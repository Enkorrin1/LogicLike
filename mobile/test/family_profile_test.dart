import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/family_profile.dart';

void main() {
  group('FamilyProfile', () {
    test('serializes to json and restores from json', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8, 9),
        completedChallenges: 2,
        lastChallengeDate: DateTime(2026, 6, 8),
      );

      final restored = FamilyProfile.fromJson(profile.toJson());

      expect(restored, profile);
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
