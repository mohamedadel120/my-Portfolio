import 'package:flutter/material.dart';

/// Widget that applies parallax effect based on scroll speed
/// Similar to data-scroll-speed in Locomotive Scroll
class ScrollSpeedWidget extends StatelessWidget {
  final Widget child;
  final double scrollOffset;
  final double sectionStartOffset;
  final double speed; // Speed multiplier: negative (opposite), 0 (normal), positive (faster)
  final bool repeat; // Whether to repeat animation when scrolling back up

  const ScrollSpeedWidget({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.sectionStartOffset,
    this.speed = 0.0,
    this.repeat = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate relative scroll position
    final relativeScroll = scrollOffset - sectionStartOffset;
    
    // Calculate parallax offset based on speed
    double offset = 0.0;
    if (repeat || relativeScroll >= 0) {
      // Move based on speed multiplier
      offset = relativeScroll * speed;
    }

    return Transform.translate(
      offset: Offset(0, offset),
      child: child,
    );
  }
}
