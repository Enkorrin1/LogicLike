import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/app/logic_like_app.dart';
import 'package:logic_like/src/data/app_locale_store.dart';
import 'package:logic_like/src/data/family_profile_store.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';
import 'package:logic_like/src/features/course/course_screen.dart';
import 'package:logic_like/src/features/lesson/lesson_screen.dart';
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

    await tester.scrollUntilVisible(
      find.text('Start quest'),
      500,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.text('Start quest').last);
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 4'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.key is ValueKey<String> &&
            (widget.key! as ValueKey<String>)
                .value
                .startsWith('character-pose-'),
      ),
      findsWidgets,
    );
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

    await tester.scrollUntilVisible(
      find.text('Next lesson'),
      500,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 4'), findsOneWidget);
  });

  testWidgets('shows daily bonus motivation card on home', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('daily-bonus-card')),
      500,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byKey(const ValueKey('daily-bonus-card')), findsOneWidget);
    expect(find.text('Daily bonus'), findsOneWidget);
    expect(find.textContaining('today'), findsWidgets);
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

    await tester.scrollUntilVisible(
      find.text('Start quest'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Start quest').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hint'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('hint-lightbulb-moment')), findsOneWidget);
    expect(
      find.textContaining('The rule repeats'),
      findsWidgets,
    );
  });

  testWidgets('opens a retry hint after a wrong lesson answer', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Start quest'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Start quest').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Triangle').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Triangle').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('lesson-polish-marker')), findsOneWidget);
    expect(find.byType(AnimatedScale), findsWidgets);

    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Think step by step'), findsOneWidget);
    expect(
      find.text('Good try. Read the hint, then choose again.'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(find.text('Try again'), 300);

    expect(find.text('Try again'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Circle').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Correct!'), findsNothing);
    expect(find.textContaining('Correct!'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
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

    await tester.scrollUntilVisible(
      find.text('Start quest'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Start quest').last);
    await tester.pumpAndSettle();

    for (final answer in ['Circle', '6', 'Shoe', 'Lock']) {
      final answerFinder = find.text(answer).last;
      await tester.ensureVisible(answerFinder);
      await tester.pumpAndSettle();
      await tester.tap(answerFinder);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Check'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();
      final nextLabel = answer == 'Lock' ? 'Finish lesson' : 'Next';
      await tester.ensureVisible(find.text(nextLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.text(nextLabel));
      await tester.pumpAndSettle();
    }

    expect(find.text('New sticker!'), findsOneWidget);
    expect(find.byKey(const ValueKey('reward-polish-marker')), findsOneWidget);
    expect(find.byKey(const ValueKey('reward-flying-stars')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('reward-character-victory')), findsOneWidget);
    expect(find.text('Lesson summary'), findsOneWidget);
    expect(find.text('Questions'), findsOneWidget);
    expect(find.text('+1 sticker'), findsOneWidget);

    await tester.ensureVisible(find.text('Next lesson'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next lesson'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Step 1 of'), findsOneWidget);
  });

  testWidgets('odd-card visual matches generated puzzle tokens',
      (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Start quest'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Start quest').last);
    await tester.pumpAndSettle();

    for (final answer in ['Circle', '6']) {
      final answerFinder = find.text(answer).last;
      await tester.ensureVisible(answerFinder);
      await tester.pumpAndSettle();
      await tester.tap(answerFinder);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Check'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    expect(
      find.textContaining('Circle, Square, Triangle, Shoe'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('visual-token-circle')), findsOneWidget);
    expect(find.byKey(const ValueKey('visual-token-square')), findsOneWidget);
    expect(find.byKey(const ValueKey('visual-token-triangle')), findsOneWidget);
    expect(find.byKey(const ValueKey('visual-token-shoe')), findsOneWidget);
    expect(find.byKey(const ValueKey('visual-token-apple')), findsNothing);
    expect(find.byKey(const ValueKey('visual-token-banana')), findsNothing);
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

    expect(find.text('0 of 20 lessons complete'), findsOneWidget);
    expect(find.text('Shape path'), findsAtLeastNWidgets(1));
  });

  testWidgets('quest tab opens the full level catalog', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Quest'));
    await tester.pumpAndSettle();

    expect(find.text('Courses and puzzles'), findsOneWidget);
    expect(find.text('0 of 60 lessons complete'), findsOneWidget);
    expect(find.text('Logic'), findsOneWidget);
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

    expect(find.text('1 of 20 lessons complete'), findsOneWidget);
    expect(find.text('Stars'), findsOneWidget);
    expect(find.text('+1 star'), findsNothing);
    expect(find.text('done'), findsOneWidget);
    expect(find.text('open'), findsAtLeastNWidgets(1));
    expect(find.text('locked'), findsNothing);
    expect(find.text('open'), findsAtLeastNWidgets(1));
  });

  testWidgets('detail-count visual colors match localized labels',
      (tester) async {
    final profile = _testProfile();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: LessonScreen(
          profile: profile,
          lessonId: 'lesson.008',
          onLessonComplete: ({
            required lessonId,
            required challenge,
            correctAnswers = 0,
            totalQuestions = 0,
            usedHints = 0,
            wrongAttempts = 0,
          }) async {},
          onBackToMap: () {},
          onNextLessonSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('красных кругов'), findsOneWidget);
    expect(find.textContaining('синих квадратов'), findsOneWidget);
    expect(find.textContaining('зеленых звезд'), findsOneWidget);

    final redCircle = tester.widget<SvgPicture>(
      find.byKey(const ValueKey('detail-red-circle-2-svg')),
    );
    final blueSquare = tester.widget<SvgPicture>(
      find.byKey(const ValueKey('detail-blue-square-1-svg')),
    );

    expect(
      redCircle.colorFilter.toString(),
      contains('Color(alpha: 1.0000, red: 1.0000'),
    );
    expect(
      blueSquare.colorFilter.toString(),
      contains('blue: 0.9686'),
    );
  });

  testWidgets('numeric puzzle answers use svg visuals', (tester) async {
    final profile = _testProfile();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: LessonScreen(
          profile: profile,
          lessonId: 'lesson.002',
          onLessonComplete: ({
            required lessonId,
            required challenge,
            correctAnswers = 0,
            totalQuestions = 0,
            usedHints = 0,
            wrongAttempts = 0,
          }) async {},
          onBackToMap: () {},
          onNextLessonSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('number-svg-4')), findsWidgets);
  });

  testWidgets('expression puzzle answers use composed svg visuals',
      (tester) async {
    final profile = _testProfile();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: LessonScreen(
          profile: profile,
          lessonId: 'lesson.007',
          onLessonComplete: ({
            required lessonId,
            required challenge,
            correctAnswers = 0,
            totalQuestions = 0,
            usedHints = 0,
            wrongAttempts = 0,
          }) async {},
          onBackToMap: () {},
          onNextLessonSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.key is ValueKey<String> &&
            (widget.key! as ValueKey<String>)
                .value
                .startsWith('expression-svg-'),
      ),
      findsWidgets,
    );
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
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Skills and recommendations'),
      700,
    );
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
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.textContaining('accuracy is the main signal'),
      700,
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('accuracy is the main signal'),
      findsOneWidget,
    );
  });

  testWidgets('shows parent weekly action plan', (tester) async {
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
              challengeId: 'lesson.plan.1',
              challengeTitle: 'Plan lesson 1',
              skill: 'Patterns',
              minutes: 4,
              correctAnswers: 4,
              totalQuestions: 4,
            ),
            PracticeSession(
              completedAt: DateTime.now(),
              challengeId: 'lesson.plan.2',
              challengeTitle: 'Plan lesson 2',
              skill: 'Patterns',
              minutes: 4,
              correctAnswers: 3,
              totalQuestions: 4,
            ),
          ]),
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Weekly action plan'), 700);
    await tester.pumpAndSettle();

    expect(find.text('Weekly action plan'), findsOneWidget);
    expect(find.textContaining('Sessions: 2'), findsOneWidget);
    expect(find.textContaining('Keep'), findsWidgets);
  });

  testWidgets('shows recent practice history for parents', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: ParentScreen(
          profile: _testProfileWithPracticeSessions([
            PracticeSession(
              completedAt: DateTime(2026, 6, 10, 18),
              challengeId: 'lesson.old',
              challengeTitle: 'Old lesson',
              skill: 'Logic',
              minutes: 3,
              correctAnswers: 2,
              totalQuestions: 4,
              usedHints: 1,
              wrongAttempts: 2,
            ),
            PracticeSession(
              completedAt: DateTime(2026, 6, 11, 18),
              challengeId: 'lesson.recent',
              challengeTitle: 'Recent lesson',
              skill: 'Math thinking',
              minutes: 5,
              correctAnswers: 4,
              totalQuestions: 4,
              usedHints: 0,
              wrongAttempts: 0,
            ),
          ]),
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Practice history'), 700);
    await tester.pumpAndSettle();

    expect(find.text('Practice history'), findsOneWidget);
    expect(find.text('Accuracy 100%'), findsOneWidget);
    expect(find.text('Mistakes 0'), findsOneWidget);
  });

  testWidgets('switches and saves app language from parent settings',
      (tester) async {
    final profileStore = _MemoryFamilyProfileStore(_testProfile());
    final localeStore = _MemoryAppLocaleStore();

    await tester.pumpWidget(
      LogicLikeApp(
        appLocaleStore: localeStore,
        familyProfileStore: profileStore,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Родителю'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Язык приложения'), 700);
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(localeStore.locale, const Locale('en'));
    expect(find.text('App language'), findsOneWidget);
    expect(find.text('Parent'), findsOneWidget);

    for (var attempt = 0;
        attempt < 6 && find.text('Русский').evaluate().isEmpty;
        attempt += 1) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -240));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Русский'));
    await tester.pumpAndSettle();

    expect(localeStore.locale, const Locale('ru'));
    expect(find.text('Язык приложения'), findsOneWidget);
    expect(find.text('Родителю'), findsOneWidget);
  });

  testWidgets('Russian quest navigation opens the full catalog and lesson',
      (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('ru'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Задание'));
    await tester.pumpAndSettle();

    expect(find.text('Курсы и головоломки'), findsOneWidget);
    expect(find.text('0 из 60 уроков пройдено'), findsOneWidget);

    await tester.tap(find.text('Логика').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Старт').first);
    await tester.pumpAndSettle();

    expect(find.text('Шаг 1 из 4'), findsOneWidget);
    expect(find.textContaining('Дорожка фигур'), findsWidgets);
  });

  testWidgets('parent reset clears local profile and returns to onboarding',
      (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: store,
        locale: const Locale('ru'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Родителю'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Сброс'), 700);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Сброс').last);
    await tester.pumpAndSettle();

    expect(find.text('Сбросить профиль?'), findsOneWidget);

    await tester.tap(find.text('Сбросить'));
    await tester.pumpAndSettle();

    expect(store.profile, isNull);
    expect(find.text('Настроим LogicLike'), findsOneWidget);
  });
}

FamilyProfile _testProfile() {
  return FamilyProfile(
    childName: 'Leo',
    childAge: ChildAge.five,
    createdAt: DateTime(2026, 6, 8),
    practiceSessions: [
      PracticeSession(
        completedAt: DateTime.now(),
        challengeId: 'lesson.fixture',
        challengeTitle: 'Fixture lesson',
        skill: 'Patterns',
        minutes: 4,
        correctAnswers: 3,
        totalQuestions: 4,
      ),
    ],
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

class _MemoryAppLocaleStore implements AppLocaleStore {
  Locale? locale;

  @override
  Future<Locale?> load() async {
    return locale;
  }

  @override
  Future<void> save(Locale locale) async {
    this.locale = locale;
  }
}
