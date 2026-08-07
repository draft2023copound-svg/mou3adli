import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';

class ReplyPreview extends StatelessWidget {
  final String author;
  final String text;
  final VoidCallback? onCancel;

  const ReplyPreview({
    super.key,
    required this.author,
    required this.text,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RoyalColors.royalBlue50,
        borderRadius: RoyalRadius.md,
        border: Border(
          left: BorderSide(
            color: RoyalColors.royalBlue600,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: RoyalColors.royalBlue600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: RoyalColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onCancel != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onCancel,
            ),
        ],
      ),
    );
  }
}