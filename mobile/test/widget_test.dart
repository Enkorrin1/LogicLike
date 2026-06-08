import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/app/logic_like_app.dart';
import 'package:logic_like/src/data/family_profile_store.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/features/parent/parent_screen.dart';
import 'package:logic_like/src/l10n/l10n.dart';
import 'package:logic_like/src/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows onboarding when family profile is empty', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Set up LogicLike'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Learning goal'), findsOneWidget);
  });

  testWidgets('opens daily lesson from home mission cta', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start quest'), findsOneWidget);

    await tester.tap(find.text('Start quest'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 3'), findsOneWidget);
  });

  testWidgets('shows a lesson hint before checking an answer', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start quest'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hint'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('The shapes alternate'),
      findsOneWidget,
    );
  });

  testWidgets('shows reward moment after completing a lesson', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Start quest'));
    await tester.pumpAndSettle();

    for (final answer in ['Circle', '3', 'Ball']) {
      final answerFinder = find.text(answer).last;
      await tester.ensureVisible(answerFinder);
      await tester.pumpAndSettle();
      await tester.tap(answerFinder);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Check'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();
      final nextLabel = answer == 'Ball' ? 'Finish lesson' : 'Next';
      await tester.ensureVisible(find.text(nextLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.text(nextLabel));
      await tester.pumpAndSettle();
    }

    expect(find.text('New sticker!'), findsOneWidget);
    expect(find.text('+1 sticker'), findsOneWidget);
  });

  testWidgets('opens a course from the home catalog', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Courses and puzzles'), findsOneWidget);

    await tester.ensureVisible(find.text('Logic'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logic'));
    await tester.pumpAndSettle();

    expect(find.text('0 of 4 lessons complete'), findsOneWidget);
    expect(find.text('Lesson 1'), findsOneWidget);
  });

  testWidgets('shows parent skill insights panel', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: ParentScreen(
          profile: _testProfile(),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.dragFrom(const Offset(400, 520), const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(find.text('Skills and recommendations'), findsOneWidget);
    expect(find.text('Strong area'), findsOneWidget);
    expect(find.text('Practice next'), findsOneWidget);
  });
}

FamilyProfile _testProfile() {
  return FamilyProfile(
    childName: 'Leo',
    childAge: ChildAge.five,
    createdAt: DateTime(2026, 6, 8),
  );
}

class _MemoryFamilyProfileStore implements FamilyProfileStore {
  _MemoryFamilyProfileStore(this.profile);

  FamilyProfile? profile;

  @override
  Future<void> clear() async {
    profile = null;
  }

  @override
  Future<FamilyProfile?> load() async {
    return profile;
  }

  @override
  Future<void> save(FamilyProfile profile) async {
    this.profile = profile;
  }
}
