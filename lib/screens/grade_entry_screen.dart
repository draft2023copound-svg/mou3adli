import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';
import '../models/evaluation_model.dart';

// ═══════════════════════════════════════════════════════════
// ÉCRAN PRINCIPAL : Liste de TOUTES les matières
// ═══════════════════════════════════════════════════════════
class GradeEntryScreen extends StatefulWidget {
  final String termId;

  const GradeEntryScreen({
    super.key,
    required this.termId,
  });

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDarkMode;
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
          child: Text("Aucun trimestre sélectionné", style: TextStyle(color: textSecondary)),
        ),
      );
    }

    final List<Subject> subjects = term.subjects.cast<Subject>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          "Saisie des notes",
          style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return _buildSubjectCard(
            subject: subject,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            textMuted: textMuted,
            cardShadow: cardShadow,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubjectGradeDetailScreen(
                    termId: term.id,
                    subject: subject,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSubjectCard({
    required Subject subject,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color cardShadow,
    required VoidCallback onTap,
  }) {
    final avg = subject.average;
    final hasGrades = avg > 0;
    final filled = subject.filledCount;
    final total = subject.evaluations.length;
    final progress = total > 0 ? filled / total : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: cardShadow, blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C3F7A).withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _iconFromName(subject.iconName),
                color: const Color(0xFF1C3F7A),
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
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        progress == 1.0 ? Colors.green : const Color(0xFF1C3F7A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$filled / $total évaluations remplies",
                    style: TextStyle(fontSize: 12, color: textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hasGrades ? avg.toStringAsFixed(2) : '--',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimary),
                ),
                Text(
                  "/20",
                  style: TextStyle(fontSize: 12, color: textMuted),
                ),
              ],
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

// ═══════════════════════════════════════════════════════════
// ÉCRAN DÉTAIL : Évaluations d'une matière spécifique
// ═══════════════════════════════════════════════════════════
class SubjectGradeDetailScreen extends StatefulWidget {
  final String termId;
  final Subject subject;

  const SubjectGradeDetailScreen({
    super.key,
    required this.termId,
    required this.subject,
  });

  @override
  State<SubjectGradeDetailScreen> createState() => _SubjectGradeDetailScreenState();
}

class _SubjectGradeDetailScreenState extends State<SubjectGradeDetailScreen> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  void _loadGrades() {
    for (final eval in widget.subject.evaluations) {
      _controllers[eval.id] = TextEditingController(
        text: eval.score != null ? eval.score.toString() : '',
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveGrades() async {
    final provider = context.read<AppProvider>();
    bool hasError = false;

    for (final entry in _controllers.entries) {
      final text = entry.value.text.trim();
      final score = text.isEmpty ? null : double.tryParse(text);

      if (score != null && (score < 0 || score > 20)) {
        hasError = true;
        continue;
      }

      await provider.updateGrade(
        widget.termId,
        widget.subject.id,
        entry.key,
        score,
      );
    }

    if (mounted) {
      if (hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Certaines notes invalides (doivent être entre 0 et 20)"),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Notes sauvegardées !")),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isDark = provider.isDarkMode;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB);
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          widget.subject.nameFr,
          style: TextStyle(fontWeight: FontWeight.w800, color: textPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Moyenne actuelle
                  if (widget.subject.average > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
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
                              color: const Color(0xFF1C3F7A).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.school, color: Color(0xFF1C3F7A), size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Moyenne actuelle",
                                  style: TextStyle(fontSize: 14, color: textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${widget.subject.average.toStringAsFixed(2)} / 20",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Liste des évaluations
                  ...widget.subject.evaluations.map((eval) => _buildEvalField(
                    eval: eval,
                    surfaceColor: surfaceColor,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    isDark: isDark,
                  )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveGrades,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C3F7A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Sauvegarder",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEvalField({
    required Evaluation eval,
    required Color surfaceColor,
    required Color textPrimary,
    required Color textMuted,
    required bool isDark,
  }) {
    final controller = _controllers[eval.id];
    if (controller == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C3F7A).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_note, color: Color(0xFF1C3F7A), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eval.nameFr,
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary),
                    ),
                    Text(
                      "Coefficient: ${eval.weight.toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 13, color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimary),
            decoration: InputDecoration(
              hintText: "Note sur 20",
              hintStyle: TextStyle(color: textMuted),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}