import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_theme.dart';

class CampDifferencesGameView extends StatelessWidget {
  const CampDifferencesGameView({
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
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: double.infinity,
          height: compact ? 214 : 242,
          child: GameWidget.controlled(
            gameFactory: () => CampDifferencesGame(
              accent: accent,
              onAnswerSelected: onAnswerSelected,
            ),
          ),
        ),
      ).animate().fadeIn(duration: 220.ms).slideY(
            begin: 0.025,
            end: 0,
            duration: 260.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}

class CampDifferencesGame extends FlameGame with TapCallbacks {
  CampDifferencesGame({
    required this.accent,
    required this.onAnswerSelected,
  });

  final Color accent;
  final ValueChanged<String> onAnswerSelected;

  final Set<int> _found = {};
  double _time = 0;
  Rect _rightScene = Rect.zero;
  final Map<int, Rect> _hitRects = {};

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

    _hitRects.clear();
    _drawBackground(canvas, sceneSize);

    final outerPadding = math.max(8.0, sceneSize.width * 0.030);
    final gap = math.max(6.0, sceneSize.width * 0.025);
    final counterWidth = math.max(34.0, sceneSize.width * 0.105);
    final pictureWidth =
        (sceneSize.width - outerPadding * 2 - gap * 2 - counterWidth) / 2;
    final pictureHeight = sceneSize.height - outerPadding * 2;
    final leftRect = Rect.fromLTWH(
      outerPadding,
      outerPadding,
      pictureWidth,
      pictureHeight,
    );
    _rightScene = Rect.fromLTWH(
      outerPadding + pictureWidth + gap,
      outerPadding,
      pictureWidth,
      pictureHeight,
    );
    final counterRect = Rect.fromLTWH(
      _rightScene.right + gap,
      outerPadding,
      counterWidth,
      pictureHeight,
    );

    _drawCampScene(canvas, leftRect, variant: 0, interactive: false);
    _drawCampScene(canvas, _rightScene, variant: 1, interactive: true);
    _drawCounter(canvas, counterRect);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final point = event.canvasPosition.toOffset();
    for (final entry in _hitRects.entries) {
      if (entry.value.inflate(12).contains(point)) {
        _found.add(entry.key);
        if (_found.length >= 2) {
          onAnswerSelected('2');
        }
      }
    }
  }

  void _drawBackground(Canvas canvas, Size sceneSize) {
    final rect = Offset.zero & sceneSize;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(22)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF1C7), Color(0xFFD9F6EF)],
        ).createShader(rect),
    );

    final glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(
      Offset(sceneSize.width * 0.10, sceneSize.height * 0.22),
      sceneSize.width * 0.16,
      glow..color = AppPalette.mango.withValues(alpha: 0.15),
    );
    canvas.drawCircle(
      Offset(sceneSize.width * 0.77, sceneSize.height * 0.78),
      sceneSize.width * 0.18,
      glow..color = AppPalette.teal.withValues(alpha: 0.13),
    );

    final canopy = Paint()
      ..color = const Color(0xFF7BD1A7).withValues(alpha: 0.24);
    canvas.drawCircle(
      Offset(sceneSize.width * 0.04, sceneSize.height * 0.18),
      sceneSize.width * 0.20,
      canopy,
    );
    canvas.drawCircle(
      Offset(sceneSize.width * 0.96, sceneSize.height * 0.10),
      sceneSize.width * 0.18,
      canopy,
    );
  }

  void _drawCounter(Canvas canvas, Rect rect) {
    final base = RRect.fromRectAndRadius(rect, const Radius.circular(17));
    canvas.drawRRect(
      base,
      Paint()..color = Colors.white.withValues(alpha: 0.42),
    );

    for (var index = 0; index < 2; index++) {
      final found = _found.contains(index);
      final center = Offset(
        rect.center.dx,
        rect.top + rect.height * (index == 0 ? 0.34 : 0.66),
      );
      final pulse = found ? 1.0 + math.sin(_time * 5 + index) * 0.035 : 1.0;
      final radius = rect.width * 0.36 * pulse;
      canvas.drawCircle(
        center.translate(0, 4),
        radius,
        Paint()..color = accent.withValues(alpha: found ? 0.16 : 0.08),
      );
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = found ? AppPalette.teal : Colors.white,
      );
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = found ? 2.4 : 1.4,
      );
      _drawText(
        canvas,
        '${index + 1}',
        center,
        found ? Colors.white : accent,
        rect.width * 0.34,
      );
    }
  }

  void _drawCampScene(
    Canvas canvas,
    Rect scene, {
    required int variant,
    required bool interactive,
  }) {
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(scene, const Radius.circular(17)));
    canvas.translate(scene.left, scene.top);
    final localSize = scene.size;

    final rect = Offset.zero & localSize;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(17)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBEEFFF), Color(0xFFFFF3C8)],
        ).createShader(rect),
    );

    _drawCloud(
      canvas,
      Offset(localSize.width * 0.20, localSize.height * 0.15),
      localSize.width * 0.0062,
    );
    _drawCloud(
      canvas,
      Offset(localSize.width * 0.72, localSize.height * 0.12),
      localSize.width * 0.0048,
    );
    canvas.drawCircle(
      Offset(localSize.width * 0.82, localSize.height * 0.26),
      localSize.width * 0.11,
      Paint()..color = const Color(0xFFFFD46B).withValues(alpha: 0.72),
    );

    final farHill = Path()
      ..moveTo(0, localSize.height * 0.64)
      ..quadraticBezierTo(localSize.width * 0.28, localSize.height * 0.42,
          localSize.width * 0.56, localSize.height * 0.63)
      ..quadraticBezierTo(localSize.width * 0.78, localSize.height * 0.78,
          localSize.width, localSize.height * 0.58)
      ..lineTo(localSize.width, localSize.height)
      ..lineTo(0, localSize.height)
      ..close();
    canvas.drawPath(
      farHill,
      Paint()..color = const Color(0xFF83D7B8).withValues(alpha: 0.62),
    );

    final nearHill = Path()
      ..moveTo(0, localSize.height * 0.78)
      ..quadraticBezierTo(localSize.width * 0.34, localSize.height * 0.64,
          localSize.width * 0.62, localSize.height * 0.76)
      ..quadraticBezierTo(localSize.width * 0.86, localSize.height * 0.88,
          localSize.width, localSize.height * 0.72)
      ..lineTo(localSize.width, localSize.height)
      ..lineTo(0, localSize.height)
      ..close();
    canvas.drawPath(nearHill, Paint()..color = const Color(0xFFB9EDAE));

    _drawTree(
      canvas,
      Offset(localSize.width * 0.09, localSize.height * 0.56),
      localSize.width * 0.0065,
    );
    _drawTree(
      canvas,
      Offset(localSize.width * 0.93, localSize.height * 0.58),
      localSize.width * 0.0055,
    );
    _drawCozyElephant(
      canvas,
      Offset(
        localSize.width * 0.18,
        localSize.height * (0.66 + math.sin(_time * 2.1) * 0.010),
      ),
      localSize.width * 0.34,
    );

    _drawTent(canvas, localSize);
    _drawBearFriend(
      canvas,
      Offset(localSize.width * 0.72, localSize.height * 0.69),
      localSize.width * 0.24,
    );

    final flagColor = variant == 0 ? AppPalette.coral : AppPalette.teal;
    final flagRect = Rect.fromLTWH(
      localSize.width * 0.31,
      localSize.height * 0.10,
      localSize.width * 0.19,
      localSize.height * 0.075,
    );
    canvas.drawLine(
      Offset(localSize.width * 0.31, localSize.height * 0.29),
      Offset(localSize.width * 0.31, localSize.height * 0.10),
      Paint()
        ..color = AppPalette.ink.withValues(alpha: 0.52)
        ..strokeWidth = localSize.width * 0.012,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(flagRect, const Radius.circular(4)),
      Paint()..color = flagColor,
    );

    final flameCenter = Offset(localSize.width * 0.61, localSize.height * 0.72);
    _drawFire(canvas, flameCenter);

    final starCenter = variant == 0
        ? Offset(localSize.width * 0.82, localSize.height * 0.50)
        : Offset(localSize.width * 0.83, localSize.height * 0.65);
    _drawTinyStar(
      canvas,
      starCenter,
      variant == 0 ? AppPalette.mango : Colors.white,
    );

    if (interactive) {
      final globalFlag = flagRect.shift(scene.topLeft).inflate(8);
      final globalStar = Rect.fromCircle(
        center: starCenter + scene.topLeft,
        radius: localSize.width * 0.12,
      );
      _hitRects[0] = globalFlag;
      _hitRects[1] = globalStar;
      _drawFoundMarker(canvas, flagRect.center, _found.contains(0));
      _drawFoundMarker(canvas, starCenter, _found.contains(1));
    }

    canvas.restore();
  }

  void _drawFoundMarker(Canvas canvas, Offset center, bool found) {
    if (!found) {
      final hintPulse = (math.sin(_time * 2.4) + 1) / 2;
      canvas.drawCircle(
        center,
        13 + hintPulse * 1.8,
        Paint()
          ..color = accent.withValues(alpha: 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      return;
    }
    canvas.drawCircle(
      center,
      15,
      Paint()..color = accent.withValues(alpha: 0.24),
    );
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    final check = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(center.dx - 6, center.dy)
      ..lineTo(center.dx - 1, center.dy + 5)
      ..lineTo(center.dx + 8, center.dy - 7);
    canvas.drawPath(path, check);
  }

  void _drawTent(Canvas canvas, Size localSize) {
    final shadow = Paint()..color = AppPalette.ink.withValues(alpha: 0.10);
    final back = Path()
      ..moveTo(localSize.width * 0.26, localSize.height * 0.79)
      ..lineTo(localSize.width * 0.50, localSize.height * 0.31)
      ..lineTo(localSize.width * 0.78, localSize.height * 0.79)
      ..close();
    canvas.drawPath(back.shift(Offset(0, localSize.height * 0.026)), shadow);
    canvas.drawPath(back, Paint()..color = const Color(0xFF8578FF));

    final door = Path()
      ..moveTo(localSize.width * 0.50, localSize.height * 0.79)
      ..lineTo(localSize.width * 0.63, localSize.height * 0.79)
      ..lineTo(localSize.width * 0.50, localSize.height * 0.48)
      ..close();
    canvas.drawPath(
        door, Paint()..color = Colors.white.withValues(alpha: 0.84));

    final sideShade = Path()
      ..moveTo(localSize.width * 0.50, localSize.height * 0.31)
      ..lineTo(localSize.width * 0.78, localSize.height * 0.79)
      ..lineTo(localSize.width * 0.63, localSize.height * 0.79)
      ..lineTo(localSize.width * 0.50, localSize.height * 0.48)
      ..close();
    canvas.drawPath(
      sideShade,
      Paint()..color = const Color(0xFF5F55E6).withValues(alpha: 0.54),
    );

    canvas.drawLine(
      Offset(localSize.width * 0.50, localSize.height * 0.31),
      Offset(localSize.width * 0.50, localSize.height * 0.79),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.56)
        ..strokeWidth = localSize.width * 0.014,
    );
  }

  void _drawCozyElephant(Canvas canvas, Offset center, double size) {
    final shadow = Paint()..color = AppPalette.ink.withValues(alpha: 0.10);
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, size * 0.34),
        width: size * 0.82,
        height: size * 0.18,
      ),
      shadow,
    );
    final body = Paint()..color = const Color(0xFF72D3D8);
    final ear = Paint()..color = const Color(0xFF93E6EA);
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, size * 0.04),
        width: size * 0.48,
        height: size * 0.58,
      ),
      body,
    );
    canvas.drawCircle(
        center.translate(-size * 0.21, -size * 0.07), size * 0.17, ear);
    canvas.drawCircle(
        center.translate(size * 0.20, -size * 0.07), size * 0.15, ear);
    canvas.drawCircle(center.translate(0, -size * 0.12), size * 0.24, body);
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(size * 0.11, size * 0.02),
        width: size * 0.20,
        height: size * 0.36,
      ),
      Paint()..color = const Color(0xFF53BEC8),
    );
    canvas.drawCircle(center.translate(-size * 0.07, -size * 0.17),
        size * 0.030, Paint()..color = Colors.white);
    canvas.drawCircle(center.translate(size * 0.07, -size * 0.17), size * 0.030,
        Paint()..color = Colors.white);
    canvas.drawCircle(center.translate(-size * 0.07, -size * 0.17),
        size * 0.014, Paint()..color = AppPalette.ink);
    canvas.drawCircle(center.translate(size * 0.07, -size * 0.17), size * 0.014,
        Paint()..color = AppPalette.ink);
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, -size * 0.08),
        width: size * 0.15,
        height: size * 0.10,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = AppPalette.ink.withValues(alpha: 0.50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.014,
    );
  }

  void _drawBearFriend(Canvas canvas, Offset center, double size) {
    final bob = math.sin(_time * 2.4) * size * 0.018;
    final current = center.translate(0, bob);
    final fur = Paint()..color = const Color(0xFF50C6A7);
    canvas.drawOval(
      Rect.fromCenter(
        center: current.translate(0, size * 0.28),
        width: size * 0.70,
        height: size * 0.14,
      ),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.10),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: current.translate(0, size * 0.06),
        width: size * 0.52,
        height: size * 0.62,
      ),
      fur,
    );
    canvas.drawCircle(
        current.translate(-size * 0.13, -size * 0.19), size * 0.10, fur);
    canvas.drawCircle(
        current.translate(size * 0.13, -size * 0.19), size * 0.10, fur);
    canvas.drawCircle(current.translate(0, -size * 0.12), size * 0.22, fur);
    canvas.drawOval(
      Rect.fromCenter(
        center: current.translate(0, -size * 0.02),
        width: size * 0.20,
        height: size * 0.13,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.72),
    );
    canvas.drawCircle(current.translate(-size * 0.07, -size * 0.15),
        size * 0.022, Paint()..color = AppPalette.ink);
    canvas.drawCircle(current.translate(size * 0.07, -size * 0.15),
        size * 0.022, Paint()..color = AppPalette.ink);
    canvas.drawCircle(current.translate(0, -size * 0.05), size * 0.018,
        Paint()..color = AppPalette.ink.withValues(alpha: 0.70));
  }

  void _drawCloud(Canvas canvas, Offset center, double scale) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.78);
    canvas.drawCircle(
        center.translate(-15 * scale, 2 * scale), 9 * scale, paint);
    canvas.drawCircle(center, 13 * scale, paint);
    canvas.drawCircle(
        center.translate(16 * scale, 3 * scale), 8 * scale, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, 8 * scale),
          width: 42 * scale,
          height: 12 * scale,
        ),
        Radius.circular(9 * scale),
      ),
      paint,
    );
  }

  void _drawTree(Canvas canvas, Offset base, double scale) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          base.dx - 4 * scale,
          base.dy - 25 * scale,
          8 * scale,
          31 * scale,
        ),
        Radius.circular(4 * scale),
      ),
      Paint()..color = const Color(0xFF8D5A35),
    );
    final leafPaint = Paint()..color = const Color(0xFF48BFA4);
    canvas.drawCircle(
        base.translate(-10 * scale, -28 * scale), 15 * scale, leafPaint);
    canvas.drawCircle(
        base.translate(7 * scale, -34 * scale), 17 * scale, leafPaint);
    canvas.drawCircle(
        base.translate(18 * scale, -22 * scale), 13 * scale, leafPaint);
  }

  void _drawFire(Canvas canvas, Offset center) {
    canvas.drawOval(
      Rect.fromCenter(center: center.translate(0, 8), width: 38, height: 12),
      Paint()..color = const Color(0xFF8D5A35),
    );
    final flameLift = math.sin(_time * 7) * 1.4;
    final outer = Path()
      ..moveTo(center.dx, center.dy - 18 - flameLift)
      ..cubicTo(center.dx - 16, center.dy - 3, center.dx - 12, center.dy + 14,
          center.dx, center.dy + 14)
      ..cubicTo(center.dx + 13, center.dy + 11, center.dx + 15, center.dy - 2,
          center.dx, center.dy - 18 - flameLift);
    canvas.drawPath(outer, Paint()..color = AppPalette.coral);
    final inner = Path()
      ..moveTo(center.dx + 1, center.dy - 9 - flameLift)
      ..cubicTo(center.dx - 7, center.dy, center.dx - 5, center.dy + 9,
          center.dx + 1, center.dy + 9)
      ..cubicTo(center.dx + 8, center.dy + 7, center.dx + 9, center.dy,
          center.dx + 1, center.dy - 9 - flameLift);
    canvas.drawPath(inner, Paint()..color = AppPalette.mango);
  }

  void _drawTinyStar(Canvas canvas, Offset center, Color color) {
    final path = Path();
    const radius = 7.0;
    final rotation = math.sin(_time * 1.7) * 0.08;
    for (var point = 0; point < 10; point++) {
      final currentRadius = point.isEven ? radius : radius * 0.45;
      final angle = -math.pi / 2 + point * math.pi / 5 + rotation;
      final offset = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      if (point == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
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
