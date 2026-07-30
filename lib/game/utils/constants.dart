import 'package:flutter/material.dart';

const int kGridRows = 8;
const int kGridCols = 8;
const double kCellSize = 48.0;
const double kCellSpacing = 3.0;
const double kCellRadius = 8.0;

const int kPiecePoolSize = 3;

const int kScorePerBlock = 10;
const int kLineClearBonus = 100;
const int kColumnClearBonus = 100;
const int kDoubleClearBonus = 200;
const int kTripleClearBonus = 400;
const double kComboMultiplierBase = 1.5;
const int kPerfectClearBonus = 1000;

const Duration kFadeDuration = Duration(milliseconds: 200);
const Duration kExplosionDuration = Duration(milliseconds: 450);
const Duration kNewPiecesDelay = Duration(milliseconds: 400);
const Duration kCascadeDelay = Duration(milliseconds: 150);
const Duration kGhostFadeDuration = Duration(milliseconds: 80);

const Color kBackgroundColor = Color(0xFFFFFFFF);
const Color kBoardBackground = Color(0xFFF8FAFC);
const Color kEmptyCellColor = Color(0xFFE2E8F0);
const Color kCellBorderColor = Color(0xFFCBD5E1);
const Color kGhostColor = Color(0x40000000);
const Color kGhostBorderColor = Color(0x80000000);
// ─── COULEURS LEGACY (compatibilité combo_animation.dart) ───
const Color kAccentColor = Color(0xFF3B82F6);
const Color kSuccessColor = Color(0xFF10B981);
const Color kWarningColor = Color(0xFFF59E0B);

const Color kPrimaryTextColor = Color(0xFF1E293B);
const Color kSecondaryTextColor = Color(0xFF64748B);

const List<Color> kRoyalBlueGradient = [
  Color(0xFF1E3A8A),
  Color(0xFF2563EB),
  Color(0xFF3B82F6),
];

const Color kMatteGold = Color(0xFFD4AF37);
const Color kMatteGoldLight = Color(0xFFF5E6A3);
const Color kMatteGoldDark = Color(0xFFB8941F);

const List<Color> kPieceColors = [
  Color(0xFFEF4444),
  Color(0xFFF97316),
  Color(0xFFEAB308),
  Color(0xFF22C55E),
  Color(0xFF3B82F6),
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
  Color(0xFF14B8A6),
  Color(0xFFF43F5E),
  Color(0xFF6366F1),
];

const String kStorageKeyGameState = 'blockblast_game_state';
const String kStorageKeyBestScore = 'blockblast_best_score';