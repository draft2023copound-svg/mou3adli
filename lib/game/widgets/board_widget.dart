import 'package:flutter/material.dart';
import '../models/board.dart';
import '../models/piece.dart';
import '../utils/constants.dart';
import 'cell_widget.dart';

class BoardWidget extends StatefulWidget {
  final Board board;
  final double cellSize;
  final Piece? ghostPiece;
  final Function(int row, int col, Piece piece)? onPieceDropped;
  final VoidCallback? onDragLeave;

  const BoardWidget({
    super.key,
    required this.board,
    required this.cellSize,
    this.ghostPiece,
    this.onPieceDropped,
    this.onDragLeave,
  });

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<Piece>(
      onWillAcceptWithDetails: (details) {
        return true;
      },
      onAcceptWithDetails: (details) {
        // La logique de drop est maintenant gérée par le parent (BlastScreen)
        // pour éviter les problèmes de conversion de coordonnées.
      },
      onLeave: (_) {
        widget.onDragLeave?.call();
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kBoardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              // CORRECTION : Remplacer withValues par withOpacity
              color: candidateData.isNotEmpty ? kAccentColor.withOpacity(0.5) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(kGridRows, (r) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(kGridCols, (c) {
                  // Le ghost est géré par la logique du parent (BlastScreen)
                  final bool isGhost = false; 
                  return Padding(
                    padding: const EdgeInsets.all(kCellSpacing / 2),
                    child: CellWidget(
                      block: widget.board.cellAt(r, c),
                      size: widget.cellSize,
                      isGhost: isGhost,
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}