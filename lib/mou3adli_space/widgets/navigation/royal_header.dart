import 'dart:ui';
import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/typography.dart';
import '../avatar/royal_avatar.dart';
import '../buttons/royal_icon_button.dart';
import '../search/royal_search_bar.dart';

class RoyalHeader extends StatelessWidget {
  final String username;
  final String subtitle;
  final String avatar;
  final int notificationCount;
  final VoidCallback? onNotification;
  final VoidCallback? onMessages;
  final ValueChanged<String>? onSearch;

  const RoyalHeader({
    super.key,
    required this.username,
    required this.subtitle,
    required this.avatar,
    this.notificationCount = 0,
    this.onNotification,
    this.onMessages,
    this.onSearch,
  });

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return "Bonjour";
    if (h < 18) return "Bon après-midi";
    return "Bonsoir";
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                RoyalColors.royalBlue600.withOpacity(0.06),
                Theme.of(context).brightness == Brightness.dark
                    ? RoyalColors.darkBackground
                    : Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: RoyalColors.border),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  RoyalAvatar(image: avatar, size: 62),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_greeting()} 👋",
                          style: RoyalTypography.bodyMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          username,
                          style: RoyalTypography.displaySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: RoyalTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  RoyalIconButton(
                    icon: Icons.chat_outlined,
                    onPressed: onMessages,
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      RoyalIconButton(
                        icon: Icons.notifications_none,
                        onPressed: onNotification,
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: RoyalColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notificationCount > 9
                                  ? "9+"
                                  : notificationCount.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              RoyalSearchBar(
                hint: "Cours, professeurs, documents...",
                onChanged: onSearch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}