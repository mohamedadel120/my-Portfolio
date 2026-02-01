import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  // Dark Theme (Default/Coding Mode)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      onPrimary: Colors.black, // Text on white primary should be black
      onSecondary: Colors.black,
      onSurface: Colors.white,
      surfaceContainerHighest: AppColors.surfaceLight,
    ),
  );

  // Light Theme (Clean Mode)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary, // Neon Green accent even in light mode
      secondary: Color(0xFF424242),
      surface: Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      surfaceContainerHighest: Color(0xFFE0E0E0),
    ),
  );
}
