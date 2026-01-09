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
  double aiAngle = 0; // For racing AI

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    startX = position.x;
    // Initialize AI angle based on starting position
    aiAngle = math.Random().nextDouble() * 2 * math.pi;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Racing opponents don't need local movement
    // Movement is handled by game_world AI
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw squirrel racer in a kart (top-down view)
    final kartPaint = Paint()
      ..color = Colors.red.shade900
      ..style = PaintingStyle.fill;
    
    // Kart body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.x * 0.9,
          height: size.y * 0.9,
        ),
        const Radius.circular(8),
      ),
      kartPaint,
    );
    
    // Driver head (squirrel)
    final headPaint = Paint()
      ..color = Colors.red.shade700
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(0, 0), size.x / 3, headPaint);
    
    // Evil eyes (glowing red)
    final eyePaint = Paint()
      ..color = Colors.red.shade300
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(-size.x / 8, -3), 3, eyePaint);
    canvas.drawCircle(Offset(size.x / 8, -3), 3, eyePaint);
    
    // Racing number
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '13',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, size.y / 4),
    );
    
    // Evil sparkles
    final time = DateTime.now().millisecondsSinceEpoch / 300;
    final sparklePaint = Paint()
      ..color = Colors.red.shade200.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    if ((time % 2).floor() == 0) {
      canvas.drawCircle(Offset(size.x / 4, -size.y / 3), 2, sparklePaint);
    }
  }
}
