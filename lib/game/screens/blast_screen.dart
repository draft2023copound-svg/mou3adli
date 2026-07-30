import 'package:flutter/material.dart';
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

class _BlastScreenState extends State<BlastScreen> {
  final Board _board = Board();
  final ScoreManager _scoreManager = ScoreManager();
  List<Piece> _pieces = [];

  Piece? _draggedPiece;
  int _draggedIndex = 0;
  (int, int)? _ghostPos;

  @override
  void initState() {
    super.initState();
    _generatePieces();
  }

  void _generatePieces() {
    setState(() {
      _pieces = PieceLibrary.getRandomPieces(kPiecePoolSize);
    });
  }

  void _placePiece(int row, int col) {
    if (_draggedPiece == null) return;

    if (_board.place(_draggedPiece!, row, col)) {
      _scoreManager.addPlacementScore(_draggedPiece!.blockCount);

      final rows = _board.getCompleteRows();
      final cols = _board.getCompleteColumns();

      if (rows.isNotEmpty || cols.isNotEmpty) {
        _scoreManager.processClear(
          lines: rows.length,
          cols: cols.length,
          perfect: _board.isPerfectClear(),
        );
        _board.clearLinesAndColumns(
          rowsToClear: rows,
          colsToClear: cols,
        );
      }

      setState(() {
        _pieces.removeAt(_draggedIndex);
        _draggedPiece = null;
        _ghostPos = null;
      });

      if (_pieces.isEmpty) {
        Future.delayed(kNewPiecesDelay, _generatePieces);
      } else if (!_board.canPlaceAnyPiece(_pieces)) {
        _showGameOver();
      }
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Game Over', style: TextStyle(fontWeight: FontWeight.bold, color: kAccentColor)),
        content: Text('Score: ${_scoreManager.score}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restart();
            },
            child: const Text('Rejouer', style: TextStyle(color: kAccentColor)),
          ),
        ],
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
    });
    _generatePieces();
  }

  void _onDragUpdate(int row, int col) {
    if (_draggedPiece == null) return;
    if (_board.canPlace(_draggedPiece!, row, col)) {
      setState(() => _ghostPos = (row, col));
    } else {
      setState(() => _ghostPos = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    children: [
                      const Text('SCORE', style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 2)),
                      Text('${_scoreManager.score}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.black),
                    onPressed: _restart,
                  ),
                ],
              ),
            ),

            // Board
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: DragTarget<Piece>(
                    onWillAcceptWithDetails: (details) {
                      _draggedPiece = details.data;
                      _draggedIndex = _pieces.indexOf(_draggedPiece!);
                      return true;
                    },
                    onAcceptWithDetails: (details) {
                      // Drop handled by child DropTarget
                    },
                    builder: (context, candidates, rejected) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(kGridRows, (r) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(kGridCols, (c) {
                              final isGhost = _ghostPos != null &&
                                  r >= _ghostPos!.$1 && r < _ghostPos!.$1 + (_draggedPiece?.height ?? 0) &&
                                  c >= _ghostPos!.$2 && c < _ghostPos!.$2 + (_draggedPiece?.width ?? 0) &&
                                  _draggedPiece!.matrix[r - _ghostPos!.$1][c - _ghostPos!.$2] == 1;
                              return GestureDetector(
                                onTap: () => _placePiece(r, c),
                                onPanUpdate: (details) {
                                  final dx = details.localPosition.dx / (kCellSize + kCellSpacing);
                                  final dy = details.localPosition.dy / (kCellSize + kCellSpacing);
                                  _onDragUpdate(dy.floor(), dx.floor());
                                },
                                child: Container(
                                  width: kCellSize,
                                  height: kCellSize,
                                  margin: const EdgeInsets.all(kCellSpacing / 2),
                                  decoration: BoxDecoration(
                                    // --- CORRECTION ICI ---
                                    color: isGhost 
                                        ? kGhostColor 
                                        : (_board.grid[r][c]?.color ?? kEmptyCellColor),
                                    borderRadius: BorderRadius.circular(kCellRadius),
                                    border: isGhost ? Border.all(color: Colors.black.withOpacity(0.3), width: 2) : null,
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Next Pieces
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _pieces.asMap().entries.map((entry) {
                  final index = entry.key;
                  final piece = entry.value;
                  return Draggable<Piece>(
                    data: piece,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: 0.8,
                        child: _buildPieceWidget(piece),
                      ),
                    ),
                    childWhenDragging: const SizedBox(width: 0, height: 0),
                    onDragStarted: () {
                      setState(() {
                        _draggedPiece = piece;
                        _draggedIndex = index;
                      });
                    },
                    onDragEnd: (_) {
                      setState(() {
                        _draggedPiece = null;
                        _ghostPos = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildPieceWidget(piece),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieceWidget(Piece piece) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(piece.height, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(piece.width, (c) {
            return Container(
              width: kCellSize * 0.6,
              height: kCellSize * 0.6,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: piece.matrix[r][c] == 1 ? piece.color : Colors.transparent,
                borderRadius: BorderRadius.circular(kCellRadius),
              ),
            );
          }),
        );
      }),
    );
  }
}