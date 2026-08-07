import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../avatar/royal_avatar.dart';
import '../cards/royal_card.dart';

class RoyalComposer extends StatelessWidget {
  final String avatar;
  final VoidCallback? onTap;
  final VoidCallback? onPhoto;
  final VoidCallback? onPdf;
  final VoidCallback? onQuiz;
  final VoidCallback? onPoll;

  const RoyalComposer({
    super.key,
    required this.avatar,
    this.onTap,
    this.onPhoto,
    this.onPdf,
    this.onQuiz,
    this.onPoll,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Column(
        children: [
          Row(
            children: [
              RoyalAvatar(image: avatar, size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: RoyalColors.background,
                      borderRadius: RoyalRadius.full,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Partager quelque chose...",
                      style: RoyalTypography.bodyMedium.copyWith(
                        color: RoyalColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ComposerAction(
                icon: Icons.image_outlined,
                color: Colors.green,
                label: "Photo",
                onTap: onPhoto,
              ),
              _ComposerAction(
                icon: Icons.picture_as_pdf_outlined,
                color: Colors.red,
                label: "PDF",
                onTap: onPdf,
              ),
              _ComposerAction(
                icon: Icons.quiz_outlined,
                color: Colors.deepPurple,
                label: "Quiz",
                onTap: onQuiz,
              ),
              _ComposerAction(
                icon: Icons.poll_outlined,
                color: Colors.orange,
                label: "Sondage",
                onTap: onPoll,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  const _ComposerAction({
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: RoyalRadius.full,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(label, style: RoyalTypography.labelMedium),
          ],
        ),
      ),
    );
  }
}