class Dice {
  final int sides;

  Dice(this.sides);

  int roll() {
    return (1 + (sides * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000)).toInt();
  }
}