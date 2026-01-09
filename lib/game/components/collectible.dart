import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Collectible extends PositionComponent with CollisionCallbacks {
  Collectible({required Vector2 position})
      : super(
          position: position,
          size: Vector2(30, 30),
          anchor: Anchor.center,
        );

  bool isCollected = false;
  double floatOffset = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!isCollected) {
      // Floating animation
      floatOffset += dt * 2;
      position.y += math.sin(floatOffset) * 0.5;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (isCollected) return;
    
    // Draw magical tennis ball
    final ballPaint = Paint()
      ..color = Colors.greenYellow
      ..style = PaintingStyle.fill;
    
    // Main ball
    canvas.drawCircle(Offset.zero, size.x / 2, ballPaint);
    
    // Tennis ball lines
    final linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path()
      ..moveTo(-size.x / 3, -size.y / 2)
      ..quadraticBezierTo(0, -size.y / 4, size.x / 3, -size.y / 2);
    canvas.drawPath(path, linePaint);
    
    final path2 = Path()
      ..moveTo(-size.x / 3, size.y / 2)
      ..quadraticBezierTo(0, size.y / 4, size.x / 3, size.y / 2);
    canvas.drawPath(path2, linePaint);
    
    // Magical glow effect
    final time = DateTime.now().millisecondsSinceEpoch / 500;
    final glowSize = size.x / 2 + math.sin(time) * 3;
    final glowPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawCircle(Offset.zero, glowSize, glowPaint);
    
    // Sparkles
    final sparklePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 4; i++) {
      final angle = (time + i * math.pi / 2) % (2 * math.pi);
      final sparkleX = math.cos(angle) * (size.x / 2 + 8);
      final sparkleY = math.sin(angle) * (size.y / 2 + 8);
      canvas.drawCircle(Offset(sparkleX, sparkleY), 2, sparklePaint);
    }
  }

  void collect() {
    isCollected = true;
    removeFromParent();
  }
}
