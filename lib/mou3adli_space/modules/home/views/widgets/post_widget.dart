import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../constants/styles.dart';
import '../../../../models/post.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/avatar_widget.dart';
import '../../../../widgets/expandable_text.dart';
import '../../../post/views/post_detail_view.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likedBy?.contains('currentUserId') ?? false;
    final isSaved = post.savedBy?.contains('currentUserId') ?? false;
    final isProf = post.role == 'prof';

    return GestureDetector(
      onTap: () => Get.to(() => PostDetailView(post: post)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(isProf),
            const SizedBox(height: 10),
            // Content
            _buildContent(),
            // Poll (if applicable)
            if (post.type == 'poll' && post.pollOptions != null)
              _buildPoll(),
            const SizedBox(height: 12),
            // Actions
            _buildActions(isLiked, isSaved),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isProf) {
    return Row(
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
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          color: AppColors.textTertiary,
          iconSize: 20,
          onPressed: () => _showOptions(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ExpandableText(
      text: post.content ?? '',
      maxLines: 4,
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
          const SizedBox(height: 8),
          Text(
            '${post.pollOptions?.fold<int>(0, (sum, o) => sum + (o['votes'] as int))} votes',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollOption(String text, int percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
        ],
      ),
    );
  }

  Widget _buildActions(bool isLiked, bool isSaved) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          count: post.likes ?? 0,
          isActive: isLiked,
          activeColor: AppColors.danger,
          onTap: onLike,
        ),
        _buildActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          count: post.comments ?? 0,
          onTap: onComment,
        ),
        _buildActionButton(
          icon: Icons.repeat_rounded,
          count: post.shares ?? 0,
          onTap: onShare,
        ),
        _buildActionButton(
          icon: Icons.send_outlined,
          onTap: onShare,
        ),
        _buildActionButton(
          icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          isActive: isSaved,
          activeColor: AppColors.gold,
          onTap: onSave,
        ),
      ],
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? (activeColor ?? AppColors.gold) : AppColors.textTertiary,
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 4),
              Text(
                Utility.formatNumber(count),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? (activeColor ?? AppColors.gold) : AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppStyles.radiusFull,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
                title: const Text(AppStrings.share, style: TextStyle(color: AppColors.textPrimary)),
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_border_rounded, color: AppColors.textSecondary),
                title: const Text(AppStrings.save, style: TextStyle(color: AppColors.textPrimary)),
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined, color: AppColors.textSecondary),
                title: const Text(AppStrings.report, style: TextStyle(color: AppColors.textPrimary)),
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: const Icon(Icons.block_flipped, color: AppColors.danger),
                title: const Text(AppStrings.block, style: TextStyle(color: AppColors.danger)),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
