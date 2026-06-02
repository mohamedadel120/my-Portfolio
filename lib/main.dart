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

  // Fetch all global data before running the app
  // This keeps the index.html loader on screen until data is fully loaded
  await Future.wait([
    di.sl<ProjectsCubit>().loadProjects(),
    di.sl<ExperienceCubit>().loadExperiences(),
    di.sl<ExpertiseCubit>().loadExpertise(),
    di.sl<HeroCubit>().loadHeroData(),
    di.sl<AboutCubit>().loadAboutData(),
    di.sl<ContactCubit>().loadContactData(),
    di.sl<TestimonialsCubit>().loadTestimonials(),
    di.sl<WhyChooseMeCubit>().loadReasons(),
  ]);

  di.sl<AnalyticsService>().logVisit();

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
