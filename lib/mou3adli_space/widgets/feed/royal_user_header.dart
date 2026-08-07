import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';
import '../avatar/royal_avatar.dart';

class RoyalUserHeader extends StatelessWidget {
  final String avatar;
  final String name;
  final String subtitle;
  final String? badge;
  final bool verified;
  final VoidCallback? onTap;
  final Widget? trailing;

  const RoyalUserHeader({
    super.key,
    required this.avatar,
    required this.name,
    required this.subtitle,
    this.badge,
    this.verified = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: RoyalRadius.full,
      onTap: onTap,
      child: Row(
        children: [
          Hero(
            tag: avatar,
            child: RoyalAvatar(
              image: avatar,
              verified: verified,
              size: 56,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: RoyalTypography.titleLarge,
                      ),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: RoyalColors.gold500,
                          borderRadius: RoyalRadius.full,
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: RoyalTypography.bodySmall.copyWith(
                    color: RoyalColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: RoyalColors.royalBlue50,
                borderRadius: RoyalRadius.full,
              ),
              child: Text(
                badge!,
                style: RoyalTypography.labelSmall.copyWith(
                  color: RoyalColors.royalBlue600,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}