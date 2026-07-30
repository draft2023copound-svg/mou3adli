import 'block.dart';
import 'piece.dart';

class Board {
  final int rows, cols;
  late List<List<Block?>> grid;

  Board({
    this.rows = 8,
    this.cols = 8,
  }) {
    _initializeGrid();
  }

  void _initializeGrid() {
    grid = List.generate(
      rows,
      (r) => List.generate(
        cols,
        (c) => null,
      ),
    );
  }

  Block? cellAt(int row, int col) {
    if (!_isInBounds(row, col)) return null;
    return grid[row][col];
  }

  bool _isInBounds(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < cols;
  }

  bool isEmpty(int row, int col) {
    return _isInBounds(row, col) && grid[row][col] == null;
  }

  bool isOccupied(int row, int col) {
    return _isInBounds(row, col) && grid[row][col] != null;
  }

  bool canPlace(Piece piece, int targetRow, int targetCol) {
    for (int r = 0; r < piece.height; r++) {
      for (int c = 0; c < piece.width; c++) {
        if (piece.matrix[r][c] == 1) {
          final int boardRow = targetRow + r;
          final int boardCol = targetCol + c;

          if (!_isInBounds(boardRow, boardCol)) {
            return false;
          }
          if (grid[boardRow][boardCol] != null) {
            return false;
          }
        }
      }
    }
    return true;
  }

  bool place(Piece piece, int targetRow, int targetCol) {
    if (!canPlace(piece, targetRow, targetCol)) {
      return false;
    }

    for (int r = 0; r < piece.height; r++) {
      for (int c = 0; c < piece.width; c++) {
        if (piece.matrix[r][c] == 1) {
          final int boardRow = targetRow + r;
          final int boardCol = targetCol + c;
          grid[boardRow][boardCol] = Block.autoId(
            row: boardRow,
            col: boardCol,
            color: piece.color,
          );
        }
      }
    }
    return true;
  }

  // --- SUPPRESSION DE LA MÉTHODE placeAtCurrentPosition ---
  // Elle utilisait piece.offsetRow et piece.offsetCol qui n'existent pas.

  List<int> getCompleteRows() {
    final List<int> completeRows = [];
    for (int r = 0; r < rows; r++) {
      bool isComplete = true;
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] == null) {
          isComplete = false;
          break;
        }
      }
      if (isComplete) completeRows.add(r);
    }
    return completeRows;
  }

  List<int> getCompleteColumns() {
    final List<int> completeCols = [];
    for (int c = 0; c < cols; c++) {
      bool isComplete = true;
      for (int r = 0; r < rows; r++) {
        if (grid[r][c] == null) {
          isComplete = false;
          break;
        }
      }
      if (isComplete) completeCols.add(c);
    }
    return completeCols;
  }

  void clearRow(int row) {
    if (!_isInBounds(row, 0)) return;
    for (int c = 0; c < cols; c++) {
      grid[row][c] = null;
    }
  }

  void clearColumn(int col) {
    if (!_isInBounds(0, col)) return;
    for (int r = 0; r < rows; r++) {
      grid[r][col] = null;
    }
  }

  int clearLinesAndColumns({
    required List<int> rowsToClear,
    required List<int> colsToClear,
  }) {
    int clearedCells = 0;

    final Set<(int, int)> positionsToClear = {};

    for (final row in rowsToClear) {
      for (int c = 0; c < cols; c++) {
        if (grid[row][c] != null) {
          positionsToClear.add((row, c));
        }
      }
    }

    for (final col in colsToClear) {
      for (int r = 0; r < rows; r++) {
        if (grid[r][col] != null) {
          positionsToClear.add((r, col));
        }
      }
    }

    for (final (r, c) in positionsToClear) {
      grid[r][c] = null;
      clearedCells++;
    }

    return clearedCells;
  }

  bool isPerfectClear() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] != null) return false;
      }
    }
    return true;
  }

  int get occupiedCellCount {
    int count = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] != null) count++;
      }
    }
    return count;
  }

  bool canPlaceAnyPiece(List<Piece> pieces) {
    for (final piece in pieces) {
      for (int r = 0; r <= rows - piece.height; r++) {
        for (int c = 0; c <= cols - piece.width; c++) {
          if (canPlace(piece, r, c)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  List<(int row, int col)> getValidPositionsForPiece(Piece piece) {
    final List<(int, int)> positions = [];
    for (int r = 0; r <= rows - piece.height; r++) {
      for (int c = 0; c <= cols - piece.width; c++) {
        if (canPlace(piece, r, c)) {
          positions.add((r, c));
        }
      }
    }
    return positions;
  }

  int countValidPositionsForPiece(Piece piece) {
    int count = 0;
    for (int r = 0; r <= rows - piece.height; r++) {
      for (int c = 0; c <= cols - piece.width; c++) {
        if (canPlace(piece, r, c)) count++;
      }
    }
    return count;
  }

  Board copy() {
    final newBoard = Board(rows: rows, cols: cols);
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c] != null) {
          newBoard.grid[r][c] = grid[r][c]!.copyWith();
        }
      }
    }
    return newBoard;
  }

  void clear() {
    _initializeGrid();
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
      'cols': cols,
      'grid': grid.map((row) {
        return row.map((block) => block?.toJson()).toList();
      }).toList(),
    };
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    final board = Board(
      rows: json['rows'] as int,
      cols: json['cols'] as int,
    );
    final gridData = json['grid'] as List<dynamic>;
    for (int r = 0; r < board.rows; r++) {
      final rowData = gridData[r] as List<dynamic>;
      for (int c = 0; c < board.cols; c++) {
        final cellData = rowData[c];
        if (cellData != null) {
          board.grid[r][c] = Block.fromJson(cellData as Map<String, dynamic>);
        }
      }
    }
    return board;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Board) return false;
    if (other.rows != rows || other.cols != cols) return false;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (other.grid[r][c] != grid[r][c]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        rows,
        cols,
        Object.hashAll(grid.expand((row) => row)),
      );

  @override
  String toString() => 'Board($rows x $cols, occupied: $occupiedCellCount)';
}