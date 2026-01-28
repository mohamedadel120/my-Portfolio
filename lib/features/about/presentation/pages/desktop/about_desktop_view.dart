import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';
import '../../../../../widgets/common/section_title.dart';
import '../../../../../widgets/common/about_card.dart';
import '../../../../../widgets/common/tech_grid_background.dart';
import '../../../../../widgets/common/skill_progress_bar.dart';
import '../../../../../widgets/common/scroll_triggered_animation.dart';
import '../../../../../widgets/common/gsap_stagger_animation.dart';
import '../../../../../widgets/common/scroll_speed_widget.dart';
import '../../../../../widgets/common/impact_stat.dart';
import '../../../../../widgets/common/about_visual_branding.dart';
import '../../../../../widgets/common/spotlight_card.dart';
import '../../cubit/about_cubit.dart';
import '../../cubit/about_state.dart';

class AboutDesktopView extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final VoidCallback? onDownloadCV;

  const AboutDesktopView({
    super.key,
    required this.scrollOffsetListenable,
    this.onDownloadCV,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutCubit, AboutState>(
      builder: (context, state) {
        if (state is AboutLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AboutError) {
          return Center(child: Text(state.message));
        }

        final aboutData = (state as AboutLoaded).aboutData;
        final viewportHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final sectionStartOffset = viewportHeight; // Hero takes 1 viewport

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
                children: [
                  // Background Tech Grid
                  ScrollSpeedWidget(
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    speed: -0.1,
                    child: TechGridBackground(
                      scrollOffset: scrollOffset,
                      opacity: isLowSpec ? 0.02 : 0.05,
                    ),
                  ),

                  Column(
                    children: [
                      ScrollTriggeredAnimation(
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        child: const TextRenderer(
                          text: 'About Me',
                          child:
                              SectionTitle(title: 'About Me', isVisible: true),
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Desktop Layout (Row: Intro vs Features)
                      Row(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Crafting Exceptional\nDigital Experiences',
                                        style: GoogleFonts.poppins(
                                          fontSize: 80,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          height: 1.0,
                                          letterSpacing: -1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        aboutData.professionalSummary,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          )
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.7),
                                          height: 1.6,
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      ElevatedButton.icon(
                                        onPressed: onDownloadCV ?? () {},
                                        icon:
                                            const Icon(Icons.download_rounded),
                                        label: const Text('Download Resume'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 60),
                                // Impact Stats
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ImpactStat(
                                      icon: Icons.download_rounded,
                                      value: aboutData.downloadsCount,
                                      label: 'DOWNLOADS',
                                    ),
                                    ImpactStat(
                                      icon: Icons.star_rounded,
                                      value: aboutData.ratings,
                                      label: 'RATINGS',
                                    ),
                                    ImpactStat(
                                      icon: Icons.workspace_premium_rounded,
                                      value: aboutData.yearsExperience,
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
                                  child: AboutVisualBranding(
                                      scrollOffset: scrollOffset),
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
                              children: aboutData.features.map((feature) {
                                IconData icon;
                                switch (feature.iconCode) {
                                  case 'code_rounded':
                                    icon = Icons.code_rounded;
                                    break;
                                  case 'rocket_launch_rounded':
                                    icon = Icons.rocket_launch_rounded;
                                    break;
                                  case 'architecture_rounded':
                                    icon = Icons.architecture_rounded;
                                    break;
                                  case 'devices_rounded':
                                    icon = Icons.devices_rounded;
                                    break;
                                  default:
                                    icon = Icons.code_rounded;
                                }

                                return SpotlightCard(
                                  spotlightColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: AboutCard(
                                    icon: icon,
                                    title: feature.title,
                                    description: feature.description,
                                    delay: Duration.zero,
                                    isVisible: true,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 80),

                      // Skills Section
                      GSAPEnhancedAnimation(
                        elementId: 'about-skills',
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset + 400,
                        viewportHeight: viewportHeight,
                        animationConfig: const {
                          'opacity': {'from': 0, 'to': 1},
                          'y': {'from': 40, 'to': 0},
                        },
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: isLowSpec ? 0.8 : 0.5),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Technical Skills',
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Column(
                                children: aboutData.skills
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final skill = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: SkillProgressBar(
                                      skill: skill.name,
                                      progress: skill.progress,
                                      color: skill.isPrimary
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      scrollOffset: scrollOffset,
                                      sectionStartOffset:
                                          sectionStartOffset + 500,
                                      viewportHeight: viewportHeight,
                                      delay: (200 * (index + 1)).ms,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
