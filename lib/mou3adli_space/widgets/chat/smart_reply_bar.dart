import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';

class SmartReplyBar extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  const SmartReplyBar({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              suggestions[index],
              style: RoyalTypography.labelMedium.copyWith(
                color: RoyalColors.royalBlue600,
              ),
            ),
            backgroundColor: RoyalColors.royalBlue50,
            side: BorderSide(color: RoyalColors.royalBlue100),
            shape: RoundedRectangleBorder(
              borderRadius: RoyalRadius.full,
            ),
            onPressed: () => onSelected(suggestions[index]),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: suggestions.length,
      ),
    );
  }
}