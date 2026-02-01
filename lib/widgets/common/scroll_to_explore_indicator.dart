import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// Scroll to explore indicator - inspired by Lightship RV
/// Shows animated text prompting user to scroll
class ScrollToExploreIndicator extends StatelessWidget {
  final double scrollOffset;
  final VoidCallback? onTap;

  const ScrollToExploreIndicator({
    super.key,
    required this.scrollOffset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final viewportHeight = MediaQuery.of(context).size.height;

    // Hide indicator after scrolling past hero section
    final shouldShow = scrollOffset < viewportHeight * 0.8;
    final opacity = (1 - (scrollOffset / (viewportHeight * 0.8))).clamp(
      0.0,
      1.0,
    );

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: opacity,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scroll to explore',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 12 : 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 1000.ms)
                .then()
                .fadeOut(duration: 1000.ms),
            const SizedBox(height: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: isMobile ? 24 : 28,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 800.ms)
                .then()
                .moveY(
                  begin: 0,
                  end: 8,
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .fadeOut(duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
