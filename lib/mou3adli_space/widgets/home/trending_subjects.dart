import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/shadows.dart';
import '../../foundation/typography.dart';
// spacing import removed (unused)
import '../../models/subject_model.dart';

class TrendingSubjects extends StatelessWidget {
  final List<SubjectModel> subjects;
  final void Function(SubjectModel)? onTap;

  const TrendingSubjects({
    super.key,
    required this.subjects,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 125,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = subjects[index];
          return GestureDetector(
            onTap: () => onTap?.call(item),
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                color: isDark ? RoyalColors.darkCard : Colors.white,
                borderRadius: RoyalRadius.lg,
                boxShadow: RoyalShadows.soft,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        borderRadius: RoyalRadius.md,
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.name,
                      style: RoyalTypography.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item.unread} nouveautés",
                      style: RoyalTypography.bodySmall.copyWith(
                        color: RoyalColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemCount: subjects.length,
      ),
    );
  }
}