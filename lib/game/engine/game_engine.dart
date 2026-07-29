import 'package:flutter/foundation.dart';
import '../models/board.dart';
import '../models/game_state.dart';
import '../models/piece.dart';
import '../utils/constants.dart';
import 'board_manager.dart';
// SUPPRESSION DE L'IMPORT INUTILE : import 'collision_manager.dart';
import 'piece_generator.dart';
import 'score_manager.dart';

enum GameEvent { piecePlaced, linesCleared, columnsCleared, doubleClear, tripleClear, combo, perfectClear, gameOver, newPiecesGenerated }

class GameEventData {
  final GameEvent event;
  final int? score, combo;
  final List<int>? rows, cols;
  final Piece? piece;
  final int? row, col;

  const GameEventData({
    required this.event,
    this.score,
    this.combo,
    this.rows,
    this.cols,
    this.piece,
    this.row,
    this.col,
  });
}

class GameEngine extends ChangeNotifier {
  final ScoreManager _scoreManager;
  final PieceGenerator _pieceGenerator;
  BoardManager _boardManager;
  List<Piece> _availablePieces = [];
  bool _isGameOver = false, _isPaused = false;
  int _movesPlayed = 0;
  DateTime _startTime = DateTime.now();
  final ValueNotifier<GameEventData?> eventNotifier = ValueNotifier(null);

  Board get board => _boardManager.board;
  ScoreManager get scoreManager => _scoreManager;
  List<Piece> get availablePieces => List.unmodifiable(_availablePieces);
  bool get isGameOver => _isGameOver;
  bool get isPaused => _isPaused;
  int get movesPlayed => _movesPlayed;

  GameEngine({
    ScoreManager? scoreManager,
    PieceGenerator? pieceGenerator,
    BoardManager? boardManager,
  })  : _scoreManager = scoreManager ?? ScoreManager(),
        _pieceGenerator = pieceGenerator ?? PieceGenerator(),
        _boardManager = boardManager ?? BoardManager();

  void startGame() {
    _boardManager.reset();
    _scoreManager.reset();
    _availablePieces.clear();
    _isGameOver = false;
    _isPaused = false;
    _movesPlayed = 0;
    _startTime = DateTime.now();
    _generateNewPieces();
    notifyListeners();
  }

  void pause() {
    _isPaused = true;
    notifyListeners();
  }

  void resume() {
    _isPaused = false;
    notifyListeners();
  }

  void restart() => startGame();

  Future<bool> placePiece(Piece piece, int row, int col, {int? pieceIndex}) async {
    if (_isGameOver || _isPaused) {
      return false;
    }
    final result = _boardManager.placePiece(piece, row, col);
    if (!result.success) {
      return false;
    }
    _movesPlayed++;
    _scoreManager.addPlacementScore(piece.blockCount);
    _emitEvent(GameEvent.piecePlaced, piece: piece, row: row, col: col);

    if (result.clearedRows.isNotEmpty || result.clearedCols.isNotEmpty) {
      await _handleClear(result);
    }

    if (pieceIndex != null) {
      _availablePieces.removeAt(pieceIndex);
    }

    if (_availablePieces.isEmpty) {
      await Future.delayed(kNewPiecesDelay);
      _generateNewPieces();
      _emitEvent(GameEvent.newPiecesGenerated);
    }
    _checkGameOver();
    notifyListeners();
    return true;
  }

  Future<void> _handleClear(PlacementResult result) async {
    final scoreResult = _scoreManager.processClear(
      rowsCleared: result.clearedRows,
      colsCleared: result.clearedCols,
      perfectClear: result.perfectClear,
    );
    GameEvent event;
    final int totalClears = result.clearedRows.length + result.clearedCols.length;

    if (result.perfectClear) {
      event = GameEvent.perfectClear;
    } else if (totalClears >= 3) {
      event = GameEvent.tripleClear;
    } else if (totalClears == 2 || (result.clearedRows.isNotEmpty && result.clearedCols.isNotEmpty)) {
      event = GameEvent.doubleClear;
    } else if (result.clearedRows.isNotEmpty) {
      event = GameEvent.linesCleared;
    } else {
      event = GameEvent.columnsCleared;
    }

    _emitEvent(
      event,
      score: scoreResult.totalScore,
      combo: scoreResult.comboLevel,
      rows: result.clearedRows,
      cols: result.clearedCols,
    );

    if (scoreResult.comboLevel > 1) {
      _emitEvent(
        GameEvent.combo,
        score: scoreResult.comboBonus,
        combo: scoreResult.comboLevel,
      );
    }
    await Future.delayed(kCascadeDelay);
  }

  void _generateNewPieces() {
    _availablePieces = _pieceGenerator.generateGuaranteedPlayable(_boardManager.board, kPiecePoolSize);
  }

  void _checkGameOver() {
    if (_availablePieces.isEmpty) {
      return;
    }
    if (!_boardManager.hasValidMove(_availablePieces)) {
      _isGameOver = true;
      _emitEvent(GameEvent.gameOver);
    }
  }

  GameState get currentState => GameState(
        board: _boardManager.copyBoard(),
        availablePieces: _availablePieces.map((p) => p.copy()).toList(),
        score: _scoreManager.score,
        bestScore: _scoreManager.bestScore,
        combo: _scoreManager.combo,
        movesPlayed: _movesPlayed,
        startTime: _startTime,
        isPlaying: !_isGameOver && !_isPaused,
        isPaused: _isPaused,
        isGameOver: _isGameOver,
      );

  void restoreState(GameState state) {
    _boardManager = BoardManager(board: state.board.copy());
    _availablePieces = state.availablePieces.map((p) => p.copy()).toList();
    _scoreManager.initializeBestScore(state.bestScore);
    _movesPlayed = state.movesPlayed;
    _startTime = state.startTime;
    _isPaused = state.isPaused;
    _isGameOver = state.isGameOver;
    notifyListeners();
  }

  void _emitEvent(
    GameEvent event, {
    int? score,
    int? combo,
    List<int>? rows,
    List<int>? cols,
    Piece? piece,
    int? row,
    int? col,
  }) {
    eventNotifier.value = GameEventData(
      event: event,
      score: score,
      combo: combo,
      rows: rows,
      cols: cols,
      piece: piece,
      row: row,
      col: col,
    );
  }

  @override
  void dispose() {
    eventNotifier.dispose();
    super.dispose();
  }
}