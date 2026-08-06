import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/dimens.dart';
import '../../../../constants/styles.dart';
import '../../../../models/post.dart';
import '../../../../widgets/avatar_widget.dart';
import '../../../../widgets/expandable_text.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onSave;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostWidget({
    super.key,
    required this.post,
    this.onLike,
    this.onSave,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══ HEADER ═══
          Padding(
            padding: const EdgeInsets.all(AppDimens.padLg),
            child: Row(
              children: [
                AvatarWidget(
                  photoUrl: post.userPhotoUrl,
                  name: post.name,
                  size: AppDimens.avatarMd,
                  isStory: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.name ?? '',
                            style: AppStyles.h3.copyWith(fontSize: 15),
                          ),
                          if (post.isAnnouncement == true) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(AppDimens.radiusXs),
                              ),
                              child: const Text(
                                '📢 Annonce',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _buildRoleBadge(post.role, post.matiere),
                          const SizedBox(width: 8),
                          Text(
                            '• 2h',
                            style: AppStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: AppColors.textTertiary, size: 20),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // ═══ CONTENU ═══
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.padLg),
            child: ExpandableText(text: post.content ?? ''),
          ),

          // ═══ MÉDIA ═══
          if (post.mediaUrls != null && post.mediaUrls!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.padLg),
              child: _buildMediaGrid(post.mediaUrls!),
            ),

          // ═══ SONDAGE ═══
          if (post.type == 'poll' && post.pollOptions != null)
            Padding(
              padding: const EdgeInsets.all(AppDimens.padLg),
              child: _buildPoll(post.pollOptions!),
            ),

          // ═══ ACTIONS ═══
          Padding(
            padding: const EdgeInsets.all(AppDimens.padLg),
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  count: post.likes ?? 0,
                  isActive: post.likedBy?.contains('currentUserId') ?? false,
                  activeColor: AppColors.danger,
                  onTap: onLike,
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  count: post.comments ?? 0,
                  onTap: onComment,
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.send_outlined,
                  count: post.shares ?? 0,
                  onTap: onShare,
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.bookmark_border_rounded,
                  activeIcon: Icons.bookmark_rounded,
                  isActive: post.savedBy?.contains('currentUserId') ?? false,
                  activeColor: AppColors.gold,
                  onTap: onSave,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms);
  }

  Widget _buildRoleBadge(String? role, String? matiere) {
    final isProf = role == 'prof';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isProf ? AppColors.royalBlue.withOpacity(0.08) : AppColors.gold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusXs),
        border: Border.all(
          color: isProf ? AppColors.royalBlue.withOpacity(0.2) : AppColors.gold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isProf ? Icons.school_outlined : Icons.person_outline,
            size: 10,
            color: isProf ? AppColors.royalBlue : AppColors.goldDark,
          ),
          const SizedBox(width: 4),
          Text(
            isProf ? (matiere ?? 'Professeur') : 'Élève',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isProf ? AppColors.royalBlue : AppColors.goldDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid(List<String> mediaUrls) {
    if (mediaUrls.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Image.network(
          mediaUrls[0],
          fit: BoxFit.cover,
          width: double.infinity,
          height: 280,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: mediaUrls.length,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: Image.network(mediaUrls[index], fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildPoll(List<dynamic> options) {
    return Column(
      children: options.map((option) {
        final percentage = option['percentage'] ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Stack(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.royalBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 40,
                width: percentage * 3, // Mock width
                decoration: BoxDecoration(
                  gradient: AppColors.blueGradient,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option['text'] ?? '',
                        style: AppStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: AppStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    IconData? activeIcon,
    int? count,
    bool isActive = false,
    Color? activeColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isActive ? (activeIcon ?? icon) : icon,
              key: ValueKey(isActive),
              color: isActive ? (activeColor ?? AppColors.royalBlue) : AppColors.textTertiary,
              size: AppDimens.iconMd,
            ),
          ),
          if (count != null && count > 0) ...[
            const SizedBox(width: 4),
            Text(
              _formatCount(count),
              style: AppStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isActive ? (activeColor ?? AppColors.royalBlue) : AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}