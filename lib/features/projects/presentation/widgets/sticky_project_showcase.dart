import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/device_utils.dart';
import '../../../../utils/url_launcher_utils.dart';
import '../../../../widgets/common/magnetic_button.dart';
import '../../../../widgets/common/phone_frame.dart';
import '../../domain/entities/project_entity.dart';
import '../../../../widgets/common/project_video_player.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/services/analytics_service.dart';

class StickyProjectShowcase extends StatefulWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final List<Project> projects;

  const StickyProjectShowcase({
    super.key,
    required this.scrollOffsetListenable,
    required this.projects,
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
  bool _hasCalculatedPosition = false;

  double? _lastScreenWidth;
  double? _lastScreenHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleMeasurePosition();
  }

  void _scheduleMeasurePosition() {
    // Initial measure on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final scrollValue = widget.scrollOffsetListenable.value;
        final screenPos = box.localToGlobal(Offset.zero);
        setState(() {
          _absoluteTop = screenPos.dy + scrollValue;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Config
  final double _introHeight = 1400.0;
  final double _scrollPerImage = 800.0;

  double _getProjectHeight(int index) {
    if (index >= widget.projects.length) return 0;
    final project = widget.projects[index];
    double h = _introHeight;
    if (project.galleryImages != null && project.galleryImages!.isNotEmpty) {
      h += (project.galleryImages!.length * _scrollPerImage);
    }
    return h;
  }

  double get _totalHeight {
    double total = 0;
    for (int i = 0; i < widget.projects.length; i++) {
      total += _getProjectHeight(i);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive Config
    final isXS = DeviceUtils.isExtraSmall(screenWidth);
    final isMobile = DeviceUtils.isMobile(screenWidth);
    final isTablet = DeviceUtils.isTablet(screenWidth);
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);

    // Guard against empty projects
    if (widget.projects.isEmpty) {
      return const SizedBox.shrink(); // Or generic empty state
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;

        return ValueListenableBuilder<double>(
          valueListenable: widget.scrollOffsetListenable,
          builder: (context, scrollOffset, child) {
            final viewportHeight = MediaQuery.of(context).size.height;

            // --- DETERMINISTIC STICKY LOGIC ---
            // Continuously update absoluteTop without setState to avoid lag and layout shift bugs
            final box = context.findRenderObject() as RenderBox?;
            if (box != null && box.hasSize) {
              _absoluteTop = box.localToGlobal(Offset.zero).dy + scrollOffset;
            }
            final discoveredTop = _absoluteTop ?? 4000.0;
            final double showcaseTopInViewport = discoveredTop - scrollOffset;

            // 2. How much the user has scrolled INTO this specific showcase
            final double relativeScroll = -showcaseTopInViewport;

            int newProjectIndex = 0;
            double currentSum = 0;
            double offsetWithinProject = 0;

            for (int i = 0; i < widget.projects.length; i++) {
              final double h = _getProjectHeight(i);
              if (relativeScroll < (currentSum + h)) {
                newProjectIndex = i;
                offsetWithinProject = relativeScroll - currentSum;
                break;
              }
              currentSum += h;
              if (i == widget.projects.length - 1) {
                newProjectIndex = i;
                offsetWithinProject = h;
              }
            }

            // Logic: Calculate State
            final project = widget.projects[newProjectIndex];
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

            // Update state directly without triggering a rebuild via setState
            // ValueListenableBuilder already rebuilds when scrollOffset changes
            // This avoids the layout-during-layout issue
            if (newProjectIndex != _activeProjectIndex) {
              _isManuallyPaused = false;
            }
            _activeProjectIndex = newProjectIndex;
            _activeImageIndex = newImageIndex;
            _activeTechLimit = newTechLimit;

            // 3. Layout Constants - Responsive Sizing
            const double phoneAspectRatio = 19.5 / 9;

            double phoneWidth;
            double phoneHeight;

            if (isXS) {
              final calcWidth = screenWidth * 0.7;
              phoneWidth = calcWidth > 240 ? 240 : calcWidth;
              phoneHeight = phoneWidth * phoneAspectRatio;
            } else if (isMobile) {
              final calcWidth = screenWidth * 0.65;
              phoneWidth = calcWidth > 280 ? 280 : calcWidth;
              phoneHeight = phoneWidth * phoneAspectRatio;
            } else if (isTablet) {
              phoneWidth = 260.0;
              phoneHeight = phoneWidth * phoneAspectRatio;
            } else {
              phoneWidth = 300.0;
              phoneHeight = phoneWidth * phoneAspectRatio;
            }

            // [FIX] Ensure aspect ratio is preserved if height is constrained
            final double maxMobilePhoneHeight =
                isMobile ? viewportHeight * 0.55 : viewportHeight * 0.70;

            if (phoneHeight > maxMobilePhoneHeight) {
              // If height exceeds limit, cap height and reduce width to match ratio
              phoneHeight = maxMobilePhoneHeight;
              phoneWidth = phoneHeight / phoneAspectRatio;
            }

            final safePhoneHeight = phoneHeight;

            final sideWidth = (containerWidth - phoneWidth) / 2;

            double targetCenter =
                isMobile ? 60 : (viewportHeight - safePhoneHeight) / 2;
            if (targetCenter < 20) targetCenter = 20;

            final double calculatedTop = targetCenter - showcaseTopInViewport;

            final double topBound = 0.0;
            final double bottomBound = _totalHeight - safePhoneHeight;
            final double clampedTop = calculatedTop.clamp(
              topBound,
              bottomBound,
            );

            final phoneTopY = showcaseTopInViewport + clampedTop;
            final phoneBottomY = phoneTopY + phoneHeight;
            final bool isPhoneInView =
                phoneTopY < viewportHeight && phoneBottomY > 0;
            final bool shouldPlayVideo = isPhoneInView && !_isManuallyPaused;

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
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 1000),
                                decoration: BoxDecoration(
                                  gradient: isLowSpec
                                      ? null
                                      : RadialGradient(
                                          center: Alignment.center,
                                          radius: 0.8,
                                          colors: [
                                            Color.lerp(
                                              Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              widget
                                                  .projects[_activeProjectIndex]
                                                  .color,
                                              0.15,
                                            )!,
                                            Theme.of(context)
                                                .scaffoldBackgroundColor
                                                .withValues(alpha: 0.0),
                                          ],
                                          stops: const [0.2, 1.0],
                                        ),
                                  color: isLowSpec
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : null,
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
                    left: (containerWidth - phoneWidth) / 2,
                    child: Transform.translate(
                      offset: Offset(0, clampedTop),
                      child: RepaintBoundary(
                        child: _buildStickyPhone(
                          phoneWidth,
                          safePhoneHeight,
                          shouldPlayVideo,
                        ),
                      ),
                    ),
                  ),

                  // --- INFO: Left (Desktop) or Bottom Overlay (Mobile) ---
                  if (isMobile)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: viewportHeight,
                      child: Transform.translate(
                        offset: Offset(0, bgClampedTop),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildMobileInfoOverlay(),
                        ),
                      ),
                    )
                  else
                    Positioned(
                      top: 0,
                      left: 0,
                      width: sideWidth,
                      height: safePhoneHeight,
                      child: Transform.translate(
                        offset: Offset(0, clampedTop),
                        child:
                            RepaintBoundary(child: _buildLeftInfo(sideWidth)),
                      ),
                    ),

                  // --- RIGHT: Tech Stack (Hidden on Mobile) ---
                  if (!isMobile)
                    Positioned(
                      top: 0,
                      right: 0,
                      width: sideWidth,
                      height: safePhoneHeight,
                      child: Transform.translate(
                        offset: Offset(0, clampedTop),
                        child: RepaintBoundary(
                          child: _buildRightTech(sideWidth),
                        ),
                      ),
                    ),

                  // --- RIGHT SIDE NAV (Dashes) ---
                  Positioned(
                    top: 0,
                    right: isMobile ? 16 : 100, // Closer to edge on mobile
                    height: viewportHeight,
                    child: Transform.translate(
                      offset: Offset(0, bgClampedTop),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildProjectNavDots(isMobile),
                      ),
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
    final project = widget.projects[_activeProjectIndex];
    final hasImages =
        project.galleryImages != null && project.galleryImages!.isNotEmpty;
    final hasVideo = project.videoUrl != null && project.videoUrl!.isNotEmpty;

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
          color: Colors.black,
          child: content,
        ),
      ),
    );
  }

  Widget _buildPhoneImageContent(String imagePath) {
    return Stack(
      fit: StackFit.expand,
      children: [
        imagePath.startsWith('http')
            ? Image.network(imagePath, fit: BoxFit.cover)
            : Image.asset(imagePath, fit: BoxFit.cover),
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
    final project = widget.projects[_activeProjectIndex];
    return Container(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.15 + 30),
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Column(
          key: Key('left-${project.title}'),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                project.title,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: width > 300 ? 56 : 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.0,
                ),
              ),
            ).animate().fadeIn().slideX(begin: -0.2),
            const SizedBox(height: 24),
            Text(
              project.description,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
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
                    onTap: () {
                      di.sl<AnalyticsService>().logProjectClick(project.title);
                      UrlLauncherUtils.launchURL(project.androidStoreUrl!);
                    },
                    child: const _StoreIconButton(
                      icon: FontAwesomeIcons.googlePlay,
                    ),
                  ),
                if (project.iosStoreUrl != null)
                  MagneticButton(
                    onTap: () {
                      di.sl<AnalyticsService>().logProjectClick(project.title);
                      UrlLauncherUtils.launchURL(project.iosStoreUrl!);
                    },
                    child: const _StoreIconButton(icon: FontAwesomeIcons.apple),
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
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Coming Soon",
                            style: GoogleFonts.jetBrainsMono(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.hourglass_empty,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface,
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
    final project = widget.projects[_activeProjectIndex];
    final currentIndex = (_activeTechLimit - 1).clamp(
      0,
      project.tech.length - 1,
    );
    final currentTech = project.tech[currentIndex];

    return Container(
      padding: EdgeInsets.only(left: width * 0.15 + 30, right: width * 0.05),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Technologies",
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              color: Theme.of(
                context,
              )
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8), // Increased opacity
              letterSpacing: 2,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 4,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ClipRect(
            child: SizedBox(
              height: 80,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final outAnimation = Tween<Offset>(
                    begin: const Offset(0.0, -1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInQuart,
                    ),
                  );
                  final outOpacity =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.linear,
                    ),
                  );

                  if (child.key != ValueKey(currentTech)) {
                    return SlideTransition(
                      position: outAnimation,
                      child: FadeTransition(opacity: outOpacity, child: child),
                    );
                  } else {
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
        ],
      ),
    );
  }

  Widget _buildStaggeredTechText(String text) {
    final fontSize = text.length > 10 ? 36.0 : 48.0;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        key: ValueKey(text),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...text.split('').asMap().entries.map((entry) {
            final index = entry.key;
            final char = entry.value;
            if (char == ' ') {
              return SizedBox(width: fontSize * 0.25);
            }
            return Text(
              char,
              style: GoogleFonts.jetBrainsMono(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.1,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 4,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 1.ms, delay: (index * 60).ms).moveY(
                  begin: 2,
                  end: 0,
                  duration: 50.ms,
                  delay: (index * 60).ms,
                );
          }),
          Container(
            margin: const EdgeInsets.only(left: 4, top: 4),
            width: 3,
            height: fontSize,
            color: Theme.of(context).colorScheme.primary,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(duration: 300.ms)
              .fadeOut(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildMobileInfoOverlay() {
    final project = widget.projects[_activeProjectIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final isXS = DeviceUtils.isExtraSmall(screenWidth);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        // Optional: Rounded corners at the top for a "card" feel
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isXS ? 24 : 36,
                    0,
                    isXS
                        ? 80
                        : 100, // Significant gutter for the ScrollIndicator
                    isXS ? 40 : 50,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        project.title.toUpperCase(),
                        key: ValueKey('title-${project.title}'),
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: isXS
                              ? 28
                              : 38, // Further reduced for better balance
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.0,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 12),

                      // Description
                      Text(
                        project.description,
                        key: ValueKey('desc-${project.title}'),
                        maxLines: 6, // Allow even more lines
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: isXS
                              ? 13
                              : 15, // Slightly smaller for premium feel
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                      const SizedBox(height: 24),

                      // Buttons
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          if (project.androidStoreUrl != null)
                            _GlassIconButton(
                              icon: FontAwesomeIcons.googlePlay,
                              onTap: () {
                                di.sl<AnalyticsService>().logProjectClick(project.title);
                                UrlLauncherUtils.launchURL(project.androidStoreUrl!);
                              },
                            ),
                          if (project.iosStoreUrl != null)
                            _GlassIconButton(
                              icon: FontAwesomeIcons.apple,
                              onTap: () {
                                di.sl<AnalyticsService>().logProjectClick(project.title);
                                UrlLauncherUtils.launchURL(project.iosStoreUrl!);
                              },
                            ),
                          if (project.androidStoreUrl == null &&
                              project.iosStoreUrl == null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white30),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Coming Soon",
                                style: GoogleFonts.jetBrainsMono(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 300.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS: Project Nav Dots ---
  Widget _buildProjectNavDots(bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(widget.projects.length, (index) {
        final isActive = index == _activeProjectIndex;
        final project = widget.projects[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_absoluteTop != null) {
                double targetOffset = _absoluteTop!;
                for (int i = 0; i < index; i++) {
                  targetOffset += _getProjectHeight(i);
                }

                final scrollController =
                    PrimaryScrollController.maybeOf(context);
                if (scrollController != null && scrollController.hasClients) {
                  scrollController.animateTo(
                    targetOffset + 10, // add a small buffer
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  );
                }
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              margin: EdgeInsets.symmetric(vertical: isMobile ? 0 : 8), // Remove vertical margin to use padding instead for bigger touch target
              padding: EdgeInsets.only(
                right: isMobile ? 12 : 12, // Keep some padding on the right for edge buffer
                left: isMobile ? 32 : 0,   // Big invisible padding on the left for easy tapping!
                top: isMobile ? 12 : 0,    // Vertical tap target
                bottom: isMobile ? 12 : 0,
              ),
              decoration: BoxDecoration(
                border: isMobile
                    ? null
                    : Border(
                        right: BorderSide(
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
              ),
              child: isMobile
                  ? AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: isActive ? 6 : 4,
                      height: isActive ? 24 : 12,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                    )
                  : AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.w400,
                        letterSpacing: 1.2,
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.4),
                      ),
                      child: Text(project.title.toUpperCase()),
                    ),
            ),
          ),
        );
      }),
    );
  }
}

class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? Colors.black : Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _StoreIconButton extends StatefulWidget {
  final IconData icon;
  const _StoreIconButton({required this.icon});
  @override
  State<_StoreIconButton> createState() => _StoreIconButtonState();
}

class _StoreIconButtonState extends State<_StoreIconButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        transform: Matrix4.identity()
          ..multiply(Matrix4.diagonal3Values(
              _isHovered ? 1.1 : 1.0, _isHovered ? 1.1 : 1.0, 1.0)),
        decoration: BoxDecoration(
          color: _isHovered
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: _isHovered
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          widget.icon,
          size: 20,
          color: _isHovered
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
