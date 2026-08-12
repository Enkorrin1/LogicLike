import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/logic_mechanics_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/shadow_match_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/what_changed_game.dart';

const _answer = 'deepened-game-complete';

Widget _harness(Widget game) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 420, child: game),
        ),
      ),
    );

Offset _scenePoint(Finder board, WidgetTester tester, Offset logical) {
  final rect = tester.getRect(board);
  final scale = math.min(rect.width / 360, rect.height / 240);
  final origin = rect.topLeft +
      Offset(
        (rect.width - 360 * scale) / 2,
        (rect.height - 240 * scale) / 2,
      );
  return origin + logical * scale;
}

Future<void> _dragScene(
  WidgetTester tester,
  Finder board,
  Offset from,
  Offset to,
) async {
  final start = _scenePoint(board, tester, from);
  final end = _scenePoint(board, tester, to);
  final gesture = await tester.startGesture(start);
  await tester.pump(const Duration(milliseconds: 40));
  await gesture.moveTo(Offset.lerp(start, end, .18)!);
  await tester.pump(const Duration(milliseconds: 40));
  await gesture.moveTo(end);
  await tester.pump(const Duration(milliseconds: 80));
  await gesture.up();
  await tester.pump();
}

Future<void> _setClockMinute(
  WidgetTester tester,
  Finder face,
  int minute,
) async {
  final rect = tester.getRect(face);
  final center = rect.center;
  final angle = minute / 60 * math.pi * 2 - math.pi / 2;
  final target = center +
      Offset(math.cos(angle), math.sin(angle)) * rect.shortestSide * .38;
  final gesture = await tester.startGesture(center);
  await gesture.moveTo(target, timeStamp: const Duration(milliseconds: 180));
  await gesture.up();
  await tester.pump();
}

Future<void> _swipeTubes(WidgetTester tester, Finder board) async {
  final start = _scenePoint(board, tester, const Offset(280, 145));
  final gesture = await tester.startGesture(start);
  await tester.pump(const Duration(milliseconds: 20));
  await gesture.moveTo(start + const Offset(-20, 0));
  await tester.pump(const Duration(milliseconds: 10));
  await gesture.moveTo(start + const Offset(-130, 0));
  await tester.pump(const Duration(milliseconds: 10));
  await gesture.up();
  await tester.pump();
}

void main() {
  testWidgets(
      'shadow match rejects a wrong shadow and completes all three rounds once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(ShadowMatchGameView(
      accent: Colors.teal,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'shadow match',
      onAnswerSelected: answers.add,
    )));
    final board = find.byKey(const ValueKey('shadow-match-board'));

    await _dragScene(
        tester, board, const Offset(180, 205), const Offset(70, 111));
    await tester.pump(const Duration(milliseconds: 560));
    expect(answers, isEmpty);

    for (final target in const [
      Offset(180, 101),
      Offset(70, 111),
      Offset(290, 111),
    ]) {
      await _dragScene(tester, board, const Offset(180, 205), target);
      await tester.pump(const Duration(milliseconds: 560));
    }
    expect(answers, [_answer]);

    await _dragScene(
        tester, board, const Offset(180, 205), const Offset(290, 111));
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
  });

  testWidgets(
      'what changed recovers from an error and completes three different tasks once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(WhatChangedGameView(
      accent: Colors.cyan,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'what changed',
      onAnswerSelected: answers.add,
    )));
    final board = find.byKey(const ValueKey('what-changed-board'));
    await tester.pump(const Duration(milliseconds: 950));

    await _dragScene(
        tester, board, const Offset(280, 103), const Offset(170, 70));
    await tester.pump(const Duration(milliseconds: 560));
    expect(answers, isEmpty);

    await _dragScene(
        tester, board, const Offset(280, 103), const Offset(83, 167));
    await tester.pump(const Duration(milliseconds: 560));
    await tester.pump(const Duration(milliseconds: 950));
    expect(answers, isEmpty);
    expect(find.byKey(const ValueKey('what-changed-round-1-taps-0')),
        findsOneWidget);

    for (var tap = 0; tap < 3; tap++) {
      await tester.tapAt(_scenePoint(board, tester, const Offset(155, 132)));
      await tester.pump();
      expect(
        find.byKey(ValueKey('what-changed-round-1-taps-${tap + 1}')),
        findsOneWidget,
      );
    }
    await tester.pump(const Duration(milliseconds: 560));
    await tester.pump(const Duration(milliseconds: 950));
    expect(answers, isEmpty);
    expect(find.byKey(const ValueKey('what-changed-round-2-taps-3')),
        findsOneWidget);

    await _swipeTubes(tester, board);
    await tester.pump(const Duration(milliseconds: 560));
    expect(answers, [_answer]);

    await _swipeTubes(tester, board);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
  });

  testWidgets(
      'moon clock rejects a wrong time and launches after three target times once',
      (tester) async {
    final answers = <String>[];
    await tester.pumpWidget(_harness(MoonClockGameView(
      accent: Colors.indigo,
      compact: false,
      correctAnswer: _answer,
      semanticLabel: 'moon clock',
      onAnswerSelected: answers.add,
    )));
    final face = find.byKey(const ValueKey('moon-clock-face'));

    await _setClockMinute(tester, face, 30);
    await tester.pump(const Duration(milliseconds: 400));
    expect(answers, isEmpty);
    expect(find.text('3:00'), findsOneWidget);

    for (final target in const [0, 15, 45]) {
      await _setClockMinute(tester, face, target);
      await tester.pump(const Duration(milliseconds: 600));
    }
    expect(answers, [_answer]);

    await _setClockMinute(tester, face, 45);
    await tester.pump(const Duration(seconds: 1));
    expect(answers, [_answer]);
  });
}
