import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/games_provider.dart';
import '../models/level_config.dart';
import '../engine/game_engine.dart';
import '../models/card_model.dart';

class MemoryScreen extends StatefulWidget {
  final int? startLevel;
  const MemoryScreen({super.key, this.startLevel});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen>
    with TickerProviderStateMixin {
  late LevelConfig _config;
  late List<CardModel> _cards;
  int _currentLevel = 1;
  int _moves = 0;
  int _matches = 0;
  bool _isProcessing = false;
  int? _firstIndex;
  int? _secondIndex;

  Timer? _timer;
  int _seconds = 0;
  int? _timeLimit;

  Timer? _speedTimer;
  double _speedProgress = 1.0;

  bool _isRedFlashing = false;
  Timer? _redFlashTimer;

  bool _isBlackout = false;

  int _chaosCounter = 0;

  double _gridRotation = 0.0;

  bool _isMirror = false;

  bool _isGameOver = false;

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _initLevel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speedTimer?.cancel();
    _redFlashTimer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _initLevel() {
    final gamesProvider = Provider.of<GamesProvider>(context, listen: false);
    final maxLevel = gamesProvider.memoryMaxLevel;

    // Si startLevel est spécifié et débloqué, l'utiliser
    if (widget.startLevel != null && widget.startLevel! <= maxLevel) {
      _currentLevel = widget.startLevel!;
    } else {
      _currentLevel = 1;
    }

    _config = LevelConfig.forLevel(_currentLevel);
    _cards = GameEngine.generateDeck(_config.pairCount);
    _moves = 0;
    _matches = 0;
    _isProcessing = false;
    _firstIndex = null;
    _secondIndex = null;
    _seconds = 0;
    _timeLimit = _config.timeLimitSeconds;
    _speedProgress = 1.0;
    _isRedFlashing = false;
    _isBlackout = false;
    _chaosCounter = 0;
    _gridRotation = 0.0;
    _isMirror = false;
    _isGameOver = false;

    if (_config.hasTimeLimit) {
      _startTimer();
    }

    if (_config.modifiers.contains(DifficultyModifier.nightmare)) {
      _gridRotation = math.pi / 4;
      _isMirror = true;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _seconds++;
        if (_timeLimit != null && _seconds >= _timeLimit!) {
          _gameOver('Temps écoulé !');
        }
      });
    });
  }

  void _startSpeedTimer() {
    _speedTimer?.cancel();
    if (!_config.hasSpeedRun) return;

    _speedProgress = 1.0;
    _speedTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      setState(() {
        _speedProgress -= 0.05 / _config.speedRunSeconds!;
        if (_speedProgress <= 0) {
          _speedTimer?.cancel();
          _gameOver('Trop lent !');
        }
      });
    });
  }

  void _triggerRedFlash() {
    if (!mounted) return;
    if (!_config.modifiers.contains(DifficultyModifier.redFlash) &&
        !_config.modifiers.contains(DifficultyModifier.nightmare)) return;

    setState(() => _isRedFlashing = true);
    HapticFeedback.heavyImpact();

    _redFlashTimer?.cancel();
    _redFlashTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _isRedFlashing = false);
    });
  }

  void _triggerBlackout() {
    if (!mounted) return;
    if (!_config.modifiers.contains(DifficultyModifier.blackout) &&
        !_config.modifiers.contains(DifficultyModifier.nightmare)) return;

    setState(() => _isBlackout = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isBlackout = false);
    });
  }

  void _triggerChaosShuffle() {
    if (!mounted) return;
    if (!_config.modifiers.contains(DifficultyModifier.chaosShuffle) &&
        !_config.modifiers.contains(DifficultyModifier.nightmare)) return;

    _chaosCounter++;
    if (_chaosCounter % 5 == 0) {
      final unmatched = _cards.where((CardModel card) => !card.isMatched)
          .toList();
      unmatched.shuffle();
      int unmatchedIdx = 0;
      setState(() {
        for (int i = 0; i < _cards.length; i++) {
          final card = _cards[i];
          if (!card.isMatched) {
            _cards[i] = unmatched[unmatchedIdx++];
          }
        }
      });
      HapticFeedback.heavyImpact();
    }
  }

  void _triggerShuffleOnFail() {
    if (!mounted) return;
    if (!_config.modifiers.contains(DifficultyModifier.shuffleOnFail) &&
        !_config.modifiers.contains(DifficultyModifier.nightmare)) return;

    final unmatched = _cards.where((CardModel card) => !card.isMatched)
        .toList();
    unmatched.shuffle();
    int unmatchedIdx = 0;
    setState(() {
      for (int i = 0; i < _cards.length; i++) {
        final card = _cards[i];
        if (!card.isMatched) {
          _cards[i] = unmatched[unmatchedIdx++];
        }
      }
    });
  }

  void _rotateGrid() {
    if (!mounted) return;
    if (!_config.modifiers.contains(DifficultyModifier.rotatingGrid) &&
        !_config.modifiers.contains(DifficultyModifier.nightmare)) return;

    setState(() {
      _gridRotation += math.pi / 2;
    });
  }

  String get _timeString {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _timeLeftString {
    if (_timeLimit == null) return _timeString;
    final left = _timeLimit! - _seconds;
    final m = (left ~/ 60).toString().padLeft(2, '0');
    final s = (left % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onCardTap(int index) async {
    if (_isProcessing) return;
    if (_isRedFlashing) return;
    if (_isBlackout) return;
    if (_isGameOver) return;
    if (_cards[index].isFlipped || _cards[index].isMatched) return;

    HapticFeedback.lightImpact();

    setState(() {
      _cards[index] = _cards[index].copyWith(isFlipped: true);
    });

    if (_firstIndex == null) {
      _firstIndex = index;
      _startSpeedTimer();
      return;
    }

    _secondIndex = index;
    _isProcessing = true;
    _speedTimer?.cancel();
    _moves++;

    final first = _cards[_firstIndex!];
    final second = _cards[_secondIndex!];

    if (first.emoji == second.emoji) {
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;
      setState(() {
        if (_config.modifiers.contains(DifficultyModifier.invisibleMatch) ||
            _config.modifiers.contains(DifficultyModifier.nightmare)) {
          _cards[_firstIndex!] = first.copyWith(
            isMatched: true,
            color: Colors.transparent,
          );
          _cards[_secondIndex!] = second.copyWith(
            isMatched: true,
            color: Colors.transparent,
          );
        } else {
          _cards[_firstIndex!] = first.copyWith(isMatched: true);
          _cards[_secondIndex!] = second.copyWith(isMatched: true);
        }
        _matches++;
      });

      _firstIndex = null;
      _secondIndex = null;
      _isProcessing = false;

      _triggerBlackout();

      if (_matches == _config.pairCount) {
        _timer?.cancel();
        _speedTimer?.cancel();

        // SAUVEGARDE PROGRESSION
        final gamesProvider = Provider.of<GamesProvider>(context, listen: false);
        gamesProvider.saveMemoryProgress(_currentLevel);

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) _showVictoryDialog();
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;
      _shakeController.forward().then((_) => _shakeController.reverse());

      setState(() {
        _cards[_firstIndex!] = first.copyWith(isFlipped: false);
        _cards[_secondIndex!] = second.copyWith(isFlipped: false);
      });

      _triggerRedFlash();
      _triggerShuffleOnFail();
      _triggerChaosShuffle();
      _rotateGrid();

      _firstIndex = null;
      _secondIndex = null;
      _isProcessing = false;
    }
  }

  void _gameOver(String reason) {
    _timer?.cancel();
    _speedTimer?.cancel();
    setState(() => _isGameOver = true);

    // SAUVEGARDE : niveau atteint (moins 1 car échec)
    final gamesProvider = Provider.of<GamesProvider>(context, listen: false);
    if (_currentLevel > 1) {
      gamesProvider.saveMemoryProgress(_currentLevel - 1);
    }

    _showGameOverDialog(reason);
  }

  void _showGameOverDialog(String reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => _GameOverDialog(
        reason: reason,
        level: _currentLevel,
        moves: _moves,
        time: _timeString,
        onRestart: () {
          Navigator.pop(context);
          _initLevel();
        },
        onMenu: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => _VictoryDialog(
        level: _currentLevel,
        moves: _moves,
        time: _timeString,
        onNext: () {
          Navigator.pop(context);
          if (_currentLevel < 50) {
            setState(() => _currentLevel++);
            _initLevel();
          } else {
            _showLegendaryDialog();
          }
        },
        onRestart: () {
          Navigator.pop(context);
          _initLevel();
        },
      ),
    );
  }

  void _showLegendaryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: AppGradients.matteGold,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 60),
              const SizedBox(height: 20),
              const Text(
                'LÉGENDAIRE !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tu as terminé les 50 niveaux !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'MENU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.matteGold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLevelSelector() {
    final gamesProvider = Provider.of<GamesProvider>(context, listen: false);
    final maxLevel = gamesProvider.memoryMaxLevel;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'CHOISIR UN NIVEAU',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Niveau max atteint: $maxLevel',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 50,
                itemBuilder: (context, index) {
                  final level = index + 1;
                  final isUnlocked = level <= maxLevel;
                  final isCurrent = level == _currentLevel;

                  return GestureDetector(
                    onTap: isUnlocked
                        ? () {
                            Navigator.pop(context);
                            setState(() => _currentLevel = level);
                            _initLevel();
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? (isCurrent
                                ? AppColors.royalBlue
                                : AppColors.darkSurface)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isUnlocked
                              ? (isCurrent
                                  ? AppColors.royalBlue
                                  : AppColors.darkBorder)
                              : Colors.white.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isUnlocked
                            ? Text(
                                '$level',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isCurrent
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.8),
                                ),
                              )
                            : Icon(
                                Icons.lock,
                                color: Colors.white.withOpacity(0.2),
                                size: 16,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final safeWidth = size.width - padding.horizontal - 32;
    final cardSize = (safeWidth / _config.gridCols).clamp(50.0, 80.0);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                _buildHeader(),
                const SizedBox(height: 8),
                _buildModifierBar(),
                const SizedBox(height: 12),
                if (_config.hasSpeedRun) _buildSpeedBar(),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildGrid(cardSize),
                ),
                const SizedBox(height: 12),
                _buildLevelInfo(),
                const SizedBox(height: 12),
              ],
            ),
            if (_isRedFlashing) _buildRedFlashOverlay(),
            if (_isBlackout) _buildBlackoutOverlay(),
            if (_config.hasSpeedRun && _speedProgress < 0.3)
              _buildSpeedWarning(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppGradients.royalBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppShadows.colored(AppColors.royalBlue, 0.3)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _showLevelSelector,
                child: Row(
                  children: [
                    Text(
                      'NIVEAU $_currentLevel',
                      style: AppTextStyles.scoreLarge.copyWith(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _config.description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (_config.hasTimeLimit)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _timeLimit != null && _timeLimit! - _seconds <= 10
                        ? AppColors.error.withOpacity(0.3)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: _timeLimit != null && _timeLimit! - _seconds <= 10
                            ? AppColors.error
                            : Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _timeLeftString,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _timeLimit != null && _timeLimit! - _seconds <= 10
                              ? AppColors.error
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$_moves',
                      style: AppTextStyles.scoreMedium.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModifierBar() {
    if (_config.modifiers.isEmpty ||
        _config.modifiers.first == DifficultyModifier.none) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: _config.modifiers.map((m) {
          return _ModifierBadge(
            icon: _modifierIcon(m),
            label: _modifierLabel(m),
            color: _modifierColor(m),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpeedBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: _speedProgress.clamp(0.0, 1.0),
          backgroundColor: AppColors.darkBorder,
          valueColor: AlwaysStoppedAnimation(
            _speedProgress > 0.5
                ? AppColors.success
                : _speedProgress > 0.2
                    ? AppColors.warning
                    : AppColors.error,
          ),
          minHeight: 6,
        ),
      ),
    );
  }

  Widget _buildGrid(double cardSize) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(_gridRotation),
        child: Transform(
          alignment: Alignment.center,
          transform: _isMirror
              ? (Matrix4.identity()..scale(-1.0, 1.0, 1.0))
              : Matrix4.identity(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: cardSize * _config.gridCols + 10 * (_config.gridCols - 1),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _config.gridCols,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) => _buildCard(index, cardSize),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index, double size) {
    final card = _cards[index];
    final isFlipped = card.isFlipped || card.isMatched;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final shake = math.sin(_shakeController.value * math.pi * 8) * 4;
        return Transform.translate(
          offset: Offset(shake, 0),
          child: GestureDetector(
            onTap: () => _onCardTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(isFlipped ? 3.14159 : 0),
              transformAlignment: Alignment.center,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: isFlipped
                      ? (card.color == Colors.transparent
                          ? AppColors.darkSurface
                          : card.color)
                      : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(14),
                  border: card.isMatched && card.color == Colors.transparent
                      ? Border.all(
                          color: AppColors.darkBorder,
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isFlipped && card.color != Colors.transparent
                          ? card.color.withOpacity(0.4)
                          : Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: isFlipped
                      ? card.color == Colors.transparent
                          ? Icon(
                              Icons.check_circle,
                              color: AppColors.darkBorder,
                              size: size * 0.4,
                            )
                          : Text(
                              card.emoji,
                              style: TextStyle(fontSize: size * 0.5),
                            )
                      : Icon(
                          Icons.question_mark_rounded,
                          color: const Color(0xFF555555),
                          size: size * 0.35,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoItem(label: 'Paires', value: '$_matches/${_config.pairCount}'),
          Container(
            width: 1,
            height: 30,
            color: AppColors.darkBorder,
          ),
          _InfoItem(
            label: 'Grille',
            value: '${_config.gridCols}x${_config.gridRows}',
          ),
          Container(
            width: 1,
            height: 30,
            color: AppColors.darkBorder,
          ),
          _InfoItem(label: 'Temps', value: _timeString),
        ],
      ),
    );
  }

  Widget _buildRedFlashOverlay() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: AppColors.error.withOpacity(0.15),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'FLASH ROUGE !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlackoutOverlay() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          '👁️',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildSpeedWarning() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '⚡ VITE !',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  IconData _modifierIcon(DifficultyModifier m) {
    switch (m) {
      case DifficultyModifier.timeLimit:
        return Icons.timer;
      case DifficultyModifier.shuffleOnFail:
        return Icons.shuffle;
      case DifficultyModifier.redFlash:
        return Icons.warning;
      case DifficultyModifier.invisibleMatch:
        return Icons.visibility_off;
      case DifficultyModifier.rotatingGrid:
        return Icons.rotate_right;
      case DifficultyModifier.mirrorMode:
        return Icons.flip;
      case DifficultyModifier.speedRun:
        return Icons.bolt;
      case DifficultyModifier.blackout:
        return Icons.dark_mode;
      case DifficultyModifier.chaosShuffle:
        return Icons.auto_fix_high;
      case DifficultyModifier.nightmare:
        return Icons.local_fire_department;
      default:
        return Icons.circle;
    }
  }

  String _modifierLabel(DifficultyModifier m) {
    switch (m) {
      case DifficultyModifier.timeLimit:
        return 'TIMER';
      case DifficultyModifier.shuffleOnFail:
        return 'SHUFFLE';
      case DifficultyModifier.redFlash:
        return 'FLASH';
      case DifficultyModifier.invisibleMatch:
        return 'INVISIBLE';
      case DifficultyModifier.rotatingGrid:
        return 'ROTATION';
      case DifficultyModifier.mirrorMode:
        return 'MIROIR';
      case DifficultyModifier.speedRun:
        return 'SPEED';
      case DifficultyModifier.blackout:
        return 'BLACKOUT';
      case DifficultyModifier.chaosShuffle:
        return 'CHAOS';
      case DifficultyModifier.nightmare:
        return 'NIGHTMARE';
      default:
        return '';
    }
  }

  Color _modifierColor(DifficultyModifier m) {
    switch (m) {
      case DifficultyModifier.timeLimit:
        return Colors.blue;
      case DifficultyModifier.shuffleOnFail:
        return Colors.purple;
      case DifficultyModifier.redFlash:
        return AppColors.error;
      case DifficultyModifier.invisibleMatch:
        return Colors.grey;
      case DifficultyModifier.rotatingGrid:
        return Colors.orange;
      case DifficultyModifier.mirrorMode:
        return Colors.cyan;
      case DifficultyModifier.speedRun:
        return Colors.yellow;
      case DifficultyModifier.blackout:
        return Colors.black;
      case DifficultyModifier.chaosShuffle:
        return Colors.pink;
      case DifficultyModifier.nightmare:
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }
}

class _ModifierBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ModifierBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _VictoryDialog extends StatelessWidget {
  final int level;
  final int moves;
  final String time;
  final VoidCallback onNext;
  final VoidCallback onRestart;

  const _VictoryDialog({
    required this.level,
    required this.moves,
    required this.time,
    required this.onNext,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.darkBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withOpacity(0.2),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppGradients.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.celebration_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'NIVEAU $level TERMINÉ !',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toutes les paires trouvées',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultBadge(
                  icon: Icons.touch_app_outlined,
                  label: 'Coups',
                  value: '$moves',
                ),
                const SizedBox(width: 16),
                _ResultBadge(
                  icon: Icons.timer_outlined,
                  label: 'Temps',
                  value: time,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onRestart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.darkBorder,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'REJOUER',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onNext,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: AppGradients.royalBlue,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.royalBlue.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'SUIVANT ➜',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GameOverDialog extends StatelessWidget {
  final String reason;
  final int level;
  final int moves;
  final String time;
  final VoidCallback onRestart;
  final VoidCallback onMenu;

  const _GameOverDialog({
    required this.reason,
    required this.level,
    required this.moves,
    required this.time,
    required this.onRestart,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              reason,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Niveau $level échoué',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultBadge(
                  icon: Icons.touch_app_outlined,
                  label: 'Coups',
                  value: '$moves',
                ),
                const SizedBox(width: 16),
                _ResultBadge(
                  icon: Icons.timer_outlined,
                  label: 'Temps',
                  value: time,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onMenu,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.darkBorder,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          'MENU',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onRestart,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: AppGradients.error,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'RÉESSAYER',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ResultBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF666666), size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}