import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../constants/app_colors.dart';

class TechChip extends StatelessWidget {
  final String tech;
  final Duration delay;

  const TechChip({
    super.key,
    required this.tech,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        tech,
        style: GoogleFonts.poppins(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 600.ms)
        .scale(
          delay: delay,
          begin: const Offset(0.8, 0.8),
          duration: 600.ms,
        )
        .slideX(begin: -0.2, end: 0, delay: delay, duration: 600.ms);
  }
}

