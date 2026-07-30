import '../models/board.dart';
import '../models/piece.dart';

class CollisionManager {
  const CollisionManager();

  bool canPlace(Board board, Piece piece, int targetRow, int targetCol) {
    return board.canPlace(piece, targetRow, targetCol);
  }

  bool hasAnyValidPlacement(Board board, List<Piece> pieces) {
    return board.canPlaceAnyPiece(pieces);
  }

  List<(int row, int col)> getValidPositions(Board board, Piece piece) {
    return board.getValidPositionsForPiece(piece);
  }

  int countValidPositions(Board board, Piece piece) {
    return board.countValidPositionsForPiece(piece);
  }
}