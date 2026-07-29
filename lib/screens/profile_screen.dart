import 'package:flutter/material.dart';
import 'package:mou3adli/screens/home_screen.dart';
import 'package:mou3adli/screens/term_selection_screen.dart';
import 'package:mou3adli/calendar_new/calendar_main_screen.dart';
import 'package:mou3adli/screens/edit_profile_screen.dart'; // <-- Nouvel import
import 'package:mou3adli/screens/settings_screen.dart';     // <-- Nouvel import

const Color kPrimary = Color(0xff4F8CFF);
const Color kSecondary = Color(0xff6C63FF);
const Color kBackground = Color(0xffF8FAFC);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFDFEFF),
              Color(0xffF7F9FD),
              Color(0xffF2F6FC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildPerformanceCard(context),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Vue d'ensemble",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildStatisticsGrid(context),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      Text(
                        "Activité récente",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Voir tout",
                        style: TextStyle(
                          color: kPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _buildActivityTimeline(context),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Objectifs & Progression",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildGoalsCard(context),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Paramètres",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _buildSettingsSection(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HEADER PREMIUM ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff4F8CFF),
            Color(0xff6D5DF6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(.35),
            blurRadius: 35,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            left: -70,
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      // --- Redirection vers l'écran Paramètres ---
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.settings_outlined, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Hero(
                  tag: "profile",
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=11"),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Ahmed Ben Ali",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "9ème Année • Lycée Pilote",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.90),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.18),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Excellent élève",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        // --- Redirection vers l'écran Modifier ---
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: kPrimary,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          "Modifier",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("📤 Partager le profil")),
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.share, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CARTE PERFORMANCE ---
  Widget _buildPerformanceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.auto_graph, color: kPrimary, size: 26),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Performance scolaire",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Évolution du trimestre",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green, size: 18),
                    SizedBox(width: 5),
                    Text(
                      "+0.85",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [kPrimary, kSecondary],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "17.45",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Moyenne Générale",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: .87,
              minHeight: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(kPrimary),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Objectif : 18.00",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const Spacer(),
              const Text(
                "87 %",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: _smallInfo("Classement", "4", Icons.emoji_events, Colors.orange)),
              const SizedBox(width: 15),
              Expanded(child: _smallInfo("XP", "2450", Icons.bolt, Colors.deepPurple)),
              const SizedBox(width: 15),
              Expanded(child: _smallInfo("Niveau", "15", Icons.star, Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInfo(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // --- GRILLE STATISTIQUES ---
  Widget _buildStatisticsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.18,
        children: [
          _statItem(
            context: context,
            title: "Matières",
            value: "12",
            subtitle: "+2 ce mois",
            icon: Icons.menu_book_rounded,
            color: Colors.blue,
            targetScreen: const HomeScreen(),
          ),
          _statItem(
            context: context,
            title: "Devoirs",
            value: "18",
            subtitle: "4 cette semaine",
            icon: Icons.assignment_rounded,
            color: Colors.deepPurple,
            targetScreen: const TermSelectionScreen(),
          ),
          _statItem(
            context: context,
            title: "Examens",
            value: "3",
            subtitle: "À venir",
            icon: Icons.event_note_rounded,
            color: Colors.orange,
            targetScreen: const CalendarMainScreen(),
          ),
          _statItem(
            context: context,
            title: "Présence",
            value: "98%",
            subtitle: "Excellent",
            icon: Icons.verified_rounded,
            color: Colors.green,
          ),
          _statItem(
            context: context,
            title: "Série",
            value: "25",
            subtitle: "Jours actifs",
            icon: Icons.local_fire_department_rounded,
            color: Colors.redAccent,
          ),
          _statItem(
            context: context,
            title: "Objectifs",
            value: "5",
            subtitle: "En cours",
            icon: Icons.flag_rounded,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    Widget? targetScreen,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          if (targetScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("📊 Statistiques : $title ($value)")),
            );
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- TIMELINE ACTIVITÉ ---
  Widget _buildActivityTimeline(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _activityCard(
            context: context,
            color: Colors.green,
            icon: Icons.grade_rounded,
            title: "Nouvelle note en Mathématiques",
            subtitle: "18.5 /20",
            time: "Aujourd'hui • 09:45",
            targetScreen: const HomeScreen(),
          ),
          _activityCard(
            context: context,
            color: Colors.orange,
            icon: Icons.assignment_rounded,
            title: "Devoir de Physique ajouté",
            subtitle: "À rendre le 12 Juin",
            time: "Hier • 18:20",
            targetScreen: const TermSelectionScreen(),
          ),
          _activityCard(
            context: context,
            color: Colors.red,
            icon: Icons.event_note_rounded,
            title: "Examen de Français",
            subtitle: "Dans 3 jours",
            time: "Lundi",
            targetScreen: const CalendarMainScreen(),
          ),
          _activityCard(
            context: context,
            color: Colors.blue,
            icon: Icons.emoji_events,
            title: "Objectif atteint",
            subtitle: "Moyenne supérieure à 17",
            time: "Cette semaine",
          ),
        ],
      ),
    );
  }

  Widget _activityCard({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    Widget? targetScreen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              Container(
                width: 2,
                height: 65,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: InkWell(
              onTap: () {
                if (targetScreen != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetScreen),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("📌 $title")),
                  );
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(18),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 16, color: Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- OBJECTIFS ET PROGRESSION ---
  Widget _buildGoalsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.flag_rounded, color: Colors.orange),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Objectif annuel",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "87 %",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            "18.00 /20",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            "Encore 0.55 point pour atteindre ton objectif.",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: .87,
              minHeight: 12,
              valueColor: AlwaysStoppedAnimation(kPrimary),
              backgroundColor: Color(0xffEAEAEA),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(child: _goalInfo("Niveau", "15", Icons.star_rounded, Colors.amber)),
              const SizedBox(width: 15),
              Expanded(child: _goalInfo("XP", "2450", Icons.bolt_rounded, Colors.deepPurple)),
            ],
          ),
          const SizedBox(height: 18),
          _streakCard(),
          const SizedBox(height: 22),
          const Text(
            "Badges obtenus",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _BadgeChip(
                icon: Icons.workspace_premium,
                label: "Excellent élève",
                color: Colors.orange,
              ),
              _BadgeChip(
                icon: Icons.menu_book,
                label: "Travailleur",
                color: Colors.blue,
              ),
              _BadgeChip(
                icon: Icons.local_fire_department,
                label: "25 jours",
                color: Colors.red,
              ),
              _BadgeChip(
                icon: Icons.flag,
                label: "Objectif",
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _goalInfo(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _streakCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 36),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Série actuelle",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(height: 4),
                Text("25 jours de travail consécutifs"),
              ],
            ),
          ),
          const Text(
            "🔥 25",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }

  // --- PARAMÈTRES ---
  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _settingTile(
            context: context,
            icon: Icons.person_outline,
            title: "Informations personnelles",
            subtitle: "Nom, classe, établissement",
            color: Colors.blue,
          ),
          _settingTile(
            context: context,
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            subtitle: "Examens, devoirs et rappels",
            color: Colors.deepPurple,
          ),
          _settingTile(
            context: context,
            icon: Icons.dark_mode_outlined,
            title: "Thème",
            subtitle: "Mode clair / sombre",
            color: Colors.indigo,
          ),
          _settingTile(
            context: context,
            icon: Icons.language_rounded,
            title: "Langue",
            subtitle: "Français",
            color: Colors.teal,
          ),
          _settingTile(
            context: context,
            icon: Icons.help_outline,
            title: "Aide & Support",
            subtitle: "FAQ et assistance",
            color: Colors.orange,
          ),
          _settingTile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: "Confidentialité",
            subtitle: "Sécurité des données",
            color: Colors.green,
          ),
          const SizedBox(height: 18),
          _logoutCard(context),
          const SizedBox(height: 30),
          Text(
            "Mou3adli v1.0.0",
            style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "© 2026 Tous droits réservés",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
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
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("🛠️ $title")),
          );
        },
      ),
    );
  }

  Widget _logoutCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffFF6B6B),
            Color(0xffFF4D4D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        leading: const Icon(Icons.logout_rounded, color: Colors.white),
        title: const Text(
          "Déconnexion",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: const Text(
          "Quitter votre compte",
          style: TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Déconnexion"),
              content: const Text("Voulez-vous vraiment vous déconnecter ?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("👋 Déconnecté !")),
                    );
                  },
                  child: const Text("Se déconnecter"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _BadgeChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}