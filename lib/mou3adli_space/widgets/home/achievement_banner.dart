import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
// removed unused spacing import
import '../cards/royal_card.dart';

class AchievementBanner extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const AchievementBanner({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              RoyalColors.gold400.withOpacity(0.18),
              RoyalColors.royalBlue100.withOpacity(0.10),
            ],
          ),
          borderRadius: RoyalRadius.lg,
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    RoyalColors.gold400,
                    RoyalColors.gold600,
                  ],
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: RoyalTypography.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: RoyalTypography.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}