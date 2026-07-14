import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinalOrbitGameView extends StatefulWidget {
  const FinalOrbitGameView({
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
  State<FinalOrbitGameView> createState() => _FinalOrbitGameViewState();
}

class _FinalOrbitGameViewState extends State<FinalOrbitGameView>
    with TickerProviderStateMixin {
  late final AnimationController _ambientController;
  late final AnimationController _turnController;
  late final AnimationController _flightController;
  late final AnimationController _successController;

  final List<int> _turns = [1, 3, 1];
  int? _turningIndex;
  int _turnFrom = 0;
  bool _flying = false;
  bool _successfulFlight = false;
  bool _solved = false;
  bool _answerSent = false;
  double _flightLimit = 1;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();
    _turnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _turnController.dispose();
    _flightController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (_flying || _solved || size.isEmpty) return;
    final layout = _FinalOrbitLayout(size);
    final point = details.localPosition;
    final tileIndex = layout.tileCenters.indexWhere(
      (center) => (point - center).distance <= layout.tileRadius * 1.18,
    );
    if (tileIndex >= 0) {
      _rotateTile(tileIndex);
      return;
    }
    if (layout.launchHitRect.contains(point)) _launch();
  }

  void _rotateTile(int index) {
    if (_turnController.isAnimating) return;
    HapticFeedback.selectionClick();
    setState(() {
      _turningIndex = index;
      _turnFrom = _turns[index];
      _turns[index] = (_turns[index] + 1) % 4;
    });
    _turnController.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _turningIndex = null);
    });
  }

  Future<void> _launch() async {
    if (_turnController.isAnimating) return;
    final firstBreak = _turns.indexWhere((turn) => turn.isOdd);
    final success = firstBreak < 0;
    HapticFeedback.mediumImpact();
    setState(() {
      _flying = true;
      _successfulFlight = success;
      _flightLimit = success ? 1 : 0.17 + firstBreak * 0.225;
    });

    _flightController.duration = Duration(milliseconds: success ? 1350 : 980);
    await _flightController.forward(from: 0);
    if (!mounted) return;

    if (success) {
      setState(() {
        _solved = true;
        _flying = false;
      });
      HapticFeedback.heavyImpact();
      _successController.forward(from: 0);
      await Future<void>.delayed(const Duration(milliseconds: 540));
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    } else {
      setState(() => _flying = false);
    }
  }

  double _tileAngle(int index) {
    if (_turningIndex != index) return _turns[index] * math.pi / 2;
    return (_turnFrom + Curves.easeOutBack.transform(_turnController.value)) *
        math.pi /
        2;
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
            height: widget.compact ? 216 : 252,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final layout = _FinalOrbitLayout(size);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (details) => _handleTap(details, size),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _ambientController,
                          _turnController,
                          _flightController,
                          _successController,
                        ]),
                        builder: (context, child) => CustomPaint(
                          size: size,
                          painter: _FinalOrbitPainter(
                            accent: widget.accent,
                            ambient: _ambientController.value,
                            tileAngles: List.generate(3, _tileAngle),
                            flight: _flightController.value,
                            flightLimit: _flightLimit,
                            flying: _flying,
                            successfulFlight: _successfulFlight,
                            solved: _solved,
                            success: _successController.value,
                          ),
                        ),
                      ),
                    ),
                    for (var i = 0; i < layout.tileCenters.length; i++)
                      _orbitHook(layout.tileCenters[i], layout.tileRadius * 2.2,
                          ValueKey('final-orbit-tile-$i')),
                    _orbitHook(
                      layout.launchCenter,
                      layout.launchHitRect.width,
                      const ValueKey('final-orbit-launch'),
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

  Widget _orbitHook(Offset center, double diameter, Key key) => Positioned(
        left: center.dx - diameter / 2,
        top: center.dy - diameter / 2,
        width: diameter,
        height: diameter,
        child: IgnorePointer(
          child: Semantics(key: key, container: true),
        ),
      );
}

class _FinalOrbitLayout {
  const _FinalOrbitLayout(this.size);

  final Size size;

  double get unit => size.height / 252;
  double get routeY => size.height * 0.51;
  double get tileRadius => math.min(size.height * 0.205, size.width * 0.092);
  Offset get launchCenter => Offset(size.width * 0.105, routeY);
  Offset get planetCenter => Offset(size.width * 0.895, routeY);
  List<Offset> get tileCenters => [
        Offset(size.width * 0.34, routeY),
        Offset(size.width * 0.52, routeY),
        Offset(size.width * 0.70, routeY),
      ];
  Rect get launchHitRect => Rect.fromCenter(
        center: launchCenter,
        width: math.max(74 * unit, size.width * 0.19),
        height: math.max(112 * unit, size.height * 0.50),
      );
}

class _FinalOrbitPainter extends CustomPainter {
  const _FinalOrbitPainter({
    required this.accent,
    required this.ambient,
    required this.tileAngles,
    required this.flight,
    required this.flightLimit,
    required this.flying,
    required this.successfulFlight,
    required this.solved,
    required this.success,
  });

  final Color accent;
  final double ambient;
  final List<double> tileAngles;
  final double flight;
  final double flightLimit;
  final bool flying;
  final bool successfulFlight;
  final bool solved;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _FinalOrbitLayout(size);
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF09162C), Color(0xFF183257), Color(0xFF30476B)],
        ).createShader(bounds),
    );
    _drawSpace(canvas, size);
    _drawRoute(canvas, layout);
    for (var i = 0; i < 3; i++) {
      _drawTile(
          canvas, layout.tileCenters[i], layout.tileRadius, tileAngles[i]);
    }
    _drawPlanet(canvas, layout);
    _drawLaunchPad(canvas, layout);
    _drawRocket(canvas, layout);
    if (success > 0) _drawSuccess(canvas, layout);
  }

  void _drawSpace(Canvas canvas, Size size) {
    for (var i = 0; i < 28; i++) {
      final x = size.width * ((0.035 + i * 0.173) % 0.98);
      final y = size.height * ((0.05 + i * 0.109) % 0.88);
      final pulse = 0.55 + 0.35 * math.sin(ambient * math.pi * 2 + i * 0.8);
      canvas.drawCircle(
        Offset(x, y),
        i % 5 == 0 ? 1.45 : 0.75,
        Paint()..color = Colors.white.withValues(alpha: pulse),
      );
    }
    final moon = Offset(size.width * 0.07, size.height * 0.17);
    canvas.drawCircle(
      moon,
      size.height * 0.075,
      Paint()..color = const Color(0xFF8FB5CB).withValues(alpha: 0.16),
    );
  }

  void _drawRoute(Canvas canvas, _FinalOrbitLayout layout) {
    final routePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..strokeWidth = 4 * layout.unit
      ..strokeCap = StrokeCap.round;
    final points = [
      Offset(layout.launchCenter.dx + 17 * layout.unit, layout.routeY),
      ...layout.tileCenters,
      Offset(layout.planetCenter.dx - 26 * layout.unit, layout.routeY),
    ];
    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], routePaint);
    }
  }

  void _drawTile(Canvas canvas, Offset center, double radius, double angle) {
    canvas.drawCircle(
      center + Offset(0, radius * 0.10),
      radius * 1.06,
      Paint()..color = Colors.black.withValues(alpha: 0.26),
    );
    canvas.drawCircle(
        center, radius * 1.06, Paint()..color = const Color(0xFF243C62));
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF385D84), Color(0xFF192C4C)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final track = Paint()
      ..color = accent
      ..strokeWidth = radius * 0.22
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-radius * 0.93, 0), Offset(radius * 0.93, 0), track);
    canvas.drawLine(
      Offset(-radius * 0.78, -radius * 0.11),
      Offset(radius * 0.78, -radius * 0.11),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.56)
        ..strokeWidth = radius * 0.055
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.34)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    for (var i = 0; i < 4; i++) {
      final markerAngle = i * math.pi / 2;
      canvas.drawCircle(
        center +
            Offset(math.cos(markerAngle), math.sin(markerAngle)) *
                radius *
                0.78,
        radius * 0.055,
        Paint()..color = Colors.white.withValues(alpha: 0.42),
      );
    }
  }

  void _drawLaunchPad(Canvas canvas, _FinalOrbitLayout layout) {
    final center = layout.launchCenter;
    final unit = layout.unit;
    final base = Rect.fromCenter(
      center: Offset(center.dx, layout.routeY + 42 * unit),
      width: 62 * unit,
      height: 13 * unit,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(base, Radius.circular(5 * unit)),
      Paint()..color = const Color(0xFF607997),
    );
    canvas.drawLine(
      Offset(base.left + 9 * unit, base.top),
      Offset(center.dx - 10 * unit, layout.routeY + 10 * unit),
      Paint()
        ..color = const Color(0xFF90A9BD)
        ..strokeWidth = 5 * unit,
    );
    if (!flying && !solved) {
      final glow = 0.35 + math.sin(ambient * math.pi * 2) * 0.12;
      canvas.drawCircle(
        center,
        31 * unit,
        Paint()..color = accent.withValues(alpha: glow * 0.22),
      );
    }
  }

  void _drawPlanet(Canvas canvas, _FinalOrbitLayout layout) {
    final center = layout.planetCenter;
    final radius =
        math.min(layout.size.height * 0.155, layout.size.width * 0.065);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.24);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset.zero, width: radius * 2.9, height: radius * 0.58),
      Paint()
        ..color = const Color(0xFFFFD474).withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.18,
    );
    canvas.restore();
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFC85D), Color(0xFFE66F62), Color(0xFF884F91)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center + Offset(-radius * 0.30, -radius * 0.22),
      radius * 0.14,
      Paint()..color = Colors.white.withValues(alpha: 0.20),
    );
  }

  void _drawRocket(Canvas canvas, _FinalOrbitLayout layout) {
    var travel = 0.0;
    if (flying || solved) {
      final eased = Curves.easeInOutCubic.transform(flight);
      travel =
          successfulFlight ? eased : math.sin(eased * math.pi) * flightLimit;
    }
    final start = layout.launchCenter;
    final end = layout.planetCenter - Offset(24 * layout.unit, 0);
    final center = Offset.lerp(start, end, travel)!;
    final bob =
        flying ? math.sin(flight * math.pi * 8) * 1.5 * layout.unit : 0.0;
    final unit = layout.unit;
    canvas.save();
    canvas.translate(center.dx, center.dy + bob);
    canvas.rotate(math.pi / 2);
    if (flying && travel > 0.01) {
      final flame = Path()
        ..moveTo(-8 * unit, 22 * unit)
        ..quadraticBezierTo(
            0, (37 + 8 * math.sin(flight * 30)) * unit, 8 * unit, 22 * unit)
        ..close();
      canvas.drawPath(flame, Paint()..color = const Color(0xFFFFC247));
    }
    final body = Path()
      ..moveTo(0, -30 * unit)
      ..quadraticBezierTo(18 * unit, -13 * unit, 12 * unit, 20 * unit)
      ..lineTo(-12 * unit, 20 * unit)
      ..quadraticBezierTo(-18 * unit, -13 * unit, 0, -30 * unit)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFF4F7FA));
    canvas.drawPath(
      Path()
        ..moveTo(-11 * unit, 8 * unit)
        ..lineTo(-22 * unit, 23 * unit)
        ..lineTo(-9 * unit, 19 * unit)
        ..close(),
      Paint()..color = accent,
    );
    canvas.drawPath(
      Path()
        ..moveTo(11 * unit, 8 * unit)
        ..lineTo(22 * unit, 23 * unit)
        ..lineTo(9 * unit, 19 * unit)
        ..close(),
      Paint()..color = accent,
    );
    canvas.drawCircle(Offset(0, -7 * unit), 6 * unit,
        Paint()..color = const Color(0xFF5EC8E5));
    canvas.restore();
  }

  void _drawSuccess(Canvas canvas, _FinalOrbitLayout layout) {
    final fade = (1 - success).clamp(0.0, 1.0);
    for (var i = 0; i < 18; i++) {
      final angle = i * math.pi * 2 / 18 + i * 0.17;
      final distance = layout.size.height * (0.12 + success * 0.28);
      final point = layout.planetCenter +
          Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawCircle(
        point,
        (2.2 + i % 3) * layout.unit * fade,
        Paint()
          ..color = (i.isEven ? accent : const Color(0xFFFFE375))
              .withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FinalOrbitPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.ambient != ambient ||
      oldDelegate.tileAngles != tileAngles ||
      oldDelegate.flight != flight ||
      oldDelegate.flightLimit != flightLimit ||
      oldDelegate.flying != flying ||
      oldDelegate.successfulFlight != successfulFlight ||
      oldDelegate.solved != solved ||
      oldDelegate.success != success;
}
