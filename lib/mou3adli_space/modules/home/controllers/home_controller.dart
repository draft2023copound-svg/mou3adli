import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/subject_model.dart';

/// =======================================================
/// MOU3ADLI SPACE — Home Controller
/// GetX Controller with reactive state management
/// =======================================================

class UserModel {
  final String id;
  final String name;
  final String avatar;
  final String classroom;
  final String section;
  final String school;
  final double average;
  final int rank;
  final int streak;
  final int badges;
  final int xp;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.classroom,
    required this.section,
    required this.school,
    required this.average,
    required this.rank,
    required this.streak,
    required this.badges,
    required this.xp,
  });
}

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String teacher;
  final DateTime date;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.teacher,
    required this.date,
  });
}

class TeacherModel {
  final String id;
  final String name;
  final String avatar;
  final String subject;
  final double rating;
  final bool online;
  final String school;

  TeacherModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.subject,
    required this.rating,
    required this.online,
    required this.school,
  });
}

class HomeController extends GetxController {
  // ======================================================
  // LOADING STATE
  // ======================================================
  final RxBool loading = true.obs;

  // ======================================================
  // USER DATA
  // ======================================================
  late final UserModel user;

  // ======================================================
  // NOTIFICATIONS
  // ======================================================
  final RxInt notifications = 0.obs;

  // ======================================================
  // ACADEMIC PULSE
  // ======================================================
  final RxInt completedHomework = 0.obs;
  final RxInt unreadMessages = 0.obs;
  final RxInt upcomingExams = 0.obs;

  // ======================================================
  // PROGRESS
  // ======================================================
  final RxDouble weekProgress = 0.0.obs;
  final RxInt completedTasks = 0.obs;
  final RxInt totalTasks = 0.obs;
  final RxInt studyHours = 0.obs;

  // ======================================================
  // STREAK & STATS
  // ======================================================
  final RxInt streak = 0.obs;
  final RxInt todayMinutes = 0.obs;
  final RxInt weeklyMinutes = 0.obs;

  // ======================================================
  // ANNOUNCEMENT
  // ======================================================
  AnnouncementModel? announcement;

  // ======================================================
  // TEACHER
  // ======================================================
  late final TeacherModel recommendedTeacher;

  // ======================================================
  // LISTS
  // ======================================================
  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;
  final RxList<dynamic> feed = <dynamic>[].obs;
  final RxList<dynamic> announcements = <dynamic>[].obs;
  final RxList<dynamic> quizzes = <dynamic>[].obs;
  final RxList<SubjectModel> trendingSubjects = <SubjectModel>[].obs;

  // ======================================================
  // AVERAGE HISTORY
  // ======================================================
  final RxList<double> averageHistory = <double>[].obs;

  // ======================================================
  // HEATMAP
  // ======================================================
  final RxList<int> heatmap = <int>[].obs;

  // ======================================================
  // INIT
  // ======================================================
  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  // ======================================================
  // MOCK DATA LOADER
  // ======================================================
  void _loadMockData() async {
    loading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Simulate network

    user = UserModel(
      id: "user_001",
      name: "Ahmed Ben Salah",
      avatar: "https://i.pravatar.cc/150?img=11",
      classroom: "2ème Sciences",
      section: "Section Scientifique",
      school: "Lycée Pilote de Tunis",
      average: 15.82,
      rank: 12,
      streak: 7,
      badges: 14,
      xp: 2840,
    );

    notifications.value = 3;
    completedHomework.value = 5;
    unreadMessages.value = 12;
    upcomingExams.value = 2;

    weekProgress.value = 0.72;
    completedTasks.value = 18;
    totalTasks.value = 25;
    studyHours.value = 42;

    streak.value = 7;
    todayMinutes.value = 135;
    weeklyMinutes.value = 840;

    announcement = AnnouncementModel(
      id: "ann_001",
      title: "Contrôle de Mathématiques",
      content: "Le contrôle de mathématiques aura lieu vendredi prochain. Le programme porte sur les suites numériques et les fonctions logarithmiques.",
      teacher: "M. Karim Ben Ammar",
      date: DateTime.now().add(const Duration(days: 3)),
    );

    recommendedTeacher = TeacherModel(
      id: "teach_001",
      name: "Mme. Fatma Trabelsi",
      avatar: "https://i.pravatar.cc/150?img=5",
      subject: "Physique-Chimie",
      rating: 4.8,
      online: true,
      school: "Lycée Pilote de Tunis",
    );

    subjects.value = [
      SubjectModel(id: "1", name: "Math", icon: Icons.calculate, color: Colors.blue, unread: 4),
      SubjectModel(id: "2", name: "Physique", icon: Icons.science, color: Colors.orange, unread: 3),
      SubjectModel(id: "3", name: "Info", icon: Icons.computer, color: Colors.green, unread: 6),
      SubjectModel(id: "4", name: "Français", icon: Icons.menu_book, color: Colors.purple, unread: 2),
      SubjectModel(id: "5", name: "Anglais", icon: Icons.language, color: Colors.red, unread: 1),
    ];

    trendingSubjects.value = subjects.take(3).toList();

    averageHistory.value = [12.5, 13.2, 14.1, 14.8, 15.3, 15.82];

    heatmap.value = List.generate(49, (i) => [0, 1, 2, 3][i % 4]);

    feed.value = [];
    announcements.value = [];
    quizzes.value = [];

    loading.value = false;
  }

  // ======================================================
  // ACTIONS
  // ======================================================
  void changeTab(int index) {
    // Navigation logic
  }

  void createResource() {
    Get.toNamed('/create');
  }

  void exitSpace() {
    Get.offAllNamed('/main');
  }

  @override
  Future<void> refresh() async {
    _loadMockData();
  }
  

  void openHomework() => Get.toNamed('/homework');
  void openTeachers() => Get.toNamed('/teachers');
  void openCalendar() => Get.toNamed('/calendar');
  void openDocuments() => Get.toNamed('/documents');
  void openLeaderboard() => Get.toNamed('/leaderboard');
  void openQuiz() => Get.toNamed('/quiz');
  void openSubject(SubjectModel subject) => Get.toNamed('/subject/${subject.id}');
  void openAnnouncement() => Get.toNamed('/announcement/${announcement?.id}');
  void startQuiz() => Get.toNamed('/quiz/daily');
  void openDailyChallenge() => Get.toNamed('/challenge');
  void resumeLesson() => Get.toNamed('/lesson/resume');
  void messageTeacher() => Get.toNamed('/chat/${recommendedTeacher.id}');
}