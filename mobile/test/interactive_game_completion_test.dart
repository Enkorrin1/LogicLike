import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_board_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_reasoning_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_workshop_games.dart';
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
  testWidgets('tower rule clears three blueprints before sending answer once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(TowerRuleGameView(
      accent: Colors.orange,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'tower rule',
      onAnswerSelected: answers.add,
    )));

    const blueprints = [
      [0, 1, 2],
      [2, 1, 0],
      [1, 0, 2],
    ];
    for (var round = 0; round < blueprints.length; round++) {
      final remaining = [0, 1, 2];
      for (var slot = 0; slot < 3; slot++) {
        final piece = blueprints[round][slot];
        await _drag(
          tester,
          _draggables.at(remaining.indexOf(piece)),
          _dragTargets.at(2 - slot),
        );
        remaining.remove(piece);
        if (slot < 2) _expectIncomplete(answers);
      }
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pump();
      if (round < 2) _expectIncomplete(answers);
    }
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

  testWidgets('number neighbors completes three train stations before answer',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(NumberNeighborsReasoningGameView(
      accent: Colors.green,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'number neighbors',
      onAnswerSelected: answers.add,
    )));

    // Every station exposes the larger number first and the smaller second.
    for (var round = 0; round < 3; round++) {
      await _drag(tester, _draggables.at(1), _dragTargets.at(0));
      _expectIncomplete(answers);
      await _drag(tester, _draggables.at(0), _dragTargets.at(1));
      if (round < 2) {
        await tester.pump(const Duration(milliseconds: 900));
        await tester.pump(const Duration(milliseconds: 300));
        _expectIncomplete(answers);
      }
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('market change corrects overpay and serves three purchases once',
      (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(MarketChangeWorkshopGameView(
      accent: Colors.indigo,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'market change',
      onAnswerSelected: answers.add,
    )));

    for (var coin = 0; coin < 4; coin++) {
      final size = tester.getSize(find.byKey(ValueKey('market-coin-0-$coin')));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }

    for (final coin in const [0, 1, 3, 2]) {
      await tester.tap(find.byKey(ValueKey('market-coin-0-$coin')));
      await tester.pump();
      _expectIncomplete(answers);
    }
    expect(find.text('13 / 12'), findsOneWidget);
    final trayCoinSize = tester.getSize(
      find.byKey(const ValueKey('market-tray-coin-0-3')),
    );
    expect(trayCoinSize.width, greaterThanOrEqualTo(44));
    expect(trayCoinSize.height, greaterThanOrEqualTo(44));
    await tester.tap(
      find.byKey(const ValueKey('market-tray-coin-0-3')),
    );
    await tester.pump();
    _expectIncomplete(answers);
    await tester.pump(const Duration(milliseconds: 830));
    expect(find.byKey(const ValueKey('market-target-1')), findsOneWidget);

    await _drag(
      tester,
      find.byKey(const ValueKey('market-coin-1-0')),
      find.byKey(const ValueKey('market-tray-1')),
    );
    for (final coin in const [1, 3]) {
      await tester.tap(find.byKey(ValueKey('market-coin-1-$coin')));
      await tester.pump();
      _expectIncomplete(answers);
    }
    await tester.pump(const Duration(milliseconds: 830));
    expect(find.byKey(const ValueKey('market-target-2')), findsOneWidget);

    for (final coin in const [0, 1, 2, 4]) {
      await tester.tap(find.byKey(ValueKey('market-coin-2-$coin')));
      await tester.pump();
      _expectIncomplete(answers);
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('pattern workshop repairs an error and clears three routes once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(PatternTrainWorkshopGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _sentinelAnswer,
      semanticLabel: 'pattern workshop',
      onAnswerSelected: answers.add,
    )));

    // The first wagon is deliberately wrong: the station must keep waiting.
    await _drag(tester, _draggables.at(0), _dragTargets.at(0));
    await tester.pump(const Duration(milliseconds: 620));
    _expectIncomplete(answers);

    const routes = [
      [1, 0, 2],
      [2, 0, 1],
      [0, 2, 1],
    ];
    for (var round = 0; round < routes.length; round++) {
      final remaining = [0, 1, 2];
      for (var slot = 0; slot < 3; slot++) {
        final piece = routes[round][slot];
        await _drag(
          tester,
          _draggables.at(remaining.indexOf(piece)),
          _dragTargets.at(slot),
        );
        remaining.remove(piece);
        _expectIncomplete(answers);
      }
      if (round < routes.length - 1) {
        await tester.pump(const Duration(milliseconds: 820));
        await tester.pump();
        _expectIncomplete(answers);
      }
    }
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

  testWidgets('mini sudoku accepts token drags into its four cells',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        MiniSudokuBoardGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'mini sudoku drag',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    final tokens = find.descendant(
      of: find.byType(MiniSudokuBoardGameView),
      matching: find.byWidgetPredicate(
        (widget) => widget is LongPressDraggable<int>,
      ),
    );
    final cells = find.descendant(
      of: find.byType(MiniSudokuBoardGameView),
      matching: find.byWidgetPredicate((widget) => widget is DragTarget<int>),
    );
    for (final cell in const [1, 7, 8, 14]) {
      await _drag(tester, tokens.at(1), cells.at(cell));
    }
    await _expectCompletedOnce(tester, answers);
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

  testWidgets('math crossword accepts dragged crystals and rejects a mismatch',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        MathCrosswordWorkshopGameView(
          accent: Colors.orange,
          compact: false,
          correctAnswer: _sentinelAnswer,
          semanticLabel: 'math crossword drag',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    Future<void> dragCrystal(int value, int socket) async {
      final from = find.byKey(ValueKey('math-crossword-crystal-$value'));
      final to = find.byKey(ValueKey('math-crossword-socket-$socket'));
      await tester.dragFrom(tester.getCenter(from),
          tester.getCenter(to) - tester.getCenter(from));
      await tester.pump(const Duration(milliseconds: 120));
    }

    await dragCrystal(2, 0);
    expect(answers, isEmpty);
    await tester.pump(const Duration(milliseconds: 520));
    await dragCrystal(5, 0);
    await dragCrystal(3, 1);
    await dragCrystal(6, 2);
    await tester.pump(const Duration(milliseconds: 650));

    expect(answers, [_sentinelAnswer]);
  });
}
