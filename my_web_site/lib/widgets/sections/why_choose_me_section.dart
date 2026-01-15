import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_data.dart';
import '../common/section_title.dart';
import '../common/tech_grid_background.dart';
import '../common/scroll_speed_widget.dart';
import '../common/gsap_stagger_animation.dart';

class WhyChooseMeSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const WhyChooseMeSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Estimate: Hero + About + Stats + Expertise sections
    final sectionStartOffset = viewportHeight * 3.5;

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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.surface, AppColors.background],
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
                  GSAPEnhancedAnimation(
                    elementId: 'why-choose-me-title',
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    viewportHeight: viewportHeight,
                    ease: 'power2.out',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': -30, 'to': 0},
                      'scale': {'from': 0.9, 'to': 1.0},
                    },
                    child: SectionTitle(
                      title: 'Why Choose Me',
                      isVisible: true,
                    ),
                  ),
                  SizedBox(height: isMobile ? 32 : 48),
                  // Reasons grid
                  GSAPStaggerAnimation(
                    groupId: 'why-choose-me-reasons',
                    scrollOffset: scrollOffset,
                    sectionStartOffset:
                        sectionStartOffset + (viewportHeight * 0.1),
                    viewportHeight: viewportHeight,
                    staggerDelay: 0.1,
                    staggerFrom: 'start',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': 60, 'to': 0},
                      'scale': {'from': 0.9, 'to': 1.0},
                    },
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = isMobile
                              ? 1
                              : isTablet
                              ? 2
                              : 3;
                          final spacing = isMobile ? 16.0 : 24.0;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            alignment: WrapAlignment.start,
                            children: AppData.whyChooseMeReasons
                                .asMap()
                                .entries
                                .map((entry) {
                                  final index = entry.key;
                                  final reason = entry.value;
                                  final cardWidth = isMobile
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth -
                                                (spacing *
                                                    (crossAxisCount - 1))) /
                                            crossAxisCount;

                                  return SizedBox(
                                    width: cardWidth,
                                    child: _WhyChooseMeCard(
                                      reason: reason,
                                      index: index,
                                      isMobile: isMobile,
                                      isTablet: isTablet,
                                    ),
                                  );
                                })
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WhyChooseMeCard extends StatefulWidget {
  final dynamic reason; // WhyChooseMeReason
  final int index;
  final bool isMobile;
  final bool isTablet;

  const _WhyChooseMeCard({
    required this.reason,
    required this.index,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<_WhyChooseMeCard> createState() => _WhyChooseMeCardState();
}

class _WhyChooseMeCardState extends State<_WhyChooseMeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(
          widget.isMobile ? 20 : (widget.isTablet ? 24 : 28),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.reason.color.withOpacity(0.12),
              widget.reason.color.withOpacity(0.06),
              AppColors.surface.withOpacity(0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.reason.color.withOpacity(_isHovered ? 0.5 : 0.25),
            width: _isHovered ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.reason.color.withOpacity(_isHovered ? 0.3 : 0.12),
              blurRadius: _isHovered ? 30 : 20,
              spreadRadius: _isHovered ? 2 : 0,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.02 : 1.0)
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(widget.isMobile ? 12 : 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.reason.color.withOpacity(0.3),
                    widget.reason.color.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.reason.color.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(
                widget.reason.icon,
                color: widget.reason.color,
                size: widget.isMobile ? 28 : 32,
              ),
            ),
            SizedBox(height: widget.isMobile ? 16 : 20),
            // Title
            Text(
              widget.reason.title,
              style: GoogleFonts.poppins(
                fontSize: widget.isMobile ? 18 : (widget.isTablet ? 20 : 22),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: widget.isMobile ? 10 : 12),
            // Description
            Text(
              widget.reason.description,
              style: GoogleFonts.poppins(
                fontSize: widget.isMobile ? 13 : (widget.isTablet ? 14 : 15),
                color: AppColors.textSecondary.withOpacity(0.9),
                height: 1.6,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
