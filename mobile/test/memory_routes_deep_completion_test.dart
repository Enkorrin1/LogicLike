import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/camp_story_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/route_memory_game.dart';

const _answer = 'memory-routes-complete';

Widget _harness(Widget game) => MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: game)),
      ),
    );

Offset _campPoint(Finder board, WidgetTester tester, Offset logical) {
  final rect = tester.getRect(board);
  final scale = math.min(rect.width / 360, rect.height / 252);
  final origin = rect.topLeft +
      Offset(
        (rect.width - 360 * scale) / 2,
        (rect.height - 252 * scale) / 2,
      );
  return origin + logical * scale;
}

Future<void> _dragCamp(
  WidgetTester tester,
  Finder board,
  Offset from,
  Offset to,
) async {
  final start = _campPoint(board, tester, from);
  final end = _campPoint(board, tester, to);
  final gesture = await tester.startGesture(start);
  await tester.pump(const Duration(milliseconds: 30));
  await gesture.moveTo(Offset.lerp(start, end, .5)!);
  await tester.pump(const Duration(milliseconds: 30));
  await gesture.moveTo(end);
  await tester.pump(const Duration(milliseconds: 30));
  await gesture.up();
  await tester.pump();
}

Offset _routeCell(Finder board, WidgetTester tester, int index) {
  final rect = tester.getRect(board);
  final side = math.min(rect.width * .78, rect.height * .82);
  final grid = Rect.fromCenter(center: rect.center, width: side, height: side);
  return Offset(
    grid.left + (index % 4 + .5) * grid.width / 4,
    grid.top + (index ~/ 4 + .5) * grid.height / 4,
  );
}

Future<void> _traceRoute(
  WidgetTester tester,
  Finder board,
  List<int> route,
  int round,
) async {
  final gesture =
      await tester.startGesture(_routeCell(board, tester, route.first));
  await gesture.moveBy(const Offset(12, 0));
  await tester.pump(const Duration(milliseconds: 30));
  expect(
    find.byKey(ValueKey('route-memory-round-$round-tracing-1')),
    findsOneWidget,
  );
  var length = 1;
  for (final cell in route.skip(1)) {
    await gesture.moveTo(
      _routeCell(board, tester, cell),
      timeStamp: const Duration(milliseconds: 70),
    );
    await tester.pump(const Duration(milliseconds: 70));
    length++;
    if (length < route.length) {
      expect(
        find.byKey(
          ValueKey('route-memory-round-$round-tracing-$length'),
        ),
        findsOneWidget,
      );
    }
  }
  await gesture.up();
  await tester.pump();
}

Future<void> _waitForKey(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  for (var frame = 0; frame < 60 && finder.evaluate().isEmpty; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  final keys = find
      .byType(CustomPaint)
      .evaluate()
      .map((element) => (element.widget as CustomPaint).key)
      .whereType<Key>()
      .join(', ');
  expect(finder, findsOneWidget, reason: 'Current paint keys: $keys');
}

void main() {
  testWidgets(
      'camp story rejects the decoy and restores three objects in order once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(CampStoryGameView(
      accent: Colors.amber,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'camp story',
      onAnswerSelected: answers.add,
    )));
    final board = find.byKey(const ValueKey('camp-story-board'));
    await tester.pump(const Duration(milliseconds: 1800));

    await _dragCamp(
      tester,
      board,
      const Offset(202, 219),
      const Offset(274, 170),
    );
    await tester.pump(const Duration(milliseconds: 450));
    expect(answers, isEmpty);

    for (final move in const [
      (Offset(305, 219), Offset(274, 170)),
      (Offset(337, 219), Offset(302, 127)),
      (Offset(235, 219), Offset(183, 93)),
    ]) {
      await _dragCamp(tester, board, move.$1, move.$2);
      await tester.pump(const Duration(milliseconds: 120));
    }
    expect(answers, isEmpty);
    await tester.pump(const Duration(milliseconds: 700));
    expect(answers, [_answer]);

    await _dragCamp(
      tester,
      board,
      const Offset(235, 219),
      const Offset(183, 93),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
  });

  testWidgets(
      'route memory retries an error and completes three growing routes once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(RouteMemoryGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'route memory',
      onAnswerSelected: answers.add,
    )));
    final board = find.byKey(const ValueKey('route-memory-board'));
    await _waitForKey(tester, 'route-memory-round-0-tracing-0');

    final wrong = await tester.startGesture(_routeCell(board, tester, 13));
    await wrong.moveBy(const Offset(12, 0));
    await tester.pump();
    await wrong.up();
    expect(
      find.byKey(const ValueKey('route-memory-round-0-retrying-0')),
      findsOneWidget,
    );
    await _waitForKey(tester, 'route-memory-round-0-tracing-0');
    expect(answers, isEmpty);

    await _traceRoute(tester, board, const [12, 8, 9, 5, 6], 0);
    await _waitForKey(tester, 'route-memory-round-1-tracing-0');
    expect(answers, isEmpty);
    await _traceRoute(tester, board, const [3, 2, 6, 10, 9, 13], 1);
    await _waitForKey(tester, 'route-memory-round-2-tracing-0');
    expect(answers, isEmpty);
    await _traceRoute(tester, board, const [0, 4, 5, 6, 10, 14, 15], 2);
    for (var frame = 0; frame < 20 && answers.isEmpty; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(answers, [_answer]);

    final ignored = await tester.startGesture(_routeCell(board, tester, 0));
    await ignored.moveBy(const Offset(12, 0));
    await ignored.up();
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
  });
}
