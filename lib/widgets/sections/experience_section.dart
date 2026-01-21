import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo_renderer/seo_renderer.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_data.dart';
import '../../models/experience.dart';
import '../common/section_title.dart';
import '../common/tech_grid_background.dart';
import '../common/scroll_triggered_animation.dart';
import '../common/scroll_speed_widget.dart';
import '../common/gsap_stagger_animation.dart';

class ExperienceSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ExperienceSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionStartOffset = viewportHeight * 3;

    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    final horizontalPadding = isMobile
        ? 20.0
        : isTablet
        ? 30.0
        : 40.0;
    final verticalPadding = isMobile
        ? 60.0
        : isTablet
        ? 80.0
        : 100.0;

    return ValueListenableBuilder<double>(
      valueListenable: scrollOffsetListenable,
      builder: (context, scrollOffset, _) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.background, AppColors.surface],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Tech grid background with parallax
              ScrollSpeedWidget(
                scrollOffset: scrollOffset,
                sectionStartOffset: sectionStartOffset,
                speed: -0.15,
                child: TechGridBackground(
                  scrollOffset: scrollOffset,
                  opacity: 0.05,
                ),
              ),
              // Main content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScrollTriggeredAnimation(
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    delay: 0.ms,
                    child: const SectionTitle(
                      title: 'Work Experience',
                      isVisible: true,
                    ),
                  ),
                  SizedBox(height: isMobile ? 48 : 72),
                  // Professional timeline-style experience cards
                  ...AppData.experiences.asMap().entries.map((entry) {
                    final index = entry.key;
                    final exp = entry.value;
                    final isLast = index == AppData.experiences.length - 1;

                    return _ProfessionalExperienceCard(
                      experience: exp,
                      scrollOffset: scrollOffset,
                      sectionStartOffset: sectionStartOffset,
                      viewportHeight: viewportHeight,
                      index: index,
                      isLast: isLast,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Professional timeline-style experience card
class _ProfessionalExperienceCard extends StatefulWidget {
  final Experience experience;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final int index;
  final bool isLast;
  final bool isMobile;
  final bool isTablet;

  const _ProfessionalExperienceCard({
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
  State<_ProfessionalExperienceCard> createState() =>
      _ProfessionalExperienceCardState();
}

class _ProfessionalExperienceCardState
    extends State<_ProfessionalExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Alternate card positions for visual interest
    final isEven = widget.index % 2 == 0;

    return Padding(
      padding: EdgeInsets.only(bottom: widget.isMobile ? 32 : 48),
      child: GSAPEnhancedAnimation(
        elementId: 'experience-card-${widget.index}',
        scrollOffset: widget.scrollOffset,
        sectionStartOffset:
            widget.sectionStartOffset +
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
                            color: AppColors.primary,
                            border: Border.all(
                              color: AppColors.background,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
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
                                    AppColors.primary.withValues(alpha: 0.6),
                                    AppColors.primary.withValues(alpha: 0.2),
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
                    _buildCardContent(),
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
                              color: AppColors.primary,
                              border: Border.all(
                                color: AppColors.background,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
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
                                    AppColors.primary.withValues(alpha: 0.6),
                                    AppColors.primary.withValues(alpha: 0.2),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Card content
                    Expanded(child: _buildCardContent()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(
        widget.isMobile ? 24 : (widget.isTablet ? 28 : 32),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: _isHovered ? 0.4 : 0.15),
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
        ..scale(_isHovered ? 1.01 : 1.0)
        ..translate(0.0, _isHovered ? -6.0 : 0.0),
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
                        fontSize: widget.isMobile
                            ? 22
                            : (widget.isTablet ? 24 : 28),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: widget.isMobile ? 8 : 12),
                    // Role
                    Text(
                      widget.experience.role,
                      style: GoogleFonts.poppins(
                        fontSize: widget.isMobile
                            ? 16
                            : (widget.isTablet ? 18 : 20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Period badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isMobile ? 14 : 18,
                  vertical: widget.isMobile ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.25),
                      AppColors.secondary.withValues(alpha: 0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  widget.experience.period,
                  style: GoogleFonts.poppins(
                    fontSize: widget.isMobile ? 11 : 13,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: widget.isMobile ? 20 : 28),
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          SizedBox(height: widget.isMobile ? 20 : 28),
          // Achievements list
          ...widget.experience.achievements.map((achievement) {
            return Padding(
              padding: EdgeInsets.only(bottom: widget.isMobile ? 14 : 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Professional bullet point
                  Container(
                    margin: EdgeInsets.only(
                      top: widget.isMobile ? 6 : 8,
                      right: 16,
                    ),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: TextRenderer(
                      text: achievement,
                      child: Text(
                        achievement,
                        style: GoogleFonts.poppins(
                          fontSize: widget.isMobile ? 14 : 16,
                          color: AppColors.textSecondary.withValues(alpha: 0.9),
                          height: 1.7,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
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
