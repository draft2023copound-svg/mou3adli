import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
// removed unused spacing import
import '../cards/royal_card.dart';

class ContinueLearningCard extends StatelessWidget {
  final String title;
  final String teacher;
  final double progress;
  final String duration;
  final int remainingLessons;
  final VoidCallback? onPressed;

  const ContinueLearningCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.progress,
    required this.duration,
    required this.remainingLessons,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      RoyalColors.royalBlue500,
                      RoyalColors.royalBlue700,
                    ],
                  ),
                  borderRadius: RoyalRadius.lg,
                ),
                child: const Icon(
                  Icons.play_lesson,
                  size: 34,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: RoyalTypography.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      teacher,
                      style: RoyalTypography.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(progress * 100).toInt()} % terminé",
                      style: RoyalTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.schedule,
                size: 18,
                color: RoyalColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(duration),
              const Spacer(),
              Text("$remainingLessons leçons"),
              const SizedBox(width: 16),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Continuer"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}