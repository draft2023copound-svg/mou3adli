import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../widgets/profile/achievement_grid.dart';
import '../../../widgets/profile/academic_timeline.dart';

class ProfileController extends GetxController {
  final RxBool loading = true.obs;

  // Simple user model for the profile screen
  late final User user;

  final RxDouble academicScore = 0.0.obs;
  final RxList<double> averageHistory = <double>[].obs;
  final RxList<int> heatmap = <int>[].obs;
  final RxInt documents = 0.obs;
  final RxInt quizzes = 0.obs;
  final RxInt homework = 0.obs;
  final RxInt posts = 0.obs;

  final RxList<Achievement> achievements = <Achievement>[].obs;
  final RxList<TimelineEvent> timeline = <TimelineEvent>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMock();
  }

  Future<void> _loadMock() async {
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    user = User(
      id: 'user_001',
      name: 'Ahmed Ben Salah',
      avatar: 'https://i.pravatar.cc/150?img=11',
      section: 'Section Scientifique',
      school: 'Lycée Pilote de Tunis',
      average: 15.82,
      rank: 12,
      streak: 7,
      badges: 14,
      xp: 2840,
    );

    academicScore.value = 1582;
    averageHistory.value = [12.5, 13.2, 14.1, 14.8, 15.3, 15.82];
    heatmap.value = List.generate(49, (i) => i % 4);
    documents.value = 12;
    quizzes.value = 6;
    homework.value = 4;
    posts.value = 23;

    achievements.value = [
      const Achievement(
        title: 'Top Student',
        icon: Icons.workspace_premium_rounded,
        color: Colors.amber,
      ),
    ];

    timeline.value = [
      TimelineEvent(
        title: 'Contrôle',
        subtitle: 'Maths',
        date: DateTime.now(),
        icon: Icons.check_circle,
        color: Colors.blue,
      ),
    ];

    loading.value = false;
  }

  Future<void> refreshProfile() async {
    await _loadMock();
  }

  void editProfile() {}
  void shareProfile() {}
  void showQrCode() {}

  void openDocuments() {}
  void openHomework() {}
  void openQuiz() {}
  void openPosts() {}
  void openSettings() {}

  void changeTab(int index) {}
  void createPost() {}
  void exitSpace() {}
}

class User {
  final String id;
  final String name;
  final String avatar;
  final String section;
  final String school;
  final double average;
  final int rank;
  final int streak;
  final int badges;
  final int xp;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.section,
    required this.school,
    required this.average,
    required this.rank,
    required this.streak,
    required this.badges,
    required this.xp,
  });
}
