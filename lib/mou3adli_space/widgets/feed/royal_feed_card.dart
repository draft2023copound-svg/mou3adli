import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
// removed unused spacing import
import '../cards/royal_card.dart';

class RoyalFeedCard extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget? footer;
  final Widget? actions;
  final VoidCallback? onTap;
  final EdgeInsets margin;

  const RoyalFeedCard({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.actions,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 8,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return RoyalCard(
      onTap: onTap,
      margin: margin,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: header,
          ),
          body,
          if (actions != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: actions!,
            ),
          ],
          if (footer != null) ...[
            const Divider(height: 1, color: RoyalColors.border),
            footer!,
          ],
        ],
      ),
    );
  }
}