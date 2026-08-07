import 'package:flutter/material.dart';
import '../../models/subject_model.dart';
import '../../widgets/home/royal_subject_card.dart';
// removed unused spacing import

class AcademicSubjects extends StatelessWidget {
  final List<SubjectModel> subjects;
  final void Function(SubjectModel)? onSubjectPressed;

  const AcademicSubjects({
    super.key,
    required this.subjects,
    this.onSubjectPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 140,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          scrollDirection: Axis.horizontal,
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final s = subjects[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: RoyalSubjectCard(
                icon: s.icon,
                subject: s.name,
                unread: s.unread,
                color: s.color,
                onTap: () => onSubjectPressed?.call(s),
              ),
            );
          },
        ),
      ),
    );
  }
}
