import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../widgets/common/section_title.dart';
import '../../../../../widgets/common/section_divider.dart';
import '../../../../../widgets/common/tech_grid_background.dart';
import '../../../../../widgets/common/floating_code_shapes.dart';
import '../../../../../widgets/common/scroll_speed_widget.dart';
import '../../../../../widgets/common/gsap_stagger_animation.dart';
import '../../widgets/project_stats_dashboard.dart';
import '../../widgets/tech_stack_filter.dart';
import '../../widgets/sticky_project_showcase.dart';
import '../../cubit/projects_cubit.dart';
import '../../cubit/projects_state.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../widgets/common/custom_shimmer.dart';

class ProjectsMobileView extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ProjectsMobileView({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 60),
            child: SectionShimmerGrid(itemCount: 4, height: 200, crossAxisCount: 1, spacing: 16),
          );
        }
        if (state is ProjectsError) {
          return Center(child: Text(state.message));
        }

        final projects = (state as ProjectsLoaded).projects;
        final viewportHeight = MediaQuery.of(context).size.height;
        final sectionStartOffset = viewportHeight * 4;

        return ValueListenableBuilder<double>(
          valueListenable: scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
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
                children: [
                  ScrollSpeedWidget(
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    speed: -0.2,
                    child: TechGridBackground(
                      scrollOffset: scrollOffset,
                      opacity: 0.08,
                    ),
                  ),
                  FloatingCodeShapes(scrollOffset: scrollOffset),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      GSAPEnhancedAnimation(
                        elementId: 'projects-title',
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
                            title: 'My Projects', isVisible: true),
                      ),
                      const SizedBox(height: 24),
                      GSAPEnhancedAnimation(
                        elementId: 'projects-divider',
                        scrollOffset: scrollOffset,
                        sectionStartOffset:
                            sectionStartOffset + (viewportHeight * 0.05),
                        viewportHeight: viewportHeight,
                        ease: 'power2.out',
                        animationConfig: const {
                          'opacity': {'from': 0, 'to': 1},
                          'scale': {'from': 0, 'to': 1.0},
                        },
                        child: SectionDivider(
                            scrollOffset: scrollOffset, delay: 0.ms),
                      ),
                      const SizedBox(height: 40),

                      // Intro Text
                      GSAPEnhancedAnimation(
                        elementId: 'projects-intro',
                        scrollOffset: scrollOffset,
                        sectionStartOffset:
                            sectionStartOffset + (viewportHeight * 0.1),
                        viewportHeight: viewportHeight,
                        ease: 'power2.out',
                        animationConfig: const {
                          'opacity': {'from': 0, 'to': 1},
                          'y': {'from': 40, 'to': 0},
                          'scale': {'from': 0.95, 'to': 1.0},
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 24),
                          margin: const EdgeInsets.only(bottom: 40),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.12),
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.08),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.05),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'The journey starts with a closer look.',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                  letterSpacing: -0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 60,
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Discover a better way to build, where development feels effortless, apps perform seamlessly, and users come alive in smooth experiences.',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                                  height: 1.8,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Stats
                      GSAPEnhancedAnimation(
                        elementId: 'projects-stats',
                        scrollOffset: scrollOffset,
                        sectionStartOffset:
                            sectionStartOffset + (viewportHeight * 0.15),
                        viewportHeight: viewportHeight,
                        ease: 'power2.out',
                        animationConfig: const {
                          'opacity': {'from': 0, 'to': 1},
                          'y': {'from': 40, 'to': 0},
                          'scale': {'from': 0.95, 'to': 1.0},
                        },
                        child: ProjectStatsDashboard(
                          stats: _getProjectStats(projects),
                          isMobile: true,
                          isTablet: false,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Filters
                      GSAPEnhancedAnimation(
                        elementId: 'projects-filters',
                        scrollOffset: scrollOffset,
                        sectionStartOffset:
                            sectionStartOffset + (viewportHeight * 0.18),
                        viewportHeight: viewportHeight,
                        ease: 'power2.out',
                        animationConfig: const {
                          'opacity': {'from': 0, 'to': 1},
                          'y': {'from': 30, 'to': 0},
                        },
                        child: TechStackFilter(
                          allTechStacks: _getAllTechStacks(projects),
                          selectedFilters:
                              context.read<ProjectsCubit>().selectedFilters,
                          onFilterChanged: (filters) {
                            context
                                .read<ProjectsCubit>()
                                .filterProjects(filters);
                          },
                          isMobile: true,
                          isTablet: false,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Project Showcase
                      StickyProjectShowcase(
                        scrollOffsetListenable: scrollOffsetListenable,
                        projects: projects,
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

  // Helper methods duplicated from original logic
  Set<String> _getAllTechStacks(List<dynamic> projects) {
    final techSet = <String>{};
    for (var project in projects) {
      techSet.addAll(project.tech);
    }
    return techSet;
  }

  Map<String, dynamic> _getProjectStats(List<dynamic> projects) {
    int totalDownloads = 0;
    double totalRating = 0.0;
    int ratedProjects = 0;

    for (var project in projects) {
      final downloadsStr = project.downloads.replaceAll(RegExp(r'[^\d]'), '');
      if (downloadsStr.isNotEmpty) {
        totalDownloads += int.tryParse(downloadsStr) ?? 0;
      }
      if (project.downloads.contains('+') || project.downloads.contains(',')) {
        totalRating += 4.8;
        ratedProjects++;
      }
    }

    return {
      'totalProjects': projects.length,
      'totalDownloads': totalDownloads,
      'averageRating': ratedProjects > 0 ? totalRating / ratedProjects : 0.0,
      'techStacks': _getAllTechStacks(projects).length,
    };
  }
}
