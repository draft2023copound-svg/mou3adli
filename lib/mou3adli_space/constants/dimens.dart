import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dimens {
  Dimens._();

  static double get screenWidth => Get.width;
  static double get screenHeight => Get.height;

  // === RAYONS ===
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radiusFull = 100.0;

  // === TAILLES ===
  static const double size4 = 4.0;
  static const double size8 = 8.0;
  static const double size12 = 12.0;
  static const double size14 = 14.0;
  static const double size16 = 16.0;
  static const double size18 = 18.0;
  static const double size20 = 20.0;
  static const double size24 = 24.0;
  static const double size28 = 28.0;
  static const double size32 = 32.0;
  static const double size40 = 40.0;
  static const double size48 = 48.0;
  static const double size56 = 56.0;
  static const double size64 = 64.0;

  // === PADDINGS ===
  static const EdgeInsets edgeInsets4 = EdgeInsets.all(4.0);
  static const EdgeInsets edgeInsets8 = EdgeInsets.all(8.0);
  static const EdgeInsets edgeInsets12 = EdgeInsets.all(12.0);
  static const EdgeInsets edgeInsets16 = EdgeInsets.all(16.0);
  static const EdgeInsets edgeInsets20 = EdgeInsets.all(20.0);

  static const EdgeInsets edgeInsetsHoriz8 = EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets edgeInsetsHoriz12 = EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets edgeInsetsHoriz16 = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets edgeInsetsHoriz20 = EdgeInsets.symmetric(horizontal: 20.0);

  static const EdgeInsets edgeInsetsVert8 = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets edgeInsetsVert12 = EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets edgeInsetsVert16 = EdgeInsets.symmetric(vertical: 16.0);

  // === ESPACEMENTS ===
  static const SizedBox boxWidth4 = SizedBox(width: 4.0);
  static const SizedBox boxWidth8 = SizedBox(width: 8.0);
  static const SizedBox boxWidth12 = SizedBox(width: 12.0);
  static const SizedBox boxWidth16 = SizedBox(width: 16.0);
  static const SizedBox boxHeight4 = SizedBox(height: 4.0);
  static const SizedBox boxHeight8 = SizedBox(height: 8.0);
  static const SizedBox boxHeight12 = SizedBox(height: 12.0);
  static const SizedBox boxHeight16 = SizedBox(height: 16.0);
  static const SizedBox boxHeight20 = SizedBox(height: 20.0);
  static const SizedBox boxHeight24 = SizedBox(height: 24.0);
  static const SizedBox boxHeight32 = SizedBox(height: 32.0);
  static const SizedBox boxHeight48 = SizedBox(height: 48.0);
  static const SizedBox boxHeight64 = SizedBox(height: 64.0);

  // === DIVIDER ===
  static const Divider divider = Divider(height: 1.0, thickness: 1.0);
}
