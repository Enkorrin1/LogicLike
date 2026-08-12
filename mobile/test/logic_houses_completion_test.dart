import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_board_games.dart';

const _answer = 'logic-houses-answer';

Widget _harness(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 420, child: child))),
    );

Finder get _characters => find.byWidgetPredicate(
      (widget) => widget is LongPressDraggable<int>,
    );

Finder get _houses => find.byWidgetPredicate(
      (widget) => widget is DragTarget<int>,
    );

Future<void> _drag(
  WidgetTester tester,
  Finder character,
  Finder house,
) async {
  final gesture = await tester.startGesture(tester.getCenter(character));
  await tester.pump(const Duration(milliseconds: 650));
  await gesture.moveTo(tester.getCenter(house));
  await tester.pump(const Duration(milliseconds: 120));
  await gesture.up();
  await tester.pump();
}

Future<void> _solveRound(
  WidgetTester tester,
  List<int> houseToCharacter,
) async {
  final remaining = [0, 1, 2];
  for (var house = 0; house < 3; house++) {
    final character = houseToCharacter[house];
    await _drag(
      tester,
      _characters.at(remaining.indexOf(character)),
      _houses.at(house),
    );
    remaining.remove(character);
  }
}

void main() {
  testWidgets('logic houses keeps playing through three village shifts',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        LogicHousesDeductionGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _answer,
          semanticLabel: 'logic houses',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    // A full wrong assignment shakes, clears only the misplaced guests,
    // and keeps the game on the first shift.
    await _solveRound(tester, const [0, 1, 2]);
    await tester.pump(const Duration(milliseconds: 600));
    expect(answers, isEmpty);
    expect(_characters, findsNWidgets(3));

    // House-to-character order for the three visual clue strips.
    for (final solution in const [
      [1, 2, 0],
      [2, 0, 1],
      [0, 1, 2],
    ]) {
      await _solveRound(tester, solution);
      expect(answers, isEmpty);
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump();
    }

    await tester.pump(const Duration(milliseconds: 400));
    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
  });
}
