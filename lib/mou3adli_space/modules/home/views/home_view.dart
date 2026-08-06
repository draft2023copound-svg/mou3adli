import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../constants/styles.dart';
import '../../../widgets/glass_bottom_nav.dart';
import '../../chat/views/inbox_view.dart';
import '../../post/views/create_post_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/home_controller.dart';
import 'widgets/post_widget.dart';
import 'widgets/stories_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final screens = [
      _buildFeed(controller),
      _buildTrending(),
      const SizedBox.shrink(), // Placeholder for FAB
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GlassBottomNav(
        currentIndex: controller.currentIndex.value,
        onTap: (index) {
          if (index == 2) {
            Get.to(() => const CreatePostView(), transition: Transition.downToUp);
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
        // ═══ HEADER ═══
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.appName,
                      style: AppStyles.h2.copyWith(
                        fontSize: 24,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildHeaderButton(Icons.search_rounded),
                    const SizedBox(width: 8),
                    _buildHeaderButton(Icons.notifications_outlined, hasBadge: true),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
        ),

        // ═══ STORIES ═══
        SliverToBoxAdapter(
          child: StoriesBar(stories: controller.stories),
        ),

        // ═══ DIVIDER ═══
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
        ),

        // ═══ POSTS ═══
        Obx(() => SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
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
          ),
        )),

        // ═══ BOTTOM PADDING FOR NAVBAR ═══
        const SliverToBoxAdapter(
          child: SizedBox(height: 120),
        ),
      ],
    );
  }

  Widget _buildHeaderButton(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 22),
        ),
        if (hasBadge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTrending() {
    return const Center(
      child: Text(
        'Tendance',
        style: AppStyles.h2,
      ),
    );
  }
}