import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameEngine {
  static final Random _random = Random();

  static const List<String> _emojis = [
    '🦁', '🦊', '🐼', '🐨', '🐯', '🐷',
    '🐸', '🐙', '🦄', '🦋', '🌵', '🍄',
    '🚀', '🎸', '🎨', '⚽', '🍕', '🍦',
  ];

  static const List<Color> _colors = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFEAB308),
    Color(0xFF22C55E),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
  ];

  static List<CardModel> generateDeck(int pairCount) {
    final selected = _emojis.sublist(0, pairCount);
    final List<CardModel> deck = [];

    for (int i = 0; i < selected.length; i++) {
      final color = _colors[i % _colors.length];
      deck.add(CardModel(id: i * 2, emoji: selected[i], color: color));
      deck.add(CardModel(id: i * 2 + 1, emoji: selected[i], color: color));
    }

    deck.shuffle(_random);
    return deck;
  }
}