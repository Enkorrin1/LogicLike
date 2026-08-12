import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_reasoning_games.dart';

void main() {
  const answer = 'balanced';

  Widget harness(
    ValueChanged<String> onAnswerSelected, {
    bool compact = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 390,
            child: StarBalanceReasoningGameView(
              accent: const Color(0xFF20B7A9),
              compact: compact,
              correctAnswer: answer,
              semanticLabel: 'Balance',
              onAnswerSelected: onAnswerSelected,
            ),
          ),
        ),
      ),
    );
  }

  Finder star(int round, int id) =>
      find.byKey(ValueKey('star-balance-star-$round-$id'));

  Finder target(String side) => find.byKey(ValueKey('star-balance-$side'));

  Future<void> dragStar(
    WidgetTester tester,
    int round,
    int id,
    String side,
  ) async {
    final gesture =
        await tester.startGesture(tester.getCenter(star(round, id)));
    await tester.pump(const Duration(milliseconds: 80));
    final targetRect = tester.getRect(target(side));
    final dropPoint = switch (side) {
      'left' || 'right' => targetRect.topRight + const Offset(-8, 8),
      _ => targetRect.bottomLeft + const Offset(8, -8),
    };
    await gesture.moveTo(dropPoint);
    await tester.pump(const Duration(milliseconds: 80));
    await gesture.up();
    await tester.pump();
  }

  Future<void> solveRound(
    WidgetTester tester,
    int round, {
    required List<int> left,
    required List<int> right,
  }) async {
    for (final id in right) {
      await dragStar(tester, round, id, 'right');
    }
    for (final id in left) {
      await dragStar(tester, round, id, 'left');
    }
    final expectedTotal = const [6, 8, 12][round];
    final stateKeys = tester
        .widgetList<Stack>(find.byType(Stack))
        .map((widget) => widget.key)
        .whereType<ValueKey<String>>()
        .where((key) => key.value.startsWith('star-balance-state-'))
        .toList();
    expect(
      stateKeys,
      contains(
        ValueKey('star-balance-state-$round-'
            '$expectedTotal-$expectedTotal-6'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 850));
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'rejects an uneven layout and completes three balance rounds once',
    (tester) async {
      final answers = <String>[];
      await tester.pumpWidget(harness(answers.add));

      final initialStarPosition = tester.getTopLeft(star(0, 3));
      await dragStar(tester, 0, 3, 'right');
      expect(tester.getTopLeft(star(0, 3)), isNot(initialStarPosition));
      for (final id in const [4, 5]) {
        await dragStar(tester, 0, id, 'right');
      }
      for (final id in const [0, 1, 2]) {
        await dragStar(tester, 0, id, 'left');
      }
      await tester.pumpAndSettle();

      expect(answers, isEmpty);
      expect(star(0, 0), findsOneWidget);

      for (var id = 0; id < 6; id++) {
        await dragStar(tester, 0, id, 'tray');
      }
      expect(
        find.byKey(const ValueKey('star-balance-state-0-0-0-0')),
        findsOneWidget,
      );
      await solveRound(
        tester,
        0,
        left: const [0, 2, 4],
        right: const [1, 3, 5],
      );

      expect(answers, isEmpty);
      expect(star(1, 0), findsOneWidget);

      await solveRound(
        tester,
        1,
        left: const [0, 3, 4],
        right: const [1, 2, 5],
      );
      expect(answers, isEmpty);
      expect(star(2, 0), findsOneWidget);

      await solveRound(
        tester,
        2,
        left: const [0, 1, 5],
        right: const [2, 3, 4],
      );

      expect(answers, [answer]);
      await tester.pump(const Duration(seconds: 2));
      expect(answers, [answer]);
    },
  );

  testWidgets('offers semantic tap fallback and 44pt targets in compact mode',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final answers = <String>[];
    await tester.pumpWidget(harness(answers.add, compact: true));

    final starSize = tester.getSize(star(0, 0));
    expect(starSize.width, greaterThanOrEqualTo(44));
    expect(starSize.height, greaterThanOrEqualTo(44));
    for (final side in const ['left', 'right', 'tray']) {
      final targetSize = tester.getSize(target(side));
      expect(targetSize.width, greaterThanOrEqualTo(44));
      expect(targetSize.height, greaterThanOrEqualTo(44));
    }

    final starSemantics = tester.getSemantics(star(0, 0));
    expect(
      starSemantics.getSemanticsData().hasAction(ui.SemanticsAction.tap),
      isTrue,
    );

    await tester.tap(star(0, 0));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('star-balance-state-0-1-0-1')),
      findsOneWidget,
    );
    await tester.tap(star(0, 0));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('star-balance-state-0-0-1-1')),
      findsOneWidget,
    );
    await tester.tap(star(0, 0));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('star-balance-state-0-0-0-0')),
      findsOneWidget,
    );
    expect(answers, isEmpty);
    semantics.dispose();
  });
}
