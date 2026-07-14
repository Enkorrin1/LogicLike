import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CleanRowGameView extends StatefulWidget {
  const CleanRowGameView({
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
  State<CleanRowGameView> createState() => _CleanRowGameViewState();
}

class _CleanRowGameViewState extends State<CleanRowGameView>
    with TickerProviderStateMixin {
  static const _centers = <Offset>[
    Offset(87, 91),
    Offset(184, 138),
    Offset(278, 82),
  ];

  late final AnimationController _shimmer;
  late final AnimationController _feedback;
  late final AnimationController _success;
  final List<double> _cleaned = [0, 0, 0];
  int _stage = 0;
  Offset? _lastPoint;
  bool _wrongSpot = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _feedback = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _shimmer.dispose();
    _feedback.dispose();
    _success.dispose();
    super.dispose();
  }

  Offset _toBoard(Offset local, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin =
        Offset((size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    return (local - origin) / scale;
  }

  void _start(DragStartDetails details, Size size) {
    if (_stage >= 3) return;
    _lastPoint = _toBoard(details.localPosition, size);
  }

  Future<void> _move(DragUpdateDetails details, Size size) async {
    if (_stage >= 3) return;
    final point = _toBoard(details.localPosition, size);
    final previous = _lastPoint ?? point;
    _lastPoint = point;
    final center = _centers[_stage];
    final inTarget = (point - center).distance < 48;
    if (!inTarget) {
      if (!_wrongSpot) {
        _wrongSpot = true;
        HapticFeedback.selectionClick();
        _feedback.forward(from: 0).whenComplete(() => _wrongSpot = false);
      }
      return;
    }
    final distance = (point - previous).distance.clamp(0.0, 22.0);
    final directionBonus = switch (_stage) {
      0 => (point.dx - previous.dx).abs() * .005,
      1 => (point.dy - previous.dy).abs() * .005,
      _ => distance * .0035,
    };
    setState(() {
      _cleaned[_stage] =
          (_cleaned[_stage] + distance * .006 + directionBonus).clamp(0, 1);
    });
    if (_cleaned[_stage] < 1) return;
    HapticFeedback.mediumImpact();
    final completed = _stage;
    setState(() {
      _cleaned[completed] = 1;
      _stage++;
      _lastPoint = null;
    });
    await _feedback.forward(from: 0);
    if (!mounted || _stage < 3) return;
    _shimmer.stop();
    await _success.forward(from: 0);
    if (!mounted || _answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: widget.semanticLabel,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(
              builder: (_, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (d) => _start(d, size),
                  onPanUpdate: (d) => _move(d, size),
                  onPanEnd: (_) => _lastPoint = null,
                  child: AnimatedBuilder(
                    animation:
                        Listenable.merge([_shimmer, _feedback, _success]),
                    builder: (_, __) => CustomPaint(
                      painter: _CleanRowPainter(
                        accent: widget.accent,
                        shimmer: _shimmer.value,
                        feedback: _feedback.value,
                        success: _success.value,
                        stage: _stage,
                        cleaned: List.of(_cleaned),
                        pointer: _lastPoint,
                        wrongSpot: _wrongSpot,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
}

class _CleanRowPainter extends CustomPainter {
  const _CleanRowPainter({
    required this.accent,
    required this.shimmer,
    required this.feedback,
    required this.success,
    required this.stage,
    required this.cleaned,
    required this.pointer,
    required this.wrongSpot,
  });

  final Color accent;
  final double shimmer;
  final double feedback;
  final double success;
  final int stage;
  final List<double> cleaned;
  final Offset? pointer;
  final bool wrongSpot;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin =
        Offset((size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF163451), Color(0xFF3A797E)],
        ).createShader(Offset.zero & size),
    );
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.scale(scale);

    final panel = RRect.fromRectAndRadius(
      const Rect.fromLTWH(30, 32, 300, 165),
      const Radius.circular(30),
    );
    canvas.drawShadow(Path()..addRRect(panel), Colors.black, 12, false);
    canvas.drawRRect(
      panel,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8FAF4), Color(0xFF91D5D4)],
        ).createShader(panel.outerRect),
    );

    for (var i = 0; i < 3; i++) {
      final center = _CleanRowGameViewState._centers[i];
      final active = i == stage;
      final alpha = 1 - cleaned[i];
      canvas.drawCircle(
        center,
        45,
        Paint()
          ..color = active
              ? accent.withValues(
                  alpha: .12 + .08 * math.sin(shimmer * math.pi * 2))
              : Colors.white.withValues(alpha: .07)
          ..style = PaintingStyle.fill,
      );
      if (active) {
        canvas.drawCircle(
          center,
          47 + math.sin(shimmer * math.pi * 2) * 3,
          Paint()
            ..color = accent.withValues(alpha: .75)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
      if (alpha > 0) _drawDirt(canvas, i, center, alpha);
      if (cleaned[i] > 0) _drawSparkles(canvas, center, cleaned[i]);
    }

    if (pointer != null && stage < 3) {
      final p = pointer!;
      final shake = wrongSpot ? math.sin(feedback * math.pi * 8) * 5 : 0.0;
      canvas.save();
      canvas.translate(p.dx + shake, p.dy);
      canvas.rotate(-.35);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-25, -13, 50, 26),
          const Radius.circular(10),
        ),
        Paint()..color = const Color(0xFFFFD76B),
      );
      canvas.drawRect(const Rect.fromLTWH(-21, 6, 42, 10),
          Paint()..color = Colors.white.withValues(alpha: .85));
      canvas.restore();
    }

    for (var i = 0; i < 3; i++) {
      final c = Offset(151 + i * 29, 218);
      canvas.drawCircle(
          c,
          7,
          Paint()
            ..color = i < stage ? const Color(0xFF67F0B9) : Colors.white24);
      if (i == stage) {
        canvas.drawArc(
          Rect.fromCircle(center: c, radius: 10),
          -math.pi / 2,
          math.pi * 2 * cleaned[i],
          false,
          Paint()
            ..color = accent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    if (success > 0) {
      const center = Offset(180, 115);
      for (var i = 0; i < 22; i++) {
        final a = i * math.pi * 2 / 22;
        final p =
            center + Offset(math.cos(a), math.sin(a)) * (25 + success * 125);
        canvas.drawCircle(
          p,
          4 * (1 - success),
          Paint()..color = i.isEven ? accent : const Color(0xFFFFD76B),
        );
      }
    }
    canvas.restore();
  }

  void _drawDirt(Canvas canvas, int type, Offset c, double alpha) {
    final paint = Paint()
      ..color = const Color(0xFF614537).withValues(alpha: alpha);
    if (type == 0) {
      for (var i = 0; i < 9; i++) {
        canvas.drawCircle(
          c + Offset((i % 3 - 1) * 15.0, (i ~/ 3 - 1) * 13.0),
          7 + (i % 2) * 3,
          paint,
        );
      }
    } else if (type == 1) {
      final sticky = Path()
        ..moveTo(c.dx - 30, c.dy - 14)
        ..quadraticBezierTo(c.dx, c.dy - 35, c.dx + 30, c.dy - 8)
        ..quadraticBezierTo(c.dx + 20, c.dy + 30, c.dx - 24, c.dy + 22)
        ..close();
      canvas.drawPath(sticky,
          paint..color = const Color(0xFFFF8D6E).withValues(alpha: alpha));
      canvas.drawCircle(c.translate(8, -5), 8,
          Paint()..color = const Color(0xFFFFC75C).withValues(alpha: alpha));
    } else {
      for (var i = 0; i < 7; i++) {
        final a = i * math.pi * 2 / 7;
        canvas.drawOval(
          Rect.fromCenter(
            center: c + Offset(math.cos(a), math.sin(a)) * 22,
            width: 13,
            height: 25,
          ),
          Paint()..color = const Color(0xFF8B70B5).withValues(alpha: alpha),
        );
      }
    }
  }

  void _drawSparkles(Canvas canvas, Offset c, double progress) {
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi * 2 / 6 + shimmer * math.pi * 2;
      canvas.drawCircle(
        c + Offset(math.cos(a), math.sin(a)) * (30 + progress * 12),
        2.5 * progress,
        Paint()..color = Colors.white.withValues(alpha: progress * .9),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CleanRowPainter old) =>
      old.shimmer != shimmer ||
      old.feedback != feedback ||
      old.success != success ||
      old.stage != stage ||
      old.pointer != pointer ||
      old.wrongSpot != wrongSpot ||
      old.cleaned.toString() != cleaned.toString() ||
      old.accent != accent;
}
