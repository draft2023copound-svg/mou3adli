import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/strings.dart';
import '../../../constants/styles.dart';
import '../controllers/post_controller.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostController());
    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Nouvelle publication',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.gold,
          ),
        ),
        actions: [
          Obx(() => TextButton(
            onPressed: controller.canPublish.value ? controller.createPost : null,
            child: Text(
              AppStrings.publish,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: controller.canPublish.value ? AppColors.gold : AppColors.textHint,
              ),
            ),
          )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceElevated,
                        ),
                        child: const Center(
                          child: Text(
                            'V',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vous',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.royalBlue10,
                              borderRadius: AppStyles.radius4,
                            ),
                            child: const Text(
                              '🎓 Élève',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.royalBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Text input
                  TextField(
                    controller: textController,
                    maxLines: null,
                    minLines: 6,
                    maxLength: 500,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: AppStrings.postHint,
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textHint,
                      ),
                      border: InputBorder.none,
                      counterStyle: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    onChanged: controller.updateContent,
                  ),
                  const SizedBox(height: 16),
                  // Tags
                  const Text(
                    'Matière',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppStrings.subjects.map((subject) {
                      final isSelected = controller.selectedTags.contains(subject);
                      return GestureDetector(
                        onTap: () => controller.toggleTag(subject),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.gold : Colors.transparent,
                            borderRadius: AppStyles.radius8,
                            border: Border.all(
                              color: isSelected ? AppColors.gold : AppColors.border,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            subject,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? AppColors.surface : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
                ],
              ),
            ),
          ),
          // Bottom toolbar
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
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  color: AppColors.gold,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.videocam_outlined),
                  color: AppColors.gold,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.poll_outlined),
                  color: AppColors.gold,
                  onPressed: () {},
                ),
                const Spacer(),
                Text(
                  'Visible par tous',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
