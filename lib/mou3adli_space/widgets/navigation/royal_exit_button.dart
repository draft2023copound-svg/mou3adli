import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../../foundation/shadows.dart';
import '../../foundation/motion.dart';

class RoyalExitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RoyalExitButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: RoyalMotion.normal,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: RoyalColors.gold500,
          borderRadius: RoyalRadius.full,
          boxShadow: RoyalShadows.glowGold,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "Mou3adli",
              style: RoyalTypography.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}