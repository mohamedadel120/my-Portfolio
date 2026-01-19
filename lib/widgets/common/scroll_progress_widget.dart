import 'package:flutter/material.dart';

/// Widget that provides scroll progress for custom animations
/// Similar to data-scroll-css-progress in Locomotive Scroll
class ScrollProgressWidget extends StatelessWidget {
  final Widget child;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final double progressStart; // When progress starts (0.0)
  final double progressEnd; // When progress ends (1.0)
  final Widget Function(BuildContext context, double progress) builder;

  const ScrollProgressWidget({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    this.progressStart = 0.0,
    this.progressEnd = 1.0,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate relative scroll position
    final relativeScroll = scrollOffset - sectionStartOffset;
    
    // Calculate progress (0.0 to 1.0)
    final startOffset = progressStart * viewportHeight;
    final endOffset = progressEnd * viewportHeight;
    final range = endOffset - startOffset;
    
    double progress = 0.0;
    if (relativeScroll < startOffset) {
      progress = 0.0;
    } else if (relativeScroll > endOffset) {
      progress = 1.0;
    } else if (range > 0) {
      progress = ((relativeScroll - startOffset) / range).clamp(0.0, 1.0);
    } else {
      progress = 1.0;
    }

    return builder(context, progress);
  }
}
