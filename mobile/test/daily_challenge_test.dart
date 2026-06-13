import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/daily_challenge.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';

void main() {
  group('DailyChallenge', () {
    test('checks answer by selected choice id', () {
      final challenge = dailyChallengesForAge(ChildAge.six).first;

      expect(challenge.isCorrectChoice(challenge.correctChoiceId), isTrue);
      expect(challenge.isCorrectChoice('wrong'), isFalse);
      expect(challenge.correctChoice.id, challenge.correctChoiceId);
    });

    test('selects one stable daily challenge for age and date', () {
      final firstDate = DateTime(2026, 6, 8);
      final sameDateLater = DateTime(2026, 6, 8, 18, 30);

      final firstChallenge = dailyChallengeForDate(
        ChildAge.six,
        firstDate,
        goal: LearningGoal.math,
      );
      final sameDayChallenge = dailyChallengeForDate(
        ChildAge.six,
        sameDateLater,
        goal: LearningGoal.math,
      );

      expect(sameDayChallenge.id, firstChallenge.id);
    });

    test('rotates challenge content across days', () {
      final firstChallenge = dailyChallengeForDate(
        ChildAge.seven,
        DateTime(2026, 6, 8),
      );
      final nextChallenge = dailyChallengeForDate(
        ChildAge.seven,
        DateTime(2026, 6, 9),
      );

      expect(nextChallenge.id, isNot(firstChallenge.id));
    });

    test('filters challenge content by selected learning goal', () {
      for (final age in ChildAge.values) {
        for (final goal in LearningGoal.values) {
          final challenge = dailyChallengeForDate(
            age,
            DateTime(2026, 6, 8),
            goal: goal,
          );

          expect(challenge.goal, goal);
        }
      }
    });

    test('exposes the full age bank when goal is not specified', () {
      final allChallenges = dailyChallengesForAge(ChildAge.seven);

      expect(allChallenges.map((challenge) => challenge.goal).toSet(), {
        LearningGoal.logic,
        LearningGoal.math,
        LearningGoal.attention,
      });
    });

    test('contains expanded catalog challenge ids', () {
      expect(
        dailyChallengeById('shadow-match', age: ChildAge.five).id,
        'shadow-match',
      );
      expect(
        dailyChallengeById('balance-scale', age: ChildAge.five).id,
        'balance-scale',
      );
      expect(
        dailyChallengeById('shape-rotation', age: ChildAge.five).id,
        'shape-rotation',
      );
      expect(
        dailyChallengeById('fruit-pattern', age: ChildAge.five).id,
        'fruit-pattern',
      );
      expect(
        dailyChallengeById('lock-key', age: ChildAge.five).id,
        'lock-key',
      );
      expect(
        dailyChallengeById('space-sequence', age: ChildAge.five).id,
        'space-sequence',
      );
      expect(
        dailyChallengeById('shape-stack', age: ChildAge.five).id,
        'shape-stack',
      );
      expect(
        dailyChallengeById('path-maze', age: ChildAge.five).id,
        'path-maze',
      );
    });

    test('generates individualized content for lesson steps', () {
      final generated = [
        for (final step in FoundationCatalog.starterLessonSteps)
          dailyChallengeForLessonStep(
            step,
            FoundationCatalog.puzzleForStep(step),
            age: ChildAge.seven,
          ),
      ];
      final ids = generated.map((challenge) => challenge.id).toSet();
      final signatures = generated
          .map(
            (challenge) => [
              challenge.familyId,
              challenge.correctChoiceId,
              challenge.tokens.join(','),
              challenge.numbers.join(','),
            ].join('|'),
          )
          .toSet();
      final shapePathVariants = generated
          .where((challenge) => challenge.familyId == 'shape-path')
          .map((challenge) => challenge.tokens.join(','))
          .toSet();
      final toyCountVariants = generated
          .where((challenge) => challenge.familyId == 'toy-count')
          .map((challenge) => challenge.numbers.join(','))
          .toSet();

      expect(ids.length, generated.length);
      expect(signatures.length, greaterThan(40));
      expect(shapePathVariants.length, greaterThan(1));
      expect(toyCountVariants.length, greaterThan(1));
      expect(
        generated.every((challenge) => challenge.choices.length >= 3),
        isTrue,
      );
    });

    test('generates path maze lesson variants with direction choices', () {
      final step = FoundationCatalog.starterLessonSteps.firstWhere(
        (step) => step.puzzleId == 'puzzle.path_maze',
      );
      final challenge = dailyChallengeForLessonStep(
        step,
        FoundationCatalog.puzzleForStep(step),
        age: ChildAge.seven,
      );

      expect(challenge.visualId, 'path-maze');
      expect(challenge.tokens, hasLength(3));
      expect(challenge.choices.map((choice) => choice.id), {
        'left',
        'right',
        'up',
        'down',
      });
      expect(
        challenge.choices.map((choice) => choice.id),
        contains(challenge.correctChoiceId),
      );
    });
  });
}
