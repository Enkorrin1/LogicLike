import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/family_profile.dart';

void main() {
  group('FamilyProfile', () {
    test('serializes to json and restores from json', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8, 9),
        language: AppLanguage.en,
        completedChallenges: 2,
        completedLevels: 3,
        completedPracticePuzzleIds: const ['logic-1', 'memory-2'],
        lastChallengeDate: DateTime(2026, 6, 8),
        remindersEnabled: false,
      );

      final restored = FamilyProfile.fromJson(profile.toJson());

      expect(restored, profile);
    });

    test('restores older json without practice progress', () {
      final restored = FamilyProfile.fromJson({
        'childName': 'Lev',
        'childAge': ChildAge.five.name,
        'createdAt': DateTime(2026, 6, 8, 9).toIso8601String(),
      });

      expect(restored.completedPracticePuzzleIds, isEmpty);
      expect(restored.language, AppLanguage.ru);
      expect(restored.remindersEnabled, isTrue);
    });

    test('detects challenge completion by calendar date', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8),
        lastChallengeDate: DateTime(2026, 6, 8, 18, 30),
      );

      expect(profile.completedOn(DateTime(2026, 6, 8, 7)), isTrue);
      expect(profile.completedOn(DateTime(2026, 6, 9)), isFalse);
    });
  });
}
