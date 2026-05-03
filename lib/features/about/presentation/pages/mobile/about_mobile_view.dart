import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';
import '../../../../../widgets/common/section_title.dart';
import '../../../../../widgets/common/tech_grid_background.dart';
import '../../../../../widgets/common/skill_progress_bar.dart';
import '../../../../../widgets/common/impact_stat.dart';
import '../../../../../widgets/common/about_visual_branding.dart';
import '../../widgets/process_section.dart';
import '../../widgets/bento_tile.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../cubit/about_cubit.dart';
import '../../cubit/about_state.dart';

class AboutMobileView extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final VoidCallback? onDownloadCV;

  const AboutMobileView({
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
        final isXS = DeviceUtils.isExtraSmall(screenWidth);

        return ValueListenableBuilder<double>(
          valueListenable: scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Stack(
                children: [
                  // Aurora Background Effects
                  if (!isLowSpec) ...[
                    Positioned(
                      top: 0,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.05),
                        ),
                      ).animate(onPlay: (c) => c.repeat()).scale(
                            duration: 10.seconds,
                            begin: const Offset(1, 1),
                            end: const Offset(1.5, 1.5),
                            curve: Curves.easeInOut,
                          ),
                    ),
                  ],

                  // Background Tech Grid
                  TechGridBackground(
                    scrollOffset: scrollOffset,
                    opacity: isLowSpec ? 0.02 : 0.05,
                  ),

                  Column(
                    children: [
                      const SectionTitle(title: 'About Me', isVisible: true),
                      const SizedBox(height: 32),

                      // Mobile Bento Grid (Vertical Stack)
                      Column(
                        children: [
                          // Identity Tile
                          BentoTile(
                            title: 'Identity',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'CRAFTING DIGITAL\nEXPERIENCES',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.orbitron(
                                    fontSize: isXS ? 20 : 24,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    height: 1.2,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  aboutData.professionalSummary,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          // Impact Tile
                          BentoTile(
                            title: 'Impact',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                          // Ecosystem Tile (Branding)
                          BentoTile(
                            height: 350,
                            title: 'Ecosystem',
                            child: Center(
                              child: Transform.scale(
                                scale: 0.75,
                                child: AboutVisualBranding(
                                    scrollOffset: scrollOffset),
                              ),
                            ),
                          ),

                          // Proficiency Tile
                          BentoTile(
                            title: 'Proficiency',
                            child: Column(
                              children: aboutData.skills.take(3).map((skill) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: SkillProgressBar(
                                    skill: skill.name,
                                    progress: skill.progress,
                                    scrollOffset: scrollOffset,
                                    sectionStartOffset:
                                        sectionStartOffset + 200,
                                    viewportHeight: viewportHeight,
                                    color: skill.isPrimary
                                        ? AppColors.primary
                                        : AppColors.secondary,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // Process Tile
                          const BentoTile(
                            title: 'Process',
                            child: ProcessSection(),
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
    );
  }
}
