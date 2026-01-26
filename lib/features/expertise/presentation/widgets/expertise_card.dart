import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/common/gsap_stagger_animation.dart';
import '../../domain/entities/expertise_entity.dart';
import '../../../../utils/device_utils.dart';

class ExpertiseCard extends StatefulWidget {
  final Expertise expertise;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final int index;
  final bool isMobile;
  final bool isTablet;

  const ExpertiseCard({
    super.key,
    required this.expertise,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.index,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<ExpertiseCard> createState() => _ExpertiseCardState();
}

class _ExpertiseCardState extends State<ExpertiseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // GSAP handles all scroll animations

    // Determine animation direction based on index
    final screenWidth = MediaQuery.of(context).size.width;
    final isXS = DeviceUtils.isExtraSmall(screenWidth);
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);

    // Determine animation direction based on index
    final isLeftCard = widget.index % 2 == 0;
    final animationDirection = isLeftCard
        ? -100
        : 100; // Left cards slide from left, right cards from right

    final cardColor =
        widget.expertise.color ?? Theme.of(context).colorScheme.primary;

    return GSAPEnhancedAnimation(
      elementId: 'expertise-card-${widget.index}',
      scrollOffset: widget.scrollOffset,
      sectionStartOffset: widget.sectionStartOffset +
          (widget.index * widget.viewportHeight * 0.08), // Closer spacing
      viewportHeight: widget.viewportHeight,
      ease: 'power3.out', // Tip 1: Better easing from the article
      useRandom: false, // Disable random for consistent animations
      animationConfig: {
        'opacity': const {'from': 0, 'to': 1},
        'x': {
          'from': animationDirection,
          'to': 0,
        }, // Tip 3: Alternating directions using wrap
        'y': const {'from': 50, 'to': 0}, // Slide up from below
        'scale': const {'from': 0.9, 'to': 1.0}, // Slightly less dramatic scale
        'rotation': {
          'from': (isLowSpec || isXS)
              ? 0
              : (widget.index % 2 == 0 ? -1.5 : 1.5), // Subtle rotation
          'to': 0,
        },
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(
            isXS ? 16 : (widget.isMobile ? 20 : (widget.isTablet ? 24 : 28)),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: cardColor.withValues(
                alpha: _isHovered ? 0.4 : 0.2,
              ),
              width: _isHovered ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.08),
                blurRadius: _isHovered ? 20 : 12,
                spreadRadius: _isHovered ? 2 : 0,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.02 : 1.0)
            ..translate(0.0, _isHovered ? -4.0 : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clean title section with icon
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isXS
                      ? 14
                      : (widget.isMobile ? 20 : (widget.isTablet ? 24 : 28)),
                  vertical: isXS
                      ? 14
                      : (widget.isMobile ? 20 : (widget.isTablet ? 24 : 28)),
                ),
                decoration: BoxDecoration(
                  color: cardColor.withValues(
                    alpha: _isHovered ? 0.1 : 0.05,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cardColor.withValues(
                      alpha: _isHovered ? 0.3 : 0.15,
                    ),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Clean icon container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(
                          alpha: _isHovered ? 0.15 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      transform: Matrix4.identity()
                        ..scale(_isHovered ? 1.08 : 1.0),
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        turns: _isHovered ? 0.08 : 0.0,
                        child: Icon(
                          widget.expertise.icon,
                          color: cardColor,
                          size: isXS
                              ? 24
                              : (widget.isMobile
                                  ? 32
                                  : (widget.isTablet ? 36 : 40)),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.isMobile ? 16 : 20),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        style: GoogleFonts.poppins(
                          fontSize: _isHovered
                              ? (isXS
                                  ? 18
                                  : (widget.isMobile
                                      ? 21
                                      : (widget.isTablet ? 23 : 25)))
                              : (isXS
                                  ? 16
                                  : (widget.isMobile
                                      ? 20
                                      : (widget.isTablet ? 22 : 24))),
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: _isHovered ? 0.6 : 0.3,
                        ),
                        child: Text(widget.expertise.title),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Clean description section with subtle accent
              Container(
                padding: EdgeInsets.all(
                  widget.isMobile ? 20 : (widget.isTablet ? 24 : 28),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                    left: BorderSide(
                      color: cardColor.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  widget.expertise.description,
                  style: GoogleFonts.poppins(
                    fontSize: widget.isMobile
                        ? 14
                        : widget.isTablet
                            ? 15
                            : 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.6,
                    fontWeight: FontWeight.w400,
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
