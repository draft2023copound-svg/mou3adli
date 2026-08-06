import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/dimens.dart';
import '../../../../constants/styles.dart';
import '../../../../models/user.dart';
import '../../../../widgets/avatar_widget.dart';

class StoriesBar extends StatelessWidget {
  final List<UserModel> stories;

  const StoriesBar({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length + 1, // +1 for "Add Story"
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStory();
          }
          final user = stories[index - 1];
          return _buildStory(user);
        },
      ),
    );
  }

  Widget _buildAddStory() {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: AppDimens.avatarStory,
            height: AppDimens.avatarStory,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.royalBlue.withOpacity(0.08),
              border: Border.all(
                color: AppColors.royalBlue.withOpacity(0.2),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.royalBlue,
              size: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ton Story',
            style: AppStyles.caption.copyWith(
              color: AppColors.royalBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildStory(UserModel user) {
    final isLive = user.name?.contains('Ben Ali') ?? false; // Mock live

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          AvatarWidget(
            photoUrl: user.photoUrl,
            name: user.name,
            size: AppDimens.avatarStory,
            isStory: true,
            hasStory: true,
            isLive: isLive,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: AppDimens.avatarStory,
            child: Text(
              user.name?.split(' ').first ?? '',
              style: AppStyles.caption,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (100 * (stories.indexOf(user) + 2)).ms).slideX(begin: -0.2, end: 0);
  }
}