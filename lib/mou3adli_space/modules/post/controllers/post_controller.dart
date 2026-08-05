import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<String> selectedTags = <String>[].obs;
  final RxString postContent = ''.obs;
  final RxBool canPublish = false.obs;

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void updateContent(String content) {
    postContent.value = content;
    canPublish.value = content.trim().isNotEmpty;
  }

  Future<void> createPost() async {
    if (!canPublish.value) return;

    isLoading.value = true;

    // TODO: Implémenter l'appel Firebase
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;
    Get.back();
    Get.snackbar(
      'Succès',
      'Publication envoyée !',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF7A),
      colorText: Colors.white,
    );
  }

  Future<void> addComment(String postId, String text) async {
    if (text.trim().isEmpty) return;

    // TODO: Implémenter l'appel Firebase
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> deletePost(String postId) async {
    // TODO: Implémenter l'appel Firebase
  }
}
