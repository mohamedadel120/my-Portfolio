import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AnimatedCodeParticles extends StatelessWidget {
  final double scrollOffset;
  final int particleCount;

  const AnimatedCodeParticles({
    super.key,
    required this.scrollOffset,
    this.particleCount = 50,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CodeParticlesPainter(
        scrollOffset: scrollOffset,
        particleCount: particleCount,
      ),
      size: Size.infinite,
    );
  }
}

class _CodeParticlesPainter extends CustomPainter {
  final double scrollOffset;
  final int particleCount;

  _CodeParticlesPainter({
    required this.scrollOffset,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent pattern
    
    for (int i = 0; i < particleCount; i++) {
      final x = (random.nextDouble() * size.width + scrollOffset * 0.1) % size.width;
      final y = (random.nextDouble() * size.height + scrollOffset * 0.05) % size.height;
      final particleSize = 2 + random.nextDouble() * 4;
      final opacity = 0.2 + random.nextDouble() * 0.3;
      
      final paint = Paint()
        ..color = AppColors.primary.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      
      // Draw as small dot with glow
      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );
      
      // Glow effect
      final glowPaint = Paint()
        ..color = AppColors.primary.withValues(alpha: opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(x, y), particleSize * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

