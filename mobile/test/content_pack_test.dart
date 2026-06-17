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

    test('phase 14 exposes three hundred level-ready puzzle steps', () {
      final items = ContentPackCatalog.phase14Items;

      expect(items, hasLength(300));
      expect(ContentPackCatalog.phase14DifficultyCounts(), {
        'easy': 60,
        'medium': 120,
        'hard': 80,
        'mixed-review': 40,
      });
      expect(
        {for (final item in items) item.familyId}.length,
        greaterThanOrEqualTo(18),
      );
    });

    test('phase 14 defines boss lessons as mixed review adventures', () {
      expect(ContentPackCatalog.phase14BossLessons, hasLength(8));

      for (final bossLesson in ContentPackCatalog.phase14BossLessons) {
        expect(bossLesson.itemIds, hasLength(5));
        final items = [
          for (final item in ContentPackCatalog.phase14Items)
            if (bossLesson.itemIds.contains(item.id)) item,
        ];
        expect(items.map((item) => item.difficultyBand).toSet(), {
          'mixed-review',
        });
        expect(
          items.map((item) => item.familyId).toSet().length,
          greaterThanOrEqualTo(4),
        );
      }
    });

    test('phase 14 items have content and visual answer assets', () {
      final issues = <String>[];

      for (final item in ContentPackCatalog.phase14Items) {
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
  });
}
