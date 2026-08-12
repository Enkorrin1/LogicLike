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
}) =>
    MaterialApp(
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

Future<void> _expectExactOnce(
  WidgetTester tester,
  DailyChallenge puzzle,
  List<String> output,
) async {
  await tester.pump(const Duration(milliseconds: 900));
  expect(output, [answerRuleForPuzzle(puzzle).correctAnswer]);
  await tester.pump(const Duration(seconds: 2));
  expect(output, hasLength(1));
}

Future<void> _tap(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(ValueKey(key)));
  await tester.pump(const Duration(milliseconds: 220));
}

Future<void> _drag(WidgetTester tester, String from, String to) async {
  await tester.dragFrom(
    tester.getCenter(find.byKey(ValueKey(from))),
    tester.getCenter(find.byKey(ValueKey(to))) -
        tester.getCenter(find.byKey(ValueKey(from))),
  );
  await tester.pump(const Duration(milliseconds: 250));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fruit fizz rejects a fruit count and solves three recipes once',
      (tester) async {
    final puzzle = _puzzle('fruit-fizz');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await _tap(tester, 'fruit-fizz-choice-0-2');
    expect(output, isEmpty);
    expect(find.byKey(const ValueKey('fruit-fizz-choice-0-2')), findsOneWidget);
    await _tap(tester, 'fruit-fizz-choice-0-3');
    await _tap(tester, 'fruit-fizz-choice-1-1');
    await _tap(tester, 'fruit-fizz-choice-2-4');

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets('planet sum rejects a wrong orbit and solves three sums once',
      (tester) async {
    final puzzle = _puzzle('planet-sum');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await _tap(tester, 'planet-sum-choice-0-4');
    expect(output, isEmpty);
    await _tap(tester, 'planet-sum-choice-0-5');
    await _tap(tester, 'planet-sum-choice-1-6');
    await _tap(tester, 'planet-sum-choice-2-8');

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets(
      'sticker shop rejects an unaffordable count and clears three carts',
      (tester) async {
    final puzzle = _puzzle('sticker-shop');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await _tap(tester, 'sticker-shop-choice-0-2');
    expect(output, isEmpty);
    await _tap(tester, 'sticker-shop-choice-0-3');
    await _tap(tester, 'sticker-shop-choice-1-4');
    await _tap(tester, 'sticker-shop-choice-2-3');

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets(
      'cookie share rejects an uneven share and solves three tables once',
      (tester) async {
    final puzzle = _puzzle('cookie-share');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await _tap(tester, 'cookie-share-choice-0-1');
    expect(output, isEmpty);
    await _tap(tester, 'cookie-share-choice-0-2');
    await _tap(tester, 'cookie-share-choice-1-2');
    await _tap(tester, 'cookie-share-choice-2-3');

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets(
      'count rockets ignores a duplicate and submits after all six once',
      (tester) async {
    final puzzle = _puzzle('count-rockets');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await _tap(tester, 'count-rockets-token-0');
    await _tap(tester, 'count-rockets-token-0');
    expect(output, isEmpty);
    for (var index = 1; index < 6; index++) {
      await _tap(tester, 'count-rockets-token-$index');
    }

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets(
      'cube groups rejects an overfilled basket and completes two groups',
      (tester) async {
    final puzzle = _puzzle('cube-groups');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await _drag(tester, 'cube-groups-cube-0', 'cube-groups-left');
    await _drag(tester, 'cube-groups-cube-1', 'cube-groups-left');
    await _drag(tester, 'cube-groups-cube-2', 'cube-groups-left');
    expect(output, isEmpty);
    await _drag(tester, 'cube-groups-cube-2', 'cube-groups-right');
    await _drag(tester, 'cube-groups-cube-3', 'cube-groups-right');

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets(
      'more less rejects a wrong pairing and completes three matches once',
      (tester) async {
    final puzzle = _puzzle('more-less');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    await _drag(tester, 'more-less-item-0', 'more-less-target-1');
    await _tap(tester, 'more-less-finish');
    expect(output, isEmpty);
    for (var index = 0; index < 3; index++) {
      await _drag(tester, 'more-less-item-$index', 'more-less-target-$index');
    }
    await _tap(tester, 'more-less-finish');

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets('route maze blocks an invalid move and reaches the star once',
      (tester) async {
    final puzzle = _puzzle('route-maze');
    final output = <String>[];
    await tester.pumpWidget(_host(puzzle, output.add));
    await tester.pump();

    expect(find.byKey(const ValueKey('route-maze-hero-8')), findsOneWidget);
    await _tap(tester, 'route-maze-left');
    expect(output, isEmpty);
    expect(find.byKey(const ValueKey('route-maze-hero-8')), findsOneWidget);
    await _tap(tester, 'route-maze-up');
    expect(find.byKey(const ValueKey('route-maze-hero-4')), findsOneWidget);
    await _tap(tester, 'route-maze-right');
    expect(find.byKey(const ValueKey('route-maze-hero-5')), findsOneWidget);
    await _tap(tester, 'route-maze-right');
    expect(find.byKey(const ValueKey('route-maze-hero-6')), findsOneWidget);

    await _expectExactOnce(tester, puzzle, output);
  });

  testWidgets('new math arcades build in all 12 locales including RTL',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final locale in AppLocalizations.supportedLocales) {
      for (final id in const [
        'fruit-fizz',
        'planet-sum',
        'sticker-shop',
        'cookie-share',
      ]) {
        await tester.pumpWidget(_host(_puzzle(id), (_) {}, locale: locale));
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$id / $locale');
      }
    }
  });
}
