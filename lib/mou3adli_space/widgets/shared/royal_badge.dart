import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';

class RoyalBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  const RoyalBadge({
    super.key,
    required this.text,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? RoyalColors.gold500;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.12),
        borderRadius: RoyalRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: baseColor),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: RoyalTypography.labelSmall.copyWith(
              color: baseColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}