// extensions/context_extensions.dart
import 'package:flutter/material.dart';
import '../theme/royal_theme.dart';
import '../foundation/typography.dart';
import '../foundation/spacing.dart';
import '../foundation/motion.dart';

extension RoyalContext on BuildContext {
  RoyalColorScheme get colors {
    final scheme = Theme.of(this).extension<RoyalColorScheme>();
    return scheme ?? (Theme.of(this).brightness == Brightness.dark 
        ? RoyalColorScheme.dark 
        : RoyalColorScheme.light);
  }

  RoyalTypography get text => const RoyalTypography();

  RoyalSpacingContext get space => RoyalSpacingContext();

  RoyalMotion get motion => const RoyalMotion();

  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isTablet => screenWidth > 600;
  bool get isDesktop => screenWidth > 1024;

  EdgeInsets get safePadding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isLight => !isDark;

  TargetPlatform get platform => Theme.of(this).platform;
  NavigatorState get nav => Navigator.of(this);
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
}

class RoyalSpacingContext {
  double get xxs => RoyalSpacing.xxs;
  double get xs => RoyalSpacing.xs;
  double get sm => RoyalSpacing.sm;
  double get md => RoyalSpacing.md;
  double get lg => RoyalSpacing.lg;
  double get xl => RoyalSpacing.xl;
  double get xxl => RoyalSpacing.xxl;
  double get xxxl => RoyalSpacing.xxxl;
  double get huge => RoyalSpacing.huge;
  double get giant => RoyalSpacing.giant;
  double get massive => RoyalSpacing.massive;

  EdgeInsets get screen => RoyalSpacing.screen;
  EdgeInsets get screenHorizontal => RoyalSpacing.screenHorizontal;
  EdgeInsets get card => RoyalSpacing.card;
  EdgeInsets get cardLarge => RoyalSpacing.cardLarge;
  EdgeInsets get section => RoyalSpacing.section;
  EdgeInsets get item => RoyalSpacing.item;
}

extension RoyalStringExtension on String {
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get truncate => length > 100 ? '${substring(0, 97)}...' : this;
}

extension RoyalWidgetExtension on Widget {
  Widget get center => Center(child: this);
  Widget get expand => Expanded(child: this);
  Widget get flexible => Flexible(child: this);
  Widget pad(EdgeInsets padding) => Padding(padding: padding, child: this);
  Widget padAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);
  Widget padH(double value) => Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);
  Widget padV(double value) => Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);
  Widget get scrollable => SingleChildScrollView(child: this);
}