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
  double horizontalMovement = 0;
  bool isOnGround = false;
  
  final double moveSpeed = 200;
  final double jumpSpeed = -500;
  final double gravity = 1000;
  final double maxFallSpeed = 500;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Apply gravity
    velocity.y += gravity * dt;
    if (velocity.y > maxFallSpeed) {
      velocity.y = maxFallSpeed;
    }
    
    // Apply horizontal movement
    velocity.x = horizontalMovement * moveSpeed;
    
    // Update position
    position += velocity * dt;
    
    // Keep player within game bounds horizontally
    if (position.x < 20) {
      position.x = 20;
    }
    
    // Reset on-ground status
    isOnGround = false;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw golden retriever (Reba) as a simple shape
    final paint = Paint()
      ..color = Colors.amber.shade600
      ..style = PaintingStyle.fill;
    
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y),
        const Radius.circular(8),
      ),
      paint,
    );
    
    // Head (slightly lighter)
    final headPaint = Paint()
      ..color = Colors.amber.shade400
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(-size.x / 4, -size.y / 2.5),
      size.x / 3,
      headPaint,
    );
    
    // Eyes
    final eyePaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(-size.x / 3, -size.y / 2.8), 3, eyePaint);
    canvas.drawCircle(Offset(-size.x / 6, -size.y / 2.8), 3, eyePaint);
    
    // Nose
    canvas.drawCircle(Offset(-size.x / 4, -size.y / 2.2), 4, eyePaint);
    
    // Tail
    final tailPaint = Paint()
      ..color = Colors.amber.shade500
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.x / 2, 0), 8, tailPaint);
    
    // Sparkle effect (magical)
    if ((DateTime.now().millisecondsSinceEpoch / 500).floor() % 2 == 0) {
      final sparklePaint = Paint()
        ..color = Colors.yellow.withOpacity(0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.x / 3, -size.y / 3), 3, sparklePaint);
    }
  }

  void jump() {
    if (isOnGround && gameRef.gameState == GameState.playing) {
      velocity.y = jumpSpeed;
      isOnGround = false;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    
    if (other is PlatformComponent) {
      // Check if player is falling onto the platform
      if (velocity.y > 0) {
        final playerBottom = position.y + size.y / 2;
        final platformTop = other.position.y;
        
        if (playerBottom <= platformTop + 10) {
          position.y = platformTop - size.y / 2;
          velocity.y = 0;
          isOnGround = true;
        }
      }
    } else if (other is Enemy) {
      if (gameRef.gameState == GameState.playing) {
        gameRef.gameOver();
      }
    } else if (other is Collectible) {
      if (!other.isCollected) {
        other.collect();
        gameRef.collectTennisball();
      }
    } else if (other is Friend) {
      if (!other.isRescued) {
        other.rescue();
        gameRef.rescueFriend();
      }
    }
  }
}
