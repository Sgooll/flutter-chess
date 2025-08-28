import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/chess_engine.dart';
import 'package:flutter_chess/src/engine/chess_engine_scope.dart';
import 'package:flutter_chess/src/engine/move_controller.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/menu/main_menu.dart';

class ChessApp extends StatefulWidget {
  const ChessApp({super.key});

  @override
  State<ChessApp> createState() => _ChessAppState();
}

class _ChessAppState extends State<ChessApp> {
  late ChessEngine chessEngine;

  @override
  void initState() {
    super.initState();
    chessEngine = ChessEngine(
      deck: Deck.testCastling(),
      moveController: MoveController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChessEngineScope(
      chessEngine: chessEngine,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo
        ),
        home: const MainMenuScreen(),
      ),
    );
  }
}