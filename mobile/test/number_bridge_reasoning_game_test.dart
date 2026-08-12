import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_reasoning_games.dart';

void main() {
  const answer = 'bridge-complete';

  Widget harness({
    required ValueChanged<String> onAnswerSelected,
    bool compact = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 390,
            child: NumberBridgeReasoningGameView(
              accent: const Color(0xFF20B7A9),
              compact: compact,
              correctAnswer: answer,
              semanticLabel: 'Number bridge',
              onAnswerSelected: onAnswerSelected,
            ),
          ),
        ),
      ),
    );
  }

  Finder draggableWithValue(int value) => find.byWidgetPredicate(
        (widget) => widget is Draggable<int> && widget.data == value,
      );

  Finder targetAt(int index) => find.byType(DragTarget<int>).at(index);

  Future<void> dragValue(
    WidgetTester tester,
    int value,
    int target,
  ) async {
    final gesture =
        await tester.startGesture(tester.getCenter(draggableWithValue(value)));
    await tester.pump(const Duration(milliseconds: 650));
    await gesture.moveTo(tester.getCenter(targetAt(target)));
    await tester.pump(const Duration(milliseconds: 120));
    await gesture.up();
    await tester.pump();
  }

  Future<void> finishIntermediateRound(
    WidgetTester tester,
    List<int> values,
  ) async {
    for (var slot = 0; slot < values.length; slot++) {
      await dragValue(tester, values[slot], slot);
    }
    await tester.pumpAndSettle();
  }

  testWidgets(
    'collapses on an invalid beam and completes three bridge rules once',
    (tester) async {
      final answers = <String>[];
      await tester.pumpWidget(harness(onAnswerSelected: answers.add));

      await dragValue(tester, 5, 0);
      expect(answers, isEmpty);
      expect(draggableWithValue(5), findsNothing);

      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
      expect(draggableWithValue(5), findsOneWidget);
      expect(answers, isEmpty);

      await finishIntermediateRound(tester, const [3, 4, 5]);
      expect(answers, isEmpty);
      expect(draggableWithValue(6), findsOneWidget);

      await finishIntermediateRound(tester, const [6, 4, 2]);
      expect(answers, isEmpty);
      expect(draggableWithValue(16), findsOneWidget);

      for (final entry in const [(4, 0), (8, 1), (16, 2)]) {
        await dragValue(tester, entry.$1, entry.$2);
      }
      expect(answers, isEmpty);

      await tester.pumpAndSettle();
      expect(answers, [answer]);

      await tester.pump(const Duration(seconds: 2));
      expect(answers, [answer]);
    },
  );

  testWidgets('supports tap fallback and 44pt controls in compact mode',
      (tester) async {
    final handle = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(
      harness(onAnswerSelected: answers.add, compact: true),
    );

    final numberNode = tester.getSemantics(find.bySemanticsLabel('3'));
    expect(
      numberNode.getSemanticsData().hasAction(ui.SemanticsAction.tap),
      isTrue,
    );

    for (final finder in [draggableWithValue(3), targetAt(0)]) {
      final size = tester.getSize(finder);
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }

    await tester.tap(find.bySemanticsLabel('3'));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Number bridge 1'));
    await tester.pump();

    expect(draggableWithValue(3), findsNothing);
    expect(answers, isEmpty);
    handle.dispose();
  });
}
