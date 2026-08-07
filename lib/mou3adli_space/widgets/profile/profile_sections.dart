import 'package:flutter/material.dart';

class ProfileSections extends StatelessWidget {
  final VoidCallback onDocuments;
  final VoidCallback onHomework;
  final VoidCallback onQuiz;
  final VoidCallback onPosts;
  final VoidCallback onSettings;

  const ProfileSections({
    super.key,
    required this.onDocuments,
    required this.onHomework,
    required this.onQuiz,
    required this.onPosts,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: const Text("Mes documents"),
          trailing: const Icon(Icons.chevron_right),
          onTap: onDocuments,
        ),
        ListTile(
          leading: const Icon(Icons.assignment),
          title: const Text("Mes devoirs"),
          trailing: const Icon(Icons.chevron_right),
          onTap: onHomework,
        ),
        ListTile(
          leading: const Icon(Icons.quiz),
          title: const Text("Mes quiz"),
          trailing: const Icon(Icons.chevron_right),
          onTap: onQuiz,
        ),
        ListTile(
          leading: const Icon(Icons.feed),
          title: const Text("Mes publications"),
          trailing: const Icon(Icons.chevron_right),
          onTap: onPosts,
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Paramètres"),
          trailing: const Icon(Icons.chevron_right),
          onTap: onSettings,
        ),
      ],
    );
  }
}