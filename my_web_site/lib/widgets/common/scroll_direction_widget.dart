import 'package:flutter/material.dart';

enum ScrollDirection {
  up,
  down,
}

/// Widget that applies different animations based on scroll direction
/// Similar to Lenis scroll callback direction in Locomotive Scroll
class ScrollDirectionWidget extends StatefulWidget {
  final Widget child;
  final double scrollOffset;
  final Widget Function(BuildContext context, ScrollDirection direction) builder;

  const ScrollDirectionWidget({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.builder,
  });

  @override
  State<ScrollDirectionWidget> createState() => _ScrollDirectionWidgetState();
}

class _ScrollDirectionWidgetState extends State<ScrollDirectionWidget> {
  ScrollDirection _currentDirection = ScrollDirection.down;
  double _lastScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _lastScrollOffset = widget.scrollOffset;
  }

  @override
  void didUpdateWidget(ScrollDirectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollOffset != oldWidget.scrollOffset) {
      final direction = widget.scrollOffset > _lastScrollOffset
          ? ScrollDirection.down
          : ScrollDirection.up;
      
      if (direction != _currentDirection) {
        setState(() {
          _currentDirection = direction;
        });
      }
      
      _lastScrollOffset = widget.scrollOffset;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _currentDirection);
  }
}
