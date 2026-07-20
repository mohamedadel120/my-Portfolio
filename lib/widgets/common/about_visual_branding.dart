import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';

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

    return VisibilityDetector(
      key: const ValueKey('about-visual-branding'),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0;
        if (visible == _controller.isAnimating) return;
        if (visible) {
          _controller.repeat();
        } else {
          _controller.stop();
        }
      },
      child: AnimatedBuilder(
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
                      color: AppColors.primary.withValues(alpha: 0.1),
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
                      color: AppColors.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              // Central branding element
              Container(
                width: isMobile ? 140 : 200,
                height: isMobile ? 140 : 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: isMobile ? 40 : 60,
                      spreadRadius: isMobile ? 10 : 20,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo1.png',
                    width: isMobile ? 60 : 150,
                    height: isMobile ? 60 : 150,
                  ),
                ),
              ),
              // Floating code-like tags (More tags, varied speeds)
              _buildFloatingTag(
                  'Flutter', isMobile ? 90 : 150, 0.5, _controller.value,
                  speed: 1.0),
              _buildFloatingTag(
                  'Dart', isMobile ? 110 : 180, 2.5, _controller.value,
                  speed: -1.2),
              _buildFloatingTag(
                  'Firebase', isMobile ? 130 : 210, 4.5, _controller.value,
                  speed: 0.8),
              if (!isMobile) ...[
                _buildFloatingTag('Clean Arch', 240, 1.5, _controller.value,
                    speed: -0.6),
                _buildFloatingTag('GraphQL', 270, 3.5, _controller.value,
                    speed: 1.4),
                _buildFloatingTag('CI/CD', 300, 5.5, _controller.value,
                    speed: -0.9),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildFloatingTag(
    String text,
    double radius,
    double offsetAngle,
    double animValue, {
    double speed = 1.0,
  }) {
    final angle = offsetAngle + (animValue * 2 * math.pi * speed);
    return Transform.translate(
      offset: Offset(radius * math.cos(angle), radius * math.sin(angle)),
      // Was a BackdropFilter blur, but that filter fails to render under
      // the Skwasm/WASM web renderer (flutter/flutter#158128), leaving
      // these tags invisible instead of frosted-glass.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            '<$text>',
            style: GoogleFonts.spaceMono(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
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
