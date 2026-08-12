import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/code_grid_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/logic_mechanics_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/sequence_workshop_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/word_grid_game.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

const _answer = 'accessible-complete';
const _localeMarkers = <String, List<String>>{
  'ar': ['تم العثور على', 'المسار', 'الجولة', 'المرحلة'],
  'de': ['Gefunden', 'Route', 'Runde', 'Phase'],
  'en': ['Found', 'Route', 'Round', 'Stage'],
  'es': ['Encontradas', 'Ruta', 'Ronda', 'Etapa'],
  'fr': ['Trouvés', 'Parcours', 'Manche', 'Étape'],
  'hi': ['मिले', 'रास्ता', 'दौर', 'चरण'],
  'it': ['Trovate', 'Percorso', 'Turno', 'Fase'],
  'ja': ['見つけた単語', 'ルート', 'ラウンド', 'ステージ'],
  'ko': ['찾은 단어', '경로', '라운드', '단계'],
  'pt': ['Encontradas', 'Rota', 'Rodada', 'Etapa'],
  'ru': ['Найдено', 'Маршрут', 'Раунд', 'Этап'],
  'zh': ['已找到', '路径', '回合', '阶段'],
};

Widget _harness(Widget child, {String locale = 'en'}) => MaterialApp(
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: child)),
      ),
    );

Future<void> _semanticAction(
  WidgetTester tester,
  Finder finder,
  SemanticsAction action,
) async {
  final node = tester.getSemantics(finder);
  expect(node.getSemanticsData().hasAction(action), isTrue);
  // The widget-test view still dispatches semantics through this owner.
  // ignore: deprecated_member_use
  tester.binding.pipelineOwner.semanticsOwner!.performAction(node.id, action);
  await tester.pump();
}

Future<int> _chooseIndex(
  WidgetTester tester,
  Finder finder,
  int current,
  int target,
  int count,
) async {
  final steps = (target - current) % count;
  for (var index = 0; index < steps; index++) {
    await _semanticAction(tester, finder, SemanticsAction.increase);
  }
  await _semanticAction(tester, finder, SemanticsAction.tap);
  return target;
}

void main() {
  testWidgets('word grid completes three words using semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(WordGridGameView(
      accent: Colors.teal,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'Accessible word grid',
      onAnswerSelected: answers.add,
    )));

    final control = find.byKey(const ValueKey('word-grid-semantics'));
    var cursor = 0;
    var completedWords = 0;
    for (final route in wordGridRoutesForLanguageCode('en')) {
      for (final cell in route) {
        cursor = await _chooseIndex(tester, control, cursor, cell, 25);
      }
      completedWords++;
      expect(
        tester.getSemantics(control).getSemanticsData().value,
        contains('Found $completedWords of 3'),
      );
    }
    await tester.pump(const Duration(milliseconds: 701));

    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  testWidgets('code grid completes three routes and code using semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(CodeGridGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'Accessible code grid',
      onAnswerSelected: answers.add,
    )));

    final control = find.byKey(const ValueKey('code-grid-semantics'));
    var cursor = 0;
    for (final route in codeGridRoutes) {
      for (final cell in route) {
        final index = cell.y * 6 + cell.x;
        cursor = await _chooseIndex(tester, control, cursor, index, 30);
      }
    }

    cursor = 0;
    const keypad = [3, 6, 8, 1, 5];
    for (final digit in codeGridExtractedCode) {
      cursor = await _chooseIndex(
        tester,
        control,
        cursor,
        keypad.indexOf(digit),
        keypad.length,
      );
    }
    await tester.pump(const Duration(milliseconds: 721));

    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  testWidgets('moon clock completes all three times using semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(MoonClockGameView(
      accent: Colors.indigo,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'Accessible moon clock',
      onAnswerSelected: answers.add,
    )));

    final control = find.byKey(const ValueKey('moon-clock-semantics'));
    for (final decreases in const [7, 7, 5]) {
      for (var index = 0; index < decreases; index++) {
        await _semanticAction(tester, control, SemanticsAction.decrease);
      }
      await _semanticAction(tester, control, SemanticsAction.tap);
      await tester.pump(const Duration(milliseconds: 561));
    }

    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  testWidgets('odd card completes every stage using semantics only',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(_harness(OddCardInvestigationGameView(
      accent: Colors.purple,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'Accessible odd card',
      onAnswerSelected: answers.add,
    )));

    final control = find.byKey(const ValueKey('odd-card-semantics'));
    var cursor = 0;
    for (final evidence in const [0, 2, 5]) {
      cursor = await _chooseIndex(tester, control, cursor, evidence, 7);
    }
    await _chooseIndex(tester, control, cursor, 6, 7);
    await tester.pumpAndSettle();

    await _semanticAction(tester, control, SemanticsAction.increase);
    await _semanticAction(tester, control, SemanticsAction.tap);
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pumpAndSettle();

    for (var index = 0; index < 4; index++) {
      final follows = index == 0 || index == 2;
      if (!follows) {
        await _semanticAction(tester, control, SemanticsAction.increase);
      }
      expect(
        tester.getSemantics(control).getSemanticsData().hasAction(
              SemanticsAction.tap,
            ),
        isTrue,
        reason: 'classification $index must be actionable',
      );
      await _semanticAction(tester, control, SemanticsAction.tap);
      await tester.pump(const Duration(milliseconds: 370));
      await tester.pumpAndSettle();
    }

    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
    semantics.dispose();
  });

  for (final entry in _localeMarkers.entries) {
    testWidgets('semantic progress and actions are localized for ${entry.key}',
        (tester) async {
      final semantics = tester.ensureSemantics();
      final markers = entry.value;

      await tester.pumpWidget(_harness(
        WordGridGameView(
          accent: Colors.teal,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'word grid',
          onAnswerSelected: (_) {},
        ),
        locale: entry.key,
      ));
      var data = tester
          .getSemantics(find.byKey(const ValueKey('word-grid-semantics')))
          .getSemanticsData();
      expect(data.value, contains(markers[0]));
      expect(data.hasAction(SemanticsAction.increase), isTrue);
      expect(data.hasAction(SemanticsAction.decrease), isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);

      await tester.pumpWidget(_harness(
        CodeGridGameView(
          accent: Colors.cyan,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'code grid',
          onAnswerSelected: (_) {},
        ),
        locale: entry.key,
      ));
      data = tester
          .getSemantics(find.byKey(const ValueKey('code-grid-semantics')))
          .getSemanticsData();
      expect(data.value, contains(markers[1]));
      expect(data.hasAction(SemanticsAction.increase), isTrue);
      expect(data.hasAction(SemanticsAction.decrease), isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);

      await tester.pumpWidget(_harness(
        MoonClockGameView(
          accent: Colors.indigo,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'moon clock',
          onAnswerSelected: (_) {},
        ),
        locale: entry.key,
      ));
      data = tester
          .getSemantics(find.byKey(const ValueKey('moon-clock-semantics')))
          .getSemanticsData();
      expect(data.value, contains(markers[2]));
      expect(data.hasAction(SemanticsAction.increase), isTrue);
      expect(data.hasAction(SemanticsAction.decrease), isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);

      await tester.pumpWidget(_harness(
        OddCardInvestigationGameView(
          accent: Colors.purple,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'odd card',
          onAnswerSelected: (_) {},
        ),
        locale: entry.key,
      ));
      data = tester
          .getSemantics(find.byKey(const ValueKey('odd-card-semantics')))
          .getSemanticsData();
      expect(data.label, contains(markers[3]));
      expect(data.hasAction(SemanticsAction.increase), isTrue);
      expect(data.hasAction(SemanticsAction.decrease), isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });
  }

  testWidgets('Arabic semantics are localized and use RTL', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_harness(
      WordGridGameView(
        accent: Colors.teal,
        compact: true,
        correctAnswer: _answer,
        semanticLabel: 'شبكة الكلمات',
        onAnswerSelected: (_) {},
      ),
      locale: 'ar',
    ));

    var data = tester
        .getSemantics(find.byKey(const ValueKey('word-grid-semantics')))
        .getSemanticsData();
    expect(data.value, contains('تم العثور على'));
    expect(data.hint, contains('اسحب لأعلى أو لأسفل'));
    expect(data.textDirection, TextDirection.rtl);

    await tester.pumpWidget(_harness(
      CodeGridGameView(
        accent: Colors.cyan,
        compact: true,
        correctAnswer: _answer,
        semanticLabel: 'شبكة الرمز',
        onAnswerSelected: (_) {},
      ),
      locale: 'ar',
    ));
    data = tester
        .getSemantics(find.byKey(const ValueKey('code-grid-semantics')))
        .getSemanticsData();
    expect(data.value, contains('المسار'));
    expect(data.hint, contains('استكشاف الخلايا'));
    expect(data.textDirection, TextDirection.rtl);

    await tester.pumpWidget(_harness(
      MoonClockGameView(
        accent: Colors.indigo,
        compact: true,
        correctAnswer: _answer,
        semanticLabel: 'ساعة القمر',
        onAnswerSelected: (_) {},
      ),
      locale: 'ar',
    ));
    data = tester
        .getSemantics(find.byKey(const ValueKey('moon-clock-semantics')))
        .getSemanticsData();
    expect(data.value, contains('الوقت المطلوب'));
    expect(data.textDirection, TextDirection.rtl);

    await tester.pumpWidget(_harness(
      OddCardInvestigationGameView(
        accent: Colors.purple,
        compact: true,
        correctAnswer: _answer,
        semanticLabel: 'البطاقة المختلفة',
        onAnswerSelected: (_) {},
      ),
      locale: 'ar',
    ));
    data = tester
        .getSemantics(find.byKey(const ValueKey('odd-evidence-card-0')))
        .getSemanticsData();
    expect(data.label, contains('بطاقة دليل'));
    expect(data.hint, contains('انقر مرتين'));
    expect(data.textDirection, TextDirection.rtl);
    expect(
      find.descendant(
        of: find.byType(OddCardInvestigationGameView),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Directionality &&
              widget.textDirection == TextDirection.rtl,
        ),
      ),
      findsWidgets,
    );
    semantics.dispose();
  });
}
