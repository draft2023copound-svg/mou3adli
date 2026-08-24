import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/shadows.dart';
import '../../foundation/typography.dart';
import '../../foundation/motion.dart';

class RoyalMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const RoyalMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: RoyalRadius.lg,
      onTap: onTap,
      child: AnimatedContainer(
        duration: RoyalMotion.normal,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? RoyalColors.darkCard
              : Colors.white,
          borderRadius: RoyalRadius.lg,
          boxShadow: RoyalShadows.soft,
          border: Border.all(
            color: color.withValues(alpha: .12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .10),
                    borderRadius: RoyalRadius.md,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: RoyalColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: RoyalTypography.displaySmall,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: RoyalTypography.titleMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: RoyalTypography.bodySmall.copyWith(
                  color: RoyalColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}