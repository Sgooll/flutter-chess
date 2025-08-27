import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/chess_engine_scope.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';
import 'package:flutter_chess/src/feature/game/models/game_status.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  Figure? _animatingFigure;
  FigurePosition? _animationStart;
  FigurePosition? _animationEnd;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    final chessEngine = ChessEngineScope.of(context);
    chessEngine.addListener(() {
      if (chessEngine.gameStatus == GameStatus.checkmate) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(title: Text('Checkmate!')),
        );
      } else if (chessEngine.gameStatus == GameStatus.stalemate) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(title: Text('Stalemate!')),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animateMove(
      FigurePosition from, FigurePosition to, Figure figure) async {
    setState(() {
      _animatingFigure = figure;
      _animationStart = from;
      _animationEnd = to;
      _isAnimating = true;
    });

    _animation = Tween<Offset>(
      begin: Offset(from.x.toDouble(), from.y.toDouble()),
      end: Offset(to.x.toDouble(), to.y.toDouble()),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    await _animationController.forward();

    setState(() {
      _isAnimating = false;
      _animatingFigure = null;
      _animationStart = null;
      _animationEnd = null;
    });

    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final chessEngine = ChessEngineScope.of(context);
    final screenSize = MediaQuery.of(context).size;
    final boardSize = screenSize.width;
    final squareSize = boardSize / 8;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Ход: ${chessEngine.currentPlayerColor == FigureColor.white ? 'Белые' : 'Черные'}'),
      ),
      body: Center(
        child: SizedBox(
          width: boardSize,
          height: boardSize,
          child: Stack(
            children: [
              // Основная шахматная доска
              ListenableBuilder(
                listenable: chessEngine,
                builder: (context, child) => GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    final x = index % 8;
                    final y = index ~/ 8;
                    final position = FigurePosition(x, y);
                    final figure = chessEngine.deck.deckMatrix[position];

                    // Скрываем фигуру во время анимации
                    final shouldHideFigure = _isAnimating &&
                        (position == _animationStart ||
                            position == _animationEnd);

                    return SquareWidget(
                      x: x,
                      y: y,
                      figure: shouldHideFigure ? null : figure,
                      onTap: () async {
                        if (_isAnimating) return;

                        if (chessEngine.selectedFigurePosition == null) {
                          chessEngine.selectFigure(position);
                        } else {
                          // Если это валидный ход, запускаем анимацию
                          if (chessEngine.possibleMoves.contains(position)) {
                            final fromPosition =
                                chessEngine.selectedFigurePosition!;
                            final movingFigure =
                                chessEngine.deck.deckMatrix[fromPosition];

                            if (movingFigure != null) {
                              await _animateMove(
                                  fromPosition, position, movingFigure);
                            }
                          }
                          chessEngine.moveFigure(position);
                        }
                      },
                    );
                  },
                ),
              ),

              // Слой анимации
              if (_isAnimating && _animatingFigure != null)
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      left: _animation.value.dx * squareSize,
                      top: _animation.value.dy * squareSize,
                      width: squareSize,
                      height: squareSize,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/${_animatingFigure!.color.name}-${_animatingFigure!.type.name}.png',
                          width: squareSize,
                          height: squareSize,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SquareWidget extends StatelessWidget {
  const SquareWidget({
    super.key,
    required this.x,
    required this.y,
    required this.figure,
    required this.onTap,
  });

  final int x;
  final int y;
  final Figure? figure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chessEngine = ChessEngineScope.of(context);
    final isBlack = (x + y) % 2 == 0;
    final position = FigurePosition(x, y);
    final isSelected = chessEngine.selectedFigurePosition == position;
    final isPossibleMove = chessEngine.possibleMoves.contains(position);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: isSelected
                ? const Color(0xff7DA6A1).withOpacity(0.8)
                : isBlack
                    ? const Color(0xffF0D9B5)
                    : const Color(0xffB58863),
            alignment: Alignment.center,
            child: figure != null
                ? Image.asset(
                    'assets/${figure!.color.name}-${figure!.type.name}.png')
                : null,
          ),
          if (isPossibleMove && figure == null)
            Container(
              width: 15,
              height: 15,
              decoration:  BoxDecoration(
                color: const Color(0xff7F7F7F).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          if (isPossibleMove && figure != null)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                shape: BoxShape.circle,
              ),
              width: MediaQuery.of(context).size.width / 8 * 0.9,
              height: MediaQuery.of(context).size.width / 8 * 0.9,
            ),
        ],
      ),
    );
  }
}
