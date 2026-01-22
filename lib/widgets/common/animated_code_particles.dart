import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../utils/device_utils.dart';

class AnimatedCodeParticles extends StatelessWidget {
  final double scrollOffset;
  final int? particleCount;

  const AnimatedCodeParticles({
    super.key,
    required this.scrollOffset,
    this.particleCount,
  });

  @override
  Widget build(BuildContext context) {
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);
    final count = particleCount ?? (isLowSpec ? 15 : 50);

    return CustomPaint(
      painter: _CodeParticlesPainter(
        scrollOffset: scrollOffset,
        particleCount: count,
        showGlow: !isLowSpec,
      ),
      size: Size.infinite,
    );
  }
}

class _CodeParticlesPainter extends CustomPainter {
  final double scrollOffset;
  final int particleCount;
  final bool showGlow;

  _CodeParticlesPainter({
    required this.scrollOffset,
    required this.particleCount,
    required this.showGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < particleCount; i++) {
      final x =
          (random.nextDouble() * size.width + scrollOffset * 0.1) % size.width;
      final y = (random.nextDouble() * size.height + scrollOffset * 0.05) %
          size.height;
      final particleSize = 2 + random.nextDouble() * 4;
      final opacity = 0.2 + random.nextDouble() * 0.3;

      final paint = Paint()
        ..color = AppColors.primary.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      // Draw as small dot
      canvas.drawCircle(
        Offset(x, y),
        particleSize,
        paint,
      );

      // Glow effect - skip on low spec
      if (showGlow) {
        final glowPaint = Paint()
          ..color = AppColors.primary.withValues(alpha: opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(x, y), particleSize * 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CodeParticlesPainter oldDelegate) {
    // Only repaint if scroll offset changed significantly or count changed
    return (oldDelegate.scrollOffset - scrollOffset).abs() > 0.5 ||
        oldDelegate.particleCount != particleCount ||
        oldDelegate.showGlow != showGlow;
  }
}
