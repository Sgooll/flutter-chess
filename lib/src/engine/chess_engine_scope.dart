import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/chess_engine.dart';

class ChessEngineScope extends InheritedWidget {
  const ChessEngineScope(
      {super.key, required super.child, required this.chessEngine});

  final ChessEngine chessEngine;

  static ChessEngine of(BuildContext context) {
    final ChessEngineScope? result = context.getInheritedWidgetOfExactType<ChessEngineScope>();
    return result!.chessEngine;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
