import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/app/app_controller.dart';
import 'package:logic_like/src/data/family_profile_store.dart';
import 'package:logic_like/src/domain/daily_challenge.dart';
import 'package:logic_like/src/domain/family_profile.dart';

void main() {
  group('AppController', () {
    test('loads existing family profile', () async {
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();

      expect(controller.isLoading, isFalse);
      expect(controller.familyProfile, profile);
    });

    test('creates and saves profile from onboarding', () async {
      final store = _InMemoryFamilyProfileStore();
      final controller = AppController(store);

      await controller.completeOnboarding(
        childName: 'Лев',
        childAge: ChildAge.five,
      );

      expect(store.savedProfile?.childName, 'Лев');
      expect(store.savedProfile?.childAge, ChildAge.five);
      expect(controller.familyProfile, store.savedProfile);
    });

    test('counts only one daily challenge completion per day', () async {
      final today = _today();
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedChallenges: 2,
        lastChallengeDate: today,
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeDailyChallenge(_challenge);

      expect(controller.familyProfile?.completedChallenges, 2);
      expect(controller.familyProfile?.lastChallengeDate, today);
    });
  });
}

const _challenge = DailyChallenge(
  id: 'test',
  title: 'Test',
  prompt: 'Test',
  skill: 'Test',
  minutes: 1,
);

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

class _InMemoryFamilyProfileStore implements FamilyProfileStore {
  _InMemoryFamilyProfileStore([this.savedProfile]);

  FamilyProfile? savedProfile;

  @override
  Future<void> clear() async {
    savedProfile = null;
  }

  @override
  Future<FamilyProfile?> load() async {
    return savedProfile;
  }

  @override
  Future<void> save(FamilyProfile profile) async {
    savedProfile = profile;
  }
}
