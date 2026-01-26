import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class ScrollToTopButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isVisible;

  const ScrollToTopButton({
    super.key,
    required this.onTap,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: !isVisible,
        child: FloatingActionButton(
          onPressed: onTap,
          backgroundColor: AppColors.primary,
          child: const Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(delay: 200.ms, duration: 400.ms)
            .then()
            .shimmer(
              duration: 2000.ms,
              color: Colors.white.withValues(alpha: 0.3),
            ),
      ),
    );
  }
}

