import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/motivation_plan.dart';

void main() {
  group('MotivationPlan', () {
    test('tracks daily progress and next reward', () {
      final child = ChildProfile(
        id: 'child.motivation',
        name: 'Leo',
        age: ChildAge.six,
        createdAt: DateTime(2026, 6, 1),
        currentStreak: 2,
        mapStars: 3,
        practiceSessions: [
          PracticeSession(
            completedAt: DateTime(2026, 6, 13, 9),
            challengeId: 'lesson.001',
            challengeTitle: 'Lesson 1',
            skill: 'Patterns',
            minutes: 4,
          ),
        ],
      );

      final plan = MotivationPlan.forChild(
        child,
        now: DateTime(2026, 6, 13, 12),
      );

      expect(plan.completedTodaySessions, 1);
      expect(plan.sessionsLeftToday, 1);
      expect(plan.dailyProgress, 0.5);
      expect(plan.nextRewardStars, 4);
      expect(plan.starsToNextReward, 1);
      expect(plan.nextStreakMilestone, 3);
    });

    test('marks daily goal complete after two sessions today', () {
      final child = ChildProfile(
        id: 'child.done',
        name: 'Mira',
        age: ChildAge.seven,
        createdAt: DateTime(2026, 6, 1),
        currentStreak: 5,
        mapStars: 8,
        practiceSessions: [
          _session(9),
          _session(15),
        ],
      );

      final plan = MotivationPlan.forChild(
        child,
        now: DateTime(2026, 6, 13, 18),
      );

      expect(plan.dailyGoalComplete, isTrue);
      expect(plan.dailyProgress, 1);
      expect(plan.nextStreakMilestone, 10);
      expect(plan.nextRewardStars, 12);
    });
  });
}

PracticeSession _session(int hour) {
  return PracticeSession(
    completedAt: DateTime(2026, 6, 13, hour),
    challengeId: 'lesson.$hour',
    challengeTitle: 'Lesson',
    skill: 'Patterns',
    minutes: 4,
  );
}
