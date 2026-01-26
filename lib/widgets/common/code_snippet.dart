import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class CodeSnippet extends StatelessWidget {
  final String code;
  final double scrollOffset;
  final Duration delay;

  const CodeSnippet({
    super.key,
    required this.code,
    required this.scrollOffset,
    Duration? delay,
  }) : delay = delay ?? const Duration(milliseconds: 0);

  @override
  Widget build(BuildContext context) {
    final parallaxY = scrollOffset * 0.1;
    final opacity = (1 - (scrollOffset / 1000)).clamp(0.3, 1.0);

    return Transform.translate(
      offset: Offset(0, parallaxY),
      child: Opacity(
        opacity: opacity,
        child: SizedBox(
          width: 280,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                Flexible(
                  child: Text(
                    code,
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(delay: delay, duration: 800.ms)
          .slideX(begin: -0.3, end: 0, delay: delay, duration: 800.ms),
    );
  }
}

