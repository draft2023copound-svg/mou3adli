import 'package:flutter/material.dart';
// removed unused foundation/colors import
import '../../foundation/radius.dart';
import '../../models/academic_message.dart';
import 'academic_message.dart';

class HomeworkMessage extends StatelessWidget {
  final AcademicMessage data;

  const HomeworkMessage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return AcademicMessageWidget(
      data: data,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade100,
              Colors.orange.shade50,
            ],
          ),
          borderRadius: RoyalRadius.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  "Devoir",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              data.message,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: RoyalRadius.md,
                ),
              ),
              child: const Text("Faire le devoir"),
            ),
          ],
        ),
      ),
    );
  }
}