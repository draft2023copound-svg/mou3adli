import 'package:flutter/material.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Motion Tokens v1.0
/// Consistent animation timing across the entire app
/// =======================================================

class RoyalMotion {
  const RoyalMotion();

  // ======================================================
  // DURATIONS
  // ======================================================
  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration deliberate = Duration(milliseconds: 500);

  // ======================================================
  // CURVES
  // ======================================================
  static const Curve standard = Curves.easeOutCubic;
  static const Curve enter = Curves.easeOutQuart;
  static const Curve exit = Curves.easeInQuart;
  static const Curve emphasis = Curves.easeOutBack;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;

  // ======================================================
  // SPRING PHYSICS
  // ======================================================
  static const SpringDescription springLight = SpringDescription(
    mass: 1,
    stiffness: 400,
    damping: 30,
  );

  static const SpringDescription springMedium = SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 25,
  );

  static const SpringDescription springHeavy = SpringDescription(
    mass: 1.5,
    stiffness: 200,
    damping: 20,
  );

  // ======================================================
  // STAGGER
  // ======================================================
  static Duration stagger(int index, {Duration base = fast}) =>
      Duration(milliseconds: base.inMilliseconds + (index * 40));
}