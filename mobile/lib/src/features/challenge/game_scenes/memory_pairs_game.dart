import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class MemoryPairsGameView extends StatefulWidget {
  const MemoryPairsGameView({
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
  State<MemoryPairsGameView> createState() => _MemoryPairsGameViewState();
}

class _MemoryPairsGameViewState extends State<MemoryPairsGameView>
    with TickerProviderStateMixin {
  static const _pairs = <int>[0, 1, 2, 1, 2, 0];

  late final List<AnimationController> _flips;
  late final AnimationController _success;
  final Set<int> _matched = {};
  final List<int> _selected = [];
  Timer? _previewTimer;
  Timer? _mismatchTimer;
  Timer? _completionTimer;
  bool _previewing = true;
  bool _checking = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _flips = List.generate(
      6,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 360),
        value: 1,
      ),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _previewTimer = Timer(const Duration(milliseconds: 1450), _hidePreview);
  }

  Future<void> _hidePreview() async {
    if (!mounted) return;
    await Future.wait<void>([
      for (final controller in _flips) controller.reverse(),
    ]);
    if (mounted) setState(() => _previewing = false);
  }

  void _selectCard(int index) {
    if (_previewing ||
        _checking ||
        _answerSent ||
        _matched.contains(index) ||
        _selected.contains(index) ||
        _flips[index].isAnimating) {
      return;
    }

    setState(() => _selected.add(index));
    _flips[index].forward();
    if (_selected.length < 2) return;

    _checking = true;
    final first = _selected[0];
    final second = _selected[1];
    if (_pairs[first] == _pairs[second]) {
      _matched.addAll([first, second]);
      _selected.clear();
      _checking = false;
      _success.forward(from: 0);
      setState(() {});
      if (_matched.length == _pairs.length) _completeGame();
      return;
    }

    _mismatchTimer = Timer(const Duration(milliseconds: 780), () {
      if (!mounted) return;
      _flips[first].reverse();
      _flips[second].reverse();
      setState(() {
        _selected.clear();
        _checking = false;
      });
    });
  }

  void _completeGame() {
    _completionTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    _mismatchTimer?.cancel();
    _completionTimer?.cancel();
    for (final controller in _flips) {
      controller.dispose();
    }
    _success.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animations = Listenable.merge([..._flips, _success]);
    return Semantics(
      label: widget.semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: AnimatedBuilder(
              animation: animations,
              builder: (context, _) => CustomPaint(
                painter: _MemoryPairsPainter(
                  accent: widget.accent,
                  pairs: _pairs,
                  flips: [for (final controller in _flips) controller.value],
                  matched: _matched,
                  success: _success.value,
                  allMatched: _matched.length == _pairs.length,
                ),
                child: _MemoryPairsHitGrid(onTap: _selectCard),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MemoryPairsHitGrid extends StatelessWidget {
  const _MemoryPairsHitGrid({required this.onTap});

  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 24.0;
        const verticalPadding = 20.0;
        const bottomPadding = 22.0;
        const gap = 12.0;
        final cardWidth =
            (constraints.maxWidth - horizontalPadding * 2 - gap * 2) / 3;
        final cardHeight =
            (constraints.maxHeight - verticalPadding - bottomPadding - gap) / 2;
        return Stack(
          children: [
            for (var index = 0; index < 6; index++)
              Positioned(
                left: horizontalPadding + (index % 3) * (cardWidth + gap),
                top: verticalPadding + (index ~/ 3) * (cardHeight + gap),
                width: cardWidth,
                height: cardHeight,
                child: Semantics(
                  button: true,
                  excludeSemantics: true,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => onTap(index),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MemoryPairsPainter extends CustomPainter {
  const _MemoryPairsPainter({
    required this.accent,
    required this.pairs,
    required this.flips,
    required this.matched,
    required this.success,
    required this.allMatched,
  });

  final Color accent;
  final List<int> pairs;
  final List<double> flips;
  final Set<int> matched;
  final double success;
  final bool allMatched;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4FBFF), Color(0xFFFFF4E8)],
        ).createShader(bounds),
    );
    _drawBackdrop(canvas, size);

    const horizontalPadding = 24.0;
    const verticalPadding = 20.0;
    const gap = 12.0;
    final cardWidth = (size.width - horizontalPadding * 2 - gap * 2) / 3;
    final cardHeight = (size.height - verticalPadding - 22 - gap) / 2;
    for (var index = 0; index < 6; index++) {
      final column = index % 3;
      final row = index ~/ 3;
      final rect = Rect.fromLTWH(
        horizontalPadding + column * (cardWidth + gap),
        verticalPadding + row * (cardHeight + gap),
        cardWidth,
        cardHeight,
      );
      _drawCard(canvas, rect, index);
    }

    if (allMatched) _drawCelebration(canvas, size);
  }

  void _drawBackdrop(Canvas canvas, Size size) {
    final dot = Paint()..color = accent.withValues(alpha: 0.09);
    for (var i = 0; i < 18; i++) {
      final x = size.width * ((0.07 + i * 0.197) % 0.92);
      final y = size.height * ((0.08 + i * 0.283) % 0.90);
      canvas.drawCircle(Offset(x, y), i.isEven ? 2.2 : 1.3, dot);
    }
  }

  void _drawCard(Canvas canvas, Rect rect, int index) {
    final progress = Curves.easeInOutCubic.transform(flips[index]);
    final scaleX = (math.cos(progress * math.pi)).abs().clamp(0.035, 1.0);
    final faceUp = progress >= 0.5;
    final matchLift = matched.contains(index) ? math.sin(success * math.pi) : 0;

    canvas.save();
    canvas.translate(rect.center.dx, rect.center.dy - matchLift * 4);
    canvas.scale(scaleX, 1 + matchLift * 0.05);
    canvas.translate(-rect.center.dx, -rect.center.dy);

    final radius = Radius.circular(math.min(14, rect.width * 0.16));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(const Offset(0, 5)), radius),
      Paint()..color = const Color(0xFF26384A).withValues(alpha: 0.13),
    );
    if (faceUp) {
      _drawFace(canvas, rect, radius, pairs[index], matched.contains(index));
    } else {
      _drawBack(canvas, rect, radius);
    }
    canvas.restore();
  }

  void _drawBack(Canvas canvas, Rect rect, Radius radius) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, radius),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, Color.lerp(accent, const Color(0xFF253B68), 0.48)!],
        ).createShader(rect),
    );
    final inset = rect.deflate(math.max(7, rect.width * 0.09));
    canvas.drawRRect(
      RRect.fromRectAndRadius(inset, Radius.circular(radius.x * 0.65)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final center = rect.center;
    final petal = Paint()..color = Colors.white.withValues(alpha: 0.72);
    for (var i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      canvas.drawOval(
        Rect.fromCenter(
          center: center + Offset(math.cos(angle), math.sin(angle)) * 9,
          width: 8,
          height: 13,
        ),
        petal,
      );
    }
    canvas.drawCircle(center, 5, Paint()..color = const Color(0xFFFFD76B));
  }

  void _drawFace(
      Canvas canvas, Rect rect, Radius radius, int pair, bool found) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, radius),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: found
              ? [const Color(0xFFE7FFF2), const Color(0xFFBCEFD5)]
              : [Colors.white, const Color(0xFFF5F7FB)],
        ).createShader(rect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1), radius),
      Paint()
        ..color =
            found ? const Color(0xFF54C58B) : accent.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = found ? 2.5 : 1.2,
    );
    final symbolSize = math.min(rect.width, rect.height) * 0.58;
    switch (pair) {
      case 0:
        _drawSun(canvas, rect.center, symbolSize);
        return;
      case 1:
        _drawPlanet(canvas, rect.center, symbolSize);
        return;
      case 2:
        _drawGem(canvas, rect.center, symbolSize);
        return;
    }
  }

  void _drawSun(Canvas canvas, Offset center, double size) {
    final rayPaint = Paint()
      ..color = const Color(0xFFFFA83D)
      ..strokeWidth = size * 0.09
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(center + direction * size * 0.34,
          center + direction * size * 0.48, rayPaint);
    }
    canvas.drawCircle(
        center, size * 0.29, Paint()..color = const Color(0xFFFFC94E));
    canvas.drawCircle(center.translate(-size * 0.08, -size * 0.09),
        size * 0.055, Paint()..color = Colors.white.withValues(alpha: 0.75));
  }

  void _drawPlanet(Canvas canvas, Offset center, double size) {
    canvas.save();
    canvas.rotate(-0.28);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: size, height: size * 0.34),
      Paint()
        ..color = const Color(0xFF7567D8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.10,
    );
    canvas.restore();
    canvas.drawCircle(
        center, size * 0.29, Paint()..color = const Color(0xFF7ED6D1));
    canvas.drawCircle(center.translate(size * 0.09, -size * 0.08), size * 0.08,
        Paint()..color = Colors.white.withValues(alpha: 0.55));
  }

  void _drawGem(Canvas canvas, Offset center, double size) {
    final path = Path()
      ..moveTo(center.dx, center.dy - size * 0.46)
      ..lineTo(center.dx + size * 0.40, center.dy - size * 0.14)
      ..lineTo(center.dx + size * 0.25, center.dy + size * 0.40)
      ..lineTo(center.dx - size * 0.25, center.dy + size * 0.40)
      ..lineTo(center.dx - size * 0.40, center.dy - size * 0.14)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFF7190));
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - size * 0.40, center.dy - size * 0.14)
        ..lineTo(center.dx, center.dy + size * 0.40)
        ..lineTo(center.dx + size * 0.40, center.dy - size * 0.14)
        ..moveTo(center.dx - size * 0.40, center.dy - size * 0.14)
        ..lineTo(center.dx + size * 0.40, center.dy - size * 0.14),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.48)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.045,
    );
  }

  void _drawCelebration(Canvas canvas, Size size) {
    final eased = Curves.easeOut.transform(success);
    final fade = (1 - success).clamp(0.0, 1.0);
    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi * 2 / 12;
      final origin = Offset(size.width / 2, size.height / 2);
      final point = origin +
          Offset(math.cos(angle), math.sin(angle)) *
              (size.height * (0.22 + eased * 0.30));
      canvas.drawCircle(
        point,
        i.isEven ? 4 : 3,
        Paint()
          ..color = (i % 3 == 0
                  ? const Color(0xFFFFC94E)
                  : i % 3 == 1
                      ? accent
                      : const Color(0xFF54C58B))
              .withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MemoryPairsPainter oldDelegate) => true;
}
