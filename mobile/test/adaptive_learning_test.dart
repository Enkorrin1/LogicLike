import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/adaptive_learning.dart';
import 'package:logic_like/src/domain/daily_challenge.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';

void main() {
  group('AdaptiveLessonPlan', () {
    test('starts gently when there is no recent practice', () {
      final child = _child();
      final plan = AdaptiveLessonPlan.forChild(
        child,
        now: DateTime(2026, 6, 13),
      );

      expect(plan.mode, AdaptiveDifficultyMode.warmUp);
      expect(plan.reason, AdaptiveReason.noRecentPractice);
    });

    test('adds support after low accuracy or repeated mistakes', () {
      final child = _child(
        sessions: [
          _session(
            correctAnswers: 1,
            totalQuestions: 4,
            usedHints: 1,
            wrongAttempts: 2,
          ),
        ],
      );
      final plan = AdaptiveLessonPlan.forChild(
        child,
        now: DateTime(2026, 6, 13),
      );

      expect(plan.mode, AdaptiveDifficultyMode.warmUp);
      expect(plan.reason, AdaptiveReason.needsSupport);
    });

    test('unlocks stretch mode after confident recent sessions', () {
      final child = _child(
        sessions: [
          _session(daysAgo: 2),
          _session(daysAgo: 1),
          _session(),
        ],
      );
      final plan = AdaptiveLessonPlan.forChild(
        child,
        now: DateTime(2026, 6, 13),
      );

      expect(plan.mode, AdaptiveDifficultyMode.stretch);
      expect(plan.reason, AdaptiveReason.readyForChallenge);
    });

    test('changes generated numeric lesson variants predictably', () {
      final step = FoundationCatalog.starterLessonSteps.firstWhere(
        (step) => step.puzzleId == 'puzzle.toy_count',
      );
      final puzzle = FoundationCatalog.puzzleForStep(step);
      final warmUp = dailyChallengeForLessonStep(
        step,
        puzzle,
        age: ChildAge.six,
        adaptivePlan: const AdaptiveLessonPlan(
          mode: AdaptiveDifficultyMode.warmUp,
          reason: AdaptiveReason.needsSupport,
          recentSessions: 1,
        ),
      );
      final stretch = dailyChallengeForLessonStep(
        step,
        puzzle,
        age: ChildAge.six,
        adaptivePlan: const AdaptiveLessonPlan(
          mode: AdaptiveDifficultyMode.stretch,
          reason: AdaptiveReason.readyForChallenge,
          recentSessions: 3,
        ),
      );

      expect(stretch.numbers[2], greaterThan(warmUp.numbers[2]));
      expect(stretch.correctChoiceId, isNot(warmUp.correctChoiceId));
    });
  });
}

ChildProfile _child({List<PracticeSession> sessions = const []}) {
  return ChildProfile(
    id: 'child.test',
    name: 'Leo',
    age: ChildAge.six,
    createdAt: DateTime(2026, 6, 1),
    practiceSessions: sessions,
  );
}

PracticeSession _session({
  int daysAgo = 0,
  int correctAnswers = 4,
  int totalQuestions = 4,
  int usedHints = 0,
  int wrongAttempts = 0,
}) {
  return PracticeSession(
    completedAt: DateTime(2026, 6, 13).subtract(Duration(days: daysAgo)),
    challengeId: 'lesson.test.$daysAgo',
    challengeTitle: 'Lesson',
    skill: 'Patterns',
    minutes: 4,
    correctAnswers: correctAnswers,
    totalQuestions: totalQuestions,
    usedHints: usedHints,
    wrongAttempts: wrongAttempts,
  );
}
