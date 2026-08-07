import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';

class DateSeparator extends StatelessWidget {
  final String text;

  const DateSeparator({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: RoyalColors.gray100,
            borderRadius: RoyalRadius.full,
          ),
          child: Text(
            text,
            style: RoyalTypography.caption.copyWith(
              color: RoyalColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}