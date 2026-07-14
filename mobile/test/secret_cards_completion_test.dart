import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/secret_cards_game.dart';

const _sentinel = 'secret-cards-sentinel';

Finder _card(int index) => find.byKey(ValueKey('secret-card-$index'));

void main() {
  testWidgets(
    'rejects a mismatch and completes only after all three memory pairs',
    (tester) async {
      final answers = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 420,
                child: SecretCardsGameView(
                  accent: Colors.teal,
                  compact: false,
                  correctAnswer: _sentinel,
                  previewDuration: const Duration(milliseconds: 40),
                  onAnswerSelected: answers.add,
                ),
              ),
            ),
          ),
        ),
      );

      for (var index = 0; index < 6; index++) {
        expect(_card(index), findsOneWidget);
      }
      await tester.pump(const Duration(milliseconds: 60));

      // Rocket + planet is an intentional mismatch.
      await tester.tap(_card(0));
      await tester.tap(_card(1));
      await tester.pump();
      expect(answers, isEmpty);

      // Input is locked while the mismatched cards remain visible.
      await tester.tap(_card(5));
      await tester.pump(const Duration(milliseconds: 700));
      expect(answers, isEmpty);

      for (final pair in const [(0, 5), (1, 3), (2, 4)]) {
        await tester.tap(_card(pair.$1));
        await tester.tap(_card(pair.$2));
        await tester.pump();
        if (pair != const (2, 4)) expect(answers, isEmpty);
      }

      expect(answers, [_sentinel]);

      // Matched cards and post-win taps cannot complete the level again.
      await tester.tap(_card(0));
      await tester.tap(_card(1));
      await tester.pump(const Duration(seconds: 1));
      expect(answers, [_sentinel]);
    },
  );
}
