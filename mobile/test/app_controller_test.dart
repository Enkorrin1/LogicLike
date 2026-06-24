import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:logicx/src/app/app_controller.dart';
import 'package:logicx/src/data/family_profile_store.dart';
import 'package:logicx/src/data/locale_store.dart';
import 'package:logicx/src/domain/daily_challenge.dart';
import 'package:logicx/src/domain/family_profile.dart';
import 'package:logicx/src/notifications/app_notification_service.dart';

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

    test('schedules reminders for loaded profile', () async {
      final profile = FamilyProfile(
        childName: 'Mira',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final reminders = _FakeReminderScheduler();
      final controller = AppController(
        _InMemoryFamilyProfileStore(profile),
        reminderScheduler: reminders,
      );

      await controller.load();

      expect(reminders.scheduledProfiles, [profile]);
      expect(reminders.cancelCount, 0);
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
        completedLevels: 2,
        lastChallengeDate: today,
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeDailyChallenge(_challenge);

      expect(controller.familyProfile?.completedChallenges, 2);
      expect(controller.familyProfile?.completedLevels, 3);
      expect(controller.familyProfile?.lastChallengeDate, today);
    });

    test('does not count replayed daily puzzle as a new level', () async {
      final today = _today();
      final profile = FamilyProfile(
        childName: 'РњРёСЂР°',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedLevels: 2,
        dailyProgressDate: today,
        dailyCompletedPuzzleIds: const ['test'],
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeDailyChallenge(_challenge);

      expect(controller.familyProfile?.completedLevels, 2);
      expect(controller.familyProfile?.dailyCompletedPuzzleIds, ['test']);
    });

    test('stores free practice puzzles once', () async {
      final profile = FamilyProfile(
        childName: 'РњРёСЂР°',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedLevels: 2,
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completePracticePuzzle(_challenge);
      await controller.completePracticePuzzle(_challenge);

      expect(controller.familyProfile?.completedLevels, 3);
      expect(controller.familyProfile?.completedPracticePuzzleIds, ['test']);
    });

    test('loads and saves selected locale', () async {
      final localeStore = _InMemoryLocaleStore(const Locale('en'));
      final controller = AppController(
        _InMemoryFamilyProfileStore(),
        localeStore: localeStore,
      );

      await controller.load();
      expect(controller.locale, const Locale('en'));

      await controller.changeLocale(const Locale('de'));
      expect(controller.locale, const Locale('de'));
      expect(localeStore.savedLocale, const Locale('de'));
    });

    test('changes and saves app language', () async {
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.changeLanguage(AppLanguage.en);

      expect(controller.familyProfile?.language, AppLanguage.en);
      expect(store.savedProfile?.language, AppLanguage.en);
    });

    test('reschedules reminders after language changes', () async {
      final profile = FamilyProfile(
        childName: 'Mira',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final reminders = _FakeReminderScheduler();
      final controller = AppController(
        _InMemoryFamilyProfileStore(profile),
        reminderScheduler: reminders,
      );

      await controller.load();
      await controller.changeLanguage(AppLanguage.en);

      expect(reminders.scheduledProfiles.length, 2);
      expect(reminders.scheduledProfiles.last.language, AppLanguage.en);
    });

    test('changes and saves reminder preference', () async {
      final profile = FamilyProfile(
        childName: 'Mira',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final reminders = _FakeReminderScheduler();
      final controller = AppController(
        store,
        reminderScheduler: reminders,
      );

      await controller.load();
      await controller.changeReminderPreference(false);

      expect(controller.familyProfile?.remindersEnabled, isFalse);
      expect(store.savedProfile?.remindersEnabled, isFalse);
      expect(reminders.scheduledProfiles.last.remindersEnabled, isFalse);
    });

    test('cancels reminders when profile is reset', () async {
      final profile = FamilyProfile(
        childName: 'Mira',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final reminders = _FakeReminderScheduler();
      final controller = AppController(
        _InMemoryFamilyProfileStore(profile),
        reminderScheduler: reminders,
      );

      await controller.load();
      await controller.resetFamilyProfile();

      expect(controller.familyProfile, isNull);
      expect(reminders.cancelCount, 1);
    });
  });
}

const _challenge = DailyChallenge(
  id: 'test',
  title: 'Test',
  prompt: 'Test',
  skill: 'Test',
  minutes: 1,
  areaId: 'test',
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

class _InMemoryLocaleStore implements LocaleStore {
  _InMemoryLocaleStore([this.savedLocale]);

  Locale? savedLocale;

  @override
  Future<Locale?> load() async {
    return savedLocale;
  }

  @override
  Future<void> save(Locale locale) async {
    savedLocale = locale;
  }
}

class _FakeReminderScheduler implements ReminderScheduler {
  final scheduledProfiles = <FamilyProfile>[];
  int cancelCount = 0;

  @override
  Future<void> cancelAllReminders() async {
    cancelCount += 1;
  }

  @override
  Future<void> scheduleForProfile(FamilyProfile profile) async {
    scheduledProfiles.add(profile);
  }
}
