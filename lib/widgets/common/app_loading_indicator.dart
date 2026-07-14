import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

/// A blinking cyan cursor bar, matching the terminal-style cursor on the
/// HTML splash screen (web/index.html), used as the loading state for
/// sections while their data streams in from Firestore.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.height = 28, this.color});

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: height * 0.4,
        height: height,
        color: color ?? AppColors.primary,
      )
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(duration: 1.ms)
          .then(delay: 500.ms)
          .fadeOut(duration: 1.ms)
          .then(delay: 500.ms),
    );
  }
}
