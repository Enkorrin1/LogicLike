import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/rocket_route_game.dart';

const _sentinel = 'rocket-route-sentinel';

Future<void> _dragCommand(
  WidgetTester tester, {
  required int command,
  required int slot,
}) async {
  final source = find.byKey(ValueKey('rocket-route-command-$command'));
  final target = find.byKey(ValueKey('rocket-route-slot-$slot'));

  expect(source, findsOneWidget);
  expect(target, findsOneWidget);

  final delta = tester.getCenter(target) - tester.getCenter(source);
  await tester.drag(source, delta, touchSlopY: 1, warnIfMissed: true);
  await tester.pump();
}

void main() {
  testWidgets(
    'builds F,F,R,F,F,F and completes after six steps and reaction',
    (tester) async {
      final answers = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 420,
                child: RocketRouteGameView(
                  accent: Colors.teal,
                  compact: false,
                  correctAnswer: _sentinel,
                  semanticLabel: 'Rocket route',
                  onAnswerSelected: answers.add,
                ),
              ),
            ),
          ),
        ),
      );

      // Palette indexes: forward = 0, left = 1, right = 2.
      for (final entry in <int>[0, 0, 2, 0, 0, 0].indexed) {
        await _dragCommand(
          tester,
          command: entry.$2,
          slot: entry.$1,
        );
        final commandLabel =
            entry.$2 == 2 ? 'Turn right command' : 'Forward command';
        expect(
          find.bySemanticsLabel('$commandLabel ${entry.$1 + 1}'),
          findsOneWidget,
        );
      }
      expect(answers, isEmpty);

      await tester.tap(
        find.byKey(const ValueKey('rocket-route-launch')),
      );
      await tester.pump();

      for (var step = 0; step < 6; step++) {
        await tester.pump(const Duration(milliseconds: 361));
        await tester.pump();
        expect(answers, isEmpty);
      }

      await tester.pump(const Duration(milliseconds: 621));
      await tester.pump();
      expect(answers, [_sentinel]);

      await tester.pump(const Duration(seconds: 2));
      await tester.tap(
        find.byKey(const ValueKey('rocket-route-launch')),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(answers, [_sentinel]);
    },
  );
}
