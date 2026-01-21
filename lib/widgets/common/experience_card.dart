import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../constants/app_colors.dart';
import '../../../models/experience.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;
  final Duration delay;
  final bool isVisible;

  const ExperienceCard({
    super.key,
    required this.experience,
    required this.delay,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    
    // Scroll-based parallax
    final parallaxX = (delay.inMilliseconds % 200) * 0.01;
    
    return Transform.translate(
      offset: Offset(parallaxX, 0),
      child: Container(
        margin: EdgeInsets.only(bottom: isMobile ? 20 : 30),
        padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 24 : 30)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.background,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.company,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 20 : (isTablet ? 22 : 24),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      experience.role,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : (isTablet ? 17 : 18),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  experience.period,
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...experience.achievements.map(
            (achievement) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, right: 12),
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      achievement,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 14 : 16,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    )
        .animate(autoPlay: isVisible)
        .fadeIn(delay: delay, duration: 800.ms)
        .slideX(begin: -0.3, end: 0, delay: delay, duration: 800.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          delay: delay,
          duration: 800.ms,
        )
        .then()
        .shimmer(
          duration: 2000.ms,
          color: const Color(0xFF00D9FF).withValues(alpha: 0.1),
        );
  }
}

