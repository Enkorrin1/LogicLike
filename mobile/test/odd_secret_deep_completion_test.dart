import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/logic_mechanics_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/sequence_workshop_games.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

const _answer = 'odd-secret-complete';
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
const _oddTitles = {
  'ar': 'اجمع الأدلة',
  'de': 'Beweise sammeln',
  'en': 'Collect evidence',
  'es': 'Reúne pruebas',
  'fr': 'Trouve les indices',
  'hi': 'सबूत चुनें',
  'it': 'Raccogli indizi',
  'ja': '証拠を集めよう',
  'ko': '증거 모으기',
  'pt': 'Reúna pistas',
  'ru': 'Собери улики',
  'zh': '收集线索',
};
const _roundTitles = {
  'ar': 'الجولة 1/3',
  'de': 'Runde 1/3',
  'en': 'Round 1/3',
  'es': 'Ronda 1/3',
  'fr': 'Manche 1/3',
  'hi': 'दौर 1/3',
  'it': 'Turno 1/3',
  'ja': 'ラウンド 1/3',
  'ko': '라운드 1/3',
  'pt': 'Rodada 1/3',
  'ru': 'Раунд 1/3',
  'zh': '回合 1/3',
};

Widget _harness(Widget child, {String locale = 'en'}) => MaterialApp(
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: child)),
      ),
    );

Future<void> _dragTo(
  WidgetTester tester,
  Finder source,
  Finder target,
) async {
  final gesture = await tester.startGesture(tester.getCenter(source));
  await tester.pump(const Duration(milliseconds: 80));
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump(const Duration(milliseconds: 100));
  await gesture.up();
  await tester.pump();
}

Future<void> _assembleCode(WidgetTester tester, List<int> code) async {
  for (var index = 0; index < code.length; index++) {
    await _dragTo(
      tester,
      find.byKey(ValueKey('secret-code-rune-${code[index]}')),
      find.byKey(ValueKey('secret-code-slot-$index')),
    );
  }
  await tester.tap(find.byKey(const ValueKey('secret-code-submit')));
  await tester.pump();
}

void main() {
  testWidgets(
      'odd card needs evidence, rule discovery and four classifications once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(OddCardInvestigationGameView(
      accent: Colors.purple,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'odd card investigation',
      onAnswerSelected: answers.add,
    )));

    await tester.tap(find.byKey(const ValueKey('odd-evidence-card-0')));
    await tester.tap(find.byKey(const ValueKey('odd-evidence-confirm')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('odd-stage-evidence')), findsOneWidget);
    expect(answers, isEmpty);

    for (final index in const [2, 5]) {
      await tester.tap(find.byKey(ValueKey('odd-evidence-card-$index')));
      await tester.pump();
    }
    expect(
      find.byKey(const ValueKey('odd-evidence-state-0-2-5')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('odd-evidence-confirm')));
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pump();
    expect(find.byKey(const ValueKey('odd-stage-rule')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('odd-rule-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('odd-stage-rule')), findsOneWidget);
    expect(answers, isEmpty);

    await tester.tap(find.byKey(const ValueKey('odd-rule-1')));
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pump();
    expect(find.byKey(const ValueKey('odd-stage-classify-0')), findsOneWidget);

    await _dragTo(
      tester,
      find.byKey(const ValueKey('odd-classify-card-0')),
      find.byKey(const ValueKey('odd-bin-breaks-0')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('odd-stage-classify-0')), findsOneWidget);
    expect(answers, isEmpty);

    for (var index = 0; index < 4; index++) {
      final follows = index == 0 || index == 2;
      await _dragTo(
        tester,
        find.byKey(ValueKey('odd-classify-card-$index')),
        find.byKey(ValueKey(
          follows ? 'odd-bin-follows-$index' : 'odd-bin-breaks-$index',
        )),
      );
      await tester.pump(const Duration(milliseconds: 370));
      await tester.pump();
      if (index < 3) expect(answers, isEmpty);
    }

    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 2));
    expect(answers, [_answer]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'secret code gives positional feedback and completes three rounds once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(SecretCodeGameView(
      accent: Colors.teal,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'secret code laboratory',
      onAnswerSelected: answers.add,
    )));

    await _assembleCode(tester, const [1, 3, 7]);
    expect(
      find.byKey(const ValueKey('secret-code-feedback-0-3')),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 430));
    expect(answers, isEmpty);

    for (var round = 0; round < 3; round++) {
      final code = const [
        [3, 7, 1],
        [6, 2, 9],
        [4, 8, 5],
      ][round];
      await _assembleCode(tester, code);
      expect(
        find.byKey(const ValueKey('secret-code-feedback-3-0')),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 630));
      if (round < 2) {
        expect(
          find.byKey(ValueKey('secret-code-round-${round + 1}')),
          findsOneWidget,
        );
        expect(answers, isEmpty);
      }
    }

    expect(answers, [_answer]);
    await tester.tap(find.byKey(const ValueKey('secret-code-rune-4')),
        warnIfMissed: false);
    await tester.pump(const Duration(seconds: 2));
    expect(answers, [_answer]);
    expect(tester.takeException(), isNull);
  });

  for (final locale in _locales) {
    testWidgets('odd card and secret code render localized $locale safely',
        (tester) async {
      await tester.pumpWidget(_harness(
        OddCardInvestigationGameView(
          accent: Colors.indigo,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'odd card $locale',
          onAnswerSelected: (_) {},
        ),
        locale: locale,
      ));
      expect(find.byType(OddCardInvestigationGameView), findsOneWidget);
      expect(find.text(_oddTitles[locale]!), findsOneWidget);
      final direction = locale == 'ar' ? TextDirection.rtl : TextDirection.ltr;
      expect(
        find.descendant(
          of: find.byType(OddCardInvestigationGameView),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Directionality && widget.textDirection == direction,
          ),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(_harness(
        SecretCodeGameView(
          accent: Colors.cyan,
          compact: true,
          correctAnswer: _answer,
          semanticLabel: 'secret code $locale',
          onAnswerSelected: (_) {},
        ),
        locale: locale,
      ));
      expect(find.text(_roundTitles[locale]!), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SecretCodeGameView),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Directionality && widget.textDirection == direction,
          ),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
