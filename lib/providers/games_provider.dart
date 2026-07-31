import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamesProvider extends ChangeNotifier {
  static const String _keyMemoryMaxLevel = 'memory_max_level';
  static const String _keyQuizBestScore = 'quiz_best_score';
  static const String _keyQuizBestStreak = 'quiz_best_streak';
  static const String _keyQuizGamesPlayed = 'quiz_games_played';
  static const String _keyMemoryGamesPlayed = 'memory_games_played';
  static const String _keyTotalScore = 'games_total_score';
  static const String _keyBadges = 'games_badges';

  int _memoryMaxLevel = 1;
  int _quizBestScore = 0;
  int _quizBestStreak = 0;
  int _quizGamesPlayed = 0;
  int _memoryGamesPlayed = 0;
  int _totalScore = 0;
  List<String> _badges = [];

  // Getters
  int get memoryMaxLevel => _memoryMaxLevel;
  int get quizBestScore => _quizBestScore;
  int get quizBestStreak => _quizBestStreak;
  int get quizGamesPlayed => _quizGamesPlayed;
  int get memoryGamesPlayed => _memoryGamesPlayed;
  int get totalScore => _totalScore;
  List<String> get badges => List.unmodifiable(_badges);

  GamesProvider() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _memoryMaxLevel = prefs.getInt(_keyMemoryMaxLevel) ?? 1;
      _quizBestScore = prefs.getInt(_keyQuizBestScore) ?? 0;
      _quizBestStreak = prefs.getInt(_keyQuizBestStreak) ?? 0;
      _quizGamesPlayed = prefs.getInt(_keyQuizGamesPlayed) ?? 0;
      _memoryGamesPlayed = prefs.getInt(_keyMemoryGamesPlayed) ?? 0;
      _totalScore = prefs.getInt(_keyTotalScore) ?? 0;
      _badges = prefs.getStringList(_keyBadges) ?? [];
      notifyListeners();
    } catch (e) {
      debugPrint('GamesProvider load error: $e');
    }
  }

  Future<void> _saveInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    } catch (e) {
      debugPrint('GamesProvider save error: $e');
    }
  }

  Future<void> _saveStringList(String key, List<String> value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(key, value);
    } catch (e) {
      debugPrint('GamesProvider save error: $e');
    }
  }

  Future<void> saveMemoryProgress(int levelReached) async {
    if (levelReached > _memoryMaxLevel) {
      _memoryMaxLevel = levelReached;
      await _saveInt(_keyMemoryMaxLevel, levelReached);
      _checkBadges();
      notifyListeners();
    }
    _memoryGamesPlayed++;
    await _saveInt(_keyMemoryGamesPlayed, _memoryGamesPlayed);
    notifyListeners();
  }

  Future<void> saveQuizResult(int score, int streak) async {
    _quizGamesPlayed++;
    await _saveInt(_keyQuizGamesPlayed, _quizGamesPlayed);

    _totalScore += score;
    await _saveInt(_keyTotalScore, _totalScore);

    if (score > _quizBestScore) {
      _quizBestScore = score;
      await _saveInt(_keyQuizBestScore, score);
    }

    if (streak > _quizBestStreak) {
      _quizBestStreak = streak;
      // ✅ CORRIGÉ ICI : utilisation de _keyQuizBestStreak au lieu de _keyBestStreak
      await _saveInt(_keyQuizBestStreak, streak);
    }

    _checkBadges();
    notifyListeners();
  }

  void _checkBadges() {
    final newBadges = <String>[];

    if (_memoryMaxLevel >= 5 && !_badges.contains('memory_5')) {
      newBadges.add('memory_5');
    }
    if (_memoryMaxLevel >= 10 && !_badges.contains('memory_10')) {
      newBadges.add('memory_10');
    }
    if (_memoryMaxLevel >= 25 && !_badges.contains('memory_25')) {
      newBadges.add('memory_25');
    }
    if (_memoryMaxLevel >= 50 && !_badges.contains('memory_50')) {
      newBadges.add('memory_50');
    }
    if (_quizBestScore >= 8 && !_badges.contains('quiz_expert')) {
      newBadges.add('quiz_expert');
    }
    if (_quizBestStreak >= 5 && !_badges.contains('quiz_streak_5')) {
      newBadges.add('quiz_streak_5');
    }
    if (_totalScore >= 1000 && !_badges.contains('score_1000')) {
      newBadges.add('score_1000');
    }
    if (_memoryGamesPlayed + _quizGamesPlayed >= 50 && !_badges.contains('player_50')) {
      newBadges.add('player_50');
    }

    if (newBadges.isNotEmpty) {
      _badges.addAll(newBadges);
      _saveStringList(_keyBadges, _badges);
    }
  }

  String getBadgeIcon(String badge) {
    return switch (badge) {
      'memory_5' => '🧠',
      'memory_10' => '🔥',
      'memory_25' => '⚡',
      'memory_50' => '👑',
      'quiz_expert' => '🎯',
      'quiz_streak_5' => '🔥',
      'score_1000' => '💎',
      'player_50' => '🎮',
      _ => '🏆',
    };
  }

  String getBadgeLabel(String badge) {
    return switch (badge) {
      'memory_5' => 'Apprenti',
      'memory_10' => 'Vétéran',
      'memory_25' => 'Maître',
      'memory_50' => 'Légende',
      'quiz_expert' => 'Expert',
      'quiz_streak_5' => 'Série X5',
      'score_1000' => 'Millénaire',
      'player_50' => 'Accro',
      _ => 'Badge',
    };
  }

  void resetProgress() {
    _memoryMaxLevel = 1;
    _quizBestScore = 0;
    _quizBestStreak = 0;
    _quizGamesPlayed = 0;
    _memoryGamesPlayed = 0;
    _totalScore = 0;
    _badges = [];
    _loadProgress();
  }
}