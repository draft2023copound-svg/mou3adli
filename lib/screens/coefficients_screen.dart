import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_widgets.dart'; // ← AJOUTÉ pour kRoyalBlue

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

        final displayClass = user?.displayClass ?? '';
        final displayStream = user?.displayStream ?? '';
        final title = displayStream.isNotEmpty
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
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: kRoyalBlue.withOpacity(.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kRoyalBlue,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    ...term.subjects.map((s) => _buildCoeffCard(
                      s.nameFr,
                      s.nameAr,
                      _iconFromName(s.iconName),
                      s.coefficient,
                    )),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: kRoyalBlue, size: 28),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'La structure est la même pour tous.\nSeuls les coefficients changent selon\nle niveau et le type d\'établissement.',
                              style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildCoeffCard(String name, String subName, IconData icon, double coeff) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: kRoyalBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: kRoyalBlue, size: 24),
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
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: kRoyalBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kRoyalBlue.withOpacity(0.3)),
            ),
            child: Text(
              coeff.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kRoyalBlue,
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