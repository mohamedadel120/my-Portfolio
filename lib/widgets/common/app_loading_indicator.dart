import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// A softly pulsing, glowing cyan cursor bar, matching the terminal-style
/// cursor on the HTML splash screen (web/index.html), used as the loading
/// state for sections while their data streams in from Firestore.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.height = 28, this.color});

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? AppColors.primary;
    return Center(
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
    );
  }
}
