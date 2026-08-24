import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
// removed unused typography import

enum PostType {
  announcement,
  teacher,
  student,
  quiz,
  exercise,
  pdf,
  video,
  poll,
  live,
  achievement,
}

class PostTypeBadge extends StatelessWidget {
  final PostType type;

  const PostTypeBadge({
    super.key,
    required this.type,
  });

  Color get color {
    switch (type) {
      case PostType.teacher:
        return RoyalColors.gold600;
      case PostType.student:
        return RoyalColors.royalBlue600;
      case PostType.quiz:
        return Colors.green;
      case PostType.pdf:
        return Colors.red;
      case PostType.video:
        return Colors.deepPurple;
      case PostType.poll:
        return Colors.orange;
      case PostType.live:
        return Colors.pink;
      case PostType.exercise:
        return Colors.teal;
      case PostType.announcement:
        return RoyalColors.warning;
      case PostType.achievement:
        return RoyalColors.success;
    }
  }

  IconData get icon {
    switch (type) {
      case PostType.teacher:
        return Icons.school;
      case PostType.student:
        return Icons.person;
      case PostType.quiz:
        return Icons.quiz;
      case PostType.pdf:
        return Icons.picture_as_pdf;
      case PostType.video:
        return Icons.play_circle;
      case PostType.live:
        return Icons.sensors;
      case PostType.exercise:
        return Icons.edit_note;
      case PostType.poll:
        return Icons.poll;
      case PostType.announcement:
        return Icons.campaign;
      case PostType.achievement:
        return Icons.workspace_premium;
    }
  }

  String get label {
    switch (type) {
      case PostType.teacher:
        return "Professeur";
      case PostType.student:
        return "Élève";
      case PostType.quiz:
        return "Quiz";
      case PostType.exercise:
        return "Exercice";
      case PostType.pdf:
        return "PDF";
      case PostType.video:
        return "Vidéo";
      case PostType.live:
        return "Live";
      case PostType.poll:
        return "Sondage";
      case PostType.announcement:
        return "Annonce";
      case PostType.achievement:
        return "Succès";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: RoyalRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}