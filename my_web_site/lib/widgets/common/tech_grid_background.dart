import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

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
    final parallaxY = scrollOffset * 0.2;
    
    return Transform.translate(
      offset: Offset(0, parallaxY % 50),
      child: CustomPaint(
        painter: GridPainter(
          color: AppColors.primary.withOpacity(opacity),
        ),
        child: Container(),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;

  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

