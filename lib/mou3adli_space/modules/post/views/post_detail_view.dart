import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../constants/styles.dart';
import '../../../models/post.dart';
import '../../../utils/utility.dart';
import '../../../widgets/avatar_widget.dart';
import '../../../widgets/expandable_text.dart';
import '../controllers/post_controller.dart';

class PostDetailView extends StatelessWidget {
  final PostModel post;

  const PostDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostController());
    final replyController = TextEditingController();
    final isProf = post.role == 'prof';
    final isLiked = post.likedBy?.contains('currentUserId') ?? false;
    final isSaved = post.savedBy?.contains('currentUserId') ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textSecondary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Discussion',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post header
                  Row(
                    children: [
                      AvatarWidget(
                        photoUrl: post.userPhotoUrl,
                        name: post.name,
                        size: 40,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  post.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isProf ? AppColors.gold10 : AppColors.royalBlue10,
                                    borderRadius: AppStyles.radius6,
                                    border: Border.all(
                                      color: isProf ? AppColors.gold.withOpacity(0.3) : AppColors.royalBlue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '${Utility.getRoleEmoji(post.role)} ${Utility.getRoleLabel(post.role)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isProf ? AppColors.gold : AppColors.royalBlue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.royalBlue10,
                                    borderRadius: AppStyles.radius4,
                                  ),
                                  child: Text(
                                    post.matiere ?? 'Général',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.royalBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              Utility.getTimeAgo(
                                post.createdAt?.toDate() ?? DateTime.now().subtract(const Duration(hours: 2)),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Content
                  ExpandableText(
                    text: post.content ?? '',
                    maxLines: 100,
                  ),
                  // Poll
                  if (post.type == 'poll' && post.pollOptions != null)
                    _buildPoll(),
                  const SizedBox(height: 16),
                  // Actions
                  Row(
                    children: [
                      _buildActionButton(
                        icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        count: post.likes ?? 0,
                        isActive: isLiked,
                        activeColor: AppColors.danger,
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.chat_bubble_outline_rounded,
                        count: post.comments ?? 0,
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.repeat_rounded,
                        count: post.shares ?? 0,
                        onTap: () {},
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.send_outlined,
                        onTap: () {},
                      ),
                      const Spacer(),
                      _buildActionButton(
                        icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        isActive: isSaved,
                        activeColor: AppColors.gold,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),
                  // Comments section
                  const Text(
                    'Commentaires',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Mock comments
                  _buildComment('Amine K.', 'Merci Monsieur !', '1h'),
                  _buildComment('Sana B.', "Est-ce qu'on aura les lois binomiales ?", '45min'),
                ],
              ),
            ),
          ),
          // Reply box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceElevated,
                  ),
                  child: const Center(
                    child: Text(
                      'V',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: replyController,
                    decoration: InputDecoration(
                      hintText: AppStrings.addComment,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textHint,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: AppStyles.radius12,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (replyController.text.trim().isNotEmpty) {
                      controller.addComment(post.postId!, replyController.text);
                      replyController.clear();
                    }
                  },
                  child: const Text(
                    'Envoyer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoll() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppStyles.radius12,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Sondage',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: 10),
          ...?post.pollOptions?.map((option) {
            return _buildPollOption(
              option['text'] as String,
              option['percentage'] as int,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPollOption(String text, int percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppStyles.radius8,
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  Container(
                    width: (Get.width - 80) * (percentage / 100),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      borderRadius: AppStyles.radius8,
                    ),
                  ),
                  Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$percentage%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    bool isActive = false,
    Color? activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? (activeColor ?? AppColors.gold) : AppColors.textTertiary,
          ),
          if (count != null && count > 0) ...[
            const SizedBox(width: 4),
            Text(
              Utility.formatNumber(count),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? (activeColor ?? AppColors.gold) : AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComment(String name, String text, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.border,
            width: 2.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceElevated,
                ),
                child: Center(
                  child: Text(
                    Utility.getInitials(name),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14.5,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "J'aime",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Répondre',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
