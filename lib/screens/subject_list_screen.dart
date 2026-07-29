import 'package:flutter/material.dart';
import 'package:mou3adli/screens/grade_entry_screen.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Matières",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "9ème Année - Classique",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C3F7A)),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _buildSubjectCard(
                  context,
                  name: "Arabe",
                  icon: Icons.menu_book_rounded,
                  average: 14.63,
                  color: const Color(0xFF1C3F7A),
                ),
                _buildSubjectCard(
                  context,
                  name: "Français",
                  icon: Icons.translate_rounded,
                  average: 12.5,
                  color: const Color(0xFF4F8CFF),
                ),
                _buildSubjectCard(
                  context,
                  name: "Anglais",
                  icon: Icons.language_rounded,
                  average: 16.0,
                  color: const Color(0xFFFB8C00),
                ),
                _buildSubjectCard(
                  context,
                  name: "Mathématiques",
                  icon: Icons.calculate_rounded,
                  average: null,
                  color: const Color(0xFF43A047),
                ),
                _buildSubjectCard(
                  context,
                  name: "Physique",
                  icon: Icons.science_rounded,
                  average: 11.2,
                  color: const Color(0xFF00ACC1),
                ),
                _buildSubjectCard(
                  context,
                  name: "SVT",
                  icon: Icons.eco_rounded,
                  average: null,
                  color: const Color(0xFFAB47BC),
                ),
                _buildSubjectCard(
                  context,
                  name: "Histoire",
                  icon: Icons.history_rounded,
                  average: 15.5,
                  color: const Color(0xFFEF5350),
                ),
                _buildSubjectCard(
                  context,
                  name: "Géographie",
                  icon: Icons.public_rounded,
                  average: 13.0,
                  color: const Color(0xFF00BCD4),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context, {
    required String name,
    required IconData icon,
    required double? average,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GradeEntryScreen(subjectName: name)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Text(
                average != null ? "${average.toStringAsFixed(1)} /20" : "- /20",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}