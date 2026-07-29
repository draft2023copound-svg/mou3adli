import 'board.dart'; import 'piece.dart';

class GameState {
  final Board board; final List<Piece> availablePieces;
  final int score, bestScore, combo, movesPlayed, elapsedSeconds;
  final DateTime startTime;
  final bool isPlaying, isPaused, isGameOver;

  const GameState({
    required this.board, required this.availablePieces,
    this.score = 0, this.bestScore = 0, this.combo = 0, this.movesPlayed = 0,
    required this.startTime, this.elapsedSeconds = 0, this.isPlaying = false,
    this.isPaused = false, this.isGameOver = false,
  });

  factory GameState.initial() => GameState(board: Board(), availablePieces: [], startTime: DateTime.now());

  GameState copyWith({Board? board, List<Piece>? availablePieces, int? score, int? bestScore, int? combo, int? movesPlayed, DateTime? startTime, int? elapsedSeconds, bool? isPlaying, bool? isPaused, bool? isGameOver}) {
    return GameState(board: board ?? this.board.copy(), availablePieces: availablePieces ?? this.availablePieces.map((p) => p.copy()).toList(), score: score ?? this.score, bestScore: bestScore ?? this.bestScore, combo: combo ?? this.combo, movesPlayed: movesPlayed ?? this.movesPlayed, startTime: startTime ?? this.startTime, elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds, isPlaying: isPlaying ?? this.isPlaying, isPaused: isPaused ?? this.isPaused, isGameOver: isGameOver ?? this.isGameOver);
  }

  Map<String, dynamic> toJson() => {'board': board.toJson(), 'availablePieces': availablePieces.map((p) => p.toJson()).toList(), 'score': score, 'bestScore': bestScore, 'combo': combo, 'movesPlayed': movesPlayed, 'startTime': startTime.toIso8601String(), 'elapsedSeconds': elapsedSeconds, 'isPlaying': isPlaying, 'isPaused': isPaused, 'isGameOver': isGameOver};
  factory GameState.fromJson(Map<String, dynamic> json) => GameState(board: Board.fromJson(json['board']), availablePieces: (json['availablePieces'] as List).map((e) => Piece.fromJson(e)).toList(), score: json['score'], bestScore: json['bestScore'], combo: json['combo'], movesPlayed: json['movesPlayed'], startTime: DateTime.parse(json['startTime']), elapsedSeconds: json['elapsedSeconds'], isPlaying: json['isPlaying'], isPaused: json['isPaused'], isGameOver: json['isGameOver']);
}