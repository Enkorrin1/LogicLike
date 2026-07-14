import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RouteMemoryGameView extends StatefulWidget {
  const RouteMemoryGameView({
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
  State<RouteMemoryGameView> createState() => _RouteMemoryGameViewState();
}

enum _RoutePhase { showing, tracing, retrying, solved }

class _RouteMemoryGameViewState extends State<RouteMemoryGameView>
    with TickerProviderStateMixin {
  static const _route = [12, 8, 9, 5, 6];

  late final AnimationController _ambient;
  late final AnimationController _feedback;
  late final AnimationController _success;
  _RoutePhase _phase = _RoutePhase.showing;
  final List<int> _trace = [];
  int _showRun = 0;
  bool _dragging = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _feedback = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRoute());
  }

  @override
  void dispose() {
    _showRun++;
    _ambient.dispose();
    _feedback.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _showRoute({bool retry = false}) async {
    final run = ++_showRun;
    setState(() {
      _phase = retry ? _RoutePhase.retrying : _RoutePhase.showing;
      _dragging = false;
      _trace.clear();
    });
    await Future<void>.delayed(
      Duration(milliseconds: retry ? 850 : 1400),
    );
    if (!mounted || run != _showRun) return;
    setState(() => _phase = _RoutePhase.tracing);
  }

  int _cellAt(Offset point, Size size) {
    final board = _RouteLayout.board(size);
    if (!board.contains(point)) return -1;
    final column = ((point.dx - board.left) / (board.width / 4)).floor();
    final row = ((point.dy - board.top) / (board.height / 4)).floor();
    return row * 4 + column;
  }

  void _start(DragStartDetails details, Size size) {
    if (_phase != _RoutePhase.tracing) return;
    _dragging = true;
    final cell = _cellAt(details.localPosition, size);
    if (cell != _route.first) {
      _retry();
      return;
    }
    setState(() => _trace.add(cell));
    HapticFeedback.selectionClick();
  }

  void _move(DragUpdateDetails details, Size size) {
    if (!_dragging || _phase != _RoutePhase.tracing || _trace.isEmpty) return;
    final cell = _cellAt(details.localPosition, size);
    if (cell < 0 || cell == _trace.last) return;
    final expectedIndex = _trace.length;
    if (expectedIndex >= _route.length || cell != _route[expectedIndex]) {
      _retry();
      return;
    }
    setState(() => _trace.add(cell));
    HapticFeedback.selectionClick();
    if (_trace.length == _route.length) _complete();
  }

  void _end(DragEndDetails details) {
    if (_phase == _RoutePhase.tracing && _dragging) _retry();
  }

  void _retry() {
    if (_phase != _RoutePhase.tracing) return;
    _dragging = false;
    HapticFeedback.lightImpact();
    setState(() => _phase = _RoutePhase.retrying);
    _feedback.forward(from: 0).whenComplete(() {
      if (mounted && _phase == _RoutePhase.retrying) {
        unawaited(_showRoute(retry: true));
      }
    });
  }

  void _complete() {
    _dragging = false;
    setState(() => _phase = _RoutePhase.solved);
    HapticFeedback.mediumImpact();
    _success.forward(from: 0).whenComplete(() {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  String _instruction(BuildContext context) {
    const instructions = <String, String>{
      'ar': 'احفظ المسار المضيء، ثم مرر إصبعك من البداية إلى النهاية.',
      'de':
          'Merke dir den leuchtenden Weg und ziehe ihn vom Start bis zum Ziel nach.',
      'en': 'Remember the glowing route, then trace it from start to finish.',
      'es':
          'Recuerda la ruta luminosa y trazala desde el inicio hasta el final.',
      'fr':
          'Memorise le chemin lumineux, puis retrace-le du depart a l arrivee.',
      'hi': 'चमकता रास्ता याद रखें, फिर शुरुआत से अंत तक उंगली चलाएं।',
      'it': 'Memorizza il percorso luminoso e traccialo dall inizio alla fine.',
      'ja': '光るルートを覚えて、スタートからゴールまでなぞってください。',
      'ko': '빛나는 경로를 기억한 뒤 시작점에서 도착점까지 따라 그리세요.',
      'pt': 'Memorize a rota brilhante e trace-a do inicio ao fim.',
      'ru': 'Запомни светящийся маршрут и проведи по нему от старта до финиша.',
      'zh': '记住发光路线，然后从起点滑到终点。',
    };
    return instructions[Localizations.localeOf(context).languageCode] ??
        instructions['en']!;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${widget.semanticLabel}. ${_instruction(context)}',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 252 : 292,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) => _start(details, size),
                  onPanUpdate: (details) => _move(details, size),
                  onPanEnd: _end,
                  onPanCancel: () {
                    if (_phase == _RoutePhase.tracing && _dragging) _retry();
                  },
                  child: AnimatedBuilder(
                    animation:
                        Listenable.merge([_ambient, _feedback, _success]),
                    builder: (context, child) => CustomPaint(
                      painter: _RouteMemoryPainter(
                        accent: widget.accent,
                        route: _route,
                        trace: List<int>.of(_trace),
                        phase: _phase,
                        ambient: _ambient.value,
                        feedback: _feedback.value,
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

class _RouteLayout {
  static Rect board(Size size) {
    final side = math.min(size.width * 0.78, size.height * 0.82);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: side,
      height: side,
    );
  }

  static Offset center(Rect board, int cell) => Offset(
        board.left + (cell % 4 + 0.5) * board.width / 4,
        board.top + (cell ~/ 4 + 0.5) * board.height / 4,
      );
}

class _RouteMemoryPainter extends CustomPainter {
  const _RouteMemoryPainter({
    required this.accent,
    required this.route,
    required this.trace,
    required this.phase,
    required this.ambient,
    required this.feedback,
    required this.success,
  });

  final Color accent;
  final List<int> route;
  final List<int> trace;
  final _RoutePhase phase;
  final double ambient;
  final double feedback;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF13223A), Color(0xFF244C59), Color(0xFF172C45)],
        ).createShader(bounds),
    );
    _drawStars(canvas, size);
    final shake = phase == _RoutePhase.retrying
        ? math.sin(feedback * math.pi * 5) * (1 - feedback) * 4
        : 0.0;
    canvas.save();
    canvas.translate(shake, 0);
    final board = _RouteLayout.board(size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(board, const Radius.circular(18)),
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );
    final gap = math.max(3.0, board.width * 0.018);
    final cellSide = board.width / 4;
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 4; col++) {
        final rect = Rect.fromLTWH(
          board.left + col * cellSide + gap,
          board.top + row * cellSide + gap,
          cellSide - gap * 2,
          cellSide - gap * 2,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(9)),
          Paint()..color = Colors.white.withValues(alpha: 0.075),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(9)),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.13)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }

    final showing =
        phase == _RoutePhase.showing || phase == _RoutePhase.retrying;
    final visible = showing ? route : trace;
    final pathColor = phase == _RoutePhase.solved
        ? const Color(0xFF67E6A4)
        : Color.lerp(accent, Colors.white, showing ? 0.22 : 0.05)!;
    if (visible.isNotEmpty) {
      final path = Path()
        ..moveTo(
          _RouteLayout.center(board, visible.first).dx,
          _RouteLayout.center(board, visible.first).dy,
        );
      for (final cell in visible.skip(1)) {
        final point = _RouteLayout.center(board, cell);
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = pathColor.withValues(alpha: 0.38)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cellSide * 0.28
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, cellSide * 0.16),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = pathColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = cellSide * 0.11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    _drawMarker(canvas, board, route.first, const Color(0xFFFFD35A), true);
    _drawMarker(canvas, board, route.last, const Color(0xFF67E6A4), false);
    if (phase == _RoutePhase.solved) _drawSuccess(canvas, board);
    canvas.restore();
  }

  void _drawStars(Canvas canvas, Size size) {
    for (var i = 0; i < 18; i++) {
      final pulse = 0.45 + 0.35 * math.sin(ambient * math.pi * 2 + i);
      canvas.drawCircle(
        Offset(size.width * ((i * 0.173 + 0.04) % 0.94),
            size.height * ((i * 0.263 + 0.06) % 0.88)),
        0.7 + (i % 3) * 0.35,
        Paint()..color = Colors.white.withValues(alpha: pulse),
      );
    }
  }

  void _drawMarker(
    Canvas canvas,
    Rect board,
    int cell,
    Color color,
    bool start,
  ) {
    final center = _RouteLayout.center(board, cell);
    final radius = board.width / 4 * 0.14;
    canvas.drawCircle(
      center,
      radius * 1.8,
      Paint()
        ..color = color.withValues(alpha: 0.22)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius),
    );
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(
      center,
      radius * (start ? 0.38 : 0.52),
      Paint()
        ..color = start ? Colors.white : const Color(0xFF173846)
        ..style = start ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  void _drawSuccess(Canvas canvas, Rect board) {
    final fade = (1 - success).clamp(0.0, 1.0);
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi * 2 / 16;
      final distance = board.width * (0.18 + success * 0.48);
      canvas.drawCircle(
        board.center + Offset(math.cos(angle), math.sin(angle)) * distance,
        (2.5 + i % 3) * fade,
        Paint()
          ..color = (i.isEven ? accent : const Color(0xFFFFD35A))
              .withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RouteMemoryPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.phase != phase ||
      oldDelegate.trace.length != trace.length ||
      oldDelegate.ambient != ambient ||
      oldDelegate.feedback != feedback ||
      oldDelegate.success != success;
}
