import 'dart:math';
import '../models/board.dart';
import '../models/piece.dart';
import '../utils/constants.dart';

class PieceGenerator {
  final Random _random;
  PieceGenerator({Random? random}) : _random = random ?? Random();

  // Formes de base définies ici pour éviter toute dépendance à PieceLibrary
  final List<List<List<int>>> _baseShapes = [
    // Monomino
    [[1]],
    // Domino
    [[1, 1]],
    // Tromino I
    [[1, 1, 1]],
    // Tromino L
    [[1, 0], [1, 1]],
    // Tetromino O (Carré 2x2)
    [[1, 1], [1, 1]],
    // Tetromino T
    [[1, 1, 1], [0, 1, 0]],
    // Tetromino L
    [[1, 0], [1, 0], [1, 1]],
    // Tetromino S
    [[0, 1, 1], [1, 1, 0]],
    // Pentomino I
    [[1, 1, 1, 1, 1]],
    // Pentomino L
    [[1, 0], [1, 0], [1, 0], [1, 1]],
  ];

  /// Génère des pièces en s'assurant qu'au moins une est jouable.
  List<Piece> generate(Board board, int count) {
    final List<Piece> result = [];
    final List<Piece> playable = [];
    final List<Piece> fallback = [];

    for (final shape in _baseShapes) {
      final color = kPieceColors[_random.nextInt(kPieceColors.length)];
      final piece = Piece(matrix: shape, color: color);

      if (board.countValidPositionsForPiece(piece) > 0) {
        playable.add(piece);
      } else {
        fallback.add(piece);
      }
    }

    result.addAll(playable.take(count));

    if (result.length < count) {
      result.addAll(fallback.take(count - result.length));
    }

    while (result.length < count) {
      final shape = _baseShapes[_random.nextInt(_baseShapes.length)];
      final color = kPieceColors[_random.nextInt(kPieceColors.length)];
      result.add(Piece(matrix: shape, color: color));
    }

    return result.take(count).toList();
  }

  /// Génère des pièces garanties jouables.
  List<Piece> generateGuaranteedPlayable(Board board, int count) {
    final List<Piece> result = [];
    int attempts = 0;
    const int maxAttempts = 50;

    while (result.length < count && attempts < maxAttempts) {
      attempts++;
      final shape = _baseShapes[_random.nextInt(_baseShapes.length)];
      final color = kPieceColors[_random.nextInt(kPieceColors.length)];
      final piece = Piece(matrix: shape, color: color);

      if (board.countValidPositionsForPiece(piece) > 0 || board.occupiedCellCount == 0) {
        result.add(piece);
      }
    }

    // Si on n'a pas assez de pièces, on complète avec des petites pièces
    if (result.length < count) {
      for (int i = result.length; i < count; i++) {
        final shape = _baseShapes[_random.nextInt(_baseShapes.length)];
        final color = kPieceColors[_random.nextInt(kPieceColors.length)];
        result.add(Piece(matrix: shape, color: color));
      }
    }

    return result.take(count).toList();
  }
}