import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampStoryGameView extends StatefulWidget {
  const CampStoryGameView({
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
  State<CampStoryGameView> createState() => _CampStoryGameViewState();
}

enum _CampItem { lantern, bottle, compass, map }

class _CampStoryGameViewState extends State<CampStoryGameView>
    with TickerProviderStateMixin {
  late final AnimationController _curtain;
  late final AnimationController _return;
  late final AnimationController _success;
  Timer? _memoryTimer;
  Timer? _answerTimer;
  _CampItem? _dragged;
  Offset _dragPosition = Offset.zero;
  Offset _returnFrom = Offset.zero;
  bool _changed = false;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _curtain = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    _return = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    )..addListener(() {
        if (!mounted || _dragged == null) return;
        final t = Curves.easeOutBack.transform(_return.value);
        setState(() {
          _dragPosition = Offset.lerp(
            _returnFrom,
            _itemHome(_dragged!),
            t,
          )!;
        });
        if (_return.isCompleted) setState(() => _dragged = null);
      });
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
    _memoryTimer = Timer(const Duration(milliseconds: 1400), _changeScene);
  }

  void _changeScene() {
    if (!mounted) return;
    _curtain.forward(from: 0);
    Timer(const Duration(milliseconds: 360), () {
      if (mounted) setState(() => _changed = true);
    });
  }

  @override
  void dispose() {
    _memoryTimer?.cancel();
    _answerTimer?.cancel();
    _curtain.dispose();
    _return.dispose();
    _success.dispose();
    super.dispose();
  }

  bool get _interactive => _changed && !_solved && !_return.isAnimating;

  Offset _toBoard(Offset local, Size size) {
    final scale =
        math.min(size.width / _board.width, size.height / _board.height);
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    return (local - origin) / scale;
  }

  void _start(DragStartDetails details, Size size) {
    if (!_interactive) return;
    final point = _toBoard(details.localPosition, size);
    for (final item in _CampItem.values.reversed) {
      if ((point - _itemHome(item)).distance < 25) {
        HapticFeedback.selectionClick();
        setState(() {
          _dragged = item;
          _dragPosition = point;
        });
        return;
      }
    }
  }

  void _update(DragUpdateDetails details, Size size) {
    if (_dragged == null || _return.isAnimating) return;
    final point = _toBoard(details.localPosition, size);
    setState(() {
      _dragPosition = Offset(
        point.dx.clamp(18, 342),
        point.dy.clamp(24, 238),
      );
    });
  }

  void _end(DragEndDetails details) {
    final item = _dragged;
    if (item == null) return;
    if (item == _CampItem.lantern &&
        (_dragPosition - _lanternTarget).distance < 40) {
      HapticFeedback.mediumImpact();
      setState(() {
        _solved = true;
        _dragged = null;
      });
      _success.forward(from: 0);
      _answerTimer = Timer(const Duration(milliseconds: 720), () {
        if (!mounted || _answerSent) return;
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      });
      return;
    }
    HapticFeedback.lightImpact();
    _returnFrom = _dragPosition;
    _return.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 224 : 258,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) => _start(details, size),
                  onPanUpdate: (details) => _update(details, size),
                  onPanEnd: _end,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_curtain, _return, _success]),
                    builder: (context, _) => CustomPaint(
                      painter: _CampPainter(
                        accent: widget.accent,
                        curtain: _curtain.value,
                        success: _success.value,
                        changed: _changed,
                        solved: _solved,
                        dragged: _dragged,
                        dragPosition: _dragPosition,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

const _board = Size(360, 252);
const _lanternTarget = Offset(183, 93);

Offset _itemHome(_CampItem item) => switch (item) {
      _CampItem.lantern => const Offset(235, 219),
      _CampItem.bottle => const Offset(270, 219),
      _CampItem.compass => const Offset(305, 219),
      _CampItem.map => const Offset(337, 219),
    };

class _CampPainter extends CustomPainter {
  const _CampPainter({
    required this.accent,
    required this.curtain,
    required this.success,
    required this.changed,
    required this.solved,
    required this.dragged,
    required this.dragPosition,
  });

  final Color accent;
  final double curtain;
  final double success;
  final bool changed;
  final bool solved;
  final _CampItem? dragged;
  final Offset dragPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final scale =
        math.min(size.width / _board.width, size.height / _board.height);
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFB9DCCA));
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    _drawLandscape(canvas);
    _drawTent(canvas);
    _drawCampfire(canvas);
    _drawSceneItems(canvas);
    _drawBackpack(canvas);
    if (dragged != null) {
      _drawItem(canvas, dragged!, dragPosition, lifted: true);
    }
    if (curtain > 0 && curtain < 1) _drawCurtain(canvas);
    if (solved) _drawSuccess(canvas);
    canvas.restore();
  }

  void _drawLandscape(Canvas canvas) {
    const sky = Rect.fromLTWH(0, 0, 360, 252);
    canvas.drawRect(
      sky,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8CC9D1), Color(0xFFF6D39A), Color(0xFF739A64)],
          stops: [0, .56, .57],
        ).createShader(sky),
    );
    canvas.drawCircle(
        const Offset(311, 36), 18, Paint()..color = const Color(0xFFFFE59A));
    final far = Paint()..color = const Color(0xFF4F8069);
    final near = Paint()..color = const Color(0xFF315F4C);
    for (final x in <double>[8, 47, 91, 284, 330]) {
      _tree(canvas, Offset(x, 112), 48, far);
    }
    for (final x in <double>[22, 322]) {
      _tree(canvas, Offset(x, 145), 68, near);
    }
    canvas.drawOval(const Rect.fromLTWH(-25, 170, 410, 108),
        Paint()..color = const Color(0xFF577D4D));
    final grass = Paint()
      ..color = const Color(0xFF315F43)
      ..strokeWidth = 1.5;
    for (var x = 5.0; x < 360; x += 17) {
      final y = 187 + (x % 23);
      canvas.drawLine(Offset(x, y), Offset(x + 4, y - 8), grass);
      canvas.drawLine(Offset(x + 5, y), Offset(x + 2, y - 6), grass);
    }
  }

  void _tree(Canvas canvas, Offset base, double height, Paint paint) {
    canvas.drawRect(
        Rect.fromLTWH(base.dx - 3, base.dy - height * .3, 6, height * .3),
        Paint()..color = const Color(0xFF5A4435));
    final path = Path()
      ..moveTo(base.dx, base.dy - height)
      ..lineTo(base.dx - height * .3, base.dy - height * .2)
      ..lineTo(base.dx + height * .3, base.dy - height * .2)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawTent(Canvas canvas) {
    final tent = Path()
      ..moveTo(42, 187)
      ..lineTo(104, 99)
      ..lineTo(166, 187)
      ..close();
    canvas.drawShadow(tent, Colors.black, 7, false);
    canvas.drawPath(tent, Paint()..color = const Color(0xFFE6A653));
    final door = Path()
      ..moveTo(104, 107)
      ..lineTo(104, 187)
      ..lineTo(139, 187)
      ..close();
    canvas.drawPath(door, Paint()..color = const Color(0xFF9E593C));
    canvas.drawLine(
        const Offset(104, 99),
        const Offset(104, 190),
        Paint()
          ..color = const Color(0xFFFFE0A0)
          ..strokeWidth = 2);
    canvas.drawLine(
        const Offset(38, 187),
        const Offset(171, 187),
        Paint()
          ..color = const Color(0xFF5C493A)
          ..strokeWidth = 4);
  }

  void _drawCampfire(Canvas canvas) {
    canvas.drawOval(const Rect.fromLTWH(166, 174, 75, 22),
        Paint()..color = Colors.black.withValues(alpha: .16));
    final log = Paint()
      ..color = const Color(0xFF6A4432)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(180, 188), const Offset(222, 174), log);
    canvas.drawLine(const Offset(181, 175), const Offset(222, 189), log);
    final flame = Path()
      ..moveTo(201, 178)
      ..cubicTo(185, 164, 201, 151, 204, 139)
      ..cubicTo(222, 157, 220, 171, 201, 178)
      ..close();
    canvas.drawPath(flame, Paint()..color = const Color(0xFFF36B3B));
    canvas.drawOval(const Rect.fromLTWH(197, 156, 12, 19),
        Paint()..color = const Color(0xFFFFD45F));
  }

  void _drawSceneItems(Canvas canvas) {
    final rope = Paint()
      ..color = const Color(0xFF5B4637)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(166, 70), const Offset(199, 70), rope);
    canvas.drawLine(const Offset(182, 70), const Offset(182, 76), rope);
    if (!changed || solved) {
      _drawItem(canvas, _CampItem.lantern, _lanternTarget);
    }
    _drawItem(canvas, _CampItem.bottle, const Offset(145, 169));
    _drawItem(canvas, _CampItem.compass, const Offset(274, 170));
    _drawItem(canvas, _CampItem.map, const Offset(302, 127));
    if (changed && !solved) {
      canvas.drawCircle(
          _lanternTarget,
          22,
          Paint()
            ..color = accent.withValues(alpha: .18)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
    }
  }

  void _drawBackpack(Canvas canvas) {
    final bag = RRect.fromRectAndRadius(
        const Rect.fromLTWH(212, 195, 145, 55), const Radius.circular(17));
    canvas.drawShadow(Path()..addRRect(bag), Colors.black, 6, false);
    canvas.drawRRect(bag, Paint()..color = const Color(0xFF6E4939));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(218, 199, 133, 44), const Radius.circular(13)),
        Paint()..color = const Color(0xFFB97948));
    canvas.drawRect(const Rect.fromLTWH(220, 198, 129, 9),
        Paint()..color = const Color(0xFF49352D));
    for (final item in _CampItem.values) {
      if (dragged != item) _drawItem(canvas, item, _itemHome(item));
    }
  }

  void _drawItem(Canvas canvas, _CampItem item, Offset center,
      {bool lifted = false}) {
    canvas.save();
    canvas.translate(center.dx, center.dy - (lifted ? 6 : 0));
    if (lifted) {
      canvas.drawCircle(Offset.zero, 25,
          Paint()..color = Colors.white.withValues(alpha: .22));
    }
    switch (item) {
      case _CampItem.lantern:
        canvas.drawRRect(
            RRect.fromRectAndRadius(const Rect.fromLTWH(-10, -12, 20, 25),
                const Radius.circular(6)),
            Paint()..color = const Color(0xFFFFD56A));
        canvas.drawRect(const Rect.fromLTWH(-13, 10, 26, 5),
            Paint()..color = const Color(0xFF384C4A));
        canvas.drawRect(const Rect.fromLTWH(-12, -16, 24, 5),
            Paint()..color = const Color(0xFF384C4A));
        canvas.drawArc(
            const Rect.fromLTWH(-10, -24, 20, 17),
            math.pi,
            math.pi,
            false,
            Paint()
              ..color = const Color(0xFF384C4A)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3);
      case _CampItem.bottle:
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                const Rect.fromLTWH(-8, -15, 16, 29), const Radius.circular(5)),
            Paint()..color = const Color(0xFF72C7C2));
        canvas.drawRect(const Rect.fromLTWH(-5, -20, 10, 7),
            Paint()..color = const Color(0xFF345B59));
        canvas.drawRect(const Rect.fromLTWH(-8, 1, 16, 5),
            Paint()..color = Colors.white.withValues(alpha: .65));
      case _CampItem.compass:
        canvas.drawCircle(
            Offset.zero, 13, Paint()..color = const Color(0xFFE9C068));
        canvas.drawCircle(
            Offset.zero, 9, Paint()..color = const Color(0xFFF7F0D5));
        final needle = Path()
          ..moveTo(0, -7)
          ..lineTo(4, 3)
          ..lineTo(0, 1)
          ..lineTo(-4, 3)
          ..close();
        canvas.drawPath(needle, Paint()..color = accent);
      case _CampItem.map:
        final map = Path()
          ..moveTo(-14, -11)
          ..lineTo(-5, -14)
          ..lineTo(5, -10)
          ..lineTo(14, -13)
          ..lineTo(14, 12)
          ..lineTo(5, 9)
          ..lineTo(-5, 13)
          ..lineTo(-14, 10)
          ..close();
        canvas.drawPath(map, Paint()..color = const Color(0xFFF2E4B4));
        canvas.drawLine(const Offset(-5, -13), const Offset(-5, 12),
            Paint()..color = const Color(0xFFB9A775));
        canvas.drawLine(const Offset(5, -10), const Offset(5, 9),
            Paint()..color = const Color(0xFFB9A775));
        canvas.drawCircle(const Offset(8, 1), 3, Paint()..color = accent);
    }
    canvas.restore();
  }

  void _drawCurtain(Canvas canvas) {
    final wave = math.sin(curtain * math.pi);
    final x = -90 + curtain * 540;
    final path = Path()
      ..moveTo(x - 105, 0)
      ..lineTo(x + 55, 0)
      ..quadraticBezierTo(x + 105 + wave * 25, 126, x + 45, 252)
      ..lineTo(x - 115, 252)
      ..quadraticBezierTo(x - 55, 126, x - 105, 0)
      ..close();
    canvas.drawPath(
        path, Paint()..color = const Color(0xFF315D59).withValues(alpha: .94));
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: .10)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8);
  }

  void _drawSuccess(Canvas canvas) {
    final t = Curves.easeOutCubic.transform(success);
    final fade = 1 - t;
    canvas.drawCircle(
        _lanternTarget,
        25 + t * 55,
        Paint()
          ..color = const Color(0xFFFFDA68).withValues(alpha: fade * .55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final p =
          _lanternTarget + Offset(math.cos(a), math.sin(a)) * (31 + t * 45);
      canvas.drawCircle(p, 3.5 * fade,
          Paint()..color = i.isEven ? accent : const Color(0xFFFFE487));
    }
  }

  @override
  bool shouldRepaint(covariant _CampPainter oldDelegate) => true;
}
