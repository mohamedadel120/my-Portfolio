import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class BentoTile extends StatelessWidget {
  final Widget child;
  final String? title;
  final int flex;
  final double? height;
  final Color? glowColor;

  const BentoTile({
    super.key,
    required this.child,
    this.title,
    this.flex = 1,
    this.height,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: (glowColor ?? AppColors.primary).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: (glowColor ?? AppColors.primary)
                          .withValues(alpha: 0.6),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
