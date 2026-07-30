import 'package:flutter/foundation.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager extends ChangeNotifier {
  int _score = 0;
  int _bestScore = 0;
  int _combo = 0;

  int get score => _score;
  int get bestScore => _bestScore;
  int get combo => _combo;

  ScoreManager() {
    _loadBestScore();
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    _bestScore = prefs.getInt(kStorageKeyBestScore) ?? 0;
    notifyListeners();
  }

  Future<void> _saveBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kStorageKeyBestScore, _bestScore);
  }

  void addPlacementScore(int blocks) {
    _score += blocks * kScorePerBlock;
    _updateBestScore();
    notifyListeners();
  }

  int processClear({required int lines, required int cols, required bool perfect}) {
    final totalClear = lines + cols;
    // CORRECTION : Ajout d'accolades
    if (totalClear > 0) {
      _combo++;
    } else {
      _combo = 0;
    }

    int base = (lines * 8 + cols * 8 - lines * cols) * kScorePerBlock;
    int bonus = 0;
    if (totalClear == 2) {
      bonus = kDoubleClearBonus;
    }
    if (totalClear >= 3) {
      bonus = kTripleClearBonus;
    }
    if (perfect) {
      bonus += kPerfectClearBonus;
    }
    if (_combo > 1) {
      bonus += (base * (kComboMultiplierBase * (_combo - 1))).toInt();
    }

    _score += base + bonus;
    _updateBestScore();
    notifyListeners();
    return base + bonus;
  }

  void _updateBestScore() {
    if (_score > _bestScore) {
      _bestScore = _score;
      _saveBestScore();
    }
  }

  void reset() {
    _score = 0;
    _combo = 0;
    notifyListeners();
  }
}