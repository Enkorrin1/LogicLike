import 'family_profile.dart';

class MotivationPlan {
  const MotivationPlan({
    required this.dailyGoalSessions,
    required this.completedTodaySessions,
    required this.currentStreak,
    required this.nextStreakMilestone,
    required this.stars,
    required this.nextRewardStars,
  });

  final int dailyGoalSessions;
  final int completedTodaySessions;
  final int currentStreak;
  final int nextStreakMilestone;
  final int stars;
  final int? nextRewardStars;

  double get dailyProgress {
    return (completedTodaySessions / dailyGoalSessions).clamp(0.0, 1.0);
  }

  bool get dailyGoalComplete {
    return completedTodaySessions >= dailyGoalSessions;
  }

  int get sessionsLeftToday {
    return (dailyGoalSessions - completedTodaySessions).clamp(0, 99);
  }

  int? get starsToNextReward {
    final target = nextRewardStars;
    if (target == null) {
      return null;
    }
    return (target - stars).clamp(0, 999);
  }

  static MotivationPlan forChild(
    ChildProfile child, {
    required DateTime now,
  }) {
    const rewardMilestones = [0, 1, 2, 4, 6, 8, 12, 16, 20];
    const dailyGoalSessions = 2;
    final todaySessions = child.sessionsInLastDays(days: 1, now: now).length;
    final streak = child.currentStreak;
    final nextStreakMilestone = _nextMilestone(streak);
    final nextRewardStars = rewardMilestones
        .where((milestone) => milestone > child.mapStars)
        .firstOrNull;

    return MotivationPlan(
      dailyGoalSessions: dailyGoalSessions,
      completedTodaySessions: todaySessions,
      currentStreak: streak,
      nextStreakMilestone: nextStreakMilestone,
      stars: child.mapStars,
      nextRewardStars: nextRewardStars,
    );
  }

  static int _nextMilestone(int streak) {
    if (streak < 3) {
      return 3;
    }
    if (streak < 5) {
      return 5;
    }
    if (streak < 10) {
      return 10;
    }
    return ((streak ~/ 5) + 1) * 5;
  }
}
