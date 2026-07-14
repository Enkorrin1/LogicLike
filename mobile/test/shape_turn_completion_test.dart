import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/shape_turn_game.dart';

const _sentinel = 'shape-turn-exact-sentinel';

Widget _host(ValueChanged<String> onAnswerSelected) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 420,
            child: ShapeTurnGameView(
              accent: Colors.pink,
              compact: false,
              correctAnswer: _sentinel,
              semanticLabel: 'shape turn board',
              onAnswerSelected: onAnswerSelected,
            ),
          ),
        ),
      ),
    );

Future<void> _rotateToTarget(WidgetTester tester, int index) async {
  final piece = find.byKey(ValueKey('shape-turn-piece-$index'));
  for (var turn = 0; turn < 3; turn++) {
    await tester.tap(piece);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 240));
  }
}

Future<void> _dock(WidgetTester tester, int index) async {
  final piece = find.byKey(ValueKey('shape-turn-piece-$index'));
  final slot = find.byKey(ValueKey('shape-turn-slot-$index'));
  final gesture = await tester.startGesture(tester.getCenter(piece));
  await tester.pump(const Duration(milliseconds: 80));
  await gesture.moveBy(const Offset(24, 0));
  await tester.pump(const Duration(milliseconds: 40));
  await gesture.moveTo(tester.getCenter(slot));
  await tester.pump(const Duration(milliseconds: 80));
  await gesture.up();
  await tester.pump();
}

void main() {
  testWidgets('orients and docks all three shapes, then answers exactly once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_host(answers.add));

    for (var index = 0; index < 3; index++) {
      await _rotateToTarget(tester, index);
      expect(answers, isEmpty);

      await _dock(tester, index);
      expect(
        find.byKey(ValueKey('shape-turn-piece-$index')),
        findsNothing,
        reason: 'shape $index should be accepted by its slot',
      );
      if (index < 2) {
        expect(answers, isEmpty);
      }
    }

    await tester.pump(const Duration(milliseconds: 850));
    expect(answers, [_sentinel]);
    await tester.pump(const Duration(seconds: 2));
    expect(answers, [_sentinel]);
  });
}
