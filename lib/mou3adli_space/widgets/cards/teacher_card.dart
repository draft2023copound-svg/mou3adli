import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../../foundation/spacing.dart';
import '../avatar/royal_avatar.dart';
import 'royal_card.dart';

class TeacherCard extends StatelessWidget {
  final String avatar;
  final String name;
  final String subject;
  final double rating;
  final bool online;
  final bool verified;
  final String? school;
  final VoidCallback? onTap;
  final VoidCallback? onMessage;

  const TeacherCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.subject,
    required this.rating,
    this.online = false,
    this.verified = true,
    this.school,
    this.onTap,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.symmetric(
        horizontal: RoyalSpacing.lg,
        vertical: RoyalSpacing.sm,
      ),
      onTap: onTap,
      child: Row(
        children: [
          RoyalAvatar(
            image: avatar,
            role: RoyalUserRole.teacher,
            verified: verified,
            online: online,
            size: 62,
          ),
          const SizedBox(width: RoyalSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: RoyalTypography.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  subject,
                  style: RoyalTypography.bodyMedium.copyWith(
                    color: RoyalColors.textSecondary,
                  ),
                ),
                if (school != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    school!,
                    style: RoyalTypography.bodySmall,
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: RoyalColors.gold500,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: RoyalTypography.labelLarge,
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: online
                            ? RoyalColors.success
                            : RoyalColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      online ? "Disponible" : "Hors ligne",
                      style: RoyalTypography.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: RoyalColors.royalBlue600,
              shape: RoundedRectangleBorder(
                borderRadius: RoyalRadius.full,
              ),
            ),
            onPressed: onMessage,
            icon: const Icon(Icons.chat, size: 18),
            label: const Text("Message"),
          ),
        ],
      ),
    );
  }
}