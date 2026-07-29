import 'package:flutter/material.dart';

class CoefficientsScreen extends StatelessWidget {
  final String title;
  const CoefficientsScreen({super.key, this.title = "Coefficients"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
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
                _buildCoeffCard("Arabe", "عربية", Icons.menu_book_rounded, 4),
                _buildCoeffCard("Français", "", Icons.translate_rounded, 4),
                _buildCoeffCard("Anglais", "", Icons.language_rounded, 1.5),
                _buildCoeffCard("Histoire", "", Icons.history_rounded, 1),
                _buildCoeffCard("Géographie", "", Icons.public_rounded, 1),
                _buildCoeffCard("Mathématiques", "", Icons.calculate_rounded, 3),
                _buildCoeffCard("Physique", "", Icons.science_rounded, 1),
                _buildCoeffCard("SVT", "", Icons.eco_rounded, 1),
                _buildCoeffCard("Technologie", "", Icons.settings_rounded, 1),
                _buildCoeffCard("Islamique", "", Icons.mosque_rounded, 1),
                
                const SizedBox(height: 20),
                
                // Carte d'information en bas
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: Color(0xFF1C3F7A), size: 28),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "La structure est la même pour tous.\nSeuls les coefficients changent selon\nle niveau et le type d'établissement.",
                          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoeffCard(String name, String subName, IconData icon, double coeff) {
    return Container(
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
              color: const Color(0xFF1C3F7A).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF1C3F7A), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                if (subName.isNotEmpty)
                  Text(
                    subName,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C3F7A).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1C3F7A).withOpacity(0.3)),
            ),
            child: Text(
              coeff.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C3F7A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}