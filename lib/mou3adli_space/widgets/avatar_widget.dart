import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';
import '../utils/utility.dart';

class AvatarWidget extends StatelessWidget {
  final String? photoUrl;
  final String? name;
  final double size;
  final bool isLive;
  final bool isStory;
  final bool hasStory;
  final VoidCallback? onTap;

  const AvatarWidget({
    Key? key,
    this.photoUrl,
    this.name,
    this.size = 40.0,
    this.isLive = false,
    this.isStory = false,
    this.hasStory = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceElevated,
        border: Border.all(
          color: AppColors.borderLight,
          width: 1.5,
        ),
      ),
      child: photoUrl != null && photoUrl!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(),
              ),
            )
          : _buildInitials(),
    );

    if (isStory && hasStory) {
      avatar = Container(
        width: size + 6,
        height: size + 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isLive
              ? const LinearGradient(
                  colors: [AppColors.liveRed, AppColors.liveRedLight],
                )
              : const LinearGradient(
                  colors: [AppColors.gold, AppColors.goldLight, AppColors.royalBlueLight, AppColors.gold],
                ),
        ),
        child: Center(
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            padding: const EdgeInsets.all(2.5),
            child: ClipOval(
              child: photoUrl != null && photoUrl!.isNotEmpty
                  ? Image.network(photoUrl!, fit: BoxFit.cover)
                  : _buildInitialsContent(),
            ),
          ),
        ),
      );
    }

    if (isLive) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.liveRed,
                  borderRadius: AppStyles.radius4,
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  Widget _buildInitials() {
    return Center(child: _buildInitialsContent());
  }

  Widget _buildInitialsContent() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceElevated,
      ),
      child: Center(
        child: Text(
          Utility.getInitials(name ?? '?'),
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w600,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }
}
