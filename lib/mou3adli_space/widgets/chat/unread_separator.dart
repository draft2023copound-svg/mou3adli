import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/typography.dart';

class UnreadSeparator extends StatelessWidget {
  final int count;

  const UnreadSeparator({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$count nouveaux messages",
              style: RoyalTypography.labelMedium.copyWith(
                color: RoyalColors.error,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}