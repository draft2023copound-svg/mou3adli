import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';
import 'grade_entry_screen.dart';

class MatieresScreen extends StatelessWidget {
  const MatieresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final isDark = provider.isDarkMode;
        final user = provider.user;
        final term = provider.currentTerm;

        final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB);
        final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
        final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
        final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);
        final cardShadow = isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.04);

        if (term == null) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: textMuted),
                  const SizedBox(height: 16),
                  Text(
                    "Aucun trimestre sélectionné",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        final List<Subject> subjects = term.subjects.cast<Subject>();

        // Trier par coefficient décroissant
        final sortedSubjects = List<Subject>.of(subjects)
          ..sort((a, b) => b.coefficient.compareTo(a.coefficient));

        // ═══════════════════════════════════════════════════
        // 3 INFOS FLOTTANTES EN HAUT
        // ═══════════════════════════════════════════════════
        final totalCoeff = sortedSubjects.fold(
          0.0, (sum, s) => sum + s.coefficient.toDouble(),
        );
        final maxCoeff = sortedSubjects.isNotEmpty
            ? sortedSubjects.first.coefficient.toDouble()
            : 1.0;
        final matiereCount = sortedSubjects.length;

        // Titre de la classe
        final displayClass = user?.displayClass ?? '';
        final displayStream = user?.displayStream ?? '';
        final classLevel = user?.classLevel ?? '';
        final hasStream = classLevel == '2eme' || classLevel == '3eme' || classLevel == '4eme';
        final title = (hasStream && displayStream.isNotEmpty)
            ? '$displayClass — $displayStream'
            : displayClass;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Matières',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 8),

              // Badge classe
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C3F7A).withOpacity(.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1C3F7A).withOpacity(.15)),
                  ),
                  child: Text(
                    title.isNotEmpty ? title : 'Matières du trimestre',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C3F7A)),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ═══════════════════════════════════════════════════
              // 3 CARTES STATS FLOTTANTES
              // ═══════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.functions_rounded,
                        label: 'Total Coef.',
                        value: totalCoeff.toStringAsFixed(1),
                        color: const Color(0xFF1C3F7A),
                        surfaceColor: surfaceColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        cardShadow: cardShadow,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.star_rounded,
                        label: 'Max Coef.',
                        value: maxCoeff.toStringAsFixed(1),
                        color: const Color(0xFFC5A059),
                        surfaceColor: surfaceColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        cardShadow: cardShadow,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.menu_book_rounded,
                        label: 'Matières',
                        value: '$matiereCount',
                        color: Colors.green,
                        surfaceColor: surfaceColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        cardShadow: cardShadow,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ═══════════════════════════════════════════════════
              // LISTE DES MATIÈRES — VISUEL UNIQUEMENT
              // ═══════════════════════════════════════════════════
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: sortedSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = sortedSubjects[index];
                    return _buildMatiereCard(
                      subject: subject,
                      maxCoeff: maxCoeff,
                      surfaceColor: surfaceColor,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                      cardShadow: cardShadow,
                      isDark: isDark,
                      onTap: () {
                        // Tap → GradeEntryScreen (pas de saisie ici)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GradeEntryScreen(termId: term.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // CARTE RÉCAPITULATIVE (3 en haut)
  // ═══════════════════════════════════════════════════════════
  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color cardShadow,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: cardShadow, blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // CARTE MATIÈRE — Identique à la maquette, VISUEL UNIQUEMENT
  // ═══════════════════════════════════════════════════════════
  Widget _buildMatiereCard({
    required Subject subject,
    required double maxCoeff,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textMuted,
    required Color cardShadow,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final coeff = subject.coefficient.toDouble();
    final progress = coeff / maxCoeff;
    final avg = subject.average;
    final hasGrades = avg > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: cardShadow, blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icône
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C3F7A).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _iconFromName(subject.iconName),
                    color: const Color(0xFF1C3F7A),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Nom FR + AR
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.nameFr,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      if (subject.nameAr.isNotEmpty)
                        Text(
                          subject.nameAr,
                          style: TextStyle(fontSize: 13, color: textMuted),
                          textDirection: TextDirection.rtl,
                        ),
                    ],
                  ),
                ),
                // Badge coefficient
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1C3F7A).withOpacity(0.15)),
                  ),
                  child: Text(
                    coeff.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1C3F7A)),
                  ),
                ),
              ],
            ),
            // Barre de progression du coefficient
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation(
                  coeff >= 4
                      ? const Color(0xFFC5A059)
                      : coeff >= 3
                          ? const Color(0xFF1C3F7A)
                          : coeff >= 2
                              ? Colors.blue.shade400
                              : Colors.grey.shade400,
                ),
              ),
            ),
            // Moyenne de la matière (si remplie dans GradeEntry)
            if (hasGrades)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(Icons.grade_rounded, size: 16, color: avg >= 12 ? Colors.green : Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      'Moyenne: ${avg.toStringAsFixed(2)}/20',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: avg >= 12 ? Colors.green : Colors.orange,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Appuyez pour modifier les notes',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFromName(String name) {
    return switch (name) {
      'menu_book' => Icons.menu_book,
      'translate' => Icons.translate,
      'language' => Icons.language,
      'calculate' => Icons.calculate,
      'science' => Icons.science,
      'eco' => Icons.eco,
      'history' => Icons.history,
      'public' => Icons.public,
      'settings' => Icons.settings,
      'mosque' => Icons.mosque,
      'account_balance' => Icons.account_balance,
      'computer' => Icons.computer,
      'sports' => Icons.sports,
      'psychology' => Icons.psychology,
      'trending_up' => Icons.trending_up,
      'business' => Icons.business,
      'code' => Icons.code,
      'router' => Icons.router,
      'devices' => Icons.devices,
      'school' => Icons.school,
      'fitness_center' => Icons.fitness_center,
      'biotech' => Icons.biotech,
      _ => Icons.school,
    };
  }
}