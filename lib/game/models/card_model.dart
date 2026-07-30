import 'package:flutter/material.dart';

class CardModel {
  final int id;
  final String emoji;
  final Color color;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.id,
    required this.emoji,
    required this.color,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardModel copyWith({
    int? id,
    String? emoji,
    Color? color,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardModel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}