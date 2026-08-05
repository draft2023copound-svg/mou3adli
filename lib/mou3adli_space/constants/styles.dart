import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  AppStyles._();

  // === BORDURES ===
  static BorderRadius get radius4 => BorderRadius.circular(4.0);
  static BorderRadius get radius6 => BorderRadius.circular(6.0);
  static BorderRadius get radius8 => BorderRadius.circular(8.0);
  static BorderRadius get radius10 => BorderRadius.circular(10.0);
  static BorderRadius get radius12 => BorderRadius.circular(12.0);
  static BorderRadius get radius16 => BorderRadius.circular(16.0);
  static BorderRadius get radius20 => BorderRadius.circular(20.0);
  static BorderRadius get radius24 => BorderRadius.circular(24.0);
  static BorderRadius get radiusFull => BorderRadius.circular(100.0);

  static BorderRadius get topRadius20 => const BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  );

  // === OMBRES ===
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8.0,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16.0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get fabShadow => [
    BoxShadow(
      color: AppColors.gold.withOpacity(0.35),
      blurRadius: 20.0,
      offset: const Offset(0, 4),
    ),
  ];

  // === TEXTES ===
  static TextStyle get style32Bold => const TextStyle(
    fontSize: 32.0, fontWeight: FontWeight.bold,
  );
  static TextStyle get style24Bold => const TextStyle(
    fontSize: 24.0, fontWeight: FontWeight.bold,
  );
  static TextStyle get style20Bold => const TextStyle(
    fontSize: 20.0, fontWeight: FontWeight.bold,
  );
  static TextStyle get style18Bold => const TextStyle(
    fontSize: 18.0, fontWeight: FontWeight.bold,
  );
  static TextStyle get style16Bold => const TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.bold,
  );
  static TextStyle get style14Bold => const TextStyle(
    fontSize: 14.0, fontWeight: FontWeight.bold,
  );
  static TextStyle get style12Bold => const TextStyle(
    fontSize: 12.0, fontWeight: FontWeight.bold,
  );
  static TextStyle get style16Normal => const TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.normal,
  );
  static TextStyle get style14Normal => const TextStyle(
    fontSize: 14.0, fontWeight: FontWeight.normal,
  );
  static TextStyle get style13Normal => const TextStyle(
    fontSize: 13.0, fontWeight: FontWeight.normal,
  );
  static TextStyle get style12Normal => const TextStyle(
    fontSize: 12.0, fontWeight: FontWeight.normal,
  );
  static TextStyle get style11Normal => const TextStyle(
    fontSize: 11.0, fontWeight: FontWeight.normal,
  );
  static TextStyle get style15Bold => const TextStyle(
    fontSize: 15.0, fontWeight: FontWeight.bold,
  );
}
