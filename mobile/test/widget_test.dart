import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/app/logic_like_app.dart';
import 'package:logic_like/src/data/family_profile_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows onboarding when family profile is empty', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      LogicLikeApp(
        familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Пропуск в BrainUp'), findsOneWidget);
    expect(find.text('Выбери возрастной маршрут'), findsOneWidget);
  });
}
