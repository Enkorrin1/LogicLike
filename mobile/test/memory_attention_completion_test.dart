import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/beacon_signal_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/captain_command_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/color_rhythm_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/fast_eyes_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/hidden_star_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/memory_pairs_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/sound_order_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/story_order_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/tiny_detail_game.dart';

const _sentinel = 'memory-attention-sentinel';

Widget _harness(Widget child) => MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: child)),
      ),
    );

Future<void> _expectCompletedOnce(
  WidgetTester tester,
  List<String> answers, {
  Duration settle = const Duration(milliseconds: 1200),
}) async {
  await tester.pump(settle);
  await tester.pump();
  expect(answers, [_sentinel]);
  await tester.pump(const Duration(seconds: 2));
  expect(answers, [_sentinel]);
  expect(tester.takeException(), isNull);
}

Finder _gameGesture(Type gameType) => find.descendant(
      of: find.byType(gameType),
      matching: find.byType(GestureDetector),
    );

Future<void> _tapFraction(
  WidgetTester tester,
  Finder surface,
  double x,
  double y,
) async {
  final rect = tester.getRect(surface);
  await tester.tapAt(
    Offset(rect.left + rect.width * x, rect.top + rect.height * y),
  );
  await tester.pump();
}

Offset _boardPoint(Rect surface, Offset boardPoint, Size boardSize) {
  final scale = math.min(
    surface.width / boardSize.width,
    surface.height / boardSize.height,
  );
  final origin = Offset(
    surface.left + (surface.width - boardSize.width * scale) / 2,
    surface.top + (surface.height - boardSize.height * scale) / 2,
  );
  return origin + boardPoint * scale;
}

void main() {
  testWidgets('memory pairs clears three different boards and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        MemoryPairsGameView(
          accent: Colors.teal,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'memory pairs',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pump(const Duration(milliseconds: 420));

    final cards = find.descendant(
      of: find.byType(MemoryPairsGameView),
      matching: find.byType(InkWell),
    );
    const rounds = [
      [(0, 5), (1, 3), (2, 4)],
      [(0, 3), (1, 4), (2, 5)],
      [(0, 4), (1, 5), (2, 3)],
    ];
    for (var round = 0; round < rounds.length; round++) {
      for (final pair in rounds[round]) {
        await tester.tap(cards.at(pair.$1));
        await tester.pump(const Duration(milliseconds: 380));
        expect(answers, isEmpty);
        await tester.tap(cards.at(pair.$2));
        await tester.pump(const Duration(milliseconds: 380));
      }
      if (round < rounds.length - 1) {
        await tester.pump(const Duration(milliseconds: 1000));
        await tester.pump(const Duration(milliseconds: 1200));
        await tester.pump(const Duration(milliseconds: 420));
        expect(answers, isEmpty);
      }
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('sound order replays all three pads and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        SoundOrderGameView(
          accent: Colors.blue,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'sound order',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 3100));
    final surface = _gameGesture(SoundOrderGameView);
    for (final index in const [0, 2, 3]) {
      await _tapFraction(tester, surface, .125 + index * .25, .58);
      expect(answers, isEmpty);
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('story order needs two reorder drags and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        StoryOrderGameView(
          accent: Colors.green,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'story order',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    Finder draggables() => find.descendant(
          of: find.byType(StoryOrderGameView),
          matching: find.byType(Draggable<int>),
        );
    Finder targets() => find.descendant(
          of: find.byType(StoryOrderGameView),
          matching: find.byType(DragTarget<int>),
        );

    await tester.drag(
      draggables().at(1),
      tester.getCenter(targets().at(0)) - tester.getCenter(draggables().at(1)),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(answers, isEmpty);
    await tester.drag(
      draggables().at(2),
      tester.getCenter(targets().at(1)) - tester.getCenter(draggables().at(2)),
    );
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('captain command clears three demonstrated sequences once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        CaptainCommandGameView(
          accent: Colors.orange,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'captain command',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    final controls = find.descendant(
      of: find.byType(CaptainCommandGameView),
      matching: find.byType(GestureDetector),
    );
    for (final sequence in const [
      [0, 2, 1],
      [1, 0, 2, 1],
      [2, 1, 0, 2, 1],
    ]) {
      await tester.pump(const Duration(milliseconds: 4800));
      for (final index in sequence) {
        if (index == 1) {
          await tester.drag(controls.at(index), const Offset(42, 0));
        } else if (index == 2) {
          await tester.longPress(controls.at(index));
        } else {
          await tester.tap(controls.at(index));
        }
        await tester.pump(const Duration(milliseconds: 80));
      }
      await tester.pump(const Duration(milliseconds: 1200));
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('color rhythm repeats order and timing and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    var clock = 10000;
    await tester.pumpWidget(
      _harness(
        ColorRhythmGameView(
          accent: Colors.purple,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'color rhythm',
          onAnswerSelected: answers.add,
          nowMilliseconds: () => clock,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 3500));
    const sequence = [0, 2, 1, 3];
    const gaps = [420, 860, 560];
    for (var i = 0; i < sequence.length; i++) {
      if (i > 0) {
        clock += gaps[i - 1];
        await tester.pump(Duration(milliseconds: gaps[i - 1]));
      }
      await tester.tap(
        find.byKey(ValueKey('color-rhythm-pad-${sequence[i]}')),
        warnIfMissed: false,
      );
      await tester.pump();
      if (i < sequence.length - 1) expect(answers, isEmpty);
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('fast eyes catches both moving targets and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        FastEyesGameView(
          accent: Colors.red,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'fast eyes',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    final firstTarget = find.byKey(
      const ValueKey('fast-eyes-target-0-reaction'),
    );
    for (var frame = 0;
        frame < 160 && firstTarget.evaluate().isEmpty;
        frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(firstTarget, findsOneWidget);
    await tester.tapAt(tester.getCenter(firstTarget));
    expect(answers, isEmpty);
    final secondTarget = find.byKey(
      const ValueKey('fast-eyes-target-1-reaction'),
    );
    for (var frame = 0;
        frame < 220 && secondTarget.evaluate().isEmpty;
        frame++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(secondTarget, findsOneWidget);
    await tester.tapAt(tester.getCenter(secondTarget));
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('beacon hits all three moving timing windows and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        BeaconSignalGameView(
          accent: Colors.amber,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'beacon signal',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    for (var round = 0; round < 3; round++) {
      final window = find.byKey(ValueKey('beacon-hit-window-$round'));
      for (var frame = 0; frame < 240 && window.evaluate().isEmpty; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(window, findsOneWidget);
      await tester.tap(window);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 470));
      await tester.pump();
      if (round < 2) expect(answers, isEmpty);
    }
    await _expectCompletedOnce(tester, answers);
  });

  testWidgets('hidden star moves lens to all three stars and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        HiddenStarGameView(
          accent: Colors.yellow,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'hidden star',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    final surface = _gameGesture(HiddenStarGameView);
    final rect = tester.getRect(surface);
    var lens = _boardPoint(rect, const Offset(92, 126), const Size(360, 240));
    for (var index = 0; index < 3; index++) {
      final destination = tester.getCenter(
        find.byKey(ValueKey('hidden-star-target-$index')),
      );
      await tester.dragFrom(lens, destination - lens);
      await tester.pump();
      await tester.tapAt(destination);
      await tester.pump(const Duration(milliseconds: 760));
      if (index < 2) expect(answers, isEmpty);
      lens = destination;
    }
    await _expectCompletedOnce(tester, answers, settle: Duration.zero);
  });

  testWidgets('tiny detail finds all three ordered targets and answers once', (
    tester,
  ) async {
    final answers = <String>[];
    await tester.pumpWidget(
      _harness(
        TinyDetailGameView(
          accent: Colors.indigo,
          compact: false,
          correctAnswer: _sentinel,
          semanticLabel: 'tiny detail',
          onAnswerSelected: answers.add,
        ),
      ),
    );
    for (var round = 0; round < 3; round++) {
      final target = find.byKey(ValueKey('tiny-detail-target-$round'));
      expect(target, findsOneWidget);
      await tester.tap(target);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1050));
      await tester.pump();
      if (round < 2) expect(answers, isEmpty);
    }
    await _expectCompletedOnce(tester, answers, settle: Duration.zero);
  });
}
