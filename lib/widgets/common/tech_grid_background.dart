import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../utils/device_utils.dart';

class TechGridBackground extends StatelessWidget {
  final double scrollOffset;
  final double opacity;

  const TechGridBackground({
    super.key,
    required this.scrollOffset,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);
    final isMobile = DeviceUtils.isMobile(screenWidth);

    final gridSpacing = isLowSpec ? 100.0 : (isMobile ? 60.0 : 50.0);
    final parallaxY = scrollOffset * 0.2;

    return Transform.translate(
      offset: Offset(0, parallaxY % gridSpacing),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: GridPainter(
            color: AppColors.primary.withValues(alpha: opacity),
            gridSpacing: gridSpacing,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  final double gridSpacing;

  GridPainter({required this.color, required this.gridSpacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.gridSpacing != gridSpacing;
}
