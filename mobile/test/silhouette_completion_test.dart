import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/silhouette_build_game.dart';

const _answer = 'silhouette-sentinel';

Widget _host(ValueChanged<String> onAnswerSelected) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 420,
          child: SilhouetteBuildGameView(
            accent: Colors.teal,
            compact: false,
            correctAnswer: _answer,
            semanticLabel: 'silhouette-game',
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      ),
    ),
  );
}

Future<void> _dragPiece(WidgetTester tester, int index) async {
  final piece = find.byKey(ValueKey('silhouette-piece-$index'));
  final target = find.byKey(ValueKey('silhouette-target-$index'));
  final from = tester.getCenter(piece);
  final to = tester.getCenter(target);
  expect(piece.hitTestable(), findsOneWidget);
  await tester.drag(
    piece,
    to - from,
    touchSlopX: 0,
    touchSlopY: 0,
  );
  await tester.pump();
  expect(
    find.byKey(ValueKey('silhouette-piece-$index')),
    findsNothing,
    reason: 'Piece $index must be accepted by its target',
  );
}

void main() {
  testWidgets(
      'rotates tail and drags all four pieces through production pipeline',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_host(answers.add));

    expect(answers, isEmpty);
    await tester.tap(
      find.byKey(const ValueKey('silhouette-piece-3')),
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey('silhouette-tail-ready')),
      findsOneWidget,
    );
    expect(answers, isEmpty);

    for (var index = 0; index < 4; index++) {
      await _dragPiece(tester, index);
      expect(answers, isEmpty);
    }

    await tester.pump(const Duration(milliseconds: 1201));
    expect(answers, [_answer]);
    await tester.pump(const Duration(seconds: 2));
    expect(answers, [_answer]);
  });
}
