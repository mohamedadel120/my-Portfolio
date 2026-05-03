import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/why_choose_me/presentation/cubit/why_choose_me_cubit.dart';
import '../../features/why_choose_me/presentation/cubit/why_choose_me_state.dart';
import '../common/custom_shimmer.dart';
import '../../injection_container.dart';
import '../common/section_title.dart';
import '../common/tech_grid_background.dart';
import '../common/scroll_speed_widget.dart';
import '../common/gsap_stagger_animation.dart';
import '../../utils/device_utils.dart';

class WhyChooseMeSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const WhyChooseMeSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WhyChooseMeCubit>()..loadReasons(),
      child: _WhyChooseMeContent(
        scrollOffsetListenable: scrollOffsetListenable,
      ),
    );
  }
}

class _WhyChooseMeContent extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const _WhyChooseMeContent({required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Estimate: Hero + About + Stats + Expertise sections
    final sectionStartOffset = viewportHeight * 3.5;

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
                Theme.of(context).colorScheme.surface,
                Theme.of(context).scaffoldBackgroundColor,
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
                    elementId: 'why-choose-me-title',
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
                      title: 'Why Choose Me',
                      isVisible: true,
                    ),
                  ),
                  SizedBox(height: isXS ? 24 : (isMobile ? 32 : 48)),
                  BlocBuilder<WhyChooseMeCubit, WhyChooseMeState>(
                    builder: (context, state) {
                      if (state is WhyChooseMeLoading) {
                        return SectionShimmerGrid(
                          itemCount: 6,
                          height: isXS ? 160 : (isMobile ? 180 : 220),
                          crossAxisCount: isXS ? 1 : (isMobile ? 1 : (isTablet ? 2 : 3)),
                          spacing: isXS ? 12.0 : (isMobile ? 16.0 : 24.0),
                        );
                      } else if (state is WhyChooseMeError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is WhyChooseMeLoaded) {
                        final reasons = state.reasons;
                        return GSAPStaggerAnimation(
                          groupId: 'why-choose-me-reasons',
                          scrollOffset: scrollOffset,
                          sectionStartOffset:
                              sectionStartOffset + (viewportHeight * 0.1),
                          viewportHeight: viewportHeight,
                          staggerDelay: 0.1,
                          staggerFrom: 'start',
                          animationConfig: const {
                            'opacity': {'from': 0, 'to': 1},
                            'y': {'from': 60, 'to': 0},
                            'scale': {'from': 0.9, 'to': 1.0},
                          },
                          children: [
                            Builder(
                              builder: (context) {
                                final crossAxisCount = isXS
                                    ? 1
                                    : (isMobile ? 1 : (isTablet ? 2 : 3));
                                final spacing =
                                    isXS ? 12.0 : (isMobile ? 16.0 : 24.0);
                                // Calculate available width from screenWidth and padding
                                final availableWidth =
                                    screenWidth - (horizontalPadding * 2);

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  alignment: WrapAlignment.start,
                                  children:
                                      reasons.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final reason = entry.value;
                                    final cardWidth = isMobile
                                        ? availableWidth
                                        : (availableWidth -
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isXS = DeviceUtils.isExtraSmall(screenWidth);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(
          isXS ? 14 : (widget.isMobile ? 20 : (widget.isTablet ? 24 : 28)),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.reason.color.withValues(alpha: 0.12),
              widget.reason.color.withValues(alpha: 0.06),
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.reason.color.withValues(
              alpha: _isHovered ? 0.5 : 0.25,
            ),
            width: _isHovered ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.reason.color.withValues(
                alpha: _isHovered ? 0.3 : 0.12,
              ),
              blurRadius: _isHovered ? 30 : 20,
              spreadRadius: _isHovered ? 2 : 0,
              offset: Offset(0, _isHovered ? 8 : 4),
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
            // Icon
            Container(
              padding: EdgeInsets.all(isXS ? 10 : (widget.isMobile ? 12 : 14)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.reason.color.withValues(alpha: 0.3),
                    widget.reason.color.withValues(alpha: 0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.reason.color.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Icon(
                widget.reason.icon,
                color: widget.reason.color,
                size: isXS ? 24 : (widget.isMobile ? 28 : 32),
              ),
            ),
            SizedBox(height: isXS ? 16 : 20),
            // Title
            Text(
              widget.reason.title,
              style: GoogleFonts.poppins(
                fontSize: isXS
                    ? 16
                    : (widget.isMobile ? 18 : (widget.isTablet ? 20 : 22)),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: isXS ? 8 : 12),
            // Description
            Text(
              widget.reason.description,
              style: GoogleFonts.poppins(
                fontSize: isXS
                    ? 12
                    : (widget.isMobile ? 13 : (widget.isTablet ? 14 : 15)),
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.9),
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
