import 'package:flutter_chess/src/feature/game/models/game_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chess/src/engine/chess_engine.dart';
import 'package:flutter_chess/src/engine/move_controller.dart';
import 'package:flutter_chess/src/feature/game/models/deck.dart';
import 'package:flutter_chess/src/feature/game/models/figure.dart';

void main() {
  group('ChessEngine', () {
    late MoveController moveController;

    setUp(() {
      moveController = MoveController();
    });

    group('isCheckmate', () {
      test('должен определять мат белому королю в углу от черной ладьи', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook1 = Figure(type: FigureType.rook, color: FigureColor.black);
        final blackRook2 = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(0, 0): whiteKing,
          FigurePosition(0, 3): blackRook1,
          FigurePosition(1, 3): blackRook2,
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        expect(engine.checkGameStatus(), GameStatus.checkmate);
      });

      test('должен определять мат черному королю от белого ферзя', () {
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(7, 7): blackKing,
          FigurePosition(6, 6): whiteQueen,
          FigurePosition(5, 6): whiteKing,
        });


        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        engine.currentPlayerColor = FigureColor.black;

        expect(engine.checkGameStatus(), GameStatus.checkmate);
      });

      test('не должен определять мат если король может уйти', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(4, 0): blackRook,
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        expect(engine.checkGameStatus(), GameStatus.inProgress);
      });

      test('не должен определять мат если атаку можно заблокировать', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteRook = Figure(type: FigureType.rook, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 0): whiteRook,
          FigurePosition(4, 7): blackQueen,
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        expect(engine.checkGameStatus(), GameStatus.inProgress);
      });

      test('не должен определять мат если атакующую фигуру можно захватить', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 0): whiteQueen,
          FigurePosition(4, 7): blackRook,
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        expect(engine.checkGameStatus(), GameStatus.inProgress);
      });

      test('не должен определять мат если король не под шахом', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(0, 0): blackRook,
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        expect(engine.checkGameStatus(), GameStatus.inProgress);
      });

      test('должен определять мат от коня (конь не блокируется)', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackKnight = Figure(type: FigureType.knight, color: FigureColor.black);
        final blackRook = Figure(type: FigureType.rook, color: FigureColor.black);
        final blackKing = Figure(type: FigureType.king, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(0, 0): whiteKing,   
          FigurePosition(2, 1): blackKnight, 
          FigurePosition(1, 1): blackRook,
          FigurePosition(1, 2): blackKing,
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        expect(engine.checkGameStatus(), GameStatus.checkmate);
      });

      test('должен определять мат с несколькими фигурами', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        final blackBishop = Figure(type: FigureType.bishop, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
              FigurePosition(0, 0): whiteKing,
          FigurePosition(1, 1): blackQueen,
          FigurePosition(7, 7): blackBishop,
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        expect(engine.checkGameStatus(), GameStatus.checkmate);
      });

      test('не должен определять мат если у короля есть союзники для защиты', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whitePawn = Figure(type: FigureType.pawn, color: FigureColor.white);
        final blackQueen = Figure(type: FigureType.queen, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(4, 4): whiteKing,
          FigurePosition(3, 3): whitePawn,  
          FigurePosition(1, 1): blackQueen,     
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        // Пешка уже блокирует атаку - не мат
        expect(engine.checkGameStatus(), GameStatus.inProgress);
      });

      test('должен работать корректно с пустой доской (нет короля)', () {
        final deck = Deck(deckMatrix: {});

        final engine = ChessEngine(
          deck: deck, 
          moveController: moveController,
        );

        // Нет короля - ничья
        expect(engine.checkGameStatus(), GameStatus.stalemate);
      });

      test('должен корректно определять отсутствие мата когда есть защита', () {
        final whiteKing = Figure(type: FigureType.king, color: FigureColor.white);
        final whiteQueen = Figure(type: FigureType.queen, color: FigureColor.white);
        final blackRook1 = Figure(type: FigureType.rook, color: FigureColor.black);
        final blackRook2 = Figure(type: FigureType.rook, color: FigureColor.black);
        
        final deck = Deck(deckMatrix: {
          FigurePosition(0, 0): whiteKing,   // король в углу
          FigurePosition(4, 4): whiteQueen,  // ферзь может помочь
          FigurePosition(0, 7): blackRook1,  // ладья атакует по вертикали
          FigurePosition(7, 0): blackRook2,  // ладья атакует по горизонтали
        });

        final engine = ChessEngine(
          deck: deck,
          moveController: moveController,
        );

        // Ферзь может заблокировать или захватить - не мат
        expect(engine.checkGameStatus(), GameStatus.inProgress);
      });
    });
  });
}
