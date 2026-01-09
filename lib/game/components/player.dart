import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'enemy.dart';
import 'collectible.dart';
import 'friend.dart';
import 'platform.dart';
import '../game_world.dart';

class Player extends PositionComponent with CollisionCallbacks, HasGameRef<RebasRevengeGame> {
  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  Vector2 velocity = Vector2.zero();
  double forwardMovement = 0;
  double steeringMovement = 0;
  double animationTime = 0;
  double currentSpeed = 0;
  bool isBoosting = false;
  double boostTime = 0;
  
  final double maxSpeed = 250;
  final double acceleration = 200;
  final double deceleration = 150;
  final double turnSpeed = 3.0;
  final double boostMultiplier = 1.5;
  final double boostDuration = 2.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Update animation time
    animationTime += dt;
    
    // Handle boost timer
    if (isBoosting) {
      boostTime -= dt;
      if (boostTime <= 0) {
        isBoosting = false;
      }
    }
    
    // Calculate speed based on forward movement
    if (forwardMovement > 0) {
      currentSpeed = math.min(maxSpeed * (isBoosting ? boostMultiplier : 1.0), 
                        currentSpeed + acceleration * dt);
    } else if (forwardMovement < 0) {
      currentSpeed = math.max(-maxSpeed / 2, currentSpeed - acceleration * dt);
    } else {
      // Decelerate when not pressing forward/back
      if (currentSpeed > 0) {
        currentSpeed = math.max(0, currentSpeed - deceleration * dt);
      } else if (currentSpeed < 0) {
        currentSpeed = math.min(0, currentSpeed + deceleration * dt);
      }
    }
    
    // Apply steering (rotation)
    if (steeringMovement != 0 && currentSpeed.abs() > 10) {
      angle += steeringMovement * turnSpeed * dt;
    }
    
    // Calculate velocity based on rotation and speed
    velocity.x = math.cos(angle) * currentSpeed;
    velocity.y = math.sin(angle) * currentSpeed;
    
    // Update position
    position += velocity * dt;
    
    // Keep player within reasonable game bounds
    position.x = position.x.clamp(50, gameRef.size.x - 50);
    position.y = position.y.clamp(50, gameRef.size.y - 50);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw Reba's kart (simplified top-down view)
    
    // Kart body
    final kartPaint = Paint()
      ..color = Colors.amber.shade600
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y),
        const Radius.circular(10),
      ),
      kartPaint,
    );
    
    // Driver (Reba's head)
    final headPaint = Paint()
      ..color = Colors.amber.shade400
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(0, 0),
      size.x / 3,
      headPaint,
    );
    
    // Eyes
    final eyePaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(-5, -3), 3, eyePaint);
    canvas.drawCircle(Offset(5, -3), 3, eyePaint);
    
    // Racing stripe
    final stripePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(-3, -size.y / 2, 6, size.y),
      stripePaint,
    );
    
    // Boost effect
    if (isBoosting) {
      final boostPaint = Paint()
        ..color = Colors.yellow.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      
      for (int i = 0; i < 3; i++) {
        canvas.drawCircle(
          Offset(-size.x / 2 - 10 - i * 8, 0),
          5 - i * 1.5,
          boostPaint,
        );
      }
    }
    
    // Speed sparkle effect
    if ((animationTime * 3).floor() % 2 == 0 && currentSpeed > 100) {
      final sparklePaint = Paint()
        ..color = Colors.lightBlue.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.x / 3, size.y / 3), 3, sparklePaint);
    }
  }
  
  void activateBoost() {
    if (gameRef.gameState == GameState.playing && 
        gameRef.boostMeter >= 30 && !isBoosting) {
      isBoosting = true;
      boostTime = boostDuration;
      gameRef.boostMeter -= 30;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    
    if (other is PlatformComponent) {
      // Bounce off track boundaries
      velocity = velocity * -0.5;
      currentSpeed *= 0.5;
    } else if (other is Enemy) {
      // Collision with opponent - slow down
      currentSpeed *= 0.7;
      if (gameRef.gameState == GameState.playing) {
        // Don't game over, just slow down in racing
        // gameRef.gameOver();
      }
    } else if (other is Collectible) {
      if (!other.isCollected) {
        other.collect();
        gameRef.collectTennisball();
      }
    } else if (other is Friend) {
      if (!other.isRescued) {
        other.rescue();
        gameRef.passCheckpoint();
      }
    }
  }
}
