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
  }) async {
    final profile = FamilyProfile(
      childName: childName,
      childAge: childAge,
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
    final dailyProgressDate = currentProfile.dailyProgressDate;
    final sameDailyProgressDay = dailyProgressDate != null &&
        DateTime(
              dailyProgressDate.year,
              dailyProgressDate.month,
              dailyProgressDate.day,
            ) ==
            today;
    final previousDailyIds = sameDailyProgressDay
        ? currentProfile.dailyCompletedPuzzleIds
        : const <String>[];
    final alreadyCompletedDailyPuzzle = previousDailyIds.contains(challenge.id);
    final nextDailyIds = {
      ...previousDailyIds,
      challenge.id,
    }.toList(growable: false);
    final dailyTarget = dailyChallengesForAge(currentProfile.childAge).length;
    final alreadyCompletedToday = currentProfile.completedOn(today);
    final completedDailySet = nextDailyIds.length >= dailyTarget;

    final nextProfile = currentProfile.copyWith(
      completedChallenges: alreadyCompletedToday || !completedDailySet
          ? currentProfile.completedChallenges
          : currentProfile.completedChallenges + 1,
      completedLevels:
          alreadyCompletedDailyPuzzle || currentProfile.completedLevels >= 8
              ? currentProfile.completedLevels
              : currentProfile.completedLevels + 1,
      dailyProgressDate: today,
      dailyCompletedPuzzleIds: nextDailyIds,
      lastChallengeDate:
          completedDailySet ? today : currentProfile.lastChallengeDate,
    );

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> completePracticePuzzle(DailyChallenge challenge) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null) {
      return;
    }

    final completedPracticeIds = currentProfile.completedPracticePuzzleIds;
    final alreadyCompleted = completedPracticeIds.contains(challenge.id);
    final nextPracticeIds = alreadyCompleted
        ? completedPracticeIds
        : <String>[...completedPracticeIds, challenge.id];

    final nextProfile = currentProfile.copyWith(
      completedLevels: alreadyCompleted || currentProfile.completedLevels >= 8
          ? currentProfile.completedLevels
          : currentProfile.completedLevels + 1,
      completedPracticePuzzleIds: nextPracticeIds,
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
