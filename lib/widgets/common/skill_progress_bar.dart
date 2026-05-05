import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class SkillProgressBar extends StatefulWidget {
  final String skill;
  final double progress;
  final Color color;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final Duration delay;

  const SkillProgressBar({
    super.key,
    required this.skill,
    required this.progress,
    this.color = AppColors.primary,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  State<SkillProgressBar> createState() => _SkillProgressBarState();
}

class _SkillProgressBarState extends State<SkillProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  double _maxScroll = 0.0;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.progress).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _maxScroll = widget.scrollOffset;
  }

  @override
  void didUpdateWidget(SkillProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollOffset > _maxScroll) {
      _maxScroll = widget.scrollOffset;
    }
    _checkVisibility();
  }

  void _checkVisibility() {
    final delayOffset = widget.delay.inMilliseconds * 0.2;
    final triggerPoint =
        widget.sectionStartOffset - (widget.viewportHeight * 0.5) + delayOffset;

    if (_maxScroll >= triggerPoint && !_hasAnimated) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _checkVisibility();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final currentProgress = _progressAnimation.value;
        final percentage = (currentProgress * 100).toInt();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    widget.skill.toUpperCase(),
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 4, // Thinner, more elegant
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: currentProgress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withValues(alpha: 0.3),
                        widget.color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.8),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
