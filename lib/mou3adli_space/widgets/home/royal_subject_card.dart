import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
// spacing import removed (unused)
import '../../foundation/shadows.dart';

class RoyalSubjectCard extends StatelessWidget {
  final IconData icon;
  final String subject;
  final int unread;
  final Color color;
  final VoidCallback? onTap;

  const RoyalSubjectCard({
    super.key,
    required this.icon,
    required this.subject,
    required this.unread,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? RoyalColors.darkCard : Colors.white,
          borderRadius: RoyalRadius.lg,
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
          boxShadow: RoyalShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const Spacer(),
            Text(
              subject,
              style: RoyalTypography.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              "$unread nouveautés",
              style: RoyalTypography.bodySmall.copyWith(
                color: RoyalColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}