import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../../foundation/spacing.dart';
import 'royal_card.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String teacher;
  final DateTime date;
  final VoidCallback? onTap;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.description,
    required this.teacher,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(
        RoyalSpacing.lg,
        RoyalSpacing.sm,
        RoyalSpacing.lg,
        RoyalSpacing.lg,
      ),
      onTap: onTap,
      color: RoyalColors.gold50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: RoyalColors.gold500,
                  borderRadius: RoyalRadius.md,
                ),
                child: const Icon(
                  Icons.campaign_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: RoyalSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Annonce importante",
                      style: RoyalTypography.labelLarge.copyWith(
                        color: RoyalColors.gold700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: RoyalTypography.headlineSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: RoyalTypography.bodyLarge.copyWith(
              height: 1.5,
              color: RoyalColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(
                Icons.school_rounded,
                size: 18,
                color: RoyalColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  teacher,
                  style: RoyalTypography.bodyMedium,
                ),
              ),
              Text(
                "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}",
                style: RoyalTypography.labelMedium.copyWith(
                  color: RoyalColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}