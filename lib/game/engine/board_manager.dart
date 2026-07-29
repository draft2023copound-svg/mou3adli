import '../models/board.dart'; import '../models/piece.dart';

class PlacementResult {
  final bool success; final List<int> clearedRows, clearedCols; final int cellsCleared; final bool perfectClear;
  const PlacementResult({required this.success, this.clearedRows = const [], this.clearedCols = const [], this.cellsCleared = 0, this.perfectClear = false});
  static const PlacementResult failure = PlacementResult(success: false);
}

class BoardManager {
  final Board board;
  BoardManager({Board? board}) : board = board ?? Board();

  PlacementResult placePiece(Piece piece, int row, int col) {
    if (!board.canPlace(piece, row, col)) return PlacementResult.failure;
    board.place(piece, row, col);
    final rows = board.getCompleteRows(), cols = board.getCompleteColumns();
    int cellsCleared = 0; bool perfectClear = false;
    if (rows.isNotEmpty || cols.isNotEmpty) {
      cellsCleared = board.clearLinesAndColumns(rowsToClear: rows, colsToClear: cols);
      perfectClear = board.isPerfectClear();
    }
    return PlacementResult(success: true, clearedRows: List.unmodifiable(rows), clearedCols: List.unmodifiable(cols), cellsCleared: cellsCleared, perfectClear: perfectClear);
  }

  bool canPlace(Piece piece, int row, int col) => board.canPlace(piece, row, col);
  List<(int row, int col)> getValidPositions(Piece piece) => board.getValidPositionsForPiece(piece);
  bool hasValidMove(List<Piece> pieces) => board.canPlaceAnyPiece(pieces);
  void reset() => board.clear();
  Board copyBoard() => board.copy();
}