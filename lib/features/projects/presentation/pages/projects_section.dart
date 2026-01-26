import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../injection_container.dart';
import '../cubit/projects_cubit.dart';
import 'mobile/projects_mobile_view.dart';
import 'tablet/projects_tablet_view.dart';
import 'desktop/projects_desktop_view.dart';

class ProjectsSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ProjectsSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProjectsCubit>()..loadProjects(),
      child: ResponsiveBuilder(
        mobile:
            ProjectsMobileView(scrollOffsetListenable: scrollOffsetListenable),
        tablet:
            ProjectsTabletView(scrollOffsetListenable: scrollOffsetListenable),
        desktop:
            ProjectsDesktopView(scrollOffsetListenable: scrollOffsetListenable),
      ),
    );
  }
}
