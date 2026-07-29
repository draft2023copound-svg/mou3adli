import 'package:flutter/material.dart';

const int kGridRows = 8;
const int kGridCols = 8;
const double kMinCellSize = 32.0;
const double kMaxCellSize = 64.0;
const double kCellSpacing = 2.0;
const double kCellBorderRadius = 8.0;

// NOUVELLE CONSTANTE : La taille réelle d'une cellule avec son padding
const double kCellFullSize = kMinCellSize + kCellSpacing;

const int kPiecePoolSize = 3;
const int kMaxPieceSize = 5;
const double kPiecePreviewCellSize = 28.0;

const int kScorePerBlock = 10;
const int kLineClearBonus = 100;
const int kColumnClearBonus = 100;
const int kDoubleClearBonus = 200;
const int kTripleClearBonus = 400;
const double kComboMultiplierBase = 1.5;
const int kPerfectClearBonus = 1000;

const Duration kPieceAppearDuration = Duration(milliseconds: 250);
const Duration kExplosionDuration = Duration(milliseconds: 400);
const Duration kBounceDuration = Duration(milliseconds: 300);
const Duration kPulseDuration = Duration(milliseconds: 500);
const Duration kShakeDuration = Duration(milliseconds: 300);
const Duration kFadeDuration = Duration(milliseconds: 200);
const Duration kRotationDuration = Duration(milliseconds: 200);
const Duration kGhostFadeDuration = Duration(milliseconds: 150);
const Duration kNewPiecesDelay = Duration(milliseconds: 400);
const Duration kCascadeDelay = Duration(milliseconds: 150);

const Color kBoardBackgroundColor = Color(0xFF1A1A2E);
const Color kEmptyCellColor = Color(0xFF16213E);
const Color kCellBorderColor = Color(0xFF0F3460);
const Color kGhostColor = Color(0x40FFFFFF);
const Color kPrimaryTextColor = Color(0xFFEAEAEA);
const Color kSecondaryTextColor = Color(0xFFAAAAAA);
const Color kAccentColor = Color(0xFFE94560);
const Color kSuccessColor = Color(0xFF4Ecca3);
const Color kWarningColor = Color(0xFFFFD700);

const List<Color> kPieceColors = [
  Color(0xFFFF6B6B), Color(0xFF4ECDC4), Color(0xFF45B7D1),
  Color(0xFF96CEB4), Color(0xFFFFEEAD), Color(0xFFD4A5A5),
  Color(0xFF9B59B6), Color(0xFF3498DB), Color(0xFF1ABC9C),
  Color(0xFFF39C12), Color(0xFFE74C3C), Color(0xFF2ECC71),
  Color(0xFF5DADE2), Color(0xFFAF7AC5), Color(0xFF48C9B0),
];

const List<BoxShadow> kPieceShadow = [
  BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(2, 4)),
];

const BoxShadow kComboGlow = BoxShadow(
  color: Color(0x80FFD700), blurRadius: 20, spreadRadius: 5,
);

const String kStorageKeyBoard = 'mou3adli_board';
const String kStorageKeyScore = 'mou3adli_score';
const String kStorageKeyBestScore = 'mou3adli_best_score';
const String kStorageKeyPieces = 'mou3adli_pieces';
const String kStorageKeyGameState = 'mou3adli_game_state';