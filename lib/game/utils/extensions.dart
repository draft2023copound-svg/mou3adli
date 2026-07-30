import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════
// EXTENSIONS COLOR
// ═══════════════════════════════════════════════════════════

extension ColorExtensions on Color {
  /// Éclaircit la couleur d'un certain pourcentage (0.0 à 1.0)
  Color lighten([double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Assombrit la couleur d'un certain pourcentage (0.0 à 1.0)
  Color darken([double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

// ═══════════════════════════════════════════════════════════
// EXTENSIONS INT
// ═══════════════════════════════════════════════════════════

extension IntFormatting on int {
  /// Formate les grands nombres : 1500 → "1.5K", 2500000 → "2.5M"
  String get formatted {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

// ═══════════════════════════════════════════════════════════
// EXTENSIONS LIST (matrices)
// ═══════════════════════════════════════════════════════════

extension ListExtensions<T> on List<List<T>> {
  /// Copie profonde d'une matrice 2D
  List<List<T>> deepCopy() => map((row) => List<T>.from(row)).toList();
}

// ═══════════════════════════════════════════════════════════
// EXTENSIONS BUILD CONTEXT
// ═══════════════════════════════════════════════════════════

extension BuildContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isLandscape => screenWidth > screenHeight;

  Size get safeSize {
    final mq = MediaQuery.of(this);
    return Size(
      mq.size.width - mq.padding.horizontal,
      mq.size.height - mq.padding.vertical,
    );
  }
}