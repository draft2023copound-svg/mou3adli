import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimens.dart';

class AvatarWidget extends StatelessWidget {
  final String? photoUrl;
  final String? name;
  final double size;
  final bool isStory;
  final bool hasStory;
  final bool isLive;
  final VoidCallback? onTap;

  const AvatarWidget({
    super.key,
    this.photoUrl,
    this.name,
    this.size = AppDimens.avatarMd,
    this.isStory = false,
    this.hasStory = false,
    this.isLive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name != null && name!.isNotEmpty
        ? name!.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.royalBlue.withOpacity(0.1),
        image: photoUrl != null && photoUrl!.isNotEmpty
            ? DecorationImage(image: NetworkImage(photoUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: photoUrl == null || photoUrl!.isEmpty
          ? Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w800,
                  color: AppColors.royalBlue,
                ),
              ),
            )
          : null,
    );

    // Anneau doré pour stories
    if (isStory && hasStory) {
      avatar = Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.storyGradient,
        ),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
          ),
          child: avatar,
        ),
      );
    }

    // Badge LIVE
    if (isLive) {
      avatar = Stack(
        alignment: Alignment.bottomCenter,
        children: [
          avatar,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.surface, width: 2),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: avatar,
    );
  }
}