import 'package:flutter/material.dart';
// removed unused foundation/colors import
import '../../foundation/radius.dart';

class ReactionBar extends StatelessWidget {
  final Map<String, int> reactions;

  const ReactionBar({
    super.key,
    required this.reactions,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: reactions.entries.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: RoyalRadius.full,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.key, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                e.value.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}