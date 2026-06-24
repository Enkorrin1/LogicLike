import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicx/src/app/logicx_app.dart';
import 'package:logicx/src/data/family_profile_store.dart';
import 'package:logicx/src/domain/daily_challenge.dart';
import 'package:logicx/src/domain/family_profile.dart';
import 'package:logicx/src/features/challenge/challenge_screen.dart';
import 'package:logicx/src/l10n/generated/app_localizations.dart';
import 'package:logicx/src/l10n/localized_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows onboarding when family profile is empty', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final l10n = lookupAppLocalizations(const Locale('ru'));

    await tester.pumpWidget(
      LogicXApp(
        familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingTitle), findsOneWidget);
    expect(find.text(l10n.onboardingAgeTitle), findsOneWidget);
  });

  testWidgets('renders free play puzzle content in the selected locale',
      (tester) async {
    final profile = FamilyProfile(
      childName: 'Leo',
      childAge: ChildAge.six,
      createdAt: DateTime(2026),
      language: AppLanguage.it,
    );
    final l10n = lookupAppLocalizations(const Locale('it'));
    final logicArea = puzzleAreasForAge(ChildAge.six)
        .firstWhere((area) => area.id == 'logic');
    final puzzle = logicArea.puzzles.first;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('it'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChallengeScreen(
          profile: profile,
          initialAreaId: 'logic',
          onInitialAreaHandled: () {},
          onChallengeComplete: (_) async {},
          onPracticeComplete: (_) async {},
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text(l10n.puzzleTitle(puzzle)).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(l10n.challengeFreePlay), findsOneWidget);
    expect(
      find.text(l10n.challengeProgressStep(1, logicArea.puzzles.length)),
      findsOneWidget,
    );
    expect(find.text(l10n.puzzleTitle(puzzle)), findsOneWidget);
    expect(find.text(l10n.puzzleSkill(puzzle)), findsOneWidget);
    expect(find.text(l10n.puzzlePrompt(puzzle)), findsOneWidget);
    expect(find.text(l10n.challengeShowHint), findsOneWidget);

    expect(find.text('Free play'), findsNothing);
    expect(find.text('Step 8 of 1'), findsNothing);
    expect(find.text('Logic train'), findsNothing);
    expect(find.text('Sequences'), findsNothing);
    expect(find.text('Place the cars so the rule stays true.'), findsNothing);
  });
}
