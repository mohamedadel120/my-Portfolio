import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';

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
        final isLowSpec = DeviceUtils.isLowSpecDevice(context);

        return ValueListenableBuilder<double>(
          valueListenable: widget.scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HeroCubit>().loadHeroData();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // 1. HERO SECTION (Full Viewport Height)
                    Container(
                      height: viewportHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Stack(
                        children: [
                          // Minimal Aurora Hint
                          if (!isLowSpec && heroData.showAurora)
                            Positioned(
                              top: -50,
                              right: -50,
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.05),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.1),
                                      blurRadius: 80,
                                      spreadRadius: 20,
                                    )
                                  ],
                                ),
                              )
                                  .animate(
                                      onPlay: (c) => c.repeat(reverse: true))
                                  .scale(
                                    begin: const Offset(1, 1),
                                    end: const Offset(1.2, 1.2),
                                    duration: 4000.ms,
                                  ),
                            ),

                          // Main content - Bottom Aligned
                          Positioned(
                            bottom: 100,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Role
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: _buildTitleSpans(
                                          heroData.title.toUpperCase(),
                                          context,
                                          12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      height: 1,
                                      width: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                )
                                    .animate()
                                    .fadeIn(duration: 800.ms)
                                    .slideX(begin: -0.1),

                                const SizedBox(height: 12),

                                // Giant Name
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    heroData.name.toUpperCase(),
                                    style: GoogleFonts.orbitron(
                                      fontSize: 100,
                                      height: 0.9,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      letterSpacing: -2,
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 1000.ms, delay: 200.ms)
                                    .moveY(begin: 30, end: 0),

                                const SizedBox(height: 32),

                                // Short Bio
                                Text(
                                  heroData.subtitle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    height: 1.6,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ).animate().fadeIn(delay: 400.ms),

                                const SizedBox(height: 48),

                                // Horizontal Navigation Row
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildNavAction(
                                          context,
                                          "ABOUT",
                                          () => Navigator.pushNamed(
                                              context, '/about')),
                                      const SizedBox(width: 20),
                                      _buildNavAction(
                                          context,
                                          "EXP",
                                          () => Navigator.pushNamed(
                                              context, '/experience')),
                                      const SizedBox(width: 20),
                                      _buildNavAction(
                                          context,
                                          "PROJECTS",
                                          () => Navigator.pushNamed(
                                              context, '/projects')),
                                      const SizedBox(width: 20),
                                      _buildNavAction(
                                          context,
                                          "CONTACT",
                                          () => Navigator.pushNamed(
                                              context, '/contact')),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 500.ms)
                                    .moveY(begin: 20, end: 0),

                                const SizedBox(height: 32),

                                // Download CV Button (Small Version)
                                OutlinedButton(
                                  onPressed: widget.onDownloadCV,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1.5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: Text(
                                    "DOWNLOAD CV",
                                    style: GoogleFonts.spaceMono(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ).animate().fadeIn(delay: 600.ms),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNavAction(
      BuildContext context, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTitleSpans(String text, BuildContext context, double fontSize) {
    // We want to style "DEVELOPER" specifically as requested.
    final parts = text.split('DEVELOPER');
    final List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: GoogleFonts.ibmPlexMono(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        );
      }
      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: 'DEVELOPER',
            style: GoogleFonts.jetBrainsMono(
              fontSize: fontSize,
              fontWeight: FontWeight.w500, // Medium
              color: Theme.of(context).colorScheme.primary, // Cyan
              letterSpacing: 2,
            ),
          ),
        );
      }
    }
    return spans;
  }
}
