import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
// removed unused spacing import
import '../cards/royal_card.dart';

class DailyQuizCard extends StatelessWidget {
  final String title;
  final int questions;
  final String duration;
  final int reward;
  final VoidCallback? onPressed;

  const DailyQuizCard({
    super.key,
    required this.title,
    required this.questions,
    required this.duration,
    required this.reward,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 8),
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
                    colors: [Colors.green, Colors.teal],
                  ),
                  borderRadius: RoyalRadius.lg,
                ),
                child: const Icon(
                  Icons.quiz,
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
                      style: RoyalTypography.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text("$questions questions"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18),
              const SizedBox(width: 6),
              Text(duration),
              const Spacer(),
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
                  "+$reward XP",
                  style: RoyalTypography.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPressed,
              child: const Text("Commencer le Quiz"),
            ),
          ),
        ],
      ),
    );
  }
}