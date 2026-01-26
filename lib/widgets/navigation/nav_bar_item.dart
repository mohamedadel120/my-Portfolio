import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBarItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const NavBarItem({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.transparent, // Hit test area
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // The main text
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()
                  ..scale(_isHovered || widget.isSelected ? 1.1 : 1.0),
                child: Text(
                  widget.title,
                  style: GoogleFonts.firaCode(
                    fontSize: 16,
                    fontWeight: _isHovered || widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: _isHovered || widget.isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                  ),
                ),
              ),

              // Animated Brackets < >
              // Left Bracket
              Positioned(
                left: -15,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isHovered || widget.isSelected ? 1.0 : 0.0,
                  child: Text(
                    '<',
                    style: GoogleFonts.firaCode(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                      .animate(target: _isHovered ? 1 : 0)
                      .moveX(begin: 10, end: 0, duration: 200.ms),
                ),
              ),

              // Right Bracket
              Positioned(
                right: -15,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isHovered || widget.isSelected ? 1.0 : 0.0,
                  child: Text(
                    '/>',
                    style: GoogleFonts.firaCode(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                      .animate(target: _isHovered ? 1 : 0)
                      .moveX(begin: -10, end: 0, duration: 200.ms),
                ),
              ),

              // Glow Effect behind (Subtle)
              if (_isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
