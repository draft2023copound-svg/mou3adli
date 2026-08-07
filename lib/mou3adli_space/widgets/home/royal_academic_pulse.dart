import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/typography.dart';
import '../cards/royal_card.dart';

class AcademicPulse extends StatelessWidget {
  final double average;
  final int announcements;
  final int assignments;
  final int replies;
  final int documents;

  const AcademicPulse({
    super.key,
    required this.average,
    required this.announcements,
    required this.assignments,
    required this.replies,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: RoyalColors.gold100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: RoyalColors.gold700,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Academic Pulse",
                      style: RoyalTypography.titleLarge,
                    ),
                    Text(
                      "Résumé intelligent de votre journée",
                      style: RoyalTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _Item(Icons.campaign_outlined, "$announcements annonces importantes"),
          _Item(Icons.assignment_outlined, "$assignments devoirs à rendre"),
          _Item(Icons.menu_book_outlined, "$documents nouveaux documents"),
          _Item(Icons.forum_outlined, "$replies nouvelles réponses"),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: RoyalColors.royalBlue50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: RoyalColors.royalBlue600,
                ),
                const SizedBox(width: 12),
                Text(
                  "Moyenne actuelle : $average",
                  style: RoyalTypography.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Item(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: RoyalColors.royalBlue600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: RoyalTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}