import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_data.dart';

import '../common/phone_frame.dart';
import '../common/magnetic_button.dart';

class ProjectShowcaseDelegate extends SliverPersistentHeaderDelegate {
  final double viewportHeight;
  final double screenWidth;

  const ProjectShowcaseDelegate({
    required this.viewportHeight,
    required this.screenWidth,
  });

  // Config
  static const double _introHeight = 1400.0;
  static const double _scrollPerImage = 800.0;

  double _getProjectHeight(int index) {
    if (index >= AppData.projects.length) return 0;
    final project = AppData.projects[index];
    double h = _introHeight;
    if (project.galleryImages != null && project.galleryImages!.isNotEmpty) {
      h += (project.galleryImages!.length * _scrollPerImage);
    }
    return h;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _ProjectShowcaseContent(
      shrinkOffset: shrinkOffset,
      viewportHeight: viewportHeight,
      screenWidth: screenWidth,
      delegate: this,
    );
  }

  @override
  double get maxExtent {
    double total = 0;
    for (int i = 0; i < AppData.projects.length; i++) {
      total += _getProjectHeight(i);
    }
    // ensure we don't return 0 if no projects
    return total == 0 ? viewportHeight : total;
  }

  @override
  double get minExtent => viewportHeight;

  @override
  bool shouldRebuild(covariant ProjectShowcaseDelegate oldDelegate) {
    return oldDelegate.viewportHeight != viewportHeight ||
        oldDelegate.screenWidth != screenWidth;
  }
}

class _ProjectShowcaseContent extends StatefulWidget {
  final double shrinkOffset;
  final double viewportHeight;
  final double screenWidth;
  final ProjectShowcaseDelegate delegate;

  const _ProjectShowcaseContent({
    required this.shrinkOffset,
    required this.viewportHeight,
    required this.screenWidth,
    required this.delegate,
  });

  @override
  State<_ProjectShowcaseContent> createState() =>
      _ProjectShowcaseContentState();
}

class _ProjectShowcaseContentState extends State<_ProjectShowcaseContent> {
  int _activeProjectIndex = 0;
  int _activeImageIndex = 0;
  int _activeTechLimit = 0;

  @override
  void didUpdateWidget(covariant _ProjectShowcaseContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateState();
  }

  @override
  void initState() {
    super.initState();
    _calculateState();
  }

  void _calculateState() {
    // Current scroll position within the total extent
    double currentOffset = widget.shrinkOffset;

    int newProjectIndex = 0;
    double currentSum = 0;
    double offsetWithinProject = 0;

    for (int i = 0; i < AppData.projects.length; i++) {
      double h = widget.delegate._getProjectHeight(i);
      if (currentOffset < (currentSum + h)) {
        newProjectIndex = i;
        offsetWithinProject = currentOffset - currentSum;
        break;
      }
      currentSum += h;
      if (i == AppData.projects.length - 1) {
        newProjectIndex = i;
        offsetWithinProject = h; // At end
      }
    }

    final project = AppData.projects[newProjectIndex];
    int imageCount = project.galleryImages?.length ?? 0;

    // Image Index
    int newImageIndex = 0;
    if (imageCount > 0) {
      // Start showing images after half the intro height
      if (offsetWithinProject > (ProjectShowcaseDelegate._introHeight / 2)) {
        double imageScroll =
            offsetWithinProject - (ProjectShowcaseDelegate._introHeight / 2);
        double totalImageScroll =
            imageCount * ProjectShowcaseDelegate._scrollPerImage;
        double progress = (imageScroll / totalImageScroll).clamp(0.0, 1.0);
        newImageIndex = (progress * imageCount).floor().clamp(
          0,
          imageCount - 1,
        );
      }
    }

    // Tech Stack Progress
    double projectProgress =
        (offsetWithinProject /
                widget.delegate._getProjectHeight(newProjectIndex))
            .clamp(0.0, 1.0);
    int techCount = project.tech.length;
    int newTechLimit = (projectProgress * techCount).ceil().clamp(1, techCount);

    if (newProjectIndex != _activeProjectIndex ||
        newImageIndex != _activeImageIndex ||
        newTechLimit != _activeTechLimit) {
      // Since we are in build/layout phase usually, simply updating state variable might be enough
      // if we are called during build. But setState is safer if called from outside.
      // However, this is a stateless calculation in 'build'.
      // We can just update local vars? No, we need to trigger specific sub-widget rebuilds.
      // Actually, since the parent passes new shrinkOffset, this build() is called.
      // We can just set the values.
      setState(() {
        _activeProjectIndex = newProjectIndex;
        _activeImageIndex = newImageIndex;
        _activeTechLimit = newTechLimit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Layout Constants - Responsive Size
    final double targetHeight = widget.viewportHeight * 0.85;
    final double phoneHeight = targetHeight.clamp(600.0, 820.0);
    final double phoneWidth = phoneHeight * (400.0 / 820.0);
    final sideWidth = (widget.screenWidth - phoneWidth) / 2;

    return Container(
      color: AppColors.background,
      width: widget.screenWidth,
      height: widget.viewportHeight,
      child: Stack(
        children: [
          // Background Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.background,
                  Color.lerp(
                    AppColors.background,
                    AppData.projects[_activeProjectIndex].color,
                    0.05,
                  )!,
                ],
              ),
            ),
          ),

          // --- CENTER: Phone ---
          // No need for Sticky Logic (clampedTop)! SliverPersistentHeader pins this whole widget.
          // We just center the phone in *this* widget (which fills viewport).
          Center(child: _buildPhone(phoneWidth, phoneHeight)),

          // --- LEFT: Info ---
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: sideWidth,
            child: _buildLeftInfo(sideWidth),
          ),

          // --- RIGHT: Tech Stack ---
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: sideWidth,
            child: _buildRightTech(sideWidth),
          ),
        ],
      ),
    );
  }

  // ... (Helper Methods from original file, simplified) ...

  Widget _buildPhone(double width, double height) {
    final project = AppData.projects[_activeProjectIndex];
    final hasImages =
        project.galleryImages != null && project.galleryImages!.isNotEmpty;

    int safeIndex = 0;
    if (hasImages) {
      safeIndex = _activeImageIndex.clamp(0, project.galleryImages!.length - 1);
    }

    Widget content;
    Key key;

    if (hasImages) {
      key = Key('${project.title}-$safeIndex');
      content = _buildPhoneImageContent(project.galleryImages![safeIndex]);
    } else {
      key = Key('${project.title}-logo');
      content = Container(
        color: project.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.layers_outlined,
          size: 80,
          color: Colors.white.withOpacity(0.5),
        ),
      );
    }

    return PhoneFrame(
      width: width,
      height: height,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeOut,
        child: Container(key: key, color: Colors.black, child: content),
      ),
    );
  }

  Widget _buildPhoneImageContent(String imagePath) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imagePath, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.transparent,
                Colors.black.withOpacity(0.2),
              ],
              stops: const [0.0, 0.2, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftInfo(double width) {
    final project = AppData.projects[_activeProjectIndex];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Column(
          key: Key('left-${project.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              project.title,
              style: GoogleFonts.anton(
                fontSize: 56,
                color: AppColors.textPrimary,
                height: 1.0,
              ),
            ).animate().fadeIn().slideX(begin: -0.2),
            const SizedBox(height: 24),
            Text(
              project.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 40),
            MagneticButton(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textPrimary.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "View Case Study",
                      style: GoogleFonts.poppins(color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_outward,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightTech(double width) {
    final project = AppData.projects[_activeProjectIndex];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.15),
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: Key('right-${project.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Technologies",
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.5),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            ...List.generate(project.tech.length, (index) {
              final isVisible = index < _activeTechLimit;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isVisible ? 1.0 : 0.2,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isVisible ? project.color : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: project.color.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        project.tech[index],
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: isVisible
                              ? FontWeight.w600
                              : FontWeight.w300,
                          color: isVisible
                              ? AppColors.textPrimary
                              : AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
