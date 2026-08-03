import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class GradeEntryScreen extends StatefulWidget {
  final String termId;
  final String subjectId;

  const GradeEntryScreen({
    super.key,
    required this.termId,
    required this.subjectId,
  });

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  void _loadGrades() {
    final provider = context.read<AppProvider>();
    final term = provider.terms.firstWhere((t) => t.id == widget.termId);
    final subject = term.subjects.firstWhere((s) => s.id == widget.subjectId);

    for (final eval in subject.evaluations) {
      _controllers[eval.id] = TextEditingController(
        text: eval.score?.toString() ?? '',
      );
    }
  }

  Future<void> _saveGrades() async {
    final provider = context.read<AppProvider>();

    for (final entry in _controllers.entries) {
      final text = entry.value.text.trim();
      final score = text.isEmpty ? null : double.tryParse(text);

      await provider.updateGrade(
        widget.termId,
        widget.subjectId,
        entry.key,
        score,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Notes sauvegardées !")),
      );
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
    final cardShadow = isDark 
      ? Colors.black.withOpacity(0.3)
      : Colors.black.withOpacity(0.04);

    final term = provider.terms.firstWhere((t) => t.id == widget.termId);
    final subject = term.subjects.firstWhere((s) => s.id == widget.subjectId);
    final avg = subject.average;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          subject.nameFr,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Moyenne actuelle
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
            child: Column(
              children: [
                Text(
                  avg > 0 ? avg.toStringAsFixed(2) : '--',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: avg >= 10 ? Colors.green : textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Moyenne actuelle",
                  style: TextStyle(color: textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Liste des évaluations
          Text(
            "Saisir les notes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...subject.evaluations.map((eval) {
            final controller = _controllers[eval.id];
            if (controller == null) return const SizedBox.shrink();

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C3F7A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_note,
                          color: Color(0xFF1C3F7A),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eval.nameFr,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              "Coefficient: ${eval.weight.toStringAsFixed(1)}",
                              style: TextStyle(color: textSecondary, fontSize: 13),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: "Note /20",
                      hintStyle: TextStyle(color: textMuted),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF242424) : const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      suffixText: "/20",
                      suffixStyle: TextStyle(color: textMuted),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveGrades,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C3F7A),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              "Enregistrer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}