import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStory();
          }
          final story = stories[index - 1];
          return _buildStoryItem(story);
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
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(
                color: AppColors.border,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.gold,
              size: 28,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ajouter',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(UserModel story) {
    final isProf = story.role == 'prof';
    final isLive = isProf && story.uid == '1'; // Mock: M. Ben Ali is live

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          AvatarWidget(
            photoUrl: story.photoUrl,
            name: story.name,
            size: 64,
            isStory: true,
            hasStory: true,
            isLive: isLive,
            onTap: () {
              Get.snackbar(
                'Story',
                'Story de ${story.name}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.surface,
                colorText: AppColors.textPrimary,
              );
            },
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 68,
            child: Text(
              story.name ?? '',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
