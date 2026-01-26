import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class SectionDivider extends StatelessWidget {
  final double scrollOffset;
  final Duration delay;

  const SectionDivider({
    super.key,
    required this.scrollOffset,
    Duration? delay,
  }) : delay = delay ?? const Duration(milliseconds: 0);

  @override
  Widget build(BuildContext context) {
    final parallaxY = scrollOffset * 0.1;
    
    return Transform.translate(
      offset: Offset(0, parallaxY),
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              AppColors.primary.withValues(alpha: 0.5),
              AppColors.secondary.withValues(alpha: 0.5),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: delay, duration: 1000.ms)
          .scaleX(begin: 0, end: 1, delay: delay, duration: 1000.ms),
    );
  }
}

