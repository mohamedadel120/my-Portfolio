import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';
import '../../../../../widgets/common/magnetic_button.dart';
import '../../../../../widgets/common/scroll_to_explore_indicator.dart';
import '../../../../../widgets/common/scroll_speed_widget.dart';
import '../../../../../widgets/common/animated_code_particles.dart';
import '../../../../../widgets/common/floating_code_shapes.dart';
import '../../../../../widgets/common/code_shape.dart';
import '../../../../../widgets/common/code_snippet.dart';
import '../../cubit/hero_cubit.dart';
import '../../cubit/hero_state.dart';
import '../../../../../../widgets/navigation/custom_nav_bar.dart';
import '../../../../../../widgets/common/code_styled_subtitle.dart';

class HeroDesktopView extends StatefulWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final VoidCallback? onDownloadCV;

  const HeroDesktopView({
    super.key,
    required this.scrollOffsetListenable,
    this.onViewProjects,
    this.onContactMe,
    this.onDownloadCV,
  });

  @override
  State<HeroDesktopView> createState() => _HeroDesktopViewState();
}

class _HeroDesktopViewState extends State<HeroDesktopView>
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
    return BlocBuilder<HeroCubit, HeroState>(
      builder: (context, state) {
        if (state is HeroLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HeroError) {
          return Center(child: Text(state.message));
        }

        final heroData = (state as HeroLoaded).heroData;

        final viewportHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final isLowSpec = DeviceUtils.isLowSpecDevice(context);

        const sectionStartOffset = 0.0;

        return ValueListenableBuilder<double>(
          valueListenable: widget.scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return Container(
              height: viewportHeight,
              width: double.infinity,
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Stack(
                children: [
                  // Aurora Background
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: isLowSpec || !heroData.showAurora
                          ? Container()
                          : AnimatedBuilder(
                              animation: _auroraController,
                              builder: (context, child) {
                                return Stack(
                                  children: [
                                    _buildAuroraBlob(
                                      color: Theme.of(
                                        context,
                                      )
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.15),
                                      top: -100 +
                                          sin(_auroraController.value *
                                                  2 *
                                                  pi) *
                                              50,
                                      left: -100 +
                                          cos(_auroraController.value *
                                                  2 *
                                                  pi) *
                                              50,
                                      size: 600,
                                    ),
                                    _buildAuroraBlob(
                                      color: Theme.of(
                                        context,
                                      )
                                          .colorScheme
                                          .secondary
                                          .withValues(alpha: 0.1),
                                      bottom: -100 -
                                          sin(_auroraController.value *
                                                  2 *
                                                  pi) *
                                              50,
                                      right: -100 -
                                          cos(_auroraController.value *
                                                  2 *
                                                  pi) *
                                              50,
                                      size: 500,
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ),

                  // Animated Code Particles
                  RepaintBoundary(
                    child: AnimatedCodeParticles(
                      scrollOffset: scrollOffset,
                      particleCount: isLowSpec ? 10 : 60,
                    ),
                  ),

                  // Floating Code Shapes
                  RepaintBoundary(
                    child: FloatingCodeShapes(scrollOffset: scrollOffset),
                  ),

                  // Floating Code Snippets
                  Positioned(
                    top: screenWidth >= 768 && screenWidth < 1024 ? 80 : 120,
                    left: screenWidth >= 768 && screenWidth < 1024 ? 30 : 50,
                    child: RepaintBoundary(
                      child: CodeSnippet(
                        code: "const developer = '${heroData.name}';",
                        scrollOffset: scrollOffset,
                        delay: 1000.ms,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom:
                        screenWidth >= 768 && screenWidth < 1024 ? 100 : 150,
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
                    bottom:
                        screenWidth >= 768 && screenWidth < 1024 ? 180 : 220,
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

                  // Large Code Shapes in corners
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
                    bottom:
                        screenWidth >= 768 && screenWidth < 1024 ? 150 : 200,
                    right: screenWidth >= 768 && screenWidth < 1024 ? 35 : 50,
                    child: CodeShape(
                      scrollOffset: scrollOffset,
                      type: CodeShapeType.codeBlock,
                      size: screenWidth >= 768 && screenWidth < 1024 ? 55 : 70,
                      delay: 1100.ms,
                    ),
                  ),

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
                            speed: isLowSpec ? 0 : -0.1,
                            child: Text(
                              heroData.helloGreeting,
                              style: GoogleFonts.oswald(
                                fontSize: 20,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),

                          // Opening Bracket
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 100, bottom: 20),
                              child: Text(
                                '[',
                                style: TextStyle(
                                  fontFamily: 'FiraCode',
                                  fontSize: 60,
                                  fontWeight: FontWeight.w100,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Giant Name
                          ScrollSpeedWidget(
                            scrollOffset: scrollOffset,
                            sectionStartOffset: sectionStartOffset,
                            speed: isLowSpec ? 0 : 0.05,
                            child: TextRenderer(
                              text: heroData.name.toUpperCase(),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  heroData.name.toUpperCase(),
                                  style: GoogleFonts.anton(
                                    fontSize: 180,
                                    height: 0.9,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    letterSpacing: -2,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Role / Subtitle
                          ScrollSpeedWidget(
                            scrollOffset: scrollOffset,
                            sectionStartOffset: sectionStartOffset,
                            speed: isLowSpec ? 0 : -0.05,
                            child: CodeStyledSubtitle(
                              title: heroData.title,
                              subtitle: heroData.subtitle,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // "runPortfolio();" Text Label
                          ScrollSpeedWidget(
                            scrollOffset: scrollOffset,
                            sectionStartOffset: sectionStartOffset,
                            speed: isLowSpec ? 0 : -0.1,
                            child: Column(
                              children: [
                                Text(
                                  'discripe my world',
                                  style: GoogleFonts.firaCode(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const CustomNavBar(),
                              ],
                            ),
                          ),

                          // Code Decoration Bracket (Bottom Right of actions)
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                ']',
                                style: TextStyle(
                                  fontFamily: 'FiraCode',
                                  fontSize: 60,
                                  fontWeight: FontWeight.w100,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Download CV Button - Bottom Right
                  Positioned(
                    bottom: 40,
                    right: 40,
                    child: MagneticButton(
                      onTap: widget.onDownloadCV ?? () {},
                      toxicity: 0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Download CV',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.download_rounded,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
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
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.4),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.6),
              blurRadius: 100,
              spreadRadius: 20,
            ),
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 4000.ms,
          ),
    );
  }
}
