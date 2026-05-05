import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class AboutCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Duration delay;
  final bool isVisible;

  const AboutCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    required this.isVisible,
  });

  @override
  State<AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return RepaintBoundary(
      child:
          MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: 300.ms,
                  transform: _isHovered
                      ? (Matrix4.identity()..multiply(Matrix4.translationValues(0, -10, 0)))
                      : Matrix4.identity(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: isMobile ? 5 : 10, // Reduced on mobile
                        sigmaY: isMobile ? 5 : 10,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(
                          isMobile ? 20 : (isTablet ? 24 : 32),
                        ),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.surface.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isHovered
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : AppColors.primary.withValues(alpha: 0.1),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _isHovered
                                  ? AppColors.primary.withValues(alpha: 0.2)
                                  : Colors.transparent,
                              blurRadius: 30,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                                  duration: 300.ms,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _isHovered
                                        ? AppColors.primary
                                        : AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    widget.icon,
                                    color: _isHovered
                                        ? Colors.white
                                        : AppColors.primary,
                                    size: 28,
                                  ),
                                )
                                .animate(autoPlay: widget.isVisible)
                                .scale(delay: widget.delay, duration: 600.ms)
                                .then()
                                .shimmer(
                                  duration: 1500.ms,
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                ),
                            const SizedBox(height: 20),
                            Text(
                              widget.title,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: isMobile ? 18 : (isTablet ? 20 : 22),
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.description,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: isMobile ? 13 : 14,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .animate(autoPlay: widget.isVisible)
              .fadeIn(delay: widget.delay, duration: 800.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                delay: widget.delay,
                duration: 800.ms,
              ),
    );
  }
}
