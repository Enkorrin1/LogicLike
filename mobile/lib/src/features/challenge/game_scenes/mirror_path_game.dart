import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MirrorPathGameView extends StatefulWidget {
  const MirrorPathGameView({
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
  State<MirrorPathGameView> createState() => _MirrorPathGameViewState();
}

class _MirrorPathGameViewState extends State<MirrorPathGameView>
    with TickerProviderStateMixin {
  static const _source = [0, 1, 4, 7, 8];
  static const _target = [2, 1, 4, 7, 6];
  late final AnimationController _error;
  late final AnimationController _success;
  int _progress = -1;
  bool _dragging = false;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    _success.dispose();
    super.dispose();
  }

  List<Offset> _nodes(Rect rect) => [
        for (var row = 0; row < 3; row++)
          for (var col = 0; col < 3; col++)
            Offset(
              rect.left + rect.width * (0.17 + col * 0.33),
              rect.top + rect.height * (0.17 + row * 0.33),
            ),
      ];

  Rect _targetRect(Size size) => Rect.fromLTWH(
        size.width * 0.54,
        size.height * 0.13,
        size.width * 0.40,
        size.height * 0.72,
      );

  int _hitNode(Offset point, Size size) {
    final nodes = _nodes(_targetRect(size));
    return nodes.indexWhere((node) => (point - node).distance <= 24);
  }

  void _start(DragStartDetails details, Size size) {
    if (_solved) return;
    if (_hitNode(details.localPosition, size) == _target.first) {
      setState(() {
        _dragging = true;
        _progress = 0;
      });
    }
  }

  void _move(DragUpdateDetails details, Size size) {
    if (!_dragging || _solved) return;
    final hit = _hitNode(details.localPosition, size);
    if (hit < 0 || hit == _target[_progress]) return;
    final next = _progress + 1;
    if (next < _target.length && hit == _target[next]) {
      setState(() => _progress = next);
      HapticFeedback.selectionClick();
      if (next == _target.length - 1) _complete();
      return;
    }
    _fail();
  }

  void _end(DragEndDetails details) {
    if (_solved) return;
    if (_dragging && _progress != _target.length - 1) _fail();
  }

  void _fail() {
    HapticFeedback.lightImpact();
    setState(() {
      _dragging = false;
      _progress = -1;
    });
    _error.forward(from: 0);
  }

  void _complete() {
    setState(() {
      _dragging = false;
      _solved = true;
    });
    HapticFeedback.mediumImpact();
    _success.forward(from: 0).whenComplete(() {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) => _start(details, size),
                  onPanUpdate: (details) => _move(details, size),
                  onPanEnd: _end,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_error, _success]),
                    builder: (context, child) => CustomPaint(
                      painter: _MirrorPathPainter(
                        accent: widget.accent,
                        source: _source,
                        target: _target,
                        progress: _progress,
                        error: _error.value,
                        success: _success.value,
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

class _MirrorPathPainter extends CustomPainter {
  const _MirrorPathPainter({
    required this.accent,
    required this.source,
    required this.target,
    required this.progress,
    required this.error,
    required this.success,
  });

  final Color accent;
  final List<int> source;
  final List<int> target;
  final int progress;
  final double error;
  final double success;

  List<Offset> _nodes(Rect rect) => [
        for (var row = 0; row < 3; row++)
          for (var col = 0; col < 3; col++)
            Offset(
              rect.left + rect.width * (0.17 + col * 0.33),
              rect.top + rect.height * (0.17 + row * 0.33),
            ),
      ];

  void _drawBoard(
    Canvas canvas,
    Rect rect,
    List<int> route, {
    required int visibleSegments,
    required Color color,
  }) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)),
      Paint()..color = Colors.white.withValues(alpha: 0.09),
    );
    final nodes = _nodes(rect);
    for (var i = 0; i < route.length - 1; i++) {
      if (i >= visibleSegments) break;
      canvas.drawLine(
        nodes[route[i]],
        nodes[route[i + 1]],
        Paint()
          ..color = color
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round,
      );
    }
    for (var i = 0; i < nodes.length; i++) {
      final active = route.take(visibleSegments + 1).contains(i);
      canvas.drawCircle(
        nodes[i],
        active ? 9 : 7,
        Paint()..color = active ? color : Colors.white.withValues(alpha: 0.55),
      );
      canvas.drawCircle(
        nodes[i],
        active ? 3.5 : 2.5,
        Paint()..color = active ? Colors.white : const Color(0xFF35516F),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF172347), Color(0xFF365B78)],
        ).createShader(bounds),
    );
    final shake = math.sin(error * math.pi * 7) * (1 - error) * 5;
    final left = Rect.fromLTWH(
      size.width * 0.06,
      size.height * 0.13,
      size.width * 0.40,
      size.height * 0.72,
    );
    final right = Rect.fromLTWH(
      size.width * 0.54 + shake,
      size.height * 0.13,
      size.width * 0.40,
      size.height * 0.72,
    );
    _drawBoard(canvas, left, source,
        visibleSegments: source.length - 1, color: const Color(0xFFFFD45D));
    _drawBoard(canvas, right, target,
        visibleSegments: math.max(0, progress),
        color: success > 0 ? const Color(0xFF6CE0A8) : accent);

    final mirrorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.42)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.10),
      Offset(size.width / 2, size.height * 0.90),
      mirrorPaint,
    );
    for (var y = size.height * 0.16; y < size.height * 0.88; y += 16) {
      canvas.drawCircle(Offset(size.width / 2, y), 2,
          Paint()..color = Colors.white.withValues(alpha: 0.6));
    }
    if (success > 0) {
      final fade = 1 - success;
      for (var i = 0; i < 12; i++) {
        final angle = i * math.pi * 2 / 12;
        final p = right.center +
            Offset(math.cos(angle), math.sin(angle)) *
                (right.width * 0.32 + success * 45);
        canvas.drawCircle(
          p,
          3,
          Paint()
            ..color = (i.isEven ? accent : const Color(0xFFFFD45D))
                .withValues(alpha: fade),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MirrorPathPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.error != error ||
      oldDelegate.success != success ||
      oldDelegate.accent != accent;
}
