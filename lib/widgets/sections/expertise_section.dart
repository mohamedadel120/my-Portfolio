import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../common/section_title.dart';
import '../common/tech_grid_background.dart';
import '../common/scroll_triggered_animation.dart';
import '../common/scroll_speed_widget.dart';
import '../common/gsap_stagger_animation.dart';
import '../../utils/device_utils.dart';

class ExpertiseSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ExpertiseSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Estimate: Hero + About + Stats sections
    final sectionStartOffset = viewportHeight * 2.5;

    final isXS = DeviceUtils.isExtraSmall(screenWidth);
    final isMobile = DeviceUtils.isMobile(screenWidth);
    final isTablet = DeviceUtils.isTablet(screenWidth);
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);

    final horizontalPadding = DeviceUtils.getHorizontalPadding(screenWidth);
    final verticalPadding = DeviceUtils.getVerticalPadding(screenWidth);

    // Expertise areas inspired by CHD Art Maker's service grid
    final expertiseAreas = [
      _ExpertiseArea(
        title: 'Mobile Development',
        description:
            'Cross-platform Flutter apps with clean architecture, state management, and seamless user experiences.',
        icon: Icons.phone_android_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      _ExpertiseArea(
        title: 'UI/UX Design',
        description:
            'Modern, intuitive interfaces with attention to detail, animations, and user-centered design principles.',
        icon: Icons.design_services_rounded,
        color: Theme.of(context).colorScheme.secondary,
      ),
      _ExpertiseArea(
        title: 'Backend Integration',
        description:
            'Firebase, REST APIs, and cloud services integration for scalable and robust applications.',
        icon: Icons.cloud_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
      _ExpertiseArea(
        title: 'Performance Optimization',
        description:
            'Code optimization, efficient state management, and smooth animations for premium app experiences.',
        icon: Icons.speed_rounded,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ];

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
                speed: -0.2,
                child: TechGridBackground(
                  scrollOffset: scrollOffset,
                  opacity: isLowSpec ? 0.02 : 0.06,
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
                      title: 'Expertise',
                      isVisible: true,
                    ),
                  ),
                  SizedBox(height: isXS ? 32 : (isMobile ? 48 : 72)),
                  // Expertise cards
                  isMobile
                      ? Column(
                          children: expertiseAreas.asMap().entries.map((entry) {
                            final index = entry.key;
                            final expertise = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: isMobile ? 24 : 32,
                              ),
                              child: _ExpertiseCardUnified(
                                expertise: expertise,
                                scrollOffset: scrollOffset,
                                sectionStartOffset: sectionStartOffset,
                                viewportHeight: viewportHeight,
                                index: index,
                                isMobile: isMobile,
                                isTablet: isTablet,
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _ExpertiseCardUnified(
                                    expertise: expertiseAreas[0],
                                    scrollOffset: scrollOffset,
                                    sectionStartOffset: sectionStartOffset,
                                    viewportHeight: viewportHeight,
                                    index: 0,
                                    isMobile: isMobile,
                                    isTablet: isTablet,
                                  ),
                                ),
                                SizedBox(width: isTablet ? 24 : 32),
                                Expanded(
                                  child: _ExpertiseCardUnified(
                                    expertise: expertiseAreas[1],
                                    scrollOffset: scrollOffset,
                                    sectionStartOffset: sectionStartOffset,
                                    viewportHeight: viewportHeight,
                                    index: 1,
                                    isMobile: isMobile,
                                    isTablet: isTablet,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 24 : 32),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _ExpertiseCardUnified(
                                    expertise: expertiseAreas[2],
                                    scrollOffset: scrollOffset,
                                    sectionStartOffset: sectionStartOffset,
                                    viewportHeight: viewportHeight,
                                    index: 2,
                                    isMobile: isMobile,
                                    isTablet: isTablet,
                                  ),
                                ),
                                SizedBox(width: isTablet ? 24 : 32),
                                Expanded(
                                  child: _ExpertiseCardUnified(
                                    expertise: expertiseAreas[3],
                                    scrollOffset: scrollOffset,
                                    sectionStartOffset: sectionStartOffset,
                                    viewportHeight: viewportHeight,
                                    index: 3,
                                    isMobile: isMobile,
                                    isTablet: isTablet,
                                  ),
                                ),
                              ],
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

class _ExpertiseArea {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _ExpertiseArea({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// Enhanced expertise card with GSAP-like animations using Flutter
class _ExpertiseCardUnified extends StatefulWidget {
  final _ExpertiseArea expertise;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final int index;
  final bool isMobile;
  final bool isTablet;

  const _ExpertiseCardUnified({
    required this.expertise,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.index,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<_ExpertiseCardUnified> createState() => _ExpertiseCardUnifiedState();
}

class _ExpertiseCardUnifiedState extends State<_ExpertiseCardUnified> {
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
              color: widget.expertise.color.withValues(
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
                  color: widget.expertise.color.withValues(
                    alpha: _isHovered ? 0.1 : 0.05,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.expertise.color.withValues(
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
                        color: widget.expertise.color.withValues(
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
                          color: widget.expertise.color,
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
                      color: widget.expertise.color.withValues(alpha: 0.3),
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
