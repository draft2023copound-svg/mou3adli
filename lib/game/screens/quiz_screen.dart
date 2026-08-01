import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/games_provider.dart';
import '../data/quiz_questions.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const int _questionsPerGame = 10;

  late List<Map<String, dynamic>> _questions;
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  String? _correctAnswer;

  Timer? _timer;
  int _seconds = 0;
  static const int _timePerQuestion = 20;

  int _streak = 0;
  int _bestStreak = 0;
  bool _showCelebration = false;

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
    final allQuestions = List<Map<String, dynamic>>.from(quizQuestions);
    allQuestions.shuffle(Random());
    _questions = allQuestions.take(_questionsPerGame).toList();

    _currentIndex = 0;
    _score = 0;
    _isAnswered = false;
    _selectedAnswer = null;
    _correctAnswer = null;
    _seconds = 0;
    _streak = 0;
    _bestStreak = 0;
    _showCelebration = false;

    _startQuestionTimer();
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    _seconds = _timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds--;
        if (_seconds <= 0) {
          _timer?.cancel();
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    if (!mounted) return;
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
        _correctAnswer = _questions[_currentIndex]['answer'];
        _streak = 0;
      });
      HapticFeedback.heavyImpact();
    }
  }

  void _onAnswerSelected(String answer) {
    if (_isAnswered) return;

    _timer?.cancel();
    HapticFeedback.lightImpact();

    final correct = _questions[_currentIndex]['answer'];
    final isCorrect = answer == correct;

    setState(() {
      _isAnswered = true;
      _selectedAnswer = answer;
      _correctAnswer = correct;

      if (isCorrect) {
        _score++;
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
        if (_streak >= 3) _showCelebration = true;
      } else {
        _streak = 0;
      }
    });

    if (isCorrect) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedAnswer = null;
        _correctAnswer = null;
        _showCelebration = false;
      });
      _startQuestionTimer();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final percentage = (_score / _questions.length * 100).round();

    final gamesProvider = Provider.of<GamesProvider>(context, listen: false);
    gamesProvider.saveQuizResult(_score, _bestStreak);

    String title;
    String subtitle;
    Color color;

    if (percentage >= 90) {
      title = '🏆 EXPERT !';
      subtitle = 'Tu es un génie de la culture générale !';
      color = const Color(0xFFD4AF37);
    } else if (percentage >= 70) {
      title = '⭐ TRÈS BIEN !';
      subtitle = 'Excellentes connaissances !';
      color = const Color(0xFF3B82F6);
    } else if (percentage >= 50) {
      title = '👍 PAS MAL';
      subtitle = 'Continue à apprendre !';
      color = const Color(0xFF22C55E);
    } else {
      title = '💪 ENCOURAGEMENT';
      subtitle = 'La prochaine fois sera meilleure !';
      color = const Color(0xFFEF4444);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _ResultDialog(
        title: title,
        subtitle: subtitle,
        color: color,
        score: _score,
        total: _questions.length,
        percentage: percentage,
        bestStreak: _bestStreak,
        onRestart: () {
          Navigator.pop(context);
          _initGame();
        },
        onMenu: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(progress),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ));
                  return SlideTransition(
                    position: slideAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  key: ValueKey<int>(_currentIndex),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildCategoryBadge(question['category']),
                      const SizedBox(height: 20),
                      _buildQuestionCard(question['question']),
                      const SizedBox(height: 24),
                      ...List.generate(
                        question['options'].length,
                        (index) => _buildOption(
                          question['options'][index],
                          index,
                        ),
                      ),
                      const Spacer(),
                      _buildTimerBar(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'SCORE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFD4AF37)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFFB8941F),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_showCelebration)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                '🔥 SÉRIE !',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ),
          Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String option, int index) {
    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFE2E8F0);
    Color textColor = const Color(0xFF1E293B);
    IconData? trailingIcon;

    if (_isAnswered) {
      final answerLetter = option.split(')')[0];
      if (answerLetter == _correctAnswer) {
        bgColor = const Color(0xFF22C55E).withOpacity(0.1);
        borderColor = const Color(0xFF22C55E);
        textColor = const Color(0xFF22C55E);
        trailingIcon = Icons.check_circle_rounded;
      } else if (answerLetter == _selectedAnswer && answerLetter != _correctAnswer) {
        bgColor = const Color(0xFFEF4444).withOpacity(0.1);
        borderColor = const Color(0xFFEF4444);
        textColor = const Color(0xFFEF4444);
        trailingIcon = Icons.cancel_rounded;
      } else {
        bgColor = Colors.white;
        borderColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF94A3B8);
      }
    }

    return GestureDetector(
      onTap: _isAnswered ? null : () => _onAnswerSelected(option.split(')')[0]),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: [
            if (!_isAnswered)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _isAnswered
                    ? (option.split(')')[0] == _correctAnswer
                        ? const Color(0xFF22C55E).withOpacity(0.15)
                        : option.split(')')[0] == _selectedAnswer
                            ? const Color(0xFFEF4444).withOpacity(0.15)
                            : const Color(0xFFF1F5F9))
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  option.split(')')[0],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _isAnswered
                        ? (option.split(')')[0] == _correctAnswer
                            ? const Color(0xFF22C55E)
                            : option.split(')')[0] == _selectedAnswer
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF94A3B8))
                        : const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.split(') ')[1],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: textColor, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerBar() {
    final progress = _seconds / _timePerQuestion;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⏱️ Temps restant',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B).withOpacity(0.8),
                ),
              ),
              Text(
                '$_seconds s',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _seconds <= 5 ? Colors.red : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(
                _seconds <= 5
                    ? Colors.red
                    : _seconds <= 10
                        ? Colors.orange
                        : const Color(0xFF3B82F6),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// RESULT DIALOG
// ═══════════════════════════════════════════════════════════

class _ResultDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final int score;
  final int total;
  final int percentage;
  final int bestStreak;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  const _ResultDialog({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.score,
    required this.total,
    required this.percentage,
    required this.bestStreak,
    required this.onRestart,
    required this.onMenu,
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
              color: color.withOpacity(0.15),
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
                gradient: LinearGradient(
                  colors: [color, _darkenColor(color)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                percentage >= 70 ? Icons.emoji_events : Icons.psychology,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 4,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                    Text(
                      '$score/$total',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatBadge(
                  icon: Icons.local_fire_department,
                  label: 'Série max',
                  value: '$bestStreak',
                  iconColor: const Color(0xFFD4AF37),
                ),
                const SizedBox(width: 16),
                _StatBadge(
                  icon: Icons.check_circle,
                  label: 'Correctes',
                  value: '$score',
                  iconColor: const Color(0xFF22C55E),
                ),
                const SizedBox(width: 16),
                _StatBadge(
                  icon: Icons.percent,
                  label: 'Réussite',
                  value: '$percentage%',
                  iconColor: const Color(0xFF3B82F6),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onMenu,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'MENU',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onRestart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, _darkenColor(color)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'REJOUER',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Color _darkenColor(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }
}

// ═══════════════════════════════════════════════════════════
// STAT BADGE
// ═══════════════════════════════════════════════════════════

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _StatBadge({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor ?? const Color(0xFFD4AF37),
            size: 20,
          ),
          const SizedBox(height: 4),
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
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}