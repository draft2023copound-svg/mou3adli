import 'package:flutter/material.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Shadow Tokens v1.0
/// Premium shadow system with depth hierarchy
/// =======================================================

class RoyalShadows {
  RoyalShadows._();

  // ======================================================
  // AMBIENT SHADOWS — Subtle depth
  // ======================================================
  static const soft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  static const floating = [
    BoxShadow(
      color: Color(0x16000000),
      blurRadius: 40,
      spreadRadius: -8,
      offset: Offset(0, 18),
    ),
  ];

  // ======================================================
  // GLOW SHADOWS — Colored halos for emphasis
  // ======================================================
  static const glowBlue = [
    BoxShadow(
      color: Color(0x222F6BFF),
      blurRadius: 26,
      spreadRadius: -6,
      offset: Offset(0, 4),
    ),
  ];

  static const glowGold = [
    BoxShadow(
      color: Color(0x22FFC929),
      blurRadius: 26,
      spreadRadius: -6,
      offset: Offset(0, 4),
    ),
  ];

  static const glowSuccess = [
    BoxShadow(
      color: Color(0x2210B981),
      blurRadius: 20,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ];

  static const glowError = [
    BoxShadow(
      color: Color(0x22EF4444),
      blurRadius: 20,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ];

  // ======================================================
  // INNER SHADOWS — For pressed/selected states
  // ======================================================
  static const innerSoft = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // ======================================================
  // HIGHLIGHT — Top edge light for glassmorphism
  // ======================================================
  static const highlightTop = [
    BoxShadow(
      color: Color(0x15FFFFFF),
      blurRadius: 1,
      offset: Offset(0, -1),
    ),
  ];
}