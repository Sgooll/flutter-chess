import 'package:flutter_chess/src/feature/game/models/figure.dart';

class Deck {
  final Map<FigurePosition, Figure> deckMatrix;

  Deck({required this.deckMatrix});

  factory Deck.defaultDeck() {

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

    return Deck(deckMatrix: {
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
     
    });
  }

  @override
  String toString() {
    return 'Deck(deckMatrix: $deckMatrix)';
  }
}
