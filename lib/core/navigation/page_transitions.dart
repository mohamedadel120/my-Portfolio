import 'package:flutter/material.dart';

// Proper implementation of a "Cover and Reveal" transition
class CodingTransition extends PageRouteBuilder {
  final Widget page;

  CodingTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1500),
          reverseTransitionDuration: const Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _CodingTransitionRenderer(
              animation: animation,
              child: child,
            );
          },
        );
}

class _CodingTransitionRenderer extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _CodingTransitionRenderer({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final val = animation.value;
        final size = MediaQuery.of(context).size;

        // 0.0 -> 0.4: Green block slides in from bottom to cover screen.
        // 0.4 -> 0.6: Pause (Loading...)
        // 0.6 -> 1.0: Green block slides up to reveal NEW page.

        double slideInY = 1.0 - (val * 2.5); // 1.0 down to 0.0 (at val 0.4)
        if (slideInY < 0) slideInY = 0;

        double slideOutY = 0.0;
        if (val > 0.6) {
          slideOutY = -((val - 0.6) * 2.5); // 0.0 up to -1.0
        }

        final overlayY = val < 0.5 ? slideInY : slideOutY;

        // New Page Opacity is 0 until val > 0.5 to prevent flashing
        final double childOpacity = val >= 0.5 ? 1.0 : 0.0;

        return Stack(
          children: [
            Opacity(opacity: childOpacity, child: child!),
            Transform.translate(
              offset: Offset(0, overlayY * size.height),
              child: Container(
                width: size.width,
                height: size.height,
                color: const Color(0xFF0A0E14), // Dark coding bg
                child: Stack(
                  children: [
                    // Grid lines
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _GridPainter(
                          color: Colors.greenAccent.withOpacity(0.1),
                          spacing: 40,
                        ),
                      ),
                    ),
                    // Loading Text
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.terminal_rounded,
                              size: 64, color: Colors.greenAccent[400]),
                          const SizedBox(height: 16),
                          Text(
                            _getStatusText(val),
                            style: TextStyle(
                              color: Colors.greenAccent[400],
                              fontFamily: 'Courier New',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (val > 0.2 && val < 0.8)
                            SizedBox(
                              width: 150,
                              child: LinearProgressIndicator(
                                value: (val - 0.2) / 0.6,
                                color: Colors.greenAccent[400],
                                backgroundColor:
                                    Colors.greenAccent.withOpacity(0.2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }

  String _getStatusText(double val) {
    if (val < 0.3) return 'INITIALIZING...';
    if (val < 0.5) return 'COMPILING ASSETS...';
    if (val < 0.7) return 'DEPLOYING...';
    return 'READY';
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  _GridPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
