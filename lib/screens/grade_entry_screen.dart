import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';

class GradeEntryScreen extends StatefulWidget {
  final String termId;
  final String subjectId;
  final String subjectName;

  const GradeEntryScreen({
    super.key,
    required this.termId,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  void _loadGrades() {
    final provider = context.read<AppProvider>();
    final term = provider.terms.firstWhere((t) => t.id == widget.termId);

    // CORRECTION ✅ : cast explicite avec type générique
    final List<Subject> subjects = term.subjects.cast<Subject>();
    final subject = subjects.firstWhere((s) => s.id == widget.subjectId);

    for (final eval in subject.evaluations) {
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

  // CORRECTION ✅ : Validation des notes entre 0 et 20
  Future<void> _saveGrades() async {
    final provider = context.read<AppProvider>();
    bool hasError = false;

    for (final entry in _controllers.entries) {
      final text = entry.value.text.trim();
      final score = text.isEmpty ? null : double.tryParse(text);

      // Validation : note doit être entre 0 et 20
      if (score != null && (score < 0 || score > 20)) {
        hasError = true;
        continue; // On saute cette note invalide
      }

      await provider.updateGrade(
        widget.termId,
        widget.subjectId,
        entry.key,
        score,
      );
    }

    if (mounted) {
      if (hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Certaines notes étaient invalides (doivent être entre 0 et 20)"),
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

    final term = provider.terms.firstWhere((t) => t.id == widget.termId);
    // CORRECTION ✅ : cast explicite avec type générique
    final List<Subject> subjects = term.subjects.cast<Subject>();
    final subject = subjects.firstWhere((s) => s.id == widget.subjectId);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          widget.subjectName,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...subject.evaluations.map((eval) => _buildGradeField(eval, isDark, surfaceColor, textPrimary, textSecondary, textMuted)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveGrades,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C3F7A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Sauvegarder",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGradeField(dynamic eval, bool isDark, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted) {
    final controller = _controllers[eval.id];
    if (controller == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
                      eval.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      "Coefficient: ${eval.coefficient}",
                      style: TextStyle(
                        fontSize: 13,
                        color: textMuted,
                      ),
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
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textPrimary,
            ),
            decoration: InputDecoration(
              hintText: "Note sur 20",
              hintStyle: TextStyle(color: textMuted),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}