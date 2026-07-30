import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_widgets.dart';
import '../navigation/custom_bottom_nav.dart';
import 'term_selection_screen.dart';
import 'coefficients_screen.dart';
import 'subject_list_screen.dart';
import 'package:mou3adli/calendar_new/calendar_main_screen.dart'; // <-- CORRIGÉ ICI

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
    setState(() => _currentIndex = index);
  }

  String _getMention(double avg) {
    if (avg >= 16) return 'Excellent';
    if (avg >= 14) return 'Très bien';
    if (avg >= 12) return 'Bien';
    if (avg >= 10) return 'Passable';
    return 'Insuffisant';
  }

  Color _getMentionColor(double avg) {
    if (avg >= 16) return const Color(0xff2E7D32);
    if (avg >= 14) return const Color(0xff1565C0);
    if (avg >= 12) return const Color(0xffF57C00);
    if (avg >= 10) return const Color(0xff795548);
    return const Color(0xffC62828);
  }

  Color _getMentionBg(double avg) {
    if (avg >= 16) return const Color(0xffEAF8EF);
    if (avg >= 14) return const Color(0xffE3F2FD);
    if (avg >= 12) return const Color(0xffFFF3E0);
    if (avg >= 10) return const Color(0xffEFEBE9);
    return const Color(0xffFFEBEE);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        final term = provider.currentTerm;
        final avg = provider.currentGeneralAverage;
        final progress = term?.progress ?? 0;
        final annualAvg = provider.annualAverage;

        final displayName = user?.fullName ?? 'Élève';
        final displayClass = user?.displayClass ?? '';
        final displayStream = user?.displayStream ?? '';
        final classLabel = displayStream.isNotEmpty
            ? '$displayClass • $displayStream'
            : displayClass;

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
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: kRoyalBlue.withOpacity(.1),
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M',
                    style: const TextStyle(
                      color: kRoyalBlue,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${displayName.split(' ').first} 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  classLabel.isNotEmpty ? classLabel : 'Passe une excellente journée',
                  style: const TextStyle(
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
                // ─── CARTE MOYENNE GÉNÉRALE ───
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
                        percent: (avg / 20).clamp(0.0, 1.0),
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: const Color(0xffEEF2F7),
                        progressColor: avg >= 10 ? kRoyalBlue : const Color(0xffC62828),
                        animation: true,
                        animationDuration: 1200,
                        startAngle: 135,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              avg > 0 ? avg.toStringAsFixed(2) : '--',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: avg >= 10 ? kRoyalBlue : const Color(0xffC62828),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '/20',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
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
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: avg > 0 ? _getMentionBg(avg) : const Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                avg > 0 ? _getMention(avg) : 'Pas encore de notes',
                                style: TextStyle(
                                  color: avg > 0 ? _getMentionColor(avg) : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: avg > 0 ? 14 : 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            if (annualAvg > 0) ...[
                              Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: annualAvg >= avg
                                          ? const Color(0xffEAF8EF)
                                          : const Color(0xffFFEBEE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      annualAvg >= avg
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: 16,
                                      color: annualAvg >= avg
                                          ? const Color(0xff2E7D32)
                                          : const Color(0xffC62828),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Annuelle: ${annualAvg.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 6),
                            Text(
                              term != null
                                  ? '${term.nameFr} • ${(progress * 100).toStringAsFixed(0)}% complété'
                                  : 'Chargement...',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: kSpacing),

                // ─── CARTE CLASSE ───
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xffEDF4FF),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Text(
                                'Classe actuelle',
                                style: TextStyle(
                                  color: kRoyalBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              displayClass.isNotEmpty ? displayClass : 'Non défini',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: kRoyalBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Année scolaire 2026-2027',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(8, 4),
                        child: Hero(
                          tag: 'bag',
                          child: Image.asset(
                            'assets/images/cart.png',
                            height: 120,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.school,
                              size: 80,
                              color: kRoyalBlue.withOpacity(.2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: kSpacing),

                // ─── TOP 3 MATIÈRES ───
                if (provider.subjectRankings.isNotEmpty) ...[
                  const Text(
                    'Top matières',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...provider.subjectRankings.take(3).map((s) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kRoyalBlue.withOpacity(.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _iconFromName(s['iconName'] as String),
                              color: kRoyalBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s['nameFr'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'Coeff ${s['coefficient']}',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getMentionBg(s['average'] as double),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              (s['average'] as double).toStringAsFixed(2),
                              style: TextStyle(
                                color: _getMentionColor(s['average'] as double),
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: kSpacing),
                ],

                // ─── ACCÈS RAPIDE ───
                const Text(
                  'Accès rapide',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildIconContainer(
                            Icons.menu_book_rounded,
                            'Notes',
                            kRoyalBlue,
                            32,
                            onTapAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SubjectListScreen()),
                            ),
                          ),
                          _buildIconContainer(
                            Icons.calculate_rounded,
                            'Coefficients',
                            const Color(0xffC8A04F),
                            34,
                            onTapAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CoefficientsScreen()),
                            ),
                          ),
                          _buildIconContainer(
                            Icons.description_rounded,
                            'Bulletin',
                            const Color(0xff43A047),
                            30,
                            onTapAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TermSelectionScreen()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildIconContainer(
                            Icons.extension_rounded,
                            'Jeux',
                            const Color(0xffFB8C00),
                            34,
                            onTapAction: () => Navigator.pushNamed(context, '/game'),
                          ),
                          _buildIconContainer(
                            Icons.bar_chart_rounded,
                            'Statistiques',
                            const Color(0xff00ACC1),
                            30,
                            onTapAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TermSelectionScreen()),
                            ),
                          ),
                          _buildIconContainer(
                            Icons.calendar_month_rounded,
                            'Calendrier',
                            const Color(0xffAB47BC),
                            30,
                            onTapAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CalendarMainScreen()),
                            ),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
      },
    );
  }

  IconData _iconFromName(String name) {
    return switch (name) {
      'menu_book' => Icons.menu_book,
      'translate' => Icons.translate,
      'language' => Icons.language,
      'calculate' => Icons.calculate,
      'science' => Icons.science,
      'eco' => Icons.eco,
      'history' => Icons.history,
      'public' => Icons.public,
      'settings' => Icons.settings,
      'mosque' => Icons.mosque,
      'account_balance' => Icons.account_balance,
      'computer' => Icons.computer,
      'sports' => Icons.sports,
      'psychology' => Icons.psychology,
      'trending_up' => Icons.trending_up,
      'business' => Icons.business,
      'code' => Icons.code,
      'router' => Icons.router,
      'devices' => Icons.devices,
      'school' => Icons.school,
      'fitness_center' => Icons.fitness_center,
      'biotech' => Icons.biotech,
      _ => Icons.menu_book,
    };
  }

  Widget _buildIconContainer(
    IconData icon,
    String label,
    Color color,
    double iconSize, {
    VoidCallback? onTapAction,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.95, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTapAction ?? () {},
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
                  border: Border.all(color: Colors.grey.shade100),
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
                    child: Icon(icon, color: color, size: iconSize),
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