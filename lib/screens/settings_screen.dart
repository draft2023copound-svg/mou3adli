import 'package:flutter/material.dart';

const Color kPrimary = Color(0xff4F8CFF);
const Color kBackground = Color(0xffF8FAFC);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Paramètres",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Section Général
          _buildSectionTitle("Général"),
          _buildSettingTile(
            icon: Icons.person_outline_rounded,
            title: "Informations personnelles",
            subtitle: "Nom, classe, établissement",
            color: Colors.blue,
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            subtitle: "Rappels, devoirs, examens",
            color: Colors.deepPurple,
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.dark_mode_outlined,
            title: "Thème",
            subtitle: "Mode clair / sombre",
            color: Colors.indigo,
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.language_rounded,
            title: "Langue",
            subtitle: "Français",
            color: Colors.teal,
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // Section Aide
          _buildSectionTitle("Aide et Support"),
          _buildSettingTile(
            icon: Icons.help_outline_rounded,
            title: "Aide et FAQ",
            subtitle: "Questions fréquentes",
            color: Colors.orange,
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: "Confidentialité",
            subtitle: "Sécurité des données",
            color: Colors.green,
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // Section À propos
          _buildSectionTitle("À propos"),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded, color: Colors.grey),
            title: Text("Version", style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text("1.0.0"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withOpacity(.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}