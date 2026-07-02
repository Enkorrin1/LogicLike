import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_answer_rules.dart';

void main() {
  group('puzzle answer rules', () {
    test('covers every catalog puzzle with a concrete rule', () {
      final puzzles = puzzleAreasForAge(ChildAge.six)
          .expand((area) => area.puzzles)
          .toList(growable: false);

      expect(puzzles.length, greaterThanOrEqualTo(40));

      for (final puzzle in puzzles) {
        final rule = answerRuleForPuzzle(puzzle);

        expect(
          hasConfiguredAnswerRuleForPuzzle(puzzle),
          isTrue,
          reason: 'Missing answer rule for ${puzzle.id}',
        );
        expect(rule.options, hasLength(3), reason: puzzle.id);
        expect(rule.options.toSet(), hasLength(3), reason: puzzle.id);
        expect(rule.options, contains(rule.correctAnswer), reason: puzzle.id);
        expect(rule.retryText, isNotEmpty, reason: puzzle.id);
      }
    });

    test('checks selected answer for specific puzzle', () {
      final puzzle = puzzleAreasForAge(ChildAge.six)
          .firstWhere((area) => area.id == 'logic')
          .puzzles
          .first;

      expect(answerRuleForPuzzle(puzzle).correctAnswer, 'Круг');
      expect(isCorrectAnswerForPuzzle(puzzle, 'Круг'), isTrue);
      expect(isCorrectAnswerForPuzzle(puzzle, 'Квадрат'), isFalse);
    });

    test('uses concrete trace task instead of abstract shadow guessing', () {
      final puzzle = puzzleAreasForAge(ChildAge.six)
          .firstWhere((area) => area.id == 'attention')
          .puzzles
          .firstWhere((puzzle) => puzzle.id == 'shadow-match');
      final rule = answerRuleForPuzzle(puzzle);

      expect(puzzle.title, 'След героя');
      expect(puzzle.prompt, contains('след'));
      expect(rule.options, ['След 1', 'След 2', 'След 3']);
      expect(rule.correctAnswer, 'След 2');
    });
  });
}
