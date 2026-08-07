import 'package:flutter/material.dart';
// removed unused radius import

class RoyalReaction {
  final String emoji;
  final String label;

  const RoyalReaction(this.emoji, this.label);
}

class RoyalReactionPicker extends StatelessWidget {
  final ValueChanged<RoyalReaction> onSelected;

  const RoyalReactionPicker({
    super.key,
    required this.onSelected,
  });

  static const reactions = [
    RoyalReaction("👍", "J'aime"),
    RoyalReaction("👏", "Bravo"),
    RoyalReaction("📚", "Utile"),
    RoyalReaction("💡", "Intéressant"),
    RoyalReaction("🔥", "Excellent"),
    RoyalReaction("🎉", "Félicitations"),
    RoyalReaction("❤️", "Merci"),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: reactions.map((reaction) {
            return InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () => onSelected(reaction),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  reaction.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}