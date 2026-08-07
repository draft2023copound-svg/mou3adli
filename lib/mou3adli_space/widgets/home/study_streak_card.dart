import 'package:flutter/material.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../cards/royal_card.dart';

class StudyStreakCard extends StatelessWidget {
  final int streak;
  final int todayMinutes;
  final int weeklyMinutes;
  final VoidCallback? onTap;

  const StudyStreakCard({
    super.key,
    required this.streak,
    required this.todayMinutes,
    required this.weeklyMinutes,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffff9800),
                      Color(0xffff5722),
                    ],
                  ),
                  borderRadius: RoyalRadius.lg,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Study Streak",
                      style: RoyalTypography.titleLarge,
                    ),
                    Text(
                      "$streak jours consécutifs",
                      style: RoyalTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Text(
                "🔥",
                style: TextStyle(fontSize: 34),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _Info(
                  title: "Aujourd'hui",
                  value: "$todayMinutes min",
                ),
              ),
              Expanded(
                child: _Info(
                  title: "Cette semaine",
                  value: "$weeklyMinutes min",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String title;
  final String value;

  const _Info({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: RoyalTypography.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: RoyalTypography.bodySmall,
        ),
      ],
    );
  }
}