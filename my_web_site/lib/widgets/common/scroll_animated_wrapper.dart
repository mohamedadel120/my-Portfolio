import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollAnimatedWrapper extends StatelessWidget {
  final Widget child;
  final double scrollOffset;
  final double triggerPoint;
  final Duration delay;
  final bool isVisible;

  const ScrollAnimatedWrapper({
    super.key,
    required this.child,
    required this.scrollOffset,
    this.triggerPoint = 0,
    Duration? delay,
    this.isVisible = true,
  }) : delay = delay ?? const Duration(milliseconds: 0);

  @override
  Widget build(BuildContext context) {
    final hasScrolledPast = scrollOffset > triggerPoint;
    final parallaxY = (scrollOffset - triggerPoint) * 0.2;
    final opacity = hasScrolledPast
        ? 1.0
        : ((scrollOffset - triggerPoint + 400) / 400).clamp(0.0, 1.0);
    final scale = hasScrolledPast
        ? 1.0
        : 0.8 + ((scrollOffset - triggerPoint + 400) / 400).clamp(0.0, 0.2);

    return Transform.translate(
      offset: Offset(0, parallaxY),
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: child,
        ),
      ),
    )
        .animate(autoPlay: isVisible && hasScrolledPast)
        .fadeIn(delay: delay, duration: 800.ms)
        .slideY(begin: 0.3, end: 0, delay: delay, duration: 800.ms);
  }
}

