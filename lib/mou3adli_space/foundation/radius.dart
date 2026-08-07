import 'package:flutter/material.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Border Radius Tokens v1.0
/// =======================================================

class RoyalRadius {
  RoyalRadius._();

  // ======================================================
  // RADIUS SCALE
  // ======================================================
  static const double xsValue  = 6;
  static const double smValue  = 10;
  static const double mdValue  = 16;
  static const double lgValue  = 22;
  static const double xlValue  = 28;
  static const double xxlValue = 36;
  static const double fullValue = 999;

  // ======================================================
  // BORDER RADIUS OBJECTS
  // ======================================================
  static final xs  = BorderRadius.circular(xsValue);
  static final sm  = BorderRadius.circular(smValue);
  static final md  = BorderRadius.circular(mdValue);
  static final lg  = BorderRadius.circular(lgValue);
  static final xl  = BorderRadius.circular(xlValue);
  static final xxl = BorderRadius.circular(xxlValue);
  static final full = BorderRadius.circular(fullValue);

  // ======================================================
  // DIRECTIONAL
  // ======================================================
  static BorderRadius top(double value) =>
      BorderRadius.vertical(top: Radius.circular(value));

  static BorderRadius bottom(double value) =>
      BorderRadius.vertical(bottom: Radius.circular(value));

  static BorderRadius left(double value) =>
      BorderRadius.horizontal(left: Radius.circular(value));

  static BorderRadius right(double value) =>
      BorderRadius.horizontal(right: Radius.circular(value));
}