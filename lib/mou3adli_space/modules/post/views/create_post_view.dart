import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/dimens.dart';
import '../../../constants/styles.dart';
import '../../../widgets/avatar_widget.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Nouvelle publication', style: AppStyles.h3),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.blueGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Publier',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AvatarWidget(name: 'Amine K.', size: 48),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amine K.', style: AppStyles.h3.copyWith(fontSize: 16)),
                    Text('Élève • Public', style: AppStyles.caption),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Qu'est-ce qui te passe par la tête ?",
                  hintStyle: AppStyles.body.copyWith(color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMediaButton(Icons.image_outlined, 'Photo', AppColors.success),
                  _buildMediaButton(Icons.videocam_outlined, 'Vidéo', AppColors.danger),
                  _buildMediaButton(Icons.poll_outlined, 'Sondage', AppColors.warning),
                  _buildMediaButton(Icons.mic_outlined, 'Audio', AppColors.royalBlue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaButton(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppStyles.caption.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}