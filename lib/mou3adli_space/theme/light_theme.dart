import 'package:flutter/material.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import 'royal_theme.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Light Theme Configuration
/// =======================================================

ThemeData buildRoyalLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: RoyalColors.background,
    colorScheme: const ColorScheme.light(
      primary: RoyalColors.royalBlue600,
      primaryContainer: RoyalColors.royalBlue50,
      secondary: RoyalColors.gold500,
      secondaryContainer: RoyalColors.gold50,
      surface: RoyalColors.surface,
      error: RoyalColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: RoyalColors.textPrimary,
      onError: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: RoyalTypography.displayLarge,
      displayMedium: RoyalTypography.displayMedium,
      displaySmall: RoyalTypography.displaySmall,
      headlineLarge: RoyalTypography.headlineLarge,
      headlineMedium: RoyalTypography.headlineMedium,
      headlineSmall: RoyalTypography.headlineSmall,
      titleLarge: RoyalTypography.titleLarge,
      titleMedium: RoyalTypography.titleMedium,
      titleSmall: RoyalTypography.titleSmall,
      bodyLarge: RoyalTypography.bodyLarge,
      bodyMedium: RoyalTypography.bodyMedium,
      bodySmall: RoyalTypography.bodySmall,
      labelLarge: RoyalTypography.labelLarge,
      labelMedium: RoyalTypography.labelMedium,
      labelSmall: RoyalTypography.labelSmall,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: RoyalTypography.headlineSmall,
      iconTheme: IconThemeData(color: RoyalColors.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: RoyalColors.royalBlue600,
      unselectedItemColor: RoyalColors.textSecondary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: RoyalColors.gold500,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: RoyalColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: RoyalColors.divider,
      thickness: 1,
      space: 1,
    ),
    extensions: const [
      RoyalColorScheme.light,
    ],
  );
}