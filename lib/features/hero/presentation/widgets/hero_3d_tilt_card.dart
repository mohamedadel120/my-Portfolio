import 'package:flutter/material.dart';

/// A wrapper widget that applies a 3D Tilt effect based on mouse position.
/// Also adds a subtle "sheen" gradient that moves opposite to the tilt.
class Hero3DTiltCard extends StatefulWidget {
  final Widget child;
  final double
      intensity; // How much it tilts (default: 0.001 perspective, 0.5 angle)

  const Hero3DTiltCard({
    super.key,
    required this.child,
    this.intensity = 0.05,
  });

  @override
  State<Hero3DTiltCard> createState() => _Hero3DTiltCardState();
}

class _Hero3DTiltCardState extends State<Hero3DTiltCard>
    with SingleTickerProviderStateMixin {
  Offset _localPos = Offset.zero;
  Size _size = Size.zero;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {},
      onExit: (_) {
        setState(() {
          _localPos = Offset.zero; // Reset on exit
        });
      },
      onHover: (details) {
        setState(() {
          // Calculate relative position (-1.0 to 1.0)
          if (_size.width > 0 && _size.height > 0) {
            final dx = (details.localPosition.dx / _size.width) * 2 - 1;
            final dy = (details.localPosition.dy / _size.height) * 2 - 1;
            _localPos = Offset(dx, dy);
          }
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          _size = Size(constraints.maxWidth, constraints.maxHeight);
          return TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(begin: Offset.zero, end: _localPos),
            duration:
                const Duration(milliseconds: 200), // Smooth spring-like lag
            curve: Curves.easeOutCubic,
            builder: (context, offset, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateX(offset.dy * -widget.intensity) // Tilt Up/Down
                  ..rotateY(offset.dx * widget.intensity), // Tilt Left/Right
                alignment: FractionalOffset.center,
                child: Stack(
                  children: [
                    widget.child,

                    // Interactive Reflection / Sheen
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(
                                -offset.dx *
                                    2, // Move gradient opposite to mouse
                                -offset.dy * 2,
                              ),
                              end: Alignment(
                                offset.dx * 2,
                                offset.dy * 2,
                              ),
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.05 +
                                    (_glowController.value *
                                        0.02)), // Pulse sheen
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(
                                20), // Approx radius for content
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
