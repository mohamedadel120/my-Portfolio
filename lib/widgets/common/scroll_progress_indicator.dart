import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ScrollProgressIndicator extends StatelessWidget {
  final double scrollOffset;
  final double maxScroll;

  const ScrollProgressIndicator({
    super.key,
    required this.scrollOffset,
    required this.maxScroll,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (scrollOffset / maxScroll).clamp(0.0, 1.0);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

