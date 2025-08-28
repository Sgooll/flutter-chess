import 'package:flutter_chess/src/feature/game/models/figure.dart';

class Deck {
  final Map<FigurePosition, Figure> deckMatrix;

  final FigureColor mainColor;

  Deck({required this.deckMatrix, this.mainColor = FigureColor.white});

  factory Deck.whitePlayer() {
    List<Figure> majorFigures(FigureColor color) => [
          Figure(type: FigureType.rook, color: color),
          Figure(type: FigureType.knight, color: color),
          Figure(type: FigureType.bishop, color: color),
          Figure(type: FigureType.queen, color: color),
          Figure(type: FigureType.king, color: color),
          Figure(type: FigureType.bishop, color: color),
          Figure(type: FigureType.knight, color: color),
          Figure(type: FigureType.rook, color: color),
        ];

    return Deck(
      deckMatrix: {
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 0): majorFigures(FigureColor.black)[i],
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 1):
              Figure(type: FigureType.pawn, color: FigureColor.black),
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 6):
              Figure(type: FigureType.pawn, color: FigureColor.white),
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 7): majorFigures(FigureColor.white)[i],
      },
      mainColor: FigureColor.white,
    );
  }

  factory Deck.testCastling() {

    return Deck(
      deckMatrix: {
        FigurePosition(0, 7): Figure(type: FigureType.rook, color: FigureColor.white),
        FigurePosition(4, 7): Figure(type: FigureType.king, color: FigureColor.white),
        FigurePosition(7, 7): Figure(type: FigureType.rook, color: FigureColor.white),
        FigurePosition(4, 0): Figure(type: FigureType.king, color: FigureColor.black),
      },
      mainColor: FigureColor.white,
    );
  }


  factory Deck.blackPlayer() {
    List<Figure> majorFigures(FigureColor color) => [
          Figure(type: FigureType.rook, color: color),
          Figure(type: FigureType.knight, color: color),
          Figure(type: FigureType.bishop, color: color),
          Figure(type: FigureType.queen, color: color),
          Figure(type: FigureType.king, color: color),
          Figure(type: FigureType.bishop, color: color),
          Figure(type: FigureType.knight, color: color),
          Figure(type: FigureType.rook, color: color),
        ];

    return Deck(
      deckMatrix: {
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 0): majorFigures(FigureColor.white)[i],
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 1):
              Figure(type: FigureType.pawn, color: FigureColor.white),
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 6):
              Figure(type: FigureType.pawn, color: FigureColor.black),
        for (int i = 0; i < 8; i++)
          FigurePosition(i, 7): majorFigures(FigureColor.black)[i],
      },
      mainColor: FigureColor.black,
    );
  }

  @override
  String toString() {
    return 'Deck(deckMatrix: $deckMatrix)';
  }
}
