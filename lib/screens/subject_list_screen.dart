import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';
import 'grade_entry_screen.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDarkMode;
    final term = provider.currentTerm;

    // CORRECTION ✅ : cast explicite avec type générique
    final List<Subject> subjects = term?.subjects.cast<Subject>() ?? [];

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB);
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);
    final cardShadow = isDark
        ? Colors.black.withOpacity(0.3)
        : Colors.black.withOpacity(0.04);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          "Matières",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: textMuted),
                  const SizedBox(height: 16),
                  Text(
                    "Aucune matière",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sélectionne d'abord ton niveau",
                    style: TextStyle(color: textMuted),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return _buildSubjectCard(subject, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow);
              },
            ),
    );
  }

  Widget _buildSubjectCard(Subject subject, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final avg = subject.average;
    final hasGrades = avg > 0;
    final progress = hasGrades ? (avg / 20) : 0.0;
    final color = hasGrades
        ? (avg >= 16 ? Colors.green : avg >= 12 ? Colors.orange : Colors.red)
        : textMuted;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GradeEntryScreen(
              termId: context.read<AppProvider>().currentTerm?.id ?? '',
            ),
          ),
        );
      },
      child: Container(
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
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
                  const SizedBox(height: 6),
                  if (hasGrades)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    )
                  else
                    Text(
                      "Aucune note",
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hasGrades ? avg.toStringAsFixed(2) : '--',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                  ),
                ),
                Text(
                  "Coef. ${subject.coefficient}",
                  style: TextStyle(
                    fontSize: 12,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
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
}