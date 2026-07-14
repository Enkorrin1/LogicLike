import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_board_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_reasoning_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_workshop_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/logic_mechanics_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/sequence_workshop_games.dart';

const _sentinelAnswer = 'sentinel-correct-answer';

Widget _harness(Widget child) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 420, child: child),
        ),
      ),
    );

Finder get _draggables =>
    find.byWidgetPredicate((widget) => widget is Draggable<Object?>);

Finder get _dragTargets =>
    find.byWidgetPredicate((widget) => widget is DragTarget<Object?>);

Future<void> _drag(
  WidgetTester tester,
  Finder source,
  Finder target,
) async {
  final gesture = await tester.startGesture(tester.getCenter(source));
  await tester.pump(const Duration(milliseconds: 650));
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump(const Duration(milliseconds: 120));
  await gesture.up();
  await tester.pump();
}

void _expectIncomplete(List<String> answers) => expect(answers, isEmpty);

Future<void> _expectCompletedOnce(
  WidgetTester tester,
  List<String> answers, {
  Duration wait = const Duration(milliseconds: 1100),
}) async {
  await tester.pump(wait);
  expect(answers, [_sentinelAnswer]);
  await tester.pump(const Duration(seconds: 2));
  expect(answers, [_sentinelAnswer]);
}

void main() {
  testWidgets('bridge order needs two reorder drags and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(BridgeOrderGameView(
      accent: Colors.teal,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'bridge order',
      onAnswerSelected: answers.add,
    )));

    await _drag(tester, _draggables.at(1), _dragTargets.at(0));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(3), _dragTargets.at(1));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('tower rule places all three blocks and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(TowerRuleGameView(
      accent: Colors.orange,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'tower rule',
      onAnswerSelected: answers.add,
    )));

    await _drag(tester, _draggables.at(0), _dragTargets.at(2));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(0), _dragTargets.at(1));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(0), _dragTargets.at(0));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('home clues assigns three residents and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(HomeCluesGameView(
      accent: Colors.purple,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'home clues',
      onAnswerSelected: answers.add,
    )));

    await _drag(tester, _draggables.at(1), _dragTargets.at(0));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(1), _dragTargets.at(1));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(0), _dragTargets.at(2));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('number bridge builds 3-4-5 and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(NumberBridgeReasoningGameView(
      accent: Colors.blue,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'number bridge',
      onAnswerSelected: answers.add,
    )));

    // Choices start as 3, 5, 4, 2, 6 and disappear after placement.
    await _drag(tester, _draggables.at(0), _dragTargets.at(0));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(1), _dragTargets.at(1));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(0), _dragTargets.at(2));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('star balance distributes eight stars and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(StarBalanceReasoningGameView(
      accent: Colors.amber,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'star balance',
      onAnswerSelected: answers.add,
    )));

    for (var i = 0; i < 4; i++) {
      await _drag(tester, _draggables.at(0), _dragTargets.at(0));
      _expectIncomplete(answers);
    }
    for (var i = 0; i < 4; i++) {
      await _drag(tester, _draggables.at(0), _dragTargets.at(1));
      if (i < 3) _expectIncomplete(answers);
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('number neighbors places 6 and 8 and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(NumberNeighborsReasoningGameView(
      accent: Colors.green,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'number neighbors',
      onAnswerSelected: answers.add,
    )));

    // Sources are 8, 6; targets are the missing slots for 6, 8.
    await _drag(tester, _draggables.at(1), _dragTargets.at(0));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(0), _dragTargets.at(1));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('market change pays 5+5+2 and sends answer once', (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(MarketChangeWorkshopGameView(
      accent: Colors.indigo,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'market change',
      onAnswerSelected: answers.add,
    )));

    for (var i = 0; i < 3; i++) {
      await _drag(tester, _draggables.at(0), _dragTargets.at(0));
      if (i < 2) _expectIncomplete(answers);
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('pattern workshop fills three slots and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(PatternTrainWorkshopGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'pattern workshop',
      onAnswerSelected: answers.add,
    )));

    // Slot answer order is piece 1, then 0, then 2.
    await _drag(tester, _draggables.at(1), _dragTargets.at(0));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(0), _dragTargets.at(1));
    _expectIncomplete(answers);
    await _drag(tester, _draggables.at(0), _dragTargets.at(2));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('rocket workshop assembles four parts and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(RocketAssemblyWorkshopGameView(
      accent: Colors.deepOrange,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'rocket workshop',
      onAnswerSelected: answers.add,
    )));

    for (var target = 0; target < 4; target++) {
      await _drag(tester, _draggables.at(0), _dragTargets.at(target));
      if (target < 3) _expectIncomplete(answers);
    }
    await _expectCompletedOnce(
      tester,
      answers,
      wait: const Duration(milliseconds: 1300),
    );
  });

  testWidgets('secret code completes in compact mode and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        SecretCodeGameView(
          accent: Colors.teal,
          compact: true,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'secret code',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    for (final digit in const ['2', '4', '8']) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await tester.pump(const Duration(milliseconds: 601));

    expect(tester.takeException(), isNull);
    expect(answers, [_sentinelAnswer]);
    await tester.tap(find.text('8'), warnIfMissed: false);
    await tester.pump();
    expect(answers, [_sentinelAnswer]);
  });

  testWidgets('odd card completes both rounds and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        OddCardInvestigationGameView(
          accent: Colors.purple,
          compact: false,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'odd card',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('odd-card-0-3')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 230));
    await tester.pumpAndSettle();
    expect(answers, isEmpty);
    await tester.tap(find.byKey(const ValueKey('odd-card-1-1')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 230));
    await tester.pumpAndSettle();

    expect(answers, [_sentinelAnswer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_sentinelAnswer]);
  });

  testWidgets('mini sudoku completes all four cells and sends answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        MiniSudokuBoardGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'mini sudoku',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    // The board contributes 16 InkWells, followed by four token controls.
    // Every missing cell in this board has token 1.
    final tokenOne = find.byType(InkWell).at(17);
    for (var i = 0; i < 4; i++) {
      await tester.tap(tokenOne);
      await tester.pump();
    }
    await tester.pump(const Duration(milliseconds: 421));

    expect(answers, [_sentinelAnswer]);
    await tester.tap(tokenOne, warnIfMissed: false);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_sentinelAnswer]);
  });

  testWidgets('mini sudoku recovers from a wrong token before completion',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        MiniSudokuBoardGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'mini sudoku retry',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    final wrongToken = find.byType(InkWell).at(16);
    final tokenOne = find.byType(InkWell).at(17);
    await tester.tap(wrongToken);
    for (var i = 0; i < 3; i++) {
      await tester.tap(tokenOne);
      await tester.pump();
    }
    await tester.pump();
    expect(answers, isEmpty);
    await tester.tap(tokenOne);
    await tester.pump(const Duration(milliseconds: 421));

    expect(answers, [_sentinelAnswer]);
  });

  testWidgets('math crossword fills three cells before sending answer',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        MathCrosswordWorkshopGameView(
          accent: Colors.orange,
          compact: false,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'math crossword',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    final keypad = find.byType(InkWell);
    expect(keypad, findsNWidgets(6));
    for (final index in const [3, 1]) {
      await tester.tap(keypad.at(index));
      await tester.pump();
      expect(answers, isEmpty);
    }
    await tester.tap(keypad.at(4));
    await tester.pump(const Duration(milliseconds: 651));

    expect(answers, [_sentinelAnswer]);
    await tester.tap(keypad.at(4), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_sentinelAnswer]);
  });

  testWidgets('math crossword clears wrong cells and can then be solved',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        MathCrosswordWorkshopGameView(
          accent: Colors.orange,
          compact: false,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'math crossword retry',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    final keypad = find.byType(InkWell);
    for (final index in const [0, 1, 4]) {
      await tester.tap(keypad.at(index));
      await tester.pump();
    }
    expect(answers, isEmpty);
    await tester.pump(const Duration(milliseconds: 621));

    await tester.tap(keypad.at(3));
    await tester.pump(const Duration(milliseconds: 651));

    expect(answers, [_sentinelAnswer]);
  });
}
