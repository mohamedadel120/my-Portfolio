import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo_renderer/seo_renderer.dart'; // Step 2: SEO Import
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_data.dart';
import '../common/section_title.dart';
import '../common/project_card.dart';
import '../common/tech_grid_background.dart';
import '../common/terminal_window.dart';
import '../common/section_divider.dart';
import '../common/floating_code_shapes.dart';
import '../common/code_shape.dart';
import '../common/scroll_speed_widget.dart';
import '../common/gsap_stagger_animation.dart';

class ProjectsSection extends StatefulWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ProjectsSection({super.key, required this.scrollOffsetListenable});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  Set<String> _selectedTechFilters = {};

  // Get all unique tech stacks from projects
  Set<String> _getAllTechStacks() {
    final techSet = <String>{};
    for (var project in AppData.projects) {
      techSet.addAll(project.tech);
    }
    return techSet;
  }

  // Filter projects based on selected tech
  List<dynamic> _getFilteredProjects() {
    if (_selectedTechFilters.isEmpty) {
      return AppData.projects;
    }
    return AppData.projects.where((project) {
      return project.tech.any((tech) => _selectedTechFilters.contains(tech));
    }).toList();
  }

  // Calculate project statistics
  Map<String, dynamic> _getProjectStats() {
    final projects = AppData.projects;
    int totalDownloads = 0;
    double totalRating = 0.0;
    int ratedProjects = 0;

    for (var project in projects) {
      // Extract numeric value from downloads string
      final downloadsStr = project.downloads.replaceAll(RegExp(r'[^\d]'), '');
      if (downloadsStr.isNotEmpty) {
        totalDownloads += int.tryParse(downloadsStr) ?? 0;
      }
      // Assume 4.8 rating for projects with downloads
      if (project.downloads.contains('+') || project.downloads.contains(',')) {
        totalRating += 4.8;
        ratedProjects++;
      }
    }

    return {
      'totalProjects': projects.length,
      'totalDownloads': totalDownloads,
      'averageRating': ratedProjects > 0 ? totalRating / ratedProjects : 0.0,
      'techStacks': _getAllTechStacks().length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Estimate: Hero + About + Stats + Experience sections
    final sectionStartOffset = viewportHeight * 4;

    // Responsive breakpoints
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Responsive padding
    final horizontalPadding = isMobile
        ? 20.0
        : isTablet
        ? 30.0
        : 40.0;
    final verticalPadding = isMobile
        ? 60.0
        : isTablet
        ? 70.0
        : 80.0;

    // Responsive grid columns - better breakpoints
    final crossAxisCount = isMobile
        ? 1
        : isTablet
        ? 2
        : screenWidth < 1400
        ? 2
        : 3; // 3 columns on very large screens

    // Responsive spacing
    final gridSpacing = isMobile
        ? 16.0
        : isTablet
        ? 20.0
        : 24.0;

    return ValueListenableBuilder<double>(
      valueListenable: widget.scrollOffsetListenable,
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
            children: [
              // Tech grid background with parallax
              ScrollSpeedWidget(
                scrollOffset: scrollOffset,
                sectionStartOffset: sectionStartOffset,
                speed: -0.2, // Parallax effect
                child: TechGridBackground(
                  scrollOffset: scrollOffset,
                  opacity: 0.08,
                ),
              ),
              // Floating code shapes
              FloatingCodeShapes(scrollOffset: scrollOffset),
              // Decorative code shapes (hidden on mobile)
              if (!isMobile)
                Positioned(
                  top: isTablet ? 50 : 60,
                  left: isTablet ? 50 : 80,
                  child: CodeShape(
                    scrollOffset: scrollOffset,
                    type: CodeShapeType.arrow,
                    size: isTablet ? 48 : 55,
                    delay: 200.ms,
                  ),
                ),
              if (!isMobile)
                Positioned(
                  bottom: isTablet ? 60 : 80,
                  right: isTablet ? 50 : 80,
                  child: CodeShape(
                    scrollOffset: scrollOffset,
                    type: CodeShapeType.codeBlock,
                    size: isTablet ? 55 : 65,
                    delay: 400.ms,
                  ),
                ),
              // Terminal showing project stats (hidden on mobile)
              if (!isMobile)
                Positioned(
                  top: isTablet ? 40 : 50,
                  right: isTablet ? 30 : 40,
                  child: TerminalWindow(
                    commands: [
                      'flutter pub get',
                      'Projects: ${AppData.projects.length}',
                      'Status: Active',
                    ],
                    scrollOffset: scrollOffset,
                    delay: 600.ms,
                  ),
                ),
              // Main content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GSAPEnhancedAnimation(
                    elementId: 'projects-title',
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    viewportHeight: viewportHeight,
                    ease: 'power2.out',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': -30, 'to': 0},
                      'scale': {'from': 0.9, 'to': 1.0},
                    },
                    child: TextRenderer(
                      text: 'My Projects',
                      child: SectionTitle(
                        title: 'My Projects',
                        isVisible: true,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 32),
                  GSAPEnhancedAnimation(
                    elementId: 'projects-divider',
                    scrollOffset: scrollOffset,
                    sectionStartOffset:
                        sectionStartOffset + (viewportHeight * 0.05),
                    viewportHeight: viewportHeight,
                    ease: 'power2.out',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'scale': {'from': 0, 'to': 1.0},
                    },
                    child: SectionDivider(
                      scrollOffset: scrollOffset,
                      delay: 0.ms,
                    ),
                  ),
                  SizedBox(height: isMobile ? 40 : 48),
                  GSAPEnhancedAnimation(
                    elementId: 'projects-intro',
                    scrollOffset: scrollOffset,
                    sectionStartOffset:
                        sectionStartOffset + (viewportHeight * 0.1),
                    viewportHeight: viewportHeight,
                    ease: 'power2.out',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': 40, 'to': 0},
                      'scale': {'from': 0.95, 'to': 1.0},
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile
                            ? 20
                            : isTablet
                            ? 28
                            : 36,
                        vertical: isMobile
                            ? 24
                            : isTablet
                            ? 28
                            : 32,
                      ),
                      margin: EdgeInsets.only(bottom: isMobile ? 40 : 48),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.12),
                            AppColors.secondary.withOpacity(0.08),
                            AppColors.primary.withOpacity(0.05),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Enhanced narrative text
                          Text(
                            'The journey starts with a closer look.',
                            style: GoogleFonts.poppins(
                              fontSize: isMobile
                                  ? 20
                                  : isTablet
                                  ? 24
                                  : 28,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isMobile ? 16 : 20),
                          Container(
                            width: 60,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(height: isMobile ? 16 : 20),
                          Text(
                            'Discover a better way to build, where development feels effortless, apps perform seamlessly, and users come alive in smooth experiences. With clean architecture, powerful state management, and intuitive design, your project is unforgettable.',
                            style: GoogleFonts.poppins(
                              fontSize: isMobile
                                  ? 14
                                  : isTablet
                                  ? 15
                                  : 17,
                              color: AppColors.textSecondary.withOpacity(0.9),
                              height: 1.8,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 40 : 48),
                  // Project Statistics Dashboard
                  GSAPEnhancedAnimation(
                    elementId: 'projects-stats',
                    scrollOffset: scrollOffset,
                    sectionStartOffset:
                        sectionStartOffset + (viewportHeight * 0.15),
                    viewportHeight: viewportHeight,
                    ease: 'power2.out',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': 40, 'to': 0},
                      'scale': {'from': 0.95, 'to': 1.0},
                    },
                    child: _ProjectStatsDashboard(
                      stats: _getProjectStats(),
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ),
                  SizedBox(height: isMobile ? 32 : 40),
                  // Tech Stack Filter Chips
                  GSAPEnhancedAnimation(
                    elementId: 'projects-filters',
                    scrollOffset: scrollOffset,
                    sectionStartOffset:
                        sectionStartOffset + (viewportHeight * 0.18),
                    viewportHeight: viewportHeight,
                    ease: 'power2.out',
                    animationConfig: {
                      'opacity': {'from': 0, 'to': 1},
                      'y': {'from': 30, 'to': 0},
                    },
                    child: _TechStackFilter(
                      allTechStacks: _getAllTechStacks(),
                      selectedFilters: _selectedTechFilters,
                      onFilterChanged: (filters) {
                        setState(() {
                          _selectedTechFilters = filters;
                        });
                      },
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ),
                  SizedBox(height: isMobile ? 32 : 40),
                  // Enhanced project cards with GSAP animations
                  // Desktop showcase is now handled by SliverPersistentHeader in main.dart
                  if (!isMobile && !isTablet)
                    const SizedBox(
                      height: 100,
                    ) // Spacing before the sticky section starts
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate card width based on crossAxisCount
                        final cardWidth =
                            (constraints.maxWidth -
                                (gridSpacing * (crossAxisCount - 1))) /
                            crossAxisCount;

                        final filteredProjects = _getFilteredProjects();

                        if (filteredProjects.isEmpty) {
                          return Container(
                            padding: EdgeInsets.all(isMobile ? 40 : 60),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: isMobile ? 64 : 80,
                                  color: AppColors.textSecondary.withOpacity(
                                    0.5,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No projects found',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? 18 : 22,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Try selecting different tech stacks',
                                  style: GoogleFonts.poppins(
                                    fontSize: isMobile ? 14 : 16,
                                    color: AppColors.textSecondary.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Wrap(
                          spacing: gridSpacing,
                          runSpacing: gridSpacing,
                          alignment: WrapAlignment.start,
                          children: List.generate(filteredProjects.length, (
                            index,
                          ) {
                            final project = filteredProjects[index];
                            final originalIndex = AppData.projects.indexOf(
                              project,
                            );
                            return SizedBox(
                              width: cardWidth,
                              child: GSAPEnhancedAnimation(
                                elementId: 'project-card-$originalIndex',
                                scrollOffset: scrollOffset,
                                sectionStartOffset:
                                    sectionStartOffset +
                                    (viewportHeight * 0.25) +
                                    (index * viewportHeight * 0.08),
                                viewportHeight: viewportHeight,
                                ease: 'power3.out',
                                animationConfig: {
                                  'opacity': {'from': 0, 'to': 1},
                                  'y': {'from': 80, 'to': 0},
                                  'scale': {'from': 0.85, 'to': 1.0},
                                  'rotation': {
                                    'from': index % 2 == 0 ? -2 : 2,
                                    'to': 0,
                                  },
                                },
                                child: ProjectCard(
                                  project: project,
                                  delay: 0.ms,
                                  isVisible: true,
                                ),
                              ),
                            );
                          }),
                        );
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

// Project Statistics Dashboard Widget
class _ProjectStatsDashboard extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isMobile;
  final bool isTablet;

  const _ProjectStatsDashboard({
    required this.stats,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 24 : 28)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.secondary.withOpacity(0.1),
            AppColors.surface.withOpacity(0.9),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.apps_rounded,
            label: 'Projects',
            value: '${stats['totalProjects']}',
            color: AppColors.primary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          Container(
            width: 1,
            height: isMobile ? 40 : 50,
            color: AppColors.primary.withOpacity(0.3),
          ),
          _StatItem(
            icon: Icons.download_rounded,
            label: 'Downloads',
            value: '${(stats['totalDownloads'] / 1000).toStringAsFixed(0)}K+',
            color: AppColors.secondary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          Container(
            width: 1,
            height: isMobile ? 40 : 50,
            color: AppColors.primary.withOpacity(0.3),
          ),
          _StatItem(
            icon: Icons.star_rounded,
            label: 'Rating',
            value: stats['averageRating'].toStringAsFixed(1),
            color: AppColors.primary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          Container(
            width: 1,
            height: isMobile ? 40 : 50,
            color: AppColors.primary.withOpacity(0.3),
          ),
          _StatItem(
            icon: Icons.code_rounded,
            label: 'Tech Stacks',
            value: '${stats['techStacks']}',
            color: AppColors.secondary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isMobile;
  final bool isTablet;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 10 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.3), color.withOpacity(0.15)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          ),
          child: Icon(icon, color: color, size: isMobile ? 24 : 28),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 20 : (isTablet ? 24 : 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 11 : (isTablet ? 12 : 13),
            color: AppColors.textSecondary.withOpacity(0.8),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// Tech Stack Filter Widget
class _TechStackFilter extends StatelessWidget {
  final Set<String> allTechStacks;
  final Set<String> selectedFilters;
  final Function(Set<String>) onFilterChanged;
  final bool isMobile;
  final bool isTablet;

  const _TechStackFilter({
    required this.allTechStacks,
    required this.selectedFilters,
    required this.onFilterChanged,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final sortedTechStacks = allTechStacks.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              color: AppColors.primary,
              size: isMobile ? 20 : 24,
            ),
            SizedBox(width: 8),
            Text(
              'Filter by Tech Stack',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            if (selectedFilters.isNotEmpty)
              TextButton.icon(
                onPressed: () => onFilterChanged({}),
                icon: Icon(
                  Icons.clear_rounded,
                  size: isMobile ? 16 : 18,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  'Clear',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 12 : 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Wrap(
          spacing: isMobile ? 8 : 12,
          runSpacing: isMobile ? 8 : 12,
          children: sortedTechStacks.map((tech) {
            final isSelected = selectedFilters.contains(tech);
            return _FilterChip(
              label: tech,
              isSelected: isSelected,
              onTap: () {
                final newFilters = Set<String>.from(selectedFilters);
                if (isSelected) {
                  newFilters.remove(tech);
                } else {
                  newFilters.add(tech);
                }
                onFilterChanged(newFilters);
              },
              isMobile: isMobile,
              isTablet: isTablet,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMobile;
  final bool isTablet;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 14 : 18,
            vertical: widget.isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isSelected
                  ? [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.secondary.withOpacity(0.2),
                    ]
                  : [
                      AppColors.surface.withOpacity(0.8),
                      AppColors.surface.withOpacity(0.6),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary.withOpacity(0.6)
                  : AppColors.primary.withOpacity(_isHovered ? 0.4 : 0.2),
              width: widget.isSelected ? 2 : 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  size: widget.isMobile ? 16 : 18,
                  color: AppColors.primary,
                ),
              if (widget.isSelected) SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: widget.isMobile ? 12 : 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: widget.isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
