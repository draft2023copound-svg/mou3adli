import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color lighten([double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
  Color darken([double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
  
  // CORRECTION : Utilisation de 'withOpacity' au lieu de 'withValues'
  Color withOpacityValue(double opacity) => withOpacity(opacity);
}

extension IntExtensions on int {
  String get formatted => toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
}

extension ListExtensions<T> on List<List<T>> {
  List<List<T>> deepCopy() => map((row) => List<T>.from(row)).toList();
}

extension BuildContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isLandscape => screenWidth > screenHeight;
  Size get safeSize {
    final mq = MediaQuery.of(this);
    return Size(mq.size.width - mq.padding.horizontal, mq.size.height - mq.padding.vertical);
  }
}