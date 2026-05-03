import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const CustomShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1500),
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        )
        .fadeIn(duration: 300.ms);
  }
}

class SectionShimmerGrid extends StatelessWidget {
  final int itemCount;
  final double height;
  final int crossAxisCount;
  final double spacing;

  const SectionShimmerGrid({
    super.key,
    this.itemCount = 6,
    this.height = 200,
    this.crossAxisCount = 3,
    this.spacing = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final cardWidth = (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.start,
          children: List.generate(
            itemCount,
            (index) => CustomShimmer(
              width: cardWidth,
              height: height,
              borderRadius: 16,
            ),
          ),
        );
      },
    );
  }
}
