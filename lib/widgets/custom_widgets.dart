import 'package:flutter/material.dart';
import 'package:mou3adli/models/mock_data.dart'; // Import ajouté pour corriger l'erreur

const Color kRoyalBlue = Color(0xFF1C3F7A);
const Color kMatteGold = Color(0xFFC5A059);

// Bouton principal (Plein ou Outline)
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFilled;
  const CustomButton({super.key, required this.text, this.onPressed, this.isFilled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? kRoyalBlue : Colors.white,
          foregroundColor: isFilled ? Colors.white : kRoyalBlue,
          elevation: isFilled ? 4 : 0,
          side: isFilled ? null : const BorderSide(color: kRoyalBlue, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// Carte d'une matière pour l'écran "Matières & Coefficients"
class SubjectCard extends StatelessWidget {
  final Subject subject;
  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: kRoyalBlue.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.book, color: kRoyalBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.nameFr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subject.nameAr, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kRoyalBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kRoyalBlue.withOpacity(0.2)),
            ),
            child: Text(
              subject.coeff.toString(),
              style: const TextStyle(color: kRoyalBlue, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}