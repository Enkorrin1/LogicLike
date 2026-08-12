import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_answer_rules.dart';
import 'package:logicloka/src/features/challenge/challenge_screen.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';
import 'package:logicloka/src/l10n/localized_content.dart';

const _accent = Color(0xFF28B8A9);

DailyChallenge _puzzle(String id) => puzzleAreasForAge(ChildAge.six)
    .expand((area) => area.puzzles)
    .firstWhere((puzzle) => puzzle.id == id);

Widget _sceneHost(
  String id,
  ValueChanged<String> onAnswerSelected, {
  String languageCode = 'en',
}) {
  return MaterialApp(
    locale: Locale(languageCode),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 430,
          child: buildPuzzleScene(
            puzzle: _puzzle(id),
            accent: _accent,
            compact: false,
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      ),
    ),
  );
}

Future<void> _semanticAction(
  WidgetTester tester,
  Finder finder,
  SemanticsAction action,
) async {
  final node = tester.getSemantics(finder);
  expect(node.getSemanticsData().hasAction(action), isTrue);
  // Widget tests still route accessibility actions through this owner.
  // ignore: deprecated_member_use
  tester.binding.pipelineOwner.semanticsOwner!.performAction(node.id, action);
  await tester.pump();
}

Future<void> _semanticTapLabel(WidgetTester tester, String label) async {
  final target = find.semantics.byLabel(label);
  expect(target, findsOneWidget, reason: 'Missing semantic action: $label');
  tester.semantics.tap(target);
  await tester.pump();
}

Future<int> _chooseIndex(
  WidgetTester tester,
  Finder control,
  int current,
  int target,
  int count,
) async {
  final steps = (target - current) % count;
  for (var step = 0; step < steps; step++) {
    await _semanticAction(tester, control, SemanticsAction.increase);
  }
  await _semanticAction(tester, control, SemanticsAction.tap);
  return target;
}

Future<void> _expectExactOnce(
  WidgetTester tester,
  List<String> answers,
  String expected,
) async {
  await tester.pump(const Duration(milliseconds: 900));
  expect(answers, [expected]);
  await tester.pump(const Duration(seconds: 2));
  expect(answers, [expected]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('constellation route completes all maps through semantics once',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    final puzzle = _puzzle('constellation-route');
    await tester.pumpWidget(_sceneHost(puzzle.id, answers.add));
    await tester.pump(const Duration(milliseconds: 500));

    final control = find.byKey(const ValueKey('constellation-route-semantics'));
    var cursor = 0;
    for (final route in const <List<int>>[
      [0, 1, 3, 6, 8],
      [0, 2, 4, 6, 8],
      [0, 2, 5, 7, 8],
    ]) {
      for (final star in route) {
        cursor = await _chooseIndex(tester, control, cursor, star, 9);
      }
      await tester.pump(const Duration(milliseconds: 450));
      cursor = 0;
    }

    await _expectExactOnce(
      tester,
      answers,
      answerRuleForPuzzle(puzzle).correctAnswer,
    );
    semantics.dispose();
  });

  testWidgets('code lock names every action and completes semantically once',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    final puzzle = _puzzle('code-lock');
    await tester.pumpWidget(_sceneHost(puzzle.id, answers.add));
    await tester.pump(const Duration(milliseconds: 500));

    Future<void> tap(String label) => _semanticTapLabel(tester, label);

    await tap('Check lock');
    expect(answers, isEmpty);

    for (final label in const [
      'Increase Dial 1',
      'Increase Dial 2',
      'Increase Dial 3',
      'Increase Dial 3',
      'Check lock',
      'Decrease Dial 1',
      'Increase Dial 2',
      'Increase Dial 3',
      'Check lock',
      'Decrease Dial 1',
      'Decrease Dial 2',
      'Decrease Dial 3',
      'Check lock',
    ]) {
      await tap(label);
    }

    await _expectExactOnce(
      tester,
      answers,
      answerRuleForPuzzle(puzzle).correctAnswer,
    );
    semantics.dispose();
  });

  testWidgets('mirror path aligns and traces through semantics exactly once',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    final puzzle = _puzzle('mirror-path');
    await tester.pumpWidget(_sceneHost(puzzle.id, answers.add));
    await tester.pump(const Duration(milliseconds: 500));

    await _semanticTapLabel(tester, 'Launch beam');
    expect(answers, isEmpty);

    for (var index = 1; index <= 3; index++) {
      await _semanticTapLabel(tester, 'Mirror $index');
    }
    await _semanticTapLabel(tester, 'Launch beam');

    final trace = find.byKey(const ValueKey('mirror-path-trace-semantics'));
    var cursor = 0;
    for (final node in const [0, 1, 4, 7, 6]) {
      cursor = await _chooseIndex(tester, trace, cursor, node, 9);
    }

    await _expectExactOnce(
      tester,
      answers,
      answerRuleForPuzzle(puzzle).correctAnswer,
    );
    semantics.dispose();
  });

  testWidgets('all 12 locales expose localized accessible game actions',
      (tester) async {
    final semantics = tester.ensureSemantics();
    const expected = <String, (String, String, String)>{
      'ar': ('تحقق من القفل', 'أطلق الشعاع', 'خريطة'),
      'de': ('Schloss prüfen', 'Strahl starten', 'Karte'),
      'en': ('Check lock', 'Launch beam', 'Map'),
      'es': ('Comprobar cerradura', 'Lanzar rayo', 'Mapa'),
      'fr': ('Vérifier le cadenas', 'Lancer le rayon', 'Carte'),
      'hi': ('ताला जाँचें', 'किरण चलाएँ', 'मानचित्र'),
      'it': ('Controlla lucchetto', 'Avvia raggio', 'Mappa'),
      'ja': ('鍵を確認', '光を発射', 'マップ'),
      'ko': ('자물쇠 확인', '빛 발사', '지도'),
      'pt': ('Verificar fechadura', 'Lançar feixe', 'Mapa'),
      'ru': ('Проверить замок', 'Запустить луч', 'Карта'),
      'zh': ('检查密码锁', '发射光束', '地图'),
    };

    for (final entry in expected.entries) {
      await tester.pumpWidget(
        _sceneHost('code-lock', (_) {}, languageCode: entry.key),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.semantics.byLabel(entry.value.$1), findsOneWidget);
      expect(
        tester
            .getSemantics(
              find.byKey(const ValueKey('code-lock-semantics')),
            )
            .value,
        isNotEmpty,
      );
      final codeActions = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .where((widget) => widget.properties.onTap != null);
      expect(codeActions, isNotEmpty);
      for (final action in codeActions) {
        expect(action.properties.label, isNotEmpty);
        expect(action.properties.hint, isNotEmpty);
      }

      await tester.pumpWidget(
        _sceneHost('mirror-path', (_) {}, languageCode: entry.key),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.semantics.byLabel(entry.value.$2), findsOneWidget);
      final mirrorActions = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .where((widget) => widget.properties.onTap != null);
      expect(mirrorActions, isNotEmpty);
      for (final action in mirrorActions) {
        expect(action.properties.label, isNotEmpty);
        expect(action.properties.hint, isNotEmpty);
      }

      await tester.pumpWidget(
        _sceneHost('constellation-route', (_) {}, languageCode: entry.key),
      );
      await tester.pump(const Duration(milliseconds: 500));
      final constellation = tester.getSemantics(
        find.byKey(const ValueKey('constellation-route-semantics')),
      );
      expect(constellation.value, contains(entry.value.$3));
      expect(constellation.hint, isNotEmpty);
    }

    await tester.pumpWidget(
      _sceneHost('code-lock', (_) {}, languageCode: 'ar'),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey('code-lock-semantics')))
          .textDirection,
      TextDirection.rtl,
    );
    await tester.pumpWidget(
      _sceneHost('mirror-path', (_) {}, languageCode: 'ar'),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('mirror-path-trace-semantics')),
          )
          .textDirection,
      TextDirection.rtl,
    );
    await tester.pumpWidget(
      _sceneHost('constellation-route', (_) {}, languageCode: 'ar'),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      tester
          .getSemantics(
            find.byKey(const ValueKey('constellation-route-semantics')),
          )
          .textDirection,
      TextDirection.rtl,
    );
    semantics.dispose();
  });

  for (final language in const [AppLanguage.de, AppLanguage.hi]) {
    testWidgets(
        'compact ${language.code} shell wraps long copy without overflow',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final profile = FamilyProfile(
        childName: 'Leo',
        childAge: ChildAge.six,
        createdAt: DateTime(2026),
        language: language,
      );
      final l10n = lookupAppLocalizations(language.locale);
      final area = puzzleAreasForAge(ChildAge.six)
          .firstWhere((candidate) => candidate.id == 'logic');
      final puzzle = area.puzzles.first;

      await tester.pumpWidget(
        MaterialApp(
          locale: language.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
            ),
            child: ChallengeScreen(
              profile: profile,
              initialAreaId: 'logic',
              onInitialAreaHandled: () {},
              onChallengeComplete: (_) async {},
              onPracticeComplete: (_) async {},
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      await tester.tap(find.text(l10n.puzzleTitle(puzzle)).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);

      for (final text in [
        l10n.puzzleTitle(puzzle),
        l10n.puzzleSkill(puzzle),
        l10n.puzzlePrompt(puzzle),
      ]) {
        final widget = tester.widget<Text>(find.text(text).last);
        expect(widget.maxLines, isNull, reason: '$language: $text');
        expect(widget.overflow, isNull, reason: '$language: $text');
      }
    });
  }
}
