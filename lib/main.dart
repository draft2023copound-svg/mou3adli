import 'package:flutter/material.dart';
import 'package:mou3adli/widgets/custom_widgets.dart';
import 'package:mou3adli/screens/login_screen.dart';
import 'package:mou3adli/game/screens/blast_screen.dart';

void main() {
  runApp(const Mou3adliApp());
}

class Mou3adliApp extends StatelessWidget {
  const Mou3adliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mou3adli',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kRoyalBlue,
          primary: kRoyalBlue,
          secondary: kMatteGold,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      // --- SUPPRESSION DE LA LIGNE 'home: const LoginScreen()' ---
      routes: {
        // Route par défaut
        '/': (context) => const LoginScreen(),
        // Route pour le jeu Blast Puzzle
        '/game': (context) => const BlastScreen(),
      },
    );
  }
}