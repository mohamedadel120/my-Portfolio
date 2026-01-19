import 'package:flutter/material.dart';

class ParallaxImage extends StatelessWidget {
  final Widget child;
  final double scrollOffset;
  final double speed;

  const ParallaxImage({
    super.key,
    required this.child,
    required this.scrollOffset,
    this.speed = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, scrollOffset * speed),
      child: child,
    );
  }
}

