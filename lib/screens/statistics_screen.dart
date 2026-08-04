import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/app_provider.dart';
import '../models/subject_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {

  late AnimationController heroController;
  late Animation<double> heroAnimation;

  @override
  void initState() {
    super.initState();

    heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    heroAnimation = CurvedAnimation(
      parent: heroController,
      curve: Curves.easeOutExpo,
    );

    heroController.forward();
  }

  @override
  void dispose() {
    heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final term = provider.currentTerm;

        if (term == null) {
          return const Scaffold(
            body: Center(
              child: Text("Aucune donnée"),
            ),
          );
        }

        final avg = provider.currentGeneralAverage;
        final annual = provider.annualAverage;
        final subjects = term.subjects.cast<Subject>();
        final isDark = provider.isDarkMode;

        final background =
            isDark ? const Color(0xff09090B) : const Color(0xffF4F7FC);
        final text =
            isDark ? Colors.white : const Color(0xff1E293B);

        return Scaffold(
          backgroundColor: background,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isDark
                      ? const Color(0xff111827)
                      : const Color(0xffEAF3FF),
                  background,
                ],
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildTopBar(text),
                          const SizedBox(height: 25),
                          FadeTransition(
                            opacity: heroAnimation,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: .85,
                                end: 1,
                              ).animate(heroAnimation),
                              child: _buildHeroCard(
                                avg,
                                annual,
                                text,
                                isDark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildQuickStats(
                            subjects,
                            text,
                            isDark,
                          ),
                          const SizedBox(height: 25),
                          _buildPerformanceCard(
                            avg,
                            annual,
                          ),
                          const SizedBox(height: 25),
                          _buildPerformanceChart(subjects),
                          const SizedBox(height: 25),
                          _buildRadarChart(subjects),
                          const SizedBox(height: 25),
                          _buildPodium(subjects),
                          const SizedBox(height: 25),
                          _buildInsights(subjects),
                          const SizedBox(height: 25),
                          _buildAIAdvice(avg),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TOP BAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildTopBar(Color text) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: text,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Text(
          "Statistiques",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: text,
            fontSize: 24,
          ),
        ),
        const Spacer(),
        const SizedBox(
          width: 46,
          height: 46,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HERO PREMIUM
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeroCard(
    double avg,
    double annual,
    Color text,
    bool dark,
  ) {
    Color gradeColor;
    if (avg >= 16) {
      gradeColor = Colors.green;
    } else if (avg >= 14) {
      gradeColor = Colors.orange;
    } else if (avg >= 10) {
      gradeColor = Colors.blue;
    } else {
      gradeColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          colors: [
            Color(0xff2563EB),
            Color(0xff1D4ED8),
            Color(0xff1E3A8A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 40,
            color: Colors.blue.withOpacity(.30),
            offset: const Offset(0, 25),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Moyenne Générale",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          TweenAnimationBuilder(
            tween: Tween(
              begin: 0.0,
              end: avg,
            ),
            duration: const Duration(seconds: 2),
            builder: (_, value, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 210,
                    height: 210,
                    child: CircularProgressIndicator(
                      value: value / 20,
                      strokeWidth: 16,
                      color: Colors.white,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.08),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        value.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 48,
                        ),
                      ),
                      const Text(
                        "/20",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              _getMention(avg),
              style: TextStyle(
                color: gradeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _heroInfo(
                Icons.trending_up,
                annual > 0 ? (avg - annual).toStringAsFixed(2) : "--",
              ),
              _heroInfo(
                Icons.workspace_premium,
                annual.toStringAsFixed(2),
              ),
              _heroInfo(
                Icons.emoji_events,
                _getTopPercent(avg),
              ),
            ],
          )
        ],
      ),
    );
  }
  String _getMention(double avg) {
    if (avg >= 18) return "Excellent 🏆";
    if (avg >= 16) return "Très Bien ⭐";
    if (avg >= 14) return "Bien 👍";
    if (avg >= 12) return "Assez Bien";
    if (avg >= 10) return "Passable";
    return "Insuffisant";
  }

  String _getTopPercent(double avg) {
    if (avg >= 18) return "Top 5%";
    if (avg >= 16) return "Top 15%";
    if (avg >= 14) return "Top 30%";
    if (avg >= 12) return "Top 50%";
    if (avg >= 10) return "Top 70%";
    return "Top 90%";
  }

  Widget _heroInfo(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // QUICK STATS — Cartes style Apple / Revolut / Notion
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickStats(
    List<Subject> subjects,
    Color text,
    bool dark,
  ) {
    final completed = subjects.where((e) => e.average > 0).length;
    final progress =
        subjects.isEmpty ? 0 : completed / subjects.length;
    final best = subjects.isEmpty
        ? 0.0
        : subjects
            .map((e) => e.average)
            .reduce(max);
    final coef = subjects.isEmpty
        ? 0
        : subjects
            .map((e) => e.coefficient)
            .reduce(max);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _premiumCard(
          icon: Icons.menu_book_rounded,
          title: "Matières",
          value: subjects.length.toString(),
          subtitle: "Modules",
          color: const Color(0xff2563EB),
        ),
        _premiumCard(
          icon: Icons.auto_graph,
          title: "Progression",
          value: "${(progress * 100).round()}%",
          subtitle: "$completed complétées",
          color: Colors.green,
        ),
        _premiumCard(
          icon: Icons.workspace_premium,
          title: "Meilleure",
          value: best.toStringAsFixed(2),
          subtitle: "/20",
          color: Colors.orange,
        ),
        _premiumCard(
          icon: Icons.star,
          title: "Coef Max",
          value: coef.toString(),
          subtitle: "Importance",
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _premiumCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            offset: const Offset(0, 15),
            color: color.withOpacity(.10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 26,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PERFORMANCE CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildPerformanceCard(
    double avg,
    double annual,
  ) {
    final diff = avg - annual;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xff0F172A),
            Color(0xff1E293B),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Performance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: _metric(
                  "Evolution",
                  diff >= 0
                      ? "+${diff.toStringAsFixed(2)}"
                      : diff.toStringAsFixed(2),
                  diff >= 0 ? Colors.green : Colors.red,
                ),
              ),
              Expanded(
                child: _metric(
                  "Objectif",
                  "18.00",
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _metric(
                  "Rang",
                  _getTopPercent(avg),
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(
    String title,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        )
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PERFORMANCE CHART — LineChart
  // ═══════════════════════════════════════════════════════════
  Widget _buildPerformanceChart(
    List<Subject> subjects,
  ) {
    final graded = subjects.where((e) => e.average > 0).toList();

    if (graded.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            blurRadius: 35,
            offset: const Offset(0, 18),
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.show_chart_rounded,
                color: Color(0xff2563EB),
              ),
              SizedBox(width: 10),
              Text(
                "Évolution des matières",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Tes performances par matière",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 35),
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 20,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles:
                      const AxisTitles(
                          sideTitles:
                          SideTitles(showTitles: false)
                      ),
                  topTitles:
                      const AxisTitles(
                          sideTitles:
                          SideTitles(showTitles: false)
                      ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= graded.length) {
                          return const SizedBox();
                        }
                        final name =
                            graded[value.toInt()].nameFr;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            name.length > 5
                                ? "${name.substring(0, 5)}."
                                : name,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: .35,
                    color: const Color(0xff2563EB),
                    barWidth: 5,
                    dotData: FlDotData(
                      show: true,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xff2563EB)
                              .withOpacity(.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    spots:
                    graded.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        e.value.average,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // RADAR CHART
  // ═══════════════════════════════════════════════════════════
  Widget _buildRadarChart(List<Subject> subjects) {
    final graded = subjects.where((e) => e.average > 0).toList();

    if (graded.length < 3) {
      return const SizedBox();
    }

    final display = graded.take(6).toList();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 15),
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.radar,
                color: Color(0xff2563EB),
              ),
              SizedBox(width: 10),
              Text(
                "Radar des compétences",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 280,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 4,
                ticksTextStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                radarBorderData: const BorderSide(
                  color: Colors.transparent,
                ),
                gridBorderData: BorderSide(
                  color: Colors.grey.shade300,
                ),
                dataSets: [
                  RadarDataSet(
                    fillColor:
                        const Color(0xff2563EB)
                            .withOpacity(.25),
                    borderColor:
                        const Color(0xff2563EB),
                    entryRadius: 4,
                    borderWidth: 3,
                    dataEntries:
                        display.map((e) {
                      return RadarEntry(
                        value: e.average,
                      );
                    }).toList(),
                  )
                ],
                getTitle: (index, angle) {
                  return RadarChartTitle(
                    text:
                        display[index].nameFr.length > 8
                            ? display[index]
                                .nameFr
                                .substring(0, 8)
                            : display[index].nameFr,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PODIUM
  // ═══════════════════════════════════════════════════════════
  Widget _buildPodium(List<Subject> subjects) {
    final graded = subjects.where((e) => e.average > 0).toList();
    graded.sort((a, b) => b.average.compareTo(a.average));

    if (graded.length < 3) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 15),
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🏆 Podium",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _podiumItem(
                  graded[1],
                  2,
                  130,
                  Colors.grey,
                ),
              ),
              Expanded(
                child: _podiumItem(
                  graded[0],
                  1,
                  180,
                  const Color(0xffD4AF37),
                ),
              ),
              Expanded(
                child: _podiumItem(
                  graded[2],
                  3,
                  100,
                  const Color(0xffCD7F32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _podiumItem(
    Subject subject,
    int rank,
    double height,
    Color color,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Text(
            rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subject.nameFr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subject.average.toStringAsFixed(2),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // INSIGHTS — Meilleure + À améliorer
  // ═══════════════════════════════════════════════════════════
  Widget _buildInsights(List<Subject> subjects) {
    final graded = subjects.where((e) => e.average > 0).toList();

    if (graded.isEmpty) return const SizedBox();

    graded.sort((a, b) => b.average.compareTo(a.average));

    final best = graded.first;
    final weak = graded.last;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 15),
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),
      child: Column(
        children: [
          _buildInsightTile(
            Icons.emoji_events,
            Colors.orange,
            "Meilleure matière",
            best.nameFr,
            best.average,
          ),
          const Divider(),
          _buildInsightTile(
            Icons.trending_down,
            Colors.red,
            "À améliorer",
            weak.nameFr,
            weak.average,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightTile(
    IconData icon,
    Color color,
    String title,
    String subject,
    double avg,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Text(
            avg.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          )
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // AI ADVICE — Conseil intelligent
  // ═══════════════════════════════════════════════════════════
  Widget _buildAIAdvice(
    double avg,
  ) {
    String advice;
    if (avg >= 16) {
      advice = "Continue sur cette lancée. Tu fais partie des meilleurs élèves.";
    } else if (avg >= 14) {
      advice = "Un point supplémentaire dans une matière principale pourrait te faire atteindre Très Bien.";
    } else if (avg >= 12) {
      advice = "Concentre-toi sur les matières à fort coefficient pour progresser rapidement.";
    } else {
      advice = "Priorise les matières en dessous de 10 afin d'augmenter rapidement ta moyenne.";
    }

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff2563EB),
            Color(0xff1D4ED8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Conseil Intelligent",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  advice,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}