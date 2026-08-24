import 'package:flutter/material.dart';
import '../../foundation/radius.dart';

class Achievement {
  final IconData icon;
  final String title;
  final Color color;
  final bool unlocked;

  const Achievement({
    required this.icon,
    required this.title,
    required this.color,
    this.unlocked = true,
  });
}

class AchievementGrid extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementGrid({
    super.key,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: achievements.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (c, i) {
        final item = achievements[i];
        return Container(
          decoration: BoxDecoration(
            color: item.unlocked
                ? item.color.withValues(alpha: 0.08)
                : Colors.grey.shade100,
            borderRadius: RoyalRadius.lg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 34,
                color: item.unlocked ? item.color : Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}