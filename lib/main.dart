import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/projects/presentation/cubit/projects_cubit.dart';
import 'features/experience/presentation/cubit/experience_cubit.dart';
import 'features/expertise/presentation/cubit/expertise_cubit.dart';
import 'features/hero/presentation/cubit/hero_cubit.dart';
import 'features/about/presentation/cubit/about_cubit.dart';
import 'features/contact/presentation/cubit/contact_cubit.dart';
import 'features/testimonials/presentation/cubit/testimonials_cubit.dart';
import 'features/why_choose_me/presentation/cubit/why_choose_me_cubit.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'core/navigation/app_router.dart';
import 'widgets/common/adaptive_cursor.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/app_theme.dart';

import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/services/analytics_service.dart';

void main() async {
  // debugPrint is used liberally in the data sources for development; without
  // this override every fetch logs to the browser console in production too,
  // which is noisy and unprofessional for anyone who opens DevTools.
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();

  // Error handling for Flutter web
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
    }
  };

  // Handle platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      print('Platform Error: $error');
      print('Stack trace: $stack');
    }
    return true;
  };

  // Kick off data loads without blocking first paint. Every cubit already
  // has Initial/Loading/Loaded/Error states and every consuming widget
  // already renders a loading spinner for them, so there's no need to make
  // the whole app (and every Lighthouse timing metric) wait on 8 parallel
  // Firestore round-trips before the first frame paints.
  unawaited(di.sl<ProjectsCubit>().loadProjects());
  unawaited(di.sl<ExperienceCubit>().loadExperiences());
  unawaited(di.sl<ExpertiseCubit>().loadExpertise());
  unawaited(di.sl<HeroCubit>().loadHeroData());
  unawaited(di.sl<AboutCubit>().loadAboutData());
  unawaited(di.sl<ContactCubit>().loadContactData());
  // TestimonialsCubit/WhyChooseMeCubit are registered in DI but their
  // sections aren't rendered anywhere (no route or home section uses them),
  // so don't spend startup time fetching their Firestore collections.
  // Re-add loadTestimonials()/loadReasons() here when those sections ship.

  unawaited(di.sl<AnalyticsService>().logVisit());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = ThemeController();

    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MultiBlocProvider(    
          providers: [
            BlocProvider(create: (_) => di.sl<ProjectsCubit>()),
            BlocProvider(create: (_) => di.sl<ExperienceCubit>()),
            BlocProvider(create: (_) => di.sl<ExpertiseCubit>()),
            BlocProvider(create: (_) => di.sl<HeroCubit>()),
            BlocProvider(create: (_) => di.sl<AboutCubit>()),
            BlocProvider(create: (_) => di.sl<ContactCubit>()),
            BlocProvider(create: (_) => di.sl<TestimonialsCubit>()),
            BlocProvider(create: (_) => di.sl<WhyChooseMeCubit>()),
          ],
          child: MaterialApp(
            title: 'Mohamed Adel - Flutter Developer',
            debugShowCheckedModeBanner: false,
            scrollBehavior: CustomScrollBehavior(),
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            builder: (context, child) {
              return AdaptiveCursor(child: child ?? const SizedBox.shrink());
            },
            // Use Routing instead of Home
            initialRoute: '/',
            onGenerateRoute: AppRouter.onGenerateRoute,
          ),
        );
      },
    );
  }
}

// Step 3: Custom MaterialScrollBehavior for touch and mouse dragging
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
