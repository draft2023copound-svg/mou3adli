import 'dart:math';
import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../utils/constants.dart';

class PieceLibrary {
  static final Random _random = Random();
  static final List<Color> _colors = List.from(kPieceColors);

  static Color _randomColor() => _colors[_random.nextInt(_colors.length)];

  static final List<Piece> _all = [
    Piece(matrix: [[1]], color: _colors[0]),
    Piece(matrix: [[1, 1]], color: _colors[1]),
    Piece(matrix: [[1, 1, 1]], color: _colors[2]),
    Piece(matrix: [[1, 0], [1, 1]], color: _colors[3]),
    Piece(matrix: [[1, 1], [1, 0]], color: _colors[4]),
    Piece(matrix: [[1, 1, 1, 1]], color: _colors[5]),
    Piece(matrix: [[1, 1], [1, 1]], color: _colors[6]),
    Piece(matrix: [[1, 1, 1], [0, 1, 0]], color: _colors[7]),
    Piece(matrix: [[1, 0], [1, 0], [1, 1]], color: _colors[8]),
    Piece(matrix: [[1, 0], [1, 1], [0, 1]], color: _colors[9]),
    Piece(matrix: [[1, 1, 1, 1, 1]], color: _colors[0]),
    Piece(matrix: [[1, 1, 1], [1, 1, 1], [1, 1, 1]], color: _colors[1]),
    Piece(matrix: [[1, 1], [1, 1], [1, 1]], color: _colors[2]),
    Piece(matrix: [[1, 0, 0], [1, 1, 1]], color: _colors[3]),
    Piece(matrix: [[0, 0, 1], [1, 1, 1]], color: _colors[4]),
    Piece(matrix: [[1, 1, 0], [0, 1, 1]], color: _colors[5]),
    Piece(matrix: [[1, 1, 1], [1, 0, 0], [1, 0, 0]], color: _colors[6]),
    Piece(matrix: [[1, 1, 1], [0, 0, 1], [0, 0, 1]], color: _colors[7]),
  ];

  static List<Piece> getRandomPieces(int count) {
    final List<Piece> result = [];
    for (int i = 0; i < count; i++) {
      final p = _all[_random.nextInt(_all.length)];
      result.add(Piece(
        matrix: p.matrix.map((row) => List<int>.from(row)).toList(),
        color: _randomColor(),
      ));
    }
    return result;
  }
}