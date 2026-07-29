import 'package:flutter/material.dart';
import '../animations/combo_animation.dart';
import '../engine/game_engine.dart';
import '../models/piece.dart';
import '../storage/save_manager.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../utils/helpers.dart';
import '../widgets/board_widget.dart';
import '../widgets/combo_widget.dart';
import '../widgets/next_pieces_widget.dart';
import '../widgets/score_card.dart';

class BlastScreen extends StatefulWidget {
  const BlastScreen({super.key});

  @override
  State<BlastScreen> createState() => _BlastScreenState();
}

class _BlastScreenState extends State<BlastScreen> with TickerProviderStateMixin {
  late GameEngine _engine;
  final SaveManager _saveManager = SaveManager();
  Piece? _draggedPiece;
  int? _draggedIndex;
  final List<Widget> _overlayAnimations = [];
  final GlobalKey _boardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _engine = GameEngine();
    _engine.eventNotifier.addListener(_onGameEvent);
    _initialize();
  }

  Future<void> _initialize() async {
    await _saveManager.initialize();
    final savedBest = _saveManager.loadBestScore();
    _engine.scoreManager.initializeBestScore(savedBest);

    final savedGame = _saveManager.loadGame();
    
    bool hasValidSave = false;
    if (savedGame != null) {
      hasValidSave = !savedGame.isGameOver;
    }

    if (hasValidSave) {
      _engine.restoreState(savedGame!);
    } else {
      _engine.startGame();
    }
    if (mounted) setState(() {});
  }

  void _onGameEvent() {
    final event = _engine.eventNotifier.value;
    if (event == null) return;

    switch (event.event) {
      case GameEvent.linesCleared:
      case GameEvent.columnsCleared:
      case GameEvent.doubleClear:
      case GameEvent.tripleClear:
        _showScoreAnimation(event);
        break;
      case GameEvent.combo:
        _showComboAnimation(event);
        break;
      case GameEvent.perfectClear:
        _showPerfectClearAnimation();
        break;
      case GameEvent.gameOver:
        _showGameOverDialog();
        break;
      default:
        break;
    }

    _autoSave();
    if (mounted) setState(() {});
  }

  void _showScoreAnimation(GameEventData event) {
    setState(() {
      _overlayAnimations.add(
        Positioned(
          top: context.screenHeight * 0.3,
          left: 0,
          right: 0,
          child: Center(
            child: ComboAnimation.score(
              event.score ?? 0,
              combo: event.combo,
              onComplete: () => _removeOverlayAnimation(0),
            ),
          ),
        ),
      );
    });
  }

  void _showComboAnimation(GameEventData event) {
    setState(() {
      _overlayAnimations.add(
        Positioned(
          top: context.screenHeight * 0.25,
          left: 0,
          right: 0,
          child: Center(
            child: ComboAnimation.score(
              event.score ?? 0,
              combo: event.combo,
            ),
          ),
        ),
      );
    });
  }

  void _showPerfectClearAnimation() {
    setState(() {
      _overlayAnimations.add(
        Positioned(
          top: context.screenHeight * 0.2,
          left: 0,
          right: 0,
          child: Center(
            child: ComboAnimation.perfectClear(),
          ),
        ),
      );
    });
  }

  void _removeOverlayAnimation(int index) {}

  Future<void> _autoSave() async {
    await _saveManager.saveGame(_engine.currentState);
    await _saveManager.saveBestScore(_engine.scoreManager.bestScore);
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: kBoardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'GAME OVER',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kAccentColor,
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: ${_engine.scoreManager.score.formatted}',
              style: const TextStyle(color: kPrimaryTextColor, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Best: ${_engine.scoreManager.bestScore.formatted}',
              style: const TextStyle(color: kSecondaryTextColor, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _engine.restart();
              setState(() {});
            },
            child: const Text('REJOUER', style: TextStyle(color: kAccentColor)),
          ),
        ],
      ),
    );
  }

  void _onPieceDragStarted(int index, Piece piece) {
    setState(() {
      _draggedPiece = piece;
      _draggedIndex = index;
    });
  }

  void _onPieceDragEnded(int index, Piece piece) {
    setState(() {
      _draggedPiece = null;
      _draggedIndex = null;
    });
  }

  void _onBoardDrop(int row, int col) {
    if (_draggedPiece == null || _draggedIndex == null) return;

    // CORRECTION WEB : Vérifier que la pièce ne dépasse pas les bords
    final piece = _draggedPiece!;
    if (row < 0 || col < 0) return;
    if (row + piece.height > kGridRows) return;
    if (col + piece.width > kGridCols) return;

    final success = _engine.placePiece(
      piece,
      row,
      col,
      pieceIndex: _draggedIndex,
    );

    if (success == true) {
      _draggedPiece = null;
      _draggedIndex = null;
    }
  }

  @override
  void dispose() {
    _engine.eventNotifier.removeListener(_onGameEvent);
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;
    final screenSize = MediaQuery.of(context).size;
    final cellSize = calculateCellSize(
      availableWidth: screenSize.width * (isLandscape ? 0.5 : 0.9),
      availableHeight: screenSize.height * (isLandscape ? 0.7 : 0.45),
      rows: kGridRows,
      cols: kGridCols,
      spacing: kCellSpacing,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A1A2E),
                    Color(0xFF0F0F23),
                  ],
                ),
              ),
            ),
            isLandscape
                ? Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildBoardSection(cellSize),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildSidePanel(cellSize),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildHeader(),
                      _buildBoardSection(cellSize),
                      const Spacer(),
                      _buildBottomPanel(cellSize),
                    ],
                  ),
            ..._overlayAnimations,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: kPrimaryTextColor),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          ScoreCard(
            score: _engine.scoreManager.score,
            bestScore: _engine.scoreManager.bestScore,
            combo: _engine.scoreManager.combo,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: kPrimaryTextColor),
            onPressed: () {
              _engine.restart();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBoardSection(double cellSize) {
    return Center(
      child: DragTarget<Piece>(
        onAcceptWithDetails: (details) {
          final RenderBox box = _boardKey.currentContext!.findRenderObject() as RenderBox;
          final localOffset = box.globalToLocal(details.offset);
          
          final effectiveCellSize = cellSize + kCellSpacing;
          final col = (localOffset.dx / effectiveCellSize).floor();
          final row = (localOffset.dy / effectiveCellSize).floor();
          
          _onBoardDrop(row, col);
        },
        builder: (context, candidateData, rejectedData) {
          return BoardWidget(
            key: _boardKey,
            board: _engine.board,
            cellSize: cellSize,
            ghostPiece: candidateData.isNotEmpty ? candidateData.first : null,
          );
        },
      ),
    );
  }

  Widget _buildSidePanel(double cellSize) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScoreCard(
            score: _engine.scoreManager.score,
            bestScore: _engine.scoreManager.bestScore,
            combo: _engine.scoreManager.combo,
          ),
          const SizedBox(height: 24),
          ComboWidget(combo: _engine.scoreManager.combo),
          const SizedBox(height: 24),
          NextPiecesWidget(
            pieces: _engine.availablePieces,
            cellSize: cellSize,
            onPieceDragStarted: _onPieceDragStarted,
            onPieceDragEnded: _onPieceDragEnded,
          ),
          const SizedBox(height: 24),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(double cellSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ComboWidget(combo: _engine.scoreManager.combo),
          const SizedBox(height: 12),
          NextPiecesWidget(
            pieces: _engine.availablePieces,
            cellSize: cellSize,
            onPieceDragStarted: _onPieceDragStarted,
            onPieceDragEnded: _onPieceDragEnded,
          ),
          const SizedBox(height: 12),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.pause,
          onPressed: () {},
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.refresh,
          onPressed: () {
            _engine.restart();
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: kCellBorderColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: kPrimaryTextColor),
        onPressed: onPressed,
      ),
    );
  }
}