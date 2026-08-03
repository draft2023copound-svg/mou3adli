import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';
import 'term_selection_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

const Color kPrimary = Color(0xFF1C3F7A);
const Color kSecondary = Color(0xFF2A5FA8);
const Color kMatteGold = Color(0xFFC5A059);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;
    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xffF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);
    final cardShadow = isDark 
      ? Colors.black.withOpacity(0.3)
      : Colors.black.withOpacity(0.04);

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        final term = provider.currentTerm;
        final avg = provider.currentGeneralAverage;
        final annualAvg = provider.annualAverage;

        final displayName = user?.fullName ?? 'Élève';
        final displayClass = user?.displayClass ?? '';
        final displayStream = user?.displayStream ?? '';
        final displayOption = user?.displayOption;
        final classLevel = user?.classLevel ?? '';

        final hasStream = classLevel == '2eme' ||
            classLevel == '3eme' ||
            classLevel == '4eme';
        final classLabel = (hasStream && displayStream.isNotEmpty)
            ? '$displayClass \u2022 $displayStream${displayOption != null ? ' \u2022 $displayOption' : ''}'
            : displayClass;
        final schoolName = user?.schoolName ?? '';

        return Scaffold(
          backgroundColor: bgColor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                  ? [const Color(0xFF0F0F0F), const Color(0xFF1A1A1A), const Color(0xFF242424)]
                  : [const Color(0xffFDFEFF), const Color(0xffF7F9FD), const Color(0xffF2F6FC)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context, displayName, classLabel, schoolName, user?.photoUrl, isDark),
                    const SizedBox(height: 30),
                    _buildPerformanceCard(context, avg, annualAvg, term, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Vue d'ensemble",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildStatisticsGrid(context, provider, surfaceColor, textPrimary, textSecondary, cardShadow),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        children: [
                          Text(
                            "Activité récente",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Voir tout",
                            style: TextStyle(
                              color: kPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildActivityTimeline(context, provider, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Objectifs & Progression",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildGoalsCard(context, avg, annualAvg, term, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                    const SizedBox(height: 30),
                    _buildLogoutButton(context, provider),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── HEADER ───
  Widget _buildHeader(BuildContext context, String displayName, String classLabel, String schoolName, String? photoUrl, bool isDark) {
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [const Color(0xFF1C3F7A), const Color(0xFF0D2247)]
            : [const Color(0xFF1C3F7A), const Color(0xFF2A5FA8)],
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(.35),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            left: -70,
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.settings_outlined, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Hero(
                  tag: "profile",
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: hasPhoto
                          ? FileImage(File(photoUrl))
                          : null,
                      child: !hasPhoto
                          ? Text(
                              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: kPrimary,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  classLabel.isNotEmpty ? classLabel : (schoolName.isNotEmpty ? schoolName : 'Élève'),
                  style: TextStyle(
                    color: Colors.white.withOpacity(.90),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.18),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _getMentionLabelFromAvg(0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: kPrimary,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          "Modifier",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("📤 Partager le profil")),
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.share, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMentionLabelFromAvg(double avg) {
    if (avg >= 16) return "Excellent élève";
    if (avg >= 14) return "Très bon élève";
    if (avg >= 12) return "Bon élève";
    if (avg >= 10) return "Élève passable";
    return "Nouvel élève";
  }

  // ─── CARTE PERFORMANCE ───
  Widget _buildPerformanceCard(BuildContext context, double avg, double annualAvg, dynamic term, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    const target = 18.0;
    final progress = avg > 0 ? (avg / target).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).round();
    final subjectCount = term?.subjects?.length ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: cardShadow,
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.auto_graph, color: kPrimary, size: 26),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Performance scolaire",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Évolution du trimestre",
                      style: TextStyle(color: textSecondary),
                    ),
                  ],
                ),
              ),
              if (avg > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.green, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        "+${(annualAvg - avg).abs().toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [kPrimary, kSecondary],
                    ).createShader(bounds);
                  },
                  child: Text(
                    avg > 0 ? avg.toStringAsFixed(2) : '--',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Moyenne Générale",
                  style: TextStyle(color: textMuted, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade800,
              valueColor: const AlwaysStoppedAnimation(kPrimary),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Objectif : ${target.toStringAsFixed(2)}",
                style: TextStyle(color: textSecondary),
              ),
              const Spacer(),
              Text(
                "$percentage %",
                style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: _smallInfo("Trimestres", "3", Icons.calendar_month, Colors.orange, textPrimary)),
              const SizedBox(width: 15),
              Expanded(child: _smallInfo("Annuelle", annualAvg > 0 ? annualAvg.toStringAsFixed(2) : '--', Icons.school, Colors.deepPurple, textPrimary)),
              const SizedBox(width: 15),
              Expanded(child: _smallInfo("Matières", "$subjectCount", Icons.menu_book, Colors.green, textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInfo(String title, String value, IconData icon, Color color, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimary),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ─── GRILLE STATISTIQUES ───
  Widget _buildStatisticsGrid(BuildContext context, AppProvider provider, Color surfaceColor, Color textPrimary, Color textSecondary, Color cardShadow) {
    final term = provider.currentTerm;
    final completedSubjects = term?.completedSubjects ?? 0;
    final totalSubjects = term?.totalSubjects ?? 0;
    final progressVal = term?.progress ?? 0;
    final progress = (progressVal * 100).toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.92,
        children: [
          _statItem(
            context: context,
            title: "Matières",
            value: "$totalSubjects",
            subtitle: "$completedSubjects notées",
            icon: Icons.menu_book_rounded,
            color: Colors.blue,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            cardShadow: cardShadow,
            targetScreen: const HomeScreen(),
          ),
          _statItem(
            context: context,
            title: "Progression",
            value: "$progress%",
            subtitle: "du trimestre",
            icon: Icons.assignment_rounded,
            color: Colors.deepPurple,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            cardShadow: cardShadow,
            targetScreen: const TermSelectionScreen(),
          ),
          _statItem(
            context: context,
            title: "Moyenne",
            value: provider.currentGeneralAverage > 0
                ? provider.currentGeneralAverage.toStringAsFixed(2)
                : '--',
            subtitle: "/20",
            icon: Icons.event_note_rounded,
            color: Colors.orange,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            cardShadow: cardShadow,
            targetScreen: const TermSelectionScreen(),
          ),
          _statItem(
            context: context,
            title: "Annuelle",
            value: provider.annualAverage > 0
                ? provider.annualAverage.toStringAsFixed(2)
                : '--',
            subtitle: "/20",
            icon: Icons.verified_rounded,
            color: Colors.green,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            cardShadow: cardShadow,
          ),
          _statItem(
            context: context,
            title: "Mentions",
            value: _getMentionShort(provider.currentGeneralAverage),
            subtitle: _getMentionLabelFromAvg(provider.currentGeneralAverage),
            icon: Icons.local_fire_department_rounded,
            color: Colors.redAccent,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            cardShadow: cardShadow,
          ),
          _statItem(
            context: context,
            title: "Objectifs",
            value: provider.currentGeneralAverage >= 16 ? "✓" : (16 - provider.currentGeneralAverage).toStringAsFixed(1),
            subtitle: provider.currentGeneralAverage >= 16 ? "Atteint" : "pts restants",
            icon: Icons.flag_rounded,
            color: Colors.teal,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            cardShadow: cardShadow,
          ),
        ],
      ),
    );
  }

  String _getMentionShort(double avg) {
    if (avg >= 16) return "Exc";
    if (avg >= 14) return "TB";
    if (avg >= 12) return "B";
    if (avg >= 10) return "P";
    return "Ins";
  }

  Widget _statItem({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color cardShadow,
    Widget? targetScreen,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          if (targetScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("📊 Statistiques : $title ($value)")),
            );
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: cardShadow,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── TIMELINE ACTIVITÉ ───
  Widget _buildActivityTimeline(BuildContext context, AppProvider provider, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final term = provider.currentTerm;

    final List<Map<String, dynamic>> activities = [];

    if (term != null) {
      for (final subject in term.subjects) {
        for (final eval in subject.evaluations) {
          if (eval.score != null) {
            activities.add({
              'color': Colors.green,
              'icon': Icons.grade_rounded,
              'title': "Nouvelle note en ${subject.nameFr}",
              'subtitle': "${eval.score!.toStringAsFixed(1)} /20 (${eval.nameFr})",
              'time': "Récemment",
            });
          }
        }
      }
    }

    if (activities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
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
          child: Column(
            children: [
              Icon(Icons.info_outline, color: textMuted, size: 40),
              const SizedBox(height: 12),
              Text(
                "Aucune activité récente",
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Commence à saisir tes notes pour voir ton activité ici !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final recentActivities = activities.reversed.take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: recentActivities.map((activity) {
          return _activityCard(
            context: context,
            color: activity['color'] as Color,
            icon: activity['icon'] as IconData,
            title: activity['title'] as String,
            subtitle: activity['subtitle'] as String,
            time: activity['time'] as String,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            textMuted: textMuted,
            cardShadow: cardShadow,
          );
        }).toList(),
      ),
    );
  }

  Widget _activityCard({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color cardShadow,
    Widget? targetScreen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              Container(
                width: 2,
                height: 65,
                color: Colors.grey.shade800,
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: InkWell(
              onTap: () {
                if (targetScreen != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetScreen),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("📌 $title")),
                  );
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(color: textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 16, color: textMuted),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: TextStyle(color: textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── OBJECTIFS ET PROGRESSION ───
  Widget _buildGoalsCard(BuildContext context, double avg, double annualAvg, dynamic term, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    const target = 18.0;
    final progress = avg > 0 ? (avg / target).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).round();
    final remaining = target - avg;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: cardShadow,
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.flag_rounded, color: Colors.orange),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Objectif annuel",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "$percentage %",
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            avg > 0 ? "${avg.toStringAsFixed(2)} /20" : "-- /20",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            avg > 0
                ? remaining > 0
                    ? "Encore ${remaining.toStringAsFixed(2)} point pour atteindre ton objectif."
                    : "🎉 Objectif atteint ! Félicitations !"
                : "Commence à saisir tes notes pour suivre ta progression.",
            style: TextStyle(color: textSecondary),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              valueColor: const AlwaysStoppedAnimation(kPrimary),
              backgroundColor: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(child: _goalInfo("Trimestre", term?.nameFr ?? "--", Icons.calendar_month, Colors.amber, textPrimary)),
              const SizedBox(width: 15),
              Expanded(child: _goalInfo("Annuelle", annualAvg > 0 ? annualAvg.toStringAsFixed(2) : '--', Icons.bolt_rounded, Colors.deepPurple, textPrimary)),
            ],
          ),
          const SizedBox(height: 18),
          _streakCard(avg, textPrimary, textSecondary),
          const SizedBox(height: 22),
          Text(
            "Badges obtenus",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary),
          ),
          const SizedBox(height: 16),
          _buildBadges(context, avg),
        ],
      ),
    );
  }

  Widget _goalInfo(String title, String value, IconData icon, Color color, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _streakCard(double avg, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 36),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Série actuelle",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  avg > 0
                      ? "Tu progresses bien, continue comme ça !"
                      : "Commence à travailler pour démarrer ta série !",
                  style: TextStyle(color: textSecondary),
                ),
              ],
            ),
          ),
          Text(
            avg > 0 ? "🔥 ${avg.toStringAsFixed(0)}" : "🔥 0",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges(BuildContext context, double avg) {
    final List<Map<String, dynamic>> badges = [];

    if (avg >= 10) badges.add({'icon': Icons.school, 'label': "En route", 'color': Colors.blue});
    if (avg >= 12) badges.add({'icon': Icons.menu_book, 'label': "Travailleur", 'color': Colors.blue});
    if (avg >= 14) badges.add({'icon': Icons.workspace_premium, 'label': "Excellent élève", 'color': Colors.orange});
    if (avg >= 16) badges.add({'icon': Icons.emoji_events, 'label': "Brillant", 'color': Colors.amber});
    if (avg >= 18) badges.add({'icon': Icons.star, 'label': "Exceptionnel", 'color': Colors.purple});

    if (badges.isEmpty) {
      return Text(
        "Saisis tes premières notes pour débloquer des badges !",
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: badges.map((badge) => _BadgeChip(
        icon: badge['icon'] as IconData,
        label: badge['label'] as String,
        color: badge['color'] as Color,
      )).toList(),
    );
  }

  // ─── BOUTON DÉCONNEXION ───
  Widget _buildLogoutButton(BuildContext context, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Row(
                children: [
                  Icon(Icons.logout_rounded, color: kPrimary),
                  SizedBox(width: 10),
                  Text("Déconnexion", style: TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
              content: const Text("Voulez-vous vraiment vous déconnecter ?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    provider.logout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("👋 Déconnecté !")),
                    );
                  },
                  child: const Text("Se déconnecter"),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPrimary,
                Color(0xFF2A4F8F),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: kPrimary.withOpacity(.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: kMatteGold.withOpacity(.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kMatteGold.withOpacity(.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: kMatteGold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Se déconnecter",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Quitter votre compte",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kMatteGold.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kMatteGold,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _BadgeChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
