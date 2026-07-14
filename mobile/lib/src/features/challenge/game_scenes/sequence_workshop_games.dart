import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PatternWorkshopVariant { train, path }

class OddCardInvestigationGameView extends StatefulWidget {
  const OddCardInvestigationGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<OddCardInvestigationGameView> createState() =>
      _OddCardInvestigationGameViewState();
}

class _OddCardInvestigationGameViewState
    extends State<OddCardInvestigationGameView> with TickerProviderStateMixin {
  static const _oddByRound = [3, 1];
  late final AnimationController _entrance;
  late final AnimationController _reaction;
  int _round = 0;
  int? _selection;
  bool _correct = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    )..forward();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
  }

  @override
  void dispose() {
    _entrance.dispose();
    _reaction.dispose();
    super.dispose();
  }

  Future<void> _choose(int index) async {
    if (_selection != null) return;
    final correct = index == _oddByRound[_round];
    setState(() {
      _selection = index;
      _correct = correct;
    });
    correct ? HapticFeedback.mediumImpact() : HapticFeedback.lightImpact();
    await _reaction.forward(from: 0);
    if (!mounted) return;
    if (!correct) {
      setState(() => _selection = null);
      _reaction.reset();
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
    if (_round + 1 < _oddByRound.length) {
      setState(() {
        _round++;
        _selection = null;
        _correct = false;
      });
      _reaction.reset();
      _entrance.forward(from: 0);
      return;
    }
    if (!_answerSent) {
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _WorkshopLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_entrance, _reaction]),
                builder: (_, __) => CustomPaint(
                  painter: _OddInvestigationPainter(
                    accent: widget.accent,
                    round: _round,
                    entrance: Curves.easeOutBack.transform(_entrance.value),
                    reaction: _reaction.value,
                    selection: _selection,
                    correct: _correct,
                  ),
                ),
              ),
              for (var index = 0; index < 6; index++)
                Positioned.fromRect(
                  rect: layout.gridRect(index),
                  child: Semantics(
                    key: ValueKey('odd-card-$_round-$index'),
                    button: true,
                    label: '${widget.semanticLabel} ${index + 1}',
                    excludeSemantics: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _choose(index),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class PatternTrainWorkshopGameView extends StatefulWidget {
  const PatternTrainWorkshopGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
    this.variant = PatternWorkshopVariant.train,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;
  final PatternWorkshopVariant variant;

  @override
  State<PatternTrainWorkshopGameView> createState() =>
      _PatternTrainWorkshopGameViewState();
}

class _PatternTrainWorkshopGameViewState
    extends State<PatternTrainWorkshopGameView> with TickerProviderStateMixin {
  static const _answers = [1, 0, 2];
  final List<int?> _slots = List<int?>.filled(3, null);
  late final AnimationController _reaction;
  late final AnimationController _success;
  int? _wrongSlot;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _drop(int slot, int piece) async {
    if (_slots.contains(piece) || _slots[slot] != null || _answerSent) return;
    if (_answers[slot] != piece) {
      setState(() => _wrongSlot = slot);
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() => _wrongSlot = null);
      _reaction.reset();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _slots[slot] = piece);
    if (_slots.every((piece) => piece != null)) {
      HapticFeedback.mediumImpact();
      await _success.forward(from: 0);
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _WorkshopLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_reaction, _success]),
                builder: (_, __) => CustomPaint(
                  painter: _PatternWorkshopPainter(
                    accent: widget.accent,
                    variant: widget.variant,
                    slots: _slots,
                    wrongSlot: _wrongSlot,
                    reaction: _reaction.value,
                    success: _success.value,
                  ),
                ),
              ),
              for (var slot = 0; slot < 3; slot++)
                Positioned.fromRect(
                  rect: layout.patternSlot(slot),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (details) =>
                        !_answerSent &&
                        _slots[slot] == null &&
                        !_slots.contains(details.data),
                    onAcceptWithDetails: (details) => _drop(slot, details.data),
                    builder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
              for (var piece = 0; piece < 3; piece++)
                if (!_slots.contains(piece))
                  Positioned.fromRect(
                    rect: layout.patternPiece(piece),
                    child: _PaintedDraggable(
                      data: piece,
                      size: layout.patternPiece(piece).size,
                      painter: _LoosePiecePainter(
                        accent: widget.accent,
                        piece: piece,
                        variant: widget.variant,
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class RocketAssemblyWorkshopGameView extends StatefulWidget {
  const RocketAssemblyWorkshopGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<RocketAssemblyWorkshopGameView> createState() =>
      _RocketAssemblyWorkshopGameViewState();
}

class _RocketAssemblyWorkshopGameViewState
    extends State<RocketAssemblyWorkshopGameView>
    with TickerProviderStateMixin {
  final List<bool> _placed = List<bool>.filled(4, false);
  late final AnimationController _reaction;
  late final AnimationController _launch;
  int? _wrongPart;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _launch = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    _launch.dispose();
    super.dispose();
  }

  Future<void> _drop(int target, int part) async {
    if (_placed[part] || _answerSent) return;
    if (target != part) {
      setState(() => _wrongPart = part);
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() => _wrongPart = null);
      _reaction.reset();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _placed[part] = true);
    if (_placed.every((value) => value)) {
      HapticFeedback.heavyImpact();
      await _launch.forward(from: 0);
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _WorkshopLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_reaction, _launch]),
                builder: (_, __) => CustomPaint(
                  painter: _RocketWorkshopPainter(
                    accent: widget.accent,
                    placed: _placed,
                    wrongPart: _wrongPart,
                    reaction: _reaction.value,
                    launch: _launch.value,
                  ),
                ),
              ),
              for (var target = 0; target < 4; target++)
                Positioned.fromRect(
                  rect: layout.rocketTarget(target),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (details) =>
                        !_answerSent && !_placed[details.data],
                    onAcceptWithDetails: (details) =>
                        _drop(target, details.data),
                    builder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
              for (var part = 0; part < 4; part++)
                if (!_placed[part])
                  Positioned.fromRect(
                    rect: layout.rocketPart(part),
                    child: _PaintedDraggable(
                      data: part,
                      size: layout.rocketPart(part).size,
                      painter: _RocketPartPainter(
                        accent: widget.accent,
                        part: part,
                        wrong: _wrongPart == part,
                        reaction: _reaction.value,
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _WorkshopFrame extends StatelessWidget {
  const _WorkshopFrame({
    required this.compact,
    required this.semanticLabel,
    required this.child,
  });

  final bool compact;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Semantics(
        container: true,
        label: semanticLabel,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: compact ? 246 : 286,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _WorkshopLayout {
  const _WorkshopLayout(this.size);

  final Size size;

  Rect _rect(double x, double y, double width, double height) => Rect.fromLTWH(
        x / 360 * size.width,
        y / 286 * size.height,
        width / 360 * size.width,
        height / 286 * size.height,
      );

  Rect gridRect(int index) => _rect(
        31 + (index % 3) * 105,
        51 + (index ~/ 3) * 98,
        88,
        78,
      );

  Rect patternSlot(int index) => _rect(39 + index * 95, 99, 72, 66);

  Rect patternPiece(int index) => _rect(65 + index * 83, 208, 54, 50);

  Rect rocketTarget(int part) => switch (part) {
        0 => _rect(200, 42, 54, 58),
        1 => _rect(195, 92, 64, 88),
        2 => _rect(169, 145, 38, 56),
        _ => _rect(247, 145, 38, 56),
      };

  Rect rocketPart(int part) =>
      _rect(34 + (part % 2) * 68, 78 + (part ~/ 2) * 88, 54, 64);
}

class _PaintedDraggable extends StatelessWidget {
  const _PaintedDraggable({
    required this.data,
    required this.size,
    required this.painter,
  });

  final int data;
  final Size size;
  final CustomPainter painter;

  Widget _piece({double opacity = 1}) => Opacity(
        opacity: opacity,
        child: CustomPaint(size: size, painter: painter),
      );

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<int>(
      data: data,
      delay: const Duration(milliseconds: 90),
      hapticFeedbackOnStart: true,
      feedback: Material(
        type: MaterialType.transparency,
        child: Transform.scale(scale: 1.12, child: _piece()),
      ),
      childWhenDragging: _piece(opacity: 0.2),
      child: _piece(),
    );
  }
}

class _OddInvestigationPainter extends CustomPainter {
  const _OddInvestigationPainter({
    required this.accent,
    required this.round,
    required this.entrance,
    required this.reaction,
    required this.selection,
    required this.correct,
  });

  final Color accent;
  final int round;
  final double entrance;
  final double reaction;
  final int? selection;
  final bool correct;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackdrop(canvas, size, accent, const Color(0xFF16284F));
    final layout = _WorkshopLayout(size);
    _paintRoundLights(canvas, size, round, 2, accent);
    for (var i = 0; i < 6; i++) {
      final rect = layout.gridRect(i);
      final selected = selection == i;
      final shake = selected && !correct
          ? math.sin(reaction * math.pi * 8) * (1 - reaction) * 7
          : 0.0;
      final pop =
          selected && correct ? 1 + math.sin(reaction * math.pi) * .1 : 1.0;
      canvas.save();
      canvas.translate(rect.center.dx + shake, rect.center.dy);
      canvas.scale(pop * entrance.clamp(.05, 1.0));
      canvas.translate(-rect.center.dx, -rect.center.dy);
      final card = RRect.fromRectAndRadius(rect, const Radius.circular(17));
      canvas.drawRRect(card, Paint()..color = const Color(0xFFF8FBFF));
      canvas.drawRRect(
        card,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 4 : 2
          ..color = selected
              ? (correct ? const Color(0xFF51D695) : const Color(0xFFFF6C78))
              : Colors.white.withValues(alpha: .55),
      );
      _paintSpecimen(canvas, rect.center, rect.shortestSide * .24, round, i);
      canvas.restore();
    }
  }

  void _paintSpecimen(Canvas canvas, Offset c, double r, int round, int index) {
    final odd = _OddCardInvestigationGameViewState._oddByRound[round] == index;
    if (round == 0) {
      canvas.drawCircle(c, r, Paint()..color = const Color(0xFF65D9C8));
      canvas.drawCircle(c.translate(-r * .25, -r * .3), r * .22,
          Paint()..color = Colors.white.withValues(alpha: .7));
      final count = odd ? 4 : 3;
      for (var j = 0; j < count; j++) {
        final a = -math.pi / 2 + j * math.pi * 2 / count;
        canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * r * .72,
            r * .12, Paint()..color = const Color(0xFFFFCF5C));
      }
    } else {
      final path = Path();
      final points = odd ? 5 : 6;
      for (var j = 0; j < points; j++) {
        final a = -math.pi / 2 + j * math.pi * 2 / points;
        final p = c + Offset(math.cos(a), math.sin(a)) * r;
        j == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..color = const Color(0xFFFF8D74));
      canvas.drawCircle(c, r * .35, Paint()..color = const Color(0xFF7B6CF6));
    }
  }

  @override
  bool shouldRepaint(covariant _OddInvestigationPainter oldDelegate) => true;
}

class _PatternWorkshopPainter extends CustomPainter {
  const _PatternWorkshopPainter({
    required this.accent,
    required this.variant,
    required this.slots,
    required this.wrongSlot,
    required this.reaction,
    required this.success,
  });

  final Color accent;
  final PatternWorkshopVariant variant;
  final List<int?> slots;
  final int? wrongSlot;
  final double reaction;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackdrop(
        canvas,
        size,
        accent,
        variant == PatternWorkshopVariant.train
            ? const Color(0xFF244B67)
            : const Color(0xFF315745));
    final layout = _WorkshopLayout(size);
    final y = size.height * .57;
    if (variant == PatternWorkshopVariant.train) {
      canvas.drawRect(Rect.fromLTWH(0, y + size.height * .08, size.width, 5),
          Paint()..color = const Color(0xFFBAD4D9));
      for (var x = 0.0; x < size.width; x += size.width * .08) {
        canvas.drawRect(
            Rect.fromLTWH(x, y + size.height * .06, size.width * .045, 10),
            Paint()..color = const Color(0xFF8CA8AE));
      }
    } else {
      final path = Path()..moveTo(0, y + 8);
      for (var x = 0.0; x <= size.width; x += 8) {
        path.lineTo(x, y + math.sin(x / size.width * math.pi * 3) * 7);
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = const Color(0xFFFFD47B)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 18);
    }
    _paintRoundLights(canvas, size, slots.whereType<int>().length, 3, accent);
    for (var i = 0; i < 3; i++) {
      final rect = layout.patternSlot(i);
      final shake = wrongSlot == i
          ? math.sin(reaction * math.pi * 8) * (1 - reaction) * 7
          : 0.0;
      canvas.save();
      canvas.translate(shake, -success * size.height * .025);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(14)),
        Paint()
          ..color = slots[i] == null
              ? Colors.white.withValues(alpha: .18)
              : Colors.white,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(14)),
        Paint()
          ..color = Colors.white.withValues(alpha: .65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      if (slots[i] != null) {
        _paintPatternPiece(canvas, rect, slots[i]!, variant, accent);
      }
      canvas.restore();
    }
    for (var i = 0; i < 4; i++) {
      final x = size.width * (.08 + i * .28);
      final c = Offset(x, size.height * .28);
      canvas.drawCircle(
          c,
          16,
          Paint()
            ..color =
                i.isEven ? const Color(0xFFFFCF5C) : const Color(0xFF65D9C8));
      canvas.drawCircle(c, 6, Paint()..color = const Color(0xFF405078));
    }
  }

  @override
  bool shouldRepaint(covariant _PatternWorkshopPainter oldDelegate) => true;
}

class _LoosePiecePainter extends CustomPainter {
  const _LoosePiecePainter(
      {required this.accent, required this.piece, required this.variant});
  final Color accent;
  final int piece;
  final PatternWorkshopVariant variant;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(2), const Radius.circular(13)),
        Paint()..color = Colors.white);
    _paintPatternPiece(canvas, rect, piece, variant, accent);
  }

  @override
  bool shouldRepaint(covariant _LoosePiecePainter oldDelegate) => false;
}

class _RocketWorkshopPainter extends CustomPainter {
  const _RocketWorkshopPainter({
    required this.accent,
    required this.placed,
    required this.wrongPart,
    required this.reaction,
    required this.launch,
  });
  final Color accent;
  final List<bool> placed;
  final int? wrongPart;
  final double reaction;
  final double launch;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackdrop(canvas, size, accent, const Color(0xFF182C59));
    final layout = _WorkshopLayout(size);
    for (var i = 0; i < 16; i++) {
      final x = ((i * 73) % 347) / 360 * size.width;
      final y = ((i * 47) % 210) / 286 * size.height;
      canvas.drawCircle(Offset(x, y), i.isEven ? 1.5 : 2.2,
          Paint()..color = Colors.white.withValues(alpha: .55));
    }
    final rise = Curves.easeIn.transform(launch) * size.height * .6;
    canvas.save();
    canvas.translate(0, -rise);
    for (var part = 0; part < 4; part++) {
      final rect = layout.rocketTarget(part);
      if (placed[part]) {
        _paintRocketPart(canvas, rect, part, accent);
      } else {
        _paintRocketSilhouette(canvas, rect, part);
      }
    }
    if (placed.every((value) => value)) {
      final flame = layout.rocketTarget(1).bottomCenter + const Offset(0, 14);
      final flicker = math.sin(launch * math.pi * 18).abs();
      final path = Path()
        ..moveTo(flame.dx - 13, flame.dy)
        ..quadraticBezierTo(
            flame.dx, flame.dy + 42 + flicker * 12, flame.dx + 13, flame.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = const Color(0xFFFFB840));
      canvas.drawOval(
          Rect.fromCenter(
              center: flame + const Offset(0, 12), width: 10, height: 29),
          Paint()..color = const Color(0xFFFF6A65));
    }
    canvas.restore();
    _paintRoundLights(
        canvas, size, placed.where((value) => value).length, 4, accent);
  }

  @override
  bool shouldRepaint(covariant _RocketWorkshopPainter oldDelegate) => true;
}

class _RocketPartPainter extends CustomPainter {
  const _RocketPartPainter(
      {required this.accent,
      required this.part,
      required this.wrong,
      required this.reaction});
  final Color accent;
  final int part;
  final bool wrong;
  final double reaction;

  @override
  void paint(Canvas canvas, Size size) {
    final shake =
        wrong ? math.sin(reaction * math.pi * 8) * (1 - reaction) * 5 : 0.0;
    canvas.save();
    canvas.translate(shake, 0);
    _paintRocketPart(canvas, Offset.zero & size, part, accent);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RocketPartPainter oldDelegate) => true;
}

void _paintBackdrop(Canvas canvas, Size size, Color accent, Color dark) {
  final bounds = Offset.zero & size;
  canvas.drawRect(
    bounds,
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [dark, Color.lerp(dark, accent, .48)!, const Color(0xFFBDEBDD)],
      ).createShader(bounds),
  );
  canvas.drawCircle(Offset(size.width * .9, size.height * .13),
      size.height * .15, Paint()..color = Colors.white.withValues(alpha: .1));
}

void _paintRoundLights(
    Canvas canvas, Size size, int active, int total, Color accent) {
  const radius = 5.0;
  final gap = size.width * .043;
  final start = size.width / 2 - (total - 1) * gap / 2;
  for (var i = 0; i < total; i++) {
    canvas.drawCircle(
      Offset(start + i * gap, size.height * .055),
      radius,
      Paint()
        ..color = i < active
            ? const Color(0xFFFFD35C)
            : Colors.white.withValues(alpha: .28),
    );
  }
}

void _paintPatternPiece(Canvas canvas, Rect rect, int piece,
    PatternWorkshopVariant variant, Color accent) {
  final c = rect.center;
  final r = rect.shortestSide * .25;
  final color = [
    const Color(0xFFFF7F78),
    const Color(0xFF62D6C5),
    const Color(0xFFFFCE61)
  ][piece];
  if (variant == PatternWorkshopVariant.train) {
    final body = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: c.translate(0, -3), width: r * 2.25, height: r * 1.35),
        Radius.circular(r * .25));
    canvas.drawRRect(body, Paint()..color = color);
    canvas.drawRect(
        Rect.fromCenter(
            center: c.translate(r * .55, -r * .9), width: r * .55, height: r),
        Paint()..color = Color.lerp(color, Colors.white, .25)!);
    canvas.drawCircle(c.translate(-r * .6, r * .65), r * .32,
        Paint()..color = const Color(0xFF354466));
    canvas.drawCircle(c.translate(r * .6, r * .65), r * .32,
        Paint()..color = const Color(0xFF354466));
  } else {
    final path = Path();
    final count = piece + 3;
    for (var i = 0; i < count; i++) {
      final a = -math.pi / 2 + i * math.pi * 2 / count;
      final p = c + Offset(math.cos(a), math.sin(a)) * r;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(c, r * .3, Paint()..color = accent.withValues(alpha: .8));
  }
}

void _paintRocketSilhouette(Canvas canvas, Rect rect, int part) {
  final paint = Paint()..color = Colors.white.withValues(alpha: .16);
  _paintRocketPartShape(canvas, rect.deflate(2), part, paint);
  _paintRocketPartShape(
    canvas,
    rect.deflate(2),
    part,
    Paint()
      ..color = Colors.white.withValues(alpha: .45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void _paintRocketPart(Canvas canvas, Rect rect, int part, Color accent) {
  final colors = [
    const Color(0xFFFF7C75),
    const Color(0xFFF5F8FF),
    const Color(0xFF64D4C5),
    const Color(0xFFFFCD58)
  ];
  _paintRocketPartShape(
      canvas, rect.deflate(2), part, Paint()..color = colors[part]);
  if (part == 1) {
    canvas.drawCircle(rect.center.translate(0, -rect.height * .12),
        rect.width * .18, Paint()..color = accent);
    canvas.drawCircle(
        rect.center.translate(-rect.width * .05, -rect.height * .17),
        rect.width * .06,
        Paint()..color = Colors.white.withValues(alpha: .75));
  }
}

void _paintRocketPartShape(Canvas canvas, Rect rect, int part, Paint paint) {
  final path = Path();
  if (part == 0) {
    path.moveTo(rect.center.dx, rect.top);
    path.quadraticBezierTo(
        rect.right, rect.bottom * .72, rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.quadraticBezierTo(
        rect.left, rect.bottom * .72, rect.center.dx, rect.top);
  } else if (part == 1) {
    path.addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.width * .32)));
  } else if (part == 2) {
    path.moveTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.quadraticBezierTo(rect.left, rect.center.dy, rect.right, rect.top);
  } else {
    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.right, rect.bottom);
    path.quadraticBezierTo(rect.right, rect.center.dy, rect.left, rect.top);
  }
  canvas.drawPath(path, paint);
}
