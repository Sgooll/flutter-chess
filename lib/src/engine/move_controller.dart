import 'package:flutter/material.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';

class MoveController {
  MoveController();

  List<FigurePosition> calculatePossibleMoves(
      FigurePosition position, Figure figure, Deck deck) {
    final potentialMoves = switch (figure.type) {
      FigureType.pawn => getPawnMoves(position, figure, deck),
      FigureType.knight => getKnightMoves(position, figure, deck),
      FigureType.bishop => getBishopMoves(position, figure, deck),
      FigureType.rook => getRookMoves(position, figure, deck),
      FigureType.queen => getQueenMoves(position, figure, deck),
      FigureType.king => getKingMoves(position, figure, deck),
    };


    return potentialMoves.where((move) {
      final newDeck = _simulateMove(deck, position, move);
      
      return !isKingInCheck(figure.color, newDeck);
    }).toList();
  }

  Deck _simulateMove(Deck deck, FigurePosition from, FigurePosition to) {

    final newMatrix = Map<FigurePosition, Figure>.from(deck.deckMatrix);
    final figure = newMatrix.remove(from);

    if (figure != null) {
      newMatrix[to] = figure;
    }

    return Deck(deckMatrix: newMatrix);
  }

  @visibleForTesting
  List<FigurePosition> getPawnMoves(
      FigurePosition position, Figure figure, Deck deck) {
    final moves = <FigurePosition>[];

    final direction = figure.color == FigureColor.white ? -1 : 1;

    final nextPosition = FigurePosition(position.x, position.y + direction);

    final isNextPositionEmpty = deck.deckMatrix[nextPosition] == null;

    if (nextPosition.outOfBounds) {
      return moves;
    }

    if (isNextPositionEmpty) {
      moves.add(nextPosition);

      // Двойной ход с начальной позиции только если первый ход возможен
      if (position.y == 1 && figure.color == FigureColor.black) {
        final doubleStepPosition = FigurePosition(position.x, position.y + 2);
        if (deck.deckMatrix[doubleStepPosition] == null) {
          moves.add(doubleStepPosition);
        }
      }

      if (position.y == 6 && figure.color == FigureColor.white) {
        final doubleStepPosition = FigurePosition(position.x, position.y - 2);
        if (deck.deckMatrix[doubleStepPosition] == null) {
          moves.add(doubleStepPosition);
        }
      }
    }

    final rightBeatPosition =
        FigurePosition(position.x + 1, position.y + direction);
    final leftBeatPosition =
        FigurePosition(position.x - 1, position.y + direction);

    final leftBeatFigure = deck.deckMatrix[leftBeatPosition];
    final rightBeatFigure = deck.deckMatrix[rightBeatPosition];

    if (rightBeatFigure != null &&
        rightBeatFigure.color != figure.color &&
        !rightBeatPosition.outOfBounds) {
      moves.add(rightBeatPosition);
    }
    if (leftBeatFigure != null &&
        leftBeatFigure.color != figure.color &&
        !leftBeatPosition.outOfBounds) {
      moves.add(leftBeatPosition);
    }

    return moves;
  }

  @visibleForTesting
  List<FigurePosition> getKnightMoves(
      FigurePosition position, Figure figure, Deck deck) {
    const knightOffsets = [
      (2, 1),
      (2, -1),
      (-2, 1),
      (-2, -1),
      (1, 2),
      (1, -2),
      (-1, 2),
      (-1, -2),
    ];

    final moves = <FigurePosition>[];

    for (final (dx, dy) in knightOffsets) {
      final newPosition = FigurePosition(position.x + dx, position.y + dy);

      if (newPosition.outOfBounds) continue;

      final targetFigure = deck.deckMatrix[newPosition];

      if (targetFigure == null || targetFigure.color != figure.color) {
        moves.add(newPosition);
      }
    }

    return moves;
  }

  @visibleForTesting
  List<FigurePosition> getBishopMoves(
      FigurePosition position, Figure figure, Deck deck) {
    final moves = <FigurePosition>[];

    final directions = [
      (1, 1),
      (1, -1),
      (-1, 1),
      (-1, -1),
    ];

    for (final (dx, dy) in directions) {
      int newX = position.x + dx;
      int newY = position.y + dy;

      while (newX >= 0 && newX <= 7 && newY >= 0 && newY <= 7) {
        final newPosition = FigurePosition(newX, newY);
        final targetFigure = deck.deckMatrix[newPosition];

        if (targetFigure == null) {
          moves.add(newPosition);
        } else if (targetFigure.color != figure.color) {
          moves.add(newPosition);
          break;
        } else {
          break;
        }

        newX += dx;
        newY += dy;
      }
    }

    return moves;
  }

  @visibleForTesting
  List<FigurePosition> getRookMoves(
      FigurePosition position, Figure figure, Deck deck) {
    final moves = <FigurePosition>[];

    final directions = [
      (1, 0),
      (-1, 0),
      (0, 1),
      (0, -1),
    ];

    for (final (dx, dy) in directions) {
      int newX = position.x + dx;
      int newY = position.y + dy;

      while (newX >= 0 && newX <= 7 && newY >= 0 && newY <= 7) {
        final newPosition = FigurePosition(newX, newY);
        final targetFigure = deck.deckMatrix[newPosition];

        if (targetFigure == null) {
          moves.add(newPosition);
        } else if (targetFigure.color != figure.color) {
          moves.add(newPosition);
          break;
        } else {
          break;
        }

        newX += dx;
        newY += dy;
      }
    }

    return moves;
  }

  @visibleForTesting
  List<FigurePosition> getQueenMoves(
      FigurePosition position, Figure figure, Deck deck) {
    final moves = <FigurePosition>[];
    final directions = [
      (1, 1),
      (1, -1),
      (-1, 1),
      (-1, -1),
      (1, 0),
      (-1, 0),
      (0, 1),
      (0, -1),
    ];

    for (final (dx, dy) in directions) {
      int newX = position.x + dx;
      int newY = position.y + dy;

      while (newX >= 0 && newX <= 7 && newY >= 0 && newY <= 7) {
        final newPosition = FigurePosition(newX, newY);
        final targetFigure = deck.deckMatrix[newPosition];

        if (targetFigure == null) {
          moves.add(newPosition);
        } else if (targetFigure.color != figure.color) {
          moves.add(newPosition);
          break;
        } else {
          break;
        }

        newX += dx;
        newY += dy;
      }
    }

    return moves;
  }

  @visibleForTesting
  List<FigurePosition> getKingMoves(
      FigurePosition position, Figure figure, Deck deck) {
    final directions = [
      (1, 0),
      (-1, 0),
      (0, 1),
      (0, -1),
      (1, 1),
      (-1, 1),
      (1, -1),
      (-1, -1),
    ];

    final moves = <FigurePosition>[];

    for (final (dx, dy) in directions) {
      final newPosition = FigurePosition(position.x + dx, position.y + dy);

      if (newPosition.outOfBounds) continue;

      final targetFigure = deck.deckMatrix[newPosition];

      if (targetFigure == null || targetFigure.color != figure.color) {
        moves.add(newPosition);
      }
    }

    return moves;
  }

  @visibleForTesting
  List<FigurePosition> getAttackedSquares(
      FigurePosition position, Figure figure, Deck deck) {
    return switch (figure.type) {
      FigureType.pawn => _getPawnAttackedSquares(position, figure),
      FigureType.knight => getKnightMoves(position, figure, deck),
      FigureType.bishop => getBishopMoves(position, figure, deck),
      FigureType.rook => getRookMoves(position, figure, deck),
      FigureType.queen => getQueenMoves(position, figure, deck),
      FigureType.king => getKingMoves(position, figure, deck),
    };
  }

  /// Специальная логика для атакуемых клеток пешки
  List<FigurePosition> _getPawnAttackedSquares(
      FigurePosition position, Figure figure) {
    final moves = <FigurePosition>[];
    final direction = figure.color == FigureColor.white ? -1 : 1;

    // Пешка может атаковать только по диагонали
    final rightAttackPosition =
        FigurePosition(position.x + 1, position.y + direction);
    final leftAttackPosition =
        FigurePosition(position.x - 1, position.y + direction);

    // Добавляем атакуемые клетки независимо от того, заняты они или нет
    if (!rightAttackPosition.outOfBounds) {
      moves.add(rightAttackPosition);
    }
    if (!leftAttackPosition.outOfBounds) {
      moves.add(leftAttackPosition);
    }

    return moves;
  }

  @visibleForTesting
  bool isKingInCheck(FigureColor kingColor, Deck deck) {
    FigurePosition? kingPosition;
    for (final entry in deck.deckMatrix.entries) {
      final figure = entry.value;
      if (figure.type == FigureType.king && figure.color == kingColor) {
        kingPosition = entry.key;
        break;
      }
    }

    if (kingPosition == null) {
      return false;
    }

    final enemyColor =
        kingColor == FigureColor.white ? FigureColor.black : FigureColor.white;

    for (final entry in deck.deckMatrix.entries) {
      final figure = entry.value;
      final position = entry.key;

      if (figure.color == enemyColor) {
        final attackedSquares = getAttackedSquares(position, figure, deck);

        if (attackedSquares.contains(kingPosition)) {
          return true;
        }
      }
    }

    return false;
  }
}
