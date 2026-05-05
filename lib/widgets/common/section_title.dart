import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isVisible;

  const SectionTitle({super.key, required this.title, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Enhanced typography inspired by CHD Art Maker - larger, bolder
    final fontSize = isMobile ? 36.0 : (isTablet ? 48.0 : 64.0);

    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.ibmPlexMono(
            fontSize: fontSize,
            fontWeight: FontWeight.w800, // Extra bold
            color: AppColors.textPrimary,
            letterSpacing: -1.0, // Tighter letter spacing for modern look
            height: 1.1, // Tighter line height
          ),
        )
            .animate(autoPlay: isVisible)
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.2, end: 0, duration: 600.ms)
            .scale(begin: const Offset(0.9, 0.9), duration: 600.ms),
        SizedBox(height: isMobile ? 16 : 24),
        Container(
          width: isMobile ? 60 : 100,
          height: isMobile ? 3 : 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        )
            .animate(autoPlay: isVisible)
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .scaleX(begin: 0, end: 1, delay: 200.ms, duration: 600.ms),
      ],
    );
  }
}
