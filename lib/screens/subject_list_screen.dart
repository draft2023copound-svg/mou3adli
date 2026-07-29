import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_widgets.dart';
import 'grade_entry_screen.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  String _getMention(double avg) {
    if (avg >= 16) return 'Excellent';
    if (avg >= 14) return 'Très bien';
    if (avg >= 12) return 'Bien';
    if (avg >= 10) return 'Passable';
    return 'Insuffisant';
  }

  Color _getMentionColor(double avg) {
    if (avg >= 16) return const Color(0xff2E7D32);
    if (avg >= 14) return const Color(0xff1565C0);
    if (avg >= 12) return const Color(0xffF57C00);
    if (avg >= 10) return const Color(0xff795548);
    return const Color(0xffC62828);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mes Matières',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final term = provider.currentTerm;
          if (term == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final subjects = term.subjects;
          final avg = term.generalAverage;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kRoyalBlue, Color(0xff2E5C9E)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: kRoyalBlue.withOpacity(.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      term.nameFr,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      avg > 0 ? avg.toStringAsFixed(2) : '--',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      '/20',
                      style: TextStyle(color: Colors.white60, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    if (avg > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getMention(avg),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ...subjects.map((subject) {
                final subjectAvg = subject.average;
                final progress = subject.evaluations.isEmpty
                    ? 0.0
                    : subject.filledCount / subject.evaluations.length;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GradeEntryScreen(
                            termId: term.id,
                            subject: subject,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: kRoyalBlue.withOpacity(.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                _iconFromName(subject.iconName),
                                color: kRoyalBlue,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject.nameFr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${subject.filledCount}/${subject.evaluations.length} évaluations • Coeff ${subject.coefficient}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: Colors.grey.shade100,
                                      valueColor: AlwaysStoppedAnimation(
                                        progress == 1.0 ? Colors.green : kRoyalBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: subjectAvg > 0
                                    ? _getMentionColor(subjectAvg).withOpacity(.08)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                subjectAvg > 0 ? subjectAvg.toStringAsFixed(2) : '--',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: subjectAvg > 0
                                      ? _getMentionColor(subjectAvg)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 30),
            ],
          );
        },
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
      _ => Icons.menu_book,
    };
  }
}