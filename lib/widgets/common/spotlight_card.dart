import 'package:flutter/material.dart';

class SpotlightCard extends StatefulWidget {
  final Widget child;
  final Color spotlightColor;
  final double radius;
  final double intensity;

  const SpotlightCard({
    super.key,
    required this.child,
    this.spotlightColor = Colors.white,
    this.radius = 350,
    this.intensity = 0.15,
  });

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  Offset _mousePos = Offset.zero;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      onHover: (details) {
        setState(() {
          _mousePos = details.localPosition;
        });
      },
      child: Stack(
        children: [
          // Content
          widget.child,

          // Spotlight Overlay
          if (_isHovered)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _SpotlightPainter(
                    position: _mousePos,
                    radius: widget.radius,
                    color: widget.spotlightColor.withValues(alpha: widget.intensity),
                  ),
                ),
              ),
            ),

          // Border glow (optional, follows mouse on border)
          if (_isHovered)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _BorderSpotlightPainter(
                    position: _mousePos,
                    radius: widget.radius,
                    color: widget.spotlightColor
                        .withValues(alpha: widget.intensity * 2), // Brighter border
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset position;
  final double radius;
  final Color color;

  _SpotlightPainter({
    required this.position,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color,
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(center: position, radius: radius),
      )
      ..blendMode = BlendMode.screen; // Nice glow effect

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) {
    return position != oldDelegate.position ||
        radius != oldDelegate.radius ||
        color != oldDelegate.color;
  }
}

class _BorderSpotlightPainter extends CustomPainter {
  final Offset position;
  final double radius;
  final Color color;

  _BorderSpotlightPainter({
    required this.position,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..shader = RadialGradient(
        colors: [
          color,
          Colors.transparent,
        ],
        stops: const [0.0, 0.8],
      ).createShader(
        Rect.fromCircle(center: position, radius: radius),
      );

    // Assuming the child has some border radius.
    // We try to match standard card border radius.
    // Ideally this should be parameterized.
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(24),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_BorderSpotlightPainter oldDelegate) => true;
}
