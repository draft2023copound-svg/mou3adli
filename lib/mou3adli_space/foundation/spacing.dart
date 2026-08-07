import 'package:flutter/material.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Spacing Tokens v1.0
/// Based on 4px grid system (like Apple, Google)
/// =======================================================

class RoyalSpacing {
  RoyalSpacing._();

  // ======================================================
  // BASE UNIT = 4px
  // ======================================================
  static const double unit = 4.0;

  // ======================================================
  // SPACING SCALE
  // ======================================================
  static const double xxs  = unit * 0.5;   // 2
  static const double xs   = unit * 1;     // 4
  static const double sm   = unit * 2;     // 8
  static const double md   = unit * 3;     // 12
  static const double lg   = unit * 4;     // 16
  static const double xl   = unit * 5;     // 20
  static const double xxl  = unit * 6;     // 24
  static const double xxxl = unit * 8;     // 32
  static const double huge = unit * 10;    // 40
  static const double giant = unit * 12;   // 48
  static const double massive = unit * 16; // 64

  // ======================================================
  // EDGE INSETS HELPERS
  // ======================================================
  static EdgeInsets get screen => const EdgeInsets.all(lg);
  static EdgeInsets get screenHorizontal => const EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get card => const EdgeInsets.all(lg);
  static EdgeInsets get cardLarge => const EdgeInsets.all(xl);
  static EdgeInsets get section => const EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get item => const EdgeInsets.symmetric(vertical: sm);
}

/// =======================================================
/// Gap Widget — Replacement for SizedBox
/// Usage: Gap(RoyalSpacing.lg) or Gap(context.space.lg)
/// =======================================================
class Gap extends StatelessWidget {
  final double size;
  const Gap(this.size, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}