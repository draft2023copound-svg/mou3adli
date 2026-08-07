import 'package:flutter/material.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import 'royal_theme.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Dark Theme Configuration
/// =======================================================

ThemeData buildRoyalDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: RoyalColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: RoyalColors.royalBlue300,
      primaryContainer: RoyalColors.royalBlue800,
      secondary: RoyalColors.gold300,
      secondaryContainer: RoyalColors.gold900,
      surface: RoyalColors.darkSurface,
      error: RoyalColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: RoyalColors.darkTextPrimary,
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
      iconTheme: IconThemeData(color: RoyalColors.darkTextPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: RoyalColors.royalBlue300,
      unselectedItemColor: RoyalColors.darkTextSecondary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: RoyalColors.gold300,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: RoyalColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: RoyalColors.darkDivider,
      thickness: 1,
      space: 1,
    ),
    extensions: const [
      RoyalColorScheme.dark,
    ],
  );
}