import 'package:flutter/material.dart';
import 'package:mou3adli/widgets/custom_widgets.dart';
import 'package:mou3adli/screens/home_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  // Variables d'état pour stocker les choix de l'utilisateur
  String _selectedCycle = "Collège"; // "Collège" ou "Lycée"
  int _selectedClassIndex = 2; // 0=7ème, 1=8ème, 2=9ème (par défaut)
  String _selectedType = "Classique"; // "Classique" ou "Pilote"

  // Liste des classes
  final List<String> _collegeClasses = ["7ème Année", "8ème Année", "9ème Année"];
  final List<String> _lyceeClasses = ["1ère Année", "2ème Année", "3ème Année", "4ème Année"];

  @override
  Widget build(BuildContext context) {
    // On choisit la liste des classes selon le cycle sélectionné
    final currentClasses = _selectedCycle == "Collège" ? _collegeClasses : _lyceeClasses;

    return Scaffold(
      appBar: AppBar(title: const Text("Choisir mon niveau")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cycle", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            // BOUTONS CYCLE (Collège / Lycée)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedCycle = "Collège";
                      _selectedClassIndex = 0; // On réinitialise à la première classe
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedCycle == "Collège" ? kRoyalBlue : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: kRoyalBlue),
                      ),
                      child: Center(
                        child: Text(
                          "Collège",
                          style: TextStyle(
                            color: _selectedCycle == "Collège" ? Colors.white : kRoyalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedCycle = "Lycée";
                      _selectedClassIndex = 0;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _selectedCycle == "Lycée" ? kRoyalBlue : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: kRoyalBlue),
                      ),
                      child: Center(
                        child: Text(
                          "Lycée",
                          style: TextStyle(
                            color: _selectedCycle == "Lycée" ? Colors.white : kRoyalBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            const Text("Classe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            // LISTE DES CLASSES
            Expanded(
              child: ListView.builder(
                itemCount: currentClasses.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedClassIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedClassIndex = index;
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? kRoyalBlue : Colors.transparent, width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Color(0xFFEEF2F6), shape: BoxShape.circle),
                            child: const Icon(Icons.school, color: kRoyalBlue, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentClasses[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                Text(_selectedCycle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: kRoyalBlue, size: 28),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // TYPE D'ÉTABLISSEMENT (Visible seulement pour le Collège)
            if (_selectedCycle == "Collège") ...[
              const Text("Type d'établissement", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = "Classique"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedType == "Classique" ? kRoyalBlue : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: kRoyalBlue),
                        ),
                        child: Center(
                          child: Text(
                            "Classique",
                            style: TextStyle(
                              color: _selectedType == "Classique" ? Colors.white : kRoyalBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = "Pilote"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedType == "Pilote" ? kRoyalBlue : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: kRoyalBlue),
                        ),
                        child: Center(
                          child: Text(
                            "Pilote",
                            style: TextStyle(
                              color: _selectedType == "Pilote" ? Colors.white : kRoyalBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // BOUTON CONTINUER
            CustomButton(
              text: "Continuer",
              onPressed: () {
                // Quand on clique sur Continuer, on va au Dashboard
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const HomeScreen())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}