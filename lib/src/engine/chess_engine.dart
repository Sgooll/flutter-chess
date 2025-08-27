import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/move_controller.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';
import 'package:flutter_chess/src/feature/game/models/game_status.dart';

class ChessEngine extends ChangeNotifier {
  final Deck deck;
  final MoveController moveController;

  FigureColor currentPlayerColor = FigureColor.white;
  FigurePosition? selectedFigurePosition;
  GameStatus gameStatus = GameStatus.inProgress;

  List<FigurePosition> possibleMoves = [];

  ChessEngine({required this.deck, required this.moveController});

  void selectFigure(FigurePosition position) {
    if (gameStatus != GameStatus.inProgress) {
      return;
    }

    final selectedFigure = deck.deckMatrix[position];

    if (selectedFigure == null || selectedFigure.color != currentPlayerColor) {
      return;
    }

    selectedFigurePosition = position;

    final moves =
        moveController.calculatePossibleMoves(position, selectedFigure, deck);

    possibleMoves = moves;

    notifyListeners();
  }

  void moveFigure(FigurePosition to) {
    if (possibleMoves.contains(to) && selectedFigurePosition != null) {
      final figure = deck.deckMatrix[selectedFigurePosition!];
      if (figure != null) {
        deck.deckMatrix.remove(selectedFigurePosition);
        deck.deckMatrix[to] = figure;
        selectedFigurePosition = null;
        possibleMoves = [];
      }
    } else {
      return selectFigure(to);
    }

    switchPlayer();
    gameStatus = checkGameStatus();

    notifyListeners();
  }

  void switchPlayer() {
    currentPlayerColor = currentPlayerColor == FigureColor.white
        ? FigureColor.black
        : FigureColor.white;
  }

  GameStatus checkGameStatus() {
    final isCheck = moveController.isKingInCheck(currentPlayerColor, deck);
    bool hasMoves = false;

    for (final position in deck.deckMatrix.keys) {
      final figure = deck.deckMatrix[position];
      if (figure == null) {
        continue;
      }

      if (figure.color != currentPlayerColor) {
        continue;
      }

      final availableMoves =
          moveController.calculatePossibleMoves(position, figure, deck);

      if (availableMoves.isNotEmpty) {
        hasMoves = true;
        break;
      }
    }

    if (isCheck && !hasMoves) {
      return GameStatus.checkmate;
    }

    if (!isCheck && !hasMoves) {
      return GameStatus.stalemate;
    }

    return GameStatus.inProgress;
  }
}
