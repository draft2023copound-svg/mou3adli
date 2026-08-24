import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_widgets.dart' as cw;

class CoefficientsScreen extends StatelessWidget {
  const CoefficientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        final term = provider.currentTerm;

        if (term == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Trier par coefficient décroissant
        final sortedSubjects = List.of(term.subjects)
          ..sort((a, b) => b.coefficient.compareTo(a.coefficient));

        final totalCoeff = sortedSubjects.fold<double>(
          0, (sum, s) => sum + s.coefficient.toDouble(),
        );
        final maxCoeff = sortedSubjects.isNotEmpty
            ? sortedSubjects.first.coefficient.toDouble()
            : 1.0;

        final displayClass = user?.displayClass ?? '';
        final displayStream = user?.displayStream ?? '';
        final classLevel = user?.classLevel ?? '';

        // Pas de section pour la 1ère année (tronc commun)
        final hasStream = classLevel == '2eme' ||
            classLevel == '3eme' ||
            classLevel == '4eme';
        final title = (hasStream && displayStream.isNotEmpty)
            ? '$displayClass — $displayStream'
            : displayClass;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Coefficients',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 8),

              // Badge classe
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: cw.kRoyalBlue.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cw.kRoyalBlue.withValues(alpha: .15)),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: cw.kRoyalBlue,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Récapitulatif
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.functions_rounded,
                        label: 'Total',
                        value: totalCoeff.toStringAsFixed(1),
                        color: cw.kRoyalBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.star_rounded,
                        label: 'Max',
                        value: maxCoeff.toStringAsFixed(1),
                        color: const Color(0xFFC5A059),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        icon: Icons.menu_book_rounded,
                        label: 'Matières',
                        value: '${sortedSubjects.length}',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Liste des coefficients
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    ...sortedSubjects.map((s) => _buildCoeffCard(
                      name: s.nameFr,
                      subName: s.nameAr,
                      icon: _iconFromName(s.iconName),
                      coeff: s.coefficient.toDouble(),
                      maxCoeff: maxCoeff,
                    )),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCoeffCard({
    required String name,
    required String subName,
    required IconData icon,
    required double coeff,
    required double maxCoeff,
  }) {
    final progress = coeff / maxCoeff;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cw.kRoyalBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: cw.kRoyalBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    if (subName.isNotEmpty)
                      Text(
                        subName,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        textDirection: TextDirection.rtl,
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [cw.kRoyalBlue, Color(0xFF2A5A9E)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '×${coeff.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation(
                coeff >= 4
                    ? const Color(0xFFC5A059)
                    : coeff >= 3
                        ? cw.kRoyalBlue
                        : coeff >= 2
                            ? Colors.blue.shade400
                            : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
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
      _ => Icons.school,
    };
  }
}