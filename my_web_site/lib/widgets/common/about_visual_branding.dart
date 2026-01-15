import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../constants/app_colors.dart';

class AboutVisualBranding extends StatefulWidget {
  final double scrollOffset;
  const AboutVisualBranding({super.key, required this.scrollOffset});

  @override
  State<AboutVisualBranding> createState() => _AboutVisualBrandingState();
}

class _AboutVisualBrandingState extends State<AboutVisualBranding>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glowing ring
            Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: Container(
                width: isMobile ? 220 : 350, // Reduced on mobile
                height: isMobile ? 220 : 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Middle ring with dashes
            Transform.rotate(
              angle: -_controller.value * 4 * math.pi,
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(isMobile ? 180 : 280, isMobile ? 180 : 280),
                  painter: _DashedCirclePainter(
                    color: AppColors.secondary.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            // Central branding element
            Container(
              width: isMobile ? 120 : 180,
              height: isMobile ? 120 : 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: isMobile ? 30 : 50,
                    spreadRadius: isMobile ? 5 : 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.developer_mode_rounded,
                  size: isMobile ? 50 : 80,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Floating code-like tags (Reduced on mobile)
            _buildFloatingTag(
              'Flutter',
              isMobile ? 80 : 130,
              0.5,
              _controller.value,
            ),
            _buildFloatingTag(
              'Dart',
              isMobile ? 100 : 150,
              2.5,
              _controller.value,
            ),
            if (!isMobile)
              _buildFloatingTag('Clean', 140, 4.5, _controller.value),
          ],
        );
      },
    );
  }

  Widget _buildFloatingTag(
    String text,
    double radius,
    double offsetAngle,
    double animValue,
  ) {
    final angle = offsetAngle + (animValue * 2 * math.pi);
    return Transform.translate(
      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(
          '<$text>',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 10,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const dashWidth = 10.0;
    const dashSpace = 15.0;
    var currentAngle = 0.0;

    final totalCircumference = 2 * math.pi * radius;
    final totalDashes = totalCircumference / (dashWidth + dashSpace);

    for (int i = 0; i < totalDashes.toInt(); i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        dashWidth / radius,
        false,
        paint,
      );
      currentAngle += (dashWidth + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
