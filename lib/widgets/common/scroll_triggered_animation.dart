import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollTriggeredAnimation extends StatefulWidget {
  final Widget child;
  final double scrollOffset;
  final double sectionStartOffset;
  final Duration delay;
  final Duration duration;

  const ScrollTriggeredAnimation({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.sectionStartOffset,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<ScrollTriggeredAnimation> createState() =>
      _ScrollTriggeredAnimationState();
}

class _ScrollTriggeredAnimationState extends State<ScrollTriggeredAnimation> {
  bool _hasAnimated = false;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final triggerPoint = widget.sectionStartOffset - viewportHeight * 0.7;
    final isInView = widget.scrollOffset >= triggerPoint;

    // Update directly - no need for setState since value is used immediately
    if (isInView && !_hasAnimated) {
      _hasAnimated = true;
    }

    return widget.child
        .animate(target: _hasAnimated ? 1 : 0)
        .fadeIn(delay: widget.delay, duration: widget.duration)
        .slideY(
          begin: 0.3,
          end: 0,
          delay: widget.delay,
          duration: widget.duration,
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          delay: widget.delay,
          duration: widget.duration,
        );
  }
}
