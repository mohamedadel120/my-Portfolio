import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// A softly pulsing, glowing cyan cursor bar, matching the terminal-style
/// cursor on the HTML splash screen (web/index.html), used as the loading
/// state for sections while their data streams in from Firestore.
///
/// Layout: claims one viewport of height (clamped by bounded parents, e.g.
/// the video player's box or the contact form's 20x20 slot) and the full
/// available width, and centers the bar inside that area. This keeps the
/// bar's position independent of whichever parent the loading state lands
/// in — earlier shrink-wrap approaches left placement up to the parent,
/// which put the bar at the screen edge inside the home page's Column.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.height = 28, this.color});

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? AppColors.primary;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height,
      child: Center(
        child: Container(
          width: height * 0.4,
          height: height,
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: indicatorColor.withValues(alpha: 0.6),
                blurRadius: 12,
              ),
            ],
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeOut(duration: 600.ms, curve: Curves.easeInOut, begin: 1),
      ),
    );
  }
}
