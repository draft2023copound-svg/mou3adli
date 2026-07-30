import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/board.dart';
import '../models/piece.dart';
import '../engine/piece_library.dart';
import '../engine/score_manager.dart';
import '../utils/constants.dart';

class BlastScreen extends StatefulWidget {
  const BlastScreen({super.key});

  @override
  State<BlastScreen> createState() => _BlastScreenState();
}

class _BlastScreenState extends State<BlastScreen>
    with TickerProviderStateMixin {
  final Board _board = Board();
  final ScoreManager _scoreManager = ScoreManager();
  List<Piece> _pieces = [];

  // Drag & Drop state
  Piece? _draggedPiece;
  int _draggedIndex = -1;
  (int, int)? _ghostPos;

  // Animations
  final Map<String, AnimationController> _explosionControllers = {};
  final Set<(int, int)> _explodingCells = {};
  bool _isClearing = false;

  // Combo animation
  AnimationController? _comboController;
  Animation<double>? _comboAnimation;
  int _displayedCombo = 0;

  @override
  void initState() {
    super.initState();
    _generatePieces();
  }

  @override
  void dispose() {
    for (final ctrl in _explosionControllers.values) {
      ctrl.dispose();
    }
    _comboController?.dispose();
    super.dispose();
  }

  void _generatePieces() {
    setState(() {
      _pieces = PieceLibrary.getRandomPieces(kPiecePoolSize);
    });
  }

  Future<void> _placePiece(int row, int col) async {
    if (_draggedPiece == null || _isClearing) return;

    if (_board.place(_draggedPiece!, row, col)) {
      _scoreManager.addPlacementScore(_draggedPiece!.blockCount);

      final rows = _board.getCompleteRows();
      final cols = _board.getCompleteColumns();

      if (rows.isNotEmpty || cols.isNotEmpty) {
        setState(() {
          _isClearing = true;
          _pieces.removeAt(_draggedIndex);
          _draggedPiece = null;
          _ghostPos = null;
        });

        // Mark exploding cells
        final Set<(int, int)> exploding = {};
        for (final r in rows) {
          for (int c = 0; c < kGridCols; c++) {
            exploding.add((r, c));
          }
        }
        for (final c in cols) {
          for (int r = 0; r < kGridRows; r++) {
            exploding.add((r, c));
          }
        }

        setState(() {
          _explodingCells.addAll(exploding);
        });

        // Animate explosions
        await _animateExplosions(exploding);

        // Clear lines and score
        _board.clearLinesAndColumns(
          rowsToClear: rows,
          colsToClear: cols,
        );

        _scoreManager.processClear(
          lines: rows.length,
          cols: cols.length,
          perfect: _board.isPerfectClear(),
        );

        setState(() {
          _explodingCells.clear();
          _isClearing = false;
        });

        if (_scoreManager.combo > 1) {
          _showComboAnimation(_scoreManager.combo);
        }
      } else {
        setState(() {
          _pieces.removeAt(_draggedIndex);
          _draggedPiece = null;
          _ghostPos = null;
        });
      }

      // Generate new pieces if pool empty
      if (_pieces.isEmpty) {
        await Future.delayed(kNewPiecesDelay);
        _generatePieces();
      }

      // Check game over
      if (!_board.canPlaceAnyPiece(_pieces)) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) _showGameOver();
      }
    }
  }

  Future<void> _animateExplosions(Set<(int, int)> cells) async {
    final List<Future<void>> futures = [];

    for (final (r, c) in cells) {
      final key = '${r}_$c';
      final ctrl = AnimationController(
        vsync: this,
        duration: kExplosionDuration,
      );
      _explosionControllers[key] = ctrl;
      futures.add(ctrl.forward().then((_) {
        ctrl.dispose();
        _explosionControllers.remove(key);
      }));
    }

    await Future.wait(futures);
  }

  void _showComboAnimation(int combo) {
    _comboController?.dispose();
    _comboController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _comboAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _comboController!, curve: Curves.elasticOut),
    );

    setState(() {
      _displayedCombo = combo;
    });

    _comboController!.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _displayedCombo = 0;
          });
        }
      });
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => _GameOverDialog(
        score: _scoreManager.score,
        bestScore: _scoreManager.bestScore,
        onRestart: () {
          Navigator.pop(context);
          _restart();
        },
      ),
    );
  }

  void _restart() {
    setState(() {
      _board.clear();
      _scoreManager.reset();
      _pieces.clear();
      _draggedPiece = null;
      _ghostPos = null;
      _explodingCells.clear();
      _isClearing = false;
      _displayedCombo = 0;
    });
    _generatePieces();
  }

  void _updateGhostPosition(Offset localPosition, double cellSize) {
    if (_draggedPiece == null) return;

    final col = (localPosition.dx / (cellSize + kCellSpacing)).floor();
    final row = (localPosition.dy / (cellSize + kCellSpacing)).floor();

    final targetRow = row - (_draggedPiece!.height ~/ 2);
    final targetCol = col - (_draggedPiece!.width ~/ 2);

    if (_board.canPlace(_draggedPiece!, targetRow, targetCol)) {
      setState(() => _ghostPos = (targetRow, targetCol));
    } else {
      setState(() => _ghostPos = null);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 800;

    final double gridSize = isDesktop
        ? 520
        : math.min(screenSize.width - 32, screenSize.height * 0.5);
    final double cellSize =
        (gridSize - (kGridCols - 1) * kCellSpacing) / kGridCols;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildGameGrid(cellSize),
                const SizedBox(height: 8),
                if (_displayedCombo > 1) _buildComboBadge(),
                const Spacer(),
                _buildPiecePool(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: kRoyalBlueGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kRoyalBlueGradient[0].withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events,
                        color: kMatteGold, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'SCORE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedBuilder(
                  animation: _scoreManager,
                  builder: (context, _) {
                    return Text(
                      '${_scoreManager.score}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Best Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: kMatteGold.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'BEST',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: kMatteGoldLight,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedBuilder(
                  animation: _scoreManager,
                  builder: (context, _) {
                    return Text(
                      '${_scoreManager.bestScore}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Restart
          GestureDetector(
            onTap: _restart,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // GAME GRID
  // ═══════════════════════════════════════════════════════════

  Widget _buildGameGrid(double cellSize) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBoardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kCellBorderColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth - 24;
          final double computedCellSize =
              (availableWidth - (kGridCols - 1) * kCellSpacing) / kGridCols;

          return SizedBox(
            width: availableWidth,
            height: availableWidth,
            child: DragTarget<Piece>(
              onWillAcceptWithDetails: (details) {
                setState(() {
                  _draggedPiece = details.data;
                });
                return true;
              },
              onAcceptWithDetails: (details) {},
              onLeave: (_) {
                setState(() => _ghostPos = null);
              },
              builder: (context, candidates, rejected) {
                return GestureDetector(
                  onPanUpdate: (details) {
                    if (_draggedPiece != null) {
                      _updateGhostPosition(
                        details.localPosition,
                        computedCellSize,
                      );
                    }
                  },
                  onPanEnd: (_) {
                    if (_ghostPos != null && _draggedPiece != null) {
                      _placePiece(_ghostPos!.$1, _ghostPos!.$2);
                    } else {
                      setState(() {
                        _draggedPiece = null;
                        _ghostPos = null;
                      });
                    }
                  },
                  onTapUp: (details) {
                    if (_draggedPiece != null) {
                      _updateGhostPosition(
                        details.localPosition,
                        computedCellSize,
                      );
                      if (_ghostPos != null) {
                        _placePiece(_ghostPos!.$1, _ghostPos!.$2);
                      } else {
                        setState(() {
                          _draggedPiece = null;
                          _ghostPos = null;
                        });
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(kGridRows, (r) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(kGridCols, (c) {
                          return _buildCell(r, c, computedCellSize);
                        }),
                      );
                    }),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCell(int r, int c, double cellSize) {
    final block = _board.grid[r][c];
    final bool isGhost = _ghostPos != null &&
        r >= _ghostPos!.$1 &&
        r < _ghostPos!.$1 + (_draggedPiece?.height ?? 0) &&
        c >= _ghostPos!.$2 &&
        c < _ghostPos!.$2 + (_draggedPiece?.width ?? 0) &&
        _draggedPiece!.matrix[r - _ghostPos!.$1][c - _ghostPos!.$2] == 1;

    final bool isExploding = _explodingCells.contains((r, c));

    return AnimatedContainer(
      duration: kGhostFadeDuration,
      width: cellSize,
      height: cellSize,
      margin: const EdgeInsets.all(kCellSpacing / 2),
      decoration: BoxDecoration(
        color: isGhost
            ? _draggedPiece!.color.withOpacity(0.35)
            : (block?.color ?? kEmptyCellColor),
        borderRadius: BorderRadius.circular(kCellRadius),
        border: isGhost
            ? Border.all(
                color: _draggedPiece!.color.withOpacity(0.6),
                width: 2,
              )
            : null,
        boxShadow: block != null && !isExploding
            ? [
                BoxShadow(
                  color: block.color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isExploding
          ? _buildExplosionEffect(r, c, cellSize)
          : block != null
              ? Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(kCellRadius - 2),
                  ),
                )
              : null,
    );
  }

  Widget _buildExplosionEffect(int r, int c, double cellSize) {
    final key = '${r}_$c';
    final ctrl = _explosionControllers[key];

    if (ctrl == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, child) {
        final progress = ctrl.value;
        return Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(1 - progress),
            borderRadius: BorderRadius.circular(kCellRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.6 * (1 - progress)),
                blurRadius: 12 * progress,
                spreadRadius: 4 * progress,
              ),
            ],
          ),
          child: Center(
            child: Transform.scale(
              scale: 1 + progress * 0.5,
              child: Opacity(
                opacity: 1 - progress,
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.amber,
                  size: cellSize * 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // COMBO BADGE
  // ═══════════════════════════════════════════════════════════

  Widget _buildComboBadge() {
    return AnimatedBuilder(
      animation: _comboController!,
      builder: (context, child) {
        return Transform.scale(
          scale: _comboAnimation!.value,
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.white, size: 20),
                const SizedBox(width: 6),
                Text(
                  'COMBO x$_displayedCombo',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // PIECE POOL
  // ═══════════════════════════════════════════════════════════

  Widget _buildPiecePool() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: kBoardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _pieces.asMap().entries.map((entry) {
          final index = entry.key;
          final piece = entry.value;
          final bool canPlace =
              _board.countValidPositionsForPiece(piece) > 0;

          return Draggable<Piece>(
            data: piece,
            feedback: Material(
              color: Colors.transparent,
              elevation: 0,
              child: Opacity(
                opacity: 0.85,
                child: _buildPieceWidget(piece, 36),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.2,
              child: _buildPieceWidget(piece, 36),
            ),
            onDragStarted: () {
              HapticFeedback.lightImpact();
              setState(() {
                _draggedPiece = piece;
                _draggedIndex = index;
              });
            },
            onDragEnd: (details) {
              if (!details.wasAccepted) {
                setState(() {
                  _draggedPiece = null;
                  _ghostPos = null;
                });
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: canPlace
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: canPlace
                      ? kCellBorderColor.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: canPlace
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: _buildPieceWidget(piece, 32),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieceWidget(Piece piece, double blockSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(piece.height, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(piece.width, (c) {
            final isBlock = piece.matrix[r][c] == 1;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: blockSize,
              height: blockSize,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isBlock ? piece.color : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isBlock
                    ? [
                        BoxShadow(
                          color: piece.color.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: isBlock
                  ? Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  : null,
            );
          }),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GAME OVER DIALOG
// ═══════════════════════════════════════════════════════════

class _GameOverDialog extends StatelessWidget {
  final int score;
  final int bestScore;
  final VoidCallback onRestart;

  const _GameOverDialog({
    required this.score,
    required this.bestScore,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNewBest = score >= bestScore && score > 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isNewBest ? 'NOUVEAU RECORD !' : 'PARTIE TERMINÉE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isNewBest ? kMatteGoldDark : kPrimaryTextColor,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre score',
              style: TextStyle(
                fontSize: 13,
                color: kSecondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$score',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: kPrimaryTextColor,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: kBoardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: kMatteGold, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Meilleur: $bestScore',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kSecondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRestart,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: kRoyalBlueGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kRoyalBlueGradient[0].withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'REJOUER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}