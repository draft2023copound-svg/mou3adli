import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';

class AcademicContextBar extends StatelessWidget {
  final String subject;
  final String teacher;
  final String average;
  final String nextHomework;
  final VoidCallback? onHomework;
  final VoidCallback? onSubject;

  const AcademicContextBar({
    super.key,
    required this.subject,
    required this.teacher,
    required this.average,
    required this.nextHomework,
    this.onHomework,
    this.onSubject,
  });

  Widget _chip(
    IconData icon,
    String text,
    Color color,
    VoidCallback? onTap,
  ) {
    return InkWell(
      borderRadius: RoyalRadius.full,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: RoyalRadius.full,
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: RoyalTypography.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _chip(Icons.school_rounded, subject, RoyalColors.royalBlue600, onSubject),
          const SizedBox(width: 10),
          _chip(Icons.person_rounded, teacher, RoyalColors.gold600, null),
          const SizedBox(width: 10),
          _chip(Icons.auto_graph_rounded, average, RoyalColors.success, null),
          const SizedBox(width: 10),
          _chip(Icons.assignment_rounded, nextHomework, Colors.orange, onHomework),
        ],
      ),
    );
  }
}