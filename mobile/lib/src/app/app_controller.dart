import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/family_profile_store.dart';
import '../domain/daily_challenge.dart';
import '../domain/family_profile.dart';

class AppController extends ChangeNotifier {
  AppController(this._familyProfileStore);

  final FamilyProfileStore _familyProfileStore;

  bool _isLoading = true;
  FamilyProfile? _familyProfile;

  bool get isLoading => _isLoading;
  FamilyProfile? get familyProfile => _familyProfile;

  Future<void> load() async {
    _familyProfile = await _familyProfileStore.load();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required String childName,
    required ChildAge childAge,
    required LearningGoal learningGoal,
  }) async {
    final profile = FamilyProfile(
      childName: childName,
      childAge: childAge,
      learningGoal: learningGoal,
      createdAt: DateTime.now(),
    );

    await _familyProfileStore.save(profile);
    _familyProfile = profile;
    notifyListeners();
  }

  Future<void> completeDailyChallenge(DailyChallenge challenge) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null) {
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (currentProfile.completedOn(today)) {
      return;
    }

    final yesterday = today.subtract(const Duration(days: 1));
    final currentStreak = currentProfile.completedOn(yesterday)
        ? currentProfile.currentStreak + 1
        : 1;
    final nextSession = PracticeSession(
      completedAt: now,
      challengeId: challenge.id,
      challengeTitle: challenge.title,
      skill: challenge.skill,
      minutes: challenge.minutes,
    );

    final nextProfile = currentProfile.copyWith(
      completedChallenges: currentProfile.completedChallenges + 1,
      currentStreak: currentStreak,
      bestStreak: math.max(currentProfile.bestStreak, currentStreak),
      totalPracticeMinutes:
          currentProfile.totalPracticeMinutes + challenge.minutes,
      lastChallengeDate: today,
      lastChallengeId: challenge.id,
      lastChallengeSkill: challenge.skill,
      practiceSessions: [
        ...currentProfile.practiceSessions,
        nextSession,
      ],
    );

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> resetFamilyProfile() async {
    await _familyProfileStore.clear();
    _familyProfile = null;
    notifyListeners();
  }
}
