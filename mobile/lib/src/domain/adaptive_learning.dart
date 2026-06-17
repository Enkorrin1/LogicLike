import 'family_profile.dart';

enum AdaptiveDifficultyMode {
  warmUp,
  steady,
  stretch,
}

enum AdaptiveReason {
  noRecentPractice,
  returningAfterBreak,
  needsSupport,
  steadyPractice,
  readyForChallenge,
}

class AdaptiveLessonPlan {
  const AdaptiveLessonPlan({
    required this.mode,
    required this.reason,
    required this.recentSessions,
    this.recentAccuracy,
    this.recentHints = 0,
    this.recentWrongAttempts = 0,
  });

  final AdaptiveDifficultyMode mode;
  final AdaptiveReason reason;
  final int recentSessions;
  final double? recentAccuracy;
  final int recentHints;
  final int recentWrongAttempts;

  bool get isWarmUp => mode == AdaptiveDifficultyMode.warmUp;

  bool get isStretch => mode == AdaptiveDifficultyMode.stretch;

  int adaptSmallNumber(int value) {
    if (isWarmUp) {
      return (value - 1).clamp(1, 20);
    }
    if (isStretch) {
      return (value + 1).clamp(1, 20);
    }
    return value;
  }

  int adaptStepSize(int value) {
    if (isWarmUp) {
      return 1;
    }
    if (isStretch) {
      return value + 1;
    }
    return value;
  }

  static AdaptiveLessonPlan forChild(
    ChildProfile child, {
    required DateTime now,
  }) {
    final recent = child.sessionsInLastDays(days: 7, now: now);
    if (recent.isEmpty) {
      return const AdaptiveLessonPlan(
        mode: AdaptiveDifficultyMode.warmUp,
        reason: AdaptiveReason.noRecentPractice,
        recentSessions: 0,
      );
    }

    final lastSessionDate = _dateOnly(recent.last.completedAt);
    if (_dateOnly(now).difference(lastSessionDate).inDays >= 3) {
      return AdaptiveLessonPlan(
        mode: AdaptiveDifficultyMode.warmUp,
        reason: AdaptiveReason.returningAfterBreak,
        recentSessions: recent.length,
        recentAccuracy: _accuracyFor(recent),
        recentHints: _sumHints(recent),
        recentWrongAttempts: _sumWrongAttempts(recent),
      );
    }

    final visible = recent.length > 5
        ? recent.sublist(recent.length - 5)
        : recent.toList(growable: false);
    final accuracy = _accuracyFor(visible);
    final hints = _sumHints(visible);
    final wrongAttempts = _sumWrongAttempts(visible);

    if ((accuracy != null && accuracy < 0.75) ||
        hints >= 2 ||
        wrongAttempts >= 2) {
      return AdaptiveLessonPlan(
        mode: AdaptiveDifficultyMode.warmUp,
        reason: AdaptiveReason.needsSupport,
        recentSessions: visible.length,
        recentAccuracy: accuracy,
        recentHints: hints,
        recentWrongAttempts: wrongAttempts,
      );
    }

    final lastThree = visible.length > 3
        ? visible.sublist(visible.length - 3)
        : visible.toList(growable: false);
    final lastThreeAccuracy = _accuracyFor(lastThree);
    final lastThreeHints = _sumHints(lastThree);
    final lastThreeWrongAttempts = _sumWrongAttempts(lastThree);
    if (lastThree.length >= 3 &&
        lastThreeAccuracy != null &&
        lastThreeAccuracy >= 0.95 &&
        lastThreeHints == 0 &&
        lastThreeWrongAttempts == 0) {
      return AdaptiveLessonPlan(
        mode: AdaptiveDifficultyMode.stretch,
        reason: AdaptiveReason.readyForChallenge,
        recentSessions: visible.length,
        recentAccuracy: accuracy,
        recentHints: hints,
        recentWrongAttempts: wrongAttempts,
      );
    }

    return AdaptiveLessonPlan(
      mode: AdaptiveDifficultyMode.steady,
      reason: AdaptiveReason.steadyPractice,
      recentSessions: visible.length,
      recentAccuracy: accuracy,
      recentHints: hints,
      recentWrongAttempts: wrongAttempts,
    );
  }

  static double? _accuracyFor(List<PracticeSession> sessions) {
    final totalQuestions = sessions.fold<int>(
      0,
      (total, session) => total + session.totalQuestions,
    );
    if (totalQuestions == 0) {
      return null;
    }

    final correctAnswers = sessions.fold<int>(
      0,
      (total, session) => total + session.correctAnswers,
    );
    return correctAnswers / totalQuestions;
  }

  static int _sumHints(List<PracticeSession> sessions) {
    return sessions.fold<int>(
      0,
      (total, session) => total + session.usedHints,
    );
  }

  static int _sumWrongAttempts(List<PracticeSession> sessions) {
    return sessions.fold<int>(
      0,
      (total, session) => total + session.wrongAttempts,
    );
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
