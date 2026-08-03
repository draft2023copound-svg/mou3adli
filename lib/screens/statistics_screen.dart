import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_provider.dart';
import '../models/subject_model.dart';
import '../models/term_model.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final isDark = provider.isDarkMode;
        final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB);
        final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
        final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
        final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);
        final cardShadow = isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.04);

        final term = provider.currentTerm;
        final avg = provider.currentGeneralAverage;
        final annualAvg = provider.annualAverage;

        if (term == null) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: Text("Aucune donnée disponible", style: TextStyle(color: textSecondary)),
            ),
          );
        }

        final List<Subject> subjects = term.subjects.cast<Subject>();
    
        final hasGrades = subjects.any((s) => s.average > 0);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Statistiques',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ═══════════════════════════════════════════════════
                // 1. MOYENNE GÉNÉRALE — Jauge circulaire
                // ═══════════════════════════════════════════════════
                _buildAverageGauge(avg, annualAvg, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                const SizedBox(height: 20),

                // ═══════════════════════════════════════════════════
                // 2. INFOS RAPIDES — 4 cartes
                // ═══════════════════════════════════════════════════
                _buildQuickStats(term, subjects, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                const SizedBox(height: 20),

                if (hasGrades) ...[
                  // ═══════════════════════════════════════════════════
                  // 3. GRAPHIQUE EN BARRES — Moyennes par matière
                  // ═══════════════════════════════════════════════════
                  _buildBarChart(subjects, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                  const SizedBox(height: 20),

                  // ═══════════════════════════════════════════════════
                  // 4. TOP 3 + MATIÈRES À AMÉLIORER
                  // ═══════════════════════════════════════════════════
                  _buildTopAndWeak(subjects, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                  const SizedBox(height: 20),

                  // ═══════════════════════════════════════════════════
                  // 5. DISTRIBUTION DES MENTIONS — Pie Chart
                  // ═══════════════════════════════════════════════════
                  _buildMentionsDistribution(subjects, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                  const SizedBox(height: 20),

                  // ═══════════════════════════════════════════════════
                  // 6. TAUX DE COMPLÉTION
                  // ═══════════════════════════════════════════════════
                  _buildCompletionRate(subjects, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                  const SizedBox(height: 20),

                  // ═══════════════════════════════════════════════════
                  // 7. COEFFICIENTS PONDÉRÉS
                  // ═══════════════════════════════════════════════════
                  _buildCoefficientsChart(subjects, surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),
                ] else
                  _buildEmptyState(surfaceColor, textPrimary, textSecondary, textMuted, cardShadow),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 1. JAUJE CIRCULAIRE DE LA MOYENNE
  // ═══════════════════════════════════════════════════════════
  Widget _buildAverageGauge(double avg, double annualAvg, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final percentage = avg > 0 ? avg / 20 : 0.0;
    final color = avg >= 16 ? Colors.green : avg >= 14 ? const Color(0xFFC5A059) : avg >= 12 ? Colors.orange : avg >= 10 ? Colors.blue : Colors.red;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: cardShadow, blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        children: [
          Text("Moyenne Générale", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 18,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(
                children: [
                  Text(avg > 0 ? avg.toStringAsFixed(2) : '--', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: textPrimary)),
                  Text("/20", style: TextStyle(fontSize: 18, color: textMuted)),
                  if (avg > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                      child: Text(_getMention(avg), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                    ),
                ],
              ),
            ],
          ),
          if (annualAvg > 0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, color: const Color(0xFF1C3F7A), size: 18),
                  const SizedBox(width: 8),
                  Text("Moyenne annuelle: ${annualAvg.toStringAsFixed(2)}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1C3F7A))),
                ],
              ),
            ),
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

  // ═══════════════════════════════════════════════════════════
  // 2. INFOS RAPIDES — 4 cartes
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickStats(Term term, List<Subject> subjects, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final totalSubjects = subjects.length;
    final completed = subjects.where((s) => s.average > 0).length;
    final totalCoeff = subjects.fold(0.0, (sum, s) => sum + s.coefficient);
    final maxCoeff = subjects.isNotEmpty ? subjects.map((s) => s.coefficient).reduce((a, b) => a > b ? a : b) : 1;

    final stats = [
      {'icon': Icons.menu_book, 'value': '$totalSubjects', 'label': 'Matières', 'color': Colors.blue},
      {'icon': Icons.check_circle, 'value': '$completed', 'label': 'Notées', 'color': Colors.green},
      {'icon': Icons.functions, 'value': totalCoeff.toStringAsFixed(1), 'label': 'Total Coef.', 'color': const Color(0xFF1C3F7A)},
      {'icon': Icons.star, 'value': maxCoeff.toStringAsFixed(1), 'label': 'Max Coef.', 'color': const Color(0xFFC5A059)},
    ];

    return Row(
      children: stats.map((s) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 12, offset: const Offset(0, 6))]),
          child: Column(
            children: [
              Icon(s['icon'] as IconData, color: s['color'] as Color, size: 22),
              const SizedBox(height: 8),
              Text(s['value'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimary)),
              const SizedBox(height: 4),
              Text(s['label'] as String, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 3. GRAPHIQUE EN BARRES — Moyennes par matière
  // ═══════════════════════════════════════════════════════════
  Widget _buildBarChart(List<Subject> subjects, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final gradedSubjects = subjects.where((s) => s.average > 0).toList();
    if (gradedSubjects.isEmpty) return const SizedBox.shrink();


    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 18, offset: const Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Moyennes par matière", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 4),
          Text("Classement des matières notées", style: TextStyle(fontSize: 13, color: textMuted)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final subject = gradedSubjects[groupIndex];
                      return BarTooltipItem(
                        '${subject.nameFr}\n${subject.average.toStringAsFixed(2)}/20',
                        TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < gradedSubjects.length) {
                          final name = gradedSubjects[value.toInt()].nameFr;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              name.length > 6 ? '${name.substring(0, 6)}..' : name,
                              style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w600),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: TextStyle(fontSize: 10, color: textMuted)),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true, horizontalInterval: 5, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: textMuted.withOpacity(0.1), strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                barGroups: gradedSubjects.asMap().entries.map((entry) {
                  final index = entry.key;
                  final subject = entry.value;
                  final color = subject.average >= 16 ? Colors.green : subject.average >= 12 ? const Color(0xFFC5A059) : subject.average >= 10 ? Colors.orange : Colors.red;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: subject.average,
                        color: color,
                        width: 22,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 20,
                          color: textMuted.withOpacity(0.05),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 4. TOP 3 + MATIÈRES À AMÉLIORER
  // ═══════════════════════════════════════════════════════════
  Widget _buildTopAndWeak(List<Subject> subjects, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final graded = subjects.where((s) => s.average > 0).toList()..sort((a, b) => b.average.compareTo(a.average));
    final top3 = graded.take(3).toList();
    final weak = graded.where((s) => s.average < 12).toList()..sort((a, b) => a.average.compareTo(b.average));
    final weak3 = weak.take(3).toList();

    return Row(
      children: [
        // TOP 3
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 12, offset: const Offset(0, 6))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: const Color(0xFFC5A059), size: 20),
                    const SizedBox(width: 8),
                    Text("Top 3", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                ...top3.asMap().entries.map((entry) {
                  final index = entry.key;
                  final subject = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(color: const Color(0xFFC5A059).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                          child: Center(child: Text('${index + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFC5A059)))),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(subject.nameFr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary), overflow: TextOverflow.ellipsis)),
                        Text(subject.average.toStringAsFixed(2), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.green)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // À AMÉLIORER
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 12, offset: const Offset(0, 6))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text("À améliorer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                if (weak3.isEmpty)
                  Text("Toutes les matières sont au dessus de 12 ! 🎉", style: TextStyle(fontSize: 12, color: textMuted))
                else
                  ...weak3.map((subject) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Icon(Icons.warning_amber_rounded, size: 12, color: Colors.red)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(subject.nameFr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary), overflow: TextOverflow.ellipsis)),
                        Text(subject.average.toStringAsFixed(2), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.red)),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 5. DISTRIBUTION DES MENTIONS — Pie Chart
  // ═══════════════════════════════════════════════════════════
  Widget _buildMentionsDistribution(List<Subject> subjects, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final graded = subjects.where((s) => s.average > 0).toList();
    if (graded.isEmpty) return const SizedBox.shrink();

    final excellent = graded.where((s) => s.average >= 18).length;
    final tresBien = graded.where((s) => s.average >= 16 && s.average < 18).length;
    final bien = graded.where((s) => s.average >= 14 && s.average < 16).length;
    final assezBien = graded.where((s) => s.average >= 12 && s.average < 14).length;
    final passable = graded.where((s) => s.average >= 10 && s.average < 12).length;
    final insuffisant = graded.where((s) => s.average < 10).length;

    final sections = [
      {'label': 'Excellent', 'value': excellent, 'color': Colors.green.shade700},
      {'label': 'Très Bien', 'value': tresBien, 'color': Colors.green},
      {'label': 'Bien', 'value': bien, 'color': const Color(0xFFC5A059)},
      {'label': 'Assez Bien', 'value': assezBien, 'color': Colors.orange},
      {'label': 'Passable', 'value': passable, 'color': Colors.blue},
      {'label': 'Insuffisant', 'value': insuffisant, 'color': Colors.red},
    ].where((s) => (s['value'] as int) > 0).toList();

    final total = graded.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 18, offset: const Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Distribution des mentions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 4),
          Text("Répartition des matières par mention", style: TextStyle(fontSize: 13, color: textMuted)),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: sections.map((s) {
                      final value = s['value'] as int;
                      final percentage = (value / total) * 100;
                      return PieChartSectionData(
                        color: s['color'] as Color,
                        value: value.toDouble(),
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: 40,
                        titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: sections.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(width: 12, height: 12, decoration: BoxDecoration(color: s['color'] as Color, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s['label'] as String, style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w600))),
                        Text('${s['value']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textPrimary)),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 6. TAUX DE COMPLÉTION
  // ═══════════════════════════════════════════════════════════
  Widget _buildCompletionRate(List<Subject> subjects, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final totalEvals = subjects.fold(0, (sum, s) => sum + s.evaluations.length);
    final filledEvals = subjects.fold(0, (sum, s) => sum + s.filledCount);
    final progress = totalEvals > 0 ? filledEvals / totalEvals : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 18, offset: const Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Taux de complétion", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 4),
          Text("$filledEvals / $totalEvals évaluations remplies", style: TextStyle(fontSize: 13, color: textMuted)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: textMuted.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(progress >= 0.8 ? Colors.green : progress >= 0.5 ? const Color(0xFFC5A059) : Colors.orange),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${(progress * 100).toStringAsFixed(0)}%", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textPrimary)),
              Text(progress >= 0.8 ? "Excellent ! 🎉" : progress >= 0.5 ? "Continue ! 💪" : "À compléter ⚠️", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: progress >= 0.8 ? Colors.green : progress >= 0.5 ? const Color(0xFFC5A059) : Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 7. COEFFICIENTS PONDÉRÉS — Horizontal bar chart
  // ═══════════════════════════════════════════════════════════
  Widget _buildCoefficientsChart(List<Subject> subjects, Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    final sorted = List<Subject>.of(subjects)..sort((a, b) => b.coefficient.compareTo(a.coefficient));
    final maxCoeff = sorted.first.coefficient.toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 18, offset: const Offset(0, 8))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Coefficients des matières", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 4),
          Text("Importance de chaque matière dans la moyenne", style: TextStyle(fontSize: 13, color: textMuted)),
          const SizedBox(height: 16),
          ...sorted.take(6).map((subject) {
            final progress = subject.coefficient / maxCoeff;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(width: 100, child: Text(subject.nameFr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: textMuted.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation(subject.coefficient >= 4 ? const Color(0xFFC5A059) : subject.coefficient >= 3 ? const Color(0xFF1C3F7A) : Colors.blue.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${subject.coefficient}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textPrimary)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ÉTAT VIDE
  // ═══════════════════════════════════════════════════════════
  Widget _buildEmptyState(Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted, Color cardShadow) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: cardShadow, blurRadius: 18, offset: const Offset(0, 8))]),
      child: Column(
        children: [
          Icon(Icons.bar_chart, size: 64, color: textMuted),
          const SizedBox(height: 16),
          Text("Aucune statistique", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textSecondary)),
          const SizedBox(height: 8),
          Text("Saisis tes notes dans l'onglet Calculatrice pour voir tes statistiques !", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: textMuted)),
        ],
      ),
    );
  }
}