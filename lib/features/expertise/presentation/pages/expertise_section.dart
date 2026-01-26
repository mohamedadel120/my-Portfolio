import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../injection_container.dart';
import '../cubit/expertise_cubit.dart';
import 'mobile/expertise_mobile_view.dart';
import 'desktop/expertise_desktop_view.dart';

class ExpertiseSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ExpertiseSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExpertiseCubit>()..loadExpertise(),
      child: ResponsiveBuilder(
        mobile:
            ExpertiseMobileView(scrollOffsetListenable: scrollOffsetListenable),
        // Use Desktop view for Tablet for now as they share similar layout logic
        tablet: ExpertiseDesktopView(
            scrollOffsetListenable: scrollOffsetListenable),
        desktop: ExpertiseDesktopView(
            scrollOffsetListenable: scrollOffsetListenable),
      ),
    );
  }
}
