import 'family_profile.dart';

enum ParentWeeklyStatus {
  gettingStarted,
  needsSupport,
  steady,
  strong,
}

class ParentWeeklyReport {
  const ParentWeeklyReport({
    required this.status,
    required this.sessionsCount,
    required this.minutes,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
  });

  final ParentWeeklyStatus status;
  final int sessionsCount;
  final int minutes;
  final int correctAnswers;
  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;

  double? get accuracy {
    if (totalQuestions == 0) {
      return null;
    }
    return correctAnswers / totalQuestions;
  }

  bool get hasEnoughData => sessionsCount >= 2;

  static ParentWeeklyReport fromSessions(List<PracticeSession> sessions) {
    final minutes = sessions.fold<int>(
      0,
      (total, session) => total + session.minutes,
    );
    final correctAnswers = sessions.fold<int>(
      0,
      (total, session) => total + session.correctAnswers,
    );
    final totalQuestions = sessions.fold<int>(
      0,
      (total, session) => total + session.totalQuestions,
    );
    final usedHints = sessions.fold<int>(
      0,
      (total, session) => total + session.usedHints,
    );
    final wrongAttempts = sessions.fold<int>(
      0,
      (total, session) => total + session.wrongAttempts,
    );
    final report = ParentWeeklyReport(
      status: ParentWeeklyStatus.gettingStarted,
      sessionsCount: sessions.length,
      minutes: minutes,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      usedHints: usedHints,
      wrongAttempts: wrongAttempts,
    );

    return ParentWeeklyReport(
      status: _statusFor(report),
      sessionsCount: report.sessionsCount,
      minutes: report.minutes,
      correctAnswers: report.correctAnswers,
      totalQuestions: report.totalQuestions,
      usedHints: report.usedHints,
      wrongAttempts: report.wrongAttempts,
    );
  }

  static ParentWeeklyStatus _statusFor(ParentWeeklyReport report) {
    final accuracy = report.accuracy;
    if (!report.hasEnoughData) {
      return ParentWeeklyStatus.gettingStarted;
    }
    if ((accuracy != null && accuracy < 0.75) ||
        report.usedHints >= 3 ||
        report.wrongAttempts >= 3) {
      return ParentWeeklyStatus.needsSupport;
    }
    if (report.sessionsCount >= 4 &&
        accuracy != null &&
        accuracy >= 0.9 &&
        report.usedHints <= 1 &&
        report.wrongAttempts <= 1) {
      return ParentWeeklyStatus.strong;
    }
    return ParentWeeklyStatus.steady;
  }
}
