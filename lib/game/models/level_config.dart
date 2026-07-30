enum DifficultyModifier {
  none,
  timeLimit,
  shuffleOnFail,
  redFlash,
  invisibleMatch,
  rotatingGrid,
  mirrorMode,
  speedRun,
  blackout,
  chaosShuffle,
  nightmare,
}

class LevelConfig {
  final int level;
  final int pairCount;
  final int gridCols;
  final int gridRows;
  final List<DifficultyModifier> modifiers;
  final int? timeLimitSeconds;
  final int? maxMoves;
  final double? speedRunSeconds;
  final String description;

  const LevelConfig({
    required this.level,
    required this.pairCount,
    required this.gridCols,
    required this.gridRows,
    this.modifiers = const [],
    this.timeLimitSeconds,
    this.maxMoves,
    this.speedRunSeconds,
    required this.description,
  });

  bool get hasTimeLimit => timeLimitSeconds != null;
  bool get hasMaxMoves => maxMoves != null;
  bool get hasSpeedRun => speedRunSeconds != null;

  static LevelConfig forLevel(int level) {
    return _levels.firstWhere(
      (l) => l.level == level,
      orElse: () => _levels.last,
    );
  }

  static const List<LevelConfig> _levels = [
    // Niveaux 1-4 : Apprentissage
    LevelConfig(level: 1, pairCount: 4, gridCols: 4, gridRows: 2, description: 'Début tranquille'),
    LevelConfig(level: 2, pairCount: 6, gridCols: 4, gridRows: 3, description: 'Un peu plus'),
    LevelConfig(level: 3, pairCount: 8, gridCols: 4, gridRows: 4, description: 'Grille standard'),
    LevelConfig(level: 4, pairCount: 10, gridCols: 5, gridRows: 4, description: 'Premier défi'),

    // Niveaux 5-7 : Timer
    LevelConfig(level: 5, pairCount: 8, gridCols: 4, gridRows: 4, modifiers: [DifficultyModifier.timeLimit], timeLimitSeconds: 60, description: 'Contre la montre !'),
    LevelConfig(level: 6, pairCount: 10, gridCols: 5, gridRows: 4, modifiers: [DifficultyModifier.timeLimit], timeLimitSeconds: 75, description: 'Plus de cartes, moins de temps'),
    LevelConfig(level: 7, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.timeLimit], timeLimitSeconds: 90, description: 'La pression monte'),

    // Niveaux 8-9 : Mélange
    LevelConfig(level: 8, pairCount: 8, gridCols: 4, gridRows: 4, modifiers: [DifficultyModifier.timeLimit, DifficultyModifier.shuffleOnFail], timeLimitSeconds: 60, description: 'Le terrain bouge !'),
    LevelConfig(level: 9, pairCount: 10, gridCols: 5, gridRows: 4, modifiers: [DifficultyModifier.timeLimit, DifficultyModifier.shuffleOnFail], timeLimitSeconds: 70, description: 'Chaque erreur coûte cher'),

    // Niveaux 10-14 : FLASH ROUGE
    LevelConfig(level: 10, pairCount: 6, gridCols: 4, gridRows: 3, modifiers: [DifficultyModifier.redFlash], description: '⚠️ FLASH ROUGE activé !'),
    LevelConfig(level: 11, pairCount: 8, gridCols: 4, gridRows: 4, modifiers: [DifficultyModifier.redFlash], description: 'Le rouge te ralentit'),
    LevelConfig(level: 12, pairCount: 10, gridCols: 5, gridRows: 4, modifiers: [DifficultyModifier.redFlash, DifficultyModifier.timeLimit], timeLimitSeconds: 80, description: 'Flash + Timer = 🔥'),
    LevelConfig(level: 13, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.redFlash, DifficultyModifier.shuffleOnFail], description: 'Triple menace'),
    LevelConfig(level: 14, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.redFlash, DifficultyModifier.timeLimit], timeLimitSeconds: 100, description: 'Grande grille, gros risques'),

    // Niveaux 15-19 : Invisible
    LevelConfig(level: 15, pairCount: 8, gridCols: 4, gridRows: 4, modifiers: [DifficultyModifier.invisibleMatch], description: 'Les paires disparaissent !'),
    LevelConfig(level: 16, pairCount: 10, gridCols: 5, gridRows: 4, modifiers: [DifficultyModifier.invisibleMatch, DifficultyModifier.timeLimit], timeLimitSeconds: 70, description: 'Mémoire visuelle obligatoire'),
    LevelConfig(level: 17, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.invisibleMatch, DifficultyModifier.redFlash], description: 'Tu ne vois plus rien'),
    LevelConfig(level: 18, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.invisibleMatch, DifficultyModifier.shuffleOnFail], description: 'Où sont les paires ?'),
    LevelConfig(level: 19, pairCount: 18, gridCols: 6, gridRows: 6, modifiers: [DifficultyModifier.invisibleMatch, DifficultyModifier.timeLimit, DifficultyModifier.redFlash], timeLimitSeconds: 120, description: 'L\'enfer blanc'),

    // Niveaux 20-24 : Rotation
    LevelConfig(level: 20, pairCount: 10, gridCols: 5, gridRows: 4, modifiers: [DifficultyModifier.rotatingGrid], description: '🔄 La grille tourne !'),
    LevelConfig(level: 21, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.rotatingGrid, DifficultyModifier.timeLimit], timeLimitSeconds: 80, description: 'Orientation perdue'),
    LevelConfig(level: 22, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.rotatingGrid, DifficultyModifier.redFlash], description: 'Tournis garanti'),
    LevelConfig(level: 23, pairCount: 18, gridCols: 6, gridRows: 6, modifiers: [DifficultyModifier.rotatingGrid, DifficultyModifier.invisibleMatch], description: 'Chaos spatial'),
    LevelConfig(level: 24, pairCount: 20, gridCols: 5, gridRows: 8, modifiers: [DifficultyModifier.rotatingGrid, DifficultyModifier.timeLimit, DifficultyModifier.shuffleOnFail], timeLimitSeconds: 100, description: 'Grille verticale infernale'),

    // Niveaux 25-29 : Miroir
    LevelConfig(level: 25, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.mirrorMode], description: '🪞 Tout est inversé !'),
    LevelConfig(level: 26, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.mirrorMode, DifficultyModifier.timeLimit], timeLimitSeconds: 90, description: 'Gauche = Droite'),
    LevelConfig(level: 27, pairCount: 18, gridCols: 6, gridRows: 6, modifiers: [DifficultyModifier.mirrorMode, DifficultyModifier.redFlash], description: 'Miroir brisé'),
    LevelConfig(level: 28, pairCount: 20, gridCols: 5, gridRows: 8, modifiers: [DifficultyModifier.mirrorMode, DifficultyModifier.rotatingGrid], description: 'Double distortion'),
    LevelConfig(level: 29, pairCount: 24, gridCols: 6, gridRows: 8, modifiers: [DifficultyModifier.mirrorMode, DifficultyModifier.timeLimit, DifficultyModifier.shuffleOnFail], timeLimitSeconds: 120, description: 'Grille massive miroir'),

    // Niveaux 30-34 : Speed Run
    LevelConfig(level: 30, pairCount: 8, gridCols: 4, gridRows: 4, modifiers: [DifficultyModifier.speedRun], speedRunSeconds: 3.0, description: '⚡ 3 secondes par coup !'),
    LevelConfig(level: 31, pairCount: 10, gridCols: 5, gridRows: 4, modifiers: [DifficultyModifier.speedRun, DifficultyModifier.timeLimit], timeLimitSeconds: 45, speedRunSeconds: 3.0, description: 'Vitesse supersonique'),
    LevelConfig(level: 32, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.speedRun, DifficultyModifier.redFlash], speedRunSeconds: 2.5, description: 'Flash rapide'),
    LevelConfig(level: 33, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.speedRun, DifficultyModifier.mirrorMode], speedRunSeconds: 2.5, description: 'Miroir express'),
    LevelConfig(level: 34, pairCount: 18, gridCols: 6, gridRows: 6, modifiers: [DifficultyModifier.speedRun, DifficultyModifier.rotatingGrid], speedRunSeconds: 2.0, description: '2 secondes !?'),

    // Niveaux 35-39 : Blackout
    LevelConfig(level: 35, pairCount: 10, gridCols: 5, gridRows: 4, modifiers: [DifficultyModifier.blackout], description: '🌑 Écran noir entre coups'),
    LevelConfig(level: 36, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.blackout, DifficultyModifier.timeLimit], timeLimitSeconds: 70, description: 'Mémoire dans le noir'),
    LevelConfig(level: 37, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.blackout, DifficultyModifier.redFlash], description: 'Rouge dans le noir'),
    LevelConfig(level: 38, pairCount: 18, gridCols: 6, gridRows: 6, modifiers: [DifficultyModifier.blackout, DifficultyModifier.mirrorMode], description: 'Miroir noir'),
    LevelConfig(level: 39, pairCount: 20, gridCols: 5, gridRows: 8, modifiers: [DifficultyModifier.blackout, DifficultyModifier.speedRun], speedRunSeconds: 3.0, description: 'Vitesse dans l\'obscurité'),

    // Niveaux 40-44 : Chaos Shuffle
    LevelConfig(level: 40, pairCount: 12, gridCols: 6, gridRows: 4, modifiers: [DifficultyModifier.chaosShuffle], description: '🔀 Mélange total toutes les 5 coups !'),
    LevelConfig(level: 41, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.chaosShuffle, DifficultyModifier.timeLimit], timeLimitSeconds: 80, description: 'Chaos chronométré'),
    LevelConfig(level: 42, pairCount: 18, gridCols: 6, gridRows: 6, modifiers: [DifficultyModifier.chaosShuffle, DifficultyModifier.redFlash], description: 'Flash chaotique'),
    LevelConfig(level: 43, pairCount: 20, gridCols: 5, gridRows: 8, modifiers: [DifficultyModifier.chaosShuffle, DifficultyModifier.mirrorMode], description: 'Miroir détruit'),
    LevelConfig(level: 44, pairCount: 24, gridCols: 6, gridRows: 8, modifiers: [DifficultyModifier.chaosShuffle, DifficultyModifier.blackout], description: 'Chaos noir'),

    // Niveaux 45-50 : NIGHTMARE
    LevelConfig(level: 45, pairCount: 15, gridCols: 6, gridRows: 5, modifiers: [DifficultyModifier.nightmare], timeLimitSeconds: 90, speedRunSeconds: 4.0, description: '👿 MODE NIGHTMARE'),
    LevelConfig(level: 46, pairCount: 18, gridCols: 6, gridRows: 6, modifiers: [DifficultyModifier.nightmare], timeLimitSeconds: 100, speedRunSeconds: 3.5, description: 'Nightmare +'),
    LevelConfig(level: 47, pairCount: 20, gridCols: 5, gridRows: 8, modifiers: [DifficultyModifier.nightmare], timeLimitSeconds: 110, speedRunSeconds: 3.0, description: 'Nightmare ++'),
    LevelConfig(level: 48, pairCount: 24, gridCols: 6, gridRows: 8, modifiers: [DifficultyModifier.nightmare], timeLimitSeconds: 120, speedRunSeconds: 2.5, description: 'Nightmare +++'),
    LevelConfig(level: 49, pairCount: 30, gridCols: 6, gridRows: 10, modifiers: [DifficultyModifier.nightmare], timeLimitSeconds: 150, speedRunSeconds: 2.0, description: 'IMPOSSIBLE ?'),
    LevelConfig(level: 50, pairCount: 36, gridCols: 8, gridRows: 9, modifiers: [DifficultyModifier.nightmare], timeLimitSeconds: 180, speedRunSeconds: 1.5, description: '🏆 LÉGENDAIRE'),
  ];
}