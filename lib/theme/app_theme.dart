import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  // Dark Theme (Original)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      surfaceContainerHighest: AppColors.surfaceLight,
    ),
    // Typography can be added here if needed
  );

  // Light Theme (New)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F4F8), // Soft whte-blueish
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary, // Keep brand color
      secondary: AppColors.secondary,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1F3A), // Dark text for light mode
      surfaceContainerHighest: Color(0xFFE2E8F0),
    ),
  );
}
