import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';

class TourGuideCharacter extends StatelessWidget {
  final double scrollOffset;
  final double maxScroll;
  final int currentSection;

  const TourGuideCharacter({
    super.key,
    required this.scrollOffset,
    required this.maxScroll,
    required this.currentSection,
  });

  // Section positions (approximate percentages of page)
  static const List<double> sectionPositions = [
    0.0,
    0.15,
    0.30,
    0.45,
    0.60,
    0.75,
    0.90,
  ];
  static const List<String> sectionMessages = [
    'Welcome! 👋',
    'About Me 📖',
    'My Stats 📊',
    'Experience 💼',
    'Projects 🚀',
    'Contact Me 📧',
    'Thanks for visiting! 🎉',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final progress = maxScroll > 0
        ? (scrollOffset / maxScroll).clamp(0.0, 1.0)
        : 0.0;

    // Calculate position based on scroll progress
    // Character moves vertically down the page as user scrolls
    final positionY = screenHeight * 0.2 + (progress * screenHeight * 0.5);

    // Determine which section we're in
    final sectionIndex = _getCurrentSectionIndex(progress);
    final message = sectionMessages[sectionIndex];

    // Character moves from left to right, then back to center
    // Creates a more dynamic path
    double positionX;
    if (progress < 0.5) {
      // First half: move from left to right
      positionX = 30.0 + (progress * 2 * (screenWidth - 250));
    } else {
      // Second half: stay on right side
      positionX = screenWidth - 220;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: positionX,
      top: positionY,
      child: _CharacterWidget(
        message: message,
        sectionIndex: sectionIndex,
        scrollOffset: scrollOffset,
      ),
    );
  }

  int _getCurrentSectionIndex(double progress) {
    for (int i = sectionPositions.length - 1; i >= 0; i--) {
      if (progress >= sectionPositions[i]) {
        return i;
      }
    }
    return 0;
  }
}

class _CharacterWidget extends StatefulWidget {
  final String message;
  final int sectionIndex;
  final double scrollOffset;

  const _CharacterWidget({
    required this.message,
    required this.sectionIndex,
    required this.scrollOffset,
  });

  @override
  State<_CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<_CharacterWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _waveController;
  final bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speech bubble with arrow
          Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.message,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow pointing down
                  Positioned(
                    bottom: -8,
                    left: 30,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        border: Border(
                          right: BorderSide(color: AppColors.primary, width: 2),
                          bottom: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      transform: Matrix4.rotationZ(0.785398), // 45 degrees
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.8, 0.8), duration: 500.ms)
              .shimmer(
                duration: 2000.ms,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
          const SizedBox(height: 8),
          // Cartoon Character (Stash-like)
          AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -10 * _bounceController.value),
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: 0.05 * (0.5 - _waveController.value),
                          child: _CartoonCharacter(
                            sectionIndex: widget.sectionIndex,
                          ),
                        );
                      },
                    ),
                  );
                },
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .scale(
                delay: 200.ms,
                begin: const Offset(0.5, 0.5),
                duration: 600.ms,
              ),
        ],
      ),
    );
  }
}

class _CartoonCharacter extends StatelessWidget {
  final int sectionIndex;

  const _CartoonCharacter({required this.sectionIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 110,
      child: CustomPaint(
        painter: _CoolMascotPainter(sectionIndex: sectionIndex),
        size: const Size(90, 110),
      ),
    );
  }
}

class _CoolMascotPainter extends CustomPainter {
  final int sectionIndex;

  _CoolMascotPainter({required this.sectionIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Tech aura/glow background
    final auraPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF00D9FF).withValues(alpha: 0.2),
              const Color(0xFF7B2CBF).withValues(alpha: 0.1),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: 50),
          );
    canvas.drawCircle(Offset(centerX, centerY), 50, auraPaint);

    // Main body (tech-inspired angular shape)
    final bodyPath = Path();
    bodyPath.moveTo(centerX - 20, centerY + 5);
    bodyPath.lineTo(centerX - 25, centerY + 25);
    bodyPath.lineTo(centerX - 15, centerY + 50);
    bodyPath.lineTo(centerX + 15, centerY + 50);
    bodyPath.lineTo(centerX + 25, centerY + 25);
    bodyPath.lineTo(centerX + 20, centerY + 5);
    bodyPath.close();

    final bodyGradient = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF00D9FF), Color(0xFF7B2CBF)],
      ).createShader(bodyPath.getBounds());

    canvas.drawPath(bodyPath, bodyGradient);

    // Tech lines on body
    final techLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(centerX - 10, centerY + 15),
      Offset(centerX + 10, centerY + 15),
      techLinePaint,
    );
    canvas.drawLine(
      Offset(centerX - 8, centerY + 30),
      Offset(centerX + 8, centerY + 30),
      techLinePaint,
    );

    // Head (hexagon shape for tech look)
    final headPath = Path();
    final headRadius = 32.0;
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = centerX + headRadius * math.cos(angle);
      final y = (centerY - 20) + headRadius * math.sin(angle);
      if (i == 0) {
        headPath.moveTo(x, y);
      } else {
        headPath.lineTo(x, y);
      }
    }
    headPath.close();

    final headPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF00D9FF), Color(0xFF7B2CBF)],
      ).createShader(headPath.getBounds());

    canvas.drawPath(headPath, headPaint);

    // Tech glasses (genius look)
    final glassesPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Left lens
    canvas.drawCircle(Offset(centerX - 12, centerY - 25), 10, glassesPaint);
    // Right lens
    canvas.drawCircle(Offset(centerX + 12, centerY - 25), 10, glassesPaint);
    // Bridge
    canvas.drawLine(
      Offset(centerX - 2, centerY - 25),
      Offset(centerX + 2, centerY - 25),
      glassesPaint,
    );

    // Glowing eyes behind glasses
    final eyeGlowPaint = Paint()
      ..color = const Color(0xFF00D9FF).withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(centerX - 12, centerY - 25), 6, eyeGlowPaint);
    canvas.drawCircle(Offset(centerX + 12, centerY - 25), 6, eyeGlowPaint);

    // Eyes (tech blue)
    final eyePaint = Paint()..color = const Color(0xFF00D9FF);
    canvas.drawCircle(Offset(centerX - 12, centerY - 25), 5, eyePaint);
    canvas.drawCircle(Offset(centerX + 12, centerY - 25), 5, eyePaint);

    // Confident smirk (not cute smile)
    final smirkPath = Path();
    smirkPath.moveTo(centerX - 10, centerY - 8);
    smirkPath.quadraticBezierTo(
      centerX,
      centerY - 5,
      centerX + 12,
      centerY - 10,
    );

    final smirkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(smirkPath, smirkPaint);

    // Tech arms (more angular, holding tech items)
    final armPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF00D9FF), Color(0xFF7B2CBF)],
      ).createShader(Rect.fromLTWH(0, centerY, size.width, 30))
      ..style = PaintingStyle.fill;

    // Left arm (holding tablet/code)
    final leftArmPath = Path();
    leftArmPath.moveTo(centerX - 22, centerY + 8);
    leftArmPath.lineTo(centerX - 32, centerY + 15);
    leftArmPath.lineTo(centerX - 28, centerY + 32);
    leftArmPath.lineTo(centerX - 20, centerY + 28);
    leftArmPath.close();
    canvas.drawPath(leftArmPath, armPaint);

    // Right arm (pointing/gesturing)
    final rightArmPath = Path();
    rightArmPath.moveTo(centerX + 22, centerY + 8);
    rightArmPath.lineTo(centerX + 30, centerY + 5);
    rightArmPath.lineTo(centerX + 28, centerY + 20);
    rightArmPath.lineTo(centerX + 22, centerY + 18);
    rightArmPath.close();
    canvas.drawPath(rightArmPath, armPaint);

    // Tech legs (angular, futuristic)
    final legPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF7B2CBF), Color(0xFF00D9FF)],
      ).createShader(Rect.fromLTWH(0, centerY + 40, size.width, 30));

    // Left leg
    final leftLegPath = Path();
    leftLegPath.moveTo(centerX - 10, centerY + 45);
    leftLegPath.lineTo(centerX - 14, centerY + 60);
    leftLegPath.lineTo(centerX - 8, centerY + 65);
    leftLegPath.lineTo(centerX - 4, centerY + 50);
    leftLegPath.close();
    canvas.drawPath(leftLegPath, legPaint);

    // Right leg
    final rightLegPath = Path();
    rightLegPath.moveTo(centerX + 10, centerY + 45);
    rightLegPath.lineTo(centerX + 14, centerY + 60);
    rightLegPath.lineTo(centerX + 8, centerY + 65);
    rightLegPath.lineTo(centerX + 4, centerY + 50);
    rightLegPath.close();
    canvas.drawPath(rightLegPath, legPaint);

    // Tech accessories based on section
    final techPaint = Paint()
      ..color = const Color(0xFF00D9FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    switch (sectionIndex) {
      case 0: // Welcome - code brackets
        canvas.drawLine(
          Offset(centerX + 28, centerY - 15),
          Offset(centerX + 30, centerY - 5),
          techPaint,
        );
        canvas.drawLine(
          Offset(centerX + 30, centerY - 5),
          Offset(centerX + 28, centerY + 5),
          techPaint,
        );
        break;
      case 1: // About - code symbol
        final codePath = Path();
        codePath.moveTo(centerX + 25, centerY - 18);
        codePath.lineTo(centerX + 30, centerY - 10);
        codePath.lineTo(centerX + 25, centerY - 2);
        codePath.moveTo(centerX + 32, centerY - 10);
        codePath.lineTo(centerX + 37, centerY - 10);
        canvas.drawPath(codePath, techPaint);
        break;
      case 2: // Stats - chart icon
        canvas.drawLine(
          Offset(centerX + 25, centerY - 5),
          Offset(centerX + 25, centerY - 15),
          techPaint,
        );
        canvas.drawLine(
          Offset(centerX + 25, centerY - 15),
          Offset(centerX + 35, centerY - 15),
          techPaint,
        );
        canvas.drawLine(
          Offset(centerX + 28, centerY - 10),
          Offset(centerX + 32, centerY - 5),
          techPaint,
        );
        break;
      case 3: // Experience - briefcase
        final briefcasePath = Path();
        briefcasePath.addRect(
          Rect.fromCenter(
            center: Offset(centerX + 28, centerY - 10),
            width: 12,
            height: 8,
          ),
        );
        canvas.drawPath(briefcasePath, techPaint);
        break;
      case 4: // Projects - rocket
        final rocketPath = Path();
        rocketPath.moveTo(centerX + 28, centerY - 20);
        rocketPath.lineTo(centerX + 30, centerY - 25);
        rocketPath.lineTo(centerX + 32, centerY - 20);
        rocketPath.lineTo(centerX + 30, centerY - 15);
        rocketPath.close();
        canvas.drawPath(rocketPath, Paint()..color = const Color(0xFF00D9FF));
        break;
      case 5: // Contact - mail icon
        final mailPath = Path();
        mailPath.addRect(
          Rect.fromCenter(
            center: Offset(centerX + 28, centerY - 10),
            width: 10,
            height: 8,
          ),
        );
        canvas.drawPath(mailPath, techPaint);
        break;
    }

    // Floating code particles around head (genius aura)
    final particlePaint = Paint()
      ..color = const Color(0xFF00D9FF).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX - 25, centerY - 35), 2, particlePaint);
    canvas.drawCircle(Offset(centerX + 25, centerY - 35), 2, particlePaint);
    canvas.drawCircle(Offset(centerX - 30, centerY - 20), 1.5, particlePaint);
    canvas.drawCircle(Offset(centerX + 30, centerY - 20), 1.5, particlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
