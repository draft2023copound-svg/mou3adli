import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';
import '../widgets/custom_widgets.dart'; // ← AJOUTÉ pour kRoyalBlue

class GradeEntryScreen extends StatefulWidget {
  final String termId;
  final Subject subject;

  const GradeEntryScreen({
    super.key,
    required this.termId,
    required this.subject,
  });

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  late List<TextEditingController> _controllers;
  double _average = 0;

  @override
  void initState() {
    super.initState();
    _controllers = widget.subject.evaluations.map((e) {
      return TextEditingController(text: e.score?.toString() ?? '');
    }).toList();
    _calculateAverage();
    for (final c in _controllers) {
      c.addListener(_calculateAverage);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _calculateAverage() {
    double totalWeighted = 0;
    double totalWeight = 0;
    for (int i = 0; i < _controllers.length; i++) {
      final val = double.tryParse(_controllers[i].text);
      if (val != null) {
        totalWeighted += val * widget.subject.evaluations[i].weight;
        totalWeight += widget.subject.evaluations[i].weight;
      }
    }
    setState(() {
      _average = totalWeight > 0 ? totalWeighted / totalWeight : 0;
    });
  }

  Future<void> _saveGrades() async {
    final provider = context.read<AppProvider>();
    for (int i = 0; i < _controllers.length; i++) {
      final val = double.tryParse(_controllers[i].text);
      await provider.updateGrade(
        widget.termId,
        widget.subject.id,
        widget.subject.evaluations[i].id,
        val,
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Notes enregistrées avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final evals = widget.subject.evaluations;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            Text(
              widget.subject.nameFr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Text(
              widget.subject.nameAr,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: kRoyalBlue.withOpacity(.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kRoyalBlue.withOpacity(.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: kRoyalBlue.withOpacity(.7)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Coefficient: ${widget.subject.coefficient} • La moyenne est pondérée selon les poids des évaluations tunisiennes.',
                    style: TextStyle(
                      fontSize: 13,
                      color: kRoyalBlue.withOpacity(.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ...List.generate(evals.length, (i) {
            return _buildInputCard(
              evals[i].nameAr,
              evals[i].nameFr,
              'Poids: ${evals[i].weight}',
              _controllers[i],
              _iconForEval(evals[i].id),
            );
          }),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Moyenne de la matière',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _average > 0 ? _average.toStringAsFixed(2) : '--',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: kRoyalBlue,
                            ),
                          ),
                          const Text(' /20', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: Colors.grey.shade300),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Coefficient', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text(
                      widget.subject.coefficient.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: kRoyalBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _saveGrades,
              style: ElevatedButton.styleFrom(
                backgroundColor: kRoyalBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
              ),
              child: const Text(
                'Enregistrer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(
    String arTitle,
    String frSubtitle,
    String weightLabel,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kRoyalBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: kRoyalBlue, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(arTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                Text(frSubtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                Text(
                  weightLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: kRoyalBlue.withOpacity(.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                suffixText: '/20',
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForEval(String evalId) {
    if (evalId.contains('dc')) return Icons.assignment_rounded;
    if (evalId.contains('oral')) return Icons.mic_rounded;
    if (evalId.contains('ds')) return Icons.description_rounded;
    if (evalId.contains('tp')) return Icons.people_rounded;
    return Icons.edit_note_rounded;
  }
}