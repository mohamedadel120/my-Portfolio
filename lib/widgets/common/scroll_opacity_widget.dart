import 'package:flutter/material.dart';

/// Widget that applies opacity fade in/out based on scroll position
/// Similar to c-scroll-opacity in Locomotive Scroll
class ScrollOpacityWidget extends StatelessWidget {
  final Widget child;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final bool repeat; // Whether to repeat animation when scrolling back up
  final double fadeStart; // When to start fading (in viewport heights)
  final double fadeEnd; // When to finish fading (in viewport heights)

  const ScrollOpacityWidget({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    this.repeat = false,
    this.fadeStart = 0.0, // Start fading when element enters viewport
    this.fadeEnd = 0.5, // Finish fading at 0.5 viewport heights
  });

  @override
  Widget build(BuildContext context) {
    // Calculate relative scroll position
    final relativeScroll = scrollOffset - sectionStartOffset;
    
    double opacity = 1.0;
    
    if (relativeScroll < 0) {
      // Before section
      opacity = repeat ? 0.0 : 1.0;
    } else {
      // Calculate fade based on scroll position
      final fadeStartOffset = fadeStart * viewportHeight;
      final fadeEndOffset = fadeEnd * viewportHeight;
      final fadeRange = fadeEndOffset - fadeStartOffset;
      
      if (relativeScroll < fadeStartOffset) {
        opacity = 0.0;
      } else if (relativeScroll > fadeEndOffset) {
        opacity = 1.0;
      } else if (fadeRange > 0) {
        opacity = ((relativeScroll - fadeStartOffset) / fadeRange).clamp(0.0, 1.0);
      } else {
        opacity = 1.0;
      }
    }

    return Opacity(
      opacity: opacity,
      child: child,
    );
  }
}
