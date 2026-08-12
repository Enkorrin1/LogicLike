import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_interaction_catalog.dart';
import 'package:logicloka/src/features/challenge/challenge_screen.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final puzzles = puzzleAreasForAge(ChildAge.six)
      .expand((area) => area.puzzles)
      .where((puzzle) => sceneDrivenPuzzleIds.contains(puzzle.id))
      .toList(growable: false);

  testWidgets(
    'production factory builds every scene-driven puzzle without fallback',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      expect(puzzles, hasLength(62));

      for (final puzzle in puzzles) {
        expect(
          usesInteractivePuzzleScene(puzzle.id),
          isTrue,
          reason: '${puzzle.id} would use the generic answer picker',
        );

        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SingleChildScrollView(
                child: buildPuzzleScene(
                  puzzle: puzzle,
                  accent: const Color(0xFF28B8A9),
                  compact: true,
                  onAnswerSelected: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(genericPuzzleSceneFallbackKey),
          findsNothing,
          reason: '${puzzle.id} has no dedicated production dispatch',
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '${puzzle.id} failed while building its production scene',
        );

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 10));
      }
    },
  );
}
