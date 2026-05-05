import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/testimonials/presentation/cubit/testimonials_cubit.dart';
import '../../features/testimonials/presentation/cubit/testimonials_state.dart';
import '../common/custom_shimmer.dart';
import '../../injection_container.dart';
import '../common/section_title.dart';
import '../common/tech_grid_background.dart';
import '../common/scroll_speed_widget.dart';
import '../common/gsap_stagger_animation.dart';
import '../../utils/device_utils.dart';

class TestimonialsSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const TestimonialsSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TestimonialsCubit>()..loadTestimonials(),
      child: _TestimonialsContent(
        scrollOffsetListenable: scrollOffsetListenable,
      ),
    );
  }
}

class _TestimonialsContent extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const _TestimonialsContent({required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Estimate: Hero + About + Stats + Expertise + Experience + Projects + Why Choose Me sections
    final sectionStartOffset = viewportHeight * 5.5;

    final isXS = DeviceUtils.isExtraSmall(screenWidth);
    final isMobile = DeviceUtils.isMobile(screenWidth);
    final isTablet = DeviceUtils.isTablet(screenWidth);
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);

    final horizontalPadding = DeviceUtils.getHorizontalPadding(screenWidth);
    final verticalPadding = DeviceUtils.getVerticalPadding(screenWidth);

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
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).colorScheme.surface,
              ],
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
                  opacity: isLowSpec ? 0.02 : 0.05,
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
                    animationConfig: const {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': -30, 'to': 0},
                      'scale': {'from': 0.9, 'to': 1.0},
                    },
                    child: const SectionTitle(
                      title: 'Their Opinions',
                      isVisible: true,
                    ),
                  ),
                  SizedBox(height: isXS ? 24 : (isMobile ? 32 : 48)),
                  // Testimonials grid
                  BlocBuilder<TestimonialsCubit, TestimonialsState>(
                    builder: (context, state) {
                      if (state is TestimonialsLoading) {
                        return SectionShimmerGrid(
                          itemCount: 4,
                          height: isXS ? 220 : (isMobile ? 240 : 280),
                          crossAxisCount: isXS ? 1 : (isMobile ? 1 : (isTablet ? 2 : 2)),
                          spacing: isXS ? 16.0 : (isMobile ? 20.0 : 28.0),
                        );
                      } else if (state is TestimonialsError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is TestimonialsLoaded) {
                        final testimonials = state.testimonials;
                        return GSAPStaggerAnimation(
                          groupId: 'testimonials-grid',
                          scrollOffset: scrollOffset,
                          sectionStartOffset:
                              sectionStartOffset + (viewportHeight * 0.1),
                          viewportHeight: viewportHeight,
                          staggerDelay: 0.12,
                          staggerFrom: 'start',
                          animationConfig: const {
                            'opacity': {'from': 0, 'to': 1},
                            'y': {'from': 60, 'to': 0},
                            'scale': {'from': 0.9, 'to': 1.0},
                          },
                          children: [
                            Builder(
                              builder: (context) {
                                final spacing =
                                    isXS ? 16.0 : (isMobile ? 20.0 : 28.0);
                                // Calculate available width from screenWidth and padding
                                final availableWidth =
                                    screenWidth - (horizontalPadding * 2);

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  alignment: WrapAlignment.center,
                                  children:
                                      testimonials.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final testimonial = entry.value;
                                    final cardWidth = isMobile || isTablet
                                        ? availableWidth
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
                        );
                      }
                      return const SizedBox.shrink();
                    },
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isXS = DeviceUtils.isExtraSmall(screenWidth);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(
          isXS ? 16 : (widget.isMobile ? 24 : (widget.isTablet ? 28 : 32)),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: _isHovered ? 0.4 : 0.2),
            width: _isHovered ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: _isHovered ? 0.25 : 0.1),
              blurRadius: _isHovered ? 30 : 20,
              spreadRadius: _isHovered ? 2 : 0,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.08),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: 0,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
          ],
        ),
        transform: Matrix4.translationValues(0.0, _isHovered ? -6.0 : 0.0, 0.0)
          * Matrix4.diagonal3Values(
              _isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0),
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
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.format_quote_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: isXS ? 24 : (widget.isMobile ? 28 : 32),
              ),
            ),
            SizedBox(height: isXS ? 16 : 20),
            // Rating stars
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: isXS ? 14 : (widget.isMobile ? 16 : 18),
                );
              }),
            ),
            SizedBox(height: isXS ? 16 : 20),
            // Opinion text
            Text(
              widget.testimonial.opinion,
              style: GoogleFonts.jetBrainsMono(
                fontSize: isXS
                    ? 13
                    : (widget.isMobile ? 14 : (widget.isTablet ? 15 : 16)),
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.95),
                height: 1.7,
                letterSpacing: 0.2,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: isXS ? 20 : 24),
            // Divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            SizedBox(height: isXS ? 16 : 20),
            // Author info
            Row(
              children: [
                // Name and role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${widget.testimonial.role} • ${widget.testimonial.company}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: isXS
                              ? 11
                              : (widget.isMobile
                                  ? 12
                                  : (widget.isTablet ? 13 : 14)),
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.8),
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
