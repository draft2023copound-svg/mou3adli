import 'dart:ui';
import 'package:flutter/material.dart';
import '../../foundation/shadows.dart';
import 'royal_nav_item.dart';
import 'royal_create_button.dart';
import 'royal_exit_button.dart';

class RoyalDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final VoidCallback onCreate;
  final VoidCallback onExit;

  const RoyalDock({
    super.key,
    required this.currentIndex,
    required this.onChanged,
    required this.onCreate,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const RoyalNavItemData(icon: Icons.home_rounded, label: "Accueil"),
      const RoyalNavItemData(icon: Icons.auto_stories_rounded, label: "Cours"),
      const RoyalNavItemData(
          icon: Icons.chat_bubble_rounded, label: "Chats", badge: 3),
      const RoyalNavItemData(icon: Icons.person_rounded, label: "Profil"),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  height: 82,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.white.withOpacity(0.35),
                    ),
                    boxShadow: RoyalShadows.floating,
                  ),
                  child: Row(
                    children: [
                      RoyalNavItem(
                        item: items[0],
                        selected: currentIndex == 0,
                        onTap: () => onChanged(0),
                      ),
                      RoyalNavItem(
                        item: items[1],
                        selected: currentIndex == 1,
                        onTap: () => onChanged(1),
                      ),
                      const SizedBox(width: 72),
                      RoyalNavItem(
                        item: items[2],
                        selected: currentIndex == 2,
                        onTap: () => onChanged(2),
                      ),
                      RoyalNavItem(
                        item: items[3],
                        selected: currentIndex == 3,
                        onTap: () => onChanged(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -18,
              child: RoyalCreateButton(onTap: onCreate),
            ),
            Positioned(
              right: -6,
              top: -14,
              child: RoyalExitButton(onPressed: onExit),
            ),
          ],
        ),
      ),
    );
  }
}