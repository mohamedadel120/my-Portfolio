import 'package:my_web_site/widgets/common/app_loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';
import '../../../../../widgets/common/section_title.dart';
import '../../../../../widgets/common/tech_grid_background.dart';
import '../../../../../widgets/common/scroll_speed_widget.dart';
import '../../../../../widgets/common/scroll_triggered_animation.dart';
import '../../cubit/expertise_cubit.dart';
import '../../cubit/expertise_state.dart';
import '../../widgets/expertise_card.dart';

class ExpertiseMobileView extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ExpertiseMobileView({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpertiseCubit, ExpertiseState>(
      builder: (context, state) {
        if (state is ExpertiseLoading) {
          return const AppLoadingIndicator();
        }
        if (state is ExpertiseError) {
          return Center(child: Text(state.message));
        }

        final expertiseAreas = (state as ExpertiseLoaded).expertiseAreas;
        final viewportHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        // Estimate: Hero + About + Stats sections
        final sectionStartOffset = viewportHeight * 2.5;

        final isLowSpec = DeviceUtils.isLowSpecDevice(context);
        final horizontalPadding = DeviceUtils.getHorizontalPadding(screenWidth);
        final verticalPadding = DeviceUtils.getVerticalPadding(screenWidth);

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
                    speed: -0.2,
                    child: TechGridBackground(
                      scrollOffset: scrollOffset,
                      opacity: isLowSpec ? 0.02 : 0.06,
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
                          title: 'Expertise',
                          isVisible: true,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Expertise cards vertical list
                      Column(
                        children: expertiseAreas.asMap().entries.map((entry) {
                          final index = entry.key;
                          final expertise = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: ExpertiseCard(
                              expertise: expertise,
                              scrollOffset: scrollOffset,
                              sectionStartOffset: sectionStartOffset,
                              viewportHeight: viewportHeight,
                              index: index,
                              isMobile: true,
                              isTablet: false,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
