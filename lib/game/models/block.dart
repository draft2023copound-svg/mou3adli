import 'dart:math';
import 'package:flutter/material.dart';

class Block {
  final String id;
  final int row;
  final int col;
  final Color color;

  Block({
    required this.id,
    required this.row,
    required this.col,
    required this.color,
  });

  static final Random _random = Random();

  factory Block.autoId({
    required int row,
    required int col,
    required Color color,
  }) {
    return Block(
      id: 'blk_${row}_${col}_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(99999)}',
      row: row,
      col: col,
      color: color,
    );
  }

  Block copyWith({
    String? id,
    int? row,
    int? col,
    Color? color,
  }) {
    return Block(
      id: id ?? this.id,
      row: row ?? this.row,
      col: col ?? this.col,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'row': row,
      'col': col,
      'color': color.value,
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] as String,
      row: json['row'] as int,
      col: json['col'] as int,
      color: Color(json['color'] as int),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Block && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Block($id at [$row,$col])';
}