import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:mou3adli/widgets/custom_widgets.dart';
import 'package:mou3adli/navigation/custom_bottom_nav.dart';
import 'package:mou3adli/screens/term_selection_screen.dart';
import 'package:mou3adli/screens/coefficients_screen.dart';
import 'package:mou3adli/calendar_new/calendar_main_screen.dart';
// SUPPRESSION DE L'IMPORT INUTILE : import 'package:mou3adli/game/screens/blast_screen.dart';

const kCardRadius = 30.0;
const kSpacing = 28.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 82,
        leadingWidth: 76,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bonjour, Ahmed 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Passe une excellente journée",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black87,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Carte "Moyenne générale" Premium ---
            Container(
              padding: const EdgeInsets.all(24),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kCardRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(.05),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 68,
                    lineWidth: 15,
                    percent: .76,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: const Color(0xffEEF2F7),
                    progressColor: kRoyalBlue,
                    animation: true,
                    animationDuration: 1200,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "15.35",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kRoyalBlue,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "/20",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffEAF8EF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "Très bien",
                            style: TextStyle(
                              color: Color(0xff2E7D32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xffEAF8EF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                size: 16,
                                color: Color(0xff2E7D32),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "+1.20",
                              style: TextStyle(
                                color: Color(0xff2E7D32),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Progression ce trimestre",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: kSpacing),

            // --- Carte "Classe actuelle" Premium ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kCardRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(.04),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffEDF4FF),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            "Classe actuelle",
                            style: TextStyle(
                              color: kRoyalBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "9ème Année",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: kRoyalBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Année scolaire 2026-2027",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(8, 4),
                    child: Hero(
                      tag: "bag",
                      child: Image.asset(
                        "assets/images/cart.png",
                        height: 120,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: kSpacing),

            // --- Titre "Accès rapide" ---
            const Text(
              "Accès rapide",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),

            // --- Grille d'icônes Premium ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Notes
                      _buildIconContainer(
                        Icons.menu_book_rounded,
                        "Notes",
                        kRoyalBlue,
                        32,
                      ),
                      // Coefficients
                      _buildIconContainer(
                        Icons.calculate_rounded,
                        "Coefficients",
                        const Color(0xffC8A04F),
                        34,
                        onTapAction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CoefficientsScreen()),
                          );
                        },
                      ),
                      // Bulletin
                      _buildIconContainer(
                        Icons.description_rounded,
                        "Bulletin",
                        const Color(0xff43A047),
                        30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Jeux
                      _buildIconContainer(
                        Icons.sports_esports_rounded,
                        "Jeux",
                        const Color(0xffFB8C00),
                        34,
                        onTapAction: () {
                          Navigator.pushNamed(context, '/game');
                        },
                      ),
                      // Statistiques
                      _buildIconContainer(
                        Icons.bar_chart_rounded,
                        "Statistiques",
                        const Color(0xff00ACC1),
                        30,
                      ),
                      // Calendrier
                      _buildIconContainer(
                        Icons.calendar_month_rounded,
                        "Calendrier",
                        const Color(0xffAB47BC),
                        30,
                        onTapAction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CalendarMainScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CustomBottomNav(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(
    IconData icon,
    String label,
    Color color,
    double iconSize, {
    VoidCallback? onTapAction,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.95, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: () {
            if (onTapAction != null) {
              onTapAction();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermSelectionScreen()),
              );
            }
          },
          splashColor: color.withOpacity(.10),
          highlightColor: Colors.transparent,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: Colors.grey.shade100,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(.10),
                      blurRadius: 25,
                      spreadRadius: 1,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: color.withOpacity(.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff263238),
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}