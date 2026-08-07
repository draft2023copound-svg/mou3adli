import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/typography.dart';

class RoyalPostBody extends StatelessWidget {
  final String text;
  final int maxLines;

  const RoyalPostBody({
    super.key,
    required this.text,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: RoyalTypography.bodyLarge.copyWith(
          height: 1.55,
          color: RoyalColors.textPrimary,
        ),
      ),
    );
  }
}