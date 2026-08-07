import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../../foundation/motion.dart';

class RoyalChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;
  final bool selected;
  final VoidCallback? onTap;

  const RoyalChip({
    super.key,
    required this.text,
    this.icon,
    this.color,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? RoyalColors.royalBlue600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: RoyalRadius.full,
        onTap: onTap,
        child: AnimatedContainer(
          duration: RoyalMotion.normal,
          curve: RoyalMotion.standard,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? baseColor : baseColor.withOpacity(0.08),
            borderRadius: RoyalRadius.full,
            border: Border.all(color: baseColor.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : baseColor,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: RoyalTypography.labelMedium.copyWith(
                  color: selected ? Colors.white : baseColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}