import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_theme.dart';

class SecretCardsGameView extends StatelessWidget {
  const SecretCardsGameView({
    required this.accent,
    required this.compact,
    required this.onAnswerSelected,
    super.key,
  });

  final Color accent;
  final bool compact;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: double.infinity,
          height: compact ? 208 : 236,
          child: GameWidget.controlled(
            gameFactory: () => SecretCardsGame(
              accent: accent,
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

class SecretCardsGame extends FlameGame with TapCallbacks {
  SecretCardsGame({
    required this.accent,
    required this.onAnswerSelected,
  });

  final Color accent;
  final ValueChanged<String> onAnswerSelected;

  double _time = 0;
  double _previewTime = 0;
  bool _preview = true;
  Rect _replayRect = Rect.zero;
  String? _chosenAnswer;
  final Map<String, Rect> _answerRects = {};

  static const _previewDuration = 3.0;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_preview) {
      _previewTime += dt;
      if (_previewTime >= _previewDuration) {
        _preview = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final sceneSize = Size(size.x, size.y);
    if (sceneSize.isEmpty) {
      return;
    }

    _answerRects.clear();
    _drawBackground(canvas, sceneSize);
    _drawSparkles(canvas, sceneSize);
    _drawMemoryTray(canvas, sceneSize);
    _drawReplayButton(canvas, sceneSize);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final point = event.canvasPosition.toOffset();
    if (_replayRect.contains(point)) {
      _preview = true;
      _previewTime = 0;
      _chosenAnswer = null;
      return;
    }

    if (_preview) {
      return;
    }

    for (final entry in _answerRects.entries) {
      if (entry.value.contains(point)) {
        _chosenAnswer = entry.key;
        onAnswerSelected(entry.key);
        return;
      }
    }
  }

  void _drawBackground(Canvas canvas, Size sceneSize) {
    final rect = Offset.zero & sceneSize;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4ECFF), Color(0xFFE2F8FF)],
        ).createShader(rect),
    );

    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(
      Offset(sceneSize.width * 0.18, sceneSize.height * 0.20),
      sceneSize.width * 0.20,
      glowPaint..color = AppPalette.coral.withValues(alpha: 0.14),
    );
    canvas.drawCircle(
      Offset(sceneSize.width * 0.74, sceneSize.height * 0.75),
      sceneSize.width * 0.22,
      glowPaint..color = AppPalette.teal.withValues(alpha: 0.14),
    );

    final wall = Path()
      ..moveTo(0, sceneSize.height * 0.54)
      ..quadraticBezierTo(sceneSize.width * 0.30, sceneSize.height * 0.47,
          sceneSize.width * 0.58, sceneSize.height * 0.56)
      ..quadraticBezierTo(sceneSize.width * 0.84, sceneSize.height * 0.64,
          sceneSize.width, sceneSize.height * 0.50)
      ..lineTo(sceneSize.width, sceneSize.height)
      ..lineTo(0, sceneSize.height)
      ..close();
    canvas.drawPath(
      wall,
      Paint()..color = Colors.white.withValues(alpha: 0.34),
    );

    final window = Rect.fromLTWH(
      sceneSize.width * 0.67,
      sceneSize.height * 0.10,
      sceneSize.width * 0.22,
      sceneSize.height * 0.26,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        window.shift(const Offset(0, 4)),
        const Radius.circular(18),
      ),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.07),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(window, const Radius.circular(18)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17255E), Color(0xFF5E72D8)],
        ).createShader(window),
    );
    canvas.drawLine(
      Offset(window.center.dx, window.top + 7),
      Offset(window.center.dx, window.bottom - 7),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.42)
        ..strokeWidth = 1.4,
    );
    canvas.drawLine(
      Offset(window.left + 8, window.center.dy),
      Offset(window.right - 8, window.center.dy),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.34)
        ..strokeWidth = 1.4,
    );
    canvas.drawCircle(
      Offset(
          window.left + window.width * 0.72, window.top + window.height * 0.26),
      window.width * 0.10,
      Paint()..color = AppPalette.mango.withValues(alpha: 0.90),
    );
    _drawTinyStar(
      canvas,
      Offset(
          window.left + window.width * 0.30, window.top + window.height * 0.28),
      Colors.white.withValues(alpha: 0.86),
      size: 4,
    );
    _drawTinyStar(
      canvas,
      Offset(
          window.left + window.width * 0.50, window.top + window.height * 0.66),
      Colors.white.withValues(alpha: 0.72),
      size: 3,
    );
  }

  void _drawSparkles(Canvas canvas, Size sceneSize) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.74);
    for (var index = 0; index < 9; index++) {
      final seed = index * 1.73;
      final x = sceneSize.width * (0.08 + ((index * 0.13) % 0.84));
      final y = sceneSize.height *
          (0.12 + ((index * 0.19 + math.sin(_time + seed) * 0.025) % 0.72));
      final radius = 1.5 + math.sin(_time * 1.7 + seed) * 0.7;
      canvas.drawCircle(Offset(x, y), radius.abs(), paint);
    }
  }

  void _drawMemoryTray(Canvas canvas, Size sceneSize) {
    _drawMemoryHost(
      canvas,
      Offset(sceneSize.width * 0.16, sceneSize.height * 0.53),
      sceneSize.height * 0.42,
    );

    final tableRect = Rect.fromLTWH(
      sceneSize.width * 0.18,
      sceneSize.height * 0.53,
      sceneSize.width * 0.70,
      sceneSize.height * 0.30,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        tableRect.shift(Offset(0, sceneSize.height * 0.040)),
        Radius.circular(sceneSize.height * 0.08),
      ),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.08),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        tableRect,
        Radius.circular(sceneSize.height * 0.08),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.92),
            AppPalette.mint.withValues(alpha: 0.58),
          ],
        ).createShader(tableRect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        tableRect.deflate(2),
        Radius.circular(sceneSize.height * 0.07),
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.54)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    final progress =
        _preview ? (_previewTime / _previewDuration).clamp(0, 1) : 1;
    final progressRect = Rect.fromLTWH(
      tableRect.left + tableRect.width * 0.12,
      tableRect.bottom - tableRect.height * 0.11,
      tableRect.width * 0.76 * (1 - progress),
      sceneSize.height * 0.025,
    );
    if (_preview) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(progressRect, const Radius.circular(99)),
        Paint()..color = AppPalette.teal.withValues(alpha: 0.72),
      );
    }

    final cardSize = math.min(sceneSize.height * 0.34, sceneSize.width * 0.18);
    final centerY = sceneSize.height * 0.64;
    final positions = [
      Offset(sceneSize.width * 0.35, centerY),
      Offset(sceneSize.width * 0.54, centerY),
      Offset(sceneSize.width * 0.73, centerY),
    ];

    _drawCard(
      canvas,
      center: positions[0],
      size: cardSize,
      label: 'A',
      answer: 'Ракета',
      color: AppPalette.coral,
      type: _CardSymbol.rocket,
      hidden: false,
      highlighted: false,
    );
    _drawCard(
      canvas,
      center: positions[1],
      size: cardSize,
      label: 'B',
      answer: 'Планета',
      color: accent,
      type: _CardSymbol.planet,
      hidden: !_preview,
      highlighted: true,
    );
    _drawCard(
      canvas,
      center: positions[2],
      size: cardSize,
      label: 'C',
      answer: 'Звезда',
      color: AppPalette.mango,
      type: _CardSymbol.star,
      hidden: false,
      highlighted: false,
    );
  }

  void _drawCard(
    Canvas canvas, {
    required Offset center,
    required double size,
    required String label,
    required String answer,
    required Color color,
    required _CardSymbol type,
    required bool hidden,
    required bool highlighted,
  }) {
    final wobble = math.sin(_time * 2.0 + center.dx * 0.02) * 1.8;
    final scale = hidden
        ? 0.92 + math.sin(_time * 4.0) * 0.015
        : 1.0 + (highlighted && _preview ? math.sin(_time * 5.0) * 0.025 : 0);
    final rect = Rect.fromCenter(
      center: center.translate(0, wobble),
      width: size * scale,
      height: size * scale,
    );
    final radius = Radius.circular(size * 0.25);
    final cardRRect = RRect.fromRectAndRadius(rect, radius);
    _answerRects[answer] = rect.inflate(size * 0.18);
    final chosen = _chosenAnswer == answer;

    canvas.drawRRect(
      cardRRect.shift(const Offset(0, 7)),
      Paint()..color = color.withValues(alpha: hidden ? 0.09 : 0.18),
    );
    canvas.drawRRect(
      cardRRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hidden
              ? [
                  AppPalette.ink.withValues(alpha: 0.24),
                  AppPalette.ink.withValues(alpha: 0.13),
                ]
              : [Colors.white, color.withValues(alpha: 0.10)],
        ).createShader(rect),
    );
    canvas.drawRRect(
      cardRRect,
      Paint()
        ..color = (chosen
                ? AppPalette.mint
                : highlighted
                    ? color
                    : Colors.white)
            .withValues(alpha: 0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = chosen
            ? 3.0
            : highlighted
                ? 2.3
                : 1.2,
    );

    _drawCardLabel(
        canvas, label, rect.topLeft + Offset(size * 0.12, size * 0.12));

    if (hidden) {
      _drawLock(canvas, rect.center, size * 0.44);
      _drawMemoryQuestion(canvas, rect.center, size);
      return;
    }

    final iconRect = Rect.fromCenter(
      center: rect.center.translate(0, size * 0.04),
      width: size * 0.55,
      height: size * 0.55,
    );
    _drawSymbolBadge(canvas, iconRect, color, type);
  }

  void _drawMemoryHost(Canvas canvas, Offset center, double size) {
    final shadow = Paint()..color = AppPalette.ink.withValues(alpha: 0.10);
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, size * 0.48),
        width: size * 0.78,
        height: size * 0.18,
      ),
      shadow,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, size * 0.10),
        width: size * 0.46,
        height: size * 0.56,
      ),
      Paint()..color = const Color(0xFF83D6E5),
    );
    canvas.drawCircle(
      center.translate(-size * 0.16, -size * 0.12),
      size * 0.14,
      Paint()..color = const Color(0xFFA8EEF6),
    );
    canvas.drawCircle(
      center.translate(size * 0.16, -size * 0.12),
      size * 0.14,
      Paint()..color = const Color(0xFFA8EEF6),
    );
    canvas.drawCircle(
      center.translate(0, -size * 0.12),
      size * 0.24,
      Paint()..color = const Color(0xFF83D6E5),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(size * 0.04, size * 0.02),
        width: size * 0.18,
        height: size * 0.30,
      ),
      Paint()..color = const Color(0xFF5CBFD0),
    );
    canvas.drawCircle(
      center.translate(-size * 0.08, -size * 0.17),
      size * 0.030,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center.translate(size * 0.08, -size * 0.17),
      size * 0.030,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      center.translate(-size * 0.08, -size * 0.17),
      size * 0.014,
      Paint()..color = AppPalette.ink,
    );
    canvas.drawCircle(
      center.translate(size * 0.08, -size * 0.17),
      size * 0.014,
      Paint()..color = AppPalette.ink,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, -size * 0.06),
        width: size * 0.16,
        height: size * 0.10,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = AppPalette.ink.withValues(alpha: 0.58)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.012,
    );
    _drawMagnifier(canvas, center.translate(size * 0.24, size * 0.03), size);
  }

  void _drawMagnifier(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = AppPalette.lavender
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.025
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, size * 0.070, paint);
    canvas.drawLine(
      center.translate(size * 0.055, size * 0.055),
      center.translate(size * 0.14, size * 0.14),
      paint,
    );
  }

  void _drawMemoryQuestion(Canvas canvas, Offset center, double size) {
    final painter = TextPainter(
      text: TextSpan(
        text: '?',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.86),
          fontSize: size * 0.38,
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

  void _drawCardLabel(Canvas canvas, String label, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: AppPalette.ink.withValues(alpha: 0.46),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  void _drawSymbolBadge(
    Canvas canvas,
    Rect rect,
    Color color,
    _CardSymbol type,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.28)),
      Paint()..color = color.withValues(alpha: 0.15),
    );

    switch (type) {
      case _CardSymbol.rocket:
        _drawRocket(canvas, rect, color);
      case _CardSymbol.planet:
        _drawPlanet(canvas, rect, color);
      case _CardSymbol.star:
        _drawStar(canvas, rect.center, rect.width * 0.42, color);
    }
  }

  void _drawRocket(Canvas canvas, Rect rect, Color color) {
    final body = Paint()..color = color;
    final center = rect.center;
    final bodyPath = Path()
      ..moveTo(center.dx, rect.top + rect.height * 0.08)
      ..cubicTo(rect.right, rect.top + rect.height * 0.28, rect.right,
          rect.bottom - rect.height * 0.18, center.dx, rect.bottom)
      ..cubicTo(
          rect.left,
          rect.bottom - rect.height * 0.18,
          rect.left,
          rect.top + rect.height * 0.28,
          center.dx,
          rect.top + rect.height * 0.08)
      ..close();
    canvas.save();
    canvas.rotate(0.58);
    canvas.restore();
    canvas.drawPath(bodyPath, body);
    canvas.drawCircle(
      Offset(center.dx + rect.width * 0.09, center.dy - rect.height * 0.12),
      rect.width * 0.10,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
    canvas.drawPath(
      Path()
        ..moveTo(rect.left + rect.width * 0.05, rect.bottom)
        ..lineTo(
            rect.left + rect.width * 0.32, rect.bottom - rect.height * 0.22)
        ..lineTo(rect.left + rect.width * 0.38, rect.bottom)
        ..close(),
      Paint()..color = AppPalette.coral,
    );
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - rect.width * 0.05, rect.bottom)
        ..lineTo(
            rect.right - rect.width * 0.32, rect.bottom - rect.height * 0.22)
        ..lineTo(rect.right - rect.width * 0.38, rect.bottom)
        ..close(),
      Paint()..color = AppPalette.mango,
    );
  }

  void _drawPlanet(Canvas canvas, Rect rect, Color color) {
    final center = rect.center;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: rect.width * 0.95,
        height: rect.height * 0.38,
      ),
      Paint()
        ..color = color.withValues(alpha: 0.34)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawCircle(
      center,
      rect.width * 0.28,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: 0.82), color],
        ).createShader(
            Rect.fromCircle(center: center, radius: rect.width * 0.3)),
    );
    canvas.drawCircle(
      center.translate(rect.width * 0.10, -rect.height * 0.09),
      rect.width * 0.06,
      Paint()..color = Colors.white.withValues(alpha: 0.70),
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? radius : radius * 0.46;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final point = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(
      center.translate(-radius * 0.14, -radius * 0.20),
      radius * 0.13,
      Paint()..color = Colors.white.withValues(alpha: 0.70),
    );
  }

  void _drawTinyStar(
    Canvas canvas,
    Offset center,
    Color color, {
    double size = 5,
  }) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? size : size * 0.45;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final point =
          center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawLock(Canvas canvas, Offset center, double size) {
    final paint = Paint()..color = AppPalette.muted.withValues(alpha: 0.92);
    final body = Rect.fromCenter(
      center: center.translate(0, size * 0.12),
      width: size * 0.82,
      height: size * 0.62,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, Radius.circular(size * 0.13)),
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, -size * 0.10),
        width: size * 0.58,
        height: size * 0.62,
      ),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = AppPalette.muted.withValues(alpha: 0.92)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.12
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      center.translate(0, size * 0.13),
      size * 0.06,
      Paint()..color = Colors.white.withValues(alpha: 0.56),
    );
  }

  void _drawReplayButton(Canvas canvas, Size sceneSize) {
    final width = sceneSize.height * 0.22;
    final height = sceneSize.height * 0.22;
    _replayRect = Rect.fromCenter(
      center: Offset(sceneSize.width * 0.90, sceneSize.height * 0.19),
      width: width,
      height: height,
    );

    final isReplay = !_preview;
    final color = isReplay ? Colors.white : AppPalette.mint;
    final foreground = isReplay ? accent : Colors.white;
    final pulse = isReplay ? 1 + math.sin(_time * 5) * 0.035 : 1.0;
    final rect = Rect.fromCenter(
      center: _replayRect.center,
      width: _replayRect.width * pulse,
      height: _replayRect.height * pulse,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect.shift(const Offset(0, 7)), Radius.circular(rect.width * 0.32)),
      Paint()..color = accent.withValues(alpha: 0.12),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.32)),
      Paint()..color = color,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.width * 0.32)),
      Paint()
        ..color = accent.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    if (isReplay) {
      _drawReplayArrow(canvas, rect, foreground);
    } else {
      _drawEye(canvas, rect, foreground);
    }
  }

  void _drawEye(Canvas canvas, Rect rect, Color color) {
    final center = rect.center;
    final eyeRect = Rect.fromCenter(
      center: center,
      width: rect.width * 0.48,
      height: rect.height * 0.23,
    );
    canvas.drawOval(
      eyeRect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawCircle(center, rect.width * 0.10, Paint()..color = color);
  }

  void _drawReplayArrow(Canvas canvas, Rect rect, Color color) {
    final center = rect.center;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: rect.width * 0.46,
        height: rect.width * 0.46,
      ),
      -math.pi * 0.15,
      math.pi * 1.45,
      false,
      paint,
    );
    final head = Path()
      ..moveTo(center.dx - rect.width * 0.13, center.dy - rect.width * 0.18)
      ..lineTo(center.dx - rect.width * 0.25, center.dy - rect.width * 0.04)
      ..lineTo(center.dx - rect.width * 0.06, center.dy - rect.width * 0.02);
    canvas.drawPath(head, paint);
  }
}

enum _CardSymbol { rocket, planet, star }
