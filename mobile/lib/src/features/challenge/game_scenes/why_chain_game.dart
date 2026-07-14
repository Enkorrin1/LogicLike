import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WhyChainGameView extends StatefulWidget {
  const WhyChainGameView({
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
  State<WhyChainGameView> createState() => _WhyChainGameViewState();
}

enum _ChainPart { battery, fan, cart }

class _WhyChainGameViewState extends State<WhyChainGameView>
    with TickerProviderStateMixin {
  static const _order = [
    _ChainPart.battery,
    _ChainPart.fan,
    _ChainPart.cart,
  ];
  final List<_ChainPart?> _slots = [null, null, null];
  late final AnimationController _error;
  late final AnimationController _run;
  _ChainPart? _wrong;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
    );
    _run = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    _run.dispose();
    super.dispose();
  }

  void _place(int slot, _ChainPart part) {
    if (_run.isAnimating || _answerSent || _slots.contains(part)) return;
    if (_order[slot] != part) {
      HapticFeedback.selectionClick();
      setState(() => _wrong = part);
      _error.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _wrong = null);
      });
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => _slots[slot] = part);
    if (_slots.every((item) => item != null)) {
      _run.forward(from: 0).whenComplete(() {
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
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([_error, _run]),
                      builder: (context, child) => CustomPaint(
                        painter: _WhyChainPainter(
                          accent: widget.accent,
                          slots: _slots,
                          error: _error.value,
                          wrong: _wrong,
                          run: _run.value,
                        ),
                      ),
                    ),
                    for (var slot = 0; slot < 3; slot++)
                      Positioned(
                        left: size.width * (0.16 + slot * 0.27) - 38,
                        top: size.height * 0.25,
                        width: 76,
                        height: 82,
                        child: DragTarget<_ChainPart>(
                          onWillAcceptWithDetails: (_) => _slots[slot] == null,
                          onAcceptWithDetails: (details) =>
                              _place(slot, details.data),
                          builder: (context, candidates, rejected) =>
                              const SizedBox.expand(),
                        ),
                      ),
                    for (var i = 0; i < _order.length; i++)
                      if (!_slots.contains(_order[i]))
                        Positioned(
                          left: size.width * (0.22 + i * 0.28) - 28,
                          bottom: 12,
                          width: 56,
                          height: 56,
                          child: Draggable<_ChainPart>(
                            data: _order[i],
                            feedback: Material(
                              color: Colors.transparent,
                              child: _ChainPartView(
                                part: _order[i],
                                accent: widget.accent,
                                size: 62,
                              ),
                            ),
                            childWhenDragging: const SizedBox.shrink(),
                            child: GestureDetector(
                              onTap: () {
                                final firstEmpty = _slots.indexOf(null);
                                if (firstEmpty >= 0) {
                                  _place(firstEmpty, _order[i]);
                                }
                              },
                              child: _ChainPartView(
                                part: _order[i],
                                accent: widget.accent,
                                size: 56,
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

class _ChainPartView extends StatelessWidget {
  const _ChainPartView({
    required this.part,
    required this.accent,
    required this.size,
  });
  final _ChainPart part;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _ChainPartPainter(part, accent),
      );
}

class _ChainPartPainter extends CustomPainter {
  const _ChainPartPainter(this.part, this.accent);
  final _ChainPart part;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    _WhyChainPainter.drawPart(canvas, part, accent, 0.65);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChainPartPainter oldDelegate) =>
      oldDelegate.part != part || oldDelegate.accent != accent;
}

class _WhyChainPainter extends CustomPainter {
  const _WhyChainPainter({
    required this.accent,
    required this.slots,
    required this.error,
    required this.wrong,
    required this.run,
  });
  final Color accent;
  final List<_ChainPart?> slots;
  final double error;
  final _ChainPart? wrong;
  final double run;

  static void drawPart(
      Canvas canvas, _ChainPart part, Color accent, double scale) {
    canvas.scale(scale);
    switch (part) {
      case _ChainPart.battery:
        final rect = RRect.fromRectAndRadius(
          const Rect.fromLTWH(-30, -22, 60, 44),
          const Radius.circular(10),
        );
        canvas.drawRRect(rect, Paint()..color = const Color(0xFFFFD05E));
        canvas.drawRect(
            const Rect.fromLTWH(30, -9, 8, 18), Paint()..color = Colors.white);
        canvas.drawLine(
            const Offset(-9, 0),
            const Offset(9, 0),
            Paint()
              ..color = accent
              ..strokeWidth = 5);
        canvas.drawLine(
            const Offset(0, -9),
            const Offset(0, 9),
            Paint()
              ..color = accent
              ..strokeWidth = 5);
      case _ChainPart.fan:
        canvas.drawCircle(Offset.zero, 30, Paint()..color = Colors.white);
        for (var i = 0; i < 4; i++) {
          canvas.save();
          canvas.rotate(i * math.pi / 2);
          canvas.drawOval(const Rect.fromLTWH(1, -10, 28, 20),
              Paint()..color = const Color(0xFF62D0C2));
          canvas.restore();
        }
        canvas.drawCircle(Offset.zero, 7, Paint()..color = accent);
      case _ChainPart.cart:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(-30, 4, 60, 26), const Radius.circular(7)),
          Paint()..color = const Color(0xFFFF7186),
        );
        canvas.drawCircle(
            const Offset(-18, 31), 8, Paint()..color = const Color(0xFF24374D));
        canvas.drawCircle(
            const Offset(18, 31), 8, Paint()..color = const Color(0xFF24374D));
        final sail = Path()
          ..moveTo(-2, 3)
          ..lineTo(-2, -38)
          ..lineTo(28, -2)
          ..close();
        canvas.drawPath(sail, Paint()..color = Colors.white);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF173250), Color(0xFF4E7D83)],
        ).createShader(bounds),
    );
    final centers = [
      Offset(size.width * 0.16, size.height * 0.42),
      Offset(size.width * 0.43, size.height * 0.42),
      Offset(size.width * 0.70, size.height * 0.42),
    ];
    for (var i = 0; i < centers.length; i++) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: centers[i], width: 76, height: 82),
        const Radius.circular(18),
      );
      canvas.drawRRect(
          rect, Paint()..color = Colors.white.withValues(alpha: 0.1));
      if (slots[i] != null) {
        canvas.save();
        canvas.translate(centers[i].dx, centers[i].dy);
        if (slots[i] == _ChainPart.fan && run > 0.2) {
          canvas.rotate(run * math.pi * 10);
        }
        drawPart(canvas, slots[i]!, accent, 0.72);
        canvas.restore();
      }
      if (i < 2) {
        canvas.drawLine(
          Offset(centers[i].dx + 42, centers[i].dy),
          Offset(centers[i + 1].dx - 42, centers[i + 1].dy),
          Paint()
            ..color = run > (i + 1) * 0.28
                ? const Color(0xFFFFD05E)
                : Colors.white.withValues(alpha: 0.2)
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round,
        );
      }
    }
    final flagX = size.width * 0.91;
    canvas.drawLine(
        Offset(flagX, size.height * 0.58),
        Offset(flagX, size.height * 0.25),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4);
    final flag = Path()
      ..moveTo(flagX, size.height * 0.25)
      ..lineTo(flagX + 28, size.height * 0.32)
      ..lineTo(flagX, size.height * 0.39)
      ..close();
    canvas.drawPath(flag, Paint()..color = const Color(0xFFFF7186));

    if (run > 0.55) {
      final t = ((run - 0.55) / 0.45).clamp(0.0, 1.0);
      canvas.save();
      canvas.translate(size.width * (0.70 + t * 0.17), size.height * 0.42);
      drawPart(canvas, _ChainPart.cart, accent, 0.72);
      canvas.restore();
    }
    if (wrong != null) {
      final shake = math.sin(error * math.pi * 7) * (1 - error) * 7;
      canvas.save();
      canvas.translate(size.width * 0.5 + shake, size.height * 0.20);
      drawPart(canvas, wrong!, accent, 0.55);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _WhyChainPainter oldDelegate) =>
      oldDelegate.slots.whereType<_ChainPart>().length !=
          slots.whereType<_ChainPart>().length ||
      oldDelegate.error != error ||
      oldDelegate.wrong != wrong ||
      oldDelegate.run != run ||
      oldDelegate.accent != accent;
}
