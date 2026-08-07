import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';

class StatsOverview extends StatelessWidget {
  final int documents;
  final int quizzes;
  final int homework;
  final int posts;

  const StatsOverview({
    super.key,
    required this.documents,
    required this.quizzes,
    required this.homework,
    required this.posts,
  });

  Widget _item(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: RoyalRadius.lg,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _item(documents.toString(), "PDF", Colors.red),
        _item(quizzes.toString(), "Quiz", Colors.green),
        _item(homework.toString(), "Devoirs", Colors.orange),
        _item(posts.toString(), "Posts", RoyalColors.royalBlue600),
      ],
    );
  }
}