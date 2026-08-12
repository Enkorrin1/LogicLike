import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_answer_rules.dart';
import 'package:logicloka/src/features/challenge/challenge_screen.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

const _accent = Color(0xFF28B8A9);

DailyChallenge _puzzle(String id) => puzzleAreasForAge(ChildAge.six)
    .expand((area) => area.puzzles)
    .firstWhere((puzzle) => puzzle.id == id);

Widget _host(
  DailyChallenge puzzle,
  ValueChanged<String> onAnswerSelected, {
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 430,
          child: buildPuzzleScene(
            puzzle: puzzle,
            accent: _accent,
            compact: false,
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      ),
    ),
  );
}

Future<void> _expectExactOnce(
  WidgetTester tester,
  List<String> output,
  String answer,
) async {
  await tester.pump(const Duration(milliseconds: 900));
  expect(output, [answer]);
  await tester.pump(const Duration(seconds: 2));
  expect(output, [answer]);
}

Future<void> _traceConstellation(
  WidgetTester tester,
  List<int> route,
) async {
  final rect = tester.getRect(
    find.byKey(const ValueKey('constellation-route-board')),
  );
  const positions = <Offset>[
    Offset(.10, .68),
    Offset(.27, .43),
    Offset(.27, .79),
    Offset(.45, .28),
    Offset(.48, .59),
    Offset(.49, .84),
    Offset(.68, .38),
    Offset(.72, .72),
    Offset(.90, .52),
  ];
  Offset node(int index) =>
      rect.topLeft +
      Offset(
        rect.width * positions[index].dx,
        rect.height * positions[index].dy,
      );

  final gesture = await tester.startGesture(node(route.first));
  for (final index in route.skip(1)) {
    await gesture.moveTo(node(index));
    await tester.pump(const Duration(milliseconds: 60));
  }
  await gesture.up();
  await tester.pump();
}

Future<void> _traceMirror(
  WidgetTester tester,
  List<int> route,
) async {
  final rect = tester.getRect(find.byKey(const ValueKey('mirror-path-board')));
  Offset node(int index) =>
      rect.topLeft +
      Offset(
        rect.width * (.18 + (index % 3) * .32),
        rect.height * (.25 + (index ~/ 3) * .24),
      );
  final gesture = await tester.startGesture(node(route.first));
  for (final index in route.skip(1)) {
    await gesture.moveTo(node(index));
    await tester.pump(const Duration(milliseconds: 60));
  }
  await gesture.up();
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'constellation route rejects a branch and completes three maps once',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final puzzle = _puzzle('constellation-route');
      final output = <String>[];
      await tester.pumpWidget(_host(puzzle, output.add));
      await tester.pump();

      await _traceConstellation(tester, [0, 2]);
      await tester.pump(const Duration(milliseconds: 450));
      expect(output, isEmpty);

      await _traceConstellation(tester, [0, 1, 3, 6, 8]);
      await tester.pump(const Duration(milliseconds: 450));
      expect(output, isEmpty);
      await _traceConstellation(tester, [0, 2, 4, 6, 8]);
      await tester.pump(const Duration(milliseconds: 450));
      expect(output, isEmpty);
      await _traceConstellation(tester, [0, 2, 5, 7, 8]);

      await _expectExactOnce(
        tester,
        output,
        answerRuleForPuzzle(puzzle).correctAnswer,
      );
    },
  );

  testWidgets('code lock uses three dial transformations and submits once',
      (tester) async {
    final puzzle = _puzzle('code-lock');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();
    String value(int index) => tester
        .widget<Text>(
          find.byKey(ValueKey('code-lock-dial-$index-value')),
        )
        .data!;

    await tester.tap(find.byKey(const ValueKey('code-lock-check')));
    await tester.pump(const Duration(milliseconds: 450));
    expect(output, isEmpty);

    for (var index = 0; index < 3; index++) {
      await tester.tap(find.byKey(ValueKey('code-lock-dial-$index-up')));
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('code-lock-dial-2-up')));
    await tester.pump();
    expect([value(0), value(1), value(2)], ['1', '3', '6']);
    await tester.tap(find.byKey(const ValueKey('code-lock-check')));
    await tester.pump();
    expect([value(0), value(1), value(2)], ['3', '3', '7']);

    await tester.tap(find.byKey(const ValueKey('code-lock-dial-0-down')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('code-lock-dial-1-up')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('code-lock-dial-2-up')));
    await tester.pump();
    expect([value(0), value(1), value(2)], ['2', '4', '8']);
    await tester.tap(find.byKey(const ValueKey('code-lock-check')));
    await tester.pump();
    expect([value(0), value(1), value(2)], ['4', '6', '1']);

    for (var index = 0; index < 3; index++) {
      await tester.tap(find.byKey(ValueKey('code-lock-dial-$index-down')));
      await tester.pump();
    }
    expect([value(0), value(1), value(2)], ['3', '5', '0']);
    expect(output, isEmpty);
    await tester.tap(find.byKey(const ValueKey('code-lock-check')));

    await _expectExactOnce(
      tester,
      output,
      answerRuleForPuzzle(puzzle).correctAnswer,
    );
  });

  testWidgets('mirror path aligns mirrors, launches, traces and submits once',
      (tester) async {
    final puzzle = _puzzle('mirror-path');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('mirror-path-launch')));
    await tester.pump(const Duration(milliseconds: 450));
    expect(output, isEmpty);

    for (var index = 0; index < 3; index++) {
      await tester.tap(find.byKey(ValueKey('mirror-path-mirror-$index')));
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('mirror-path-launch')));
    await tester.pump();

    await _traceMirror(tester, [0, 3]);
    await tester.pump(const Duration(milliseconds: 450));
    expect(output, isEmpty);
    await _traceMirror(tester, [0, 1, 4, 7, 6]);

    await _expectExactOnce(
      tester,
      output,
      answerRuleForPuzzle(puzzle).correctAnswer,
    );
  });

  testWidgets('all three production games build in every supported locale',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final locale in AppLocalizations.supportedLocales) {
      for (final id in const [
        'constellation-route',
        'code-lock',
        'mirror-path',
      ]) {
        await tester.pumpWidget(
          _host(_puzzle(id), (_) {}, locale: locale),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$id / $locale');
        expect(
          find.byKey(ValueKey('$id-board')),
          findsOneWidget,
          reason: '$id / $locale',
        );
      }
    }
  });
}
