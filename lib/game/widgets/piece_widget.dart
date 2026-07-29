import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../models/block.dart'; // <-- IMPORT AJOUTÉ ICI
import '../utils/constants.dart';
import 'cell_widget.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  final double cellSize;
  final bool isDraggable;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnded;

  const PieceWidget({
    super.key,
    required this.piece,
    required this.cellSize,
    this.isDraggable = true,
    this.onDragStarted,
    this.onDragEnded,
  });

  @override
  Widget build(BuildContext context) {
    final widget = _buildPieceContent();
    if (!isDraggable) return widget;

    return GestureDetector(
      onVerticalDragUpdate: (details) {},
      child: Draggable<Piece>(
        data: piece,
        feedback: _buildDragFeedback(),
        childWhenDragging: Opacity(opacity: 0.3, child: widget),
        onDragStarted: onDragStarted,
        onDragEnd: (_) => onDragEnded?.call(),
        child: widget,
      ),
    );
  }

  Widget _buildPieceContent() {
    // On crée un faux bloc juste pour la couleur
    final fakeBlock = Block.autoId(row: 0, col: 0, color: piece.color);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(piece.height, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(piece.width, (c) {
            final isFilled = piece.matrix[r][c] == 1;
            
            if (isFilled) {
              return CellWidget(
                block: fakeBlock, // On passe la couleur ici
                size: cellSize,
                isGhost: false,
                isHighlighted: false,
                onTap: null,
              );
            } else {
              return Container(
                width: cellSize,
                height: cellSize,
                margin: const EdgeInsets.all(kCellSpacing / 2),
                child: const SizedBox.shrink(),
              );
            }
          }),
        );
      }),
    );
  }

  Widget _buildDragFeedback() {
    return Transform.scale(
      scale: 1.1,
      child: Opacity(
        opacity: 0.85,
        child: _buildPieceContent(),
      ),
    );
  }
}