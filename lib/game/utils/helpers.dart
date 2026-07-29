// AJOUT DE L'IMPORT MANQUANT ICI
import 'dart:async'; 

import 'dart:math';
import 'package:flutter/material.dart';

final Random random = Random();

Color randomBrightColor() {
  return HSLColor.fromAHSL(1.0, random.nextDouble() * 360, 0.7 + random.nextDouble() * 0.3, 0.5 + random.nextDouble() * 0.2).toColor();
}

double calculateCellSize({required double availableWidth, required double availableHeight, required int rows, required int cols, required double spacing, double minSize = 32.0, double maxSize = 64.0}) {
  final double w = (availableWidth - (cols - 1) * spacing) / cols;
  final double h = (availableHeight - (rows - 1) * spacing) / rows;
  final double size = w < h ? w : h;
  return size.clamp(minSize, maxSize);
}

Color lerpColor(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;

LinearGradient gameBackgroundGradient() {
  return const LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
  );
}

Color contrastColor(Color background) {
  final double luminance = background.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}

String generateUniqueId() => '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(99999)}';

class Debouncer {
  final Duration delay;
  Timer? _timer;
  Debouncer({required this.delay});
  void run(VoidCallback action) { 
    _timer?.cancel(); 
    _timer = Timer(delay, action); // <-- Correction : ; ajouté
  }
  void dispose() { _timer?.cancel(); }
}