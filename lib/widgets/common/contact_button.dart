import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ContactButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Duration delay;
  final bool isVisible;

  const ContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.delay,
    required this.isVisible,
  });

  @override
  State<ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<ContactButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _isHovered ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: widget.color.withValues(alpha: _isHovered ? 0.5 : 0.3),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.15),
                      blurRadius: 15,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          transform: Matrix4.identity()
            ..multiply(Matrix4.diagonal3Values(_isHovered ? 1.15 : 1.0, _isHovered ? 1.15 : 1.0, 1.0))
            ..multiply(Matrix4.translationValues(0.0, _isHovered ? -3.0 : 0.0, 0.0)), // Lift effect on hover
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: _isHovered ? 0.25 : 0.0,
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: _isHovered ? 26 : 24,
                ),
              ),
              const SizedBox(width: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.poppins(
                  fontSize: _isHovered ? 19 : 18,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                  letterSpacing: _isHovered ? 0.5 : 0.0,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      )
          .animate(autoPlay: widget.isVisible)
          .fadeIn(delay: widget.delay, duration: 500.ms)
          .scale(
            delay: widget.delay,
            begin: const Offset(0.8, 0.8),
            duration: 400.ms,
          )
          .slideY(begin: 0.3, end: 0, delay: widget.delay, duration: 500.ms),
    );
  }
}

