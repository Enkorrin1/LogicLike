import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeGridGameView extends StatefulWidget {
  const CodeGridGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
    this.routeGestureKey,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;
  final Key? routeGestureKey;

  @override
  State<CodeGridGameView> createState() => _CodeGridGameViewState();
}

class _CodeGridGameViewState extends State<CodeGridGameView> {
  static const _route = <math.Point<int>>[
    math.Point(0, 4),
    math.Point(1, 4),
    math.Point(1, 3),
    math.Point(2, 3),
    math.Point(2, 2),
    math.Point(3, 2),
    math.Point(3, 1),
  ];

  int _routeIndex = 0;
  bool _dragging = false;
  bool _solved = false;
  bool _answerSent = false;
  bool _error = false;

  _GridLayout _layout(Size size) => _GridLayout(size);

  void _start(Offset point, _GridLayout layout) {
    if (_solved) return;
    final cell = layout.cellAt(point);
    if (cell != _route.first) {
      _fail();
      return;
    }
    setState(() {
      _dragging = true;
      _routeIndex = 0;
      _error = false;
    });
    HapticFeedback.selectionClick();
  }

  void _move(Offset point, _GridLayout layout) {
    if (!_dragging || _solved) return;
    final cell = layout.cellAt(point);
    if (cell == null || cell == _route[_routeIndex]) return;
    if (_routeIndex > 0 && cell == _route[_routeIndex - 1]) {
      setState(() => _routeIndex--);
      return;
    }
    if (_routeIndex + 1 < _route.length && cell == _route[_routeIndex + 1]) {
      setState(() => _routeIndex++);
      HapticFeedback.selectionClick();
      if (_routeIndex == _route.length - 1) _complete();
      return;
    }
    final current = _route[_routeIndex];
    if ((cell.x - current.x).abs() + (cell.y - current.y).abs() <= 1) {
      _fail();
    }
  }

  void _end() {
    if (_dragging && !_solved) _fail();
  }

  void _fail() {
    setState(() {
      _dragging = false;
      _routeIndex = 0;
      _error = true;
    });
    HapticFeedback.lightImpact();
    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (mounted && !_solved) setState(() => _error = false);
    });
  }

  void _complete() {
    setState(() {
      _dragging = false;
      _solved = true;
    });
    HapticFeedback.mediumImpact();
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
      container: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _layout(constraints.biggest);
                return GestureDetector(
                  key: widget.routeGestureKey,
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) =>
                      _start(details.localPosition, layout),
                  onPanUpdate: (details) =>
                      _move(details.localPosition, layout),
                  onPanEnd: (_) => _end(),
                  onPanCancel: _end,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _error ? 1 : 0),
                    duration: const Duration(milliseconds: 120),
                    builder: (context, shake, child) => Transform.translate(
                      offset: Offset(math.sin(shake * math.pi * 4) * 5, 0),
                      child: child,
                    ),
                    child: CustomPaint(
                      painter: _CodeGridPainter(
                        layout: layout,
                        accent: widget.accent,
                        route: _route,
                        routeIndex: _routeIndex,
                        solved: _solved,
                        error: _error,
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

class _GridLayout {
  _GridLayout(this.size) {
    cellSize = math.min((size.width - 68) / 6, (size.height - 24) / 5);
    board = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 + 2),
      width: cellSize * 6,
      height: cellSize * 5,
    );
  }

  final Size size;
  late final double cellSize;
  late final Rect board;

  Offset center(math.Point<int> cell) => Offset(
        board.left + (cell.x + .5) * cellSize,
        board.top + (cell.y + .5) * cellSize,
      );

  math.Point<int>? cellAt(Offset point) {
    if (!board.inflate(8).contains(point)) return null;
    final column = ((point.dx - board.left) / cellSize).floor().clamp(0, 5);
    final row = ((point.dy - board.top) / cellSize).floor().clamp(0, 4);
    return math.Point(column, row);
  }
}

class _CodeGridPainter extends CustomPainter {
  const _CodeGridPainter({
    required this.layout,
    required this.accent,
    required this.route,
    required this.routeIndex,
    required this.solved,
    required this.error,
  });

  final _GridLayout layout;
  final Color accent;
  final List<math.Point<int>> route;
  final int routeIndex;
  final bool solved;
  final bool error;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17274C), Color(0xFF08707A)],
        ).createShader(bounds),
    );
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: .12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (var row = 0; row < 5; row++) {
      for (var column = 0; column < 6; column++) {
        final rect = Rect.fromLTWH(
          layout.board.left + column * layout.cellSize + 3,
          layout.board.top + row * layout.cellSize + 3,
          layout.cellSize - 6,
          layout.cellSize - 6,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(8)),
          gridPaint,
        );
      }
    }
    final guide = Path()
      ..moveTo(layout.center(route.first).dx, layout.center(route.first).dy);
    for (final cell in route.skip(1)) {
      final point = layout.center(cell);
      guide.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      guide,
      Paint()
        ..color = Colors.white.withValues(alpha: .13)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(2.0, layout.cellSize * .07)
        ..strokeCap = StrokeCap.round,
    );
    final active = Path();
    for (var index = 0; index <= routeIndex; index++) {
      final point = layout.center(route[index]);
      index == 0
          ? active.moveTo(point.dx, point.dy)
          : active.lineTo(point.dx, point.dy);
    }
    final beam = error
        ? const Color(0xFFFF6E75)
        : (solved ? const Color(0xFF6AE4A5) : const Color(0xFFFFCE55));
    canvas.drawPath(
      active,
      Paint()
        ..color = beam
        ..style = PaintingStyle.stroke
        ..strokeWidth = layout.cellSize * .12
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    for (var index = 0; index <= routeIndex; index++) {
      canvas.drawCircle(layout.center(route[index]), layout.cellSize * .11,
          Paint()..color = beam);
      canvas.drawCircle(layout.center(route[index]), layout.cellSize * .04,
          Paint()..color = Colors.white);
    }
    canvas.drawCircle(layout.center(route.first), layout.cellSize * .20,
        Paint()..color = accent);
    canvas.drawCircle(layout.center(route.last), layout.cellSize * .18,
        Paint()..color = solved ? const Color(0xFF6AE4A5) : Colors.white);
  }

  @override
  bool shouldRepaint(covariant _CodeGridPainter oldDelegate) =>
      oldDelegate.routeIndex != routeIndex ||
      oldDelegate.solved != solved ||
      oldDelegate.error != error ||
      oldDelegate.accent != accent;
}
