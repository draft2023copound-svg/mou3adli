import 'package:flutter/material.dart';
import '../foundation/colors.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// RoyalColorScheme — ThemeExtension for context access
/// =======================================================

@immutable
class RoyalColorScheme extends ThemeExtension<RoyalColorScheme> {
  // Primary
  final Color primary;
  final Color primaryContainer;
  final Color primaryLight;

  // Gold
  final Color gold;
  final Color goldContainer;
  final Color goldLight;

  // Surfaces
  final Color background;
  final Color surface;
  final Color card;
  final Color elevated;

  // Borders
  final Color border;
  final Color divider;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textInverse;

  // Status
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Effects
  final Color shadow;
  final Color glow;
  final Color glass;

  const RoyalColorScheme({
    required this.primary,
    required this.primaryContainer,
    required this.primaryLight,
    required this.gold,
    required this.goldContainer,
    required this.goldLight,
    required this.background,
    required this.surface,
    required this.card,
    required this.elevated,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textInverse,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.shadow,
    required this.glow,
    required this.glass,
  });

  // ======================================================
  // LIGHT THEME
  // ======================================================
  static const RoyalColorScheme light = RoyalColorScheme(
    primary: RoyalColors.royalBlue600,
    primaryContainer: RoyalColors.royalBlue50,
    primaryLight: RoyalColors.royalBlue400,
    gold: RoyalColors.gold500,
    goldContainer: RoyalColors.gold50,
    goldLight: RoyalColors.gold300,
    background: RoyalColors.background,
    surface: RoyalColors.surface,
    card: RoyalColors.card,
    elevated: RoyalColors.elevated,
    border: RoyalColors.border,
    divider: RoyalColors.divider,
    textPrimary: RoyalColors.textPrimary,
    textSecondary: RoyalColors.textSecondary,
    textMuted: RoyalColors.textMuted,
    textInverse: RoyalColors.textWhite,
    success: RoyalColors.success,
    warning: RoyalColors.warning,
    error: RoyalColors.error,
    info: RoyalColors.info,
    shadow: RoyalColors.shadow,
    glow: RoyalColors.blueGlow,
    glass: RoyalColors.glass,
  );

  // ======================================================
  // DARK THEME
  // ======================================================
  static const RoyalColorScheme dark = RoyalColorScheme(
    primary: RoyalColors.royalBlue300,
    primaryContainer: RoyalColors.royalBlue800,
    primaryLight: RoyalColors.royalBlue400,
    gold: RoyalColors.gold300,
    goldContainer: RoyalColors.gold900,
    goldLight: RoyalColors.gold400,
    background: RoyalColors.darkBackground,
    surface: RoyalColors.darkSurface,
    card: RoyalColors.darkCard,
    elevated: RoyalColors.darkElevated,
    border: RoyalColors.darkBorder,
    divider: RoyalColors.darkDivider,
    textPrimary: RoyalColors.darkTextPrimary,
    textSecondary: RoyalColors.darkTextSecondary,
    textMuted: RoyalColors.darkTextMuted,
    textInverse: RoyalColors.textPrimary,
    success: RoyalColors.success,
    warning: RoyalColors.warning,
    error: RoyalColors.error,
    info: RoyalColors.info,
    shadow: Color(0x33FFFFFF),
    glow: RoyalColors.blueGlow,
    glass: RoyalColors.darkGlass,
  );

  // ======================================================
  // THEME EXTENSION METHODS
  // ======================================================
  @override
  RoyalColorScheme copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? primaryLight,
    Color? gold,
    Color? goldContainer,
    Color? goldLight,
    Color? background,
    Color? surface,
    Color? card,
    Color? elevated,
    Color? border,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textInverse,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? shadow,
    Color? glow,
    Color? glass,
  }) {
    return RoyalColorScheme(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      primaryLight: primaryLight ?? this.primaryLight,
      gold: gold ?? this.gold,
      goldContainer: goldContainer ?? this.goldContainer,
      goldLight: goldLight ?? this.goldLight,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      elevated: elevated ?? this.elevated,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textInverse: textInverse ?? this.textInverse,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      shadow: shadow ?? this.shadow,
      glow: glow ?? this.glow,
      glass: glass ?? this.glass,
    );
  }

  @override
  RoyalColorScheme lerp(ThemeExtension<RoyalColorScheme>? other, double t) {
    if (other is! RoyalColorScheme) return this;
    return RoyalColorScheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      goldContainer: Color.lerp(goldContainer, other.goldContainer, t)!,
      goldLight: Color.lerp(goldLight, other.goldLight, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      elevated: Color.lerp(elevated, other.elevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
    );
  }
}