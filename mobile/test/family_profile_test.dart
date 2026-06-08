import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/family_profile.dart';

void main() {
  group('FamilyProfile', () {
    test('serializes to json and restores from json', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8, 9),
        learningGoal: LearningGoal.attention,
        completedChallenges: 2,
        currentStreak: 2,
        bestStreak: 3,
        totalPracticeMinutes: 9,
        lastChallengeDate: DateTime(2026, 6, 8),
        lastChallengeId: 'shape-path',
        lastChallengeSkill: 'Внимание и закономерности',
        practiceSessions: [
          PracticeSession(
            completedAt: DateTime(2026, 6, 8, 18, 30),
            challengeId: 'shape-path',
            challengeTitle: 'Дорожка фигур',
            skill: 'Внимание и закономерности',
            minutes: 4,
          ),
        ],
      );

      final restored = FamilyProfile.fromJson(profile.toJson());

      expect(restored, profile);
    });

    test('restores old saved profile with default progress fields', () {
      final restored = FamilyProfile.fromJson({
        'childName': 'Мира',
        'childAge': 'six',
        'createdAt': DateTime(2026, 6, 8).toIso8601String(),
        'completedChallenges': 1,
      });

      expect(restored.learningGoal, LearningGoal.logic);
      expect(restored.currentStreak, 0);
      expect(restored.bestStreak, 0);
      expect(restored.totalPracticeMinutes, 0);
      expect(restored.practiceSessions, isEmpty);
    });

    test('detects challenge completion by calendar date', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8),
        lastChallengeDate: DateTime(2026, 6, 8, 18, 30),
      );

      expect(profile.completedOn(DateTime(2026, 6, 8, 7)), isTrue);
      expect(profile.completedOn(DateTime(2026, 6, 9)), isFalse);
    });

    test('returns practice sessions inside the requested day window', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 1),
        practiceSessions: [
          PracticeSession(
            completedAt: DateTime(2026, 6, 1, 17),
            challengeId: 'old',
            challengeTitle: 'Старое задание',
            skill: 'Логика',
            minutes: 3,
          ),
          PracticeSession(
            completedAt: DateTime(2026, 6, 7, 17),
            challengeId: 'recent',
            challengeTitle: 'Новое задание',
            skill: 'Внимание',
            minutes: 4,
          ),
        ],
      );

      final sessions = profile.sessionsInLastDays(
        days: 7,
        now: DateTime(2026, 6, 8),
      );

      expect(sessions.map((session) => session.challengeId), ['recent']);
    });
  });
}
