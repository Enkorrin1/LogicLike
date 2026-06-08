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
    final createdAt = DateTime.now();
    final child = ChildProfile(
      id: childProfileId(name: childName, createdAt: createdAt),
      name: childName,
      age: childAge,
      learningGoal: learningGoal,
      createdAt: createdAt,
    );
    final profile = FamilyProfile(
      childName: childName,
      childAge: childAge,
      learningGoal: learningGoal,
      createdAt: createdAt,
      childProfiles: [child],
      activeChildId: child.id,
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

    final activeChild = currentProfile.activeChild;
    final yesterday = today.subtract(const Duration(days: 1));
    final currentStreak =
        activeChild.completedOn(yesterday) ? activeChild.currentStreak + 1 : 1;
    final nextSession = PracticeSession(
      completedAt: now,
      challengeId: challenge.id,
      challengeTitle: challenge.title,
      skill: challenge.skill,
      minutes: challenge.minutes,
    );
    final nextChild = activeChild.copyWith(
      completedChallenges: activeChild.completedChallenges + 1,
      currentStreak: currentStreak,
      bestStreak: math.max(activeChild.bestStreak, currentStreak),
      totalPracticeMinutes:
          activeChild.totalPracticeMinutes + challenge.minutes,
      lastChallengeDate: today,
      lastChallengeId: challenge.id,
      lastChallengeSkill: challenge.skill,
      practiceSessions: [
        ...activeChild.practiceSessions,
        nextSession,
      ],
    );

    final nextProfile = currentProfile.withActiveChild(nextChild);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> addChildProfile({
    required String childName,
    required ChildAge childAge,
    required LearningGoal learningGoal,
  }) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || !currentProfile.canAddChild) {
      return;
    }

    final createdAt = DateTime.now();
    final child = ChildProfile(
      id: childProfileId(name: childName, createdAt: createdAt),
      name: childName,
      age: childAge,
      learningGoal: learningGoal,
      createdAt: createdAt,
    );
    final nextProfile = currentProfile.withActiveChild(child);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> selectChildProfile(String childId) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || currentProfile.activeChild.id == childId) {
      return;
    }

    final child = currentProfile.children.firstWhere(
      (profile) => profile.id == childId,
      orElse: () => currentProfile.activeChild,
    );
    if (child.id == currentProfile.activeChild.id) {
      return;
    }

    final nextProfile = currentProfile.withActiveChild(child);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> updateSubscriptionPlan(FamilySubscriptionPlan plan) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || currentProfile.subscriptionPlan == plan) {
      return;
    }

    final nextProfile = currentProfile.copyWith(
      subscriptionPlan: plan,
      subscriptionUpdatedAt: DateTime.now(),
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
