import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/app/logic_like_app.dart';
import 'package:logic_like/src/data/family_profile_store.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';
import 'package:logic_like/src/features/course/course_screen.dart';
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

  testWidgets('opens recommended lesson from home route card', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Next lesson'), findsOneWidget);

    await tester.tap(find.text('Continue'));
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
    expect(find.text('Lesson 1'), findsAtLeastNWidgets(1));
  });

  testWidgets('opens sticker collection from home summary card',
      (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.dragFrom(const Offset(400, 520), const Offset(0, -1300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My collection'));
    await tester.pumpAndSettle();

    expect(find.text('Sticker collection'), findsOneWidget);
    expect(find.text('Star helper'), findsOneWidget);
    expect(find.text('Next reward'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Courses and puzzles'), findsOneWidget);
  });

  testWidgets('shows concrete course lesson progress states', (tester) async {
    final profile = _testProfileWithCompletedLessons(['lesson.001']);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: CourseScreen(
          profile: profile,
          course: FoundationCatalog.starterCourses.first,
          onStartLesson: (_) {},
          onBackHome: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 of 4 lessons complete'), findsOneWidget);
    expect(find.text('Stars'), findsOneWidget);
    expect(find.text('+1 star'), findsNothing);
    expect(find.text('done'), findsOneWidget);
    expect(find.text('open'), findsAtLeastNWidgets(1));
    expect(find.text('locked'), findsAtLeastNWidgets(1));
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

  testWidgets('shows accuracy-based parent recommendation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: ParentScreen(
          profile: _testProfileWithPracticeSessions([
            PracticeSession(
              completedAt: DateTime.now(),
              challengeId: 'lesson.low-accuracy',
              challengeTitle: 'Low accuracy lesson',
              skill: 'Math thinking',
              minutes: 4,
              correctAnswers: 1,
              totalQuestions: 4,
              usedHints: 0,
              wrongAttempts: 3,
            ),
          ]),
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

    expect(
      find.textContaining('accuracy is the main signal'),
      findsOneWidget,
    );
  });
}

FamilyProfile _testProfile() {
  return FamilyProfile(
    childName: 'Leo',
    childAge: ChildAge.five,
    createdAt: DateTime(2026, 6, 8),
  );
}

FamilyProfile _testProfileWithPracticeSessions(List<PracticeSession> sessions) {
  return FamilyProfile(
    childName: 'Leo',
    childAge: ChildAge.five,
    createdAt: DateTime(2026, 6, 8),
    practiceSessions: sessions,
  );
}

FamilyProfile _testProfileWithCompletedLessons(List<String> lessonIds) {
  final createdAt = DateTime(2026, 6, 8);
  final child = ChildProfile(
    id: 'child-lesson-progress',
    name: 'Leo',
    age: ChildAge.five,
    createdAt: createdAt,
    completedLessonIds: lessonIds,
    completedMapNodeIds: const ['node.001'],
    mapStars: lessonIds.length,
  );

  return FamilyProfile(
    childName: child.name,
    childAge: child.age,
    createdAt: createdAt,
    childProfiles: [child],
    activeChildId: child.id,
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
