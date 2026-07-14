import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SoundOrderGameView extends StatefulWidget {
  const SoundOrderGameView({
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
  State<SoundOrderGameView> createState() => _SoundOrderGameViewState();
}

enum _SoundOrderPhase { showing, input, retrying, solved }

class _SoundOrderGameViewState extends State<SoundOrderGameView>
    with TickerProviderStateMixin {
  static const _sequence = [0, 2, 3];

  late final AnimationController _ambientController;
  late final AnimationController _pulseController;
  late final AnimationController _shakeController;
  late final AnimationController _successController;
  _SoundOrderPhase _phase = _SoundOrderPhase.showing;
  int? _litIndex;
  int? _pressedIndex;
  int _inputIndex = 0;
  int _showRun = 0;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 330),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSequence());
  }

  @override
  void dispose() {
    _showRun++;
    _ambientController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _showSequence() async {
    final run = ++_showRun;
    setState(() {
      _phase = _SoundOrderPhase.showing;
      _inputIndex = 0;
      _pressedIndex = null;
      _litIndex = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 450));
    for (final index in _sequence) {
      if (!mounted || run != _showRun) return;
      setState(() => _litIndex = index);
      _pulseController.forward(from: 0);
      HapticFeedback.selectionClick();
      await Future<void>.delayed(const Duration(milliseconds: 510));
      if (!mounted || run != _showRun) return;
      setState(() => _litIndex = null);
      await Future<void>.delayed(const Duration(milliseconds: 190));
    }
    if (!mounted || run != _showRun) return;
    setState(() => _phase = _SoundOrderPhase.input);
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (_phase != _SoundOrderPhase.input || size.isEmpty) return;
    final pads = _SoundOrderLayout.padRects(size);
    final index = pads.indexWhere(
      (rect) => rect.inflate(5).contains(details.localPosition),
    );
    if (index < 0) return;

    setState(() {
      _pressedIndex = index;
      _litIndex = index;
    });
    _pulseController.forward(from: 0).whenComplete(() {
      if (mounted && _phase == _SoundOrderPhase.input) {
        setState(() {
          _pressedIndex = null;
          _litIndex = null;
        });
      }
    });

    if (index != _sequence[_inputIndex]) {
      HapticFeedback.mediumImpact();
      setState(() => _phase = _SoundOrderPhase.retrying);
      _shakeController.forward(from: 0).whenComplete(() {
        if (mounted && _phase == _SoundOrderPhase.retrying) _showSequence();
      });
      return;
    }

    HapticFeedback.lightImpact();
    _inputIndex++;
    if (_inputIndex == _sequence.length) _complete();
  }

  void _complete() {
    setState(() {
      _phase = _SoundOrderPhase.solved;
      _litIndex = null;
      _pressedIndex = null;
    });
    HapticFeedback.heavyImpact();
    _successController.forward(from: 0);
    Future<void>.delayed(const Duration(milliseconds: 720), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 218 : 252,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _ambientController,
                      _pulseController,
                      _shakeController,
                      _successController,
                    ]),
                    builder: (context, child) => CustomPaint(
                      size: size,
                      painter: _SoundOrderPainter(
                        accent: widget.accent,
                        ambient: _ambientController.value,
                        pulse: _pulseController.value,
                        shake: _shakeController.value,
                        success: _successController.value,
                        phase: _phase,
                        litIndex: _litIndex,
                        pressedIndex: _pressedIndex,
                        progress: _inputIndex,
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

class _SoundOrderLayout {
  static List<Rect> padRects(Size size) {
    final gap = math.max(10.0, size.width * 0.025);
    final side = math.min(
      (size.width - gap * 3) / 4,
      size.height * 0.55,
    );
    final left = (size.width - side * 4 - gap * 3) / 2;
    final top = size.height * 0.30;
    return List.generate(
      4,
      (index) => Rect.fromLTWH(left + index * (side + gap), top, side, side),
    );
  }
}

class _SoundOrderPainter extends CustomPainter {
  const _SoundOrderPainter({
    required this.accent,
    required this.ambient,
    required this.pulse,
    required this.shake,
    required this.success,
    required this.phase,
    required this.litIndex,
    required this.pressedIndex,
    required this.progress,
  });

  final Color accent;
  final double ambient;
  final double pulse;
  final double shake;
  final double success;
  final _SoundOrderPhase phase;
  final int? litIndex;
  final int? pressedIndex;
  final int progress;

  static const _colors = [
    Color(0xFFFF5E62),
    Color(0xFFFFC84A),
    Color(0xFF45D6A4),
    Color(0xFF55A8FF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12243D), Color(0xFF26385B), Color(0xFF3E426B)],
        ).createShader(bounds),
    );
    _drawSpace(canvas, size);

    final wrongShake = phase == _SoundOrderPhase.retrying
        ? math.sin(shake * math.pi * 8) * (1 - shake) * 7
        : 0.0;
    canvas.save();
    canvas.translate(wrongShake, 0);
    final pads = _SoundOrderLayout.padRects(size);
    for (var i = 0; i < pads.length; i++) {
      _drawRobot(canvas, pads[i], i, litIndex == i, pressedIndex == i);
    }
    canvas.restore();
    _drawSequenceDots(canvas, size);
    if (phase == _SoundOrderPhase.solved) _drawSuccess(canvas, size);
  }

  void _drawSpace(Canvas canvas, Size size) {
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.55);
    for (var i = 0; i < 18; i++) {
      final x = size.width * ((i * 0.137 + 0.04) % 0.96);
      final y = size.height * ((i * 0.083 + 0.05) % 0.72);
      final twinkle = 0.7 + 0.6 * math.sin(ambient * math.pi * 2 + i);
      canvas.drawCircle(Offset(x, y), math.max(0.5, twinkle), starPaint);
    }
    final floor =
        Rect.fromLTWH(0, size.height * 0.79, size.width, size.height * 0.21);
    canvas.drawRect(floor, Paint()..color = const Color(0xFF18253A));
    final line = Paint()
      ..color = accent.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    for (var i = 0; i < 7; i++) {
      final y = floor.top + i * floor.height / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  void _drawRobot(Canvas canvas, Rect rect, int index, bool lit, bool pressed) {
    final color = _colors[index];
    final glowAmount = lit ? 1 - Curves.easeOut.transform(pulse) * 0.35 : 0.0;
    final scale = lit ? 1 + 0.08 * math.sin(pulse * math.pi) : 1.0;
    canvas.save();
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.scale(scale, scale);
    canvas.translate(-rect.center.dx, -rect.center.dy + (pressed ? 3 : 0));
    if (lit) {
      canvas.drawCircle(
        rect.center,
        rect.width * (0.66 + glowAmount * 0.12),
        Paint()
          ..color = color.withValues(alpha: 0.45)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, rect.width * 0.18),
      );
    }
    final body =
        RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.22));
    canvas.drawRRect(
      body.shift(Offset(0, rect.height * 0.06)),
      Paint()..color = Colors.black.withValues(alpha: 0.28),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, lit ? 0.48 : 0.20)!, color],
        ).createShader(rect),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..color = Colors.white.withValues(alpha: lit ? 0.92 : 0.38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = lit ? 3 : 1.4,
    );

    final face = Rect.fromLTWH(
      rect.left + rect.width * 0.18,
      rect.top + rect.height * 0.14,
      rect.width * 0.64,
      rect.height * 0.30,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(face, Radius.circular(rect.width * 0.10)),
      Paint()..color = const Color(0xFF142238),
    );
    final eyePaint = Paint()..color = lit ? Colors.white : color;
    canvas.drawCircle(Offset(face.left + face.width * 0.30, face.center.dy),
        rect.width * 0.045, eyePaint);
    canvas.drawCircle(Offset(face.right - face.width * 0.30, face.center.dy),
        rect.width * 0.045, eyePaint);

    final drumCenter = Offset(rect.center.dx, rect.top + rect.height * 0.70);
    canvas.drawCircle(drumCenter, rect.width * 0.22,
        Paint()..color = const Color(0xFFF2F5FA));
    canvas.drawCircle(
      drumCenter,
      rect.width * 0.17,
      Paint()
        ..color = lit ? Colors.white : color.withValues(alpha: 0.62)
        ..style = PaintingStyle.stroke
        ..strokeWidth = rect.width * 0.045,
    );
    final antenna = Paint()
      ..color = const Color(0xFFE6EDF7)
      ..strokeWidth = rect.width * 0.045
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(rect.center.dx, rect.top),
      Offset(rect.center.dx, rect.top - rect.height * 0.12),
      antenna,
    );
    canvas.drawCircle(
      Offset(rect.center.dx, rect.top - rect.height * 0.14),
      rect.width * 0.055,
      Paint()..color = color,
    );
    canvas.restore();
  }

  void _drawSequenceDots(Canvas canvas, Size size) {
    const count = 3;
    final radius = math.min(5.0, size.height * 0.022);
    final gap = radius * 3.2;
    final start = size.width / 2 - gap;
    for (var i = 0; i < count; i++) {
      final completed = phase == _SoundOrderPhase.solved || i < progress;
      canvas.drawCircle(
        Offset(start + i * gap, size.height * 0.15),
        completed ? radius * 1.18 : radius,
        Paint()
          ..color = completed ? accent : Colors.white.withValues(alpha: 0.30),
      );
    }
  }

  void _drawSuccess(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.53);
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    for (var i = 0; i < 20; i++) {
      final angle = i * math.pi * 2 / 20;
      final distance = size.height * (0.22 + success * 0.30);
      paint.color = _colors[i % _colors.length].withValues(alpha: 1 - success);
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawCircle(point, 2.5 + (i % 3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SoundOrderPainter oldDelegate) =>
      oldDelegate.ambient != ambient ||
      oldDelegate.pulse != pulse ||
      oldDelegate.shake != shake ||
      oldDelegate.success != success ||
      oldDelegate.phase != phase ||
      oldDelegate.litIndex != litIndex ||
      oldDelegate.pressedIndex != pressedIndex ||
      oldDelegate.progress != progress ||
      oldDelegate.accent != accent;
}
