import 'package:my_web_site/widgets/common/app_loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';

import '../../../../../widgets/common/tech_grid_background.dart';
import '../../../../../widgets/common/scroll_speed_widget.dart';
import '../../../../../widgets/common/scroll_triggered_animation.dart';
import '../../../../../widgets/common/section_title.dart';
import '../../cubit/experience_cubit.dart';
import '../../cubit/experience_state.dart';
import '../../widgets/professional_experience_card.dart';

class ExperienceDesktopView extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ExperienceDesktopView(
      {super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary isolates this section's compositing layer from its
    // siblings: BlocBuilder swaps a fixed-height loading indicator for the
    // much taller real content the instant Firestore data arrives. Without
    // a boundary, that resize can leave the section stuck showing a stale
    // frame forever (a MouseTracker/relayout race — asserts loudly in
    // debug, fails silently in release).
    return RepaintBoundary(
      child: BlocBuilder<ExperienceCubit, ExperienceState>(
      builder: (context, state) {
        if (state is ExperienceLoading) {
          return const AppLoadingIndicator();
        }
        if (state is ExperienceError) {
          return Center(child: Text(state.message));
        }

        final experiences = (state as ExperienceLoaded).experiences;
        final viewportHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final sectionStartOffset = viewportHeight * 3;
        final isLowSpec = DeviceUtils.isLowSpecDevice(context);

        final horizontalPadding = DeviceUtils.getHorizontalPadding(screenWidth);
        final verticalPadding = DeviceUtils.getVerticalPadding(screenWidth);
        final isTablet = DeviceUtils.isTablet(screenWidth);

        return ValueListenableBuilder<double>(
          valueListenable: scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ScrollSpeedWidget(
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    speed: -0.15,
                    child: TechGridBackground(
                      scrollOffset: scrollOffset,
                      opacity: isLowSpec ? 0.02 : 0.05,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScrollTriggeredAnimation(
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        delay: 0.ms,
                        child: const SectionTitle(
                          title: 'Work Experience',
                          isVisible: true,
                        ),
                      ),
                      const SizedBox(height: 72),
                      ...experiences.asMap().entries.map((entry) {
                        final index = entry.key;
                        final exp = entry.value;
                        final isLast = index == experiences.length - 1;

                        return ProfessionalExperienceCard(
                          experience: exp,
                          scrollOffset: scrollOffset,
                          sectionStartOffset: sectionStartOffset,
                          viewportHeight: viewportHeight,
                          index: index,
                          isLast: isLast,
                          isMobile: false,
                          isTablet: isTablet,
                        );
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      ),
    );
  }
}
