import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/parent_weekly_report.dart';

void main() {
  group('ParentWeeklyReport', () {
    test('marks low accuracy and mistakes as support needed', () {
      final report = ParentWeeklyReport.fromSessions([
        _session(correctAnswers: 1, totalQuestions: 4, wrongAttempts: 3),
        _session(correctAnswers: 2, totalQuestions: 4, usedHints: 1),
      ]);

      expect(report.status, ParentWeeklyStatus.needsSupport);
      expect(report.accuracy, lessThan(0.75));
      expect(report.wrongAttempts, 3);
    });

    test('marks consistent accurate practice as strong', () {
      final report = ParentWeeklyReport.fromSessions([
        _session(),
        _session(),
        _session(),
        _session(),
      ]);

      expect(report.status, ParentWeeklyStatus.strong);
      expect(report.sessionsCount, 4);
      expect(report.accuracy, 1);
    });
  });
}

PracticeSession _session({
  int correctAnswers = 4,
  int totalQuestions = 4,
  int usedHints = 0,
  int wrongAttempts = 0,
}) {
  return PracticeSession(
    completedAt: DateTime(2026, 6, 13),
    challengeId: 'lesson.report',
    challengeTitle: 'Lesson',
    skill: 'Patterns',
    minutes: 4,
    correctAnswers: correctAnswers,
    totalQuestions: totalQuestions,
    usedHints: usedHints,
    wrongAttempts: wrongAttempts,
  );
}
