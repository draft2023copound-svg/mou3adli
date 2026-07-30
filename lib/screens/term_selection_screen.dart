import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'subject_list_screen.dart';

class TermSelectionScreen extends StatefulWidget {
  const TermSelectionScreen({super.key});

  @override
  State<TermSelectionScreen> createState() => _TermSelectionScreenState();
}

class _TermSelectionScreenState extends State<TermSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const Color backgroundColor = Color(0xFFF6F8FC);
  static const Color primaryColor = Color(0xFF4F8CFF);
  static const Color successColor = Color(0xFF43A047);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getStatus(term) {
    final now = DateTime.now();
    if (term.endDate != null && now.isAfter(term.endDate!)) return 'Terminé';
    if (term.startDate != null && now.isBefore(term.startDate!)) return 'À venir';
    return 'En cours';
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      'Terminé' => successColor,
      'À venir' => Colors.grey,
      _ => Colors.orange,
    };
  }

  IconData _getStatusIcon(String status) {
    return switch (status) {
      'Terminé' => Icons.check_circle_rounded,
      'À venir' => Icons.schedule_rounded,
      _ => Icons.autorenew_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final terms = provider.terms;
        final currentTerm = provider.currentTerm;
        final avg = provider.currentGeneralAverage;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
              'Mes Trimestres',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF8FAFF), Color(0xFFEEF3FB)],
              ),
            ),
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                children: [
                  Text(
                    'Bonjour, ${provider.user?.fullName.split(' ').first ?? 'Élève'} 👋',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Consultez vos notes et vos matières facilement.',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          Icons.menu_book_rounded,
                          '${currentTerm?.subjects.length ?? 0}',
                          'Matières',
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          Icons.trending_up_rounded,
                          avg > 0 ? avg.toStringAsFixed(1) : '--',
                          'Moyenne',
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          Icons.percent_rounded,
                          '${((currentTerm?.progress ?? 0) * 100).toStringAsFixed(0)}%',
                          'Progression',
                          primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Trimestre actuel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  if (currentTerm != null) _buildCurrentTerm(context, currentTerm, provider),

                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: primaryColor, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Autres trimestres',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // CORRECTION : Suppression du .toList()
                  ...terms.where((t) => t.id != currentTerm?.id).map((t) {
                    final status = _getStatus(t);
                    return _buildSmallTermCard(
                      t.nameFr,
                      '${t.startDate?.day ?? 1}/${t.startDate?.month ?? 1} • ${t.endDate?.day ?? 30}/${t.endDate?.month ?? 6}',
                      status,
                      _getStatusIcon(status),
                      _getStatusColor(status),
                      t.generalAverage,
                      onTap: () {
                        provider.setCurrentTerm(t.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SubjectListScreen()),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCurrentTerm(BuildContext context, term, AppProvider provider) {
    final avg = term.generalAverage;
    final progress = term.progress;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF9FBFF)],
        ),
        border: Border.all(color: primaryColor.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFB74D), Color(0xFFFB8C00)]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.autorenew_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      term.nameFr,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${term.startDate?.day ?? 1}/${term.startDate?.month ?? 1} • ${term.endDate?.day ?? 30}/${term.endDate?.month ?? 6}',
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  '✨ Actuel',
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              const Text('Progression', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)} %',
                style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(primaryColor),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(child: _buildInfoChip(Icons.menu_book_rounded, '${term.subjects.length} Matières')),
              const SizedBox(width: 12),
              Expanded(child: _buildInfoChip(Icons.assignment_turned_in_rounded, '${term.subjects.where((s) => s.average > 0).length} Notées')),
            ],
          ),
          const SizedBox(height: 28),
          if (avg > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: primaryColor),
                  const SizedBox(width: 12),
                  Text(
                    'Moyenne: ${avg.toStringAsFixed(2)}/20',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: primaryColor),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubjectListScreen()),
              ),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Voir les matières', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildSmallTermCard(
    String title,
    String subtitle,
    String status,
    IconData icon,
    Color color,
    double avg, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                    const SizedBox(height: 5),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    if (avg > 0)
                      Text(
                        'Moy: ${avg.toStringAsFixed(2)}',
                        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFB0B0B0)),
            ],
          ),
        ),
      ),
    );
  }
}