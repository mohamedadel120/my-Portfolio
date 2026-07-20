import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blur;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.opacity = 0.1,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: blur,
            spreadRadius: 0,
          ),
        ],
      ),
      // Was a BackdropFilter blur, but that filter fails to render under
      // the Skwasm/WASM web renderer (flutter/flutter#158128), leaving
      // content invisible instead of frosted-glass.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }
}

