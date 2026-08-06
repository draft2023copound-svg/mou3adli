import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ═══ FOND ═══
  static const Color background = Color(0xFFF8F7F4);      // Grège très clair élégant
  static const Color surface = Color(0xFFFFFFFF);          // Blanc pur
  static const Color surfaceDark = Color(0xFF1A1A1A);      // Pour dark mode

  // ═══ ACCENTS PRINCIPAUX ═══
  static const Color royalBlue = Color(0xFF1C3F7A);       // Bleu roi Mou3adli
  static const Color royalBlueLight = Color(0xFF2E5AAC);
  static const Color royalBlueDark = Color(0xFF142D5C);

  static const Color gold = Color(0xFFC5A059);            // Or Mou3adli
  static const Color goldLight = Color(0xFFD4B76A);
  static const Color goldDark = Color(0xFFA68B4B);

  // ═══ DÉGRADÉS ═══
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4B76A), Color(0xFFC5A059), Color(0xFFA68B4B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2E5AAC), Color(0xFF1C3F7A), Color(0xFF142D5C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient storyGradient = LinearGradient(
    colors: [Color(0xFFD4B76A), Color(0xFFC5A059), Color(0xFFE8D5A3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ═══ TEXTES ═══
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9A9A9A);
  static const Color textInverse = Color(0xFFFFFFFF);

  // ═══ ÉTATS ═══
  static const Color danger = Color(0xFFFF4757);
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);

  // ═══ BORDURES & DIVIDERS ═══
  static const Color border = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color gold10 = Color(0x1AC5A059);
  static const Color royalBlue10 = Color(0x1A1C3F7A);
  static const Color surfaceElevated = Color(0xFFF5F3EE);
  static const Color textHint = Color(0xFF8F8F8F);

  // ═══ GLASSMORPHISM ═══
  static Color glassWhite = Colors.white.withOpacity(0.85);
  static Color glassBorder = Colors.white.withOpacity(0.5);
  static Color glassShadow = Colors.black.withOpacity(0.08);
}