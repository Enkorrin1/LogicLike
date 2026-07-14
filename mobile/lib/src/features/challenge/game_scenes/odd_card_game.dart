import 'dart:math' as math;

import 'package:flutter/material.dart';

class OddCardGameView extends StatefulWidget {
  const OddCardGameView({
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
  State<OddCardGameView> createState() => _OddCardGameViewState();
}

class _OddCardGameViewState extends State<OddCardGameView>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _ambientController;
  late final AnimationController _feedbackController;
  int? _selectedIndex;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..forward();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _ambientController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (_solved || size.isEmpty) {
      return;
    }
    final cards = _OddCardLayout.cardRects(size);
    final index = cards.indexWhere(
      (rect) => rect.inflate(math.max(5, size.width * 0.012)).contains(
            details.localPosition,
          ),
    );
    if (index < 0) {
      return;
    }

    setState(() {
      _selectedIndex = index;
      _solved = index == _OddCardLayout.oddIndex;
    });
    _feedbackController.forward(from: 0).whenComplete(() {
      if (!mounted || _solved) {
        return;
      }
      setState(() => _selectedIndex = null);
    });

    if (_solved) {
      Future<void>.delayed(const Duration(milliseconds: 620), () {
        if (!mounted || _answerSent) {
          return;
        }
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 214.0 : 242.0;
    return Semantics(
      label: widget.semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _introController,
                      _ambientController,
                      _feedbackController,
                    ]),
                    builder: (context, child) => CustomPaint(
                      painter: _OddCardPainter(
                        accent: widget.accent,
                        intro: Curves.easeOutBack.transform(
                          _introController.value,
                        ),
                        ambient: _ambientController.value,
                        feedback: Curves.easeOut.transform(
                          _feedbackController.value,
                        ),
                        selectedIndex: _selectedIndex,
                        solved: _solved,
                      ),
                      size: size,
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

class _OddCardLayout {
  static const oddIndex = 1;

  static List<Rect> cardRects(Size size) {
    final horizontalPadding = math.max(12.0, size.width * 0.045);
    final gap = math.max(7.0, size.width * 0.022);
    final top = size.height * 0.19;
    final width = (size.width - horizontalPadding * 2 - gap * 3) / 4;
    final height = size.height * 0.67;
    return List.generate(
      4,
      (index) => Rect.fromLTWH(
        horizontalPadding + index * (width + gap),
        top,
        width,
        height,
      ),
    );
  }
}

class _OddCardPainter extends CustomPainter {
  const _OddCardPainter({
    required this.accent,
    required this.intro,
    required this.ambient,
    required this.feedback,
    required this.selectedIndex,
    required this.solved,
  });

  final Color accent;
  final double intro;
  final double ambient;
  final double feedback;
  final int? selectedIndex;
  final bool solved;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF193A4A), Color(0xFF285E61), Color(0xFF8CC9A4)],
          stops: [0, 0.58, 1],
        ).createShader(bounds),
    );
    _drawNightDetails(canvas, size);
    _drawShelf(canvas, size);

    final cards = _OddCardLayout.cardRects(size);
    for (var index = 0; index < cards.length; index++) {
      final delay = index * 0.11;
      final progress = ((intro - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (progress == 0) {
        continue;
      }
      final selected = selectedIndex == index;
      final wrong = selected && !solved;
      final bounce = math.sin(progress * math.pi) * size.height * 0.035;
      final bob = math.sin(ambient * math.pi * 2 + index * 0.9) * 1.3;
      final shake =
          wrong ? math.sin(feedback * math.pi * 7) * (1 - feedback) * 8 : 0.0;
      final scale = selected && solved
          ? 1 + math.sin(feedback * math.pi) * 0.09
          : 0.86 + progress * 0.14;
      canvas.save();
      canvas.translate(shake, -bounce + bob);
      canvas.translate(cards[index].center.dx, cards[index].center.dy);
      canvas.scale(scale, scale);
      canvas.translate(-cards[index].center.dx, -cards[index].center.dy);
      _drawDisplayCard(canvas, cards[index], index, selected);
      canvas.restore();
    }

    if (solved && selectedIndex != null) {
      _drawCelebration(canvas, cards[selectedIndex!].center, size);
    }
  }

  void _drawNightDetails(Canvas canvas, Size size) {
    final moonCenter = Offset(size.width * 0.88, size.height * 0.15);
    canvas.drawCircle(
      moonCenter,
      size.height * 0.085,
      Paint()..color = const Color(0xFFFFE89B).withValues(alpha: 0.92),
    );
    canvas.drawCircle(
      moonCenter.translate(size.height * 0.035, -size.height * 0.018),
      size.height * 0.075,
      Paint()..color = const Color(0xFF193A4A),
    );
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.65);
    for (var i = 0; i < 11; i++) {
      final x = size.width * ((0.06 + i * 0.173) % 0.92);
      final y = size.height * (0.06 + (i * 0.097) % 0.24);
      final radius = 0.8 + (math.sin(ambient * math.pi * 2 + i) + 1) * 0.45;
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
    final hills = Path()
      ..moveTo(0, size.height * 0.66)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.49,
        size.width * 0.38,
        size.height * 0.65,
      )
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.46,
        size.width,
        size.height * 0.63,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hills, Paint()..color = const Color(0xFF4F8D72));
  }

  void _drawShelf(Canvas canvas, Size size) {
    final shelf = Rect.fromLTWH(
      size.width * 0.025,
      size.height * 0.82,
      size.width * 0.95,
      size.height * 0.065,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        shelf.shift(Offset(0, size.height * 0.025)),
        const Radius.circular(5),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(shelf, const Radius.circular(5)),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFDC9A62), Color(0xFF9B583F)],
        ).createShader(shelf),
    );
  }

  void _drawDisplayCard(Canvas canvas, Rect rect, int index, bool selected) {
    final radius = Radius.circular(math.min(16, rect.width * 0.18));
    final shadowRect = rect.shift(Offset(0, rect.height * 0.045));
    canvas.drawRRect(
      RRect.fromRectAndRadius(shadowRect, radius),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );

    final face = RRect.fromRectAndRadius(rect, radius);
    canvas.drawRRect(
      face,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: selected && solved
              ? [const Color(0xFFFFF6C4), const Color(0xFFFFD76D)]
              : [const Color(0xFFFFFCED), const Color(0xFFDFF1DF)],
        ).createShader(rect),
    );
    canvas.drawRRect(
      face,
      Paint()
        ..color = selected
            ? (solved ? const Color(0xFFFFC84A) : const Color(0xFFFF6F6F))
            : Colors.white.withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 3 : 1.2,
    );

    _drawLantern(canvas, rect, odd: index == _OddCardLayout.oddIndex);
    _drawNumber(canvas, rect, index + 1);
  }

  void _drawLantern(Canvas canvas, Rect rect, {required bool odd}) {
    final center = Offset(rect.center.dx, rect.top + rect.height * 0.47);
    final unit = math.min(rect.width, rect.height) / 100;
    final dark = Paint()..color = const Color(0xFF294C53);
    final metal = Paint()
      ..color = const Color(0xFF294C53)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * unit
      ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..color = const Color(0xFFFFCA55).withValues(alpha: 0.20)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * unit);
    canvas.drawCircle(center, 31 * unit, glow);

    final handle = Rect.fromCenter(
      center: center.translate(0, -31 * unit),
      width: 40 * unit,
      height: 35 * unit,
    );
    canvas.drawArc(handle, math.pi, math.pi, false, metal);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, -20 * unit),
          width: 30 * unit,
          height: 10 * unit,
        ),
        Radius.circular(4 * unit),
      ),
      dark,
    );

    final chamber = Rect.fromCenter(
      center: center,
      width: 47 * unit,
      height: 54 * unit,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(chamber, Radius.circular(12 * unit)),
      Paint()..color = const Color(0xFFFFDF78),
    );
    final window = odd
        ? (Path()
          ..moveTo(center.dx, center.dy - 17 * unit)
          ..lineTo(center.dx + 17 * unit, center.dy + 13 * unit)
          ..lineTo(center.dx - 17 * unit, center.dy + 13 * unit)
          ..close())
        : (Path()
          ..addOval(
            Rect.fromCenter(
              center: center,
              width: 30 * unit,
              height: 34 * unit,
            ),
          ));
    canvas.drawPath(window, Paint()..color = const Color(0xFFFFF9C9));
    canvas.drawLine(
      Offset(chamber.left, chamber.top + 8 * unit),
      Offset(chamber.left, chamber.bottom - 7 * unit),
      metal,
    );
    canvas.drawLine(
      Offset(chamber.right, chamber.top + 8 * unit),
      Offset(chamber.right, chamber.bottom - 7 * unit),
      metal,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, 31 * unit),
          width: 58 * unit,
          height: 13 * unit,
        ),
        Radius.circular(5 * unit),
      ),
      dark,
    );
  }

  void _drawNumber(Canvas canvas, Rect rect, int number) {
    final badgeCenter =
        Offset(rect.center.dx, rect.bottom - rect.height * 0.105);
    final radius = math.min(12.0, rect.width * 0.13);
    canvas.drawCircle(badgeCenter, radius, Paint()..color = accent);
    final painter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 1.15,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      badgeCenter - Offset(painter.width / 2, painter.height / 2),
    );
  }

  void _drawCelebration(Canvas canvas, Offset center, Size size) {
    final progress = feedback;
    final paint = Paint()
      ..color = const Color(0xFFFFE277).withValues(alpha: 1 - progress)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 10; i++) {
      final angle = i * math.pi * 2 / 10 - math.pi / 2;
      final inner = size.height * (0.12 + progress * 0.05);
      final outer = size.height * (0.15 + progress * 0.09);
      canvas.drawLine(
        center + Offset(math.cos(angle), math.sin(angle)) * inner,
        center + Offset(math.cos(angle), math.sin(angle)) * outer,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OddCardPainter oldDelegate) =>
      oldDelegate.intro != intro ||
      oldDelegate.ambient != ambient ||
      oldDelegate.feedback != feedback ||
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.solved != solved ||
      oldDelegate.accent != accent;
}
