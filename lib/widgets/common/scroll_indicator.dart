import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollIndicator extends StatelessWidget {
  final double opacity;

  const ScrollIndicator({
    super.key,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();

    return Opacity(
      opacity: opacity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "SCROLL" Vertical Text
          RotatedBox(
            quarterTurns: 1,
            child: Text(
              'SCROLL',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.6),
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Vertical Line with Moving Mouse
          SizedBox(
            height: 80,
            width: 24,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // The Track (Line)
                Container(
                  width: 1,
                  height: 80,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                ),

                // The Mouse Icon moving down
                Positioned(
                  top: 0,
                  child: Icon(
                    Icons.mouse_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .moveY(
                        begin: 0,
                        end: 60,
                        duration: 1500.ms,
                        curve: Curves.easeInOutCubic,
                      )
                      .fadeIn(duration: 300.ms)
                      .then(delay: 500.ms)
                      .fadeOut(duration: 300.ms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
