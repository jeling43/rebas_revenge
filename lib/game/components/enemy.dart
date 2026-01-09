import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Enemy extends PositionComponent with CollisionCallbacks {
  Enemy({required Vector2 position})
      : super(
          position: position,
          size: Vector2(35, 35),
          anchor: Anchor.center,
        );

  double direction = 1;
  double moveSpeed = 50;
  final double moveRange = 100;
  late double startX;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    startX = position.x;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move back and forth
    position.x += direction * moveSpeed * dt;
    
    // Change direction at boundaries
    if (position.x > startX + moveRange || position.x < startX - moveRange) {
      direction *= -1;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw evil magical squirrel
    final bodyPaint = Paint()
      ..color = Colors.red.shade900
      ..style = PaintingStyle.fill;
    
    // Body
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, 0),
        width: size.x * 0.7,
        height: size.y * 0.8,
      ),
      bodyPaint,
    );
    
    // Head
    canvas.drawCircle(Offset(0, -size.y / 3), size.x / 3, bodyPaint);
    
    // Evil eyes (glowing red)
    final eyePaint = Paint()
      ..color = Colors.red.shade300
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(-size.x / 6, -size.y / 3), 4, eyePaint);
    canvas.drawCircle(Offset(size.x / 6, -size.y / 3), 4, eyePaint);
    
    // Evil glow effect
    final glowPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(Offset(0, 0), size.x / 2, glowPaint);
    
    // Bushy tail
    final tailPaint = Paint()
      ..color = Colors.red.shade800
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.x / 2.5, size.y / 4), 12, tailPaint);
    
    // Evil sparkles
    final time = DateTime.now().millisecondsSinceEpoch / 300;
    final sparklePaint = Paint()
      ..color = Colors.red.shade200.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    if ((time % 2).floor() == 0) {
      canvas.drawCircle(Offset(size.x / 3, -size.y / 2), 2, sparklePaint);
      canvas.drawCircle(Offset(-size.x / 3, -size.y / 2), 2, sparklePaint);
    }
  }
}
