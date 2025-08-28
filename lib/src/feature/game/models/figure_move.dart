import 'package:flutter_chess/src/feature/game/models/figure.dart';

// Класс для описания движения фигуры
class FigureMove {
  final FigurePosition from;
  final FigurePosition to;
  final Figure figure;

  FigureMove({
    required this.from,
    required this.to,
    required this.figure,
  });
}
