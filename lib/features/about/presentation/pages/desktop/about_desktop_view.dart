import 'package:my_web_site/widgets/common/app_loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';
import '../../../../../widgets/common/section_title.dart';
import '../../../../../widgets/common/tech_grid_background.dart';
import '../../../../../widgets/common/skill_progress_bar.dart';
import '../../../../../widgets/common/scroll_triggered_animation.dart';
import '../../../../../widgets/common/scroll_speed_widget.dart';
import '../../widgets/process_section.dart';
import '../../widgets/bento_tile.dart';
import '../../../../../widgets/common/impact_stat.dart';
import '../../../../../widgets/common/about_visual_branding.dart';
import '../../cubit/about_cubit.dart';
import '../../cubit/about_state.dart';
import '../../../../../core/constants/app_colors.dart';

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
    // RepaintBoundary isolates this section's compositing layer from its
    // siblings: BlocBuilder swaps a fixed-height loading indicator for the
    // much taller real content the instant Firestore data arrives. Without
    // a boundary, that resize can leave the section stuck showing a stale
    // frame forever (a MouseTracker/relayout race — asserts loudly in
    // debug, fails silently in release).
    return RepaintBoundary(
      child: BlocBuilder<AboutCubit, AboutState>(
      builder: (context, state) {
        if (state is AboutLoading) {
          return const AppLoadingIndicator();
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
                  // Aurora Background Effects. Only kept ticking while the
                  // About section is roughly on-screen -- otherwise these
                  // two infinite loops would run for the whole session even
                  // while the user is scrolled far away.
                  if (!isLowSpec) ...[
                    Builder(builder: (context) {
                      final isNearViewport =
                          (scrollOffset - sectionStartOffset).abs() <
                              viewportHeight * 2;
                      final blobOne = Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.05),
                        ),
                      );
                      final blobTwo = Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary.withValues(alpha: 0.03),
                        ),
                      );
                      return Stack(
                        children: [
                          Positioned(
                            top: -100,
                            right: -100,
                            child: isNearViewport
                                ? blobOne
                                    .animate(onPlay: (c) => c.repeat())
                                    .scale(
                                      duration: 10.seconds,
                                      begin: const Offset(1, 1),
                                      end: const Offset(1.5, 1.5),
                                      curve: Curves.easeInOut,
                                    )
                                : blobOne,
                          ),
                          Positioned(
                            bottom: 200,
                            left: -50,
                            child: isNearViewport
                                ? blobTwo
                                    .animate(onPlay: (c) => c.repeat())
                                    .scale(
                                      duration: 8.seconds,
                                      begin: const Offset(1.2, 1.2),
                                      end: const Offset(0.8, 0.8),
                                      curve: Curves.easeInOut,
                                    )
                                : blobTwo,
                          ),
                        ],
                      );
                    }),
                  ],

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
                        child: const SectionTitle(
                            title: 'About Me', isVisible: true),
                      ),
                      const SizedBox(height: 60),

                      // Bento Grid Layout
                      Column(
                        children: [
                          // Row 1: Identity & Visual
                          SizedBox(
                            height: 450,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: BentoTile(
                                    title: 'Identity',
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Crafting Exceptional\nDigital Experiences',
                                          style: GoogleFonts.ibmPlexMono(
                                            fontSize: 54,
                                            fontWeight: FontWeight.w900,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            height: 1.1,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          aboutData.professionalSummary,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.7),
                                            height: 1.6,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: BentoTile(
                                    title: 'Ecosystem',
                                    child: Center(
                                      child: AboutVisualBranding(
                                          scrollOffset: scrollOffset),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Row 2: Stats & Features
                          SizedBox(
                            height: 380,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: BentoTile(
                                    title: 'Impact',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: BentoTile(
                                    title: 'Experience',
                                    child: Expanded(
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children:
                                            aboutData.features.map((feature) {
                                          return Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.03),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.bolt,
                                                    color: AppColors.primary,
                                                    size: 20),
                                                const SizedBox(height: 12),
                                                Text(
                                                  feature.title,
                                                  style:
                                                      GoogleFonts.ibmPlexMono(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  feature.description,
                                                  style:
                                                      GoogleFonts.jetBrainsMono(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Row 3: Skills & Process
                          SizedBox(
                            height: 500,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: BentoTile(
                                    title: 'Proficiency',
                                    child: Expanded(
                                      child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: aboutData.skills.map((skill) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: SkillProgressBar(
                                              skill: skill.name,
                                              progress: skill.progress,
                                              scrollOffset: scrollOffset,
                                              sectionStartOffset:
                                                  sectionStartOffset + 400,
                                              viewportHeight: viewportHeight,
                                              color: skill.isPrimary
                                                  ? AppColors.primary
                                                  : AppColors.secondary,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: BentoTile(
                                    title: 'Process',
                                    child: ProcessSection(),
                                  ),
                                ),
                              ],
                            ),
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
      },
      ),
    );
  }
}
