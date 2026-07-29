import 'package:flutter/material.dart';
import 'package:mou3adli/widgets/custom_widgets.dart';
import 'package:mou3adli/screens/level_selection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // On ajuste le padding pour que tout tienne sans Espace
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // LOGO MOU3ADLI
                Image.asset(
                  'assets/images/logo.png',
                  height: 160,
                  width: 160,
                ),
                
                const SizedBox(height: 20),
                
                // ILLUSTRATION 3D DU GARÇON
                Image.asset(
                  'assets/images/boy.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 30),

                // BOUTONS DE NAVIGATION
                CustomButton(
                  text: "Se connecter", 
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const LevelSelectionScreen())
                    );
                  }
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: "Créer un compte", 
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const LevelSelectionScreen())
                    );
                  },
                  isFilled: false
                ),
                
                const SizedBox(height: 20),
                const Text(
                  "Apprendre • Évaluer • Progresser",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}