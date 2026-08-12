import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/onboarding/onboarding_screen.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';
import 'package:logicloka/src/l10n/l10n.dart';
import 'package:logicloka/src/theme/app_theme.dart';

void main() {
  testWidgets('keeps onboarding stable in compact Arabic RTL', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
        home: OnboardingScreen(
          onComplete: ({required childName, required childAge}) async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(OnboardingScreen));
    expect(find.text(context.l10n.onboardingTitle), findsOneWidget);
    expect(find.text(context.l10n.onboardingAgeTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
