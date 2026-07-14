import 'dart:math' as math;

import 'package:flutter/material.dart';

class TwoDifferencesGameView extends StatefulWidget {
  const TwoDifferencesGameView({
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
  State<TwoDifferencesGameView> createState() => _TwoDifferencesGameViewState();
}

class _TwoDifferencesGameViewState extends State<TwoDifferencesGameView>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _feedbackController;
  late final AnimationController _successController;
  final Set<int> _found = <int>{};
  Offset? _missPosition;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _feedbackController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (_answerSent || _found.length == _DifferenceLayout.targets.length) {
      return;
    }
    final layout = _DifferenceLayout(size);
    final sceneIndex = layout.scenes.indexWhere(
      (scene) => scene.inflate(4).contains(details.localPosition),
    );
    if (sceneIndex < 0) {
      _showMiss(details.localPosition);
      return;
    }

    final scene = layout.scenes[sceneIndex];
    final local = Offset(
      (details.localPosition.dx - scene.left) / scene.width,
      (details.localPosition.dy - scene.top) / scene.height,
    );
    final targetIndex = _DifferenceLayout.targets.indexWhere((target) {
      final dx = (local.dx - target.dx) * scene.width;
      final dy = (local.dy - target.dy) * scene.height;
      return math.sqrt(dx * dx + dy * dy) <= layout.hitRadius;
    });

    if (targetIndex < 0 || _found.contains(targetIndex)) {
      _showMiss(details.localPosition);
      return;
    }

    setState(() => _found.add(targetIndex));
    if (_found.length == _DifferenceLayout.targets.length) {
      _successController.forward(from: 0).whenComplete(() {
        if (!mounted || _answerSent) return;
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      });
    }
  }

  void _showMiss(Offset position) {
    setState(() => _missPosition = position);
    _feedbackController.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _missPosition = null);
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
            height: widget.compact ? 220 : 252,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _introController,
                      _feedbackController,
                      _successController,
                    ]),
                    builder: (context, child) => CustomPaint(
                      painter: _TwoDifferencesPainter(
                        accent: widget.accent,
                        intro: Curves.easeOutBack.transform(
                          _introController.value,
                        ),
                        feedback: Curves.easeOutCubic.transform(
                          _feedbackController.value,
                        ),
                        success: Curves.easeOutCubic.transform(
                          _successController.value,
                        ),
                        found: _found,
                        missPosition: _missPosition,
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

class _DifferenceLayout {
  const _DifferenceLayout(this.size);

  static const targets = <Offset>[
    Offset(0.205, 0.315),
    Offset(0.765, 0.675),
    Offset(0.500, 0.455),
    Offset(0.325, 0.790),
  ];

  final Size size;

  double get gap => math.max(7, size.width * 0.018);
  double get side => math.max(9, size.width * 0.025);
  double get top => size.height * 0.095;
  double get sceneHeight => size.height * 0.82;
  double get sceneWidth => (size.width - side * 2 - gap) / 2;
  double get hitRadius =>
      math.max(17, math.min(sceneWidth, sceneHeight) * 0.105);

  List<Rect> get scenes => [
        Rect.fromLTWH(side, top, sceneWidth, sceneHeight),
        Rect.fromLTWH(side + sceneWidth + gap, top, sceneWidth, sceneHeight),
      ];
}

class _TwoDifferencesPainter extends CustomPainter {
  const _TwoDifferencesPainter({
    required this.accent,
    required this.intro,
    required this.feedback,
    required this.success,
    required this.found,
    required this.missPosition,
  });

  final Color accent;
  final double intro;
  final double feedback;
  final double success;
  final Set<int> found;
  final Offset? missPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF182B50), Color(0xFF315C73), Color(0xFF77A69A)],
        ).createShader(bounds),
    );
    _drawBackdrop(canvas, size);

    final layout = _DifferenceLayout(size);
    for (var index = 0; index < layout.scenes.length; index++) {
      final progress =
          ((intro - index * 0.12) / (1 - index * 0.12)).clamp(0.0, 1.0);
      final rect = layout.scenes[index];
      canvas.save();
      canvas.translate(0, (1 - progress) * 28);
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.scale(0.9 + progress * 0.1, 0.9 + progress * 0.1);
      canvas.translate(-rect.center.dx, -rect.center.dy);
      _drawScene(canvas, rect, alternate: index == 1);
      canvas.restore();
    }

    for (final targetIndex in found) {
      for (final scene in layout.scenes) {
        final center = Offset(
          scene.left + _DifferenceLayout.targets[targetIndex].dx * scene.width,
          scene.top + _DifferenceLayout.targets[targetIndex].dy * scene.height,
        );
        _drawFoundRing(canvas, center, layout.hitRadius * 0.72);
      }
    }

    if (missPosition != null && feedback < 1) {
      final pulse = math.sin(feedback * math.pi);
      canvas.drawCircle(
        missPosition!,
        7 + feedback * 13,
        Paint()
          ..color = const Color(0xFFFFD6C8).withValues(alpha: 0.5 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2,
      );
      final nudge = math.sin(feedback * math.pi * 5) * (1 - feedback) * 3;
      final soft = Paint()
        ..color = Colors.white.withValues(alpha: 0.6 * pulse)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        missPosition!.translate(-5 + nudge, 0),
        missPosition!.translate(5 + nudge, 0),
        soft,
      );
    }

    if (success > 0) _drawSuccess(canvas, size);
  }

  void _drawBackdrop(Canvas canvas, Size size) {
    final star = Paint()..color = Colors.white.withValues(alpha: 0.25);
    for (var i = 0; i < 15; i++) {
      canvas.drawCircle(
        Offset(size.width * ((i * 0.193 + 0.04) % 0.96),
            size.height * (0.035 + (i % 3) * 0.025)),
        i.isEven ? 1.1 : 0.7,
        star,
      );
    }
  }

  void _drawScene(Canvas canvas, Rect rect, {required bool alternate}) {
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(rect, const Radius.circular(15)));
    canvas.translate(rect.left, rect.top);
    canvas.scale(rect.width, rect.height);

    const room = Rect.fromLTWH(0, 0, 1, 1);
    canvas.drawRect(room, Paint()..color = const Color(0xFFE7D9C7));
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 1, 0.73),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB8D7D2), Color(0xFFDCE5D8)],
        ).createShader(const Rect.fromLTWH(0, 0, 1, 0.73)),
    );
    _drawWindow(canvas, alternate: alternate);
    _drawShelf(canvas);
    _drawBed(canvas);
    _drawRobot(canvas, alternate: alternate);
    _drawRoomDetails(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: const Offset(0.5, 0.455),
          width: 0.075,
          height: 0.075,
        ),
        Radius.circular(alternate ? 0.008 : 0.038),
      ),
      Paint()
        ..color = alternate ? const Color(0xFF73AEB5) : const Color(0xFFF4C95D),
    );
    final bedMark = Path();
    if (alternate) {
      bedMark
        ..moveTo(0.325, 0.75)
        ..lineTo(0.36, 0.82)
        ..lineTo(0.29, 0.82)
        ..close();
    } else {
      bedMark.addOval(
        Rect.fromCircle(
          center: const Offset(0.325, 0.79),
          radius: 0.034,
        ),
      );
    }
    canvas.drawPath(bedMark, Paint()..color = const Color(0xFF8E79AA));

    canvas.restore();
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(14)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawWindow(Canvas canvas, {required bool alternate}) {
    final frame = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0.07, 0.08, 0.27, 0.35),
      const Radius.circular(0.025),
    );
    canvas.drawRRect(frame, Paint()..color = const Color(0xFFF4F0E6));
    final glass = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0.09, 0.1, 0.23, 0.31),
      const Radius.circular(0.018),
    );
    canvas.drawRRect(glass, Paint()..color = const Color(0xFF263E68));
    final stars = Paint()..color = const Color(0xFFFFE99A);
    for (final point in const [
      Offset(0.13, 0.16),
      Offset(0.27, 0.19),
      Offset(0.16, 0.35),
      Offset(0.29, 0.31),
    ]) {
      canvas.drawCircle(point, 0.007, stars);
    }
    const planet = Offset(0.205, 0.315);
    canvas.drawCircle(planet, 0.032, Paint()..color = const Color(0xFFF1A86F));
    if (!alternate) {
      canvas.drawOval(
        Rect.fromCenter(center: planet, width: 0.1, height: 0.025),
        Paint()
          ..color = const Color(0xFFFFE2A7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.009,
      );
    }
  }

  void _drawShelf(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.54, 0.11, 0.36, 0.035),
        const Radius.circular(0.01),
      ),
      Paint()..color = const Color(0xFF6B5960),
    );
    final bookColors = [
      const Color(0xFFE46662),
      const Color(0xFFF2C765),
      const Color(0xFF5987A4),
      const Color(0xFF7BAA84),
    ];
    for (var i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0.59 + i * 0.048, 0.045, 0.038, 0.065 + i % 2 * 0.01),
          const Radius.circular(0.006),
        ),
        Paint()..color = bookColors[i],
      );
    }
    canvas.drawCircle(
      const Offset(0.84, 0.085),
      0.035,
      Paint()..color = const Color(0xFF8D74B5),
    );
    canvas.drawCircle(
      const Offset(0.825, 0.075),
      0.007,
      Paint()..color = Colors.white,
    );
  }

  void _drawBed(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.06, 0.61, 0.52, 0.25),
        const Radius.circular(0.035),
      ),
      Paint()..color = const Color(0xFF5D7891),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.08, 0.59, 0.48, 0.19),
        const Radius.circular(0.04),
      ),
      Paint()..color = const Color(0xFFE96F73),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.095, 0.57, 0.2, 0.095),
        const Radius.circular(0.035),
      ),
      Paint()..color = const Color(0xFFFFF5DC),
    );
    final blanket = Path()
      ..moveTo(0.31, 0.59)
      ..quadraticBezierTo(0.43, 0.65, 0.56, 0.62)
      ..lineTo(0.56, 0.78)
      ..lineTo(0.3, 0.78)
      ..close();
    canvas.drawPath(blanket, Paint()..color = const Color(0xFFF4C95D));
    canvas.drawCircle(
      const Offset(0.42, 0.69),
      0.025,
      Paint()..color = const Color(0xFFFFECA8),
    );
  }

  void _drawRobot(Canvas canvas, {required bool alternate}) {
    final shadow = Paint()
      ..color = const Color(0xFF537078).withValues(alpha: 0.2);
    canvas.drawOval(const Rect.fromLTWH(0.64, 0.87, 0.27, 0.055), shadow);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.66, 0.58, 0.21, 0.27),
        const Radius.circular(0.045),
      ),
      Paint()..color = const Color(0xFF73AEB5),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0.68, 0.42, 0.17, 0.18),
        const Radius.circular(0.05),
      ),
      Paint()..color = const Color(0xFFE6ECE4),
    );
    canvas.drawLine(
      const Offset(0.765, 0.42),
      const Offset(0.765, 0.365),
      Paint()
        ..color = const Color(0xFF566B78)
        ..strokeWidth = 0.012
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      const Offset(0.765, 0.35),
      0.018,
      Paint()..color = const Color(0xFFE96F73),
    );
    for (final x in const [0.72, 0.81]) {
      canvas.drawCircle(
        Offset(x, 0.5),
        0.018,
        Paint()..color = const Color(0xFF263E68),
      );
      canvas.drawCircle(
        Offset(x - 0.005, 0.494),
        0.005,
        Paint()..color = Colors.white,
      );
    }
    canvas.drawArc(
      const Rect.fromLTWH(0.73, 0.515, 0.07, 0.045),
      0.15,
      math.pi - 0.3,
      false,
      Paint()
        ..color = const Color(0xFF566B78)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.009,
    );
    canvas.drawCircle(
      const Offset(0.765, 0.675),
      0.038,
      Paint()
        ..color = alternate ? const Color(0xFFEF6A64) : const Color(0xFF55C7A5),
    );
    canvas.drawCircle(
      const Offset(0.752, 0.662),
      0.009,
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );
    final limb = Paint()
      ..color = const Color(0xFF566B78)
      ..strokeWidth = 0.022
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(0.67, 0.67), const Offset(0.61, 0.74), limb);
    canvas.drawLine(const Offset(0.86, 0.67), const Offset(0.91, 0.61), limb);
    canvas.drawLine(const Offset(0.71, 0.84), const Offset(0.69, 0.9), limb);
    canvas.drawLine(const Offset(0.82, 0.84), const Offset(0.84, 0.9), limb);
  }

  void _drawRoomDetails(Canvas canvas) {
    canvas.drawRect(
      const Rect.fromLTWH(0, 0.91, 1, 0.09),
      Paint()..color = const Color(0xFFCFB79D),
    );
    final rug = Paint()
      ..color = const Color(0xFF8E79AA).withValues(alpha: 0.72);
    canvas.drawOval(const Rect.fromLTWH(0.23, 0.86, 0.43, 0.1), rug);
    canvas.drawCircle(
      const Offset(0.52, 0.48),
      0.055,
      Paint()..color = const Color(0xFFF4C95D),
    );
    canvas.drawCircle(
      const Offset(0.5, 0.46),
      0.012,
      Paint()..color = const Color(0xFFE9F0E7),
    );
  }

  void _drawFoundRing(Canvas canvas, Offset center, double radius) {
    final bloom = 1 + math.sin(success * math.pi) * 0.14;
    canvas.drawCircle(
      center,
      radius * bloom,
      Paint()
        ..color = const Color(0xFFFFF3A5).withValues(alpha: 0.23)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius * bloom,
      Paint()
        ..color = Color.lerp(accent, Colors.white, 0.28)!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _drawSuccess(Canvas canvas, Size size) {
    final fade = (1 - success * 0.55).clamp(0.0, 1.0);
    final paint = Paint()..strokeCap = StrokeCap.round;
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi * 2 / 16;
      final distance = size.shortestSide * (0.08 + success * 0.34);
      final center = Offset(size.width / 2, size.height / 2) +
          Offset(math.cos(angle), math.sin(angle)) * distance;
      paint
        ..color = [
          const Color(0xFFFFD65C),
          const Color(0xFF70D2C5),
          const Color(0xFFFF8B82),
          Colors.white,
        ][i % 4]
            .withValues(alpha: fade)
        ..strokeWidth = 3;
      canvas.drawLine(
        center,
        center + Offset(math.cos(angle), math.sin(angle)) * 7,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TwoDifferencesPainter oldDelegate) =>
      oldDelegate.intro != intro ||
      oldDelegate.feedback != feedback ||
      oldDelegate.success != success ||
      oldDelegate.missPosition != missPosition ||
      oldDelegate.accent != accent ||
      oldDelegate.found.length != found.length;
}
