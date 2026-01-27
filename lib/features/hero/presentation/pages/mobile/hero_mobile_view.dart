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
import '../../../../../widgets/navigation/mobile_menu_section.dart';
import '../../cubit/hero_cubit.dart';
import '../../cubit/hero_state.dart';

class HeroMobileView extends StatefulWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final VoidCallback? onDownloadCV;

  const HeroMobileView({
    super.key,
    required this.scrollOffsetListenable,
    this.onViewProjects,
    this.onContactMe,
    this.onDownloadCV,
  });

  @override
  State<HeroMobileView> createState() => _HeroMobileViewState();
}

class _HeroMobileViewState extends State<HeroMobileView>
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
        final isXS = DeviceUtils.isExtraSmall(screenWidth);
        final isLowSpec = DeviceUtils.isLowSpecDevice(context);

        const sectionStartOffset = 0.0;

        return ValueListenableBuilder<double>(
          valueListenable: widget.scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return RefreshIndicator(
              onRefresh: () async {
                // Trigger a reload of the hero data
                context.read<HeroCubit>().loadHeroData();
                // Add a small delay to let the animation play
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Ensure scroll even if content fits
                child: Column(
                  children: [
                    // 1. HERO SECTION (Full Viewport Height)
                    Container(
                      height: viewportHeight, // Fixed height for hero part
                      width: double.infinity,
                      clipBehavior: Clip.none,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
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
                                              size: 400,
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
                                              size: 300,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                            ),
                          ),

                          // Animated Code Particles
                          Positioned.fill(
                            child: RepaintBoundary(
                              child: AnimatedCodeParticles(
                                scrollOffset: scrollOffset,
                                particleCount: isLowSpec ? 10 : 30,
                              ),
                            ),
                          ),

                          // Floating Code Shapes
                          Positioned.fill(
                            child: RepaintBoundary(
                              child: FloatingCodeShapes(
                                  scrollOffset: scrollOffset),
                            ),
                          ),

                          // Main content
                          Padding(
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
                                      fontSize: 16,
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
                                          fontSize: isXS ? 60 : 100,
                                          height: 0.9,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
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
                                  child: TextRenderer(
                                    text:
                                        '${heroData.title} | ${heroData.subtitle}',
                                    child: Text(
                                      '${heroData.title} & ${heroData.subtitle}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: isXS ? 14 : 18,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white70,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 60),

                                // Actions
                                ScrollSpeedWidget(
                                  scrollOffset: scrollOffset,
                                  sectionStartOffset: sectionStartOffset,
                                  speed: isLowSpec ? 0 : -0.1,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: isXS ? 12 : 20,
                                    runSpacing: isXS ? 12 : 20,
                                    children: [
                                      MagneticButton(
                                        onTap: widget.onViewProjects ?? () {},
                                        toxicity: isLowSpec ? 0 : 0.5,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isXS ? 28 : 40,
                                            vertical: isXS ? 14 : 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            'VIEW WORK',
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: isXS ? 14 : 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      MagneticButton(
                                        onTap: widget.onDownloadCV ?? () {},
                                        toxicity: isLowSpec ? 0 : 0.3,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isXS ? 28 : 40,
                                            vertical: isXS ? 14 : 20,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.download_rounded,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                size: isXS ? 16 : 18,
                                              ),
                                              SizedBox(width: isXS ? 6 : 8),
                                              Text(
                                                'DOWNLOAD CV',
                                                style: GoogleFonts.oswald(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: isXS ? 14 : 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      MagneticButton(
                                        onTap: widget.onContactMe ?? () {},
                                        toxicity: isLowSpec ? 0 : 0.3,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isXS ? 28 : 40,
                                            vertical: isXS ? 14 : 20,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.24),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            'CONTACT ME',
                                            style: GoogleFonts.oswald(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontSize: isXS ? 14 : 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Scroll indicator
                          ScrollToExploreIndicator(
                            scrollOffset: scrollOffset,
                            onTap: widget.onViewProjects,
                          ),
                        ],
                      ),
                    ),

                    // 2. MENU SECTION (Below the fold)
                    const MobileMenuSection(),
                  ],
                ),
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
