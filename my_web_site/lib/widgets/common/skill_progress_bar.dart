import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

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
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.progress)
        .animate(CurvedAnimation(
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
    final triggerPoint = widget.sectionStartOffset - (widget.viewportHeight * 0.5) + delayOffset;
    
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
                    widget.skill,
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percentage%',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 13 : 14,
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: currentProgress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.color,
                        widget.color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 0,
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

