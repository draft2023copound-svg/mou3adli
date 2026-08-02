import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'edit_profile_screen.dart';

const Color kPrimary = Color(0xFF1C3F7A);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  String _language = 'fr';

  final List<Map<String, dynamic>> _languages = [
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇹🇳'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
  ];

  String get _languageName {
    return _languages.firstWhere((l) => l['code'] == _language)['name'];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;
    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xffF8FAFC);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final sectionColor = isDark ? Colors.grey.shade500 : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Paramètres",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Section Compte
          _buildSectionTitle("Compte", sectionColor),
          _buildSettingTile(
            icon: Icons.person_outline_rounded,
            title: "Informations personnelles",
            subtitle: "${context.watch<AppProvider>().user?.fullName ?? ''} — ${context.watch<AppProvider>().user?.displayClass ?? ''}",
            color: Colors.blue,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),

          const SizedBox(height: 30),

          // Section Préférences
          _buildSectionTitle("Préférences", sectionColor),
          _buildToggleTile(
            icon: Icons.dark_mode_outlined,
            title: "Mode sombre",
            subtitle: "Activer le thème sombre",
            color: Colors.indigo,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            value: isDark,
            onChanged: (val) {
              context.read<AppProvider>().toggleDarkMode(val);
            },
          ),
          _buildToggleTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            subtitle: "Rappels, devoirs, examens",
            color: Colors.deepPurple,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            value: _notifications,
            onChanged: (val) {
              setState(() => _notifications = val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(val ? "🔔 Notifications activées" : "🔕 Notifications désactivées"),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.language_rounded,
            title: "Langue",
            subtitle: _languageName,
            color: Colors.teal,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () => _showLanguagePicker(context, cardColor, textColor),
          ),

          const SizedBox(height: 30),

          // Section Aide
          _buildSectionTitle("Aide et Support", sectionColor),
          _buildSettingTile(
            icon: Icons.help_outline_rounded,
            title: "Aide et FAQ",
            subtitle: "Questions fréquentes",
            color: Colors.orange,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () => _showFAQ(context, cardColor, textColor),
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: "Confidentialité",
            subtitle: "Sécurité des données",
            color: Colors.green,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () => _showPrivacy(context, cardColor, textColor),
          ),

          const SizedBox(height: 30),

          // Section Données
          _buildSectionTitle("Données", sectionColor),
          _buildDangerTile(
            icon: Icons.delete_outline_rounded,
            title: "Effacer toutes les notes",
            subtitle: "Cette action est irréversible",
            color: Colors.red,
            cardColor: cardColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onTap: () => _showClearDataDialog(context),
          ),

          const SizedBox(height: 30),

          // Section À propos
          _buildSectionTitle("À propos", sectionColor),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: Colors.grey),
            title: Text("Version", style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
            subtitle: Text("1.0.0", style: TextStyle(color: subtitleColor)),
          ),
          ListTile(
            leading: const Icon(Icons.code_rounded, color: Colors.grey),
            title: Text("Développé par", style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
            subtitle: Text("Mou3adli Team © 2026", style: TextStyle(color: subtitleColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
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
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardColor,
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
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitleColor),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardColor,
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
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitleColor),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: kPrimary,
        ),
      ),
    );
  }

  Widget _buildDangerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardColor,
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
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: subtitleColor),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, Color cardColor, Color textColor) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        color: cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Choisir la langue",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textColor),
            ),
            const SizedBox(height: 20),
            ..._languages.map((lang) => ListTile(
              leading: Text(lang['flag'], style: const TextStyle(fontSize: 24)),
              title: Text(lang['name'], style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
              trailing: _language == lang['code']
                  ? const Icon(Icons.check_circle, color: kPrimary)
                  : null,
              onTap: () {
                setState(() => _language = lang['code']);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("🌐 Langue changée : ${lang['name']}")),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showFAQ(BuildContext context, Color cardColor, Color textColor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        title: Text("FAQ", style: TextStyle(fontWeight: FontWeight.w800, color: textColor)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("❓ Comment calculer ma moyenne ?", style: TextStyle(fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 4),
              Text("Va dans l'onglet Notes, choisis un trimestre, puis saisis tes notes par matière. La moyenne se calcule automatiquement.", style: TextStyle(color: textColor)),
              const SizedBox(height: 16),
              Text("❓ Puis-je changer de classe ?", style: TextStyle(fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 4),
              Text("Oui ! Va dans Profil > Modifier le profil, change ta classe et/ou section. Les matières et coefficients se mettront à jour.", style: TextStyle(color: textColor)),
              const SizedBox(height: 16),
              Text("❓ Mes données sont-elles sauvegardées ?", style: TextStyle(fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 4),
              Text("Oui, tout est stocké localement sur ton téléphone.", style: TextStyle(color: textColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context, Color cardColor, Color textColor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        title: Text("Confidentialité", style: TextStyle(fontWeight: FontWeight.w800, color: textColor)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🔒 Sécurité", style: TextStyle(fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 4),
              Text("Toutes tes données sont stockées localement sur ton appareil. Aucune information n'est envoyée sur Internet.", style: TextStyle(color: textColor)),
              const SizedBox(height: 16),
              Text("🗑️ Suppression", style: TextStyle(fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 4),
              Text("Tu peux effacer tes données à tout moment depuis les paramètres.", style: TextStyle(color: textColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    final provider = context.read<AppProvider>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("⚠️ Attention", style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          "Tu es sur le point d'effacer TOUTES tes notes. Cette action est irréversible.\n\nEs-tu sûr ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              for (final term in provider.terms) {
                for (final subject in term.subjects) {
                  for (final eval in subject.evaluations) {
                    provider.updateGrade(term.id, subject.id, eval.id, null);
                  }
                }
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("🗑️ Toutes les notes ont été effacées")),
              );
            },
            child: const Text("Effacer"),
          ),
        ],
      ),
    );
  }
}