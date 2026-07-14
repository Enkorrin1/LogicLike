import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShapeTowerGameView extends StatefulWidget {
  const ShapeTowerGameView({
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
  State<ShapeTowerGameView> createState() => _ShapeTowerGameViewState();
}

enum _TowerPiece { wide, square, circle, roof }

class _ShapeTowerGameViewState extends State<ShapeTowerGameView>
    with TickerProviderStateMixin {
  static const _order = [
    _TowerPiece.wide,
    _TowerPiece.square,
    _TowerPiece.circle,
    _TowerPiece.roof,
  ];
  final Set<_TowerPiece> _placed = {};
  late final AnimationController _error;
  late final AnimationController _success;
  _TowerPiece? _wrong;
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
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    _success.dispose();
    super.dispose();
  }

  void _place(_TowerPiece piece) {
    if (_placed.contains(piece) || _answerSent) return;
    final expected = _order[_placed.length];
    if (piece != expected) {
      HapticFeedback.selectionClick();
      setState(() => _wrong = piece);
      _error.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _wrong = null);
      });
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _placed.add(piece));
    if (_placed.length == _order.length) {
      _success.forward(from: 0).whenComplete(() {
        if (!mounted || _answerSent) return;
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      });
    }
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
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final trayY = size.height * 0.82;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([_error, _success]),
                      builder: (context, child) => CustomPaint(
                        painter: _ShapeTowerPainter(
                          accent: widget.accent,
                          placed: _placed,
                          error: _error.value,
                          wrong: _wrong,
                          success: _success.value,
                        ),
                      ),
                    ),
                    Positioned(
                      left: size.width * 0.42,
                      top: size.height * 0.12,
                      width: size.width * 0.48,
                      height: size.height * 0.63,
                      child: DragTarget<_TowerPiece>(
                        onWillAcceptWithDetails: (_) => true,
                        onAcceptWithDetails: (details) => _place(details.data),
                        builder: (context, candidates, rejected) =>
                            const SizedBox.expand(),
                      ),
                    ),
                    for (var i = 0; i < _order.length; i++)
                      if (!_placed.contains(_order[i]))
                        Positioned(
                          left: size.width * (0.08 + i * 0.22) - 24,
                          top: trayY - 24,
                          width: 48,
                          height: 48,
                          child: Draggable<_TowerPiece>(
                            data: _order[i],
                            feedback: Material(
                              color: Colors.transparent,
                              child: _TowerPieceWidget(
                                piece: _order[i],
                                accent: widget.accent,
                                size: 54,
                              ),
                            ),
                            childWhenDragging: const SizedBox.shrink(),
                            child: GestureDetector(
                              onTap: () => _place(_order[i]),
                              child: _TowerPieceWidget(
                                piece: _order[i],
                                accent: widget.accent,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TowerPieceWidget extends StatelessWidget {
  const _TowerPieceWidget({
    required this.piece,
    required this.accent,
    required this.size,
  });

  final _TowerPiece piece;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _SingleTowerPiecePainter(piece, accent),
      );
}

class _SingleTowerPiecePainter extends CustomPainter {
  const _SingleTowerPiecePainter(this.piece, this.accent);
  final _TowerPiece piece;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    _ShapeTowerPainter.drawPiece(canvas, piece, accent, 0.72);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SingleTowerPiecePainter oldDelegate) =>
      oldDelegate.piece != piece || oldDelegate.accent != accent;
}

class _ShapeTowerPainter extends CustomPainter {
  const _ShapeTowerPainter({
    required this.accent,
    required this.placed,
    required this.error,
    required this.wrong,
    required this.success,
  });

  final Color accent;
  final Set<_TowerPiece> placed;
  final double error;
  final _TowerPiece? wrong;
  final double success;

  static void drawPiece(
      Canvas canvas, _TowerPiece piece, Color accent, double scale) {
    final colors = <_TowerPiece, Color>{
      _TowerPiece.wide: const Color(0xFF55CFC1),
      _TowerPiece.square: const Color(0xFF66A1F4),
      _TowerPiece.circle: const Color(0xFFFFD15C),
      _TowerPiece.roof: const Color(0xFFFF7184),
    };
    final color = colors[piece]!;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, color],
      ).createShader(const Rect.fromLTWH(-34, -24, 68, 48));
    Path path;
    switch (piece) {
      case _TowerPiece.wide:
        path = Path()
          ..addRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(-34, -15, 68, 30),
              const Radius.circular(10)));
      case _TowerPiece.square:
        path = Path()
          ..addRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(-23, -19, 46, 38), const Radius.circular(8)));
      case _TowerPiece.circle:
        path = Path()..addOval(const Rect.fromLTWH(-20, -20, 40, 40));
      case _TowerPiece.roof:
        path = Path()
          ..moveTo(0, -27)
          ..lineTo(29, 20)
          ..lineTo(-29, 20)
          ..close();
    }
    canvas.save();
    canvas.scale(scale);
    canvas.drawShadow(path, Colors.black, 6, false);
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF21385E), Color(0xFF69A6A1)],
        ).createShader(bounds),
    );
    for (var i = 0; i < 18; i++) {
      canvas.drawCircle(
        Offset(size.width * ((i * 0.173 + 0.05) % 0.95),
            size.height * ((i * 0.113 + 0.05) % 0.72)),
        i.isEven ? 1.5 : 1,
        Paint()..color = Colors.white.withValues(alpha: 0.36),
      );
    }
    final base = Offset(size.width * 0.66, size.height * 0.72);
    canvas.drawOval(
      Rect.fromCenter(center: base, width: size.width * 0.36, height: 20),
      Paint()..color = const Color(0xFF23394A).withValues(alpha: 0.6),
    );
    final yOffsets = [0.0, -35.0, -73.0, -113.0];
    for (var i = 0; i < _ShapeTowerGameViewState._order.length; i++) {
      final piece = _ShapeTowerGameViewState._order[i];
      final center = base + Offset(0, yOffsets[i]);
      if (!placed.contains(piece)) {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        final path = Path()
          ..addRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(-34, -20, 68, 40),
              const Radius.circular(10)));
        canvas.drawPath(
          path,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.12)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
        canvas.restore();
      } else {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        drawPiece(canvas, piece, accent, 0.9);
        canvas.restore();
      }
    }
    if (wrong != null) {
      final shake = math.sin(error * math.pi * 7) * (1 - error) * 7;
      canvas.save();
      canvas.translate(base.dx + shake, base.dy - 145);
      drawPiece(canvas, wrong!, accent, 0.7);
      canvas.restore();
    }
    if (success > 0) {
      final fade = 1 - success;
      for (var i = 0; i < 14; i++) {
        final angle = i * math.pi * 2 / 14;
        final p = base.translate(0, -70) +
            Offset(math.cos(angle), math.sin(angle)) * (55 + success * 70);
        canvas.drawCircle(
          p,
          3.5,
          Paint()
            ..color = (i.isEven ? accent : const Color(0xFFFFD15C))
                .withValues(alpha: fade),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeTowerPainter oldDelegate) =>
      oldDelegate.placed.length != placed.length ||
      oldDelegate.error != error ||
      oldDelegate.wrong != wrong ||
      oldDelegate.success != success ||
      oldDelegate.accent != accent;
}
