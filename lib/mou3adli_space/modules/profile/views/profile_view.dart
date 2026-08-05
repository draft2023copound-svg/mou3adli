import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../widgets/avatar_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // App Bar
              SliverAppBar(
                backgroundColor: AppColors.surface,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
                title: const Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    color: AppColors.textSecondary,
                    onPressed: () {},
                  ),
                ],
              ),
              // Profile Info
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar & Stats
                      Row(
                        children: [
                          AvatarWidget(
                            photoUrl: null,
                            name: 'Vous',
                            size: 80,
                            isStory: true,
                            hasStory: true,
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStat('24', 'Posts'),
                                _buildStat('1.2k', 'Abonnés'),
                                _buildStat('156', 'Abonnements'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Name & Bio
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vous',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.royalBlue10,
                                borderRadius: AppStyles.radius6,
                              ),
                              child: const Text(
                                '🎓 Élève · 4ème Sciences',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.royalBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Passionné par les sciences et l'informatique. Toujours prêt à apprendre !",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              'Modifier le profil',
                              AppColors.gold,
                              AppColors.surface,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildActionButton(
                            'Partager',
                            AppColors.surface,
                            AppColors.textPrimary,
                            borderColor: AppColors.border,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Tab Bar
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: AppColors.gold,
                    unselectedLabelColor: AppColors.textTertiary,
                    indicatorColor: AppColors.gold,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'Posts'),
                      Tab(text: 'Sauvegardes'),
                      Tab(text: 'Matières'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildPostsGrid(),
              _buildSavesGrid(),
              _buildSubjectsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color bgColor, Color textColor, {Color? borderColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppStyles.radius10,
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPostsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Container(
          color: AppColors.surfaceElevated,
          child: Center(
            child: Icon(
              index % 3 == 0 ? Icons.image_outlined : Icons.text_snippet_outlined,
              color: AppColors.textTertiary,
              size: 28,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSavesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          color: AppColors.surfaceElevated,
          child: const Center(
            child: Icon(
              Icons.bookmark_outlined,
              color: AppColors.gold,
              size: 28,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectsList() {
    final subjects = [
      {'name': 'Math', 'icon': '📐', 'progress': 0.85},
      {'name': 'Physique', 'icon': '⚛️', 'progress': 0.72},
      {'name': 'Chimie', 'icon': '🧪', 'progress': 0.60},
      {'name': 'Français', 'icon': '📚', 'progress': 0.90},
      {'name': 'Informatique', 'icon': '💻', 'progress': 0.95},
      {'name': 'SVT', 'icon': '🌿', 'progress': 0.78},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppStyles.radius12,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Text(
                subject['icon'] as String,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: AppStyles.radiusFull,
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: subject['progress'] as double,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: AppStyles.radiusFull,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${((subject['progress'] as double) * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
