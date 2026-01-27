import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MobileMenuSection extends StatelessWidget {
  const MobileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: CustomPaint(
          painter: const _TechCornerPainter(),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // Replaced simple border with gradient border logic in CustomPainter or distinct widget if needed.
              // For now, keeping subtle background border.
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
              color: Colors.black.withValues(alpha: 0.4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64CEFF).withValues(alpha: 0.1),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.terminal,
                              color: const Color(0xFF64CEFF)
                                  .withValues(alpha: 0.6),
                              size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'lets-Code //',
                            style: GoogleFonts.firaCode(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: const Color(0xFF64FFDA)
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.white.withValues(alpha: 0.1)),
                      const SizedBox(height: 30),

                      // Menu Items
                      _GlassMenuItem(
                        title: 'About',
                        onTap: () => Navigator.pushNamed(context, '/about'),
                        delay: 0,
                      ),
                      const SizedBox(height: 10),
                      _GlassMenuItem(
                        title: 'Experience',
                        onTap: () =>
                            Navigator.pushNamed(context, '/experience'),
                        isActive: true,
                        delay: 100,
                      ),
                      const SizedBox(height: 10),
                      _GlassMenuItem(
                        title: 'Projects',
                        onTap: () => Navigator.pushNamed(context, '/projects'),
                        delay: 200,
                      ),
                      const SizedBox(height: 10),
                      _GlassMenuItem(
                        title: 'Contact',
                        onTap: () => Navigator.pushNamed(context, '/contact'),
                        delay: 300,
                      ),

                      const SizedBox(height: 40),

                      // Footer
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Text(
                          'STATUS: ONLINE',
                          style: GoogleFonts.firaCode(
                            fontSize: 10,
                            letterSpacing: 2,
                            color:
                                const Color(0xFFBD93F9).withValues(alpha: 0.7),
                          ),
                        ),
                      ).animate(delay: 500.ms).fadeIn(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
      ),
    );
  }
}

class _GlassMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;
  final int delay;

  const _GlassMenuItem({
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isActive
              ? Border.all(
                  color: const Color(0xFF64FFDA).withValues(alpha: 0.2),
                  width: 1)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            // Active Indicator Dot with Pulse
            if (isActive)
              Container(
                margin: const EdgeInsets.only(right: 15),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF64FFDA),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF64FFDA).withValues(alpha: 0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              )
                  .animate(
                      onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.2, 1.2),
                      duration: 1000.ms)
            else
              const SizedBox(width: 23), // Spacing placeholder

            // Menu Title
            Expanded(
              child: isActive
                  ? ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF64FFDA), // Cyan
                          Color(0xFFBD93F9), // Purple
                        ],
                      ).createShader(bounds),
                      child: Text(
                        title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text(
                      title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
            ),

            // Arrow Indicator
            if (isActive)
              const Icon(
                Icons.code_rounded, // Changed to tech-looking icon
                color: Color(0xFFBD93F9),
                size: 16,
              ).animate().fadeIn().slideX(begin: -0.2, end: 0)
          ],
        ),
      ),
    )
        .animate(delay: delay.ms)
        .fadeIn()
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
  }
}

class _TechCornerPainter extends CustomPainter {
  const _TechCornerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(30));

    // Gradient Border
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF64D3FF), // Cyan
          Color(0x00000000), // Transparent center
          Color(0xFFBD93F9), // Purple
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);

    // Tech Corners (Accents)
    final cornerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square
      ..color = const Color(0xFF64FFDA);

    final purpleCornerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square
      ..color = const Color(0xFFBD93F9);

    final double cornerLen = 20;

    // Top Left - Cyan
    final pathTL = Path();
    pathTL.moveTo(0, 30 + cornerLen); // Start below curve
    // Actually simpler to just draw brackets outside or on the rim.
    // Let's draw them ON the border path but thicker.
    // To match the rounded corner, we need arcTo.
    // Simplified: Just draw small lines at the straight parts near corners.

    // Top Left
    canvas.drawLine(
        const Offset(30, 0), Offset(30 + cornerLen, 0), cornerPaint);
    canvas.drawLine(
        const Offset(0, 30), Offset(0, 30 + cornerLen), cornerPaint);

    // Bottom Right - Purple
    canvas.drawLine(Offset(size.width - 30, size.height),
        Offset(size.width - 30 - cornerLen, size.height), purpleCornerPaint);
    canvas.drawLine(Offset(size.width, size.height - 30),
        Offset(size.width, size.height - 30 - cornerLen), purpleCornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
