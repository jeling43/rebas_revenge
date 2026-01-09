import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PlatformComponent extends PositionComponent with CollisionCallbacks {
  PlatformComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  // Cache random instance for sparkle positions
  late final Random _random;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    _random = Random(position.x.toInt() + position.y.toInt());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw magical platform with gradient
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.purple.shade400,
        Colors.purple.shade700,
      ],
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    
    // Add magical sparkle border
    final borderPaint = Paint()
      ..color = Colors.pink.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      borderPaint,
    );
    
    // Add some sparkle effects
    final sparklePaint = Paint()
      ..color = Colors.yellow.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 3; i++) {
      final x = _random.nextDouble() * size.x;
      final y = _random.nextDouble() * size.y;
      final phase = (DateTime.now().millisecondsSinceEpoch / 1000 + i) % 2;
      if (phase < 1) {
        canvas.drawCircle(Offset(x, y), 2, sparklePaint);
      }
    }
  }
}
