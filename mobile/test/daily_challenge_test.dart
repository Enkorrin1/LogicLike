import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/daily_challenge.dart';
import 'package:logic_like/src/domain/family_profile.dart';

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

      final firstChallenge = dailyChallengeForDate(ChildAge.six, firstDate);
      final sameDayChallenge =
          dailyChallengeForDate(ChildAge.six, sameDateLater);

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
  });
}
