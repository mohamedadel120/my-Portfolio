import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_data.dart';
import '../common/magnetic_button.dart';
import '../common/scroll_to_explore_indicator.dart';
import '../common/scroll_speed_widget.dart';
import '../common/floating_code_shapes.dart';
import '../common/animated_code_particles.dart';
import '../common/code_shape.dart';
import '../common/code_snippet.dart';

class HeroSection extends StatefulWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final VoidCallback? onDownloadCV;

  const HeroSection({
    super.key,
    required this.scrollOffsetListenable,
    this.onViewProjects,
    this.onContactMe,
    this.onDownloadCV,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _auroraController;

  @override
  void initState() {
    super.initState();
    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _auroraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    const sectionStartOffset = 0.0;

    return ValueListenableBuilder<double>(
      valueListenable: widget.scrollOffsetListenable,
      builder: (context, scrollOffset, _) {
        return Container(
          height: viewportHeight,
          width: double.infinity,
          clipBehavior: Clip.none, // Allow overflow for aurora blobs
          decoration: BoxDecoration(color: AppColors.background),
          child: Stack(
            children: [
              // Aurora Background
              Positioned.fill(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _auroraController,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          _buildAuroraBlob(
                            color: AppColors.primary.withOpacity(0.15),
                            top:
                                -100 +
                                sin(_auroraController.value * 2 * pi) * 50,
                            left:
                                -100 +
                                cos(_auroraController.value * 2 * pi) * 50,
                            size: 600,
                          ),
                          _buildAuroraBlob(
                            color: AppColors.secondary.withOpacity(0.1),
                            bottom:
                                -100 -
                                sin(_auroraController.value * 2 * pi) * 50,
                            right:
                                -100 -
                                cos(_auroraController.value * 2 * pi) * 50,
                            size: 500,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Animated Code Particles (Restored)
              RepaintBoundary(
                child: AnimatedCodeParticles(
                  scrollOffset: scrollOffset,
                  particleCount: isMobile ? 30 : 60,
                ),
              ),

              // Floating Code Shapes (Restored)
              RepaintBoundary(
                child: FloatingCodeShapes(scrollOffset: scrollOffset),
              ),

              // Floating Code Snippets (Restored & Personalized)
              if (!isMobile) ...[
                Positioned(
                  top: screenWidth >= 768 && screenWidth < 1024 ? 80 : 120,
                  left: screenWidth >= 768 && screenWidth < 1024 ? 30 : 50,
                  child: RepaintBoundary(
                    child: CodeSnippet(
                      code: "const developer = 'Mohamed Adel';",
                      scrollOffset: scrollOffset,
                      delay: 1000.ms,
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenWidth >= 768 && screenWidth < 1024 ? 100 : 150,
                  right: screenWidth >= 768 && screenWidth < 1024 ? 30 : 50,
                  child: RepaintBoundary(
                    child: CodeSnippet(
                      code: "final experience = Years(3);",
                      scrollOffset: scrollOffset,
                      delay: 1200.ms,
                    ),
                  ),
                ),
                Positioned(
                  top: screenWidth >= 768 && screenWidth < 1024 ? 160 : 200,
                  right: screenWidth >= 768 && screenWidth < 1024 ? 40 : 80,
                  child: RepaintBoundary(
                    child: CodeSnippet(
                      code: "const stack = ['Flutter', 'Bloc'];",
                      scrollOffset: scrollOffset,
                      delay: 1400.ms,
                    ),
                  ),
                ),
                Positioned(
                  bottom: screenWidth >= 768 && screenWidth < 1024 ? 180 : 220,
                  left: screenWidth >= 768 && screenWidth < 1024 ? 40 : 80,
                  child: RepaintBoundary(
                    child: CodeSnippet(
                      code: "await App.launch({downloads: '10k+'});",
                      scrollOffset: scrollOffset,
                      delay: 1600.ms,
                    ),
                  ),
                ),
                Positioned(
                  top: screenWidth >= 768 && screenWidth < 1024 ? 40 : 60,
                  right: screenWidth >= 768 && screenWidth < 1024 ? 100 : 250,
                  child: RepaintBoundary(
                    child: CodeSnippet(
                      code: "class CleanCode extends Standard {}",
                      scrollOffset: scrollOffset,
                      delay: 1800.ms,
                    ),
                  ),
                ),
              ],

              // Large Code Shapes in corners (Restored & Hidden on Mobile)
              if (!isMobile) ...[
                Positioned(
                  top: screenWidth >= 768 && screenWidth < 1024 ? 40 : 50,
                  left: screenWidth >= 768 && screenWidth < 1024 ? 15 : 20,
                  child: CodeShape(
                    scrollOffset: scrollOffset,
                    type: CodeShapeType.angleBracket,
                    size: screenWidth >= 768 && screenWidth < 1024 ? 60 : 80,
                    delay: 500.ms,
                  ),
                ),
                Positioned(
                  top: screenWidth >= 768 && screenWidth < 1024 ? 120 : 150,
                  right: screenWidth >= 768 && screenWidth < 1024 ? 15 : 20,
                  child: CodeShape(
                    scrollOffset: scrollOffset,
                    type: CodeShapeType.curlyBrace,
                    size: screenWidth >= 768 && screenWidth < 1024 ? 80 : 100,
                    delay: 700.ms,
                  ),
                ),
                Positioned(
                  bottom: screenWidth >= 768 && screenWidth < 1024 ? 80 : 100,
                  left: screenWidth >= 768 && screenWidth < 1024 ? 35 : 50,
                  child: CodeShape(
                    scrollOffset: scrollOffset,
                    type: CodeShapeType.hexagon,
                    size: screenWidth >= 768 && screenWidth < 1024 ? 45 : 60,
                    delay: 900.ms,
                  ),
                ),
                Positioned(
                  bottom: screenWidth >= 768 && screenWidth < 1024 ? 150 : 200,
                  right: screenWidth >= 768 && screenWidth < 1024 ? 35 : 50,
                  child: CodeShape(
                    scrollOffset: scrollOffset,
                    type: CodeShapeType.codeBlock,
                    size: screenWidth >= 768 && screenWidth < 1024 ? 55 : 70,
                    delay: 1100.ms,
                  ),
                ),
              ],

              // Main content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Editorial "Hello"
                      ScrollSpeedWidget(
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        speed: -0.1,
                        child:
                            Text(
                                  "HELLO I'M",
                                  style: GoogleFonts.oswald(
                                    fontSize: isMobile ? 16 : 20,
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 800.ms, delay: 200.ms)
                                .slideY(begin: 0.2, end: 0),
                      ),

                      const SizedBox(height: 20),

                      // Giant Name
                      ScrollSpeedWidget(
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        speed: 0.05,
                        child:
                            TextRenderer(
                                  text: AppData.name.toUpperCase(),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppData.name.toUpperCase(),
                                      style: GoogleFonts.anton(
                                        fontSize: isMobile
                                            ? 80
                                            : 180, // Massive font
                                        height: 0.9,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -2,
                                      ),
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 1000.ms, delay: 400.ms)
                                .moveY(
                                  begin: 50,
                                  end: 0,
                                  curve: Curves.easeOutExpo,
                                ),
                      ),

                      // Role / Subtitle
                      ScrollSpeedWidget(
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        speed: -0.05,
                        child:
                            TextRenderer(
                                  text:
                                      '${AppData.title} | ${AppData.subtitle}',
                                  child: Text(
                                    '${AppData.title} & ${AppData.subtitle}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: isMobile ? 18 : 32,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white70,
                                      height: 1.5,
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 1000.ms, delay: 600.ms)
                                .slideY(begin: 0.2, end: 0),
                      ),

                      const SizedBox(height: 60),

                      // Actions
                      ScrollSpeedWidget(
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        speed: -0.1,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            MagneticButton(
                                  onTap: widget.onViewProjects ?? () {},
                                  toxicity: 0.5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      'VIEW WORK',
                                      style: GoogleFonts.oswald(
                                        color: AppColors.background,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: 1000.ms, duration: 600.ms)
                                .scale(
                                  delay: 1000.ms,
                                  curve: Curves.easeOutBack,
                                ),

                            MagneticButton(
                                  onTap: widget.onDownloadCV ?? () {},
                                  toxicity: 0.3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.download_rounded,
                                          color: AppColors.primary,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'DOWNLOAD CV',
                                          style: GoogleFonts.oswald(
                                            color: AppColors.primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: 1100.ms, duration: 600.ms)
                                .scale(
                                  delay: 1100.ms,
                                  curve: Curves.easeOutBack,
                                ),

                            MagneticButton(
                                  onTap: widget.onContactMe ?? () {},
                                  toxicity: 0.3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      'CONTACT ME',
                                      style: GoogleFonts.oswald(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: 1200.ms, duration: 600.ms)
                                .scale(
                                  delay: 1200.ms,
                                  curve: Curves.easeOutBack,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Scroll indicator
              ScrollToExploreIndicator(
                scrollOffset: scrollOffset,
                onTap: widget.onViewProjects,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuroraBlob({
    required Color color,
    required double size,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child:
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(
                    0.4,
                  ), // Reduced opacity as we use blur
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: Offset(1, 1),
                end: Offset(1.2, 1.2),
                duration: 4000.ms,
              ),
    );
  }
}
