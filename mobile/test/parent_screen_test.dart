import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/features/parent/parent_screen.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';
import 'package:logicloka/src/l10n/localized_content.dart';
import 'package:logicloka/src/theme/app_theme.dart';

void main() {
  testWidgets('shows parent dashboard sections and reset confirmation',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final now = DateTime.now();
    var resetCalled = false;
    final l10n = lookupAppLocalizations(const Locale('ru'));
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
          onResetProfile: () async {
            resetCalled = true;
          },
          onLanguageChanged: (_) async {},
          onReminderPreferenceChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.parentOverviewTitle), findsOneWidget);
    expect(find.text(l10n.parentProgressTitle), findsOneWidget);
    expect(find.text(l10n.parentTodayValue(1, 3)), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(l10n.parentTodayPlanTitle),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.parentTodayPlanTitle), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(l10n.parentAreasTitle),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.parentAreasTitle), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(l10n.parentRecommendationsTitle),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.parentRecommendationsTitle), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(l10n.parentResetProfile),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text(l10n.parentResetProfile));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.parentResetProfile));
    await tester.pumpAndSettle();

    expect(find.text(l10n.parentResetTitle), findsOneWidget);
    await tester.tap(find.text(l10n.commonCancel));
    await tester.pumpAndSettle();
    expect(resetCalled, isFalse);
  });

  testWidgets('shows subscription tariff ladder and billing placeholder',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = lookupAppLocalizations(const Locale('ru'));
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
          onResetProfile: () async {},
          onLanguageChanged: (_) async {},
          onReminderPreferenceChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(l10n.parentSubscriptionPremiumTitle),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text(l10n.parentSubscriptionFreeTitle), findsWidgets);
    expect(find.text(l10n.parentSubscriptionPremiumTitle), findsOneWidget);
    expect(find.text(l10n.parentSubscriptionPremiumPrice), findsOneWidget);
    expect(find.text(l10n.parentSubscriptionAnnualTitle), findsOneWidget);
    expect(find.text(l10n.parentSubscriptionAnnualPrice), findsOneWidget);
    expect(find.text(l10n.parentSubscriptionFuturePriceNote), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(l10n.parentSubscriptionPremiumCta),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text(l10n.parentSubscriptionPremiumCta));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.parentSubscriptionPremiumCta));
    await tester.pumpAndSettle();

    expect(find.text(l10n.parentSubscriptionBillingSoonSnack), findsOneWidget);
  });

  testWidgets('changes selected language from parent settings', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AppLanguage? selectedLanguage;
    final l10n = lookupAppLocalizations(const Locale('ru'));
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
          onResetProfile: () async {},
          onLanguageChanged: (language) async {
            selectedLanguage = language;
          },
          onReminderPreferenceChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(l10n.languageName(AppLanguage.en)),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text(l10n.languageName(AppLanguage.en)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.languageName(AppLanguage.en)));
    await tester.pumpAndSettle();

    expect(selectedLanguage, AppLanguage.en);
  });

  testWidgets('toggles reminder preference from parent settings',
      (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool? selectedReminderPreference;
    final l10n = lookupAppLocalizations(const Locale('ru'));
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
          onResetProfile: () async {},
          onLanguageChanged: (_) async {},
          onReminderPreferenceChanged: (enabled) async {
            selectedReminderPreference = enabled;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(l10n.parentRemindersTitle),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(l10n.parentReminderToggleLabel));
    await tester.pumpAndSettle();

    expect(selectedReminderPreference, isFalse);
  });

  testWidgets('opens account sign in from parent settings', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = lookupAppLocalizations(const Locale('ru'));
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
          onResetProfile: () async {},
          onLanguageChanged: (_) async {},
          onReminderPreferenceChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(l10n.parentAccountAction),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(l10n.parentAccountAction));
    await tester.pumpAndSettle();

    expect(find.text(l10n.accountTitle), findsOneWidget);
    expect(find.text(l10n.accountProviderGoogle), findsOneWidget);
    expect(find.text(l10n.accountProviderApple), findsOneWidget);
    expect(find.text(l10n.accountSubmitSignIn), findsOneWidget);
  });

  testWidgets('signs in locally with email and password', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = lookupAppLocalizations(const Locale('ru'));
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
          onResetProfile: () async {},
          onLanguageChanged: (_) async {},
          onReminderPreferenceChanged: (_) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(l10n.parentAccountAction),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(l10n.parentAccountAction));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, l10n.accountEmailLabel),
      'parent@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, l10n.accountPasswordLabel),
      'secret123',
    );
    await tester.tap(find.text(l10n.accountSubmitSignIn));
    await tester.pumpAndSettle();

    expect(find.text(l10n.accountSignedInTitle), findsOneWidget);
    expect(find.textContaining('parent@example.com'), findsWidgets);
  });
}
