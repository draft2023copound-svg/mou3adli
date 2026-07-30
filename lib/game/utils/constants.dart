import 'package:flutter/material.dart';

const int kGridRows = 8;
const int kGridCols = 8;
const double kCellSize = 56.0;
const double kCellSpacing = 4.0;
const double kCellRadius = 4.0;

const int kPiecePoolSize = 3;

const int kScorePerBlock = 10;
const int kLineClearBonus = 100;
const int kColumnClearBonus = 100;
const int kDoubleClearBonus = 200;
const int kTripleClearBonus = 400;
const double kComboMultiplierBase = 1.5;
const int kPerfectClearBonus = 1000;

const Duration kFadeDuration = Duration(milliseconds: 200);
const Duration kExplosionDuration = Duration(milliseconds: 400);
const Duration kNewPiecesDelay = Duration(milliseconds: 300);
const Duration kCascadeDelay = Duration(milliseconds: 150);

// Thème CLAIR et LUMINEUX
const Color kBoardBackground = Color(0xFFF5F7FA);
const Color kEmptyCellColor = Color(0xFFE8ECF1);
const Color kCellBorderColor = Color(0xFFD1D5DB);
const Color kGhostColor = Color(0x40000000);
const Color kPrimaryTextColor = Color(0xFF1E293B);
const Color kSecondaryTextColor = Color(0xFF64748B);
const Color kAccentColor = Color(0xFF3B82F6);
const Color kSuccessColor = Color(0xFF10B981);
const Color kWarningColor = Color(0xFFF59E0B);

const List<Color> kPieceColors = [
  Color(0xFFEF4444), Color(0xFFF97316), Color(0xFFEAB308),
  Color(0xFF22C55E), Color(0xFF3B82F6), Color(0xFF8B5CF6),
  Color(0xFFEC4899), Color(0xFF14B8A6), Color(0xFFF43F5E),
  Color(0xFF6366F1),
];

const String kStorageKeyGameState = 'mou3adli_game_state';
const String kStorageKeyBestScore = 'mou3adli_best_score';