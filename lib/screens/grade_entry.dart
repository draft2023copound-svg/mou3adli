import 'package:flutter/material.dart';
import 'package:mou3adli/models/mock_data.dart';
import 'package:mou3adli/widgets/custom_widgets.dart';

class GradeEntryScreen extends StatelessWidget {
  final Subject subject;
  const GradeEntryScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subject.nameFr), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: subject.evaluations.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.assignment, color: kRoyalBlue, size: 28),
                      const SizedBox(width: 16),
                      Expanded(child: Text(subject.evaluations[index], style: const TextStyle(fontWeight: FontWeight.w500))),
                      SizedBox(
                        width: 80,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "16",
                            suffixText: "/20",
                            filled: true,
                            fillColor: const Color(0xFFF8F9FA),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Color(0xFFEEF2F6), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Moyenne de la matière", style: TextStyle(color: Colors.grey)),
                    Text("14.63 /20", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kRoyalBlue)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Coefficient", style: TextStyle(color: Colors.grey)),
                    Text(subject.coeff.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kRoyalBlue)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(text: "Enregistrer", onPressed: () {}),
          ),
        ],
      ),
    );
  }
}