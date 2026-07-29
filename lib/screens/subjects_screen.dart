import 'package:flutter/material.dart';
import 'package:mou3adli/screens/coefficients_screen.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // On réutilise le même design, mais avec le titre "Matières"
    return const CoefficientsScreen(title: "Matières");
  }
}