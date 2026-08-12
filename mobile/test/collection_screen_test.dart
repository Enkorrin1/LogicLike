import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/rewards/collection_screen.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';
import 'package:logicloka/src/l10n/l10n.dart';
import 'package:logicloka/src/theme/app_theme.dart';

void main() {
  testWidgets('keeps the collection usable in compact Arabic RTL',
      (tester) async {
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
        home: const CollectionScreen(
          stars: 125,
          completedLevels: 4,
          highlightDailyPrize: true,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
        find.text(
            tester.element(find.byType(CollectionScreen)).l10n.collectionTitle),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
