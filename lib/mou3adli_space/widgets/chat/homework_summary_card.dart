import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
// removed unused spacing import
import '../cards/royal_card.dart';

class HomeworkSummaryCard extends StatelessWidget {
  final String title;
  final int exercises;
  final String dueDate;
  final VoidCallback onOpen;

  const HomeworkSummaryCard({
    super.key,
    required this.title,
    required this.exercises,
    required this.dueDate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      color: Colors.orange.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: RoyalRadius.md,
                ),
                child: const Icon(
                  Icons.assignment_rounded,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Devoir",
                      style: RoyalTypography.labelLarge.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: RoyalTypography.titleLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.format_list_numbered_rounded,
                  size: 18, color: RoyalColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                "$exercises exercices",
                style: RoyalTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.event_rounded,
                  size: 18, color: RoyalColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                dueDate,
                style: RoyalTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onOpen,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: RoyalRadius.full,
                ),
              ),
              child: const Text("Faire le devoir"),
            ),
          ),
        ],
      ),
    );
  }
}