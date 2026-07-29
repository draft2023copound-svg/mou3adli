import 'package:flutter/material.dart';

class Piece {
  final String id, name;
  final List<List<int>> matrix;
  final Color color;
  final int offsetRow, offsetCol;

  const Piece({
    required this.id, required this.name, required this.matrix,
    required this.color, this.offsetRow = 0, this.offsetCol = 0,
  });

  int get height => matrix.length;
  int get width => matrix[0].length;
  int get blockCount => matrix.expand((row) => row).where((cell) => cell == 1).length;

  // Méthode de copie corrigée pour les anciennes versions de Flutter
  Piece copyWith({String? id, String? name, List<List<int>>? matrix, Color? color, int? offsetRow, int? offsetCol}) {
    return Piece(
      id: id ?? this.id,
      name: name ?? this.name,
      matrix: matrix ?? this.matrix.map((row) => List<int>.from(row)).toList(),
      color: color ?? this.color,
      offsetRow: offsetRow ?? this.offsetRow,
      offsetCol: offsetCol ?? this.offsetCol,
    );
  }

  Piece withOffset(int row, int col) => copyWith(offsetRow: row, offsetCol: col);
  
  // Méthode de copie simplifiée pour "copy" (utilisée par le moteur de jeu)
  Piece copy() => copyWith();

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'matrix': matrix, 'color': color.value, 'offsetRow': offsetRow, 'offsetCol': offsetCol};
  
  factory Piece.fromJson(Map<String, dynamic> json) => Piece(
    id: json['id'], 
    name: json['name'], 
    matrix: (json['matrix'] as List).map((row) => (row as List).map((e) => e as int).toList()).toList(), 
    color: Color(json['color']), 
    offsetRow: json['offsetRow'], 
    offsetCol: json['offsetCol']
  );
}