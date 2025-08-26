
enum FigureType {
  pawn,
  knight,
  bishop,
  rook,
  queen,
  king,
}

enum FigureColor {
  white,
  black,
}


class FigurePosition {
  final int x;
  final int y;

  FigurePosition(this.x, this.y);

  @override
  String toString() {
    return '($x, $y)';
  }

  bool get outOfBounds {
    return x < 0 || x > 7 || y < 0 || y > 7;
  }

  @override
  bool operator ==(Object other) {
    if (other is FigurePosition) {
      return x == other.x && y == other.y;
    }
    return false;
  }
  @override
  int get hashCode => x.hashCode ^ y.hashCode;
  
}


class Figure {
  final FigureType type;
  final FigureColor color;


  Figure({required this.type, required this.color});

  @override
  String toString() {
    return '$color $type';
  }
}
