import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/data/family_profile_store.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesFamilyProfileStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('returns null when profile has not been saved', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesFamilyProfileStore(preferences);

      expect(await store.load(), isNull);
    });

    test('saves and loads family profile', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesFamilyProfileStore(preferences);
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedChallenges: 3,
        lastChallengeDate: DateTime(2026, 6, 8),
      );

      await store.save(profile);

      expect(await store.load(), profile);
    });

    test('clears saved family profile', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesFamilyProfileStore(preferences);
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );

      await store.save(profile);
      await store.clear();

      expect(await store.load(), isNull);
    });
  });
}
