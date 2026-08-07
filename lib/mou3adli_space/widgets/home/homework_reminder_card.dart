import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
// removed unused spacing import
import '../cards/royal_card.dart';

class HomeworkReminderCard extends StatelessWidget {
  final String subject;
  final String teacher;
  final DateTime dueDate;
  final int exercises;
  final VoidCallback? onPressed;

  const HomeworkReminderCard({
    super.key,
    required this.subject,
    required this.teacher,
    required this.dueDate,
    required this.exercises,
    this.onPressed,
  });

  int get daysLeft => dueDate.difference(DateTime.now()).inDays;

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
                  color: RoyalColors.error.withOpacity(0.1),
                  borderRadius: RoyalRadius.lg,
                ),
                child: const Icon(
                  Icons.assignment,
                  color: RoyalColors.error,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: RoyalTypography.titleLarge,
                    ),
                    Text(
                      teacher,
                      style: RoyalTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: RoyalColors.error,
                  borderRadius: RoyalRadius.full,
                ),
                child: Text(
                  "$daysLeft j",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            "$exercises exercices à rendre",
            style: RoyalTypography.bodyLarge,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Ouvrir"),
          ),
        ],
      ),
    );
  }
}