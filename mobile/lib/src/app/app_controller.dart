import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../data/family_profile_store.dart';
import '../data/locale_store.dart';
import '../domain/daily_challenge.dart';
import '../domain/family_profile.dart';
import '../notifications/app_notification_service.dart';

class AppController extends ChangeNotifier {
  AppController(
    this._familyProfileStore, {
    LocaleStore? localeStore,
    ReminderScheduler? reminderScheduler,
  })  : _localeStore = localeStore,
        _reminderScheduler = reminderScheduler;

  final FamilyProfileStore _familyProfileStore;
  final LocaleStore? _localeStore;
  final ReminderScheduler? _reminderScheduler;

  bool _isLoading = true;
  FamilyProfile? _familyProfile;
  Locale _locale = const Locale('ru');

  bool get isLoading => _isLoading;
  FamilyProfile? get familyProfile => _familyProfile;
  Locale get locale => _locale;

  Future<void> load() async {
    final loaded = await Future.wait<Object?>([
      _familyProfileStore.load(),
      _localeStore?.load() ?? Future<Locale?>.value(),
    ]);
    _familyProfile = loaded[0] as FamilyProfile?;
    _locale = loaded[1] as Locale? ?? const Locale('ru');
    _isLoading = false;
    notifyListeners();
    await _syncRemindersFor(_familyProfile);
  }

  Future<void> changeLocale(Locale locale) async {
    if (_locale == locale) {
      return;
    }

    _locale = locale;
    notifyListeners();
    await _localeStore?.save(locale);
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
    await _syncRemindersFor(profile);
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
    await _syncRemindersFor(nextProfile);
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
    await _syncRemindersFor(nextProfile);
  }

  Future<void> changeLanguage(AppLanguage language) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || currentProfile.language == language) {
      return;
    }

    final nextProfile = currentProfile.copyWith(language: language);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
    await _syncRemindersFor(nextProfile);
  }

  Future<void> changeReminderPreference(bool enabled) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || currentProfile.remindersEnabled == enabled) {
      return;
    }

    final nextProfile = currentProfile.copyWith(remindersEnabled: enabled);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
    await _syncRemindersFor(nextProfile);
  }

  Future<void> resetFamilyProfile() async {
    await _familyProfileStore.clear();
    _familyProfile = null;
    notifyListeners();
    await _syncRemindersFor(null);
  }

  Future<void> _syncRemindersFor(FamilyProfile? profile) async {
    final scheduler = _reminderScheduler;
    if (scheduler == null) {
      return;
    }

    try {
      if (profile == null) {
        await scheduler.cancelAllReminders();
      } else {
        await scheduler.scheduleForProfile(profile);
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'app_controller',
          context: ErrorDescription('syncing reminder notifications'),
        ),
      );
    }
  }
}
