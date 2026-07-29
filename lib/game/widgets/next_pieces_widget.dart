import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../utils/constants.dart';
import 'piece_widget.dart';

class NextPiecesWidget extends StatelessWidget {
  final List<Piece> pieces;
  final double cellSize;
  final Function(int index, Piece piece)? onPieceDragStarted;
  final Function(int index, Piece piece)? onPieceDragEnded;
  final int? selectedIndex;

  const NextPiecesWidget({
    super.key,
    required this.pieces,
    required this.cellSize,
    this.onPieceDragStarted,
    this.onPieceDragEnded,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: kBoardBackgroundColor.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: kCellBorderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(pieces.length, (index) {
          final piece = pieces[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: onPieceDragStarted != null ? () => onPieceDragStarted!(index, piece) : null,
            child: AnimatedContainer(
              duration: kPulseDuration,
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? piece.color.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: piece.color.withOpacity(0.5), width: 2)
                    : null,
              ),
              child: PieceWidget(
                piece: piece,
                cellSize: cellSize,
                isDraggable: true,
                onDragStarted: () => onPieceDragStarted?.call(index, piece),
                onDragEnded: () => onPieceDragEnded?.call(index, piece),
              ),
            ),
          );
        }),
      ),
    );
  }
}