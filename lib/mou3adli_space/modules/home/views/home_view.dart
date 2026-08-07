import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../foundation/colors.dart';
import '../../../foundation/spacing.dart';
import '../../../widgets/layout/royal_sliver_page.dart';
import '../../../widgets/navigation/royal_header.dart';
import '../../../widgets/navigation/royal_dock.dart';
import '../../../engine/feed_builder.dart';
import '../../../engine/feed_engine.dart';
import '../../../models/feed_item.dart';
import '../../../widgets/cards/announcement_card.dart';
import '../../../widgets/cards/teacher_card.dart';
import '../../../widgets/home/royal_academic_pulse.dart';
import '../../../widgets/home/academic_subjects.dart';
import '../../../widgets/home/royal_daily_challenge.dart';
import '../../../widgets/home/continue_learning_card.dart';
// removed unused import homework_reminder_card
import '../../../widgets/home/daily_quiz_card.dart';
import '../../../widgets/home/study_streak_card.dart';
import '../../../widgets/home/weekly_progress_card.dart';
import '../../../widgets/home/achievement_banner.dart';
import '../../../widgets/home/trending_subjects.dart';
import '../../../widgets/loading/royal_skeleton.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) {
        return const _LoadingView();
      }

      return RoyalSliverPage(
        header: RoyalHeader(
          username: controller.user.name,
          subtitle: controller.user.classroom,
          avatar: controller.user.avatar,
          notificationCount: controller.notifications.value,
        ),
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: RoyalColors.gold500,
          elevation: 0,
          onPressed: controller.createResource,
          child: const Icon(Icons.add),
        ),
        bottomNavigation: RoyalDock(
          currentIndex: 0,
          onChanged: controller.changeTab,
          onCreate: controller.createResource,
          onExit: controller.exitSpace,
        ),
        onRefresh: controller.refresh,
        slivers: [
          // Academic Pulse — Dashboard intelligent
          SliverToBoxAdapter(
            child: AcademicPulse(
              average: controller.user.average,
              announcements: controller.notifications.value,
              assignments: controller.completedHomework.value,
              replies: controller.unreadMessages.value,
              documents: 0,
            ),
          ),

          // Continue Learning
          SliverToBoxAdapter(
            child: ContinueLearningCard(
              title: "Trigonométrie",
              teacher: "M. Ben Salah",
              progress: 0.72,
              remainingLessons: 3,
              duration: "18 min",
              onPressed: controller.resumeLesson,
            ),
          ),

          // Daily Challenge
          SliverToBoxAdapter(
            child: RoyalDailyChallenge(
              title: "Défi du jour",
              description: "Réponds correctement à 5 questions de mathématiques.",
              xp: 150,
              progress: 0.45,
              onPressed: controller.openDailyChallenge,
            ),
          ),

          // Matières
          SliverToBoxAdapter(
            child: AcademicSubjects(
              subjects: controller.subjects,
              onSubjectPressed: controller.openSubject,
            ),
          ),

          // Annonce
          if (controller.announcement != null)
            SliverToBoxAdapter(
              child: AnnouncementCard(
                title: controller.announcement!.title,
                description: controller.announcement!.content,
                teacher: controller.announcement!.teacher,
                date: controller.announcement!.date,
                onTap: controller.openAnnouncement,
              ),
            ),

          // Quiz du jour
          SliverToBoxAdapter(
            child: DailyQuizCard(
              title: "Quiz de Physique",
              questions: 12,
              duration: "10 min",
              reward: 50,
              onPressed: controller.startQuiz,
            ),
          ),

          // Study Streak
          SliverToBoxAdapter(
            child: StudyStreakCard(
              streak: controller.streak.value,
              todayMinutes: controller.todayMinutes.value,
              weeklyMinutes: controller.weeklyMinutes.value,
            ),
          ),

          // Weekly Progress
          SliverToBoxAdapter(
            child: WeeklyProgressCard(
              progress: controller.weekProgress.value,
              average: controller.user.average,
              completedTasks: controller.completedTasks.value,
              totalTasks: controller.totalTasks.value,
            ),
          ),

          // Achievement Banner
          SliverToBoxAdapter(
            child: AchievementBanner(
              title: "Excellent travail",
              description: "Tu as gagné 3 places cette semaine.",
              icon: Icons.workspace_premium_rounded,
            ),
          ),

          // Trending Subjects
          SliverToBoxAdapter(
            child: TrendingSubjects(
              subjects: controller.trendingSubjects.toList(),
              onTap: controller.openSubject,
            ),
          ),

          // Le Feed principal
          RoyalFeedBuilder(
            sections: FeedEngine().build(
              feed: controller.feed.cast<FeedItem>().toList(),
              announcements: controller.announcements,
              quizzes: controller.quizzes,
              subjects: controller.subjects,
            ),
          ),

          // Professeur recommandé
          SliverToBoxAdapter(
            child: TeacherCard(
              avatar: controller.recommendedTeacher.avatar,
              name: controller.recommendedTeacher.name,
              subject: controller.recommendedTeacher.subject,
              rating: controller.recommendedTeacher.rating,
              online: controller.recommendedTeacher.online,
              onMessage: controller.messageTeacher,
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      );
    });
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoyalColors.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(RoyalSpacing.lg),
          children: [
            const SizedBox(height: 20),
            Row(
              children: const [
                RoyalSkeleton(width: 58, height: 58),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    children: [
                      RoyalSkeleton(width: double.infinity, height: 18),
                      SizedBox(height: 12),
                      RoyalSkeleton(width: 160, height: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const RoyalSkeleton(width: double.infinity, height: 160),
            const SizedBox(height: 20),
            const RoyalSkeleton(width: double.infinity, height: 90),
            const SizedBox(height: 20),
            ...List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: RoyalSkeleton(width: double.infinity, height: 280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}