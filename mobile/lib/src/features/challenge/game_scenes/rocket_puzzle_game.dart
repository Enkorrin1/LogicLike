import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_theme.dart';

class RocketPuzzleGameView extends StatelessWidget {
  const RocketPuzzleGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: double.infinity,
          height: compact ? 214 : 242,
          child: GameWidget.controlled(
            gameFactory: () => RocketPuzzleGame(
              accent: accent,
              correctAnswer: correctAnswer,
              onAnswerSelected: onAnswerSelected,
            ),
          ),
        ),
      ).animate().fadeIn(duration: 220.ms).scale(
            begin: const Offset(0.985, 0.985),
            end: const Offset(1, 1),
            duration: 260.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}

class RocketPuzzleGame extends FlameGame with DragCallbacks {
  RocketPuzzleGame({
    required this.accent,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  final Color accent;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  String? _selectedPiece;
  String? _placedPiece;
  String? _draggingPiece;
  Offset _dragOffset = Offset.zero;
  Rect _targetSlotRect = Rect.zero;
  double _time = 0;
  final Map<String, Rect> _pieceRects = {};
  final Map<String, Offset> _dragCenters = {};

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final sceneSize = Size(size.x, size.y);
    if (sceneSize.isEmpty) {
      return;
    }

    _pieceRects.clear();
    _drawBackground(canvas, sceneSize);

    final pad = math.max(10.0, sceneSize.width * 0.035);
    final boardRect = Rect.fromLTWH(
      pad,
      pad,
      sceneSize.width * 0.55,
      sceneSize.height - pad * 2,
    );
    final trayRect = Rect.fromLTWH(
      boardRect.right + pad * 0.78,
      pad,
      sceneSize.width - boardRect.right - pad * 1.78,
      sceneSize.height - pad * 2,
    );

    _drawRocketBoard(canvas, boardRect);
    _drawPieceTray(canvas, trayRect);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final point = event.canvasPosition.toOffset();
    for (final entry in _pieceRects.entries) {
      if (entry.value.contains(point)) {
        _draggingPiece = entry.key;
        _selectedPiece = entry.key;
        _dragOffset = entry.value.center - point;
        _dragCenters[entry.key] = point + _dragOffset;
        return;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final dragging = _draggingPiece;
    if (dragging == null) {
      return;
    }
    final current =
        _dragCenters[dragging] ?? event.canvasStartPosition.toOffset();
    _dragCenters[dragging] =
        current + Offset(event.localDelta.x, event.localDelta.y);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    final dragging = _draggingPiece;
    if (dragging == null) {
      return;
    }

    final center = _dragCenters[dragging] ?? _pieceRects[dragging]?.center;
    if (center != null && _targetSlotRect.inflate(18).contains(center)) {
      _placedPiece = dragging;
      _selectedPiece = dragging;
      onAnswerSelected(correctAnswer);
    } else {
      _dragCenters.remove(dragging);
    }
    _draggingPiece = null;
  }

  void _drawBackground(Canvas canvas, Size sceneSize) {
    final rect = Offset.zero & sceneSize;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(22)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF18205E), Color(0xFF147EA0)],
        ).createShader(rect),
    );

    final stars = Paint()..color = Colors.white.withValues(alpha: 0.62);
    for (var i = 0; i < 30; i++) {
      final x = sceneSize.width * ((0.08 + i * 0.137) % 0.92);
      final y = sceneSize.height * ((0.12 + i * 0.211) % 0.78);
      final r = 1.0 + math.sin(_time * 1.8 + i) * 0.45;
      canvas.drawCircle(Offset(x, y), r.abs(), stars);
    }

    canvas.drawCircle(
      Offset(sceneSize.width * 0.88, sceneSize.height * 0.20),
      sceneSize.height * 0.22,
      Paint()..color = AppPalette.mango.withValues(alpha: 0.13),
    );
    canvas.drawCircle(
      Offset(sceneSize.width * 0.90, sceneSize.height * 0.20),
      sceneSize.height * 0.13,
      Paint()..color = const Color(0xFF7BD9C7).withValues(alpha: 0.18),
    );

    final floor = Path()
      ..moveTo(0, sceneSize.height * 0.78)
      ..quadraticBezierTo(sceneSize.width * 0.26, sceneSize.height * 0.70,
          sceneSize.width * 0.56, sceneSize.height * 0.78)
      ..quadraticBezierTo(sceneSize.width * 0.80, sceneSize.height * 0.85,
          sceneSize.width, sceneSize.height * 0.74)
      ..lineTo(sceneSize.width, sceneSize.height)
      ..lineTo(0, sceneSize.height)
      ..close();
    canvas.drawPath(
      floor,
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );
  }

  void _drawRocketBoard(Canvas canvas, Rect rect) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect.shift(const Offset(0, 5)), const Radius.circular(24)),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.14),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.18),
            Colors.white.withValues(alpha: 0.08),
          ],
        ).createShader(rect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(2), const Radius.circular(22)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    _drawBlueprintGrid(canvas, rect.deflate(12));
    _drawAssemblyArms(canvas, rect);

    final slotHeight = rect.height * 0.18;
    final slotWidth = rect.width * 0.74;
    final centers = [
      Offset(rect.center.dx, rect.top + rect.height * 0.29),
      Offset(rect.center.dx, rect.top + rect.height * 0.51),
      Offset(rect.center.dx, rect.top + rect.height * 0.73),
    ];
    _drawSlot(canvas, centers[0], slotWidth, slotHeight, 'A', fixed: true);
    _drawSlot(
      canvas,
      centers[1],
      slotWidth,
      slotHeight,
      _placedPiece,
      fixed: false,
      target: true,
    );
    _drawSlot(canvas, centers[2], slotWidth, slotHeight, 'C', fixed: true);

    if (_placedPiece == 'B') {
      _drawSuccessSpark(canvas, centers[1], slotWidth);
    }
  }

  void _drawBlueprintGrid(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (var i = 1; i < 5; i++) {
      final x = rect.left + rect.width * i / 5;
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), paint);
    }
    for (var i = 1; i < 4; i++) {
      final y = rect.top + rect.height * i / 4;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
    }
    canvas.drawCircle(
      rect.center,
      rect.width * 0.36,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  void _drawAssemblyArms(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = AppPalette.mint.withValues(alpha: 0.46)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final left =
        Offset(rect.left + rect.width * 0.13, rect.top + rect.height * 0.50);
    final right =
        Offset(rect.right - rect.width * 0.12, rect.top + rect.height * 0.50);
    canvas.drawLine(
        left, left.translate(rect.width * 0.14, -rect.height * 0.10), paint);
    canvas.drawLine(
        right, right.translate(-rect.width * 0.13, rect.height * 0.10), paint);
    canvas.drawCircle(left, 4, Paint()..color = AppPalette.mint);
    canvas.drawCircle(right, 4, Paint()..color = AppPalette.mint);
  }

  void _drawSlot(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    String? piece, {
    required bool fixed,
    bool target = false,
  }) {
    final solved = piece == 'B' && target;
    final pulse = target && piece == null
        ? 1 + math.sin(_time * 3.2) * 0.018
        : solved
            ? 1 + math.sin(_time * 5.0) * 0.020
            : 1.0;
    final rect = Rect.fromCenter(
      center: center,
      width: width * pulse,
      height: height * pulse,
    );
    if (target) {
      _targetSlotRect = rect;
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect.shift(const Offset(0, 4)), const Radius.circular(12)),
      Paint()..color = Colors.black.withValues(alpha: 0.16),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()
        ..color = piece == null
            ? const Color(0xFF24305F).withValues(alpha: 0.78)
            : Colors.white.withValues(alpha: 0.96),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()
        ..color =
            solved ? AppPalette.mint : Colors.white.withValues(alpha: 0.34)
        ..style = PaintingStyle.stroke
        ..strokeWidth = solved ? 2.5 : 1.2,
    );

    if (piece == null) {
      final scanY = rect.top + rect.height * (0.18 + (_time * 0.34) % 0.64);
      canvas.drawLine(
        Offset(rect.left + 8, scanY),
        Offset(rect.right - 8, scanY),
        Paint()
          ..color = AppPalette.sky.withValues(alpha: 0.48)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
      _drawText(canvas, '?', center, Colors.white.withValues(alpha: 0.86), 22);
      return;
    }

    _drawRocketPiece(canvas, rect.deflate(3), piece, fixed: fixed);
  }

  void _drawPieceTray(Canvas canvas, Rect rect) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(23)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final pieces = ['A', 'B', 'C'];
    final thumbWidth = rect.width * 0.76;
    final thumbHeight = rect.height * 0.22;
    for (var i = 0; i < pieces.length; i++) {
      final piece = pieces[i];
      if (_placedPiece == piece && _draggingPiece != piece) {
        continue;
      }
      final orbit = Rect.fromCenter(
        center: rect.center,
        width: rect.width * (0.72 + i * 0.10),
        height: rect.height * (0.38 + i * 0.08),
      );
      canvas.drawOval(
        orbit,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      final center = Offset(
        rect.center.dx,
        rect.top + rect.height * (0.24 + i * 0.26),
      );
      final selected = _selectedPiece == piece;
      final bob = math.sin(_time * 2.4 + i) * (selected ? 1.6 : 0.8);
      final dragCenter = _dragCenters[piece];
      final thumbRect = Rect.fromCenter(
        center: dragCenter ?? center.translate(0, bob),
        width: thumbWidth * (selected ? 1.06 : 1.0),
        height: thumbHeight * (selected ? 1.06 : 1.0),
      );
      _pieceRects[piece] = thumbRect.inflate(8);
      _drawThumb(canvas, thumbRect, piece, selected);
    }
  }

  void _drawThumb(Canvas canvas, Rect rect, String piece, bool selected) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect.shift(const Offset(0, 5)), const Radius.circular(16)),
      Paint()..color = Colors.black.withValues(alpha: selected ? 0.20 : 0.12),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: selected
              ? [accent, AppPalette.sky]
              : [
                  Colors.white.withValues(alpha: 0.96),
                  AppPalette.surfaceBlue.withValues(alpha: 0.72),
                ],
        ).createShader(rect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      Paint()
        ..color = Colors.white.withValues(alpha: selected ? 0.90 : 0.64)
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 2.4 : 1.2,
    );

    _drawRocketPiece(canvas, rect.deflate(5), piece, fixed: false);
    _drawText(
      canvas,
      piece,
      rect.bottomRight - const Offset(10, 10),
      selected ? Colors.white : accent,
      12,
    );
  }

  void _drawRocketPiece(
    Canvas canvas,
    Rect rect,
    String piece, {
    required bool fixed,
  }) {
    final scaleY = rect.height / 28;
    final scaleX = rect.width / 112;
    canvas.save();
    canvas.translate(rect.left, rect.top);
    canvas.scale(scaleX, scaleY);

    final bodyPaint = Paint()..color = const Color(0xFFFF6F61);
    final glassPaint = Paint()..color = AppPalette.sky;
    final firePaint = Paint()..color = AppPalette.mango;
    final shadowPaint = Paint()..color = AppPalette.ink.withValues(alpha: 0.10);

    if (piece == 'A') {
      final nose = Path()
        ..moveTo(56, 2)
        ..lineTo(84, 26)
        ..lineTo(28, 26)
        ..close();
      canvas.drawPath(nose.shift(const Offset(0, 2)), shadowPaint);
      canvas.drawPath(nose, bodyPaint);
      canvas.drawCircle(const Offset(56, 19), 7, glassPaint);
      canvas.drawCircle(
        const Offset(53, 16),
        2.5,
        Paint()..color = Colors.white.withValues(alpha: 0.68),
      );
    } else if (piece == 'B') {
      final body = RRect.fromRectAndRadius(
        const Rect.fromLTWH(31, 1, 50, 26),
        const Radius.circular(12),
      );
      canvas.drawRRect(body.shift(const Offset(0, 2)), shadowPaint);
      canvas.drawRRect(body, Paint()..color = Colors.white);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(40, 7, 32, 14),
          const Radius.circular(7),
        ),
        Paint()..color = AppPalette.teal,
      );
      canvas.drawCircle(const Offset(56, 14), 5, glassPaint);
    } else {
      final leftFin = Path()
        ..moveTo(35, 4)
        ..lineTo(17, 25)
        ..lineTo(45, 21)
        ..close();
      final rightFin = Path()
        ..moveTo(77, 4)
        ..lineTo(95, 25)
        ..lineTo(67, 21)
        ..close();
      canvas.drawPath(leftFin.shift(const Offset(0, 2)), shadowPaint);
      canvas.drawPath(rightFin.shift(const Offset(0, 2)), shadowPaint);
      canvas.drawPath(leftFin, Paint()..color = AppPalette.lavender);
      canvas.drawPath(rightFin, Paint()..color = AppPalette.lavender);
      final flame = Path()
        ..moveTo(56, 9)
        ..cubicTo(43, 16, 49, 27, 56, 27)
        ..cubicTo(65, 25, 68, 16, 56, 9);
      canvas.drawPath(flame, firePaint);
    }

    if (!fixed) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(4, 3, 104, 22),
          const Radius.circular(11),
        ),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
    canvas.restore();
  }

  void _drawSuccessSpark(Canvas canvas, Offset center, double width) {
    final paint = Paint()
      ..color = AppPalette.mint.withValues(alpha: 0.92)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 6; i++) {
      final angle = _time * 1.8 + i * math.pi / 3;
      final start =
          center + Offset(math.cos(angle), math.sin(angle)) * width * 0.36;
      final end =
          center + Offset(math.cos(angle), math.sin(angle)) * width * 0.44;
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center,
    Color color,
    double fontSize,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }
}
