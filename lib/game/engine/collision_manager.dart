import '../models/board.dart'; import '../models/piece.dart';

class CollisionManager {
  const CollisionManager();
  bool canPlace(Board board, Piece piece, int targetRow, int targetCol) => board.canPlace(piece, targetRow, targetCol);
  bool canPlaceAtCurrentPosition(Board board, Piece piece) => board.canPlace(piece, piece.offsetRow, piece.offsetCol);
  bool hasAnyValidPlacement(Board board, List<Piece> pieces) => board.canPlaceAnyPiece(pieces);
  List<(int row, int col)> getValidPositions(Board board, Piece piece) => board.getValidPositionsForPiece(piece);
  int countValidPositions(Board board, Piece piece) => board.countValidPositionsForPiece(piece);
}