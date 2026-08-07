import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
// removed unused spacing import
import '../cards/royal_card.dart';

class RoyalDailyChallenge extends StatelessWidget {
  final String title;
  final String description;
  final int xp;
  final double progress;
  final VoidCallback? onPressed;

  const RoyalDailyChallenge({
    super.key,
    required this.title,
    required this.description,
    required this.xp,
    required this.progress,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      RoyalColors.gold400,
                      RoyalColors.gold600,
                    ],
                  ),
                  borderRadius: RoyalRadius.lg,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: RoyalTypography.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: RoyalTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: RoyalColors.gold100,
                  borderRadius: RoyalRadius.full,
                ),
                child: Text(
                  "+$xp XP",
                  style: RoyalTypography.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: RoyalColors.border,
              valueColor: const AlwaysStoppedAnimation(RoyalColors.gold500),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "${(progress * 100).toInt()} %",
                style: RoyalTypography.labelMedium,
              ),
              const Spacer(),
              FilledButton(
                onPressed: onPressed,
                child: const Text("Commencer"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}