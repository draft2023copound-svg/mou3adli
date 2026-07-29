import 'dart:math'; import '../models/board.dart'; import '../models/piece.dart'; import 'piece_library.dart';

class PieceGenerator {
  final Random _random;
  PieceGenerator({Random? random}) : _random = random ?? Random();

  List<Piece> generate(Board board, int count) {
    final List<Piece> result = [];
    final List<Piece> library = PieceLibrary.all.map((p) => p.copy()).toList()..shuffle(_random);
    final List<Piece> playablePieces = [], fallbackPieces = [];
    for (final piece in library) {
      final coloredPiece = piece.copyWith(color: PieceLibrary.all[_random.nextInt(PieceLibrary.count)].color);
      if (board.countValidPositionsForPiece(coloredPiece) > 0) playablePieces.add(coloredPiece);
      else fallbackPieces.add(coloredPiece);
    }
    result.addAll(playablePieces.take(count));
    if (result.length < count) result.addAll(fallbackPieces.take(count - result.length));
    while (result.length < count) { final p = library[_random.nextInt(library.length)].copy(); result.add(p.copyWith(color: PieceLibrary.all[_random.nextInt(PieceLibrary.count)].color)); }
    return result.take(count).toList();
  }

  List<Piece> generateRandom(int count) => PieceLibrary.getRandomPieces(count, random: _random);

  List<Piece> generateGuaranteedPlayable(Board board, int count) {
    final List<Piece> result = []; int attempts = 0; const int maxAttempts = 100;
    while (result.length < count && attempts < maxAttempts) {
      attempts++;
      final piece = PieceLibrary.randomWithRandomColor();
      if (board.countValidPositionsForPiece(piece) > 0 || board.occupiedCellCount == 0) result.add(piece);
    }
    if (result.isEmpty) {
      final smallPieces = PieceLibrary.byBlockCount(1)..addAll(PieceLibrary.byBlockCount(2));
      for (int i = 0; i < count; i++) result.add(smallPieces[_random.nextInt(smallPieces.length)].copy());
    }
    while (result.length < count) result.add(PieceLibrary.randomWithRandomColor());
    return result.take(count).toList();
  }
}