import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/card_model.dart';
import '../engine/game_engine.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen>
    with TickerProviderStateMixin {
  static const int _pairCount = 8;
  static const int _gridCols = 4;

  late List<CardModel> _cards;
  int _moves = 0;
  int _matches = 0;
  bool _isProcessing = false;
  int? _firstIndex;
  int? _secondIndex;

  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initGame() {
    setState(() {
      _cards = GameEngine.generateDeck(_pairCount);
      _moves = 0;
      _matches = 0;
      _isProcessing = false;
      _firstIndex = null;
      _secondIndex = null;
      _seconds = 0;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  String get _timeString {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onCardTap(int index) async {
    if (_isProcessing) return;
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    HapticFeedback.lightImpact();

    setState(() {
      _cards[index] = _cards[index].copyWith(isFlipped: true);
    });

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    _secondIndex = index;
    _isProcessing = true;
    _moves++;

    final first = _cards[_firstIndex!];
    final second = _cards[_secondIndex!];

    if (first.emoji == second.emoji) {
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _cards[_firstIndex!] = first.copyWith(isMatched: true);
        _cards[_secondIndex!] = second.copyWith(isMatched: true);
        _matches++;
      });

      _firstIndex = null;
      _secondIndex = null;
      _isProcessing = false;

      if (_matches == _pairCount) {
        _timer?.cancel();
        await Future.delayed(const Duration(milliseconds: 500));
        _showVictoryDialog();
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() {
        _cards[_firstIndex!] = first.copyWith(isFlipped: false);
        _cards[_secondIndex!] = second.copyWith(isFlipped: false);
      });
      _firstIndex = null;
      _secondIndex = null;
      _isProcessing = false;
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => _VictoryDialog(
        moves: _moves,
        time: _timeString,
        onRestart: () {
          Navigator.pop(context);
          _initGame();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final safeWidth = size.width - padding.horizontal - 32;

    final cardSize = (safeWidth / _gridCols).clamp(70.0, 100.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'MEMORY',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatsBar(),
            const SizedBox(height: 32),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardSize * _gridCols + 12 * (_gridCols - 1),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridCols,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) => _buildCard(index, cardSize),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildRestartButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.timer_outlined,
            label: 'TEMPS',
            value: _timeString,
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFE2E8F0),
          ),
          _StatItem(
            icon: Icons.touch_app_outlined,
            label: 'COUPS',
            value: '$_moves',
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFE2E8F0),
          ),
          _StatItem(
            icon: Icons.check_circle_outline,
            label: 'PAIRES',
            value: '$_matches/$_pairCount',
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index, double size) {
    final card = _cards[index];
    final isFlipped = card.isFlipped || card.isMatched;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(isFlipped ? 3.14159 : 0),
        transformAlignment: Alignment.center,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isFlipped ? card.color : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isFlipped
                    ? card.color.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isFlipped
                ? Text(
                    card.emoji,
                    style: TextStyle(fontSize: size * 0.5),
                  )
                : Icon(
                    Icons.question_mark_rounded,
                    color: Colors.white.withOpacity(0.3),
                    size: size * 0.35,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestartButton() {
    return GestureDetector(
      onTap: _initGame,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E293B).withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'NOUVELLE PARTIE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF94A3B8), size: 20),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Color(0xFF94A3B8),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _VictoryDialog extends StatelessWidget {
  final int moves;
  final String time;
  final VoidCallback onRestart;

  const _VictoryDialog({
    required this.moves,
    required this.time,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.celebration_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'BRAVO !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toutes les paires trouvées',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultBadge(
                  icon: Icons.touch_app_outlined,
                  label: 'Coups',
                  value: '$moves',
                ),
                const SizedBox(width: 16),
                _ResultBadge(
                  icon: Icons.timer_outlined,
                  label: 'Temps',
                  value: time,
                ),
              ],
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onRestart,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'REJOUER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ResultBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}