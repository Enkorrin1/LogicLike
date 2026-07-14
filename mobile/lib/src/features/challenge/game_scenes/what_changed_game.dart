import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WhatChangedGameView extends StatefulWidget {
  const WhatChangedGameView({
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
  State<WhatChangedGameView> createState() => _WhatChangedGameViewState();
}

class _WhatChangedGameViewState extends State<WhatChangedGameView>
    with TickerProviderStateMixin {
  late final AnimationController _curtain;
  late final AnimationController _reaction;
  int _round = 0;
  int _dialTaps = 0;
  Offset _flask = _flaskMoved;
  Offset _anchor = Offset.zero;
  bool _dragging = false;
  bool _roundLocked = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _curtain = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _curtain.dispose();
    _reaction.dispose();
    super.dispose();
  }

  bool get _ready => _curtain.isCompleted && !_roundLocked && !_sent;

  Offset _boardPoint(Offset local, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    return (local - Offset((size.width - 360 * scale) / 2,
            (size.height - 240 * scale) / 2)) /
        scale;
  }

  void _panStart(DragStartDetails details, Size size) {
    if (!_ready) return;
    final point = _boardPoint(details.localPosition, size);
    if (_round == 0 && (point - _flask).distance < 40) {
      _dragging = true;
      _anchor = point - _flask;
      setState(() {});
    } else if (_round == 2 && point.dx > 185 && point.dy > 108) {
      _dragging = true;
      _anchor = point;
    }
  }

  void _panUpdate(DragUpdateDetails details, Size size) {
    if (!_dragging) return;
    final point = _boardPoint(details.localPosition, size);
    if (_round == 0) {
      setState(() => _flask = point - _anchor);
    }
  }

  void _panEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;
    if (_round == 0 && (_flask - _flaskHome).distance < 38) {
      setState(() => _flask = _flaskHome);
      _finishRound();
    } else if (_round == 2 && details.velocity.pixelsPerSecond.dx < -180) {
      _finishRound();
    } else {
      HapticFeedback.selectionClick();
      setState(() {
        if (_round == 0) _flask = _flaskMoved;
      });
      _reaction.forward(from: 0);
    }
  }

  void _tap(TapUpDetails details, Size size) {
    if (!_ready || _round != 1) return;
    final point = _boardPoint(details.localPosition, size);
    if ((point - _dialCenter).distance > 37) return;
    HapticFeedback.selectionClick();
    setState(() => _dialTaps++);
    if (_dialTaps == 3) _finishRound();
  }

  void _finishRound() {
    if (_roundLocked || _sent) return;
    HapticFeedback.lightImpact();
    setState(() => _roundLocked = true);
    _reaction.forward(from: 0).whenComplete(() {
      if (!mounted || _sent) return;
      if (_round == 2) {
        _sent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      } else {
        setState(() {
          _round++;
          _roundLocked = false;
        });
        _reaction.reset();
        _curtain.forward(from: 0);
      }
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
              width: double.infinity,
              height: widget.compact ? 216 : 246,
              child: LayoutBuilder(builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  key: const ValueKey('what-changed-board'),
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (event) => _panStart(event, size),
                  onPanUpdate: (event) => _panUpdate(event, size),
                  onPanEnd: _panEnd,
                  onTapUp: (event) => _tap(event, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_curtain, _reaction]),
                    builder: (context, child) => CustomPaint(
                      painter: _ChangedLabPainter(
                        accent: widget.accent,
                        round: _round,
                        dialTaps: _dialTaps,
                        flask: _flask,
                        dragging: _dragging,
                        curtain: _curtain.value,
                        reaction: _reaction.value,
                        locked: _roundLocked,
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

const _flaskHome = Offset(83, 167);
const _flaskMoved = Offset(280, 103);
const _dialCenter = Offset(155, 132);

class _ChangedLabPainter extends CustomPainter {
  const _ChangedLabPainter({
    required this.accent,
    required this.round,
    required this.dialTaps,
    required this.flask,
    required this.dragging,
    required this.curtain,
    required this.reaction,
    required this.locked,
  });

  final Color accent;
  final int round;
  final int dialTaps;
  final Offset flask;
  final bool dragging;
  final double curtain;
  final double reaction;
  final bool locked;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    canvas.save();
    canvas.translate((size.width - 360 * scale) / 2,
        (size.height - 240 * scale) / 2);
    canvas.scale(scale);
    _room(canvas);
    _flaskObject(canvas, round == 0 ? flask : _flaskHome, dragging);
    _dial(canvas);
    _tubes(canvas);
    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(Offset(154 + index * 26, 18), 6,
          Paint()..color = index < round ? const Color(0xFF42C997) : index == round ? accent : const Color(0xFFB8CFCC));
    }
    if (curtain < .78) {
      final width = (1 - Curves.easeInOut.transform(curtain / .78)) * 180;
      canvas.drawRect(Rect.fromLTWH(0, 0, width, 240), Paint()..color = const Color(0xFF315A68));
      canvas.drawRect(Rect.fromLTWH(360 - width, 0, width, 240), Paint()..color = const Color(0xFF315A68));
    }
    if (locked) {
      canvas.drawCircle([_flaskHome, _dialCenter, const Offset(247, 144)][round],
          30 + reaction * 34, Paint()..color = const Color(0xFF42C997).withValues(alpha: (1 - reaction) * .35)..style = PaintingStyle.stroke..strokeWidth = 5);
    }
    canvas.restore();
  }

  void _room(Canvas canvas) {
    const wall = Rect.fromLTWH(0, 0, 360, 178);
    canvas.drawRect(wall, Paint()..shader = const LinearGradient(colors: [Color(0xFFF4FCF9), Color(0xFFCBE4E0)]).createShader(wall));
    final grid = Paint()..color = const Color(0x258FB9B4)..strokeWidth = 1;
    for (var x = 0.0; x <= 360; x += 45) canvas.drawLine(Offset(x, 0), Offset(x, 178), grid);
    for (var y = 44.0; y < 178; y += 44) canvas.drawLine(Offset(0, y), Offset(360, y), grid);
    canvas.drawRect(const Rect.fromLTWH(0, 176, 360, 64), Paint()..color = const Color(0xFF31545A));
    canvas.drawRect(const Rect.fromLTWH(0, 173, 360, 13), Paint()..color = const Color(0xFFDAA76A));
  }

  void _flaskObject(Canvas canvas, Offset center, bool lifted) {
    canvas.save(); canvas.translate(center.dx, center.dy - (lifted ? 5 : 0));
    final path = Path()..moveTo(-8,-30)..lineTo(8,-30)..lineTo(8,-12)..quadraticBezierTo(26,11,25,19)..quadraticBezierTo(20,29,0,29)..quadraticBezierTo(-20,29,-25,19)..quadraticBezierTo(-26,11,-8,-12)..close();
    canvas.drawShadow(path, Colors.black, lifted ? 9 : 4, false);
    canvas.drawPath(path, Paint()..color = const Color(0xFFD9F5F0));
    canvas.drawOval(const Rect.fromLTWH(-22, 8, 44, 20), Paint()..color = const Color(0xFFEF6F91));
    canvas.drawRect(const Rect.fromLTWH(-11,-34,22,6), Paint()..color = const Color(0xFF345760));
    canvas.restore();
  }

  void _dial(Canvas canvas) {
    canvas.drawCircle(_dialCenter, 34, Paint()..color = const Color(0xFF315A68));
    canvas.drawCircle(_dialCenter, 27, Paint()..color = const Color(0xFFFFF2BF));
    final angle = (-.7 + dialTaps * .7) * math.pi;
    canvas.drawLine(_dialCenter, _dialCenter + Offset(math.cos(angle), math.sin(angle)) * 19,
        Paint()..color = accent..strokeWidth = 5..strokeCap = StrokeCap.round);
    canvas.drawCircle(_dialCenter, 5, Paint()..color = accent);
  }

  void _tubes(Canvas canvas) {
    final shifted = round == 2;
    const colors = [Color(0xFFFFD36E), Color(0xFFEF738B), Color(0xFF6FC6DF)];
    for (var index = 0; index < 3; index++) {
      final x = 220.0 + index * 27 + (shifted ? 12 : 0);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, 112, 14, 54), const Radius.circular(7)), Paint()..color = const Color(0xFFE2F7F3));
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 2, 138, 10, 26), const Radius.circular(5)), Paint()..color = colors[index]);
    }
    if (round == 2) canvas.drawLine(const Offset(286, 180), const Offset(202, 180), Paint()..color = accent..strokeWidth = 5..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant _ChangedLabPainter oldDelegate) => true;
}
