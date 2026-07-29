import 'dart:math';
import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../utils/constants.dart';

class PieceLibrary {
  PieceLibrary._();

  static final Random _random = Random();
  // CORRECTION ICI : Remplacement de 'final' par 'const'
  static const List<Color> _colors = kPieceColors;

  static Color _randomColor() => _colors[_random.nextInt(_colors.length)];
  static Color _colorAt(int index) => _colors[index % _colors.length];

  // --- Formes ---
  static Piece get monomino => Piece(
      id: 'monomino', name: 'Monomino', matrix: [[1]], color: _colorAt(0));
  static Piece get dominoH => Piece(
      id: 'domino_h', name: 'Domino', matrix: [[1, 1]], color: _colorAt(1));
  static Piece get trominoI => Piece(
      id: 'tromino_i', name: 'Tromino I', matrix: [[1, 1, 1]], color: _colorAt(2));
  static Piece get trominoL => Piece(
      id: 'tromino_l', name: 'Tromino L', matrix: [[1, 0], [1, 1]],
      color: _colorAt(3));
  static Piece get trominoV => Piece(
      id: 'tromino_v', name: 'Tromino V', matrix: [[1, 1], [1, 0]],
      color: _colorAt(4));
  static Piece get tetrominoI => Piece(
      id: 'tetromino_i', name: 'Tetromino I', matrix: [[1, 1, 1, 1]],
      color: _colorAt(5));
  static Piece get tetrominoO => Piece(
      id: 'tetromino_o', name: 'Tetromino O', matrix: [[1, 1], [1, 1]],
      color: _colorAt(6));
  static Piece get tetrominoT => Piece(
      id: 'tetromino_t', name: 'Tetromino T', matrix: [[1, 1, 1], [0, 1, 0]],
      color: _colorAt(7));
  static Piece get tetrominoL => Piece(
      id: 'tetromino_l', name: 'Tetromino L', matrix: [[1, 0], [1, 0], [1, 1]],
      color: _colorAt(8));
  static Piece get tetrominoJ => Piece(
      id: 'tetromino_j', name: 'Tetromino J', matrix: [[0, 1], [0, 1], [1, 1]],
      color: _colorAt(9));
  static Piece get tetrominoS => Piece(
      id: 'tetromino_s', name: 'Tetromino S', matrix: [[0, 1, 1], [1, 1, 0]],
      color: _colorAt(10));
  static Piece get tetrominoZ => Piece(
      id: 'tetromino_z', name: 'Tetromino Z', matrix: [[1, 1, 0], [0, 1, 1]],
      color: _colorAt(11));
  static Piece get pentominoI => Piece(
      id: 'pentomino_i', name: 'Pentomino I', matrix: [[1, 1, 1, 1, 1]],
      color: _colorAt(12));
  static Piece get pentominoL => Piece(
      id: 'pentomino_l', name: 'Pentomino L', matrix: [[1, 0], [1, 0], [1, 0], [1, 1]],
      color: _colorAt(13));
  static Piece get pentominoY => Piece(
      id: 'pentomino_y', name: 'Pentomino Y', matrix: [[0, 1], [1, 1], [0, 1], [0, 1]],
      color: _colorAt(14));
  static Piece get pentominoN => Piece(
      id: 'pentomino_n', name: 'Pentomino N', matrix: [[0, 1], [1, 1], [1, 0], [1, 0]],
      color: _colorAt(0));
  static Piece get pentominoP => Piece(
      id: 'pentomino_p', name: 'Pentomino P', matrix: [[1, 1], [1, 1], [1, 0]],
      color: _colorAt(1));
  static Piece get pentominoU => Piece(
      id: 'pentomino_u', name: 'Pentomino U', matrix: [[1, 0, 1], [1, 1, 1]],
      color: _colorAt(2));
  static Piece get pentominoV => Piece(
      id: 'pentomino_v', name: 'Pentomino V', matrix: [[1, 0, 0], [1, 0, 0], [1, 1, 1]],
      color: _colorAt(3));
  static Piece get pentominoW => Piece(
      id: 'pentomino_w', name: 'Pentomino W', matrix: [[1, 0, 0], [1, 1, 0], [0, 1, 1]],
      color: _colorAt(4));
  static Piece get pentominoX => Piece(
      id: 'pentomino_x', name: 'Pentomino X', matrix: [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
      color: _colorAt(5));
  static Piece get pentominoZ => Piece(
      id: 'pentomino_z', name: 'Pentomino Z', matrix: [[1, 1, 0], [0, 1, 0], [0, 1, 1]],
      color: _colorAt(6));
  static Piece get pentominoF => Piece(
      id: 'pentomino_f', name: 'Pentomino F', matrix: [[0, 1, 1], [1, 1, 0], [0, 1, 0]],
      color: _colorAt(7));
  static Piece get pentominoT => Piece(
      id: 'pentomino_t', name: 'Pentomino T', matrix: [[1, 1, 1], [0, 1, 0], [0, 1, 0]],
      color: _colorAt(8));
  static Piece get rect2x3 => Piece(
      id: 'rect_2x3', name: 'Rectangle 2x3', matrix: [[1, 1, 1], [1, 1, 1]],
      color: _colorAt(9));
  static Piece get square3x3 => Piece(
      id: 'square_3x3', name: 'Square 3x3', matrix: [[1, 1, 1], [1, 1, 1], [1, 1, 1]],
      color: _colorAt(10));
  static Piece get plus3x3 => Piece(
      id: 'plus_3x3', name: 'Plus', matrix: [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
      color: _colorAt(11));
  static Piece get stair2x2 => Piece(
      id: 'stair_2x2', name: 'Stair', matrix: [[1, 0], [1, 1]], color: _colorAt(12));
  static Piece get bigL3x3 => Piece(
      id: 'big_l_3x3', name: 'Big L', matrix: [[1, 0, 0], [1, 0, 0], [1, 1, 1]],
      color: _colorAt(13));
  static Piece get bigT3x3 => Piece(
      id: 'big_t_3x3', name: 'Big T', matrix: [[1, 1, 1], [0, 1, 0], [0, 1, 0]],
      color: _colorAt(14));
  static Piece get zigzag3 => Piece(
      id: 'zigzag_3', name: 'Zigzag', matrix: [[1, 0], [1, 1], [0, 1]],
      color: _colorAt(0));
  static Piece get corner2x2 => Piece(
      id: 'corner_2x2', name: 'Corner', matrix: [[1, 1], [1, 0]], color: _colorAt(1));
  static Piece get diagonal2 => Piece(
      id: 'diagonal_2', name: 'Diagonal 2', matrix: [[1, 0], [0, 1]],
      color: _colorAt(2));
  static Piece get diagonal3 => Piece(
      id: 'diagonal_3', name: 'Diagonal 3', matrix: [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      color: _colorAt(3));
  static Piece get frame3x3 => Piece(
      id: 'frame_3x3', name: 'Frame', matrix: [[1, 1, 1], [1, 0, 1], [1, 1, 1]],
      color: _colorAt(4));

  static List<Piece> get all => [
        monomino,
        dominoH,
        trominoI,
        trominoL,
        trominoV,
        tetrominoI,
        tetrominoO,
        tetrominoT,
        tetrominoL,
        tetrominoJ,
        tetrominoS,
        tetrominoZ,
        pentominoI,
        pentominoL,
        pentominoY,
        pentominoN,
        pentominoP,
        pentominoU,
        pentominoV,
        pentominoW,
        pentominoX,
        pentominoZ,
        pentominoF,
        pentominoT,
        rect2x3,
        square3x3,
        plus3x3,
        stair2x2,
        bigL3x3,
        bigT3x3,
        zigzag3,
        corner2x2,
        diagonal2,
        diagonal3,
        frame3x3,
      ];

  static int get count => all.length;
  static Piece at(int index) => all[index].copy();
  static Piece random() => all[_random.nextInt(count)].copy();
  static Piece randomWithRandomColor() =>
      random().copyWith(color: _randomColor());

  static List<Piece> getRandomPieces(int count, {Random? random}) {
    final rand = random ?? _random;
    final indices = List<int>.generate(all.length, (i) => i)..shuffle(rand);
    return indices
        .take(count)
        .map((i) => all[i].copyWith(color: _colors[rand.nextInt(_colors.length)]))
        .toList();
  }

  static List<Piece> getPlayablePieces(int count, {Random? random}) {
    final rand = random ?? _random;
    final List<Piece> result = [];
    final List<Piece> pool = all.map((p) => p.copy()).toList()..shuffle(rand);
    for (final piece in pool) {
      if (result.length >= count) break;
      if (piece.width <= 8 && piece.height <= 8) {
        result.add(
            piece.copyWith(color: _colors[rand.nextInt(_colors.length)]));
      }
    }
    while (result.length < count) {
      final p = pool[rand.nextInt(pool.length)];
      result.add(p.copyWith(color: _colors[rand.nextInt(_colors.length)]));
    }
    return result;
  }

  static List<Piece> byBlockCount(int blockCount) =>
      all.where((p) => p.blockCount == blockCount).toList();
  static Piece? byId(String id) {
    try {
      return all.firstWhere((p) => p.id == id).copy();
    } catch (_) {
      return null;
    }
  }
}