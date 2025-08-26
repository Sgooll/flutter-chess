import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/chess_engine_scope.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final chessEngine = ChessEngineScope.of(context);

    return ListenableBuilder(
      listenable: chessEngine,
      builder: (context, child) => GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemCount: 64,
        itemBuilder: (context, index) {
          final x = index % 8;
          final y = index ~/ 8;
          final figure = chessEngine.deck.deckMatrix[FigurePosition(x, y)];
          return SquareWidget(x: x, y: y, figure: figure);
        },
      ),
    );
  }
}

class SquareWidget extends StatelessWidget {
  const SquareWidget(
      {super.key, required this.x, required this.y, required this.figure});

  final int x;
  final int y;
  final Figure? figure;

  @override
  Widget build(BuildContext context) {
    final chessEngine = ChessEngineScope.of(context);

    final isBlack = (x + y) % 2 == 0;

    final position = FigurePosition(x, y);

    final isSelected = chessEngine.selectedFigurePosition == position;

    return GestureDetector(
      onTap: () {
        if (chessEngine.selectedFigurePosition == null) {
          chessEngine.selectFigure(position);
        } else {
          chessEngine.moveFigure(position);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: isSelected
                ? Colors.blue
                : isBlack
                    ? Colors.brown
                    : Colors.white,
            alignment: Alignment.center,
            child: figure != null
                ? Image.asset(
                    'assets/${figure!.color.name}-${figure!.type.name}.png')
                : null,
          ),
          if (chessEngine.possibleMoves.contains(position))
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 10,
                height: 10,
                decoration:  BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
