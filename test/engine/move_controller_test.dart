import 'package:flutter_chess/src/engine/move_controller.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('moveController', () {
    late MoveController moveController;

    setUp(() {
      moveController = MoveController();
    });

    group('pawnMove', () {
      test('белая пешка должна двигаться на одну клетку вперед с любой позиции',
          () {
        final deck = Deck(deckMatrix: {});
        final pawnPosition = FigurePosition(4, 4);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(4, 3)));
      });

      test(
          'черная пешка должна двигаться на одну клетку вперед с любой позиции',
          () {
        final deck = Deck(deckMatrix: {});
        final pawnPosition = FigurePosition(4, 4);
        final blackPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);

        final moves =
            moveController.getPawnMoves(pawnPosition, blackPawn, deck);

        expect(moves, contains(FigurePosition(4, 5)));
      });

      test('белая пешка должна двигаться на два шага с начальной позиции (y=6)',
          () {
        final deck = Deck(deckMatrix: {});
        final pawnPosition = FigurePosition(4, 6);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(4, 4)));
        expect(moves.length, equals(2));
      });

      test(
          'черная пешка должна двигаться на два шага с начальной позиции (y=1)',
          () {
        final deck = Deck(deckMatrix: {});
        final pawnPosition = FigurePosition(4, 1);
        final blackPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);

        final moves =
            moveController.getPawnMoves(pawnPosition, blackPawn, deck);

        expect(moves, contains(FigurePosition(4, 2)));
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves.length, equals(2));
      });

      test('пешка не должна двигаться, если путь заблокирован', () {
        final blockingFigure =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 3): blockingFigure,
        });
        final pawnPosition = FigurePosition(4, 4);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, isEmpty);
      });

      test('белая пешка должна атаковать черную фигуру по диагонали', () {
        final enemyFigure =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 3): enemyFigure,
          FigurePosition(3, 3): enemyFigure,
        });
        final pawnPosition = FigurePosition(4, 4);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(5, 3)));
        expect(moves, contains(FigurePosition(3, 3)));
        expect(moves.length, equals(3));
      });

      test('черная пешка должна атаковать белую фигуру по диагонали', () {
        final enemyFigure =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 5): enemyFigure,
          FigurePosition(3, 5): enemyFigure,
        });
        final pawnPosition = FigurePosition(4, 4);
        final blackPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);

        final moves =
            moveController.getPawnMoves(pawnPosition, blackPawn, deck);

        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 5)));
        expect(moves.length, equals(3));
      });

      test('пешка не должна атаковать фигуру своего цвета', () {
        final allyFigure =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 3): allyFigure,
          FigurePosition(3, 3): allyFigure,
        });
        final pawnPosition = FigurePosition(4, 4);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, isNot(contains(FigurePosition(5, 3))));
        expect(moves, isNot(contains(FigurePosition(3, 3))));
        expect(moves.length, equals(1));
      });

      test('белая пешка на краю доски (y=0) не должна иметь возможных ходов',
          () {
        final deck = Deck(deckMatrix: {});
        final pawnPosition = FigurePosition(4, 0);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, isEmpty);
      });

      test('черная пешка на краю доски (y=7) не должна иметь возможных ходов',
          () {
        final deck = Deck(deckMatrix: {});
        final pawnPosition = FigurePosition(4, 7);
        final blackPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);

        final moves =
            moveController.getPawnMoves(pawnPosition, blackPawn, deck);

        expect(moves, isEmpty);
      });

      test('пешка не должна атаковать за пределы доски', () {
        final deck = Deck(deckMatrix: {});
        final pawnPosition = FigurePosition(0, 4);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(0, 3)));
        expect(moves, isNot(contains(FigurePosition(-1, 3))));
        expect(moves.length, equals(1));
      });

      test(
          'белая пешка с начальной позиции не должна прыгать через фигуру на втором шаге',
          () {
        final blockingFigure =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): blockingFigure,
        });
        final pawnPosition = FigurePosition(4, 6);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves,
            isNot(contains(FigurePosition(4, 4))));
        expect(moves.length, equals(1));
      });
    });

    group('knightMove', () {
      test('конь должен иметь все 8 возможных ходов с центральной позиции', () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(4, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        final expectedMoves = [
          FigurePosition(6, 5),
          FigurePosition(6, 3),
          FigurePosition(2, 5),
          FigurePosition(2, 3),
          FigurePosition(5, 6),
          FigurePosition(5, 2),
          FigurePosition(3, 6),
          FigurePosition(3, 2),
        ];

        expect(moves.length, equals(8));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('конь должен атаковать вражеские фигуры', () {
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 5): enemyPawn,
          FigurePosition(2, 3): enemyPawn,
        });
        final knightPosition = FigurePosition(4, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        expect(moves, contains(FigurePosition(6, 5)));
        expect(moves, contains(FigurePosition(2, 3)));
        expect(moves.length, equals(8)); // Конь может ходить на все 8 позиций (включая атаки)
      });

      test('конь не должен атаковать союзные фигуры', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 5): allyPawn,
          FigurePosition(2, 3): allyPawn,
        });
        final knightPosition = FigurePosition(4, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        expect(
            moves,
            isNot(
                contains(FigurePosition(6, 5))));
        expect(
            moves,
            isNot(
                contains(FigurePosition(2, 3)))); // не может атаковать союзника
        expect(moves.length, equals(6));
      });

      test('конь в углу доски должен иметь только 2 возможных хода', () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(0, 0);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        final expectedMoves = [
          FigurePosition(2, 1),
          FigurePosition(1, 2),
        ];

        expect(moves.length, equals(2));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('конь в правом нижнем углу должен иметь только 2 возможных хода',
          () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(7, 7);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        final expectedMoves = [
          FigurePosition(5, 6),
          FigurePosition(6, 5),
        ];

        expect(moves.length, equals(2));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('конь на краю доски должен иметь ограниченное количество ходов', () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(0, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        final expectedMoves = [
          FigurePosition(2, 5),
          FigurePosition(2, 3),
          FigurePosition(1, 6),
          FigurePosition(1, 2),
        ];

        expect(moves.length, equals(4));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('черный конь должен работать так же как белый', () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(4, 4);
        final blackKnight =
            Figure(type: FigureType.knight, color: FigureColor.black);

        final moves =
            moveController.getKnightMoves(knightPosition, blackKnight, deck);

        expect(moves.length, equals(8));
        expect(moves, contains(FigurePosition(6, 5)));
        expect(moves, contains(FigurePosition(6, 3)));
        expect(moves, contains(FigurePosition(2, 5)));
        expect(moves, contains(FigurePosition(2, 3)));
      });

      test('конь должен перепрыгивать через другие фигуры', () {
        // Окружаем коня фигурами, но он должен перепрыгивать
        final blockingFigure =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 3): blockingFigure,
          FigurePosition(4, 5): blockingFigure,
          FigurePosition(3, 4): blockingFigure,
          FigurePosition(5, 4): blockingFigure,
          FigurePosition(3, 3): blockingFigure,
          FigurePosition(3, 5): blockingFigure,
          FigurePosition(5, 3): blockingFigure,
          FigurePosition(5, 5): blockingFigure,
        });
        final knightPosition = FigurePosition(4, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        expect(moves.length, equals(8));
      });

      test('конь рядом с границей должен исключать ходы за пределы доски', () {
        final deck = Deck(deckMatrix: {});
          final knightPosition = FigurePosition(1, 1);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        for (final move in moves) {
          expect(move.x, greaterThanOrEqualTo(0));
          expect(move.y, greaterThanOrEqualTo(0));
          expect(move.x, lessThanOrEqualTo(7));
          expect(move.y, lessThanOrEqualTo(7));
        }

        expect(moves.length, equals(4));
      });

      test(
          'конь должен корректно обрабатывать смешанные ситуации с союзниками и врагами',
          () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 5): allyPawn,
          FigurePosition(6, 3): enemyPawn,
          FigurePosition(2, 5): allyPawn,
          FigurePosition(2, 3): enemyPawn,
        });
        final knightPosition = FigurePosition(4, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        expect(moves, contains(FigurePosition(6, 3)));
        expect(moves, contains(FigurePosition(2, 3)));
        expect(moves,
            isNot(contains(FigurePosition(6, 5))));
        expect(moves,
            isNot(contains(FigurePosition(2, 5))));
        expect(moves.length, equals(6));
      });
    });

    group('bishopMove', () {
      test(
          'слон должен двигаться по всем четырем диагоналям с центральной позиции',
          () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(4, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        final expectedMoves = [
          FigurePosition(5, 5), FigurePosition(6, 6), FigurePosition(7, 7),
          FigurePosition(3, 5), FigurePosition(2, 6), FigurePosition(1, 7),
          FigurePosition(5, 3), FigurePosition(6, 2), FigurePosition(7, 1),
          FigurePosition(3, 3), FigurePosition(2, 2), FigurePosition(1, 1),
          FigurePosition(0, 0),
        ];

        expect(moves.length, equals(13));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test(
          'слон должен останавливаться при встрече с вражеской фигурой и атаковать её',
          () {
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 6): enemyPawn,
          FigurePosition(2, 2): enemyPawn,
        });
        final bishopPosition = FigurePosition(4, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        expect(moves, contains(FigurePosition(6, 6)));
        expect(moves, contains(FigurePosition(2, 2)));

        expect(moves, isNot(contains(FigurePosition(7, 7))));
        expect(moves, isNot(contains(FigurePosition(1, 1))));

        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 3)));
      });

      test(
          'слон должен останавливаться при встрече с союзной фигурой и не атаковать её',
          () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
            FigurePosition(6, 6): allyPawn,
          FigurePosition(2, 2): allyPawn,
        });
        final bishopPosition = FigurePosition(4, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        expect(moves, isNot(contains(FigurePosition(6, 6))));
        expect(moves, isNot(contains(FigurePosition(2, 2))));

        expect(moves, isNot(contains(FigurePosition(7, 7))));
        expect(moves, isNot(contains(FigurePosition(1, 1))));

        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 3)));
      });

      test('слон в углу доски должен двигаться только по одной диагонали', () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(0, 0);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        final expectedMoves = [
          FigurePosition(1, 1),
          FigurePosition(2, 2),
          FigurePosition(3, 3),
          FigurePosition(4, 4),
          FigurePosition(5, 5),
          FigurePosition(6, 6),
          FigurePosition(7, 7),
        ];

        expect(moves.length, equals(7));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test(
          'слон в противоположном углу должен двигаться только по одной диагонали',
          () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(7, 7);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        final expectedMoves = [
          FigurePosition(6, 6),
          FigurePosition(5, 5),
          FigurePosition(4, 4),
          FigurePosition(3, 3),
          FigurePosition(2, 2),
          FigurePosition(1, 1),
          FigurePosition(0, 0),
        ];

        expect(moves.length, equals(7));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('слон на краю доски должен иметь ограниченные диагональные ходы',
          () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(0, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        final expectedMoves = [
          FigurePosition(1, 5), FigurePosition(2, 6), FigurePosition(3, 7),
          FigurePosition(1, 3), FigurePosition(2, 2), FigurePosition(3, 1),
          FigurePosition(4, 0),
        ];

        expect(moves.length, equals(7));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('черный слон должен работать так же как белый', () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(4, 4);
        final blackBishop =
            Figure(type: FigureType.bishop, color: FigureColor.black);

        final moves =
            moveController.getBishopMoves(bishopPosition, blackBishop, deck);

        expect(moves.length, equals(13));
        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 3)));
        expect(moves, contains(FigurePosition(5, 3)));
        expect(moves, contains(FigurePosition(3, 5)));
      });

      test('слон должен корректно обрабатывать смешанные ситуации', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 5): allyPawn,
          FigurePosition(3, 3): enemyPawn,
          FigurePosition(6, 2): enemyPawn,
        });
        final bishopPosition = FigurePosition(4, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        expect(moves, contains(FigurePosition(3, 3)));
        expect(moves, contains(FigurePosition(6, 2)));

        expect(moves, isNot(contains(FigurePosition(5, 5))));

        expect(moves, isNot(contains(FigurePosition(6, 6))));
        expect(moves, isNot(contains(FigurePosition(2, 2))));
        expect(moves, isNot(contains(FigurePosition(7, 1))));
      });

      test('слон не должен выходить за границы доски', () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(1, 1);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);


        for (final move in moves) {
          expect(move.x, greaterThanOrEqualTo(0));
          expect(move.y, greaterThanOrEqualTo(0));
          expect(move.x, lessThanOrEqualTo(7));
          expect(move.y, lessThanOrEqualTo(7));
        }
      });

      test(
          'слон должен иметь максимальное количество ходов с центра пустой доски',
          () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(3, 3);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        final upperRight = moves.where((m) => m.x > 3 && m.y > 3).length;
        final upperLeft = moves.where((m) => m.x < 3 && m.y > 3).length;
        final lowerRight = moves.where((m) => m.x > 3 && m.y < 3).length;
        final lowerLeft = moves.where((m) => m.x < 3 && m.y < 3).length;

        expect(upperRight, equals(4));
        expect(upperLeft, equals(3));
        expect(lowerRight, equals(3));
        expect(lowerLeft, equals(3));
        expect(moves.length, equals(13));
      });
    });

    group('rookMove', () {
      test(
          'ладья должна двигаться по всем четырем направлениям с центральной позиции',
          () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(4, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        final expectedMoves = [
          FigurePosition(5, 4), FigurePosition(6, 4), FigurePosition(7, 4),
          FigurePosition(3, 4), FigurePosition(2, 4), FigurePosition(1, 4),
          FigurePosition(0, 4),
          FigurePosition(4, 5), FigurePosition(4, 6), FigurePosition(4, 7),
          FigurePosition(4, 3), FigurePosition(4, 2), FigurePosition(4, 1),
          FigurePosition(4, 0),
        ];

        expect(moves.length, equals(14));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test(
          'ладья должна останавливаться при встрече с вражеской фигурой и атаковать её',
          () {
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 4): enemyPawn,
          FigurePosition(4, 2): enemyPawn,
        });
        final rookPosition = FigurePosition(4, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        expect(moves, contains(FigurePosition(6, 4)));
        expect(moves, contains(FigurePosition(4, 2)));

        expect(moves, isNot(contains(FigurePosition(7, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 1))));

        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 3)));
      });

      test(
          'ладья должна останавливаться при встрече с союзной фигурой и не атаковать её',
          () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 4): allyPawn,
          FigurePosition(4, 2): allyPawn,
        });
        final rookPosition = FigurePosition(4, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        expect(moves, isNot(contains(FigurePosition(6, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 2))));

        expect(moves, isNot(contains(FigurePosition(7, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 1))));

        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 3)));
      });

      test('ладья в углу доски должна двигаться только по двум направлениям',
          () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(0, 0);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        final expectedMoves = [
          FigurePosition(1, 0), FigurePosition(2, 0), FigurePosition(3, 0),
          FigurePosition(4, 0), FigurePosition(5, 0), FigurePosition(6, 0),
          FigurePosition(7, 0),
          FigurePosition(0, 1), FigurePosition(0, 2), FigurePosition(0, 3),
          FigurePosition(0, 4), FigurePosition(0, 5), FigurePosition(0, 6),
          FigurePosition(0, 7),
        ];

        expect(moves.length, equals(14));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test(
          'ладья в противоположном углу должна двигаться только по двум направлениям',
          () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(7, 7);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        final expectedMoves = [
          FigurePosition(6, 7), FigurePosition(5, 7), FigurePosition(4, 7),
          FigurePosition(3, 7), FigurePosition(2, 7), FigurePosition(1, 7),
          FigurePosition(0, 7),
          FigurePosition(7, 6), FigurePosition(7, 5), FigurePosition(7, 4),
          FigurePosition(7, 3), FigurePosition(7, 2), FigurePosition(7, 1),
          FigurePosition(7, 0),
        ];

        expect(moves.length, equals(14));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('ладья на краю доски должна иметь ограниченные ходы', () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(0, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        final expectedMoves = [
          FigurePosition(1, 4), FigurePosition(2, 4), FigurePosition(3, 4),
          FigurePosition(4, 4), FigurePosition(5, 4), FigurePosition(6, 4),
          FigurePosition(7, 4),
          FigurePosition(0, 5), FigurePosition(0, 6), FigurePosition(0, 7),
          FigurePosition(0, 3), FigurePosition(0, 2), FigurePosition(0, 1),
          FigurePosition(0, 0),
        ];

        expect(moves.length, equals(14));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('черная ладья должна работать так же как белая', () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(4, 4);
        final blackRook =
            Figure(type: FigureType.rook, color: FigureColor.black);

        final moves =
            moveController.getRookMoves(rookPosition, blackRook, deck);

        expect(moves.length, equals(14));
        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(4, 3)));
      });

      test('ладья должна корректно обрабатывать смешанные ситуации', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 4): allyPawn,
          FigurePosition(2, 4): enemyPawn,
          FigurePosition(4, 6): enemyPawn,
        });
        final rookPosition = FigurePosition(4, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        expect(moves, contains(FigurePosition(2, 4)));
        expect(moves, contains(FigurePosition(4, 6)));

        expect(moves, isNot(contains(FigurePosition(6, 4))));

        expect(moves, isNot(contains(FigurePosition(7, 4))));
        expect(moves, isNot(contains(FigurePosition(1, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 7))));

        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
      });

      test('ладья не должна выходить за границы доски', () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(1, 1);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        for (final move in moves) {
          expect(move.x, greaterThanOrEqualTo(0));
          expect(move.y, greaterThanOrEqualTo(0));
          expect(move.x, lessThanOrEqualTo(7));
          expect(move.y, lessThanOrEqualTo(7));
        }
      });

      test(
          'ладья должна иметь максимальное количество ходов с центра пустой доски',
          () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(3, 3);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        final right = moves.where((m) => m.x > 3 && m.y == 3).length;
        final left = moves.where((m) => m.x < 3 && m.y == 3).length;
        final up = moves.where((m) => m.x == 3 && m.y > 3).length;
        final down = moves.where((m) => m.x == 3 && m.y < 3).length;

        expect(right, equals(4));
        expect(left, equals(3));
        expect(up, equals(4));
        expect(down, equals(3));
        expect(moves.length, equals(14));
      });

      test('ладья должна правильно работать на разных позициях доски', () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(2, 6);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        expect(moves, contains(FigurePosition(0, 6)));
        expect(moves, contains(FigurePosition(7, 6)));
        expect(moves, contains(FigurePosition(2, 0)));
        expect(moves, contains(FigurePosition(2, 7)));

        expect(moves.length, equals(14));
      });
    });

    group('queenMove', () {
      test(
          'ферзь должен двигаться по всем восьми направлениям с центральной позиции',
          () {
        final deck = Deck(deckMatrix: {});
        final queenPosition = FigurePosition(4, 4);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        final expectedMoves = [
          FigurePosition(5, 4), FigurePosition(6, 4),
          FigurePosition(7, 4),
          FigurePosition(3, 4), FigurePosition(2, 4), FigurePosition(1, 4),
          FigurePosition(0, 4),
          FigurePosition(4, 5), FigurePosition(4, 6),
          FigurePosition(4, 7),
          FigurePosition(4, 3), FigurePosition(4, 2), FigurePosition(4, 1),
          FigurePosition(4, 0),
          FigurePosition(5, 5), FigurePosition(6, 6), FigurePosition(7, 7),
          FigurePosition(3, 5), FigurePosition(2, 6),
          FigurePosition(1, 7),
          FigurePosition(5, 3), FigurePosition(6, 2),
          FigurePosition(7, 1),
          FigurePosition(3, 3), FigurePosition(2, 2), FigurePosition(1, 1),
          FigurePosition(0, 0),
        ];

        expect(moves.length, equals(27));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test(
          'ферзь должен останавливаться при встрече с вражескими фигурами и атаковать их',
          () {
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 4): enemyPawn,
          FigurePosition(4, 6): enemyPawn,
          FigurePosition(6, 6): enemyPawn,
          FigurePosition(2, 2): enemyPawn,
        });
        final queenPosition = FigurePosition(4, 4);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        expect(moves, contains(FigurePosition(6, 4)));
        expect(moves, contains(FigurePosition(4, 6)));
        expect(moves, contains(FigurePosition(6, 6)));
        expect(moves, contains(FigurePosition(2, 2)));

        expect(moves, isNot(contains(FigurePosition(7, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 7))));
        expect(moves, isNot(contains(FigurePosition(7, 7))));
        expect(moves, isNot(contains(FigurePosition(1, 1))));
      });

      test(
          'ферзь должен останавливаться при встрече с союзными фигурами и не атаковать их',
          () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 4): allyPawn,
          FigurePosition(4, 6): allyPawn,
          FigurePosition(6, 6): allyPawn,
          FigurePosition(2, 2): allyPawn,
        });
        final queenPosition = FigurePosition(4, 4);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        expect(moves, isNot(contains(FigurePosition(6, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 6))));
        expect(moves, isNot(contains(FigurePosition(6, 6))));
        expect(moves, isNot(contains(FigurePosition(2, 2))));

        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 3)));
      });

      test('ферзь в углу доски должен двигаться только по трем направлениям',
          () {
        final deck = Deck(deckMatrix: {});
        final queenPosition = FigurePosition(0, 0);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        final expectedMoves = [
          FigurePosition(1, 0), FigurePosition(2, 0), FigurePosition(3, 0),
          FigurePosition(4, 0), FigurePosition(5, 0), FigurePosition(6, 0),
          FigurePosition(7, 0),
          FigurePosition(0, 1), FigurePosition(0, 2), FigurePosition(0, 3),
          FigurePosition(0, 4), FigurePosition(0, 5), FigurePosition(0, 6),
          FigurePosition(0, 7),
          FigurePosition(1, 1), FigurePosition(2, 2), FigurePosition(3, 3),
          FigurePosition(4, 4), FigurePosition(5, 5), FigurePosition(6, 6),
          FigurePosition(7, 7),
        ];

          expect(moves.length, equals(21));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('черный ферзь должен работать так же как белый', () {
        final deck = Deck(deckMatrix: {});
        final queenPosition = FigurePosition(4, 4);
        final blackQueen =
            Figure(type: FigureType.queen, color: FigureColor.black);

        final moves =
            moveController.getQueenMoves(queenPosition, blackQueen, deck);

        expect(moves.length, equals(27));
        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 3)));
      });

      test('ферзь должна быть самой мощной фигурой по количеству ходов', () {
        final deck = Deck(deckMatrix: {});
        final position = FigurePosition(4, 4);

        final queenMoves = moveController.getQueenMoves(position,
            Figure(type: FigureType.queen, color: FigureColor.white), deck);
        final rookMoves = moveController.getRookMoves(position,
            Figure(type: FigureType.rook, color: FigureColor.white), deck);
        final bishopMoves = moveController.getBishopMoves(position,
            Figure(type: FigureType.bishop, color: FigureColor.white), deck);
        final knightMoves = moveController.getKnightMoves(position,
            Figure(type: FigureType.knight, color: FigureColor.white), deck);

        expect(queenMoves.length, greaterThan(rookMoves.length));
        expect(queenMoves.length, greaterThan(bishopMoves.length));
        expect(queenMoves.length, greaterThan(knightMoves.length));
        expect(
            queenMoves.length, equals(27));
      });

      test('ферзь не должен выходить за границы доски', () {
        final deck = Deck(deckMatrix: {});
        final queenPosition = FigurePosition(1, 1);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        for (final move in moves) {
          expect(move.x, greaterThanOrEqualTo(0));
          expect(move.y, greaterThanOrEqualTo(0));
          expect(move.x, lessThanOrEqualTo(7));
          expect(move.y, lessThanOrEqualTo(7));
        }
      });
    });

    group('kingMove', () {
      test('король должен двигаться на одну клетку во всех восьми направлениях',
          () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        final expectedMoves = [
          FigurePosition(5, 4),
          FigurePosition(3, 4),
          FigurePosition(4, 5),
          FigurePosition(4, 3),
          FigurePosition(5, 5),
          FigurePosition(3, 5),
          FigurePosition(5, 3),
          FigurePosition(3, 3),
        ];

        expect(moves.length, equals(8));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('король должен атаковать вражеские фигуры вокруг себя', () {
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 4): enemyPawn,
          FigurePosition(4, 5): enemyPawn,
          FigurePosition(5, 5): enemyPawn,
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));

        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves.length, equals(8));
      });

      test('король не должен атаковать союзные фигуры', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 4): allyPawn,
          FigurePosition(4, 5): allyPawn,
          FigurePosition(5, 5): allyPawn,
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        expect(moves, isNot(contains(FigurePosition(5, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 5))));
        expect(moves, isNot(contains(FigurePosition(5, 5))));

        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(3, 5)));
        expect(moves, contains(FigurePosition(5, 3)));
        expect(moves, contains(FigurePosition(3, 3)));
        expect(moves.length, equals(5));
      });

      test('король в углу доски должен иметь только 3 возможных хода', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(0, 0);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        final expectedMoves = [
          FigurePosition(1, 0),
          FigurePosition(0, 1),
          FigurePosition(1, 1),
        ];

        expect(moves.length, equals(3));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('король в противоположном углу должен иметь только 3 возможных хода',
          () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(7, 7);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        final expectedMoves = [
          FigurePosition(6, 7),
          FigurePosition(7, 6),
          FigurePosition(6, 6),
        ];

        expect(moves.length, equals(3));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('король на краю доски должен иметь ограниченные ходы', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(0, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        final expectedMoves = [
          FigurePosition(1, 4),
          FigurePosition(0, 5),
          FigurePosition(0, 3),
          FigurePosition(1, 5),
          FigurePosition(1, 3),
        ];

        expect(moves.length, equals(5));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('черный король должен работать так же как белый', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(4, 4);
        final blackKing =
            Figure(type: FigureType.king, color: FigureColor.black);

        final moves =
            moveController.getKingMoves(kingPosition, blackKing, deck);

        expect(moves.length, equals(8));
              expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(5, 5)));
      });

      test('король должен корректно обрабатывать смешанные ситуации', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 4): allyPawn,
          FigurePosition(4, 5): enemyPawn,
          FigurePosition(3, 4): allyPawn,
          FigurePosition(5, 5): enemyPawn,
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));

        expect(moves, isNot(contains(FigurePosition(5, 4))));
        expect(moves, isNot(contains(FigurePosition(3, 4))));

        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(3, 5)));
        expect(moves, contains(FigurePosition(5, 3)));
        expect(moves, contains(FigurePosition(3, 3)));

        expect(moves.length, equals(6));
      });

      test('король не должен выходить за границы доски', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(1, 1);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        for (final move in moves) {
          expect(move.x, greaterThanOrEqualTo(0));
          expect(move.y, greaterThanOrEqualTo(0));
          expect(move.x, lessThanOrEqualTo(7));
          expect(move.y, lessThanOrEqualTo(7));
        }

        expect(moves.length, equals(8));
      });

      test('король должен иметь ровно 8 ходов с центра пустой доски', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(3, 3);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        expect(moves.length, equals(8));

        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(2, 3)));
        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(3, 2)));
        expect(moves, contains(FigurePosition(4, 4)));
        expect(moves, contains(FigurePosition(2, 4)));
        expect(moves, contains(FigurePosition(4, 2)));
        expect(moves, contains(FigurePosition(2, 2)));
      });

      test('король окруженный союзниками не должен иметь ходов', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 4): allyPawn,
          FigurePosition(3, 4): allyPawn,
          FigurePosition(4, 5): allyPawn,
          FigurePosition(4, 3): allyPawn,
          FigurePosition(5, 5): allyPawn,
          FigurePosition(3, 5): allyPawn,
          FigurePosition(5, 3): allyPawn,
          FigurePosition(3, 3): allyPawn,
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        expect(moves, isEmpty);
      });
    });

    group('isKingInCheck', () {
      test('должен определять шах белому королю', () {
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook =
            Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 0): blackRook,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять отсутствие шаха', () {
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook =
            Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 0): blackRook,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах черному королю от белых фигур', () {
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): blackKing,
          FigurePosition(4, 0): whiteQueen,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.black, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от черной пешки белому королю', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 3): blackPawn,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от черной пешки в другом направлении', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(5, 3): blackPawn,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('не должен определять шах от пешки в неправильном направлении', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 5): blackPawn,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах от белой пешки черному королю', () {
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): blackKing,
              FigurePosition(3, 5): whitePawn,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.black, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от коня', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackKnight = Figure(type: FigureType.knight, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(6, 5): blackKnight,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от слона по диагонали', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackBishop = Figure(type: FigureType.bishop, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(7, 7): blackBishop,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от ферзя по горизонтали', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 4): blackQueen,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от ферзя по диагонали', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(1, 1): blackQueen,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('не должен определять шах если путь заблокирован союзной фигурой', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 3): whitePawn,
          FigurePosition(4, 0): blackRook,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('не должен определять шах если путь заблокирован вражеской фигурой', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 2): blackPawn,
          FigurePosition(4, 0): blackRook,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах когда несколько фигур могут атаковать', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final blackBishop = Figure(type: FigureType.bishop, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 0): blackRook,
          FigurePosition(7, 7): blackBishop,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('не должен определять шах от союзных фигур', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 0): whiteRook,
          FigurePosition(0, 4): whiteQueen,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах в углу доски', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(0, 0): whiteKing,
          FigurePosition(0, 7): blackRook,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

    });

    group('getAttackedSquares', () {
      test('черная пешка должна атаковать вниз по диагонали', () {
        final deck = Deck(deckMatrix: {});
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final pawnPosition = FigurePosition(4, 4);

        final attackedSquares = moveController.getAttackedSquares(pawnPosition, blackPawn, deck);

        expect(attackedSquares.length, equals(2));
        expect(attackedSquares, contains(FigurePosition(3, 5)));
        expect(attackedSquares, contains(FigurePosition(5, 5)));
      });

      test('белая пешка должна атаковать вверх по диагонали', () {
        final deck = Deck(deckMatrix: {});
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final pawnPosition = FigurePosition(4, 4);

        final attackedSquares = moveController.getAttackedSquares(pawnPosition, whitePawn, deck);

        expect(attackedSquares.length, equals(2));
              expect(attackedSquares, contains(FigurePosition(3, 3)));
        expect(attackedSquares, contains(FigurePosition(5, 3)));
      });

      test('пешка на краю доски должна атаковать только доступные клетки', () {
        final deck = Deck(deckMatrix: {});
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final pawnPosition = FigurePosition(0, 4);

        final attackedSquares = moveController.getAttackedSquares(pawnPosition, blackPawn, deck);

        expect(attackedSquares.length, equals(1));
          expect(attackedSquares, contains(FigurePosition(1, 5)));
      });

      test('ладья должна иметь те же атакуемые клетки что и ходы', () {
        final deck = Deck(deckMatrix: {});
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final rookPosition = FigurePosition(4, 4);

        final attackedSquares = moveController.getAttackedSquares(rookPosition, whiteRook, deck);
        final possibleMoves = moveController.getRookMoves(rookPosition, whiteRook, deck);

        expect(attackedSquares.length, equals(possibleMoves.length));
        for (final move in possibleMoves) {
          expect(attackedSquares, contains(move));
        }
      });

      test('конь должен иметь те же атакуемые клетки что и ходы', () {
        final deck = Deck(deckMatrix: {});
        final whiteKnight = Figure(type: FigureType.knight, color: FigureColor.white);
        final knightPosition = FigurePosition(4, 4);

        final attackedSquares = moveController.getAttackedSquares(knightPosition, whiteKnight, deck);
        final possibleMoves = moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        expect(attackedSquares.length, equals(possibleMoves.length));
        for (final move in possibleMoves) {
          expect(attackedSquares, contains(move));
        }
      });

      test('ферзь должен иметь те же атакуемые клетки что и ходы', () {
        final deck = Deck(deckMatrix: {});
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final queenPosition = FigurePosition(4, 4);

        final attackedSquares = moveController.getAttackedSquares(queenPosition, whiteQueen, deck);
        final possibleMoves = moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        expect(attackedSquares.length, equals(possibleMoves.length));
        for (final move in possibleMoves) {
          expect(attackedSquares, contains(move));
        }
      });

      test('должен корректно работать с пустой доской без короля', () {
        final deck = Deck(deckMatrix: {});

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах в сложной позиции с множеством фигур', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whitePawn1 = Figure(type: FigureType.pawn, color: FigureColor.white);
        final whitePawn2 = Figure(type: FigureType.pawn, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        final blackKnight = Figure(type: FigureType.knight, color: FigureColor.black);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 3): whitePawn1,
          FigurePosition(5, 3): whitePawn2,
          FigurePosition(1, 1): blackQueen,
          FigurePosition(6, 6): blackKnight,
          FigurePosition(4, 6): blackPawn,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах от короля к королю (теоретически)', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 5): blackKing,
        });

        final whiteInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        final blackInCheck = moveController.isKingInCheck(FigureColor.black, deck);
        
        expect(whiteInCheck, isTrue);
        expect(blackInCheck, isTrue);
      });

      test('должен определять отсутствие шаха когда все фигуры далеко', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final blackBishop = Figure(type: FigureType.bishop, color: FigureColor.black);
        final blackKnight = Figure(type: FigureType.knight, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 0): blackRook,
          FigurePosition(1, 0): blackBishop,
          FigurePosition(0, 1): blackKnight,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах через несколько клеток', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(7, 7): whiteKing,
          FigurePosition(7, 0): blackRook,
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });
    });

    group('calculatePossibleMoves с фильтрацией шахов', () {
      test('должен исключать ходы короля, которые ставят его под шах', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 5): blackRook,
        });

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(4, 4), whiteKing, deck);

        expect(moves, isNot(contains(FigurePosition(4, 5))));
        expect(moves, isNot(contains(FigurePosition(3, 5))));
        expect(moves, isNot(contains(FigurePosition(5, 5))));
        
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(3, 3)));
        expect(moves, contains(FigurePosition(5, 3)));
      });

      test('должен исключать ходы фигур, которые открывают короля под шах', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 3): whitePawn,
          FigurePosition(4, 0): blackRook,
        });

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(4, 3), whitePawn, deck);

        expect(moves, contains(FigurePosition(4, 2)));
        expect(moves.length, equals(1));
      });

      test('должен исключать ходы, которые не решают проблему шаха', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
              FigurePosition(0, 4): whiteQueen,
          FigurePosition(4, 0): blackRook,
        });

        expect(moveController.isKingInCheck(FigureColor.white, deck), isTrue);

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(0, 4), whiteQueen, deck);



        expect(moves, contains(FigurePosition(4, 0)));
        
        expect(moves, contains(FigurePosition(4, 4)));
        
        expect(moves, isNot(contains(FigurePosition(0, 1))));
        expect(moves, isNot(contains(FigurePosition(0, 5))));
      });

      test('должен правильно работать с диагональными атаками', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteBishop = Figure(type: FigureType.bishop, color: FigureColor.white);
        final blackBishop = Figure(type: FigureType.bishop, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 3): whiteBishop,
          FigurePosition(0, 0): blackBishop,
        });

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(3, 3), whiteBishop, deck);

        expect(moves, isNot(contains(FigurePosition(3, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 2))));
        
        expect(moves, contains(FigurePosition(2, 2)));
        expect(moves, contains(FigurePosition(1, 1)));
        expect(moves, contains(FigurePosition(0, 0)));
      });

      test('должен разрешать все ходы когда король не под угрозой', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 0): whiteQueen,
          FigurePosition(7, 7): blackPawn,
        });

        final normalMoves = moveController.getQueenMoves(
            FigurePosition(0, 0), whiteQueen, deck);
        final filteredMoves = moveController.calculatePossibleMoves(
            FigurePosition(0, 0), whiteQueen, deck);

        expect(filteredMoves.length, equals(normalMoves.length));
        for (final move in normalMoves) {
          expect(filteredMoves, contains(move));
        }
      });

      test('должен правильно обрабатывать ситуацию когда король уже под шахом', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 7): blackQueen,
        });

        expect(moveController.isKingInCheck(FigureColor.white, deck), isTrue);

        final kingMoves = moveController.calculatePossibleMoves(
            FigurePosition(4, 4), whiteKing, deck);


        expect(kingMoves, contains(FigurePosition(3, 5)));
        expect(kingMoves, contains(FigurePosition(5, 3)));
        expect(kingMoves, contains(FigurePosition(3, 3)));

      });

      test('должен корректно работать с атаками коня', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final blackKnight = Figure(type: FigureType.knight, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 4): whitePawn,
          FigurePosition(2, 5): blackKnight,
        });

        final kingMoves = moveController.calculatePossibleMoves(
            FigurePosition(4, 4), whiteKing, deck);

        expect(kingMoves, isNot(contains(FigurePosition(3, 3))));
        
  
        expect(kingMoves, contains(FigurePosition(5, 4)));
        expect(kingMoves, contains(FigurePosition(5, 3)));
      });
    });

    group('getCastlingMoves', () {
      setUp(() {
        // Очищаем movedFigures перед каждым тестом
        moveController.movedFigures.clear();
      });

      test('должен возвращать короткую рокировку для белых', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,  // король на e1
          FigurePosition(7, 7): whiteRook,  // ладья на h1
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, contains(FigurePosition(6, 7))); // g1 - короткая рокировка
        expect(moves.length, equals(1));
      });

      test('должен возвращать длинную рокировку для белых', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,  // король на e1
          FigurePosition(0, 7): whiteRook,  // ладья на a1
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, contains(FigurePosition(2, 7))); // c1 - длинная рокировка
        expect(moves.length, equals(1));
      });

      test('должен возвращать обе рокировки для белых', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook1 = Figure(type: FigureType.rook, color: FigureColor.white);
        final whiteRook2 = Figure(type: FigureType.rook, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,   // король на e1
          FigurePosition(0, 7): whiteRook1,  // ладья на a1
          FigurePosition(7, 7): whiteRook2,  // ладья на h1
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, contains(FigurePosition(6, 7))); // g1 - короткая
        expect(moves, contains(FigurePosition(2, 7))); // c1 - длинная
        expect(moves.length, equals(2));
      });

      test('должен возвращать рокировки для черных', () {
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final blackRook1 = Figure(type: FigureType.rook, color: FigureColor.black);
        final blackRook2 = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 0): blackKing,   // король на e8
          FigurePosition(0, 0): blackRook1,  // ладья на a8
          FigurePosition(7, 0): blackRook2,  // ладья на h8
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 0), blackKing, deck);

        expect(moves, contains(FigurePosition(6, 0))); // g8 - короткая
        expect(moves, contains(FigurePosition(2, 0))); // c8 - длинная
        expect(moves.length, equals(2));
      });

      test('не должен возвращать рокировку если король двигался', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(7, 7): whiteRook,
        });

        // Отмечаем, что король двигался
        moveController.movedFigures.add(FigurePosition(4, 7));

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('не должен возвращать короткую рокировку если ладья двигалась', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook1 = Figure(type: FigureType.rook, color: FigureColor.white);
        final whiteRook2 = Figure(type: FigureType.rook, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(0, 7): whiteRook1,  // длинная ладья
          FigurePosition(7, 7): whiteRook2,  // короткая ладья
        });

        // Отмечаем, что короткая ладья двигалась
        moveController.movedFigures.add(FigurePosition(7, 7));

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, contains(FigurePosition(2, 7))); // только длинная
        expect(moves, isNot(contains(FigurePosition(6, 7)))); // не короткая
        expect(moves.length, equals(1));
      });

      test('не должен возвращать длинную рокировку если ладья двигалась', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook1 = Figure(type: FigureType.rook, color: FigureColor.white);
        final whiteRook2 = Figure(type: FigureType.rook, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(0, 7): whiteRook1,  // длинная ладья
          FigurePosition(7, 7): whiteRook2,  // короткая ладья
        });

        // Отмечаем, что длинная ладья двигалась
        moveController.movedFigures.add(FigurePosition(0, 7));

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, contains(FigurePosition(6, 7))); // только короткая
        expect(moves, isNot(contains(FigurePosition(2, 7)))); // не длинная
        expect(moves.length, equals(1));
      });

      test('не должен возвращать рокировку если король под шахом', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(7, 7): whiteRook,
          FigurePosition(4, 0): blackRook,  // ладья атакует короля
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('не должен возвращать короткую рокировку если путь заблокирован', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final whiteBishop = Figure(type: FigureType.bishop, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(7, 7): whiteRook,
          FigurePosition(5, 7): whiteBishop, // блокирует путь
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('не должен возвращать длинную рокировку если путь заблокирован', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final whiteKnight = Figure(type: FigureType.knight, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(0, 7): whiteRook,
          FigurePosition(1, 7): whiteKnight, // блокирует путь
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('не должен возвращать рокировку если король проходит через атакуемое поле', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(7, 7): whiteRook,
          FigurePosition(5, 0): blackRook,  // атакует f1
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('не должен возвращать рокировку если конечная позиция короля атакуется', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(7, 7): whiteRook,
          FigurePosition(6, 0): blackRook,  // атакует g1
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('не должен возвращать рокировку если нет ладьи', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          // нет ладей
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('не должен возвращать рокировку если ладья неправильного цвета', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(7, 7): blackRook, // черная ладья
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty);
      });

      test('должен правильно работать с длинной рокировкой через все три поля', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(0, 7): whiteRook,
          FigurePosition(1, 0): blackRook,  // атакует b1 (поле, через которое проходит король)
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty); // не должно быть рокировки
      });

      test('должен работать с тестовой позицией для рокировки', () {
        final deck = Deck.testCastling();
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, contains(FigurePosition(6, 7))); // короткая
        expect(moves, contains(FigurePosition(2, 7))); // длинная
        expect(moves.length, equals(2));
      });

      test('не должен возвращать рокировку если на пути стоит не та фигура', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black); // не ладья
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(7, 7): blackPawn, // не ладья на позиции ладьи
          FigurePosition(0, 7): whiteRook,
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, contains(FigurePosition(2, 7))); // только длинная
        expect(moves, isNot(contains(FigurePosition(6, 7)))); // не короткая
        expect(moves.length, equals(1));
      });

      test('должен проверять все промежуточные поля при длинной рокировке', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(0, 7): whiteRook,
          FigurePosition(3, 0): blackRook,  // атакует d1 (промежуточное поле)
        });

        final moves = moveController.getCastlingMoves(
            FigurePosition(4, 7), whiteKing, deck);

        expect(moves, isEmpty); // не должно быть рокировки
      });
    });

  });
}
