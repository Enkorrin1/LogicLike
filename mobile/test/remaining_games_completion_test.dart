import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/balloon_order_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/camp_differences_game.dart';
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

  testWidgets('notebook sum repairs an error and clears three pages once', (
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
    for (var digit = 0; digit < 5; digit++) {
      final size = tester.getSize(
        find.byKey(ValueKey('notebook-digit-0-$digit')),
      );
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }
    for (var slot = 0; slot < 3; slot++) {
      final size = tester.getSize(
        find.byKey(ValueKey('notebook-slot-0-$slot')),
      );
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }

    await _drag(
      tester,
      find.byKey(const ValueKey('notebook-digit-0-3')),
      find.byKey(const ValueKey('notebook-slot-0-0')),
    );
    await tester.tap(find.byKey(const ValueKey('notebook-digit-0-1')));
    await tester.tap(find.byKey(const ValueKey('notebook-digit-0-2')));
    await tester.pump();
    expect(answers, isEmpty);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const ValueKey('notebook-page-0')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('notebook-digit-0-0')));
    await tester.pump();
    expect(answers, isEmpty);
    await tester.pump(const Duration(milliseconds: 710));
    await tester.pump(const Duration(milliseconds: 330));
    expect(find.byKey(const ValueKey('notebook-page-1')), findsOneWidget);

    for (final round in const [1, 2]) {
      for (final digit in const [0, 1, 2]) {
        await tester.tap(
          find.byKey(ValueKey('notebook-digit-$round-$digit')),
        );
        await tester.pump();
        expect(answers, isEmpty);
      }
      if (round == 1) {
        await tester.pump(const Duration(milliseconds: 710));
        await tester.pump(const Duration(milliseconds: 330));
        expect(find.byKey(const ValueKey('notebook-page-2')), findsOneWidget);
      }
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('odd step repairs and runs three cause chains once', (
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

    const brokenIds = [4, 14, 24];
    const repairIds = [2, 12, 22];
    const decoyIds = [5, 15, 25];
    for (var round = 0; round < 3; round++) {
      await tester.tap(
        find.byKey(ValueKey('odd-step-card-$round-${brokenIds[round]}')),
      );
      await tester.pump();
      if (round == 0) {
        await _drag(
          tester,
          find.byKey(ValueKey('odd-step-repair-$round-${decoyIds[round]}')),
          find.byKey(ValueKey('odd-step-slot-$round')),
        );
        expect(answers, isEmpty);
      }
      await _drag(
        tester,
        find.byKey(ValueKey('odd-step-repair-$round-${repairIds[round]}')),
        find.byKey(ValueKey('odd-step-slot-$round')),
      );
      await tester.tap(find.byKey(ValueKey('odd-step-run-$round')));
      await tester.pumpAndSettle();
      if (round < 2) {
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
        expect(
            find.byKey(
                ValueKey('odd-step-card-${round + 1}-${brokenIds[round + 1]}')),
            findsOneWidget);
      }
      expect(answers, round == 2 ? [_sentinel] : isEmpty);
    }
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
