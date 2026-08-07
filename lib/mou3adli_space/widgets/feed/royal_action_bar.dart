import 'package:flutter/material.dart';
import '../buttons/royal_icon_button.dart';

class RoyalActionBar extends StatelessWidget {
  final int likes;
  final int comments;
  final int shares;
  final bool liked;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;

  const RoyalActionBar({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.liked,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoyalIconButton(
          icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          onPressed: onLike,
          selected: liked,
          color: liked ? Colors.red : null,
        ),
        Text("$likes"),
        const SizedBox(width: 12),
        RoyalIconButton(
          icon: Icons.chat_bubble_outline,
          onPressed: onComment,
        ),
        Text("$comments"),
        const Spacer(),
        RoyalIconButton(
          icon: Icons.bookmark_outline,
          onPressed: onBookmark,
        ),
        RoyalIconButton(
          icon: Icons.share_outlined,
          onPressed: onShare,
        ),
      ],
    );
  }
}