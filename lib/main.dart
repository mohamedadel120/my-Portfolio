import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'core/navigation/app_router.dart';
import 'widgets/common/adaptive_cursor.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/app_theme.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        return MaterialApp(
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
