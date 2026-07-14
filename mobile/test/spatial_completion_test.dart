import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/arrow_maze_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/clean_row_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/final_orbit_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/mirror_path_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/shape_tangram_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/shape_tower_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/two_differences_game.dart';

const answer = 'spatial-sentinel';
const label = 'spatial-game';
Widget host(Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: SizedBox(width: 420, child: child))));
Finder get scene => find.bySemanticsLabel(label);
Finder get drags => find.byWidgetPredicate((w) => w is Draggable<Object?>);
Finder get drops => find.byWidgetPredicate((w) => w is DragTarget<Object?>);

Future<void> exactOnce(WidgetTester t, List<String> out,
    [Duration wait = const Duration(milliseconds: 1500)]) async {
  await t.pump();
  await t.pump(wait);
  await t.pump();
  expect(out, [answer]);
  await t.pump(const Duration(seconds: 2));
  expect(out, [answer]);
}

Offset board(WidgetTester t, Offset p, [Finder? finder]) {
  final r = t.getRect(finder ?? scene);
  final s = (r.width / 360).clamp(0.0, r.height / 240);
  return r.topLeft +
      Offset((r.width - 360 * s) / 2, (r.height - 240 * s) / 2) +
      p * s;
}

Future<void> dragAt(WidgetTester t, Offset from, Offset to) async {
  final g = await t.startGesture(from);
  await t.pump(const Duration(milliseconds: 80));
  await g.moveTo(to);
  await t.pump(const Duration(milliseconds: 40));
  await g.up();
  await t.pump();
}

void main() {
  testWidgets('arrow maze: rotate four tiles then launch, exact once',
      (t) async {
    final out = <String>[];
    await t.pumpWidget(host(ArrowMazeGameView(
        accent: Colors.teal,
        compact: false,
        correctAnswer: answer,
        semanticLabel: label,
        onAnswerSelected: out.add)));
    for (var i = 1; i <= 4; i++) {
      final tile = find.byKey(ValueKey('arrow-maze-tile-${i - 1}'));
      for (var n = 0; n < 2; n++) {
        await t.tap(tile);
        await t.pump();
        await t.pump(const Duration(milliseconds: 240));
      }
    }
    expect(out, isEmpty);
    await t.tap(find.byKey(const ValueKey('arrow-maze-launch')));
    await exactOnce(t, out, const Duration(seconds: 2));
  });

  testWidgets('mirror path: trace five nodes, exact once', (t) async {
    final out = <String>[];
    await t.pumpWidget(host(MirrorPathGameView(
        accent: Colors.cyan,
        compact: false,
        correctAnswer: answer,
        semanticLabel: label,
        onAnswerSelected: out.add)));
    final r = t.getRect(scene);
    Offset node(int i) =>
        r.topLeft +
        Offset(r.width * (.54 + .40 * (.17 + (i % 3) * .33)),
            r.height * (.13 + .72 * (.17 + (i ~/ 3) * .33)));
    final g = await t.startGesture(node(2));
    for (final i in [1, 4, 7, 6]) {
      await g.moveTo(node(i));
      await t.pump(const Duration(milliseconds: 40));
    }
    await g.up();
    await exactOnce(t, out);
  });

  testWidgets('tangram: rotate fin and place four pieces, exact once',
      (t) async {
    final out = <String>[];
    await t.pumpWidget(host(ShapeTangramGameView(
        accent: Colors.orange,
        compact: false,
        correctAnswer: answer,
        semanticLabel: label,
        onAnswerSelected: out.add)));
    const homes = [
      Offset(48, 196),
      Offset(137, 196),
      Offset(229, 196),
      Offset(316, 196)
    ];
    const targets = [
      Offset(180, 49),
      Offset(180, 105),
      Offset(142, 145),
      Offset(218, 145)
    ];
    for (var turn = 0; turn < 3; turn++) {
      await t.tapAt(board(t, homes[2]));
      await t.pump();
    }
    for (var i = 0; i < 4; i++) {
      await dragAt(t, board(t, homes[i]), board(t, targets[i]));
    }
    await exactOnce(t, out);
  });

  testWidgets('shape tower: place all pieces in order, exact once', (t) async {
    final out = <String>[];
    await t.pumpWidget(host(ShapeTowerGameView(
        accent: Colors.purple,
        compact: false,
        correctAnswer: answer,
        semanticLabel: label,
        onAnswerSelected: out.add)));
    for (var i = 0; i < 4; i++) {
      await t.tap(drags.first);
      await t.pump();
    }
    await exactOnce(t, out);
  });

  testWidgets('final orbit: align three tiles and launch, exact once',
      (t) async {
    final out = <String>[];
    await t.pumpWidget(host(FinalOrbitGameView(
        accent: Colors.deepPurple,
        compact: false,
        correctAnswer: answer,
        semanticLabel: label,
        onAnswerSelected: out.add)));
    for (var i = 0; i < 3; i++) {
      await t.tapAt(t.getCenter(find.byKey(ValueKey('final-orbit-tile-$i'))));
      await t.pump();
      await t.pump(const Duration(milliseconds: 280));
    }
    expect(out, isEmpty);
    await t
        .tapAt(t.getCenter(find.byKey(const ValueKey('final-orbit-launch'))));
    await t.pump();
    await t.pump(const Duration(milliseconds: 1351));
    await t.pump();
    await t.pump(const Duration(milliseconds: 541));
    await exactOnce(t, out, Duration.zero);
  });

  testWidgets('clean row: scrub all three targets, exact once', (t) async {
    final out = <String>[];
    await t.pumpWidget(host(CleanRowGameView(
        accent: Colors.blue,
        compact: false,
        correctAnswer: answer,
        semanticLabel: label,
        onAnswerSelected: out.add)));
    for (final c in [
      const Offset(87, 91),
      const Offset(184, 138),
      const Offset(278, 82)
    ]) {
      final a = board(t, c - const Offset(18, 0)),
          b = board(t, c + const Offset(18, 0));
      final g = await t.startGesture(a);
      for (var i = 0; i < 22; i++) {
        await g.moveTo(i.isEven ? b : a);
        await t.pump(const Duration(milliseconds: 8));
      }
      await g.up();
      await t.pump(const Duration(milliseconds: 450));
    }
    await exactOnce(t, out);
  });

  testWidgets('two differences: find four details, exact once', (t) async {
    final out = <String>[];
    await t.pumpWidget(host(TwoDifferencesGameView(
        accent: Colors.red,
        compact: false,
        correctAnswer: answer,
        semanticLabel: label,
        onAnswerSelected: out.add)));
    final r = t.getRect(scene),
        side = (r.width * .025).clamp(9.0, double.infinity),
        gap = (r.width * .018).clamp(7.0, double.infinity);
    final w = (r.width - side * 2 - gap) / 2,
        top = r.height * .095,
        h = r.height * .82;
    for (final p in [
      const Offset(.205, .315),
      const Offset(.765, .675),
      const Offset(.5, .455),
      const Offset(.325, .79)
    ]) {
      await t.tapAt(r.topLeft + Offset(side + w * p.dx, top + h * p.dy));
      await t.pump();
    }
    await exactOnce(t, out);
  });
}
