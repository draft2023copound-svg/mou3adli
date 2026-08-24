import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════
// COULEURS
// ═══════════════════════════════════════════════════════════

class AppColors {
  const AppColors._();

  static const Color royalBlue = Color(0xFF1C3F7A);
  static const Color royalBlueLight = Color(0xFF3B82F6);
  static const Color royalBlueDark = Color(0xFF1E3A8A);

  static const Color matteGold = Color(0xFFC5A059);
  static const Color matteGoldLight = Color(0xFFD4AF37);
  static const Color matteGoldDark = Color(0xFFB8941F);

  static const Color background = Color(0xFFF5F7FB);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Dark theme (jeux)
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkBorder = Color(0xFF333333);
}

// ═══════════════════════════════════════════════════════════
// TAILLES
// ═══════════════════════════════════════════════════════════

class AppSizes {
  const AppSizes._();

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusXXLarge = 24.0;
  static const double radiusCircular = 30.0;

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingLarge = 16.0;
  static const double paddingXLarge = 20.0;
  static const double paddingXXLarge = 24.0;
  static const double paddingXXXLarge = 32.0;

  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;
  static const double iconXXLarge = 40.0;

  static const double shadowSmall = 4.0;
  static const double shadowMedium = 8.0;
  static const double shadowLarge = 16.0;
  static const double shadowXLarge = 24.0;
}

// ═══════════════════════════════════════════════════════════
// TEXTES
// ═══════════════════════════════════════════════════════════

class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'Inter';

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: 2,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 1,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get label => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 1.2,
      );

  static TextStyle get scoreLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        height: 1.0,
      );

  static TextStyle get scoreMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );
}

// ═══════════════════════════════════════════════════════════
// DÉGRADÉS
// ═══════════════════════════════════════════════════════════

class AppGradients {
  const AppGradients._();

  static const LinearGradient royalBlue = LinearGradient(
    colors: [AppColors.royalBlueDark, AppColors.royalBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient matteGold = LinearGradient(
    colors: [AppColors.matteGoldDark, AppColors.matteGoldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient error = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ═══════════════════════════════════════════════════════════
// OMBRES
// ═══════════════════════════════════════════════════════════

class AppShadows {
  const AppShadows._();

  static BoxShadow get small => BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: AppSizes.shadowSmall,
        offset: const Offset(0, 2),
      );

  static BoxShadow get medium => BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: AppSizes.shadowMedium,
        offset: const Offset(0, 4),
      );

  static BoxShadow get large => BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: AppSizes.shadowLarge,
        offset: const Offset(0, 8),
      );

  static BoxShadow get xLarge => BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: AppSizes.shadowXLarge,
        offset: const Offset(0, 12),
      );

  static BoxShadow colored(Color color, double opacity) => BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: AppSizes.shadowLarge,
        offset: const Offset(0, 6),
      );
}