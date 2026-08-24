import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/shadows.dart';

enum RoyalUserRole {
  student,
  teacher,
  admin,
  premium,
}

class RoyalAvatar extends StatelessWidget {
  final String image;
  final double size;
  final bool online;
  final bool verified;
  final bool premium;
  final RoyalUserRole role;
  final VoidCallback? onTap;
  final String? heroTag;

  const RoyalAvatar({
    super.key,
    required this.image,
    this.size = 56,
    this.online = false,
    this.verified = false,
    this.premium = false,
    this.role = RoyalUserRole.student,
    this.onTap,
    this.heroTag,
  });

  Color get _ringColor {
    if (premium) return RoyalColors.gold500;
    switch (role) {
      case RoyalUserRole.teacher:
        return RoyalColors.gold500;
      case RoyalUserRole.admin:
        return Colors.deepPurple;
      case RoyalUserRole.premium:
        return RoyalColors.gold500;
      case RoyalUserRole.student:
        return RoyalColors.royalBlue500;
    }
  }

  double get _ringWidth {
    if (premium || role == RoyalUserRole.teacher) return 2.5;
    return 2.0;
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ring glow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _ringColor.withValues(alpha: 0.25),
                  blurRadius: size * 0.3,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Avatar with ring
          Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(_ringWidth),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _ringColor,
                width: _ringWidth,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: RoyalColors.gray200,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: RoyalColors.gray200,
                  child: Icon(
                    Icons.person,
                    size: size * 0.4,
                    color: RoyalColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          // Online indicator
          if (online)
            Positioned(
              right: size * 0.05,
              bottom: size * 0.05,
              child: Container(
                width: size * 0.22,
                height: size * 0.22,
                decoration: BoxDecoration(
                  color: RoyalColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.5,
                  ),
                  boxShadow: RoyalShadows.soft,
                ),
              ),
            ),
          // Verified badge
          if (verified)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: const BoxDecoration(
                  color: RoyalColors.gold500,
                  shape: BoxShape.circle,
                  boxShadow: RoyalShadows.glowGold,
                ),
                child: const Icon(
                  Icons.verified,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: avatar);
    }
    return avatar;
  }
}