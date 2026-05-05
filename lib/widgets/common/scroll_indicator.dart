import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollIndicator extends StatelessWidget {
  final double opacity;
  final bool isExpanded;

  const ScrollIndicator({
    super.key,
    this.opacity = 1.0,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();

    final Widget trackContent = SizedBox(
      width: 32,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: [
              Center(
                child: Container(
                  width: 1.5, // Standard visible width
                  height: double.infinity,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.5),
                ),
              ),
              Positioned(
                top: 0,
                child: Icon(
                  Icons.mouse_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .moveY(
                      begin: 0,
                      end: isExpanded
                          ? constraints.maxHeight - 24
                          : 90, // Dynamic distance
                      duration:
                          isExpanded ? 3000.ms : 2500.ms, // Slower animation
                      curve: Curves.easeInOutCubic,
                    )
                    .fadeIn(duration: 300.ms)
                    .then(
                        delay: isExpanded
                            ? 2000.ms
                            : 1000.ms) // Keep visible longer
                    .fadeOut(
                        duration: isExpanded
                            ? 700.ms
                            : 500.ms), // Fade out at the end
              ),
            ],
          );
        },
      ),
    );

    return Opacity(
      opacity: opacity,
      child: Column(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: Text(
              'SCROLL',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.9),
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          isExpanded
              ? Expanded(child: trackContent)
              : SizedBox(height: 120, child: trackContent),
        ],
      ),
    );
  }
}
