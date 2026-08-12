import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/camp_story_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/route_memory_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/shadow_match_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/what_changed_game.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

const _answer = 'accessible-canvas-complete';

Widget _harness(Widget game, {String languageCode = 'en'}) => MaterialApp(
      locale: Locale(languageCode),
      supportedLocales: const [
        Locale('ar'),
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('hi'),
        Locale('it'),
        Locale('ja'),
        Locale('ko'),
        Locale('pt'),
        Locale('ru'),
        Locale('zh'),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: game)),
      ),
    );

void _semanticTap(WidgetTester tester, String label) {
  final target = find.semantics.byLabel(label);
  expect(target, findsOneWidget, reason: 'Missing semantic action: $label');
  tester.semantics.tap(target);
}

Future<void> _waitForSemanticLabel(
  WidgetTester tester,
  String label, {
  int frames = 40,
}) async {
  final finder = find.semantics.byLabel(label);
  for (var frame = 0; frame < frames && finder.evaluate().isEmpty; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(finder, findsOneWidget, reason: 'Missing semantic action: $label');
}

Future<void> _waitForWidgetKey(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  for (var frame = 0; frame < 30 && finder.evaluate().isEmpty; frame++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(finder, findsOneWidget, reason: 'Missing state key: $key');
}

void main() {
  testWidgets(
      'camp story supports error and every restore step through semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(CampStoryGameView(
      accent: Colors.amber,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'Camp story',
      onAnswerSelected: answers.add,
    )));
    await _waitForSemanticLabel(tester, 'Boot');

    _semanticTap(tester, 'Boot');
    await tester.pump(const Duration(milliseconds: 420));
    expect(answers, isEmpty);
    expect(
        find.semantics.byLabel(RegExp('not the next object')), findsOneWidget);

    for (final item in const ['Compass', 'Map', 'Lantern']) {
      await _waitForSemanticLabel(tester, item);
      _semanticTap(tester, item);
      await tester.pump(const Duration(milliseconds: 850));
      expect(find.semantics.byLabel(item), findsNothing,
          reason: '$item semantic action did not advance the game');
    }
    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  testWidgets(
      'route memory supports retry and all route cells through semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(RouteMemoryGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'Route memory',
      onAnswerSelected: answers.add,
    )));
    await _waitForSemanticLabel(tester, 'Row 4, column 1');

    _semanticTap(tester, 'Row 4, column 2');
    await tester.pump();
    expect(answers, isEmpty);
    expect(find.semantics.byLabel(RegExp('Wrong cell')), findsOneWidget);
    await _waitForSemanticLabel(tester, 'Row 4, column 1');

    const routes = [
      [12, 8, 9, 5, 6],
      [3, 2, 6, 10, 9, 13],
      [0, 4, 5, 6, 10, 14, 15],
    ];
    for (final route in routes) {
      for (final cell in route) {
        final label = 'Row ${cell ~/ 4 + 1}, column ${cell % 4 + 1}';
        await _waitForSemanticLabel(tester, label);
        _semanticTap(tester, label);
        await tester.pump();
      }
      await tester.pump(const Duration(milliseconds: 1300));
    }
    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  testWidgets(
      'shadow match supports error and three matches through semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(ShadowMatchGameView(
      accent: Colors.teal,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'Shadow match',
      onAnswerSelected: answers.add,
    )));

    _semanticTap(tester, 'Shadow 1');
    await tester.pump();
    expect(answers, isEmpty);
    expect(find.semantics.byLabel(RegExp('not the correct shadow')),
        findsOneWidget);
    await tester.pump(const Duration(milliseconds: 560));

    var expectedRound = 1;
    for (final shadow in const ['Shadow 2', 'Shadow 1', 'Shadow 3']) {
      _semanticTap(tester, shadow);
      if (expectedRound < 3) {
        await _waitForWidgetKey(
          tester,
          'shadow-semantic-round-$expectedRound-ready',
        );
      } else {
        for (var frame = 0; frame < 12 && answers.isEmpty; frame++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
      }
      expectedRound++;
    }
    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  testWidgets(
      'what changed supports error and every lab action through semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(WhatChangedGameView(
      accent: Colors.pink,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'What changed',
      onAnswerSelected: answers.add,
    )));
    await _waitForSemanticLabel(tester, 'flask');

    _semanticTap(tester, 'dial');
    await tester.pump();
    expect(answers, isEmpty);
    expect(find.semantics.byLabel(RegExp('did not change')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 560));

    _semanticTap(tester, 'flask');
    await tester.pump();
    await _waitForSemanticLabel(tester, 'dial');
    for (var turn = 0; turn < 3; turn++) {
      _semanticTap(tester, 'dial');
      await tester.pump();
    }
    await _waitForSemanticLabel(tester, 'test tubes');
    _semanticTap(tester, 'test tubes');
    for (var frame = 0; frame < 12 && answers.isEmpty; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  testWidgets('Arabic semantics are localized and use RTL', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(_harness(
      CampStoryGameView(
        accent: Colors.amber,
        compact: false,
        correctAnswer: _answer,
        semanticLabel: 'قصة المخيم',
        onAnswerSelected: (_) {},
      ),
      languageCode: 'ar',
    ));
    await _waitForSemanticLabel(tester, 'البوصلة');
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('camp-semantic-compass')),
          )
          .textDirection,
      TextDirection.rtl,
    );

    await tester.pumpWidget(_harness(
      RouteMemoryGameView(
        accent: Colors.cyan,
        compact: false,
        correctAnswer: _answer,
        semanticLabel: 'ذاكرة المسار',
        onAnswerSelected: (_) {},
      ),
      languageCode: 'ar',
    ));
    await _waitForSemanticLabel(tester, 'الصف 4، العمود 1');
    expect(find.semantics.byLabel('الصف 4، العمود 1'), findsOneWidget);

    await tester.pumpWidget(_harness(
      ShadowMatchGameView(
        accent: Colors.teal,
        compact: false,
        correctAnswer: _answer,
        semanticLabel: 'مطابقة الظل',
        onAnswerSelected: (_) {},
      ),
      languageCode: 'ar',
    ));
    expect(find.semantics.byLabel('الظل 1'), findsOneWidget);

    await tester.pumpWidget(_harness(
      WhatChangedGameView(
        accent: Colors.pink,
        compact: false,
        correctAnswer: _answer,
        semanticLabel: 'ما الذي تغيّر',
        onAnswerSelected: (_) {},
      ),
      languageCode: 'ar',
    ));
    await _waitForSemanticLabel(tester, 'الدورق');
    expect(find.semantics.byLabel('الدورق'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('all 12 locales expose localized canvas actions', (tester) async {
    final semantics = tester.ensureSemantics();
    const labels = <String, (String, String, String, String)>{
      'ar': ('البوصلة', 'الصف 4، العمود 1', 'الظل 1', 'الدورق'),
      'de': ('Kompass', 'Zeile 4, Spalte 1', 'Schatten 1', 'Kolben'),
      'en': ('Compass', 'Row 4, column 1', 'Shadow 1', 'flask'),
      'es': ('Brújula', 'Fila 4, columna 1', 'Sombra 1', 'matraz'),
      'fr': ('Boussole', 'Ligne 4, colonne 1', 'Ombre 1', 'fiole'),
      'hi': ('दिशासूचक', 'पंक्ति 4, स्तंभ 1', 'छाया 1', 'फ्लास्क'),
      'it': ('Bussola', 'Riga 4, colonna 1', 'Ombra 1', 'beuta'),
      'ja': ('コンパス', '4行1列', '影1', 'フラスコ'),
      'ko': ('나침반', '4행 1열', '그림자 1', '플라스크'),
      'pt': ('Bússola', 'Linha 4, coluna 1', 'Sombra 1', 'frasco'),
      'ru': ('Компас', 'Строка 4, столбец 1', 'Тень 1', 'колба'),
      'zh': ('指南针', '第 4 行，第 1 列', '影子 1', '烧瓶'),
    };

    for (final entry in labels.entries) {
      final locale = entry.key;
      final expected = entry.value;
      await tester.pumpWidget(_harness(
        CampStoryGameView(
          accent: Colors.amber,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'camp',
          onAnswerSelected: (_) {},
        ),
        languageCode: locale,
      ));
      await _waitForSemanticLabel(tester, expected.$1);

      await tester.pumpWidget(_harness(
        RouteMemoryGameView(
          accent: Colors.cyan,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'route',
          onAnswerSelected: (_) {},
        ),
        languageCode: locale,
      ));
      await _waitForSemanticLabel(tester, expected.$2);

      await tester.pumpWidget(_harness(
        ShadowMatchGameView(
          accent: Colors.teal,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'shadow',
          onAnswerSelected: (_) {},
        ),
        languageCode: locale,
      ));
      expect(find.semantics.byLabel(expected.$3), findsOneWidget);

      await tester.pumpWidget(_harness(
        WhatChangedGameView(
          accent: Colors.pink,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'changed',
          onAnswerSelected: (_) {},
        ),
        languageCode: locale,
      ));
      await _waitForSemanticLabel(tester, expected.$4);
    }
    semantics.dispose();
  });
}
