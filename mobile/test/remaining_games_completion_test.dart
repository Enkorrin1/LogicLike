import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/balloon_order_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/camp_differences_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/camp_story_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_board_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/logic_mechanics_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_workshop_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/star_list_game.dart';

const _sentinel = 'remaining-games-sentinel';

Widget _harness(Widget child) => MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: child)),
      ),
    );

Finder get _draggables =>
    find.byWidgetPredicate((widget) => widget is Draggable<Object?>);
Finder get _dragTargets =>
    find.byWidgetPredicate((widget) => widget is DragTarget<Object?>);

Finder _draggableWithData(int data) => find.byWidgetPredicate(
      (widget) => widget is Draggable<int> && widget.data == data,
    );

Future<void> _drag(WidgetTester tester, Finder source, Finder target) async {
  final gesture = await tester.startGesture(tester.getCenter(source));
  await tester.pump(const Duration(milliseconds: 650));
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump(const Duration(milliseconds: 100));
  await gesture.up();
  await tester.pump();
}

Future<void> _pan(
  WidgetTester tester,
  Finder surface,
  Offset from,
  Offset to,
) async {
  final origin = tester.getTopLeft(surface);
  final gesture = await tester.startGesture(origin + from);
  for (var step = 1; step <= 6; step++) {
    await gesture.moveTo(origin + Offset.lerp(from, to, step / 6)!);
    await tester.pump(const Duration(milliseconds: 35));
  }
  await gesture.up();
  await tester.pump();
}

Future<void> _expectCompletedOnce(
  WidgetTester tester,
  List<String> answers, {
  Duration wait = const Duration(milliseconds: 1100),
}) async {
  await tester.pump(wait);
  expect(answers, [_sentinel]);
  await tester.pump(const Duration(seconds: 2));
  expect(answers, [_sentinel]);
  expect(tester.takeException(), isNull);
}

void main() {
  testWidgets('balloon order rejects a large balloon then pops all in order', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        BalloonOrderGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'balloon order',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    final surface = find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.onTapUp != null,
    );
    final surfaceSize = tester.getSize(surface);
    final scale = math.min(surfaceSize.width / 360, surfaceSize.height / 240);
    final boardOrigin = Offset(
      (surfaceSize.width - 360 * scale) / 2,
      (surfaceSize.height - 240 * scale) / 2,
    );
    Offset board(Offset point) => boardOrigin + point * scale;
    final origin = tester.getTopLeft(surface);

    await tester.tapAt(origin + board(const Offset(181, 76)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    expect(answers, isEmpty);
    for (final point in const [
      Offset(111, 116),
      Offset(253, 111),
      Offset(315, 87),
      Offset(48, 88),
      Offset(181, 76),
    ]) {
      await tester.tapAt(origin + board(point));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('camp differences finds all four actual scene differences once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        CampDifferencesGameView(
          accent: Colors.orange,
          compact: false,
          correctAnswer: _sentinel,
          onAnswerSelected: answers.add,
        ),
      ),
    );
    for (var frame = 0; frame < 12; frame++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    final origin = tester.getTopLeft(find.byType(CampDifferencesGameView));
    for (final point in const [
      Offset(254.7, 42.4),
      Offset(324.8, 153.5),
      Offset(323.1, 69.0),
      Offset(280.3, 160.0),
    ]) {
      await tester.tapAt(origin + point);
      await tester.pump(const Duration(milliseconds: 80));
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('camp story waits for memory phase and restores the lantern', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        CampStoryGameView(
          accent: Colors.amber,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'camp story',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    final surface = find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.onPanStart != null,
    );
    await tester.pump(const Duration(milliseconds: 1800));
    const scale = 258 / 252;
    const boardOrigin = Offset(25.71, 0);
    Offset board(Offset point) => boardOrigin + point * scale;
    await _pan(
      tester,
      surface,
      board(const Offset(270, 219)),
      board(const Offset(183, 93)),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(answers, isEmpty);
    await _pan(
      tester,
      surface,
      board(const Offset(235, 219)),
      board(const Offset(183, 93)),
    );
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('logic houses recovers from a wrong layout and solves once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        LogicHousesDeductionGameView(
          accent: Colors.purple,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'logic houses',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    await _drag(tester, _draggableWithData(0), _dragTargets.at(0));
    await _drag(tester, _draggableWithData(1), _dragTargets.at(1));
    await _drag(tester, _draggableWithData(2), _dragTargets.at(2));
    await tester.pump(const Duration(milliseconds: 550));
    expect(answers, isEmpty);
    await _drag(tester, _draggableWithData(1), _dragTargets.at(0));
    await _drag(tester, _draggableWithData(2), _dragTargets.at(1));
    await _drag(tester, _draggableWithData(0), _dragTargets.at(2));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('notebook sum places three digits and sends exact answer once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        NotebookSumWorkshopGameView(
          accent: Colors.indigo,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'notebook sum',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    for (var slot = 0; slot < 3; slot++) {
      await _drag(tester, _draggables.at(0), _dragTargets.at(slot));
      if (slot < 2) expect(answers, isEmpty);
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('odd step reorders the whole chain and completes once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        OddStepGameView(
          accent: Colors.green,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'odd step',
          onAnswerSelected: answers.add,
        ),
      ),
    );

    Future<void> reorder(int oldIndex, int newIndex) async {
      final list = tester.widget<ReorderableListView>(
        find.byType(ReorderableListView),
      );
      list.onReorderItem!(oldIndex, newIndex);
      await tester.pumpAndSettle();
    }

    await reorder(1, 0);
    expect(answers, isEmpty);
    await reorder(3, 1);
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('star list remembers and drags the three shown object kinds', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        StarListGameView(
          accent: Colors.cyan,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'star list',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    final surface = find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.onPanStart != null,
    );
    for (var frame = 0; frame < 45; frame++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    const scale = 246 / 240;
    const boardOrigin = Offset(25.5, 0);
    Offset board(Offset point) => boardOrigin + point * scale;
    for (final home in const [
      Offset(70, 150),
      Offset(145, 144),
      Offset(220, 151),
    ]) {
      await _pan(tester, surface, board(home), board(const Offset(180, 66)));
      expect(answers, isEmpty);
    }
    await _expectCompletedOnce(tester, answers);
  });
}
