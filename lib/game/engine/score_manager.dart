import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

class ScoreResult {
  final int baseScore, lineBonus, columnBonus, comboBonus, perfectClearBonus, totalScore, comboLevel;
  final bool isPerfectClear;
  const ScoreResult({
    required this.baseScore,
    required this.lineBonus,
    required this.columnBonus,
    required this.comboBonus,
    required this.perfectClearBonus,
    required this.totalScore,
    required this.comboLevel,
    required this.isPerfectClear,
  });
}

class ScoreManager extends ChangeNotifier {
  int _score = 0;
  int _bestScore = 0;
  int _combo = 0;
  int _totalLinesCleared = 0;
  int _totalColumnsCleared = 0;

  int get score => _score;
  int get bestScore => _bestScore;
  int get combo => _combo;
  int get totalLinesCleared => _totalLinesCleared;
  int get totalColumnsCleared => _totalColumnsCleared;

  void initializeBestScore(int savedBest) {
    _bestScore = savedBest;
    notifyListeners();
  }

  void addPlacementScore(int blockCount) {
    _score += blockCount * kScorePerBlock;
    _updateBestScore();
    notifyListeners();
  }

  ScoreResult processClear({
    required List<int> rowsCleared,
    required List<int> colsCleared,
    required bool perfectClear,
  }) {
    final int lineCount = rowsCleared.length;
    final int colCount = colsCleared.length;
    final int totalClears = lineCount + colCount;

    if (totalClears > 0) {
      _combo++;
    } else {
      _combo = 0;
    }

    final int cellsCleared = (lineCount * 8) + (colCount * 8) - (lineCount * colCount);
    final int baseScore = cellsCleared * kScorePerBlock;
    final int lineBonus = lineCount * kLineClearBonus;
    final int columnBonus = colCount * kColumnClearBonus;
    int clearBonus = 0;

    if (totalClears == 2) {
      clearBonus = kDoubleClearBonus;
    } else if (totalClears >= 3) {
      clearBonus = kTripleClearBonus;
    }

    final int comboBonus = _combo > 1
        ? (baseScore * (kComboMultiplierBase * (_combo - 1))).toInt()
        : 0;

    final int perfectClearBonus = perfectClear ? kPerfectClearBonus : 0;

    final int total = baseScore + lineBonus + columnBonus + clearBonus +
        comboBonus + perfectClearBonus;

    _score += total;
    _totalLinesCleared += lineCount;
    _totalColumnsCleared += colCount;
    _updateBestScore();
    notifyListeners();

    return ScoreResult(
      baseScore: baseScore,
      lineBonus: lineBonus,
      columnBonus: columnBonus,
      comboBonus: comboBonus,
      perfectClearBonus: perfectClearBonus,
      totalScore: total,
      comboLevel: _combo,
      isPerfectClear: perfectClear,
    );
  }

  void _updateBestScore() {
    if (_score > _bestScore) {
      _bestScore = _score;
    }
  }

  void reset() {
    _score = 0;
    _combo = 0;
    _totalLinesCleared = 0;
    _totalColumnsCleared = 0;
    notifyListeners();
  }

  set bestScore(int value) {
    _bestScore = value;
    notifyListeners();
  }
}