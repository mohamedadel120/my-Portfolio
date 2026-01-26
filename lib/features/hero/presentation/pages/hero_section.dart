import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../injection_container.dart';
import '../cubit/hero_cubit.dart';
import 'mobile/hero_mobile_view.dart';
import 'desktop/hero_desktop_view.dart';

class HeroSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HeroCubit>()..loadHeroData(),
      child: ResponsiveBuilder(
        mobile: HeroMobileView(
          scrollOffsetListenable: scrollOffsetListenable,
          onViewProjects: onViewProjects,
          onContactMe: onContactMe,
          onDownloadCV: onDownloadCV,
        ),
        tablet: HeroMobileView(
          // Reuse mobile view for tablet as it scales well, or create tablet specific if needed
          scrollOffsetListenable: scrollOffsetListenable,
          onViewProjects: onViewProjects,
          onContactMe: onContactMe,
          onDownloadCV: onDownloadCV,
        ),
        desktop: HeroDesktopView(
          scrollOffsetListenable: scrollOffsetListenable,
          onViewProjects: onViewProjects,
          onContactMe: onContactMe,
          onDownloadCV: onDownloadCV,
        ),
      ),
    );
  }
}
