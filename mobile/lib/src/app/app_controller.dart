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

  Future<void> completeDailyChallenge(DailyChallenge _) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null) {
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final alreadyCompletedToday = currentProfile.completedOn(today);

    final nextProfile = currentProfile.copyWith(
      completedChallenges: alreadyCompletedToday
          ? currentProfile.completedChallenges
          : currentProfile.completedChallenges + 1,
      completedLevels: currentProfile.completedLevels >= 8
          ? currentProfile.completedLevels
          : currentProfile.completedLevels + 1,
      lastChallengeDate: today,
    );

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> completePracticePuzzle(DailyChallenge _) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null) {
      return;
    }

    final nextProfile = currentProfile.copyWith(
      completedLevels: currentProfile.completedLevels >= 8
          ? currentProfile.completedLevels
          : currentProfile.completedLevels + 1,
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
