import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Friend extends PositionComponent with CollisionCallbacks {
  Friend({
    required Vector2 position,
    required this.name,
  }) : super(
          position: position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  final String name;
  bool isRescued = false;
  double bounceOffset = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!isRescued) {
      // Bounce animation to show they're trapped
      bounceOffset += dt * 3;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (isRescued) return;
    
    // Draw cage/prison effect
    final cagePaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    for (int i = 0; i < 5; i++) {
      final x = -size.x / 2 + (i * size.x / 4);
      canvas.drawLine(
        Offset(x, -size.y / 2 - 10),
        Offset(x, size.y / 2 + 10),
        cagePaint,
      );
    }
    
    // Top and bottom bars
    canvas.drawLine(
      Offset(-size.x / 2, -size.y / 2 - 10),
      Offset(size.x / 2, -size.y / 2 - 10),
      cagePaint,
    );
    canvas.drawLine(
      Offset(-size.x / 2, size.y / 2 + 10),
      Offset(size.x / 2, size.y / 2 + 10),
      cagePaint,
    );
    
    // Draw friend (golden retriever) - similar to player but slightly different
    final dogPaint = Paint()
      ..color = Colors.amber.shade500
      ..style = PaintingStyle.fill;
    
    final yOffset = math.sin(bounceOffset) * 3;
    
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-size.x / 2 + 5, -size.y / 2 + 5 + yOffset, size.x - 10, size.y - 10),
        const Radius.circular(8),
      ),
      dogPaint,
    );
    
    // Head
    final headPaint = Paint()
      ..color = Colors.amber.shade400
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(-size.x / 4, -size.y / 2.5 + yOffset),
      size.x / 3.5,
      headPaint,
    );
    
    // Eyes (sad/worried expression)
    final eyePaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(-size.x / 3, -size.y / 2.8 + yOffset), 3, eyePaint);
    canvas.drawCircle(Offset(-size.x / 6, -size.y / 2.8 + yOffset), 3, eyePaint);
    
    // Nose
    canvas.drawCircle(Offset(-size.x / 4, -size.y / 2.2 + yOffset), 4, eyePaint);
    
    // Name label
    final textPainter = TextPainter(
      text: TextSpan(
        text: name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Colors.black,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, size.y / 2 + 15),
    );
    
    // Help indicator
    final helpPainter = TextPainter(
      text: TextSpan(
        text: '❗',
        style: TextStyle(
          fontSize: 20,
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: Colors.red,
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    helpPainter.layout();
    helpPainter.paint(
      canvas,
      Offset(-helpPainter.width / 2, -size.y / 2 - 25 + math.sin(bounceOffset * 2) * 3),
    );
  }

  void rescue() {
    isRescued = true;
    removeFromParent();
  }
}
