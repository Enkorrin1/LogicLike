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
const _localeCases = <String,
    ({
  List<int> wordTiles,
  List<int> firstRoute,
  List<int> secondRoute,
})>{
  'ar': (
    wordTiles: [2, 0, 1],
    firstRoute: [0, 1, 5, 4],
    secondRoute: [10, 11, 15],
  ),
  'de': (
    wordTiles: [2, 3, 0, 1],
    firstRoute: [1, 2, 6, 10, 9],
    secondRoute: [4, 8, 9, 13],
  ),
  'en': (
    wordTiles: [2, 3, 0, 1],
    firstRoute: [2, 3, 7, 6],
    secondRoute: [12, 8, 9],
  ),
  'es': (
    wordTiles: [2, 3, 0, 1],
    firstRoute: [5, 1, 2, 6],
    secondRoute: [14, 10, 11],
  ),
  'fr': (
    wordTiles: [2, 3, 0, 1],
    firstRoute: [15, 14, 10, 6, 7],
    secondRoute: [0, 4, 5, 9],
  ),
  'hi': (
    wordTiles: [1, 0],
    firstRoute: [3, 7],
    secondRoute: [8, 12],
  ),
  'it': (
    wordTiles: [2, 3, 0, 1],
    firstRoute: [4, 5, 1, 2, 6],
    secondRoute: [11, 10, 14, 13],
  ),
  'ja': (
    wordTiles: [1, 0],
    firstRoute: [6, 10],
    secondRoute: [9, 5],
  ),
  'ko': (
    wordTiles: [1, 0],
    firstRoute: [13, 14],
    secondRoute: [7],
  ),
  'pt': (
    wordTiles: [1, 2, 0],
    firstRoute: [8, 4, 0, 1, 5],
    secondRoute: [3, 2, 6],
  ),
  'ru': (
    wordTiles: [2, 3, 0, 1],
    firstRoute: [9, 10, 6, 5],
    secondRoute: [0, 4, 8],
  ),
  'zh': (
    wordTiles: [1, 0],
    firstRoute: [11, 15],
    secondRoute: [2],
  ),
};

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
  await gesture.moveTo(
    origin + localPoints.first + const Offset(20, 0),
    timeStamp: const Duration(milliseconds: 40),
  );
  await tester.pump(const Duration(milliseconds: 40));
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

Future<void> _traceCodeRoute(
  WidgetTester tester,
  Finder surface,
  List<Offset> points,
  double cellSize,
) async {
  final origin = tester.getTopLeft(surface);
  final direction =
      (points[1] - points.first) / (points[1] - points.first).distance;
  final gesture = await tester.startGesture(
    origin + points.first - direction * cellSize * .42,
  );
  await gesture.moveTo(
    origin + points.first + direction * cellSize * .10,
  );
  await tester.pump(const Duration(milliseconds: 40));
  for (final point in points.skip(1)) {
    await gesture.moveTo(origin + point);
    await tester.pump(const Duration(milliseconds: 45));
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

Offset _wordGridCenter(Size sceneSize, int index) {
  const headerHeight = 68.0;
  final available = math.min(
    sceneSize.width - 26,
    sceneSize.height - headerHeight - 14,
  );
  final boardSize = math.min(available, 224.0);
  final cell = boardSize / 5;
  return Offset(
    (sceneSize.width - boardSize) / 2 + (index % 5 + .5) * cell,
    headerHeight + 5 + (index ~/ 5 + .5) * cell,
  );
}

Offset _codeGridCenter(Size sceneSize, math.Point<int> point) {
  final boardHeight = sceneSize.height * .68;
  final cell = math.min(
    (sceneSize.width - 60) / 6,
    (boardHeight - 20) / 5,
  );
  return Offset(
    (sceneSize.width - cell * 6) / 2 + (point.x + .5) * cell,
    14 + (point.y + .5) * cell,
  );
}

Offset _codeGridKeyCenter(Size sceneSize, int keyIndex) {
  final boardHeight = sceneSize.height * .68;
  final cell = math.min(
    (sceneSize.width - 60) / 6,
    (boardHeight - 20) / 5,
  );
  final boardBottom = 14 + cell * 5;
  final codeTop = boardBottom + 9;
  final codeHeight = sceneSize.height - boardBottom - 15;
  const gap = 6.0;
  final keyWidth = (sceneSize.width - 40 - gap * 4) / 5;
  return Offset(
    20 + keyIndex * (keyWidth + gap) + keyWidth / 2,
    codeTop + codeHeight / 2,
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
  test('word games expose exactly the 12 product locales', () {
    expect(wordBuilderSupportedLanguageCodes, _localeCases.keys.toSet());
    expect(letterFieldSupportedLanguageCodes, _localeCases.keys.toSet());
  });

  for (final entry in _localeCases.entries) {
    final locale = entry.key;
    final localeCase = entry.value;
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
      final expectedDirection =
          locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
      expect(
        find.descendant(
          of: find.byType(LocaleWordBuilderGameView),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Directionality &&
                widget.textDirection == expectedDirection,
          ),
        ),
        findsWidgets,
      );
      for (var slot = 0; slot < localeCase.wordTiles.length; slot++) {
        final source = find.byWidgetPredicate(
          (widget) =>
              widget is Draggable<int> &&
              widget.data == localeCase.wordTiles[slot],
        );
        await _drag(tester, source, _dragTargets.at(slot));
        if (slot < localeCase.wordTiles.length - 1) expect(answers, isEmpty);
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
      expect(tester.getSize(surface), const Size(420, 316));
      final expectedDirection =
          locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
      expect(
        find.descendant(
          of: find.byType(LocaleLetterFieldGameView),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Directionality &&
                widget.textDirection == expectedDirection,
          ),
        ),
        findsWidgets,
      );
      final initialPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(LocaleLetterFieldGameView),
          matching: find.byType(CustomPaint),
        ),
      );
      final initialPainter = initialPaint.painter as dynamic;
      expect(
        localeCase.firstRoute
            .map((cell) => initialPainter.data.grid[cell])
            .toList(),
        initialPainter.data.target,
      );
      await _dragPoints(
        tester,
        surface,
        localeCase.firstRoute
            .map((cell) => _gridCenter(cell, top: 75))
            .toList(),
      );
      final firstRoundPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(LocaleLetterFieldGameView),
          matching: find.byType(CustomPaint),
        ),
      );
      expect(
        (firstRoundPaint.painter as dynamic).matched,
        localeCase.firstRoute.length,
      );
      expect((firstRoundPaint.painter as dynamic).complete, isTrue);
      expect(answers, isEmpty);
      await tester.pump(const Duration(milliseconds: 821));
      await _dragPoints(
        tester,
        surface,
        localeCase.secondRoute
            .map((cell) => _gridCenter(cell, top: 75))
            .toList(),
      );
      final secondRoundPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(LocaleLetterFieldGameView),
          matching: find.byType(CustomPaint),
        ),
      );
      expect((secondRoundPaint.painter as dynamic).complete, isTrue);
      await _expectOnce(tester, answers);
    });
  }

  testWidgets('letter field resets a wrong trail and exposes letter actions',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(LocaleLetterFieldGameView(
      accent: Colors.indigo,
      compact: false,
      correctAnswer: _sentinel,
      semanticLabel: 'letter field',
      onAnswerSelected: answers.add,
    )));
    final surface = find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.onPanStart != null,
    );
    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(LocaleLetterFieldGameView),
        matching: find.byType(CustomPaint),
      ),
    );
    final painter = paint.painter as dynamic;
    expect(painter.semanticsBuilder(const Size(420, 316)), hasLength(16));

    await tester.tapAt(
      tester.getTopLeft(surface) + _gridCenter(0, top: 75),
    );
    await tester.pump(const Duration(milliseconds: 361));
    final afterError = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(LocaleLetterFieldGameView),
        matching: find.byType(CustomPaint),
      ),
    );
    expect((afterError.painter as dynamic).matched, 0);
    expect(answers, isEmpty);
  });
  testWidgets('word grid keeps three found routes and completes once',
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
    final sceneSize = tester.getSize(surface);
    final routes = wordGridRoutesForLanguageCode('en');
    for (var index = 0; index < routes.length; index++) {
      await _dragPoints(
        tester,
        surface,
        routes[index].map((cell) => _wordGridCenter(sceneSize, cell)).toList(),
      );
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(WordGridGameView),
          matching: find.byType(CustomPaint),
        ),
      );
      expect((paint.painter as dynamic).foundWords.length, index + 1);
      if (index < routes.length - 1) expect(answers, isEmpty);
    }
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

  testWidgets('code grid solves three chains then extracts code once',
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
    final cellSize = math.min(
      (sceneSize.width - 60) / 6,
      (sceneSize.height * .68 - 20) / 5,
    );
    for (var index = 0; index < codeGridRoutes.length; index++) {
      await _traceCodeRoute(
        tester,
        surface,
        codeGridRoutes[index]
            .map((cell) => _codeGridCenter(sceneSize, cell))
            .toList(),
        cellSize,
      );
      expect(answers, isEmpty);
    }
    const keypad = [3, 6, 8, 1, 5];
    for (final digit in codeGridExtractedCode) {
      await tester.tapAt(
        tester.getTopLeft(surface) +
            _codeGridKeyCenter(sceneSize, keypad.indexOf(digit)),
      );
      await tester.pump();
    }
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
