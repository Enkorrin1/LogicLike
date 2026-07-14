import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/animal_word_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/code_grid_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/letter_field_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/space_proof_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/why_chain_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/word_builder_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/word_grid_game.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

const _sentinel = 'word-logic-sentinel';

Widget _harness(Widget child, {String languageCode = 'en'}) => MaterialApp(
      locale: Locale(languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: child)),
      ),
    );

Finder get _draggables =>
    find.byWidgetPredicate((widget) => widget is Draggable<Object?>);
Finder get _dragTargets =>
    find.byWidgetPredicate((widget) => widget is DragTarget<Object?>);

Future<void> _drag(WidgetTester tester, Finder source, Finder target) async {
  final gesture = await tester.startGesture(tester.getCenter(source));
  await tester.pump(const Duration(milliseconds: 650));
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump(const Duration(milliseconds: 100));
  await gesture.up();
  await tester.pump();
}

Future<void> _dragPoints(
  WidgetTester tester,
  Finder surface,
  List<Offset> localPoints,
) async {
  final origin = tester.getTopLeft(surface);
  final gesture = await tester.startGesture(origin + localPoints.first);
  for (final point in localPoints.skip(1)) {
    await gesture.moveTo(
      origin + point,
      timeStamp: const Duration(milliseconds: 80),
    );
    await tester.pump(const Duration(milliseconds: 40));
  }
  await gesture.up();
  await tester.pump();
}

Offset _gridCenter(int index, {required double top, double size = 220}) {
  final cell = size / 4;
  return Offset(
    (420 - size) / 2 + (index % 4 + 0.5) * cell,
    top + (index ~/ 4 + 0.5) * cell,
  );
}

Future<void> _expectOnce(
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
  for (final locale in const ['ru', 'ar']) {
    testWidgets('word builder $locale completes through ordered tile taps once',
        (tester) async {
      final answers = <String>[];
      await tester.pumpWidget(_harness(
        LocaleWordBuilderGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'word builder',
          onAnswerSelected: answers.add,
        ),
        languageCode: locale,
      ));
      final tileOrder = locale == 'ru' ? const [2, 3, 0, 1] : const [2, 0, 1];
      for (var slot = 0; slot < tileOrder.length; slot++) {
        final source = find.byWidgetPredicate(
          (widget) =>
              widget is Draggable<int> && widget.data == tileOrder[slot],
        );
        await _drag(tester, source, _dragTargets.at(slot));
        if (slot < tileOrder.length - 1) expect(answers, isEmpty);
      }
      await _expectOnce(tester, answers);
    });

    testWidgets('letter field $locale traces both rounds and completes once',
        (tester) async {
      final answers = <String>[];
      await tester.pumpWidget(_harness(
        LocaleLetterFieldGameView(
          accent: Colors.indigo,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'letter field',
          onAnswerSelected: answers.add,
        ),
        languageCode: locale,
      ));
      final surface = find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.onPanStart != null,
      );
      await _dragPoints(
        tester,
        surface,
        [5, 6, 10, 9].map((cell) => _gridCenter(cell, top: 75)).toList(),
      );
      expect(answers, isEmpty);
      await tester.pump(const Duration(milliseconds: 651));
      await _dragPoints(
        tester,
        surface,
        [5, 6, 10].map((cell) => _gridCenter(cell, top: 75)).toList(),
      );
      await _expectOnce(tester, answers);
    });
  }

  testWidgets('word grid traces adjacent CAT cells and completes once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(WordGridGameView(
      accent: Colors.green,
      compact: false,
      correctAnswer: _sentinel,
      semanticLabel: 'word grid',
      onAnswerSelected: answers.add,
    )));
    final surface = find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.onPanStart != null,
    );
    await _dragPoints(
      tester,
      surface,
      [0, 1, 5].map((cell) => _gridCenter(cell, top: 81)).toList(),
    );
    await _expectOnce(tester, answers);
  });

  testWidgets('animal word drags all three correct units and completes once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(AnimalWordGameView(
      accent: Colors.orange,
      compact: false,
      correctAnswer: _sentinel,
      semanticLabel: 'animal word',
      onAnswerSelected: answers.add,
    )));
    await _drag(tester, _draggables.at(3), _dragTargets.at(0));
    expect(answers, isEmpty);
    await _drag(tester, _draggables.at(0), _dragTargets.at(1));
    expect(answers, isEmpty);
    await _drag(tester, _draggables.at(1), _dragTargets.at(2));
    await _expectOnce(tester, answers);
  });

  testWidgets('code grid traces full circuit route and completes once',
      (tester) async {
    final answers = <String>[];
    const routeGestureKey = ValueKey('code-grid-route-gesture');
    await tester.pumpWidget(_harness(CodeGridGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _sentinel,
      semanticLabel: 'code grid',
      onAnswerSelected: answers.add,
      routeGestureKey: routeGestureKey,
    )));
    await tester.pump(const Duration(milliseconds: 300));

    final surface = find.byKey(routeGestureKey);
    final sceneSize = tester.getSize(surface);
    final cell = math.min(
      (sceneSize.width - 68) / 6,
      (sceneSize.height - 24) / 5,
    );
    final left = (sceneSize.width - cell * 6) / 2;
    final top = sceneSize.height / 2 + 2 - cell * 5 / 2;
    const route = [(0, 4), (1, 4), (1, 3), (2, 3), (2, 2), (3, 2), (3, 1)];
    final centers = route
        .map((point) => Offset(
              left + (point.$1 + 0.5) * cell,
              top + (point.$2 + 0.5) * cell,
            ))
        .toList();
    final denseRoute = <Offset>[centers.first];
    for (var index = 1; index < centers.length; index++) {
      final from = centers[index - 1];
      final to = centers[index];
      for (var step = 1; step <= 5; step++) {
        denseRoute.add(Offset.lerp(from, to, step / 5)!);
      }
    }
    await _dragPoints(tester, surface, denseRoute);
    await _expectOnce(tester, answers);
  });

  testWidgets('why chain places battery fan and cart then completes once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(WhyChainGameView(
      accent: Colors.purple,
      compact: false,
      correctAnswer: _sentinel,
      semanticLabel: 'why chain',
      onAnswerSelected: answers.add,
    )));
    for (var slot = 0; slot < 3; slot++) {
      await _drag(tester, _draggables.at(0), _dragTargets.at(slot));
      if (slot < 2) expect(answers, isEmpty);
    }
    await _expectOnce(tester, answers, wait: const Duration(seconds: 2));
  });

  testWidgets('space proof places two bans before capsule and completes once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(SpaceProofGameView(
      accent: Colors.deepPurple,
      compact: false,
      correctAnswer: _sentinel,
      semanticLabel: 'space proof',
      onAnswerSelected: answers.add,
    )));
    final surface = find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.onPanStart != null,
    );
    const scale = 1.025;
    const origin = Offset(25.5, 0);
    Offset board(Offset point) => origin + point * scale;
    await _dragPoints(tester, surface,
        [board(const Offset(80, 202)), board(const Offset(72, 105))]);
    expect(answers, isEmpty);
    await _dragPoints(tester, surface,
        [board(const Offset(280, 202)), board(const Offset(288, 105))]);
    expect(answers, isEmpty);
    await _dragPoints(tester, surface,
        [board(const Offset(180, 202)), board(const Offset(180, 105))]);
    await _expectOnce(tester, answers);
  });

  testWidgets('home clues assigns all residents and completes once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(HomeCluesGameView(
      accent: Colors.pink,
      compact: false,
      correctAnswer: _sentinel,
      semanticLabel: 'home clues',
      onAnswerSelected: answers.add,
    )));
    await _drag(tester, _draggables.at(1), _dragTargets.at(0));
    expect(answers, isEmpty);
    await _drag(tester, _draggables.at(1), _dragTargets.at(1));
    expect(answers, isEmpty);
    await _drag(tester, _draggables.at(0), _dragTargets.at(2));
    await _expectOnce(tester, answers);
  });
}
