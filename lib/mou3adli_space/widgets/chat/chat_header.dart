import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/typography.dart';
import '../avatar/royal_avatar.dart';

class ChatHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String avatar;
  final bool online;
  final VoidCallback? onCall;
  final VoidCallback? onVideo;
  final VoidCallback? onMore;

  const ChatHeader({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatar,
    required this.online,
    this.onCall,
    this.onVideo,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? RoyalColors.darkSurface
              : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? RoyalColors.darkBorder
                  : RoyalColors.border,
            ),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : RoyalColors.textPrimary,
            ),
            RoyalAvatar(
              image: avatar,
              size: 44,
              online: online,
              role: RoyalUserRole.teacher,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: RoyalTypography.titleLarge.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : RoyalColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    online ? "En ligne" : subtitle,
                    style: RoyalTypography.bodySmall.copyWith(
                      color: online
                          ? RoyalColors.success
                          : RoyalColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCall,
              icon: const Icon(Icons.call_rounded),
              color: RoyalColors.royalBlue600,
            ),
            IconButton(
              onPressed: onVideo,
              icon: const Icon(Icons.videocam_rounded),
              color: RoyalColors.royalBlue600,
            ),
            IconButton(
              onPressed: onMore,
              icon: const Icon(Icons.more_vert_rounded),
              color: RoyalColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}