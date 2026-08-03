import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';
import '../navigation/custom_bottom_nav.dart';
import '../calendar_new/calendar_main_screen.dart';
import '../game/screens/games_hub_screen.dart';
import 'profile_screen.dart';
import 'subject_list_screen.dart';
import 'settings_screen.dart';
import 'grade_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDarkMode;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB);
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);
    final cardShadow = isDark
        ? Colors.black.withOpacity(0.3)
        : Colors.black.withOpacity(0.04);

    final user = provider.user;
    final term = provider.currentTerm;
    final avg = provider.currentGeneralAverage;
    final annualAvg = provider.annualAverage;

    final displayName = user?.fullName ?? 'Élève';
    final photoUrl = user?.photoUrl;
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // ═══════════════════════════════════════════════════════════
              // HEADER CENTRÉ : Photo + Bonjour alignés au centre ✅
              // ═══════════════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Photo à gauche
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: Hero(
                        tag: "profile",
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1C3F7A).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF1C3F7A).withOpacity(0.1),
                            backgroundImage: hasPhoto ? FileImage(File(photoUrl)) : null,
                            child: !hasPhoto
                                ? Text(
                                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1C3F7A),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Texte centré verticalement avec la photo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Bonjour,',
                            style: TextStyle(
                              fontSize: 15,
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Moyenne circulaire
              _buildAverageCard(avg, annualAvg, surfaceColor, textPrimary, textSecondary, textMuted),
              const SizedBox(height: 24),
              // Stats rapides — TEXTES CENTRÉS
              _buildQuickStats(provider, surfaceColor, textPrimary, textSecondary, cardShadow),
              const SizedBox(height: 24),
              // Matières
              _buildSubjectsSection(term, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
              const SizedBox(height: 24),
              // Navigation rapide
              _buildQuickNav(surfaceColor, textPrimary, textSecondary, cardShadow),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          if (index == 0) {
            // Home - déjà là
          } else if (index == 1) {
            // Matières
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectListScreen()));
          } else if (index == 2) {
            // ═══════════════════════════════════════════════════
            // FAB CALCULATRICE 🧮 → GradeEntryScreen ✅
            // ═══════════════════════════════════════════════════
            _openGradeEntry(context, provider);
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarMainScreen()));
          } else if (index == 4) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FAB CALCULATRICE → Ouvre GradeEntryScreen ✅
  // ═══════════════════════════════════════════════════════════
  void _openGradeEntry(BuildContext context, AppProvider provider) {
    final term = provider.currentTerm;
    if (term == null || term.subjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Aucune matière disponible. Sélectionne d'abord ton niveau."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // CORRECTION ✅ : cast explicite
    final List<Subject> subjects = term.subjects.cast<Subject>();
    final firstSubject = subjects.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GradeEntryScreen(
          termId: term.id,
          subjectId: firstSubject.id,
          subjectName: firstSubject.nameFr,
        ),
      ),
    );
  }

  Widget _buildAverageCard(double avg, double annualAvg, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted) {
    final percentage = avg > 0 ? (avg / 20) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C3F7A).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.school, color: Color(0xFF1C3F7A), size: 26),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Moyenne Générale",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Trimestre en cours",
                      style: TextStyle(color: textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 14,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF1C3F7A)),
                ),
              ),
              Column(
                children: [
                  Text(
                    avg > 0 ? avg.toStringAsFixed(2) : '--',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    "/20",
                    style: TextStyle(
                      fontSize: 16,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (annualAvg > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1C3F7A).withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.trending_up, color: Color(0xFF1C3F7A), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Annuelle: ${annualAvg.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Color(0xFF1C3F7A),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AppProvider provider, Color surfaceColor, Color textPrimary, Color textSecondary, Color cardShadow) {
    final term = provider.currentTerm;
    final completedSubjects = term?.completedSubjects ?? 0;
    final totalSubjects = term?.totalSubjects ?? 0;
    final progressVal = term?.progress ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              "Matières",
              "$totalSubjects",
              "$completedSubjects notées",
              Icons.menu_book_rounded,
              Colors.blue,
              surfaceColor,
              textPrimary,
              textSecondary,
              cardShadow,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              "Progression",
              "${(progressVal * 100).toStringAsFixed(0)}%",
              "du trimestre",
              Icons.assignment_rounded,
              Colors.deepPurple,
              surfaceColor,
              textPrimary,
              textSecondary,
              cardShadow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, String subtitle, IconData icon, Color color, Color surfaceColor, Color textPrimary, Color textSecondary, Color cardShadow) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cardShadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsSection(dynamic term, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    if (term == null) return const SizedBox.shrink();

    final List<Subject> allSubjects = term.subjects.cast<Subject>();
    final topSubjects = allSubjects
        .where((s) => s.average > 0)
        .toList()
      ..sort((a, b) => b.average.compareTo(a.average));
    final displaySubjects = topSubjects.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Top Matières",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SubjectListScreen()),
                  );
                },
                child: const Text(
                  "Voir tout",
                  style: TextStyle(
                    color: Color(0xFF1C3F7A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (displaySubjects.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: cardShadow,
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: textMuted, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      "Aucune note saisie",
                      style: TextStyle(
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Commence à saisir tes notes pour voir tes top matières !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...displaySubjects.map((subject) => _subjectItem(subject, surfaceColor, textPrimary, textSecondary, cardShadow)),
        ],
      ),
    );
  }

  Widget _subjectItem(Subject subject, Color surfaceColor, Color textPrimary, Color textSecondary, Color cardShadow) {
    final avg = subject.average;
    final progress = avg / 20;
    final color = avg >= 16 ? Colors.green : avg >= 12 ? Colors.orange : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardShadow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getSubjectIcon(subject.id),
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.nameFr,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            avg.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subjectId) {
    final icons = {
      'math': Icons.calculate,
      'physique': Icons.science,
      'svt': Icons.eco,
      'francais': Icons.menu_book,
      'anglais': Icons.translate,
      'arabe': Icons.language,
      'histoire': Icons.history,
      'geo': Icons.public,
      'philosophie': Icons.psychology,
      'sport': Icons.sports,
      'info': Icons.computer,
      'tech': Icons.build,
      'gestion': Icons.business,
      'eco': Icons.trending_up,
    };
    return icons[subjectId] ?? Icons.school;
  }

  Widget _buildQuickNav(Color surfaceColor, Color textPrimary, Color textSecondary, Color cardShadow) {
    final items = [
      {
        'icon': Icons.calendar_month,
        'label': 'Calendrier',
        'screen': const CalendarMainScreen(),
      },
      {
        'icon': Icons.videogame_asset,
        'label': 'Jeux',
        'screen': const GamesHubScreen(),
      },
      {
        'icon': Icons.settings,
        'label': 'Paramètres',
        'screen': const SettingsScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Navigation rapide",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: items.map((item) => Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item['screen'] as Widget),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadow,
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: const Color(0xFF1C3F7A),
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}