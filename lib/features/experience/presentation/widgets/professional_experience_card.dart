import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/common/gsap_stagger_animation.dart';
import '../../domain/entities/experience_entity.dart';

class ProfessionalExperienceCard extends StatefulWidget {
  final Experience experience;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final int index;
  final bool isLast;
  final bool isMobile;
  final bool isTablet;

  const ProfessionalExperienceCard({
    super.key,
    required this.experience,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.index,
    required this.isLast,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<ProfessionalExperienceCard> createState() =>
      _ProfessionalExperienceCardState();
}

class _ProfessionalExperienceCardState
    extends State<ProfessionalExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Simple XS check - can be improved with DeviceUtils if accessible,
    // otherwise fallback to width check
    final isXS = screenWidth < 450;

    // Alternate card positions for visual interest
    final isEven = widget.index % 2 == 0;

    return Padding(
      padding: EdgeInsets.only(bottom: isXS ? 24 : (widget.isMobile ? 32 : 48)),
      child: GSAPEnhancedAnimation(
        elementId: 'experience-card-${widget.index}',
        scrollOffset: widget.scrollOffset,
        sectionStartOffset: widget.sectionStartOffset +
            (widget.index * widget.viewportHeight * 0.1),
        viewportHeight: widget.viewportHeight,
        ease: 'power3.out',
        useRandom: false,
        animationConfig: {
          'opacity': const {'from': 0, 'to': 1},
          'x': {
            'from': isEven ? -80 : 80, // Alternate slide directions
            'to': 0,
          },
          'y': const {'from': 60, 'to': 0},
          'scale': const {'from': 0.92, 'to': 1.0},
          'rotation': const {'from': 0, 'to': 0},
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: widget.isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mobile timeline indicator (top)
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        if (!widget.isLast) ...[
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.6),
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Card content
                    _buildCardContent(isXS),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Desktop timeline indicator (left side)
                    SizedBox(
                      width: 120,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Timeline dot
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          // Timeline line
                          if (!widget.isLast)
                            Container(
                              width: 2,
                              height: 100,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.6),
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.2),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Card content
                    Expanded(child: _buildCardContent(isXS)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCardContent(bool isXS) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(
        isXS ? 16 : (widget.isMobile ? 24 : (widget.isTablet ? 28 : 32)),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: _isHovered ? 0.4 : 0.15),
          width: _isHovered ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: _isHovered ? 0.2 : 0.1),
            blurRadius: _isHovered ? 24 : 16,
            spreadRadius: _isHovered ? 2 : 0,
            offset: Offset(0, _isHovered ? 10 : 6),
          ),
        ],
      ),
      transform: Matrix4.identity()
        ..multiply(Matrix4.diagonal3Values(_isHovered ? 1.01 : 1.0, _isHovered ? 1.01 : 1.0, 1.0))
        ..multiply(Matrix4.translationValues(0.0, _isHovered ? -6.0 : 0.0, 0.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with company, role, and period
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company name
                    Text(
                      widget.experience.company,
                      style: GoogleFonts.poppins(
                        fontSize: isXS
                            ? 18
                            : (widget.isMobile
                                ? 22
                                : (widget.isTablet ? 24 : 28)),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: isXS ? 8 : 12),
                    // Role
                    Text(
                      widget.experience.role,
                      style: GoogleFonts.poppins(
                        fontSize: isXS
                            ? 14
                            : (widget.isMobile
                                ? 16
                                : (widget.isTablet ? 18 : 20)),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Period badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isXS ? 10 : (widget.isMobile ? 14 : 18),
                  vertical: isXS ? 6 : (widget.isMobile ? 8 : 10),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.25),
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  widget.experience.period,
                  style: GoogleFonts.poppins(
                    fontSize: isXS ? 10 : (widget.isMobile ? 11 : 13),
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isXS ? 16 : 28),
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          SizedBox(height: isXS ? 16 : 28),
          // Achievements list
          ...widget.experience.achievements.map((achievement) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: isXS ? 10 : (widget.isMobile ? 14 : 18)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Professional bullet point
                  Container(
                    margin: EdgeInsets.only(
                      top: isXS ? 6 : (widget.isMobile ? 6 : 8),
                      right: 16,
                      left: 4,
                    ),
                    width: isXS ? 4 : 6,
                    height: isXS ? 4 : 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      achievement,
                      style: GoogleFonts.poppins(
                        fontSize: isXS ? 13 : (widget.isMobile ? 14 : 16),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.9),
                        height: 1.7,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
