import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../features/projects/domain/entities/project_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../project_image_gallery.dart';

class ProjectGallery extends StatefulWidget {
  final Project project;
  final bool isVisible;
  final Duration delay;
  final bool isHovered;

  const ProjectGallery({
    super.key,
    required this.project,
    required this.isVisible,
    required this.delay,
    required this.isHovered,
  });

  @override
  State<ProjectGallery> createState() => _ProjectGalleryState();
}

class _ProjectGalleryState extends State<ProjectGallery>
    with SingleTickerProviderStateMixin {
  ScrollController? _thumbnailScrollController;
  AnimationController? _scrollAnimationController;
  Animation<double>? _scrollAnimation;
  bool _isUserInteracting = false;
  bool _isScrollingForward = true;

  @override
  void initState() {
    super.initState();
    if (widget.project.galleryImages != null &&
        widget.project.galleryImages!.isNotEmpty) {
      _thumbnailScrollController = ScrollController();
      _scrollAnimationController = AnimationController(
        duration: const Duration(seconds: 15),
        vsync: this,
      );

      _scrollAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _scrollAnimationController!,
          curve: Curves.linear,
        ),
      );

      _scrollAnimation!.addListener(_updateScrollPosition);

      _scrollAnimationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed && !_isUserInteracting) {
          _isScrollingForward = false;
          _scrollAnimationController!.reverse();
        } else if (status == AnimationStatus.dismissed && !_isUserInteracting) {
          _isScrollingForward = true;
          _scrollAnimationController!.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(ProjectGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHovered && !oldWidget.isHovered) {
      _startContinuousScroll();
    } else if (!widget.isHovered && oldWidget.isHovered) {
      _pauseAutoScroll();
    }
  }

  void _startContinuousScroll() {
    if (_thumbnailScrollController != null &&
        _scrollAnimationController != null &&
        _thumbnailScrollController!.hasClients) {
      final maxScroll = _thumbnailScrollController!.position.maxScrollExtent;
      if (maxScroll > 0 && !_scrollAnimationController!.isAnimating) {
        final currentPosition = _thumbnailScrollController!.position.pixels;
        if (currentPosition <= 0) {
          _isScrollingForward = true;
          _thumbnailScrollController!.jumpTo(0);
          _scrollAnimationController!.forward();
        } else if (currentPosition >= maxScroll) {
          _isScrollingForward = false;
          _thumbnailScrollController!.jumpTo(maxScroll);
          _scrollAnimationController!.reverse();
        } else {
          if (_isScrollingForward) {
            _scrollAnimationController!.forward();
          } else {
            _scrollAnimationController!.reverse();
          }
        }
        _isUserInteracting = false;
      }
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted &&
            _thumbnailScrollController != null &&
            _scrollAnimationController != null &&
            _thumbnailScrollController!.hasClients &&
            widget.isHovered) {
          _startContinuousScroll();
        }
      });
    }
  }

  void _updateScrollPosition() {
    if (!_isUserInteracting &&
        _thumbnailScrollController != null &&
        _scrollAnimation != null &&
        _thumbnailScrollController!.hasClients) {
      final maxScroll = _thumbnailScrollController!.position.maxScrollExtent;
      if (maxScroll > 0) {
        final scrollPosition = _scrollAnimation!.value * maxScroll;
        _thumbnailScrollController!.jumpTo(scrollPosition);
      }
    }
  }

  void _pauseAutoScroll() {
    _isUserInteracting = true;
    _scrollAnimationController?.stop();
  }

  void _resumeAutoScroll() {
    _isUserInteracting = false;
    if (widget.isHovered && _scrollAnimationController != null) {
      if (_isScrollingForward) {
        _scrollAnimationController!.forward();
      } else {
        _scrollAnimationController!.reverse();
      }
    }
  }

  @override
  void dispose() {
    _thumbnailScrollController?.dispose();
    _scrollAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    if (widget.project.galleryImages != null &&
        widget.project.galleryImages!.isNotEmpty) {
      return _buildScrollableGallery(isMobile, isTablet, screenWidth);
    } else if (widget.project.logoUrl != null ||
        widget.project.imageUrl != null) {
      return _buildStaticImage();
    }
    return const SizedBox.shrink();
  }

  Widget _buildScrollableGallery(
      bool isMobile, bool isTablet, double screenWidth) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProjectImageGallery(
            images: widget.project.galleryImages!,
            projectTitle: widget.project.title,
            projectColor: widget.project.color,
          ),
        );
      },
      onTapDown: (_) => _pauseAutoScroll(),
      onTapUp: (_) => _resumeAutoScroll(),
      onTapCancel: () => _resumeAutoScroll(),
      child: MouseRegion(
        onEnter: (_) => _pauseAutoScroll(),
        onExit: (_) => _resumeAutoScroll(),
        child: Container(
          margin: EdgeInsets.only(
            bottom: isMobile ? 4 : (isTablet ? 6 : 8),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.project.color.withValues(
                alpha: widget.isHovered ? 0.4 : 0.25,
              ),
              width: widget.isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: widget.isHovered ? 0.08 : 0.04,
                ),
                blurRadius: widget.isHovered ? 8 : 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            // Use screenWidth-based sizing instead of LayoutBuilder
            // to prevent layout re-entrancy issues
            child: Builder(
              builder: (context) {
                // Calculate available width based on screen size and layout
                // ProjectCard padding is ~20-28px, gallery has additional margins
                final cardPadding = isMobile ? 20.0 : (isTablet ? 24.0 : 28.0);
                // Assume container takes most of screen width minus card padding and margin
                final availableWidth = screenWidth - (cardPadding * 2) - 40;

                final crossAxisCount = isMobile ? 2 : 3;
                const crossAxisSpacing = 4.0;
                final itemCount = widget.project.galleryImages!.length;
                final thumbnailItemWidth =
                    (availableWidth - (crossAxisCount - 1) * crossAxisSpacing) /
                        crossAxisCount;
                final thumbnailItemHeight =
                    thumbnailItemWidth.clamp(60.0, 200.0);

                return SizedBox(
                  height: thumbnailItemHeight,
                  child: GestureDetector(
                    onVerticalDragUpdate: (_) {},
                    onVerticalDragEnd: (_) {},
                    onVerticalDragCancel: () {},
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) => true,
                      child: ListView.builder(
                        controller: _thumbnailScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          final dpr = MediaQuery.of(context).devicePixelRatio;
                          final decodeWidth =
                              (thumbnailItemWidth * dpr).round();
                          final decodeHeight =
                              (thumbnailItemHeight * dpr).round();
                          return Container(
                            width: thumbnailItemWidth,
                            margin: EdgeInsets.only(
                              right:
                                  index < itemCount - 1 ? crossAxisSpacing : 0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Hero(
                                tag:
                                    'project_gallery_image_${widget.project.title}_$index',
                                child: widget.project.galleryImages![index].startsWith('http')
                                    ? Image.network(
                                        widget.project.galleryImages![index],
                                        fit: BoxFit.cover,
                                        cacheWidth: decodeWidth,
                                        cacheHeight: decodeHeight,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(
                                          color: AppColors.background,
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            size: 30,
                                            color: widget.project.color
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      )
                                    : Image.asset(
                                        widget.project.galleryImages![index],
                                        fit: BoxFit.cover,
                                        cacheWidth: decodeWidth,
                                        cacheHeight: decodeHeight,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(
                                          color: AppColors.background,
                                          child: Icon(
                                            Icons.broken_image_rounded,
                                            size: 30,
                                            color: widget.project.color
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      )
          .animate(autoPlay: widget.isVisible)
          .fadeIn(delay: widget.delay + 100.ms, duration: 600.ms)
          .scale(
            delay: widget.delay + 100.ms,
            begin: const Offset(0.9, 0.9),
            duration: 600.ms,
          ),
    );
  }

  Widget _buildStaticImage() {
    return Container(
      height: 110,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.project.color.withValues(
            alpha: widget.isHovered ? 0.4 : 0.25,
          ),
          width: widget.isHovered ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: widget.isHovered ? 0.06 : 0.03),
            blurRadius: widget.isHovered ? 8 : 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.project.logoUrl != null)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.background,
                      widget.project.color.withValues(alpha: 0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: widget.project.logoUrl!.startsWith('http')
                      ? Image.network(
                          widget.project.logoUrl!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              _ErrorPlaceholder(color: widget.project.color),
                        )
                      : Image.asset(
                          widget.project.logoUrl!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              _ErrorPlaceholder(color: widget.project.color),
                        ),
                ),
              )
            else if (widget.project.imageUrl != null)
              Hero(
                tag: 'project_image_${widget.project.title}',
                child: Image.network(
                  widget.project.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _ErrorPlaceholder(color: widget.project.color),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _LoadingPlaceholder(
                      color: widget.project.color,
                      progress: loadingProgress,
                    );
                  },
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    widget.project.color.withValues(
                      alpha: widget.isHovered ? 0.15 : 0,
                    ),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(autoPlay: widget.isVisible)
        .fadeIn(delay: widget.delay + 100.ms, duration: 600.ms)
        .scale(
          delay: widget.delay + 100.ms,
          begin: const Offset(0.9, 0.9),
          duration: 600.ms,
        );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final Color color;
  const _ErrorPlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.background, color.withValues(alpha: 0.2)],
        ),
      ),
      child: Center(
        child: Icon(Icons.broken_image_rounded, size: 45, color: color),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final Color color;
  final ImageChunkEvent progress;
  const _LoadingPlaceholder({required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.background, color.withValues(alpha: 0.1)],
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null,
          color: color,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}
