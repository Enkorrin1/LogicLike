import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/features/parent/parent_screen.dart';
import 'package:logic_like/src/l10n/l10n.dart';
import 'package:logic_like/src/theme/app_theme.dart';

void main() {
  testWidgets('shows parent dashboard sections and reset confirmation',
      (tester) async {
    final now = DateTime.now();
    var resetCalled = false;
    final profile = FamilyProfile(
      childName: 'Lev',
      childAge: ChildAge.five,
      createdAt: now.subtract(const Duration(days: 12)),
      completedChallenges: 4,
      completedLevels: 3,
      dailyProgressDate: now,
      dailyCompletedPuzzleIds: const ['logic-train'],
      completedPracticePuzzleIds: const ['memory-pairs', 'odd-card'],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: ParentScreen(
          profile: profile,
          selectedLocale: const Locale('ru'),
          onLocaleChanged: (_) {},
          onResetProfile: () async {
            resetCalled = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Родительский обзор'), findsOneWidget);
    expect(find.text('Прогресс ребенка'), findsOneWidget);
    expect(find.text('1 из 3'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('План на сегодня'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('План на сегодня'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Зоны развития'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Зоны развития'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Рекомендации'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Рекомендации'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Сбросить профиль'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Сбросить профиль'));
    await tester.pumpAndSettle();

    expect(find.text('Сбросить профиль?'), findsOneWidget);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(resetCalled, isFalse);
  });

  testWidgets('changes selected language from parent settings', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Locale? selectedLocale;
    final profile = FamilyProfile(
      childName: 'Lev',
      childAge: ChildAge.five,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: ParentScreen(
          profile: profile,
          selectedLocale: const Locale('ru'),
          onLocaleChanged: (locale) {
            selectedLocale = locale;
          },
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final dropdown = find.byType(DropdownButtonFormField<Locale>);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(selectedLocale, const Locale('en'));
  });
}
