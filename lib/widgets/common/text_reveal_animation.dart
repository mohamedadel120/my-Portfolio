import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';

class TextRevealAnimation extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Duration delay;
  final bool isVisible;

  const TextRevealAnimation({
    super.key,
    required this.text,
    this.style,
    Duration? delay,
    this.isVisible = true,
  }) : delay = delay ?? const Duration(milliseconds: 0);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          GoogleFonts.poppins(
            fontSize: 24,
            color: AppColors.textPrimary,
          ),
    )
        .animate(autoPlay: isVisible)
        .fadeIn(delay: delay, duration: 800.ms)
        .then()
        .shimmer(
          duration: 2000.ms,
          color: AppColors.primary.withValues(alpha: 0.3),
        );
  }
}

