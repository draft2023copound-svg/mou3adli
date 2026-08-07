import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../cards/royal_card.dart';

class WeeklyProgressCard extends StatelessWidget {
  final double progress;
  final double average;
  final int completedTasks;
  final int totalTasks;

  const WeeklyProgressCard({
    super.key,
    required this.progress,
    required this.average,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progression hebdomadaire",
            style: RoyalTypography.titleLarge,
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: RoyalColors.border,
              valueColor: const AlwaysStoppedAnimation(
                RoyalColors.royalBlue600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  title: "Moyenne",
                  value: average.toStringAsFixed(2),
                  color: RoyalColors.gold500,
                ),
              ),
              Expanded(
                child: _Metric(
                  title: "Terminés",
                  value: "$completedTasks/$totalTasks",
                  color: RoyalColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _Metric({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: RoyalRadius.md,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: RoyalTypography.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: RoyalTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}