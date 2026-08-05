import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../constants/styles.dart';
import '../../../widgets/avatar_widget.dart';
import '../controllers/chat_controller.dart';
import 'p2p_chat_view.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.inbox,
                    style: AppStyles.style20Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          // Online stories bar
          SliverToBoxAdapter(
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.conversations.length,
                itemBuilder: (context, index) {
                  final user = controller.conversations[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        AvatarWidget(
                          photoUrl: user.photoUrl,
                          name: user.name,
                          size: 56,
                          isStory: true,
                          hasStory: true,
                          onTap: () {},
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.name?.split(' ')[0] ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),
          ),
          // Divider
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),
          // Messages list
          Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final user = controller.conversations[index];
                final isUnread = index < 2; // Mock unread

                return GestureDetector(
                  onTap: () => Get.to(() => P2PChatView(user: user)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
                      ),
                    ),
                    child: Row(
                      children: [
                        AvatarWidget(
                          photoUrl: user.photoUrl,
                          name: user.name,
                          size: 48,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.name ?? '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (isUnread) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                index == 0 
                                    ? "N'oublie pas le DS jeudi."
                                    : index == 1 
                                        ? 'Tu as la fiche de chimie ?'
                                        : "Quelqu'un pour réviser ce soir ?",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isUnread ? AppColors.textSecondary : AppColors.textTertiary,
                                  fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          index == 0 ? '10min' : index == 1 ? '1h' : '2h',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: controller.conversations.length,
            ),
          )),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }
}
