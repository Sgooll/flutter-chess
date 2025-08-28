import 'package:flutter/material.dart';
import 'package:flutter_chess/src/engine/move_controller.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';
import 'package:flutter_chess/src/feature/game/models/figure_move.dart';
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

  List<FigureMove> moveFigure(FigurePosition to) {
    final moves = <FigureMove>[];
    
    if (possibleMoves.contains(to) && selectedFigurePosition != null) {
      final figure = deck.deckMatrix[selectedFigurePosition!];
      if (figure != null) {
        final from = selectedFigurePosition!;

        if (figure.type == FigureType.king &&
            isCastlingMove(from, to, figure)) {
          moves.addAll(_performCastling(from, to, figure));
        } else {
          deck.deckMatrix.remove(from);
          deck.deckMatrix[to] = figure;
          moves.add(FigureMove(from: from, to: to, figure: figure));
        }

        moveController.movedFigures.add(from);

        selectedFigurePosition = null;
        possibleMoves = [];
      }
    } else {
      selectFigure(to);
      return moves; // Пустой список если выбираем фигуру
    }

    switchPlayer();
    gameStatus = checkGameStatus();
    notifyListeners();
    return moves;
  }

  void switchPlayer() {
    currentPlayerColor = currentPlayerColor == FigureColor.white
        ? FigureColor.black
        : FigureColor.white;
  }

  bool isCastlingMove(FigurePosition from, FigurePosition to, Figure king) {
    final kingRow = king.color == FigureColor.white ? 7 : 0;
    if (from != FigurePosition(4, kingRow)) return false;

    return (to == FigurePosition(6, kingRow)) ||
        (to == FigurePosition(2, kingRow));
  }

  List<FigureMove> _performCastling(FigurePosition from, FigurePosition to, Figure king) {
    final moves = <FigureMove>[];
    final kingRow = king.color == FigureColor.white ? 7 : 0;

    // Двигаем короля
    deck.deckMatrix.remove(from);
    deck.deckMatrix[to] = king;
    moves.add(FigureMove(from: from, to: to, figure: king));

    // Двигаем ладью
    if (to == FigurePosition(6, kingRow)) {
      // Короткая рокировка
      final rookFrom = FigurePosition(7, kingRow);
      final rookTo = FigurePosition(5, kingRow);
      final rook = deck.deckMatrix.remove(rookFrom);
      if (rook != null) {
        deck.deckMatrix[rookTo] = rook;
        moves.add(FigureMove(from: rookFrom, to: rookTo, figure: rook));
        moveController.movedFigures.add(rookFrom);
      }
    } else if (to == FigurePosition(2, kingRow)) {
      // Длинная рокировка
      final rookFrom = FigurePosition(0, kingRow);
      final rookTo = FigurePosition(3, kingRow);
      final rook = deck.deckMatrix.remove(rookFrom);
      if (rook != null) {
        deck.deckMatrix[rookTo] = rook;
        moves.add(FigureMove(from: rookFrom, to: rookTo, figure: rook));
        moveController.movedFigures.add(rookFrom);
      }
    }
    
    return moves;
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

  // Метод для получения информации о рокировке (для анимации)
  ({FigurePosition rookFrom, FigurePosition rookTo, Figure? rook})? getCastlingRookInfo(
      FigurePosition from, FigurePosition to, Figure king) {
    if (!isCastlingMove(from, to, king)) return null;
    
    final kingRow = king.color == FigureColor.white ? 7 : 0;
    
    if (to == FigurePosition(6, kingRow)) {
      // Короткая рокировка
      final rookFrom = FigurePosition(7, kingRow);
      final rookTo = FigurePosition(5, kingRow);
      final rook = deck.deckMatrix[rookFrom];
      return (rookFrom: rookFrom, rookTo: rookTo, rook: rook);
    } else if (to == FigurePosition(2, kingRow)) {
      // Длинная рокировка
      final rookFrom = FigurePosition(0, kingRow);
      final rookTo = FigurePosition(3, kingRow);
      final rook = deck.deckMatrix[rookFrom];
      return (rookFrom: rookFrom, rookTo: rookTo, rook: rook);
    }
    
    return null;
  }
}
