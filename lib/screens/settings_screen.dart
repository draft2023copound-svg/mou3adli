import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'edit_profile_screen.dart';

const Color kPrimary = Color(0xff4F8CFF);
const Color kBackground = Color(0xffF8FAFC);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
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
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
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
              // Section Compte
              _buildSectionTitle("Compte"),
              _buildSettingTile(
                icon: Icons.person_outline_rounded,
                title: "Informations personnelles",
                subtitle: "${provider.user?.fullName ?? ''} — ${provider.user?.displayClass ?? ''}",
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Section Préférences
              _buildSectionTitle("Préférences"),
              _buildToggleTile(
                icon: Icons.dark_mode_outlined,
                title: "Mode sombre",
                subtitle: "Activer le thème sombre",
                color: Colors.indigo,
                value: _darkMode,
                onChanged: (val) {
                  setState(() => _darkMode = val);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(val ? "🌙 Mode sombre activé" : "☀️ Mode clair activé"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              _buildToggleTile(
                icon: Icons.notifications_none_rounded,
                title: "Notifications",
                subtitle: "Rappels, devoirs, examens",
                color: Colors.deepPurple,
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
                onTap: () => _showLanguagePicker(context),
              ),

              const SizedBox(height: 30),

              // Section Aide
              _buildSectionTitle("Aide et Support"),
              _buildSettingTile(
                icon: Icons.help_outline_rounded,
                title: "Aide et FAQ",
                subtitle: "Questions fréquentes",
                color: Colors.orange,
                onTap: () => _showFAQ(context),
              ),
              _buildSettingTile(
                icon: Icons.privacy_tip_outlined,
                title: "Confidentialité",
                subtitle: "Sécurité des données",
                color: Colors.green,
                onTap: () => _showPrivacy(context),
              ),

              const SizedBox(height: 30),

              // Section Données
              _buildSectionTitle("Données"),
              _buildDangerTile(
                icon: Icons.delete_outline_rounded,
                title: "Effacer toutes les notes",
                subtitle: "Cette action est irréversible",
                color: Colors.red,
                onTap: () => _showClearDataDialog(context, provider),
              ),

              const SizedBox(height: 30),

              // Section À propos
              _buildSectionTitle("À propos"),
              const ListTile(
                leading: Icon(Icons.info_outline_rounded, color: Colors.grey),
                title: Text("Version", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text("1.0.0"),
              ),
              ListTile(
                leading: const Icon(Icons.code_rounded, color: Colors.grey),
                title: const Text("Développé par", style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Mou3adli Team © 2026"),
              ),
            ],
          ),
        );
      },
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

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool value,
    required ValueChanged<bool> onChanged,
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
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color),
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

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
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
            const Text(
              "Choisir la langue",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            ..._languages.map((lang) => ListTile(
              leading: Text(lang['flag'], style: const TextStyle(fontSize: 24)),
              title: Text(lang['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
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

  void _showFAQ(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("FAQ", style: TextStyle(fontWeight: FontWeight.w800)),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("❓ Comment calculer ma moyenne ?", style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text("Va dans l'onglet Notes, choisis un trimestre, puis saisis tes notes par matière. La moyenne se calcule automatiquement."),
              SizedBox(height: 16),
              Text("❓ Puis-je changer de classe ?", style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text("Oui ! Va dans Profil > Modifier le profil, change ta classe et/ou section. Les matières et coefficients se mettront à jour."),
              SizedBox(height: 16),
              Text("❓ Mes données sont-elles sauvegardées ?", style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text("Oui, tout est stocké localement sur ton téléphone."),
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

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confidentialité", style: TextStyle(fontWeight: FontWeight.w800)),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🔒 Sécurité", style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text("Toutes tes données sont stockées localement sur ton appareil. Aucune information n'est envoyée sur Internet."),
              SizedBox(height: 16),
              Text("🗑️ Suppression", style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text("Tu peux effacer tes données à tout moment depuis les paramètres."),
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

  void _showClearDataDialog(BuildContext context, AppProvider provider) {
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
              // Réinitialiser les notes de tous les trimestres
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