import 'package:flutter/material.dart';

class AnimatedParticle extends StatefulWidget {
  final int index;
  final double scrollOffset;

  const AnimatedParticle({
    super.key,
    required this.index,
    required this.scrollOffset,
  });

  @override
  State<AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3 + (widget.index % 5)),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final parallaxY = widget.scrollOffset * 0.1 * (widget.index % 3 - 1);

    return Positioned(
      left: (widget.index * 50.0) % screenWidth,
      top: ((widget.index * 80.0) % screenHeight) + parallaxY,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return RepaintBoundary(
            child: Opacity(
              opacity: 0.1 + (_animation.value * 0.3),
              child: Transform.scale(
                scale: 0.5 + (_animation.value * 0.5),
                child: Container(
                  width: 4 + (widget.index % 3) * 2,
                  height: 4 + (widget.index % 3) * 2,
                  decoration: BoxDecoration(
                    color: widget.index % 2 == 0
                        ? const Color(0xFF00D9FF)
                        : const Color(0xFF7B2CBF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (widget.index % 2 == 0
                                    ? const Color(0xFF00D9FF)
                                    : const Color(0xFF7B2CBF))
                                .withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
