import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class GlitchText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double scrollOffset;

  const GlitchText({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    required this.scrollOffset,
  });

  @override
  Widget build(BuildContext context) {
    final glitchIntensity = (scrollOffset % 200 / 200).clamp(0.0, 0.1);
    
    return Stack(
      children: [
        // Red shadow
        Positioned(
          left: glitchIntensity * 3,
          child: Text(
            text,
            style: GoogleFonts.spaceMono(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.red.withValues(alpha: 0.7),
            ),
          ),
        ),
        // Blue shadow
        Positioned(
          left: -glitchIntensity * 3,
          child: Text(
            text,
            style: GoogleFonts.spaceMono(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.blue.withValues(alpha: 0.7),
            ),
          ),
        ),
        // Main text
        Text(
          text,
          style: GoogleFonts.spaceMono(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: AppColors.primary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .shimmer(
          duration: 2000.ms,
          color: AppColors.primary.withValues(alpha: 0.3),
        );
  }
}

