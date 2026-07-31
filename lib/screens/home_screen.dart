import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../providers/games_provider.dart';
import '../widgets/app_bottom_nav.dart';
import 'subject_list_screen.dart';
import 'term_selection_screen.dart';
import '../calendar_new/calendar_main_screen.dart';
import '../game/screens/games_hub_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const _NotesTab(),
    const GamesHubScreen(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// HOME TAB (Dashboard)
// ═══════════════════════════════════════════════════════════

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final annualAvg = provider.annualAverage;
        final rankings = provider.subjectRankings as List<Map<String, dynamic>>? ?? [];

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(provider),
                const SizedBox(height: 24),
                _buildAverageCard(annualAvg),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                if (rankings.isNotEmpty) _buildTopSubjects(rankings),
                const SizedBox(height: 24),
                _buildGamesPreview(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getUserName(AppProvider provider) {
    final user = provider.user;
    if (user == null) return 'Élève';
    return user.fullName;
  }

  Widget _buildHeader(AppProvider provider) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppGradients.royalBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Salut, ${_getUserName(provider)} !',
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Prêt à exceller ?',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAverageCard(double annualAvg) {
    final isExcellent = annualAvg >= 16;
    final isGood = annualAvg >= 12;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isExcellent
            ? AppGradients.matteGold
            : isGood
                ? AppGradients.royalBlue
                : AppGradients.success,
        borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
        boxShadow: [AppShadows.colored(AppColors.royalBlue, 0.2)],
      ),
      child: Column(
        children: [
          Text(
            'MOYENNE ANNUELLE',
            style: AppTextStyles.label.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            annualAvg.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isExcellent
                ? '🏆 Excellence !'
                : isGood
                    ? '👍 Très bien'
                    : '💪 Continue tes efforts',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.calculate_rounded,
        label: 'Calculer',
        color: AppColors.royalBlue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SubjectListScreen()),
        ),
      ),
      _ActionItem(
        icon: Icons.calendar_month_rounded,
        label: 'Agenda',
        color: const Color(0xFF8B5CF6),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CalendarMainScreen()),
        ),
      ),
      _ActionItem(
        icon: Icons.bar_chart_rounded,
        label: 'Bulletin',
        color: const Color(0xFF22C55E),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TermSelectionScreen()),
        ),
      ),
      _ActionItem(
        icon: Icons.extension_rounded,
        label: 'Jeux',
        color: AppColors.matteGold,
        onTap: () {}, // Géré par BottomNav
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Accès rapide', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions.map((a) => _buildActionButton(a)).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton(_ActionItem action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(action.icon, color: action.color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSubjects(List<Map<String, dynamic>> rankings) {
    final top3 = rankings.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tes forces', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        ...top3.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final medals = ['🥇', '🥈', '🥉'];
          
          final subject = item['nameFr'] as String;
          final avg = (item['average'] as num).toDouble();

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              border: Border.all(color: AppColors.border),
              boxShadow: [AppShadows.small],
            ),
            child: Row(
              children: [
                Text(medals[index], style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    subject,
                    style: AppTextStyles.bodyLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.royalBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    avg.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.royalBlue,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGamesPreview(BuildContext context) {
    return Consumer<GamesProvider>(
      builder: (context, games, _) {
        if (games.memoryMaxLevel <= 1 && games.quizBestScore == 0) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progression jeux', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
                border: Border.all(color: AppColors.border),
                boxShadow: [AppShadows.small],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _GameStat(
                      icon: '🧠',
                      label: 'Memory',
                      value: 'Niv. ${games.memoryMaxLevel}',
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.divider),
                  Expanded(
                    child: _GameStat(
                      icon: '🎯',
                      label: 'Quiz',
                      value: '${games.quizBestScore}/10',
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppColors.divider),
                  Expanded(
                    child: _GameStat(
                      icon: '🏆',
                      label: 'Badges',
                      value: '${games.badges.length}',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _GameStat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _GameStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// NOTES TAB
// ═══════════════════════════════════════════════════════════

class _NotesTab extends StatelessWidget {
  const _NotesTab();

  @override
  Widget build(BuildContext context) {
    return const SubjectListScreen();
  }
}

// ═══════════════════════════════════════════════════════════
// PROFILE TAB
// ═══════════════════════════════════════════════════════════

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  // ✅ Fonction déplacée ici car elle n'est utilisée que par ce widget
  String _getUserDetails(AppProvider provider) {
    final user = provider.user;
    if (user == null) return '';
    return '${user.cycle} - ${user.displayClass}';
  }

  String _getUserName(AppProvider provider) {
    final user = provider.user;
    if (user == null) return 'Élève';
    return user.fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppGradients.royalBlue,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getUserName(provider),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getUserDetails(provider),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSettingsTile(
                  icon: Icons.logout_rounded,
                  label: 'Déconnexion',
                  color: AppColors.error,
                  onTap: () => provider.logout(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}