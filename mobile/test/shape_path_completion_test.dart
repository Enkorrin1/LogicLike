import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_answer_rules.dart';
import 'package:logicloka/src/features/challenge/challenge_screen.dart';
import 'package:logicloka/src/features/challenge/game_scenes/sequence_workshop_games.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

const _accent = Color(0xFF28B8A9);

DailyChallenge get _shapePath => puzzleAreasForAge(ChildAge.six)
    .expand((area) => area.puzzles)
    .firstWhere((puzzle) => puzzle.id == 'shape-path');

Widget _host(
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
            puzzle: _shapePath,
            accent: _accent,
            compact: false,
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      ),
    ),
  );
}

Finder get _draggables =>
    find.byWidgetPredicate((widget) => widget is Draggable<Object?>);

Finder get _dragTargets =>
    find.byWidgetPredicate((widget) => widget is DragTarget<Object?>);

Future<void> _drag(
  WidgetTester tester,
  Finder source,
  Finder target,
) async {
  final gesture = await tester.startGesture(tester.getCenter(source));
  await tester.pump(const Duration(milliseconds: 650));
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump(const Duration(milliseconds: 120));
  await gesture.up();
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'production shape path rejects an error and completes exactly once',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final answers = <String>[];
      final correctAnswer = answerRuleForPuzzle(_shapePath).correctAnswer;

      await tester.pumpWidget(_host(answers.add));
      await tester.pump();

      final workshop = tester.widget<PatternTrainWorkshopGameView>(
        find.byType(PatternTrainWorkshopGameView),
      );
      expect(workshop.variant, PatternWorkshopVariant.path);
      expect(_draggables, findsNWidgets(3));
      expect(_dragTargets, findsNWidgets(3));

      // Piece 0 does not belong in slot 0. The scene must reject it.
      await _drag(tester, _draggables.at(0), _dragTargets.at(0));
      await tester.pump(const Duration(milliseconds: 600));
      expect(answers, isEmpty);
      expect(_draggables, findsNWidgets(3));

      // Production order is piece 1, piece 0, piece 2.
      await _drag(tester, _draggables.at(1), _dragTargets.at(0));
      expect(answers, isEmpty);
      await _drag(tester, _draggables.at(0), _dragTargets.at(1));
      expect(answers, isEmpty);
      await _drag(tester, _draggables.at(0), _dragTargets.at(2));

      await tester.pump(const Duration(milliseconds: 900));
      expect(answers, [correctAnswer]);
      await tester.pump(const Duration(seconds: 2));
      expect(answers, [correctAnswer]);
    },
  );

  testWidgets('production shape path renders in all 12 locales with RTL',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    expect(AppLocalizations.supportedLocales, hasLength(12));
    for (final locale in AppLocalizations.supportedLocales) {
      await tester.pumpWidget(_host((_) {}, locale: locale));
      await tester.pump();

      final workshop = tester.widget<PatternTrainWorkshopGameView>(
        find.byType(PatternTrainWorkshopGameView),
      );
      expect(
        workshop.variant,
        PatternWorkshopVariant.path,
        reason: 'Wrong production variant for $locale',
      );
      expect(tester.takeException(), isNull, reason: 'Render failed: $locale');

      final scaffoldDirection = Directionality.of(
        tester.element(find.byType(Scaffold)),
      );
      expect(
        scaffoldDirection,
        locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        reason: 'Wrong app direction for $locale',
      );
    }
  });
}
