import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/shadows.dart';
import '../../foundation/typography.dart';
// removed unused motion import

class RoyalNavItemData {
  final IconData icon;
  final String label;
  final int badge;
  final Color? activeColor;

  const RoyalNavItemData({
    required this.icon,
    required this.label,
    this.badge = 0,
    this.activeColor,
  });
}

class RoyalNavItem extends StatelessWidget {
  final RoyalNavItemData item;
  final bool selected;
  final VoidCallback onTap;

  const RoyalNavItem({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: RoyalRadius.full,
          onTap: onTap,
          child: SizedBox(
            height: 64,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutBack,
                  width: selected ? 118 : 52,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected
                        ? (item.activeColor ?? RoyalColors.royalBlue600)
                        : Colors.transparent,
                    borderRadius: RoyalRadius.full,
                    boxShadow: selected ? RoyalShadows.glowBlue : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        color: selected
                            ? Colors.white
                            : (isDark
                                ? RoyalColors.darkTextSecondary
                                : RoyalColors.textSecondary),
                        size: 22,
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        child: selected
                            ? Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    item.label,
                                    style: RoyalTypography.labelLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                if (item.badge > 0)
                  Positioned(
                    top: 6,
                    right: selected ? 6 : 18,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: RoyalColors.error,
                        borderRadius: RoyalRadius.full,
                        boxShadow: RoyalShadows.glowError,
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        item.badge > 99 ? "99+" : item.badge.toString(),
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
          ),
        ),
      ),
    );
  }
}