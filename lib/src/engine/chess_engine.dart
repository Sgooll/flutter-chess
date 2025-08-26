import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/move_controller.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';

class ChessEngine extends ChangeNotifier {
  final Deck deck;
  final FigureColor? playerColor;
  FigurePosition? selectedFigurePosition;
  final MoveController moveController;

  List<FigurePosition> possibleMoves = [];

  ChessEngine(
      {required this.deck,
      required this.playerColor,
      required this.moveController});

  void selectFigure(FigurePosition position) {
    final selectedFigure = deck.deckMatrix[position];

    if (selectedFigure == null || selectedFigure.color != playerColor) {
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
      selectFigure(to);
    }
    notifyListeners();
  }
}
