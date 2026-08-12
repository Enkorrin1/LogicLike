import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_games.dart';

void main() {
  testWidgets(
    'bridge workshop rejects weak sections and completes three builds once',
    (tester) async {
      final answers = <String>[];
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 390,
                child: BridgeOrderGameView(
                  accent: const Color(0xFF22AFA2),
                  compact: false,
                  correctAnswer: 'bridge',
                  semanticLabel: 'bridge puzzle',
                  onAnswerSelected: answers.add,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('bridge-stage-0')), findsOneWidget);
      final firstPiece = tester.getSize(
        find.byKey(const ValueKey('bridge-piece-0-0')),
      );
      final firstSlot = tester.getSize(
        find.byKey(const ValueKey('bridge-slot-0-0')),
      );
      expect(firstPiece.width, greaterThanOrEqualTo(44));
      expect(firstPiece.height, greaterThanOrEqualTo(44));
      expect(firstSlot.width, greaterThanOrEqualTo(44));
      expect(firstSlot.height, greaterThanOrEqualTo(44));

      await _tapPlace(tester, stage: 0, piece: 3, slot: 0);
      await _tapPlace(tester, stage: 0, piece: 1, slot: 1);
      await _tapPlace(tester, stage: 0, piece: 2, slot: 2);
      await _tapPlace(tester, stage: 0, piece: 0, slot: 3);
      expect(find.byKey(const ValueKey('bridge-slot-error-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('bridge-slot-error-3')), findsOneWidget);
      expect(answers, isEmpty);

      await tester.pump(const Duration(milliseconds: 750));
      await _dragPiece(tester, stage: 0, piece: 0, slot: 0);
      await _dragPiece(tester, stage: 0, piece: 3, slot: 3);
      await tester.pump(const Duration(milliseconds: 1100));
      expect(find.byKey(const ValueKey('bridge-stage-1')), findsOneWidget);
      expect(answers, isEmpty);

      await _dragPiece(tester, stage: 1, piece: 2, slot: 0);
      await _dragPiece(tester, stage: 1, piece: 0, slot: 1);
      await _dragPiece(tester, stage: 1, piece: 1, slot: 2);
      await _dragInstalledPiece(tester, stage: 1, piece: 1, slot: 3);
      await _dragPiece(tester, stage: 1, piece: 3, slot: 2);
      await tester.pump(const Duration(milliseconds: 1100));
      expect(find.byKey(const ValueKey('bridge-stage-2')), findsOneWidget);
      expect(answers, isEmpty);

      await _tapPlace(tester, stage: 2, piece: 1, slot: 0);
      await _tapPlace(tester, stage: 2, piece: 3, slot: 1);
      await _tapPlace(tester, stage: 2, piece: 2, slot: 2);
      await _tapPlace(tester, stage: 2, piece: 0, slot: 3);
      await tester.pump(const Duration(milliseconds: 1100));
      expect(answers, isEmpty);
      await tester.pump(const Duration(milliseconds: 450));

      expect(answers, ['bridge']);
      await tester.pump(const Duration(seconds: 2));
      expect(answers, ['bridge']);

      semantics.dispose();
    },
  );
}

Future<void> _tapPlace(
  WidgetTester tester, {
  required int stage,
  required int piece,
  required int slot,
}) async {
  await tester.tap(find.byKey(ValueKey('bridge-piece-$stage-$piece')));
  await tester.pump();
  await tester.tap(find.byKey(ValueKey('bridge-slot-$stage-$slot')));
  await tester.pump();
}

Future<void> _dragPiece(
  WidgetTester tester, {
  required int stage,
  required int piece,
  required int slot,
}) =>
    _longPressDrag(
      tester,
      find.byKey(ValueKey('bridge-piece-$stage-$piece')),
      find.byKey(ValueKey('bridge-slot-$stage-$slot')),
    );

Future<void> _dragInstalledPiece(
  WidgetTester tester, {
  required int stage,
  required int piece,
  required int slot,
}) =>
    _longPressDrag(
      tester,
      find.byKey(ValueKey('bridge-installed-$stage-$piece')),
      find.byKey(ValueKey('bridge-slot-$stage-$slot')),
    );

Future<void> _longPressDrag(
  WidgetTester tester,
  Finder source,
  Finder target,
) async {
  final gesture = await tester.startGesture(tester.getCenter(source));
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump(const Duration(milliseconds: 100));
  await gesture.up();
  await tester.pump();
}
