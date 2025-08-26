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

        expect(moves, contains(FigurePosition(4, 3))); // обычный ход
        expect(moves, contains(FigurePosition(5, 3))); // атака вправо
        expect(moves, contains(FigurePosition(3, 3))); // атака влево
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

        expect(moves, contains(FigurePosition(4, 5))); // обычный ход
        expect(moves, contains(FigurePosition(5, 5))); // атака вправо
        expect(moves, contains(FigurePosition(3, 5))); // атака влево
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

        expect(moves, contains(FigurePosition(4, 3))); // только обычный ход
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
        final pawnPosition = FigurePosition(0, 4); // левый край
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(0, 3))); // обычный ход
        expect(moves, isNot(contains(FigurePosition(-1, 3)))); // не за пределы
        expect(moves.length, equals(1));
      });

      test(
          'белая пешка с начальной позиции не должна прыгать через фигуру на втором шаге',
          () {
        final blockingFigure =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): blockingFigure, // блокирует второй шаг
        });
        final pawnPosition = FigurePosition(4, 6);
        final whitePawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);

        final moves =
            moveController.getPawnMoves(pawnPosition, whitePawn, deck);

        expect(moves, contains(FigurePosition(4, 5))); // первый шаг
        expect(moves,
            isNot(contains(FigurePosition(4, 4)))); // второй шаг заблокирован
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
          FigurePosition(6, 5), // (2, 1)
          FigurePosition(6, 3), // (2, -1)
          FigurePosition(2, 5), // (-2, 1)
          FigurePosition(2, 3), // (-2, -1)
          FigurePosition(5, 6), // (1, 2)
          FigurePosition(5, 2), // (1, -2)
          FigurePosition(3, 6), // (-1, 2)
          FigurePosition(3, 2), // (-1, -2)
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

        expect(moves, contains(FigurePosition(6, 5))); // может атаковать
        expect(moves, contains(FigurePosition(2, 3))); // может атаковать
        expect(moves.length, equals(8)); // все ходы доступны
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
                contains(FigurePosition(6, 5)))); // не может атаковать союзника
        expect(
            moves,
            isNot(
                contains(FigurePosition(2, 3)))); // не может атаковать союзника
        expect(moves.length, equals(6)); // только 6 ходов доступны
      });

      test('конь в углу доски должен иметь только 2 возможных хода', () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(0, 0); // левый верхний угол
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        final expectedMoves = [
          FigurePosition(2, 1), // (2, 1)
          FigurePosition(1, 2), // (1, 2)
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
          FigurePosition(5, 6), // (-2, -1)
          FigurePosition(6, 5), // (-1, -2)
        ];

        expect(moves.length, equals(2));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('конь на краю доски должен иметь ограниченное количество ходов', () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(0, 4); // левый край
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        final expectedMoves = [
          FigurePosition(2, 5), // (2, 1)
          FigurePosition(2, 3), // (2, -1)
          FigurePosition(1, 6), // (1, 2)
          FigurePosition(1, 2), // (1, -2)
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
          FigurePosition(4, 3): blockingFigure, // сверху
          FigurePosition(4, 5): blockingFigure, // снизу
          FigurePosition(3, 4): blockingFigure, // слева
          FigurePosition(5, 4): blockingFigure, // справа
          FigurePosition(3, 3): blockingFigure, // диагонали
          FigurePosition(3, 5): blockingFigure,
          FigurePosition(5, 3): blockingFigure,
          FigurePosition(5, 5): blockingFigure,
        });
        final knightPosition = FigurePosition(4, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        // Конь должен иметь все 8 ходов, так как он перепрыгивает
        expect(moves.length, equals(8));
      });

      test('конь рядом с границей должен исключать ходы за пределы доски', () {
        final deck = Deck(deckMatrix: {});
        final knightPosition = FigurePosition(1, 1); // близко к углу
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        // Проверяем, что нет ходов с отрицательными координатами
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
          FigurePosition(6, 5): allyPawn, // не может атаковать
          FigurePosition(6, 3): enemyPawn, // может атаковать
          FigurePosition(2, 5): allyPawn, // не может атаковать
          FigurePosition(2, 3): enemyPawn, // может атаковать
        });
        final knightPosition = FigurePosition(4, 4);
        final whiteKnight =
            Figure(type: FigureType.knight, color: FigureColor.white);

        final moves =
            moveController.getKnightMoves(knightPosition, whiteKnight, deck);

        expect(moves, contains(FigurePosition(6, 3))); // атака врага
        expect(moves, contains(FigurePosition(2, 3))); // атака врага
        expect(moves,
            isNot(contains(FigurePosition(6, 5)))); // не атакует союзника
        expect(moves,
            isNot(contains(FigurePosition(2, 5)))); // не атакует союзника
        expect(moves.length, equals(6)); // 4 свободных + 2 атаки врагов
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

        // Проверяем все 4 диагонали
        final expectedMoves = [
          // Верхняя правая диагональ
          FigurePosition(5, 5), FigurePosition(6, 6), FigurePosition(7, 7),
          // Верхняя левая диагональ
          FigurePosition(3, 5), FigurePosition(2, 6), FigurePosition(1, 7),
          // Нижняя правая диагональ
          FigurePosition(5, 3), FigurePosition(6, 2), FigurePosition(7, 1),
          // Нижняя левая диагональ
          FigurePosition(3, 3), FigurePosition(2, 2), FigurePosition(1, 1),
          FigurePosition(0, 0),
        ];

        expect(moves.length, equals(13)); // 3+3+3+4 клетки
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
          FigurePosition(6, 6): enemyPawn, // блокирует верхнюю правую диагональ
          FigurePosition(2, 2): enemyPawn, // блокирует нижнюю левую диагональ
        });
        final bishopPosition = FigurePosition(4, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        // Должен атаковать вражеские фигуры
        expect(moves, contains(FigurePosition(6, 6)));
        expect(moves, contains(FigurePosition(2, 2)));

        // Но не должен идти дальше них
        expect(moves, isNot(contains(FigurePosition(7, 7))));
        expect(moves, isNot(contains(FigurePosition(1, 1))));

        // Другие диагонали должны быть свободны
        expect(moves, contains(FigurePosition(5, 5))); // до блокировки
        expect(moves, contains(FigurePosition(3, 3))); // до блокировки
      });

      test(
          'слон должен останавливаться при встрече с союзной фигурой и не атаковать её',
          () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 6): allyPawn, // блокирует верхнюю правую диагональ
          FigurePosition(2, 2): allyPawn, // блокирует нижнюю левую диагональ
        });
        final bishopPosition = FigurePosition(4, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        // Не должен атаковать союзные фигуры
        expect(moves, isNot(contains(FigurePosition(6, 6))));
        expect(moves, isNot(contains(FigurePosition(2, 2))));

        // И не должен идти дальше них
        expect(moves, isNot(contains(FigurePosition(7, 7))));
        expect(moves, isNot(contains(FigurePosition(1, 1))));

        // Но может идти до них
        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 3)));
      });

      test('слон в углу доски должен двигаться только по одной диагонали', () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(0, 0); // левый верхний угол
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
        final bishopPosition = FigurePosition(7, 7); // правый нижний угол
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
        final bishopPosition = FigurePosition(0, 4); // левый край
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        // Только две диагонали доступны
        final expectedMoves = [
          // Верхняя правая диагональ
          FigurePosition(1, 5), FigurePosition(2, 6), FigurePosition(3, 7),
          // Нижняя правая диагональ
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
          FigurePosition(5, 5): allyPawn, // блокирует одну диагональ
          FigurePosition(3, 3): enemyPawn, // атакует на другой диагонали
          FigurePosition(6, 2): enemyPawn, // атакует на третьей диагонали
        });
        final bishopPosition = FigurePosition(4, 4);
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        // Может атаковать врагов
        expect(moves, contains(FigurePosition(3, 3)));
        expect(moves, contains(FigurePosition(6, 2)));

        // Не может атаковать союзника
        expect(moves, isNot(contains(FigurePosition(5, 5))));

        // Не может идти дальше блокирующих фигур
        expect(moves, isNot(contains(FigurePosition(6, 6))));
        expect(moves, isNot(contains(FigurePosition(2, 2))));
        expect(moves, isNot(contains(FigurePosition(7, 1))));
      });

      test('слон не должен выходить за границы доски', () {
        final deck = Deck(deckMatrix: {});
        final bishopPosition = FigurePosition(1, 1); // близко к углу
        final whiteBishop =
            Figure(type: FigureType.bishop, color: FigureColor.white);

        final moves =
            moveController.getBishopMoves(bishopPosition, whiteBishop, deck);

        // Проверяем, что все ходы в пределах доски
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

        // Проверяем количество ходов по каждой диагонали
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

        // Проверяем все 4 направления (горизонталь и вертикаль)
        final expectedMoves = [
          // Вправо
          FigurePosition(5, 4), FigurePosition(6, 4), FigurePosition(7, 4),
          // Влево
          FigurePosition(3, 4), FigurePosition(2, 4), FigurePosition(1, 4),
          FigurePosition(0, 4),
          // Вверх
          FigurePosition(4, 5), FigurePosition(4, 6), FigurePosition(4, 7),
          // Вниз
          FigurePosition(4, 3), FigurePosition(4, 2), FigurePosition(4, 1),
          FigurePosition(4, 0),
        ];

        expect(moves.length, equals(14)); // 3+4+3+4 клетки
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
          FigurePosition(6, 4): enemyPawn, // блокирует движение вправо
          FigurePosition(4, 2): enemyPawn, // блокирует движение вниз
        });
        final rookPosition = FigurePosition(4, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        // Должна атаковать вражеские фигуры
        expect(moves, contains(FigurePosition(6, 4)));
        expect(moves, contains(FigurePosition(4, 2)));

        // Но не должна идти дальше них
        expect(moves, isNot(contains(FigurePosition(7, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 1))));

        // Другие направления должны быть свободны
        expect(moves, contains(FigurePosition(5, 4))); // до блокировки
        expect(moves, contains(FigurePosition(4, 3))); // до блокировки
      });

      test(
          'ладья должна останавливаться при встрече с союзной фигурой и не атаковать её',
          () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 4): allyPawn, // блокирует движение вправо
          FigurePosition(4, 2): allyPawn, // блокирует движение вниз
        });
        final rookPosition = FigurePosition(4, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        // Не должна атаковать союзные фигуры
        expect(moves, isNot(contains(FigurePosition(6, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 2))));

        // И не должна идти дальше них
        expect(moves, isNot(contains(FigurePosition(7, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 1))));

        // Но может идти до них
        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 3)));
      });

      test('ладья в углу доски должна двигаться только по двум направлениям',
          () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(0, 0); // левый верхний угол
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        final expectedMoves = [
          // Вправо
          FigurePosition(1, 0), FigurePosition(2, 0), FigurePosition(3, 0),
          FigurePosition(4, 0), FigurePosition(5, 0), FigurePosition(6, 0),
          FigurePosition(7, 0),
          // Вверх
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
        final rookPosition = FigurePosition(7, 7); // правый нижний угол
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        final expectedMoves = [
          // Влево
          FigurePosition(6, 7), FigurePosition(5, 7), FigurePosition(4, 7),
          FigurePosition(3, 7), FigurePosition(2, 7), FigurePosition(1, 7),
          FigurePosition(0, 7),
          // Вниз
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
        final rookPosition = FigurePosition(0, 4); // левый край
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        // Только три направления доступны (нет движения влево)
        final expectedMoves = [
          // Вправо
          FigurePosition(1, 4), FigurePosition(2, 4), FigurePosition(3, 4),
          FigurePosition(4, 4), FigurePosition(5, 4), FigurePosition(6, 4),
          FigurePosition(7, 4),
          // Вверх
          FigurePosition(0, 5), FigurePosition(0, 6), FigurePosition(0, 7),
          // Вниз
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
        expect(moves, contains(FigurePosition(5, 4))); // вправо
        expect(moves, contains(FigurePosition(3, 4))); // влево
        expect(moves, contains(FigurePosition(4, 5))); // вверх
        expect(moves, contains(FigurePosition(4, 3))); // вниз
      });

      test('ладья должна корректно обрабатывать смешанные ситуации', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(6, 4): allyPawn, // блокирует движение вправо
          FigurePosition(2, 4): enemyPawn, // атакует влево
          FigurePosition(4, 6): enemyPawn, // атакует вверх
        });
        final rookPosition = FigurePosition(4, 4);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        // Может атаковать врагов
        expect(moves, contains(FigurePosition(2, 4)));
        expect(moves, contains(FigurePosition(4, 6)));

        // Не может атаковать союзника
        expect(moves, isNot(contains(FigurePosition(6, 4))));

        // Не может идти дальше блокирующих фигур
        expect(moves, isNot(contains(FigurePosition(7, 4))));
        expect(moves, isNot(contains(FigurePosition(1, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 7))));

        // Может идти до блокировки
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

        // Проверяем, что все ходы в пределах доски
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

        // Проверяем количество ходов по каждому направлению
        final right = moves.where((m) => m.x > 3 && m.y == 3).length;
        final left = moves.where((m) => m.x < 3 && m.y == 3).length;
        final up = moves.where((m) => m.x == 3 && m.y > 3).length;
        final down = moves.where((m) => m.x == 3 && m.y < 3).length;

        expect(right, equals(4)); // до (7,3)
        expect(left, equals(3)); // до (0,3)
        expect(up, equals(4)); // до (3,7)
        expect(down, equals(3)); // до (3,0)
        expect(moves.length, equals(14));
      });

      test('ладья должна правильно работать на разных позициях доски', () {
        final deck = Deck(deckMatrix: {});
        final rookPosition = FigurePosition(2, 6);
        final whiteRook =
            Figure(type: FigureType.rook, color: FigureColor.white);

        final moves =
            moveController.getRookMoves(rookPosition, whiteRook, deck);

        // Проверяем, что есть ходы во всех доступных направлениях
        expect(moves, contains(FigurePosition(0, 6))); // влево
        expect(moves, contains(FigurePosition(7, 6))); // вправо
        expect(moves, contains(FigurePosition(2, 0))); // вниз
        expect(moves, contains(FigurePosition(2, 7))); // вверх

        // Общее количество ходов
        expect(moves.length, equals(14)); // 2+5+6+1 = 14 ходов
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

        // Проверяем все 8 направлений (горизонталь + вертикаль + диагонали)
        final expectedMoves = [
          // Горизонталь и вертикаль (как ладья)
          FigurePosition(5, 4), FigurePosition(6, 4),
          FigurePosition(7, 4), // вправо
          FigurePosition(3, 4), FigurePosition(2, 4), FigurePosition(1, 4),
          FigurePosition(0, 4), // влево
          FigurePosition(4, 5), FigurePosition(4, 6),
          FigurePosition(4, 7), // вверх
          FigurePosition(4, 3), FigurePosition(4, 2), FigurePosition(4, 1),
          FigurePosition(4, 0), // вниз
          // Диагонали (как слон)
          FigurePosition(5, 5), FigurePosition(6, 6),
          FigurePosition(7, 7), // верхняя правая
          FigurePosition(3, 5), FigurePosition(2, 6),
          FigurePosition(1, 7), // верхняя левая
          FigurePosition(5, 3), FigurePosition(6, 2),
          FigurePosition(7, 1), // нижняя правая
          FigurePosition(3, 3), FigurePosition(2, 2), FigurePosition(1, 1),
          FigurePosition(0, 0), // нижняя левая
        ];

        expect(moves.length, equals(27)); // 14 (ладья) + 13 (слон) = 27 ходов
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
          FigurePosition(6, 4): enemyPawn, // блокирует горизонтальное движение
          FigurePosition(4, 6): enemyPawn, // блокирует вертикальное движение
          FigurePosition(6, 6): enemyPawn, // блокирует диагональное движение
          FigurePosition(2, 2): enemyPawn, // блокирует другую диагональ
        });
        final queenPosition = FigurePosition(4, 4);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        // Должна атаковать всех врагов
        expect(moves, contains(FigurePosition(6, 4)));
        expect(moves, contains(FigurePosition(4, 6)));
        expect(moves, contains(FigurePosition(6, 6)));
        expect(moves, contains(FigurePosition(2, 2)));

        // Но не должна идти дальше них
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
          FigurePosition(6, 4): allyPawn, // блокирует горизонтальное движение
          FigurePosition(4, 6): allyPawn, // блокирует вертикальное движение
          FigurePosition(6, 6): allyPawn, // блокирует диагональное движение
          FigurePosition(2, 2): allyPawn, // блокирует другую диагональ
        });
        final queenPosition = FigurePosition(4, 4);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        // Не должна атаковать союзников
        expect(moves, isNot(contains(FigurePosition(6, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 6))));
        expect(moves, isNot(contains(FigurePosition(6, 6))));
        expect(moves, isNot(contains(FigurePosition(2, 2))));

        // Но может идти до них
        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));
        expect(moves, contains(FigurePosition(3, 3)));
      });

      test('ферзь в углу доски должен двигаться только по трем направлениям',
          () {
        final deck = Deck(deckMatrix: {});
        final queenPosition = FigurePosition(0, 0); // левый верхний угол
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        final expectedMoves = [
          // Вправо
          FigurePosition(1, 0), FigurePosition(2, 0), FigurePosition(3, 0),
          FigurePosition(4, 0), FigurePosition(5, 0), FigurePosition(6, 0),
          FigurePosition(7, 0),
          // Вверх
          FigurePosition(0, 1), FigurePosition(0, 2), FigurePosition(0, 3),
          FigurePosition(0, 4), FigurePosition(0, 5), FigurePosition(0, 6),
          FigurePosition(0, 7),
          // Диагональ вправо-вверх
          FigurePosition(1, 1), FigurePosition(2, 2), FigurePosition(3, 3),
          FigurePosition(4, 4), FigurePosition(5, 5), FigurePosition(6, 6),
          FigurePosition(7, 7),
        ];

        expect(moves.length, equals(21)); // 7+7+7 = 21 ход
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
        // Проверяем все направления
        expect(moves, contains(FigurePosition(5, 4))); // горизонталь
        expect(moves, contains(FigurePosition(4, 5))); // вертикаль
        expect(moves, contains(FigurePosition(5, 5))); // диагональ
        expect(moves, contains(FigurePosition(3, 3))); // обратная диагональ
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

        // Ферзь должен иметь больше ходов чем любая другая фигура
        expect(queenMoves.length, greaterThan(rookMoves.length));
        expect(queenMoves.length, greaterThan(bishopMoves.length));
        expect(queenMoves.length, greaterThan(knightMoves.length));
        expect(
            queenMoves.length, equals(27)); // максимум для центральной позиции
      });

      test('ферзь не должен выходить за границы доски', () {
        final deck = Deck(deckMatrix: {});
        final queenPosition = FigurePosition(1, 1);
        final whiteQueen =
            Figure(type: FigureType.queen, color: FigureColor.white);

        final moves =
            moveController.getQueenMoves(queenPosition, whiteQueen, deck);

        // Проверяем, что все ходы в пределах доски
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

        // Проверяем все 8 направлений на 1 клетку
        final expectedMoves = [
          // Горизонталь и вертикаль
          FigurePosition(5, 4), // вправо
          FigurePosition(3, 4), // влево
          FigurePosition(4, 5), // вверх
          FigurePosition(4, 3), // вниз
          // Диагонали
          FigurePosition(5, 5), // вправо-вверх
          FigurePosition(3, 5), // влево-вверх
          FigurePosition(5, 3), // вправо-вниз
          FigurePosition(3, 3), // влево-вниз
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
          FigurePosition(5, 4): enemyPawn, // справа
          FigurePosition(4, 5): enemyPawn, // сверху
          FigurePosition(5, 5): enemyPawn, // по диагонали
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        // Должен атаковать всех врагов
        expect(moves, contains(FigurePosition(5, 4)));
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));

        // И иметь свободные ходы в других направлениях
        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves.length, equals(8)); // все 8 ходов доступны
      });

      test('король не должен атаковать союзные фигуры', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 4): allyPawn, // справа
          FigurePosition(4, 5): allyPawn, // сверху
          FigurePosition(5, 5): allyPawn, // по диагонали
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        // Не должен атаковать союзников
        expect(moves, isNot(contains(FigurePosition(5, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 5))));
        expect(moves, isNot(contains(FigurePosition(5, 5))));

        // Но может ходить в свободные направления
        expect(moves, contains(FigurePosition(3, 4)));
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(3, 5)));
        expect(moves, contains(FigurePosition(5, 3)));
        expect(moves, contains(FigurePosition(3, 3)));
        expect(moves.length, equals(5)); // только 5 свободных ходов
      });

      test('король в углу доски должен иметь только 3 возможных хода', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(0, 0); // левый верхний угол
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        final expectedMoves = [
          FigurePosition(1, 0), // вправо
          FigurePosition(0, 1), // вверх
          FigurePosition(1, 1), // диагональ вправо-вверх
        ];

        expect(moves.length, equals(3));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('король в противоположном углу должен иметь только 3 возможных хода',
          () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(7, 7); // правый нижний угол
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        final expectedMoves = [
          FigurePosition(6, 7), // влево
          FigurePosition(7, 6), // вниз
          FigurePosition(6, 6), // диагональ влево-вниз
        ];

        expect(moves.length, equals(3));
        for (final expectedMove in expectedMoves) {
          expect(moves, contains(expectedMove));
        }
      });

      test('король на краю доски должен иметь ограниченные ходы', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(0, 4); // левый край
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        final expectedMoves = [
          FigurePosition(1, 4), // вправо
          FigurePosition(0, 5), // вверх
          FigurePosition(0, 3), // вниз
          FigurePosition(1, 5), // диагональ вправо-вверх
          FigurePosition(1, 3), // диагональ вправо-вниз
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
        expect(moves, contains(FigurePosition(5, 4))); // вправо
        expect(moves, contains(FigurePosition(3, 4))); // влево
        expect(moves, contains(FigurePosition(4, 5))); // вверх
        expect(moves, contains(FigurePosition(4, 3))); // вниз
        expect(moves, contains(FigurePosition(5, 5))); // диагонали
      });

      test('король должен корректно обрабатывать смешанные ситуации', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final enemyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 4): allyPawn, // союзник справа
          FigurePosition(4, 5): enemyPawn, // враг сверху
          FigurePosition(3, 4): allyPawn, // союзник слева
          FigurePosition(5, 5): enemyPawn, // враг по диагонали
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        // Может атаковать врагов
        expect(moves, contains(FigurePosition(4, 5)));
        expect(moves, contains(FigurePosition(5, 5)));

        // Не может атаковать союзников
        expect(moves, isNot(contains(FigurePosition(5, 4))));
        expect(moves, isNot(contains(FigurePosition(3, 4))));

        // Может ходить в свободные клетки
        expect(moves, contains(FigurePosition(4, 3)));
        expect(moves, contains(FigurePosition(3, 5)));
        expect(moves, contains(FigurePosition(5, 3)));
        expect(moves, contains(FigurePosition(3, 3)));

        expect(moves.length, equals(6)); // 2 атаки + 4 свободных хода
      });

      test('король не должен выходить за границы доски', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(1, 1);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        // Проверяем, что все ходы в пределах доски
        for (final move in moves) {
          expect(move.x, greaterThanOrEqualTo(0));
          expect(move.y, greaterThanOrEqualTo(0));
          expect(move.x, lessThanOrEqualTo(7));
          expect(move.y, lessThanOrEqualTo(7));
        }

        expect(moves.length, equals(8)); // все 8 ходов доступны с позиции (1,1)
      });

      test('король должен иметь ровно 8 ходов с центра пустой доски', () {
        final deck = Deck(deckMatrix: {});
        final kingPosition = FigurePosition(3, 3);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        // Король всегда делает только 1 шаг, поэтому максимум 8 ходов
        expect(moves.length, equals(8));

        // Проверяем, что есть ходы во всех направлениях
        expect(moves, contains(FigurePosition(4, 3))); // вправо
        expect(moves, contains(FigurePosition(2, 3))); // влево
        expect(moves, contains(FigurePosition(3, 4))); // вверх
        expect(moves, contains(FigurePosition(3, 2))); // вниз
        expect(moves, contains(FigurePosition(4, 4))); // диагонали
        expect(moves, contains(FigurePosition(2, 4)));
        expect(moves, contains(FigurePosition(4, 2)));
        expect(moves, contains(FigurePosition(2, 2)));
      });

      test('король окруженный союзниками не должен иметь ходов', () {
        final allyPawn =
            Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(5, 4): allyPawn, // справа
          FigurePosition(3, 4): allyPawn, // слева
          FigurePosition(4, 5): allyPawn, // сверху
          FigurePosition(4, 3): allyPawn, // снизу
          FigurePosition(5, 5): allyPawn, // диагонали
          FigurePosition(3, 5): allyPawn,
          FigurePosition(5, 3): allyPawn,
          FigurePosition(3, 3): allyPawn,
        });
        final kingPosition = FigurePosition(4, 4);
        final whiteKing =
            Figure(type: FigureType.king, color: FigureColor.white);

        final moves =
            moveController.getKingMoves(kingPosition, whiteKing, deck);

        expect(moves, isEmpty); // нет доступных ходов
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
          FigurePosition(4, 0): blackRook, // ладья атакует по вертикали
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
          FigurePosition(0, 0): blackRook, // ладья не атакует короля
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах черному королю от белых фигур', () {
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): blackKing,
          FigurePosition(4, 0): whiteQueen, // ферзь атакует по вертикали
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.black, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от черной пешки белому королю', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 3): blackPawn, // черная пешка атакует вниз-вправо (3,3) -> (4,4)
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от черной пешки в другом направлении', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(5, 3): blackPawn, // черная пешка атакует вниз-влево (5,3) -> (4,4)
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('не должен определять шах от пешки в неправильном направлении', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 5): blackPawn, // черная пешка не может атаковать назад вверх
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах от белой пешки черному королю', () {
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): blackKing,
          FigurePosition(3, 5): whitePawn, // белая пешка атакует вверх-вправо (3,5) -> (4,4)
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.black, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от коня', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackKnight = Figure(type: FigureType.knight, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(6, 5): blackKnight, // конь атакует L-ходом
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от слона по диагонали', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackBishop = Figure(type: FigureType.bishop, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(7, 7): blackBishop, // слон атакует по диагонали
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от ферзя по горизонтали', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 4): blackQueen, // ферзь атакует по горизонтали
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue);
      });

      test('должен определять шах от ферзя по диагонали', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(1, 1): blackQueen, // ферзь атакует по диагонали
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
          FigurePosition(4, 3): whitePawn, // союзная пешка блокирует
          FigurePosition(4, 0): blackRook, // ладья не может атаковать
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
          FigurePosition(4, 2): blackPawn, // вражеская пешка блокирует
          FigurePosition(4, 0): blackRook, // ладья не может атаковать через пешку
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
          FigurePosition(4, 0): blackRook, // ладья атакует по вертикали
          FigurePosition(7, 7): blackBishop, // слон атакует по диагонали
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isTrue); // достаточно одной атакующей фигуры
      });

      test('не должен определять шах от союзных фигур', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 0): whiteRook, // союзная ладья
          FigurePosition(0, 4): whiteQueen, // союзный ферзь
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах в углу доски', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(0, 0): whiteKing, // король в углу
          FigurePosition(0, 7): blackRook, // ладья атакует по вертикали
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
        expect(attackedSquares, contains(FigurePosition(3, 5))); // влево-вниз (y+1)
        expect(attackedSquares, contains(FigurePosition(5, 5))); // вправо-вниз (y+1)
      });

      test('белая пешка должна атаковать вверх по диагонали', () {
        final deck = Deck(deckMatrix: {});
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final pawnPosition = FigurePosition(4, 4);

        final attackedSquares = moveController.getAttackedSquares(pawnPosition, whitePawn, deck);

        expect(attackedSquares.length, equals(2));
        expect(attackedSquares, contains(FigurePosition(3, 3))); // влево-вверх (y-1)
        expect(attackedSquares, contains(FigurePosition(5, 3))); // вправо-вверх (y-1)
      });

      test('пешка на краю доски должна атаковать только доступные клетки', () {
        final deck = Deck(deckMatrix: {});
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final pawnPosition = FigurePosition(0, 4); // левый край

        final attackedSquares = moveController.getAttackedSquares(pawnPosition, blackPawn, deck);

        expect(attackedSquares.length, equals(1));
        expect(attackedSquares, contains(FigurePosition(1, 5))); // только вправо-вниз (y+1)
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
        expect(isInCheck, isFalse); // нет короля - нет шаха
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
          FigurePosition(3, 3): whitePawn1, // защищает от слева-снизу
          FigurePosition(5, 3): whitePawn2, // защищает справа-снизу
          FigurePosition(1, 1): blackQueen, // не может атаковать (блокирована пешкой)
          FigurePosition(6, 6): blackKnight, // не может атаковать (неправильная позиция)
          FigurePosition(4, 6): blackPawn, // может атаковать по вертикали? Нет, пешки так не ходят
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах от короля к королю (теоретически)', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 5): blackKing, // короли рядом - взаимный шах
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
          FigurePosition(4, 4): whiteKing, // в центре
          FigurePosition(0, 0): blackRook, // в углу, не атакует
          FigurePosition(1, 0): blackBishop, // не на диагонали
          FigurePosition(0, 1): blackKnight, // слишком далеко для L-хода
        });

        final isInCheck = moveController.isKingInCheck(FigureColor.white, deck);
        expect(isInCheck, isFalse);
      });

      test('должен определять шах через несколько клеток', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(7, 7): whiteKing, // в углу
          FigurePosition(7, 0): blackRook, // ладья атакует через всю вертикаль
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
          FigurePosition(0, 5): blackRook, // ладья контролирует 5-ю горизонталь
        });

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(4, 4), whiteKing, deck);

        // Король не может идти на 5-ю горизонталь
        expect(moves, isNot(contains(FigurePosition(4, 5))));
        expect(moves, isNot(contains(FigurePosition(3, 5))));
        expect(moves, isNot(contains(FigurePosition(5, 5))));
        
        // Но может идти в безопасные места
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
          FigurePosition(4, 3): whitePawn, // пешка защищает короля от ладьи
          FigurePosition(4, 0): blackRook, // ладья на той же вертикали
        });

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(4, 3), whitePawn, deck);

        // Пешка может ходить только вперед по той же вертикали (не открывая короля)
        expect(moves, contains(FigurePosition(4, 2)));
        // Но не может идти в стороны, так как откроет короля
        expect(moves.length, equals(1));
      });

      test('должен исключать ходы, которые не решают проблему шаха', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 7): whiteKing,
          FigurePosition(0, 4): whiteQueen, // ферзь далеко от линии атаки
          FigurePosition(4, 0): blackRook, // ладья атакует короля по вертикали
        });

        // Проверяем, что король под шахом
        expect(moveController.isKingInCheck(FigureColor.white, deck), isTrue);

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(0, 4), whiteQueen, deck);



        // Ферзь может захватить атакующую ладью
        expect(moves, contains(FigurePosition(4, 0)));
        
        // Ферзь может встать на линию атаки для блокировки
        expect(moves, contains(FigurePosition(4, 4)));
        
        // Но не может делать ходы, которые не блокируют шах
        expect(moves, isNot(contains(FigurePosition(0, 1))));
        expect(moves, isNot(contains(FigurePosition(0, 5))));
      });

      test('должен правильно работать с диагональными атаками', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteBishop = Figure(type: FigureType.bishop, color: FigureColor.white);
        final blackBishop = Figure(type: FigureType.bishop, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 3): whiteBishop, // слон защищает короля
          FigurePosition(0, 0): blackBishop, // черный слон на диагонали
        });

        final moves = moveController.calculatePossibleMoves(
            FigurePosition(3, 3), whiteBishop, deck);

        // Слон не может покинуть диагональ защиты
        expect(moves, isNot(contains(FigurePosition(3, 4))));
        expect(moves, isNot(contains(FigurePosition(4, 2))));
        
        // Но может двигаться по диагонали
        expect(moves, contains(FigurePosition(2, 2)));
        expect(moves, contains(FigurePosition(1, 1)));
        expect(moves, contains(FigurePosition(0, 0))); // захват атакующего
      });

      test('должен разрешать все ходы когда король не под угрозой', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final blackPawn = Figure(type: FigureType.pawn, color: FigureColor.black);
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 0): whiteQueen,
          FigurePosition(7, 7): blackPawn, // далеко от короля
        });

        final normalMoves = moveController.getQueenMoves(
            FigurePosition(0, 0), whiteQueen, deck);
        final filteredMoves = moveController.calculatePossibleMoves(
            FigurePosition(0, 0), whiteQueen, deck);

        // Все ходы должны быть разрешены
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
          FigurePosition(4, 7): blackQueen, // ферзь атакует короля - шах!
        });

        // Проверяем, что король действительно под шахом
        expect(moveController.isKingInCheck(FigureColor.white, deck), isTrue);

        final kingMoves = moveController.calculatePossibleMoves(
            FigurePosition(4, 4), whiteKing, deck);


        // Король может уйти из-под шаха
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
          FigurePosition(2, 5): blackKnight, // конь атакует короля
        });

        final kingMoves = moveController.calculatePossibleMoves(
            FigurePosition(4, 4), whiteKing, deck);

        expect(kingMoves, isNot(contains(FigurePosition(3, 3))));
        
        // Но может идти в безопасные места
        expect(kingMoves, contains(FigurePosition(5, 4)));
        expect(kingMoves, contains(FigurePosition(5, 3)));
      });
    });

  });
}
