import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../models/academic_message.dart';
import 'academic_message.dart';

class TeacherMessage extends StatelessWidget {
  final AcademicMessage data;

  const TeacherMessage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return AcademicMessageWidget(
      data: data,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: RoyalColors.gold100,
              borderRadius: RoyalRadius.full,
            ),
            child: const Text(
              "Professeur",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.message,
            style: TextStyle(
              height: 1.5,
              fontSize: 15,
              color: data.mine ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}