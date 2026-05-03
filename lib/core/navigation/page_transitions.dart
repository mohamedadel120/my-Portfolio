import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A premium "Cyber-Glass" transition effect.
///
/// Features:
/// - Smooth spring-like motion.
/// - Glassmorphism card with blur and subtle border.
/// - Generative "Constellation" particle field background.
/// - Film grain noise texture.
class CodingTransition extends PageRouteBuilder {
  final Widget page;

  CodingTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration:
              const Duration(milliseconds: 2500), // Slower, heavier feel
          reverseTransitionDuration: const Duration(milliseconds: 1200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _GlassTransitionRenderer(
              animation: animation,
              child: child,
            );
          },
        );
}

class _GlassTransitionRenderer extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _GlassTransitionRenderer({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final val = animation.value;

        // ANIMATION PHASES
        // 0.0 -> 0.35: Glass Card slides up & expands (Springy).
        // 0.35 -> 0.75: Processing (Particles move, loader fills).
        // 0.75 -> 1.0: Reveal new page (Card fades/scales out).

        final double childOpacity = val >= 0.4 ? 1.0 : 0.0;

        // Physics-based curves (approximate spring)
        final curveIn = Curves.fastLinearToSlowEaseIn;
        final curveOut = Curves.easeInOutCubicEmphasized;

        // Card Entry
        double cardScale = 0.8;
        double cardOpacity = 0.0;
        double cardY = 0.0;

        if (val < 0.4) {
          final t = (val / 0.4).clamp(0.0, 1.0);
          cardScale = 0.8 + (0.2 * curveIn.transform(t));
          cardOpacity = curveIn.transform(t);
          cardY = (1.0 - curveIn.transform(t)) * 100;
        } else if (val > 0.7) {
          final t = ((val - 0.7) / 0.3).clamp(0.0, 1.0);
          // Exit: Scale up slightly and fade out
          cardScale = 1.0 + (0.1 * curveOut.transform(t));
          cardOpacity = 1.0 - curveOut.transform(t);
        } else {
          cardScale = 1.0;
          cardOpacity = 1.0;
        }

        return Stack(
          children: [
            // New Page (Background) - revealed late
            Positioned.fill(
              child: Opacity(
                opacity: childOpacity,
                child: child!,
              ),
            ),

            // Transition Overlay
            if (val < 0.99)
              Positioned.fill(
                child: Opacity(
                  opacity: cardOpacity,
                  child: Stack(
                    children: [
                      // 1. App Background + Noise
                      Positioned.fill(
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      const Positioned.fill(child: _NoiseTexture()),

                      // 2. Particle Field
                      Positioned.fill(
                          child: _ParticleField(animationValue: val)),

                      // 3. Glass Card (Center)
                      Center(
                        child: Transform.translate(
                          offset: Offset(0, cardY),
                          child: Transform.scale(
                            scale: cardScale,
                            child: const _GlassCard(),
                          ),
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
}

class _GlassCard extends StatelessWidget {
  const _GlassCard();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 380,
          height: 220,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: primary.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.05),
                blurRadius: 30,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Inner Glow
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        primary.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                      radius: 0.8,
                      center: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Content
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BreathingText(),
                    SizedBox(height: 32),
                    _QuantumLoader(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreathingText extends StatefulWidget {
  const _BreathingText();

  @override
  State<_BreathingText> createState() => _BreathingTextState();
}

class _BreathingTextState extends State<_BreathingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          "SYSTEM OPTIMIZING",
          style: TextStyle(
            fontFamily: 'Inter', // Ensure you have this or generic sans
            fontFamilyFallback: const ['Roboto', 'sans-serif'],
            color: primary.withValues(alpha: 0.8 + (_controller.value * 0.2)),
            fontSize: 14,
            letterSpacing:
                4.0 + (_controller.value * 2.0), // Breathing tracking
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}

class _QuantumLoader extends StatefulWidget {
  const _QuantumLoader();

  @override
  State<_QuantumLoader> createState() => _QuantumLoaderState();
}

class _QuantumLoaderState extends State<_QuantumLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _LoaderPainter(
                progress: _controller.value,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LoaderPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color,
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw a moving line segment
    final width = size.width;
    final start = (progress * 1.5 - 0.25) * width; // Moves from -25% to 125%

    // Simple glowing line
    final p1 = Offset(start - (width * 0.25), size.height / 2);
    final p2 = Offset(start + (width * 0.25), size.height / 2);

    // Paint with blend mode for glow effect
    paint.strokeWidth = 2;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant _LoaderPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _ParticleField extends StatefulWidget {
  final double animationValue;
  const _ParticleField({required this.animationValue});

  @override
  State<_ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<_ParticleField> {
  final List<_Particle> _particles = [];
  final int _count = 30;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    // Initialize particles randomly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < _count; i++) {
        _particles.add(_Particle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          vx: (_random.nextDouble() - 0.5) * 0.5, // Slow velocity
          vy: (_random.nextDouble() - 0.5) * 0.5,
          size: _random.nextDouble() * 3 + 1,
        ));
      }
      setState(() {}); // Trigger rebuild to paint
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlePainter(
        particles: _particles,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        animValue: widget.animationValue,
      ),
    );
  }
}

class _Particle {
  double x, y, vx, vy, size;
  _Particle(
      {required this.x,
      required this.y,
      required this.vx,
      required this.vy,
      required this.size});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;
  final double animValue;

  _ParticlePainter(
      {required this.particles, required this.color, required this.animValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    // Simulate slight movement based on time/animation to make them "float"
    // In a real game loop we'd update state, but here we cheat with animValue + noise
    const movementScale = 20.0;

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];

      // Calculate dynamic position
      final dx = p.x + (p.vx * movementScale * animValue);
      final dy = p.y + (p.vy * movementScale * animValue);

      // Draw Dot
      canvas.drawCircle(
          Offset(dx, dy), p.size * (0.5 + animValue * 0.5), paint);

      // Draw Connections
      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final dx2 = p2.x + (p2.vx * movementScale * animValue);
        final dy2 = p2.y + (p2.vy * movementScale * animValue);

        final distDx = dx - dx2;
        final distDy = dy - dy2;
        final dist = math.sqrt(distDx * distDx + distDy * distDy);

        if (dist < 150) {
          // Connection threshold
          canvas.drawLine(Offset(dx, dy), Offset(dx2, dy2), linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      true; // Animate always
}

class _NoiseTexture extends StatelessWidget {
  const _NoiseTexture();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.05, // Subtle
      child: CustomPaint(
        painter: _NoisePainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final math.Random _random = math.Random();

  @override
  void paint(Canvas canvas, Size size) {
    // Drawing thousands of points is expensive, so we draw a smaller pattern and tile it?
    // Or just draw fewer larger points for simplicity in Flutter Web.
    // For performance, we'll draw a sparse noise.

    final paint = Paint()..color = Colors.white;
    final points = <Offset>[];

    // Performance optimization: Generate fixed noise
    // In a real app, use an image asset for noise.
    for (int i = 0; i < 500; i++) {
      points.add(Offset(_random.nextDouble() * size.width,
          _random.nextDouble() * size.height));
    }

    canvas.drawPoints(ui.PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
