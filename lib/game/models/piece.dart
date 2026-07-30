import 'package:flutter/material.dart';

class Piece {
  final List<List<int>> matrix;
  final Color color;

  const Piece({required this.matrix, required this.color});

  int get height => matrix.length;
  int get width => matrix[0].length;
  int get blockCount => matrix.expand((row) => row).where((c) => c == 1).length;

  Piece copyWith({List<List<int>>? matrix, Color? color}) {
    return Piece(
      matrix: matrix ?? this.matrix.map((row) => List<int>.from(row)).toList(),
      color: color ?? this.color,
    );
  }

  Piece rotate() {
    final List<List<int>> rotated = [];
    for (int c = 0; c < width; c++) {
      rotated.add(List.generate(height, (r) => matrix[height - 1 - r][c]));
    }
    return Piece(matrix: rotated, color: color);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Piece &&
        other.color == color &&
        _listEquals(other.matrix, matrix);
  }

  bool _listEquals(List<List<int>> a, List<List<int>> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(color, Object.hashAll(matrix.expand((e) => e)));

  @override
  String toString() => 'Piece(${height}x$width, $blockCount blocks)';
}