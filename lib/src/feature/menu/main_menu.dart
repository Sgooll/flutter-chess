import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/chess_engine.dart';
import 'package:flutter_chess/src/engine/chess_engine_scope.dart';
import 'package:flutter_chess/src/engine/move_controller.dart';
import 'package:flutter_chess/src/feature/game/game_screen.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChessEngineScope(
                          chessEngine: ChessEngine(
                              deck: Deck.defaultDeck(),
                              playerColor: FigureColor.white,
                              moveController: MoveController()),
                          child: const GameScreen())));
            },
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
