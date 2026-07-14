import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShapeTangramGameView extends StatefulWidget {
  const ShapeTangramGameView({
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
  State<ShapeTangramGameView> createState() => _ShapeTangramGameViewState();
}

class _ShapeTangramGameViewState extends State<ShapeTangramGameView>
    with TickerProviderStateMixin {
  late final List<_TangramPiece> _pieces;
  late final AnimationController _returnController;
  late final AnimationController _successController;
  int? _activePiece;
  int? _returningPiece;
  Offset _returnFrom = Offset.zero;
  Offset _returnTo = Offset.zero;
  Offset _dragStart = Offset.zero;
  double _dragDistance = 0;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _pieces = _pieceBlueprints
        .map(
          (piece) => _TangramPiece(
            id: piece.id,
            shape: piece.shape,
            color: piece.color,
            home: piece.home,
            target: piece.target,
            position: piece.home,
            angle: piece.initialAngle,
            targetAngle: 0,
          ),
        )
        .toList();
    _returnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..addListener(_animateReturn);
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _returnController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _animateReturn() {
    final index = _returningPiece;
    if (index == null) return;
    final t = Curves.easeOutBack.transform(_returnController.value);
    setState(() {
      _pieces[index].position = Offset.lerp(_returnFrom, _returnTo, t)!;
    });
  }

  Offset _toBoard(Offset local, Size size) {
    final scale = math.min(
        size.width / _boardSize.width, size.height / _boardSize.height);
    final origin = Offset(
      (size.width - _boardSize.width * scale) / 2,
      (size.height - _boardSize.height * scale) / 2,
    );
    return (local - origin) / scale;
  }

  void _onPanStart(DragStartDetails details, Size size) {
    if (_solved) return;
    final point = _toBoard(details.localPosition, size);
    for (var index = _pieces.length - 1; index >= 0; index--) {
      final piece = _pieces[index];
      if (!piece.placed && piece.contains(point)) {
        _returnController.stop();
        _returningPiece = null;
        setState(() => _activePiece = index);
        _dragStart = point;
        _dragDistance = 0;
        return;
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final index = _activePiece;
    if (index == null) return;
    final point = _toBoard(details.localPosition, size);
    final delta = point - _dragStart;
    _dragStart = point;
    _dragDistance += delta.distance;
    setState(() => _pieces[index].position += delta);
  }

  void _onPanEnd(DragEndDetails details) {
    final index = _activePiece;
    if (index == null) return;
    final piece = _pieces[index];
    setState(() => _activePiece = null);

    if (_dragDistance < 8) {
      setState(() => piece.angle = _nextQuarterTurn(piece.angle));
      return;
    }

    final closeEnough = (piece.position - piece.target).distance <= 34;
    final angleMatches = _angleDistance(piece.angle, piece.targetAngle) < 0.12;
    if (closeEnough && angleMatches) {
      setState(() {
        piece
          ..position = piece.target
          ..angle = piece.targetAngle
          ..placed = true;
      });
      if (_pieces.every((item) => item.placed)) _finishGame();
      return;
    }

    _returningPiece = index;
    _returnFrom = piece.position;
    _returnTo = piece.home;
    _returnController.forward(from: 0).whenComplete(() {
      if (!mounted || _returningPiece != index) return;
      setState(() => _returningPiece = null);
    });
  }

  void _finishGame() {
    _solved = true;
    _successController.forward(from: 0).whenComplete(() {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  double _nextQuarterTurn(double angle) {
    final next = angle + math.pi / 2;
    return next >= math.pi * 2 ? next - math.pi * 2 : next;
  }

  double _angleDistance(double a, double b) =>
      math.atan2(math.sin(a - b), math.cos(a - b)).abs();

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
                  onPanStart: (details) => _onPanStart(details, size),
                  onPanUpdate: (details) => _onPanUpdate(details, size),
                  onPanEnd: _onPanEnd,
                  child: AnimatedBuilder(
                    animation: _successController,
                    builder: (context, child) => CustomPaint(
                      painter: _ShapeTangramPainter(
                        accent: widget.accent,
                        pieces: _pieces,
                        activePiece: _activePiece,
                        success: Curves.easeOutBack
                            .transform(_successController.value),
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

const _boardSize = Size(360, 240);

enum _PieceShape { nose, body, leftFin, rightFin }

class _PieceBlueprint {
  const _PieceBlueprint({
    required this.id,
    required this.shape,
    required this.color,
    required this.home,
    required this.target,
    this.initialAngle = 0,
  });

  final int id;
  final _PieceShape shape;
  final Color color;
  final Offset home;
  final Offset target;
  final double initialAngle;
}

const _pieceBlueprints = [
  _PieceBlueprint(
    id: 0,
    shape: _PieceShape.nose,
    color: Color(0xFFFF6B6B),
    home: Offset(48, 196),
    target: Offset(180, 49),
  ),
  _PieceBlueprint(
    id: 1,
    shape: _PieceShape.body,
    color: Color(0xFF46B9E8),
    home: Offset(137, 196),
    target: Offset(180, 105),
  ),
  _PieceBlueprint(
    id: 2,
    shape: _PieceShape.leftFin,
    color: Color(0xFFFFC857),
    home: Offset(229, 196),
    target: Offset(142, 145),
    initialAngle: math.pi / 2,
  ),
  _PieceBlueprint(
    id: 3,
    shape: _PieceShape.rightFin,
    color: Color(0xFF62D2A2),
    home: Offset(316, 196),
    target: Offset(218, 145),
  ),
];

class _TangramPiece {
  _TangramPiece({
    required this.id,
    required this.shape,
    required this.color,
    required this.home,
    required this.target,
    required this.position,
    required this.angle,
    required this.targetAngle,
  });

  final int id;
  final _PieceShape shape;
  final Color color;
  final Offset home;
  final Offset target;
  Offset position;
  double angle;
  final double targetAngle;
  bool placed = false;

  bool contains(Offset point) {
    final delta = point - position;
    final cosine = math.cos(-angle);
    final sine = math.sin(-angle);
    final local = Offset(
      delta.dx * cosine - delta.dy * sine,
      delta.dx * sine + delta.dy * cosine,
    );
    return _piecePath(shape).contains(local);
  }
}

Path _piecePath(_PieceShape shape) {
  switch (shape) {
    case _PieceShape.nose:
      return Path()
        ..moveTo(0, -28)
        ..lineTo(34, 27)
        ..lineTo(-34, 27)
        ..close();
    case _PieceShape.body:
      return Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-32, -35, 64, 70),
            const Radius.circular(8),
          ),
        );
    case _PieceShape.leftFin:
      return Path()
        ..moveTo(27, -25)
        ..lineTo(27, 25)
        ..lineTo(-28, 25)
        ..close();
    case _PieceShape.rightFin:
      return Path()
        ..moveTo(-27, -25)
        ..lineTo(28, 25)
        ..lineTo(-27, 25)
        ..close();
  }
}

class _ShapeTangramPainter extends CustomPainter {
  const _ShapeTangramPainter({
    required this.accent,
    required this.pieces,
    required this.activePiece,
    required this.success,
  });

  final Color accent;
  final List<_TangramPiece> pieces;
  final int? activePiece;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(
        size.width / _boardSize.width, size.height / _boardSize.height);
    final origin = Offset(
      (size.width - _boardSize.width * scale) / 2,
      (size.height - _boardSize.height * scale) / 2,
    );
    canvas
      ..drawRect(
        Offset.zero & size,
        Paint()..color = const Color(0xFFF3F8FC),
      )
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);

    _paintBackground(canvas);
    _paintSilhouette(canvas);
    for (final piece in pieces.where((item) => item.placed)) {
      _paintPiece(canvas, piece, false);
    }
    for (final piece in pieces.where((item) => !item.placed)) {
      if (piece.id != activePiece) _paintPiece(canvas, piece, false);
    }
    if (activePiece != null) {
      _paintPiece(canvas, pieces[activePiece!], true);
    }
    if (success > 0) _paintSuccess(canvas);
    canvas.restore();
  }

  void _paintBackground(Canvas canvas) {
    final softAccent = Paint()..color = accent.withValues(alpha: 0.08);
    canvas.drawCircle(const Offset(180, 105), 94, softAccent);
    canvas.drawCircle(
      const Offset(30, 28),
      3,
      Paint()..color = const Color(0xFFFFC857).withValues(alpha: 0.8),
    );
    canvas.drawCircle(
      const Offset(330, 52),
      4,
      Paint()..color = const Color(0xFF46B9E8).withValues(alpha: 0.75),
    );
  }

  void _paintSilhouette(Canvas canvas) {
    final fill = Paint()
      ..color = const Color(0xFF243B53).withValues(alpha: 0.11);
    final outline = Paint()
      ..color = accent.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round;
    for (final piece in pieces.where((item) => !item.placed)) {
      canvas.save();
      canvas.translate(piece.target.dx, piece.target.dy);
      canvas.rotate(piece.targetAngle);
      final path = _piecePath(piece.shape);
      canvas
        ..drawPath(path, fill)
        ..drawPath(path, outline);
      canvas.restore();
    }
  }

  void _paintPiece(Canvas canvas, _TangramPiece piece, bool active) {
    canvas.save();
    canvas.translate(piece.position.dx, piece.position.dy);
    canvas.rotate(piece.angle);
    final path = _piecePath(piece.shape);
    canvas.drawShadow(path, Colors.black, active ? 9 : 4, false);
    canvas.drawPath(path, Paint()..color = piece.color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.82)
        ..style = PaintingStyle.stroke
        ..strokeWidth = active ? 3 : 2
        ..strokeJoin = StrokeJoin.round,
    );
    if (piece.shape == _PieceShape.body) {
      canvas.drawCircle(
        const Offset(0, -7),
        11,
        Paint()..color = const Color(0xFFFDFEFF).withValues(alpha: 0.9),
      );
      canvas.drawCircle(
        const Offset(0, -7),
        7,
        Paint()..color = accent.withValues(alpha: 0.45),
      );
    }
    canvas.restore();
  }

  void _paintSuccess(Canvas canvas) {
    final pulse = 1 + success * 0.08;
    canvas.save();
    canvas.translate(180, 105);
    canvas.scale(pulse);
    canvas.translate(-180, -105 - success * 9);
    final glow = Paint()
      ..color = const Color(0xFFFFC857).withValues(alpha: 0.32 * (1 - success))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(const Offset(180, 105), 76 + success * 22, glow);
    canvas.restore();

    final sparklePaint = Paint()..color = const Color(0xFFFFC857);
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final radius = 60 + 42 * success;
      final center = Offset(
        180 + math.cos(angle) * radius,
        105 + math.sin(angle) * radius,
      );
      canvas.drawCircle(center, 3.5 * (1 - success * 0.55), sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeTangramPainter oldDelegate) => true;
}
