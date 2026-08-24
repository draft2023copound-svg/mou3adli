import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/spacing.dart';

class RoyalDivider extends StatelessWidget {
  final double indent;
  final double endIndent;
  final EdgeInsetsGeometry margin;

  const RoyalDivider({
    super.key,
    this.indent = 0,
    this.endIndent = 0,
    this.margin = const EdgeInsets.symmetric(vertical: RoyalSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            RoyalColors.border.withValues(alpha: 0.75),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}