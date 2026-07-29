import 'package:flutter/material.dart';

class Block {
  final int row, col;
  final Color color;
  final String id;

  const Block({required this.row, required this.col, required this.color, required this.id});

  factory Block.autoId({required int row, required int col, required Color color}) {
    return Block(row: row, col: col, color: color, id: '${row}_${col}_${DateTime.now().millisecondsSinceEpoch}_${_randomId()}');
  }

  static String _randomId() => '${DateTime.now().microsecond}${DateTime.now().millisecond}';

  Block copyWith({int? row, int? col, Color? color, String? id}) {
    return Block(row: row ?? this.row, col: col ?? this.col, color: color ?? this.color, id: id ?? this.id);
  }

  Block translate(int dRow, int dCol) => copyWith(row: row + dRow, col: col + dCol);
  bool isInBounds(int rows, int cols) => row >= 0 && row < rows && col >= 0 && col < cols;

  Map<String, dynamic> toJson() => {'row': row, 'col': col, 'color': color.value, 'id': id};
  factory Block.fromJson(Map<String, dynamic> json) => Block(row: json['row'], col: json['col'], color: Color(json['color']), id: json['id']);

  @override bool operator ==(Object other) => identical(this, other) || other is Block && other.row == row && other.col == col && other.color == color && other.id == id;
  @override int get hashCode => Object.hash(row, col, color, id);
}