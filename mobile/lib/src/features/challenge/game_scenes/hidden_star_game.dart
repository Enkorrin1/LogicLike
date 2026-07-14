import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HiddenStarGameView extends StatefulWidget {
  const HiddenStarGameView({
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
  State<HiddenStarGameView> createState() => _HiddenStarGameViewState();
}

class _HiddenStarGameViewState extends State<HiddenStarGameView>
    with TickerProviderStateMixin {
  late final AnimationController _ambient;
  late final AnimationController _feedback;
  Offset _lens = const Offset(92, 126);
  Offset _dragAnchor = Offset.zero;
  final Set<int> _found = {};
  bool _dragging = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();
    _feedback = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
  }

  @override
  void dispose() {
    _ambient.dispose();
    _feedback.dispose();
    super.dispose();
  }

  Offset _toBoard(Offset local, Size size) {
    final scale = math.min(
      size.width / _board.width,
      size.height / _board.height,
    );
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    return (local - origin) / scale;
  }

  void _panStart(DragStartDetails details, Size size) {
    final point = _toBoard(details.localPosition, size);
    if ((point - _lens).distance > _lensRadius + 22 || _answerSent) return;
    _dragAnchor = point - _lens;
    setState(() => _dragging = true);
  }

  void _panUpdate(DragUpdateDetails details, Size size) {
    if (!_dragging) return;
    final point = _toBoard(details.localPosition, size) - _dragAnchor;
    setState(() {
      _lens = Offset(
        point.dx.clamp(_lensRadius, _board.width - _lensRadius),
        point.dy.clamp(_lensRadius, _board.height - _lensRadius),
      );
    });
  }

  void _tap(TapUpDetails details, Size size) {
    if (_answerSent) return;
    final point = _toBoard(details.localPosition, size);
    final index = List.generate(_stars.length, (i) => i).firstWhere(
      (i) =>
          !_found.contains(i) &&
          (_lens - _stars[i]).distance <= _lensRadius - 7 &&
          (point - _stars[i]).distance <= 25,
      orElse: () => -1,
    );
    if (index < 0) {
      HapticFeedback.selectionClick();
      _feedback.forward(from: 0);
      return;
    }
    setState(() {
      _found.add(index);
      _lens = _stars[index];
    });
    HapticFeedback.mediumImpact();
    _feedback.forward(from: 0);
    if (_found.length != _stars.length || _answerSent) return;
    _answerSent = true;
    Future<void>.delayed(const Duration(milliseconds: 720), () {
      if (mounted) widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: widget.semanticLabel,
        value: 'found:${_found.length}',
        button: true,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              width: double.infinity,
              height: widget.compact ? 216 : 252,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest;
                  return GestureDetector(
                    key: const ValueKey('hidden-star-surface'),
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) => _panStart(details, size),
                    onPanUpdate: (details) => _panUpdate(details, size),
                    onPanEnd: (_) => setState(() => _dragging = false),
                    onPanCancel: () => setState(() => _dragging = false),
                    onTapUp: (details) => _tap(details, size),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_ambient, _feedback]),
                      builder: (context, _) => Stack(
                        children: [
                          CustomPaint(
                            size: size,
                            painter: _HiddenStarPainter(
                              accent: widget.accent,
                              ambient: _ambient.value,
                              feedback: _feedback.value,
                              lens: _lens,
                              found: _found,
                            ),
                          ),
                          for (var index = 0; index < _stars.length; index++)
                            Positioned.fromRect(
                              rect: _targetRect(size, _stars[index], 24),
                              child: IgnorePointer(
                                child: SizedBox(
                                  key: ValueKey('hidden-star-target-$index'),
                                ),
                              ),
                            ),
                        ],
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

const _board = Size(360, 240);
const _stars = [Offset(279, 117), Offset(168, 76), Offset(84, 198)];
const _lensRadius = 43.0;

Rect _targetRect(Size size, Offset point, double radius) {
  final scale = math.min(
    size.width / _board.width,
    size.height / _board.height,
  );
  final origin = Offset(
    (size.width - _board.width * scale) / 2,
    (size.height - _board.height * scale) / 2,
  );
  return Rect.fromCircle(
    center: origin + point * scale,
    radius: radius * scale,
  );
}

class _HiddenStarPainter extends CustomPainter {
  const _HiddenStarPainter({
    required this.accent,
    required this.ambient,
    required this.feedback,
    required this.lens,
    required this.found,
  });

  final Color accent;
  final double ambient;
  final double feedback;
  final Offset lens;
  final Set<int> found;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(
      size.width / _board.width,
      size.height / _board.height,
    );
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF10243D), Color(0xFF21506A)],
        ).createShader(bounds),
    );
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    for (var i = 0; i < 38; i++) {
      final p = Offset((19 + i * 83) % 352.0, (11 + i * 47) % 232.0);
      canvas.drawCircle(
        p,
        i.isEven ? 1.2 : .7,
        Paint()
          ..color = Colors.white.withValues(
            alpha: .22 + .3 * math.sin(ambient * math.pi * 2 + i).abs(),
          ),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(24, 30, 312, 188),
        const Radius.circular(24),
      ),
      Paint()..color = const Color(0xFF284962).withValues(alpha: .72),
    );
    for (var i = 0; i < _stars.length; i++) {
      final visible = found.contains(i) || (lens - _stars[i]).distance < 38;
      if (!visible) continue;
      _star(canvas, _stars[i], found.contains(i) ? 13 : 9);
    }
    canvas.drawCircle(
      lens,
      _lensRadius,
      Paint()..color = const Color(0xFFBCEBF0).withValues(alpha: .12),
    );
    canvas.drawCircle(
      lens,
      _lensRadius + 2 + math.sin(feedback * math.pi) * 3,
      Paint()
        ..color = found.length == _stars.length ? Colors.amber : accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
    canvas.drawLine(
      lens + const Offset(29, 29),
      lens + const Offset(50, 50),
      Paint()
        ..color = const Color(0xFFE69A8A)
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  void _star(Canvas canvas, Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final r = i.isEven ? radius : radius * .43;
      final p = center + Offset(math.cos(angle), math.sin(angle)) * r;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD45C));
  }

  @override
  bool shouldRepaint(covariant _HiddenStarPainter oldDelegate) =>
      oldDelegate.ambient != ambient ||
      oldDelegate.feedback != feedback ||
      oldDelegate.lens != lens ||
      oldDelegate.found != found ||
      oldDelegate.accent != accent;
}
