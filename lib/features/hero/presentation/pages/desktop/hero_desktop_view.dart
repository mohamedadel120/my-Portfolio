import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';
import '../../../../../widgets/common/magnetic_button.dart';
import '../../cubit/hero_cubit.dart';
import '../../cubit/hero_state.dart';
import '../../../../../widgets/common/adaptive_cursor.dart';

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

class _HeroDesktopViewState extends State<HeroDesktopView> {
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

        // Calculate responsive font sizes
        final nameFontSize = screenWidth * 0.15; // Massive responsive text
        final horizontalPadding = screenWidth * 0.05;

        return ValueListenableBuilder<double>(
          valueListenable: widget.scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return Container(
              height: viewportHeight,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor, // Pure Black
              child: Stack(
                children: [
                  // Minimal Aurora Hint (Optional/Subtle)
                  if (!isLowSpec && heroData.showAurora)
                    Positioned(
                      top: -100,
                      right: -100,
                      child: Container(
                        width: 600,
                        height: 600,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              blurRadius: 100,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.2, 1.2),
                            duration: 5000.ms,
                          ),
                    ),

                  // Main Content - Bottom Left aligned like "Robertson"
                  Positioned(
                    bottom: viewportHeight * 0.1,
                    left: horizontalPadding,
                    right: horizontalPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. Editorial "Hello" / Role
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: _buildTitleSpans(
                                  heroData.title.toUpperCase(),
                                  context,
                                  16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              height: 1,
                              width: 40,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "BASED IN EGYPT", // Dynamic location if available
                              style: GoogleFonts.spaceMono(
                                fontSize: 14,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .slideX(begin: -0.1),

                        const SizedBox(height: 16),

                        // 2. Massive Name
                        Text(
                          heroData.name.toUpperCase(),
                          style: GoogleFonts.orbitron(
                            fontSize: nameFontSize.clamp(
                                80, 250), // Responsive massive size
                            height: 0.9,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -4,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 1000.ms, delay: 200.ms)
                            .moveY(begin: 50, end: 0),

                        const SizedBox(height: 48),

                        // 3. Description & Actions (Row structure)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Short Bio
                            SizedBox(
                              width: 400,
                              child: Text(
                                heroData
                                    .subtitle, // "Specializing in high-performance..."
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  height: 1.6,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),

                            const Spacer(),

                            // Actions
                            Row(
                              children: [
                                _buildMinimalAction(
                                  context,
                                  "PROJECTS",
                                  Icons.arrow_forward_rounded,
                                  widget.onViewProjects,
                                ),
                                const SizedBox(width: 32),
                                _buildMinimalAction(
                                  context,
                                  "CONTACT",
                                  Icons.mail_outline_rounded,
                                  widget.onContactMe,
                                ),
                              ],
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .moveY(begin: 30, end: 0),
                      ],
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

  Widget _buildMinimalAction(
      BuildContext context, String label, IconData icon, VoidCallback? onTap) {
    return MagneticButton(
      onTap: onTap ?? () {},
      cursorType: CursorType.click,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent, // Explicitly transparent
        ),
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.oswald(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildTitleSpans(
      String text, BuildContext context, double fontSize) {
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
