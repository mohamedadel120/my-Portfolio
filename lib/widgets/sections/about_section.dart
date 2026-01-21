import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_data.dart';
import '../common/section_title.dart';
import '../common/about_card.dart';
import '../common/tech_grid_background.dart';
import '../common/skill_progress_bar.dart';
import '../common/scroll_triggered_animation.dart';
import '../common/gsap_stagger_animation.dart';
import '../common/scroll_speed_widget.dart';
import '../common/impact_stat.dart';
import '../common/about_visual_branding.dart';

class AboutSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final VoidCallback? onDownloadCV;

  const AboutSection({
    super.key,
    required this.scrollOffsetListenable,
    this.onDownloadCV,
  });

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionStartOffset = viewportHeight;

    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    final horizontalPadding = isMobile ? 24.0 : (isTablet ? 40.0 : 80.0);
    final verticalPadding = isMobile ? 60.0 : (isTablet ? 80.0 : 120.0);

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
            children: [
              // Background Tech Grid
              ScrollSpeedWidget(
                scrollOffset: scrollOffset,
                sectionStartOffset: sectionStartOffset,
                speed: -0.1,
                child: TechGridBackground(
                  scrollOffset: scrollOffset,
                  opacity: 0.05,
                ),
              ),

              Column(
                children: [
                  ScrollTriggeredAnimation(
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    child: const TextRenderer(
                      text: 'About Me',
                      child: SectionTitle(title: 'About Me', isVisible: true),
                    ),
                  ),
                  const SizedBox(height: 60),

                  if (isDesktop)
                    _buildDesktopLayout(
                      context,
                      viewportHeight,
                      sectionStartOffset,
                      scrollOffset,
                    )
                  else
                    _buildMobileLayout(
                      context,
                      viewportHeight,
                      sectionStartOffset,
                      scrollOffset,
                    ),

                  const SizedBox(height: 80),

                  // Skills Section (Common for both)
                  _buildSkillsSection(
                    context,
                    viewportHeight,
                    sectionStartOffset,
                    scrollOffset,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    double viewportHeight,
    double sectionStartOffset,
    double scrollOffset,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Branding & Intro
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GSAPEnhancedAnimation(
                elementId: 'about-header',
                scrollOffset: scrollOffset,
                sectionStartOffset: sectionStartOffset,
                viewportHeight: viewportHeight,
                animationConfig: const {
                  'opacity': {'from': 0, 'to': 1},
                  'x': {'from': -50, 'to': 0},
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crafting Exceptional\nDigital Experiences',
                      style: GoogleFonts.poppins(
                        fontSize: 80, // Increased from 48
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.0, // Tighter leading
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppData.professionalSummary,
                      style: GoogleFonts.poppins(
                        fontSize: 20, // Increased from 18
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: onDownloadCV ?? () {},
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              // Impact Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    [
                          const ImpactStat(
                            icon: Icons.download_rounded,
                            value: '10k+',
                            label: 'DOWNLOADS',
                          ),
                          const ImpactStat(
                            icon: Icons.star_rounded,
                            value: '4.8',
                            label: 'RATINGS',
                          ),
                          const ImpactStat(
                            icon: Icons.workspace_premium_rounded,
                            value: '3+',
                            label: 'YEARS EXP',
                          ),
                        ]
                        .animate(interval: 200.ms)
                        .fadeIn()
                        .slideX(begin: -0.2, end: 0),
              ),
              const SizedBox(height: 80),
              // Visual Branding element
              RepaintBoundary(
                child: AboutVisualBranding(scrollOffset: scrollOffset),
              ),
            ],
          ),
        ),
        const SizedBox(width: 80),
        // Right Column: Feature Cards
        Expanded(
          flex: 5,
          child: GSAPStaggerAnimation(
            groupId: 'about-cards-grid',
            scrollOffset: scrollOffset,
            sectionStartOffset: sectionStartOffset + 100,
            viewportHeight: viewportHeight,
            staggerDelay: 0.1,
            children: const [
              AboutCard(
                icon: Icons.code_rounded,
                title: 'Clean Code',
                description:
                    'Writing maintainable, scalable, and well-documented code that teams love to work with.',
                delay: Duration.zero,
                isVisible: true,
              ),
              AboutCard(
                icon: Icons.rocket_launch_rounded,
                title: 'Performance',
                description:
                    'Optimizing for 60fps and lightning-fast load times. I make sure your users never wait.',
                delay: Duration.zero,
                isVisible: true,
              ),
              AboutCard(
                icon: Icons.architecture_rounded,
                title: 'Architecture',
                description:
                    'Robust Clean Architecture and MVVM patterns for enterprise-grade scalability.',
                delay: Duration.zero,
                isVisible: true,
              ),
              AboutCard(
                icon: Icons.devices_rounded,
                title: 'Responsive',
                description:
                    'Pixel-perfect experiences across all device categories, from mobile to desktop.',
                delay: Duration.zero,
                isVisible: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    double viewportHeight,
    double sectionStartOffset,
    double scrollOffset,
  ) {
    return Column(
      children: [
        GSAPEnhancedAnimation(
          elementId: 'about-intro-mobile',
          scrollOffset: scrollOffset,
          sectionStartOffset: sectionStartOffset,
          viewportHeight: viewportHeight,
          animationConfig: const {
            'opacity': {'from': 0, 'to': 1},
            'y': {'from': 30, 'to': 0},
          },
          child: Column(
            children: [
              Text(
                AppData.professionalSummary,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onDownloadCV ?? () {},
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download Resume'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        // Stats for mobile
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ImpactStat(
                icon: Icons.download_rounded,
                value: '10k+',
                label: 'DOWNLOADS',
              ),
              SizedBox(width: 40),
              ImpactStat(
                icon: Icons.star_rounded,
                value: '4.8',
                label: 'RATINGS',
              ),
              SizedBox(width: 40),
              ImpactStat(
                icon: Icons.workspace_premium_rounded,
                value: '3+',
                label: 'YEARS EXP',
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        GSAPStaggerAnimation(
          groupId: 'about-cards-mobile',
          scrollOffset: scrollOffset,
          sectionStartOffset: sectionStartOffset + 200,
          viewportHeight: viewportHeight,
          staggerDelay: 0.15,
          children: const [
            AboutCard(
              icon: Icons.code_rounded,
              title: 'Clean Code',
              description: 'Maintainable, scalable, and well-documented code.',
              delay: Duration.zero,
              isVisible: true,
            ),
            AboutCard(
              icon: Icons.rocket_launch_rounded,
              title: 'Performance',
              description: 'Optimized speed and 60fps animations.',
              delay: Duration.zero,
              isVisible: true,
            ),
            AboutCard(
              icon: Icons.architecture_rounded,
              title: 'Architecture',
              description: 'Enterprise-grade Clean Architecture.',
              delay: Duration.zero,
              isVisible: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsSection(
    BuildContext context,
    double viewportHeight,
    double sectionStartOffset,
    double scrollOffset,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return GSAPEnhancedAnimation(
      elementId: 'about-skills',
      scrollOffset: scrollOffset,
      sectionStartOffset: sectionStartOffset + 400,
      viewportHeight: viewportHeight,
      animationConfig: const {
        'opacity': {'from': 0, 'to': 1},
        'y': {'from': 40, 'to': 0},
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 40),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technical Skills',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                SkillProgressBar(
                  skill: 'Flutter & Dart',
                  progress: 0.95,
                  color: Theme.of(context).colorScheme.primary,
                  scrollOffset: scrollOffset,
                  sectionStartOffset: sectionStartOffset + 500,
                  viewportHeight: viewportHeight,
                  delay: 200.ms,
                ),
                const SizedBox(height: 24),
                SkillProgressBar(
                  skill: 'Clean Architecture & Bloc',
                  progress: 0.90,
                  color: Theme.of(context).colorScheme.primary,
                  scrollOffset: scrollOffset,
                  sectionStartOffset: sectionStartOffset + 500,
                  viewportHeight: viewportHeight,
                  delay: 400.ms,
                ),
                const SizedBox(height: 24),
                SkillProgressBar(
                  skill: 'Firebase & REST APIs',
                  progress: 0.88,
                  color: Theme.of(context).colorScheme.secondary,
                  scrollOffset: scrollOffset,
                  sectionStartOffset: sectionStartOffset + 500,
                  viewportHeight: viewportHeight,
                  delay: 600.ms,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
