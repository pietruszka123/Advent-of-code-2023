import 'dart:io';

class Card {
  int left;
  int solved = 0;
  Card(this.left, this.solved);
}

final bool PartTwo = false;
void main() {
  List<String> input = File("./input.txt").readAsLinesSync();

  int output = 0;

  List<Card> cards = [];
  for (var i = 0; i < input.length; i++) {
    var sides = input[i]
        .split(":")[1]
        .split("|")
        .map((e) => e.split(RegExp(r'\s+')))
        .toList();
    int out = 0;

    for (var j = 0; j < sides[0].length; j++) {
      if (sides[0][j] == "") {
        continue;
      }
      if (sides[1].contains(sides[0][j])) {
        out++;
      }
    }
    cards.add(Card(1, out));
  }
  Card current = cards.removeAt(0);
  while (true) {
    output += current.left;
    for (var i = 0; i < current.solved; i++) {
      cards[i].left += current.left;
    }
    if (cards.length == 0) {
      break;
    }
    current = cards.removeAt(0);
  }

  print("Output: " + output.toString());
}
