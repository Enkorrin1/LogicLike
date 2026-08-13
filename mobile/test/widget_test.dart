import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/app/logic_loka_app.dart';
import 'package:logicloka/src/data/family_profile_store.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/features/challenge/challenge_screen.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';
import 'package:logicloka/src/l10n/localized_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders the branded loading scene without a generic card',
      (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final store = _PendingFamilyProfileStore();
    final l10n = lookupAppLocalizations(const Locale('ru'));
    await tester.pumpWidget(
      LogicLokaApp(
        familyProfileStore: store,
        locale: const Locale('ru'),
      ),
    );
    await tester.runAsync(
      () => precacheImage(
        const AssetImage('assets/images/avatar_lion.png'),
        tester.element(find.byType(LogicLokaApp)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Logic Loka'), findsOneWidget);
    expect(find.text(l10n.loadingMission), findsOneWidget);
    expect(find.byType(Card), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/avatar_lion.png',
      ),
      findsOneWidget,
    );
    await expectLater(
      find.byType(LogicLokaApp),
      matchesGoldenFile('goldens/loading_screen_ru.png'),
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('shows onboarding when family profile is empty', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final l10n = lookupAppLocalizations(const Locale('ru'));

    await tester.pumpWidget(
      LogicLokaApp(
        familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingTitle), findsOneWidget);
    expect(find.text(l10n.onboardingAgeTitle), findsOneWidget);
  });

  testWidgets('renders free play puzzle content in the selected locale',
      (tester) async {
    final semantics = tester.ensureSemantics();
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
    expect(find.bySemanticsLabel(l10n.puzzleListenPrompt), findsOneWidget);
    expect(find.bySemanticsLabel(l10n.puzzleStopNarration), findsNothing);

    expect(find.text('Free play'), findsNothing);
    expect(find.text('Step 8 of 1'), findsNothing);
    expect(find.text('Logic train'), findsNothing);
    expect(find.text('Sequences'), findsNothing);
    expect(find.text('Place the cars so the rule stays true.'), findsNothing);
    semantics.dispose();
  });
}

class _PendingFamilyProfileStore implements FamilyProfileStore {
  final Completer<FamilyProfile?> _load = Completer<FamilyProfile?>();

  @override
  Future<void> clear() async {}

  @override
  Future<FamilyProfile?> load() => _load.future;

  @override
  Future<void> save(FamilyProfile profile) async {}
}
