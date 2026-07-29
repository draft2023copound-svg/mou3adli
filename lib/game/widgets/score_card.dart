import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class ScoreCard extends StatelessWidget {
  final int score;
  final int bestScore;
  final int combo;
  final bool isNewBest;

  const ScoreCard({
    super.key,
    required this.score,
    required this.bestScore,
    required this.combo,
    this.isNewBest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kBoardBackgroundColor,
            kBoardBackgroundColor.lighten(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNewBest ? kWarningColor.withOpacity(0.5) : kCellBorderColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: kWarningColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'SCORE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kSecondaryTextColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: kFadeDuration,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              score.formatted,
              key: ValueKey<int>(score),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: kPrimaryTextColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kAccentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: isNewBest ? kWarningColor : kSecondaryTextColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Best: ${bestScore.formatted}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isNewBest ? kWarningColor : kSecondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}