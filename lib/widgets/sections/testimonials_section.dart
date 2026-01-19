import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../common/section_title.dart';
import '../common/tech_grid_background.dart';
import '../common/scroll_speed_widget.dart';
import '../common/gsap_stagger_animation.dart';

class TestimonialsSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const TestimonialsSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Estimate: Hero + About + Stats + Expertise + Experience + Projects + Why Choose Me sections
    final sectionStartOffset = viewportHeight * 5.5;

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
                  GSAPEnhancedAnimation(
                    elementId: 'testimonials-title',
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
                      title: 'Their Opinions',
                      isVisible: true,
                    ),
                  ),
                  SizedBox(height: isMobile ? 32 : 48),
                  // Testimonials grid
                  GSAPStaggerAnimation(
                    groupId: 'testimonials-grid',
                    scrollOffset: scrollOffset,
                    sectionStartOffset:
                        sectionStartOffset + (viewportHeight * 0.1),
                    viewportHeight: viewportHeight,
                    staggerDelay: 0.12,
                    staggerFrom: 'start',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': 60, 'to': 0},
                      'scale': {'from': 0.9, 'to': 1.0},
                    },
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final spacing = isMobile ? 20.0 : 28.0;

                          final hardcodedTestimonials = [
                            (
                              opinion:
                                  "Working with Mohamed was a game-changer. His code is clean, scalable, and he delivered features faster than anticipated.",
                              role: "Senior Tech Lead",
                              company: "TechCorp",
                            ),
                          ];

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            alignment: WrapAlignment.center,
                            children: hardcodedTestimonials.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final testimonial = entry.value;
                              final cardWidth = isMobile || isTablet
                                  ? constraints.maxWidth
                                  : 600.0; // Fixed width for single testimonial

                              return SizedBox(
                                width: cardWidth,
                                child: _TestimonialCard(
                                  testimonial: testimonial,
                                  index: index,
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                ),
                              );
                            }).toList(),
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

class _TestimonialCard extends StatefulWidget {
  final dynamic testimonial; // Testimonial
  final int index;
  final bool isMobile;
  final bool isTablet;

  const _TestimonialCard({
    required this.testimonial,
    required this.index,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
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
          widget.isMobile ? 24 : (widget.isTablet ? 28 : 32),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.secondary.withOpacity(0.08),
              AppColors.surface.withOpacity(0.95),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary.withOpacity(_isHovered ? 0.4 : 0.2),
            width: _isHovered ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(_isHovered ? 0.25 : 0.1),
              blurRadius: _isHovered ? 30 : 20,
              spreadRadius: _isHovered ? 2 : 0,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: 0,
              offset: Offset(0, _isHovered ? 6 : 3),
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
            // Quote icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.secondary.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.format_quote_rounded,
                color: AppColors.primary,
                size: widget.isMobile ? 28 : 32,
              ),
            ),
            SizedBox(height: widget.isMobile ? 16 : 20),
            // Rating stars
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star_rounded,
                  color: AppColors.primary,
                  size: widget.isMobile ? 16 : 18,
                );
              }),
            ),
            SizedBox(height: widget.isMobile ? 16 : 20),
            // Opinion text
            Text(
              widget.testimonial.opinion,
              style: GoogleFonts.poppins(
                fontSize: widget.isMobile ? 14 : (widget.isTablet ? 15 : 16),
                color: AppColors.textSecondary.withOpacity(0.95),
                height: 1.7,
                letterSpacing: 0.2,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: widget.isMobile ? 20 : 24),
            // Divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            SizedBox(height: widget.isMobile ? 16 : 20),
            // Author info
            Row(
              children: [
                // Name and role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        '${widget.testimonial.role} • ${widget.testimonial.company}',
                        style: GoogleFonts.poppins(
                          fontSize: widget.isMobile
                              ? 12
                              : (widget.isTablet ? 13 : 14),
                          color: AppColors.textSecondary.withOpacity(0.8),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
