import 'package:flutter/material.dart';

/// Widget that applies rotation based on scroll position
/// Similar to c-scroll-rotate in Locomotive Scroll
class ScrollRotateWidget extends StatelessWidget {
  final Widget child;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final double maxRotation; // Maximum rotation in turns (1.0 = 360 degrees)
  final bool repeat; // Whether to repeat animation when scrolling back up
  final double rotateStart; // When to start rotating
  final double rotateEnd; // When to finish rotating

  const ScrollRotateWidget({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    this.maxRotation = 0.1, // Small rotation by default
    this.repeat = false,
    this.rotateStart = 0.0,
    this.rotateEnd = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate relative scroll position
    final relativeScroll = scrollOffset - sectionStartOffset;
    
    double rotation = 0.0;
    
    if (relativeScroll < 0) {
      // Before section
      rotation = repeat ? 0.0 : 0.0;
    } else {
      // Calculate rotation based on scroll position
      final rotateStartOffset = rotateStart * viewportHeight;
      final rotateEndOffset = rotateEnd * viewportHeight;
      final rotateRange = rotateEndOffset - rotateStartOffset;
      
      if (relativeScroll < rotateStartOffset) {
        rotation = 0.0;
      } else if (relativeScroll > rotateEndOffset) {
        rotation = maxRotation;
      } else if (rotateRange > 0) {
        final progress = ((relativeScroll - rotateStartOffset) / rotateRange).clamp(0.0, 1.0);
        rotation = progress * maxRotation;
      } else {
        rotation = maxRotation;
      }
    }

    return Transform.rotate(
      angle: rotation * 2 * 3.14159, // Convert turns to radians
      child: child,
    );
  }
}
