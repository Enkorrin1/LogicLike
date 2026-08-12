import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/code_grid_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/word_grid_game.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

const _answer = 'trace-answer';
const _locales = [
  'ar',
  'de',
  'en',
  'es',
  'fr',
  'hi',
  'it',
  'ja',
  'ko',
  'pt',
  'ru',
  'zh',
];

Widget _harness(Widget child, {String languageCode = 'en'}) => MaterialApp(
      locale: Locale(languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: child)),
      ),
    );

Offset _wordCenter(Size sceneSize, int index) {
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

double _wordCellSize(Size sceneSize) {
  const headerHeight = 68.0;
  return math.min(
        math.min(
          sceneSize.width - 26,
          sceneSize.height - headerHeight - 14,
        ),
        224.0,
      ) /
      5;
}

Offset _codeCenter(Size sceneSize, math.Point<int> point) {
  final cell = _codeCellSize(sceneSize);
  return Offset(
    (sceneSize.width - cell * 6) / 2 + (point.x + .5) * cell,
    14 + (point.y + .5) * cell,
  );
}

double _codeCellSize(Size sceneSize) => math.min(
      (sceneSize.width - 60) / 6,
      (sceneSize.height * .68 - 20) / 5,
    );

Offset _codeKeyCenter(Size sceneSize, int index) {
  final boardBottom = 14 + _codeCellSize(sceneSize) * 5;
  final codeTop = boardBottom + 9;
  final codeHeight = sceneSize.height - boardBottom - 15;
  const gap = 6.0;
  final keyWidth = (sceneSize.width - 40 - gap * 4) / 5;
  return Offset(
    20 + index * (keyWidth + gap) + keyWidth / 2,
    codeTop + codeHeight / 2,
  );
}

Future<void> _trace(
  WidgetTester tester,
  Finder surface,
  List<Offset> points,
  double cellSize,
) async {
  final origin = tester.getTopLeft(surface);
  final direction = points.length > 1
      ? (points[1] - points.first) / (points[1] - points.first).distance
      : const Offset(1, 0);
  final start = points.first - direction * cellSize * .42;
  final warmup = points.first + direction * cellSize * .10;
  final gesture = await tester.startGesture(origin + start);
  await gesture.moveTo(origin + warmup);
  await tester.pump(const Duration(milliseconds: 40));
  for (final point in points.skip(1)) {
    await gesture.moveTo(origin + point);
    await tester.pump(const Duration(milliseconds: 45));
  }
  await gesture.up();
  await tester.pump();
}

CustomPainter _painter(WidgetTester tester, Type gameType) => tester
    .widget<CustomPaint>(
      find.descendant(
        of: find.byType(gameType),
        matching: find.byType(CustomPaint),
      ),
    )
    .painter!;

void main() {
  test('word grid exposes all 12 product locales', () {
    expect(wordGridSupportedLanguageCodes, _locales.toSet());
  });

  for (final locale in _locales) {
    testWidgets('word grid $locale rejects errors and finds three words once',
        (tester) async {
      final answers = <String>[];
      const surfaceKey = ValueKey('word-grid-surface');
      await tester.pumpWidget(_harness(
        WordGridGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _answer,
          semanticLabel: 'word grid',
          onAnswerSelected: answers.add,
          routeGestureKey: surfaceKey,
        ),
        languageCode: locale,
      ));
      final surface = find.byKey(surfaceKey);
      final sceneSize = tester.getSize(surface);
      final expectedDirection =
          locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
      expect(
        find.descendant(
          of: find.byType(WordGridGameView),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Directionality &&
                widget.textDirection == expectedDirection,
          ),
        ),
        findsWidgets,
      );

      await _trace(
        tester,
        surface,
        [24, 19].map((cell) => _wordCenter(sceneSize, cell)).toList(),
        _wordCellSize(sceneSize),
      );
      expect((_painter(tester, WordGridGameView) as dynamic).error, isTrue);
      expect(answers, isEmpty);
      await tester.pump(const Duration(milliseconds: 450));

      final routes = wordGridRoutesForLanguageCode(locale);
      for (var index = 0; index < routes.length; index++) {
        await _trace(
          tester,
          surface,
          routes[index].map((cell) => _wordCenter(sceneSize, cell)).toList(),
          _wordCellSize(sceneSize),
        );
        expect(
          (_painter(tester, WordGridGameView) as dynamic).foundWords.length,
          index + 1,
        );
        if (index == 0) {
          await _trace(
            tester,
            surface,
            routes[index].map((cell) => _wordCenter(sceneSize, cell)).toList(),
            _wordCellSize(sceneSize),
          );
          expect(
            (_painter(tester, WordGridGameView) as dynamic).foundWords.length,
            1,
          );
          expect((_painter(tester, WordGridGameView) as dynamic).error, isTrue);
          await tester.pump(const Duration(milliseconds: 450));
        }
        if (index < routes.length - 1) expect(answers, isEmpty);
      }
      await tester.pump(const Duration(milliseconds: 701));
      expect(answers, [_answer]);
      await tester.pump(const Duration(seconds: 2));
      expect(answers, [_answer]);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
      'code grid rejects wrong route and wrong code then completes once',
      (tester) async {
    final answers = <String>[];
    const surfaceKey = ValueKey('code-grid-surface');
    await tester.pumpWidget(_harness(CodeGridGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'code grid',
      onAnswerSelected: answers.add,
      routeGestureKey: surfaceKey,
    )));
    final surface = find.byKey(surfaceKey);
    final sceneSize = tester.getSize(surface);

    await _trace(
      tester,
      surface,
      [const math.Point(0, 0), const math.Point(0, 1)]
          .map((point) => _codeCenter(sceneSize, point))
          .toList(),
      _codeCellSize(sceneSize),
    );
    expect((_painter(tester, CodeGridGameView) as dynamic).error, isTrue);
    expect((_painter(tester, CodeGridGameView) as dynamic).completedRoutes, 0);
    await tester.pump(const Duration(milliseconds: 450));

    for (var index = 0; index < codeGridRoutes.length; index++) {
      await _trace(
        tester,
        surface,
        codeGridRoutes[index]
            .map((point) => _codeCenter(sceneSize, point))
            .toList(),
        _codeCellSize(sceneSize),
      );
      expect(
        (_painter(tester, CodeGridGameView) as dynamic).completedRoutes,
        index + 1,
      );
      expect(answers, isEmpty);
    }
    expect((_painter(tester, CodeGridGameView) as dynamic).codePhase, isTrue);

    await tester.tapAt(
      tester.getTopLeft(surface) + _codeKeyCenter(sceneSize, 0),
    );
    await tester.pump();
    expect((_painter(tester, CodeGridGameView) as dynamic).error, isTrue);
    expect((_painter(tester, CodeGridGameView) as dynamic).codeInput, isEmpty);
    await tester.pump(const Duration(milliseconds: 450));

    const keypad = [3, 6, 8, 1, 5];
    for (final digit in codeGridExtractedCode) {
      await tester.tapAt(
        tester.getTopLeft(surface) +
            _codeKeyCenter(sceneSize, keypad.indexOf(digit)),
      );
      await tester.pump();
    }
    await tester.pump(const Duration(milliseconds: 721));
    expect(answers, [_answer]);
    await tester.tapAt(
      tester.getTopLeft(surface) + _codeKeyCenter(sceneSize, 1),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(answers, [_answer]);
    expect(tester.takeException(), isNull);
  });
}
