import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/content_pack.dart';
import 'package:logic_like/src/domain/daily_challenge.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';
import 'package:logic_like/src/domain/puzzle_content.dart';

void main() {
  group('ContentPackCatalog', () {
    test('phase 13 exposes one hundred unique puzzle definitions', () {
      final items = ContentPackCatalog.phase13Items;
      final signatures = {for (final item in items) item.signature};

      expect(items, hasLength(100));
      expect(signatures, hasLength(100));
    });

    test('phase 13 matches the planned content distribution', () {
      expect(ContentPackCatalog.phase13CategoryCounts(), {
        'pattern': 20,
        'odd-one-out': 15,
        'counting': 15,
        'comparison': 10,
        'pair-matching': 10,
        'shadow-matching': 10,
        'path-logic': 10,
        'memory-detail': 10,
      });
    });

    test('phase 13 items have content and visual answer assets', () {
      final issues = <String>[];

      for (final item in ContentPackCatalog.phase13Items) {
        final content = PuzzleContentCatalog.maybeByFamilyId(item.familyId);
        if (content == null) {
          issues.add('${item.id}: missing content for ${item.familyId}');
        }
        if (!item.choiceIds.contains(item.correctChoiceId)) {
          issues.add('${item.id}: correct answer is not in choices');
        }
        for (final choiceId in item.choiceIds) {
          final assets = PuzzleContentCatalog.assetsForChoice(
            item.familyId,
            choiceId,
          );
          if (assets.isEmpty) {
            issues.add('${item.id}: missing visual for $choiceId');
          }
        }
      }

      expect(issues, isEmpty);
    });

    test('lesson generation uses phase 13 variants for matching mechanics', () {
      final generated = [
        for (final step in FoundationCatalog.starterLessonSteps.take(120))
          dailyChallengeForLessonStep(
            step,
            FoundationCatalog.puzzleForStep(step),
            age: ChildAge.seven,
          ),
      ];
      final signatures = {
        for (final challenge in generated)
          [
            challenge.familyId,
            challenge.correctChoiceId,
            challenge.tokens.join(','),
            challenge.numbers.join(','),
          ].join('|'),
      };

      expect(signatures.length, greaterThanOrEqualTo(80));
      expect(
        generated.every(
          (challenge) =>
              challenge.choices
                  .map((choice) => choice.id)
                  .contains(challenge.correctChoiceId) &&
              (challenge.tokens.isNotEmpty || challenge.numbers.isNotEmpty),
        ),
        isTrue,
      );
    });
  });
}
