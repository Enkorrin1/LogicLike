import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShadowMatchGameView extends StatefulWidget {
  const ShadowMatchGameView({
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
  State<ShadowMatchGameView> createState() => _ShadowMatchGameViewState();
}

class _ShadowMatchGameViewState extends State<ShadowMatchGameView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reaction;
  int _round = 0;
  Offset _piece = _home;
  Offset _anchor = Offset.zero;
  bool _dragging = false;
  bool _locked = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }

  Offset _scenePoint(Offset local, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin = Offset((size.width - 360 * scale) / 2,
        (size.height - 240 * scale) / 2);
    return (local - origin) / scale;
  }

  void _start(DragStartDetails details, Size size) {
    if (_locked || _sent) return;
    final point = _scenePoint(details.localPosition, size);
    if ((point - _piece).distance > 44) return;
    setState(() => _dragging = true);
    _anchor = point - _piece;
  }

  void _move(DragUpdateDetails details, Size size) {
    if (!_dragging) return;
    final point = _scenePoint(details.localPosition, size) - _anchor;
    setState(() => _piece = Offset(
          point.dx.clamp(28, 332),
          point.dy.clamp(42, 214),
        ));
  }

  void _end(DragEndDetails details) {
    if (!_dragging) return;
    setState(() => _dragging = false);
    var nearest = 0;
    for (var index = 1; index < _targets.length; index++) {
      if ((_piece - _targets[index]).distance <
          (_piece - _targets[nearest]).distance) nearest = index;
    }
    if (nearest != _answers[_round] ||
        (_piece - _targets[nearest]).distance > 62) {
      HapticFeedback.selectionClick();
      _reaction.forward(from: 0);
      setState(() => _piece = _home);
      return;
    }
    HapticFeedback.lightImpact();
    setState(() {
      _locked = true;
      _piece = _targets[nearest];
    });
    _reaction.forward(from: 0).whenComplete(() async {
      if (!mounted || _sent) return;
      if (_round == 2) {
        _sent = true;
        widget.onAnswerSelected(widget.correctAnswer);
        return;
      }
      setState(() {
        _round++;
        _piece = _home;
        _locked = false;
      });
      _reaction.reset();
    });
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: widget.semanticLabel,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              height: widget.compact ? 216 : 246,
              width: double.infinity,
              child: LayoutBuilder(builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  key: const ValueKey('shadow-match-board'),
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (event) => _start(event, size),
                  onPanUpdate: (event) => _move(event, size),
                  onPanEnd: _end,
                  child: AnimatedBuilder(
                    animation: _reaction,
                    builder: (context, child) => CustomPaint(
                      painter: _ShadowPainter(
                        accent: widget.accent,
                        round: _round,
                        piece: _piece,
                        dragging: _dragging,
                        reaction: _reaction.value,
                        locked: _locked,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
}

const _home = Offset(180, 205);
const _targets = [Offset(70, 111), Offset(180, 101), Offset(290, 111)];
const _answers = [1, 0, 2];

class _ShadowPainter extends CustomPainter {
  const _ShadowPainter({
    required this.accent,
    required this.round,
    required this.piece,
    required this.dragging,
    required this.reaction,
    required this.locked,
  });

  final Color accent;
  final int round;
  final Offset piece;
  final bool dragging;
  final double reaction;
  final bool locked;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    canvas.save();
    canvas.translate((size.width - 360 * scale) / 2,
        (size.height - 240 * scale) / 2);
    canvas.scale(scale);
    const scene = Rect.fromLTWH(0, 0, 360, 240);
    canvas.drawRect(
      scene,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF11173A), Color(0xFF315B5B)],
        ).createShader(scene),
    );
    _forest(canvas);
    for (var index = 0; index < 3; index++) {
      _pedestal(canvas, _targets[index]);
      _object(canvas, _targets[index], index, shadow: true);
    }
    final bounce = locked ? math.sin(reaction * math.pi) * 7 : 0.0;
    _object(canvas, piece - Offset(0, (dragging ? 5 : 0) + bounce), round);
    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(
        Offset(154 + index * 26, 19),
        6,
        Paint()
          ..color = index < round
              ? const Color(0xFF62D6A5)
              : index == round
                  ? Colors.white
                  : Colors.white38,
      );
    }
    canvas.restore();
  }

  void _forest(Canvas canvas) {
    canvas.drawCircle(const Offset(300, 43), 23,
        Paint()..color = const Color(0xFFFFE7A5));
    final ground = Path()
      ..moveTo(0, 148)
      ..quadraticBezierTo(180, 126, 360, 150)
      ..lineTo(360, 240)
      ..lineTo(0, 240)
      ..close();
    canvas.drawPath(ground, Paint()..color = const Color(0xFF153C3A));
    final tree = Paint()..color = const Color(0xFF102831);
    for (var index = 0; index < 12; index++) {
      final x = index * 34.0 - 12;
      canvas.drawPath(
        Path()
          ..moveTo(x, 151)
          ..lineTo(x + 14, 75 + (index % 3) * 9)
          ..lineTo(x + 29, 151)
          ..close(),
        tree,
      );
    }
  }

  void _pedestal(Canvas canvas, Offset center) {
    canvas.drawOval(Rect.fromCenter(center: center + const Offset(0, 28), width: 72, height: 24),
        Paint()..color = const Color(0xFF8D6442));
  }

  void _object(Canvas canvas, Offset center, int kind, {bool shadow = false}) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    final color = shadow ? const Color(0xFF07151C) : [const Color(0xFFFFCB58), const Color(0xFFEF7D62), const Color(0xFF62C9BF)][kind];
    if (kind == 0) {
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-20, -21, 40, 40), const Radius.circular(8)), Paint()..color = color);
      canvas.drawArc(const Rect.fromLTWH(-16, -38, 32, 34), math.pi, math.pi, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 5);
      if (!shadow) canvas.drawCircle(Offset.zero, 8, Paint()..color = accent);
    } else if (kind == 1) {
      final path = Path()..moveTo(-19, 14)..lineTo(-13, -28)..quadraticBezierTo(5, -30, 9, -14)..lineTo(3, 0)..quadraticBezierTo(27, 2, 29, 14)..close();
      canvas.drawPath(path, Paint()..color = color);
    } else {
      canvas.drawOval(const Rect.fromLTWH(-23, -17, 46, 34), Paint()..color = color);
      canvas.drawArc(const Rect.fromLTWH(8, -15, 31, 28), -math.pi / 2, math.pi, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 7);
      final spout = Path()..moveTo(-18, -8)..quadraticBezierTo(-40, -20, -40, -6)..quadraticBezierTo(-28, -2, -20, 6)..close();
      canvas.drawPath(spout, Paint()..color = color);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShadowPainter oldDelegate) =>
      oldDelegate.round != round ||
      oldDelegate.piece != piece ||
      oldDelegate.dragging != dragging ||
      oldDelegate.reaction != reaction ||
      oldDelegate.locked != locked ||
      oldDelegate.accent != accent;
}
