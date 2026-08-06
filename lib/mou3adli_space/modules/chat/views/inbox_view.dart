import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/dimens.dart';
import '../../../constants/styles.dart';
import '../../../widgets/avatar_widget.dart';
import 'p2p_chat_view.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = _mockConversations();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ═══ HEADER ═══
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Messages',
                    style: AppStyles.h1.copyWith(fontSize: 32),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 22),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

            // ═══ STORIES EN HAUT (comme Reelix) ═══
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 8,
                itemBuilder: (context, index) {
                  final isOnline = index < 3;
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            AvatarWidget(
                              name: 'User $index',
                              size: 64,
                              isStory: true,
                              hasStory: index % 2 == 0,
                            ),
                            if (isOnline)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.surface, width: 2.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'User $index',
                          style: AppStyles.caption,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms);
                },
              ),
            ),

            // ═══ DIVIDER ═══
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1, thickness: 1, color: AppColors.divider),
            ),

            // ═══ LISTE CONVERSATIONS ═══
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  return _buildConversationItem(conv, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> conv, int index) {
    final isUnread = conv['unread'] ?? false;

    return GestureDetector(
      onTap: () => Get.to(() => P2PChatView(userName: conv['name'])),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.royalBlue.withOpacity(0.03) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                AvatarWidget(
                  name: conv['name'],
                  size: 56,
                  isStory: false,
                ),
                if (conv['online'] == true)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conv['name'],
                        style: AppStyles.h3.copyWith(fontSize: 15),
                      ),
                      Text(
                        conv['time'],
                        style: AppStyles.caption.copyWith(
                          color: isUnread ? AppColors.royalBlue : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv['lastMessage'],
                          style: AppStyles.body.copyWith(
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                            color: isUnread ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.royalBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms).slideX(begin: -0.1, end: 0);
  }

  List<Map<String, dynamic>> _mockConversations() {
    return [
      {
        'name': 'M. Ben Ali',
        'lastMessage': "N'oublie pas le contrôle demain !",
        'time': '2m',
        'unread': true,
        'online': true,
      },
      {
        'name': 'Amine K.',
        'lastMessage': "T'as compris l'exo 3 ?",
        'time': '15m',
        'unread': true,
        'online': false,
      },
      {
        'name': 'Sana B.',
        'lastMessage': 'Merci pour la fiche de révision !',
        'time': '1h',
        'unread': false,
        'online': true,
      },
      {
        'name': 'Dr. Trabelsi',
        'lastMessage': 'Le cours est reporté à jeudi',
        'time': '3h',
        'unread': false,
        'online': false,
      },
      {
        'name': 'Youssef M.',
        'lastMessage': 'On se voit à la bibliothèque ?',
        'time': '1j',
        'unread': false,
        'online': false,
      },
    ];
  }
}