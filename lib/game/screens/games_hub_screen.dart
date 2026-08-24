import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/games_provider.dart';
import 'memory_screen.dart';
import 'quiz_screen.dart';

class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<GamesProvider>(
          builder: (context, games, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  if (games.badges.isNotEmpty) ...[
                    _buildBadges(games),
                    const SizedBox(height: 24),
                  ],
                  _buildStats(games),
                  const SizedBox(height: 32),
                  _buildGameCard(
                    title: 'MEMORY',
                    subtitle: 'Teste ta mémoire visuelle',
                    icon: Icons.grid_view_rounded,
                    gradient: AppGradients.royalBlue,
                    description: '50 niveaux de difficulté croissante. Flash rouge, miroir, blackout...',
                    stats: 'Niveau max: ${games.memoryMaxLevel}',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MemoryScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildGameCard(
                    title: 'CULTURE G',
                    subtitle: 'Défie tes connaissances',
                    icon: Icons.psychology_rounded,
                    gradient: AppGradients.matteGold,
                    description: '56 questions sur sport, musique, sciences, cinéma et littérature.',
                    stats: 'Meilleur: ${games.quizBestScore}/10',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.royalBlue,
        borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
        boxShadow: [AppShadows.colored(AppColors.royalBlue, 0.25)],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.games_rounded,
            color: AppColors.matteGold,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'ZONE DE JEUX',
            style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Choisis ton défi et bats tes records',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges(GamesProvider games) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tes badges', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: games.badges.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final badge = games.badges[index];
              return Container(
                width: 80,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [AppShadows.small],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      games.getBadgeIcon(badge),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      games.getBadgeLabel(badge),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStats(GamesProvider games) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
        border: Border.all(color: AppColors.border),
        boxShadow: [AppShadows.small],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.games_rounded,
            label: 'Parties',
            value: '${games.memoryGamesPlayed + games.quizGamesPlayed}',
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _StatItem(
            icon: Icons.star_rounded,
            label: 'Score total',
            value: '${games.totalScore}',
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _StatItem(
            icon: Icons.emoji_events_rounded,
            label: 'Badges',
            value: '${games.badges.length}',
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required String description,
    required String stats,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXXLarge),
          border: Border.all(color: AppColors.border),
          boxShadow: [AppShadows.medium],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [AppShadows.colored(gradient.colors[0], 0.3)],
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.royalBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      stats,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.royalBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.matteGold, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}