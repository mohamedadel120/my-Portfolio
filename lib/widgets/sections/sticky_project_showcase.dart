import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/url_launcher_utils.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_data.dart';
import '../common/phone_frame.dart';
import '../common/magnetic_button.dart';
import '../common/project_video_player.dart';

class StickyProjectShowcase extends StatefulWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const StickyProjectShowcase({
    super.key,
    required this.scrollOffsetListenable,
  });

  @override
  State<StickyProjectShowcase> createState() => _StickyProjectShowcaseState();
}

class _StickyProjectShowcaseState extends State<StickyProjectShowcase> {
  int _activeProjectIndex = 0;
  int _activeImageIndex = 0;
  int _activeTechLimit = 0; // How many tech items to show
  double? _absoluteTop;

  // Video Control
  bool _isManuallyPaused = false;

  // Scroll Detection
  bool _isScrolling = false;
  Timer? _scrollEndTimer;
  double _lastScrollOffset = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Auto-discover absolute position in the scrollable content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final scrollValue = widget.scrollOffsetListenable.value;
          final screenPos = box.localToGlobal(Offset.zero);
          setState(() {
            _absoluteTop = screenPos.dy + scrollValue;
          });
        }
      }
    });
  }

  // Config
  final double _introHeight = 1400.0;
  final double _scrollPerImage = 800.0;

  double _getProjectHeight(int index) {
    final project = AppData.projects[index];
    double h = _introHeight;
    if (project.galleryImages != null && project.galleryImages!.isNotEmpty) {
      h += (project.galleryImages!.length * _scrollPerImage);
    }
    return h;
  }

  double get _totalHeight {
    double total = 0;
    for (int i = 0; i < AppData.projects.length; i++) {
      total += _getProjectHeight(i);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    if (!isDesktop) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<double>(
          valueListenable: widget.scrollOffsetListenable,
          builder: (context, scrollOffset, child) {
            // Detect manual scroll updates
            if ((scrollOffset - _lastScrollOffset).abs() > 0.01) {
              // We can't setState inside build directly usually,
              // but since we are just debouncing a 'scrolling' state,
              // we can defer the 'end' timer.
              // To trigger 'start', we need to be careful not to cause rebuild loops.
              // However, since we are inside a ValueListenableBuilder, this closure runs on change.
              // We can safely schedule the timer.
              if (!_isScrolling) {
                // Defer state update to next frame to avoid locked build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isScrolling) {
                    setState(() => _isScrolling = true);
                  }
                });
              }
              _scrollEndTimer?.cancel();
              _scrollEndTimer = Timer(const Duration(milliseconds: 200), () {
                if (mounted) setState(() => _isScrolling = false);
              });
            }
            _lastScrollOffset = scrollOffset;

            final viewportHeight = MediaQuery.of(context).size.height;

            // --- DETERMINISTIC STICKY LOGIC ---
            // Instead of localToGlobal (which jitters), we use the absolute scroll offset
            // and the section's starting point to calculate its viewport position.

            // 1. Where the section is currently relative to the viewport top
            // 1. Where this widget is currently relative to the viewport top
            // Fallback to a safe guess if not yet discovered
            final discoveredTop = _absoluteTop ?? 4000.0;
            final double showcaseTopInViewport = discoveredTop - scrollOffset;

            // 2. How much the user has scrolled INTO this specific showcase
            final double relativeScroll = -showcaseTopInViewport;

            int newProjectIndex = 0;
            double currentSum = 0;
            double offsetWithinProject = 0;

            for (int i = 0; i < AppData.projects.length; i++) {
              final double h = _getProjectHeight(i);
              if (relativeScroll < (currentSum + h)) {
                newProjectIndex = i;
                offsetWithinProject = relativeScroll - currentSum;
                break;
              }
              currentSum += h;
              if (i == AppData.projects.length - 1) {
                newProjectIndex = i;
                offsetWithinProject = h;
              }
            }

            // Logic: Calculate State
            final project = AppData.projects[newProjectIndex];
            final int imageCount = project.galleryImages?.length ?? 0;

            // Image Index
            int newImageIndex = 0;
            if (imageCount > 0) {
              if (offsetWithinProject > (_introHeight / 2)) {
                final double imageScroll =
                    offsetWithinProject - (_introHeight / 2);
                final double totalImageScroll = imageCount * _scrollPerImage;
                final double progress = (imageScroll / totalImageScroll).clamp(
                  0.0,
                  1.0,
                );
                newImageIndex = (progress * imageCount).floor().clamp(
                  0,
                  imageCount - 1,
                );
              }
            }

            // Tech Stack Progress
            final double projectProgress =
                (offsetWithinProject / _getProjectHeight(newProjectIndex))
                    .clamp(0.0, 1.0);
            final int techCount = project.tech.length;
            final int newTechLimit = (projectProgress * techCount).ceil().clamp(
              1,
              techCount,
            );

            if (newProjectIndex != _activeProjectIndex ||
                newImageIndex != _activeImageIndex ||
                newTechLimit != _activeTechLimit) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    // Reset manual pause when switching projects
                    if (_activeProjectIndex != newProjectIndex) {
                      _isManuallyPaused = false;
                    }

                    _activeProjectIndex = newProjectIndex;
                    _activeImageIndex = newImageIndex;
                    _activeTechLimit = newTechLimit;
                  });
                }
              });
            }

            // 3. Layout Constants - INCREASED SIZE "Better and Bigger"
            // Increased from 460x940 to 480x980 for maximum impact
            final phoneWidth = 480.0;
            final phoneHeight = 980.0;
            final sideWidth = (screenWidth - phoneWidth) / 2;

            // --- DETERMINISTIC CLAMPED POSITION ---
            // Ensure targetCenter is at least 20px even if viewport is small
            double targetCenter = (viewportHeight - phoneHeight) / 2;
            if (targetCenter < 20) targetCenter = 20;

            // The phone should stick when showcaseTopInViewport reaches targetCenter
            final double calculatedTop = targetCenter - showcaseTopInViewport;

            final double topBound = 0.0;
            final double bottomBound = _totalHeight - phoneHeight;
            final double clampedTop = calculatedTop.clamp(
              topBound,
              bottomBound,
            );

            // Phone Visibility Logic
            // We consider the phone visible if a significant portion of it is in the viewport
            final phoneTopY = showcaseTopInViewport + clampedTop;
            final phoneBottomY = phoneTopY + phoneHeight;
            // Visible if top is above bottom of viewport AND bottom is below top of viewport
            final bool isPhoneInView =
                phoneTopY < viewportHeight && phoneBottomY > 0;
            // Auto-play when in view, unless manually paused
            final bool shouldPlayVideo = isPhoneInView && !_isManuallyPaused;

            // Background Sticky Logic
            final double bgClampedTop = (-showcaseTopInViewport).clamp(
              0.0,
              _totalHeight - viewportHeight,
            );

            return SizedBox(
              height: _totalHeight,
              child: Stack(
                children: [
                  // --- STICKY BACKGROUND ---
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: viewportHeight,
                    child: Transform.translate(
                      offset: Offset(0, bgClampedTop),
                      child: RepaintBoundary(
                        child: Container(
                          color: AppColors.background,
                          child: Stack(
                            children: [
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
                                        AppData
                                            .projects[_activeProjectIndex]
                                            .color,
                                        0.05,
                                      )!,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- CENTER: Sticky Phone ---
                  Positioned(
                    top: 0,
                    left: (screenWidth - phoneWidth) / 2,
                    child: Transform.translate(
                      offset: Offset(0, clampedTop),
                      child: RepaintBoundary(
                        child: _buildStickyPhone(
                          phoneWidth,
                          phoneHeight,
                          shouldPlayVideo,
                        ),
                      ),
                    ),
                  ),

                  // --- LEFT: Sticky Info ---
                  Positioned(
                    top: 0,
                    left: 0,
                    width: sideWidth,
                    height: 500,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        clampedTop + 220,
                      ), // Adjusted for bigger phone
                      child: RepaintBoundary(child: _buildLeftInfo(sideWidth)),
                    ),
                  ),

                  // --- RIGHT: Tech Stack ---
                  Positioned(
                    top: 0,
                    right: 0,
                    width: sideWidth,
                    height: 550, // Increased height for tech stack
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        clampedTop + 260,
                      ), // Adjusted for bigger phone
                      child: RepaintBoundary(child: _buildRightTech(sideWidth)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStickyPhone(double width, double height, bool isVisible) {
    final project = AppData.projects[_activeProjectIndex];
    final hasImages =
        project.galleryImages != null && project.galleryImages!.isNotEmpty;
    final hasVideo = project.videoUrl != null && project.videoUrl!.isNotEmpty;

    // Determine Image: Default to first image, or active index
    int safeIndex = 0;
    if (hasImages) {
      safeIndex = _activeImageIndex.clamp(0, project.galleryImages!.length - 1);
    }

    Widget content;
    Key key;

    if (hasVideo) {
      key = Key('${project.title}-video');
      content = Stack(
        fit: StackFit.expand,
        children: [
          ProjectVideoPlayer(videoUrl: project.videoUrl!, isVisible: isVisible),

          // Play/Pause Control Overlay
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isManuallyPaused = !_isManuallyPaused;
                });
              },
              child: Center(
                child: AnimatedOpacity(
                  opacity: _isManuallyPaused ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (hasImages) {
      key = Key('${project.title}-$safeIndex');
      content = _buildPhoneImageContent(project.galleryImages![safeIndex]);
    } else {
      // Fallback for NO IMAGES: Show Logo/Icon
      key = Key('${project.title}-logo');
      content = Container(
        color: project.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.layers_outlined,
          size: 80,
          color: Colors.white.withValues(alpha: 0.5),
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
        child: Container(
          key: key,
          color: Colors.black, // Default background behind images
          child: content,
        ),
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
                Colors.black.withValues(alpha: 0.1),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.2),
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
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                if (project.androidStoreUrl != null)
                  MagneticButton(
                    onTap: () =>
                        UrlLauncherUtils.launchURL(project.androidStoreUrl!),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.googlePlay,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                if (project.iosStoreUrl != null)
                  MagneticButton(
                    onTap: () =>
                        UrlLauncherUtils.launchURL(project.iosStoreUrl!),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.apple,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                if (project.androidStoreUrl == null &&
                    project.iosStoreUrl == null)
                  MagneticButton(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Coming Soon",
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.hourglass_empty,
                            size: 16,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildRightTech(double width) {
    final project = AppData.projects[_activeProjectIndex];

    // Use activeTechLimit as the index to show.
    // It cycles from 0 to tech.length-1 based on scroll.
    final currentIndex = (_activeTechLimit - 1).clamp(
      0,
      project.tech.length - 1,
    );
    final currentTech = project.tech[currentIndex];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.15),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Technologies",
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 32),
          // Masked Animated Slide
          ClipRect(
            child: SizedBox(
              height: 80, // Slightly increased height
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // We only want to animate the OUTGOING text with the switcher.
                  // The INCOMING text will handle its own staggered animation.

                  final outAnimation =
                      Tween<Offset>(
                        begin: const Offset(0.0, -1.0), // Slide out to top
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInQuart,
                        ),
                      );

                  final outOpacity = Tween<double>(begin: 0.0, end: 1.0)
                      .animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.linear,
                        ),
                      );

                  if (child.key != ValueKey(currentTech)) {
                    // Old text slides out AND fades out
                    return SlideTransition(
                      position: outAnimation,
                      child: FadeTransition(opacity: outOpacity, child: child),
                    );
                  } else {
                    // New text stays in place (animation handled internally)
                    // We must ensure it's visible.
                    return child;
                  }
                },
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: _buildStaggeredTechText(currentTech),
              ),
            ),
          ),
          // const SizedBox(height: 16),

          // Progress bar or indicator
          // Row(
          //   children: List.generate(project.tech.length, (index) {
          //     final isActive = index == currentIndex;
          //     return AnimatedContainer(
          //       duration: const Duration(milliseconds: 300),
          //       width: isActive ? 24 : 6,
          //       height: 6,
          //       margin: const EdgeInsets.only(right: 6),
          //       decoration: BoxDecoration(
          //         color: isActive
          //             ? project.color
          //             : AppColors.textSecondary.withOpacity(0.2),
          //         borderRadius: BorderRadius.circular(3),
          //       ),
          //     );
          //   }),
          // ),
        ],
      ),
    );
  }

  Widget _buildStaggeredTechText(String text) {
    return Row(
      key: ValueKey(text),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...text.split('').asMap().entries.map((entry) {
          final index = entry.key;
          final char = entry.value;

          // Handle spaces explicitly
          if (char == ' ') {
            return const SizedBox(width: 12);
          }

          return Text(
                char,
                style: GoogleFonts.outfit(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              )
              .animate()
              .fadeIn(duration: 1.ms, delay: (index * 60).ms) // Instant "type"
              .moveY(
                begin: 2,
                end: 0,
                duration: 50.ms,
                delay: (index * 60).ms,
              ); // Subtle key press impact
        }),
        Container(
              margin: const EdgeInsets.only(left: 4, top: 4),
              width: 3,
              height: 48,
              color: AppColors.primary,
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(duration: 300.ms)
            .fadeOut(delay: 300.ms),
      ],
    );
  }
}
