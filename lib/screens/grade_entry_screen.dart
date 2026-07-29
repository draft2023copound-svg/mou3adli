import 'package:flutter/material.dart';

class GradeEntryScreen extends StatefulWidget {
  final String subjectName;
  const GradeEntryScreen({super.key, required this.subjectName});

  @override
  State<GradeEntryScreen> createState() => _GradeEntryScreenState();
}

class _GradeEntryScreenState extends State<GradeEntryScreen> {
  final TextEditingController _ctrl1 = TextEditingController(text: "16");
  final TextEditingController _ctrl2 = TextEditingController(text: "14");
  final TextEditingController _oral = TextEditingController(text: "17");
  final TextEditingController _synth = TextEditingController(text: "13");
  final TextEditingController _tp = TextEditingController(text: "15");

  double _average = 14.63;

  void _calculateAverage() {
    double n1 = double.tryParse(_ctrl1.text) ?? 0;
    double n2 = double.tryParse(_ctrl2.text) ?? 0;
    double n3 = double.tryParse(_oral.text) ?? 0;
    double n4 = double.tryParse(_synth.text) ?? 0;
    double n5 = double.tryParse(_tp.text) ?? 0;
    
    setState(() {
      _average = (n1 + n2 + n3 + n4 + n5) / 5;
    });
  }

  @override
  void initState() {
    super.initState();
    _ctrl1.addListener(_calculateAverage);
    _ctrl2.addListener(_calculateAverage);
    _oral.addListener(_calculateAverage);
    _synth.addListener(_calculateAverage);
    _tp.addListener(_calculateAverage);
  }

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _oral.dispose();
    _synth.dispose();
    _tp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.subjectName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _buildInputCard("فرض المراقبة عدد 1", "Contrôle continu n°1", _ctrl1, Icons.assignment_rounded),
          _buildInputCard("فرض المراقبة عدد 2", "Contrôle continu n°2", _ctrl2, Icons.edit_note_rounded),
          _buildInputCard("شفهي", "Oral", _oral, Icons.mic_rounded),
          _buildInputCard("فرض التأليفي", "Devoir de synthèse", _synth, Icons.description_rounded),
          _buildInputCard("TP / الإنتاج الكتابي", "Travaux pratiques", _tp, Icons.people_rounded),

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
                      const Text("Moyenne de la matière", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _average.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1C3F7A)),
                          ),
                          const Text(" /20", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: Colors.grey.shade300),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Coefficient", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text("4", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1C3F7A))),
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
              onPressed: () {
                // Action d'enregistrement future
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3F7A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
              ),
              child: const Text("Enregistrer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(String arTitle, String frSubtitle, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C3F7A).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF1C3F7A), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(arTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text(frSubtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
                hintText: "0",
                suffixText: "/20",
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
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}