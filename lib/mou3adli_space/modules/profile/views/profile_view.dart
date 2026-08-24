import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../foundation/colors.dart';
import '../../../foundation/typography.dart';
import '../../../widgets/navigation/royal_dock.dart';
import '../../../widgets/profile/academic_identity_card.dart';
import '../../../widgets/profile/academic_score_card.dart';
import '../../../widgets/profile/profile_header_delegate.dart';
import '../../../widgets/profile/average_evolution_card.dart';
import '../../../widgets/profile/academic_heatmap.dart';
import '../../../widgets/profile/stats_overview.dart';
import '../../../widgets/profile/profile_action_buttons.dart';
import '../../../widgets/profile/achievement_grid.dart';
import '../../../widgets/profile/academic_timeline.dart';
import '../../../widgets/profile/profile_sections.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoyalColors.background,
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: ProfileHeaderDelegate(
                  expandedHeight: 340,
                  child: _HeroHeader(controller),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 12),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    AcademicIdentityCard(
                      name: controller.user.name,
                      section: controller.user.section,
                      school: controller.user.school,
                      average: controller.user.average,
                      rank: controller.user.rank,
                      streak: controller.user.streak,
                      badges: controller.user.badges,
                      avatar: controller.user.avatar,
                    ),
                    AcademicScoreCard(
                      score: controller.academicScore.value,
                      average: controller.user.average,
                      rank: controller.user.rank,
                      streak: controller.user.streak,
                      xp: controller.user.xp,
                    ),
                    const SizedBox(height: 12),
                    AverageEvolutionCard(
                      values: controller.averageHistory,
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Activité",
                        style: RoyalTextStyles.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 14),
                    AcademicHeatmap(
                      values: controller.heatmap,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Statistiques",
                        style: RoyalTextStyles.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StatsOverview(
                      documents: controller.documents.value,
                      quizzes: controller.quizzes.value,
                      homework: controller.homework.value,
                      posts: controller.posts.value,
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Actions rapides",
                        style: RoyalTextStyles.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: ProfileActionButtons(
                        onEdit: controller.editProfile,
                        onShare: controller.shareProfile,
                        onQr: controller.showQrCode,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Récompenses",
                        style: RoyalTextStyles.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AchievementGrid(
                        achievements: controller.achievements,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Chronologie académique",
                        style: RoyalTextStyles.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AcademicTimeline(
                        events: controller.timeline,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        "Mon espace",
                        style: RoyalTextStyles.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: ProfileSections(
                        onDocuments: controller.openDocuments,
                        onHomework: controller.openHomework,
                        onQuiz: controller.openQuiz,
                        onPosts: controller.openPosts,
                        onSettings: controller.openSettings,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoyalDock(
        currentIndex: 4,
        onChanged: controller.changeTab,
        onCreate: controller.createPost,
        onExit: controller.exitSpace,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: RoyalColors.gold500,
        elevation: 0,
        icon: const Icon(Icons.edit),
        label: const Text("Modifier"),
        onPressed: controller.editProfile,
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final ProfileController controller;

  const _HeroHeader(this.controller);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                RoyalColors.royalBlue900,
                RoyalColors.royalBlue700,
                RoyalColors.royalBlue500,
              ],
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -40,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: .05),
            ),
          ),
        ),
        Positioned(
          bottom: -90,
          left: -50,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RoyalColors.gold500.withValues(alpha: .08),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),
          child: Container(),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: controller.openSettings,
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Hero(
                  tag: controller.user.id,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(
                      controller.user.avatar,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.user.name,
                  style: RoyalTextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  controller.user.section,
                  style: RoyalTextStyles.bodyLarge.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ],
    );
  }
}