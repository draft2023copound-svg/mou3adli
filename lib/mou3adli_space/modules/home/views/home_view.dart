import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../constants/styles.dart';
import '../../../widgets/glass_bottom_nav.dart';
import '../../chat/views/inbox_view.dart';
import '../../post/views/create_post_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';
import 'widgets/stories_bar.dart';
import 'widgets/post_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final screens = [
      _buildFeed(controller),
      _buildTrending(),
      const SizedBox(), // Placeholder for FAB
      const InboxView(),
      const ProfileView(),
    ];

    return Obx(() => Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GlassBottomNav(
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          if (index == 2) {
            Get.to(() => const CreatePostView());
          } else {
            controller.changeTab(index);
          }
        },
      ),
    ));
  }

  Widget _buildFeed(HomeController controller) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '⚜️ ',
                      style: AppStyles.style20Bold.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                    Text(
                      AppStrings.appName,
                      style: AppStyles.style20Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search_rounded),
                      color: AppColors.textSecondary,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      color: AppColors.textSecondary,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Stories
        SliverToBoxAdapter(
          child: StoriesBar(stories: controller.stories),
        ),
        // Divider
        const SliverToBoxAdapter(
          child: Divider(height: 1, thickness: 1, color: AppColors.border),
        ),
        // Posts
        Obx(() => SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final post = controller.posts[index];
              return PostWidget(
                post: post,
                onLike: () => controller.toggleLike(post.postId!),
                onSave: () => controller.toggleSave(post.postId!),
                onComment: () {},
                onShare: () {},
              );
            },
            childCount: controller.posts.length,
          ),
        )),
        // Bottom padding for FAB
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildTrending() {
    return const Center(
      child: Text(
        'Tendance',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
