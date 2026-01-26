import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../injection_container.dart';
import '../cubit/about_cubit.dart';
import 'mobile/about_mobile_view.dart';
import 'desktop/about_desktop_view.dart';

class AboutSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;
  final VoidCallback? onDownloadCV;

  const AboutSection({
    super.key,
    required this.scrollOffsetListenable,
    this.onDownloadCV,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AboutCubit>()..loadAboutData(),
      child: ResponsiveBuilder(
        mobile: AboutMobileView(
          scrollOffsetListenable: scrollOffsetListenable,
          onDownloadCV: onDownloadCV,
        ),
        tablet: AboutMobileView(
          // Reuse mobile view for tablet
          scrollOffsetListenable: scrollOffsetListenable,
          onDownloadCV: onDownloadCV,
        ),
        desktop: AboutDesktopView(
          scrollOffsetListenable: scrollOffsetListenable,
          onDownloadCV: onDownloadCV,
        ),
      ),
    );
  }
}
