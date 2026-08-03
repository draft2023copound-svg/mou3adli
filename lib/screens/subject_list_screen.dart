import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';
import 'grade_entry_screen.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

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

    final term = provider.currentTerm;
    // CORRECTION : cast explicite
    final List<Subject> subjects = term?.subjects.cast<Subject>() ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          term?.nameFr ?? "Matières",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final avg = subject.average;
          final hasGrades = subject.evaluations.any((e) => e.score != null);

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GradeEntryScreen(
                        termId: term!.id,
                        subjectId: subject.id,
                      ),
                    ),
                  );
                },
                child: Ink(
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
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _getSubjectColor(subject.id).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getSubjectIcon(subject.id),
                            color: _getSubjectColor(subject.id),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject.nameFr,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Coef. ${subject.coefficient}",
                                style: TextStyle(color: textSecondary, fontSize: 13),
                              ),
                              if (hasGrades) ...[
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: avg / 20,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey.shade800,
                                    valueColor: AlwaysStoppedAnimation(
                                      avg >= 10 ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              hasGrades ? avg.toStringAsFixed(2) : '--',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: hasGrades
                                    ? (avg >= 10 ? Colors.green : Colors.red)
                                    : textMuted,
                              ),
                            ),
                            Text(
                              "/20",
                              style: TextStyle(color: textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getSubjectColor(String id) {
    final colors = {
      'math': Colors.blue,
      'physique': Colors.purple,
      'svt': Colors.green,
      'francais': Colors.orange,
      'anglais': Colors.teal,
      'arabe': Colors.indigo,
      'histoire': Colors.brown,
      'geo': Colors.cyan,
      'philosophie': Colors.deepPurple,
      'sport': Colors.red,
      'info': Colors.blueGrey,
      'tech': Colors.amber,
      'gestion': Colors.pink,
      'eco': Colors.lightGreen,
    };
    return colors[id] ?? Colors.grey;
  }

  IconData _getSubjectIcon(String id) {
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
    return icons[id] ?? Icons.school;
  }
}