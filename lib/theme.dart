import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFED903E); // #ED903E
  static const secondary = Color(0xFFA8714C); // #A8714C
  static const tertiary = Color(0xFF57482B); // #57482B
  static const accent = Color(0xFF7A1C0B); // #7A1C0B
  static const error = Color(0xFFAD2E24); // #AD2E24
  static const surface = Color(0xFFF8F1E8);
  static const surfaceVariant = Color(0xFFF0E2D4);
  static const onPrimary = Colors.white;
  static const onSurface = Color(0xFF2D2A24);
}

class AppTheme {
  static ThemeData light() {
    final scheme = const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
      surface: AppColors.surface,
      surfaceVariant: AppColors.surfaceVariant,
      onPrimary: AppColors.onPrimary,
      onSurface: AppColors.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceVariant,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: AppColors.tertiary),
      textTheme: const TextTheme(
        titleMedium: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(color: AppColors.onSurface),
      ),
    );
  }
}
