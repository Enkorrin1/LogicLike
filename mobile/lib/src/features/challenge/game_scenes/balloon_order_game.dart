import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BalloonOrderGameView extends StatefulWidget {
  const BalloonOrderGameView({
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
  State<BalloonOrderGameView> createState() => _BalloonOrderGameViewState();
}

class _BalloonOrderGameViewState extends State<BalloonOrderGameView>
    with TickerProviderStateMixin {
  late final AnimationController _ambient;
  late final AnimationController _reaction;
  final Set<int> _popped = <int>{};
  int _nextSize = 0;
  int? _burstIndex;
  int? _wrongIndex;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
  }

  @override
  void dispose() {
    _ambient.dispose();
    _reaction.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (_answerSent || _reaction.isAnimating || size.isEmpty) return;
    final point = _toBoard(details.localPosition, size);
    final index = _balloons.lastIndexWhere((balloon) {
      if (_popped.contains(balloon.sizeRank)) return false;
      final center = _floatingCenter(balloon, _ambient.value);
      final dx = (point.dx - center.dx) / balloon.radius;
      final dy = (point.dy - center.dy) / (balloon.radius * 1.18);
      return dx * dx + dy * dy <= 1.25;
    });
    if (index < 0) return;

    _selectBalloon(_balloons[index].sizeRank);
  }

  void _selectBalloon(int rank) {
    if (_answerSent || _reaction.isAnimating) return;
    if (rank != _nextSize) {
      HapticFeedback.selectionClick();
      setState(() {
        _wrongIndex = rank;
        _burstIndex = null;
      });
      _reaction.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _wrongIndex = null);
      });
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _popped.add(rank);
      _nextSize++;
      _burstIndex = rank;
      _wrongIndex = null;
    });
    _reaction.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      setState(() => _burstIndex = null);
      if (_nextSize == _balloons.length && !_answerSent) {
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      }
    });
  }

  Offset _toBoard(Offset point, Size size) {
    final scale =
        math.min(size.width / _board.width, size.height / _board.height);
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    return (point - origin) / scale;
  }

  @override
  Widget build(BuildContext context) {
    final semantics =
        _BalloonSemantics.forLocale(Localizations.localeOf(context));
    return Semantics(
      label: '${widget.semanticLabel}. ${semantics.instruction}',
      hint: semantics.progress(_nextSize),
      button: true,
      onTap: _answerSent ? null : () => _selectBalloon(_nextSize),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 250,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_ambient, _reaction]),
                    builder: (context, _) => CustomPaint(
                      painter: _BalloonOrderPainter(
                        accent: widget.accent,
                        ambient: _ambient.value,
                        reaction: _reaction.value,
                        popped: _popped,
                        burstIndex: _burstIndex,
                        wrongIndex: _wrongIndex,
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

const _board = Size(360, 240);

class _BalloonData {
  const _BalloonData(
      this.sizeRank, this.center, this.radius, this.color, this.phase);

  final int sizeRank;
  final Offset center;
  final double radius;
  final Color color;
  final double phase;
}

const _balloons = <_BalloonData>[
  _BalloonData(3, Offset(48, 88), 30, Color(0xFF6D7EE8), 0.12),
  _BalloonData(0, Offset(111, 116), 20, Color(0xFFFFC44D), 0.66),
  _BalloonData(4, Offset(181, 76), 35, Color(0xFFEC6784), 0.34),
  _BalloonData(1, Offset(253, 111), 23.5, Color(0xFF54C6A5), 0.88),
  _BalloonData(2, Offset(315, 87), 27, Color(0xFFFF8B55), 0.48),
];

Offset _floatingCenter(_BalloonData balloon, double ambient) {
  final angle = (ambient + balloon.phase) * math.pi * 2;
  return balloon.center + Offset(math.sin(angle) * 2.8, math.cos(angle) * 4.2);
}

class _BalloonOrderPainter extends CustomPainter {
  const _BalloonOrderPainter({
    required this.accent,
    required this.ambient,
    required this.reaction,
    required this.popped,
    required this.burstIndex,
    required this.wrongIndex,
  });

  final Color accent;
  final double ambient;
  final double reaction;
  final Set<int> popped;
  final int? burstIndex;
  final int? wrongIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final scale =
        math.min(size.width / _board.width, size.height / _board.height);
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE6F7FF), Color(0xFFF8FCF2)],
        ).createShader(bounds),
    );
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    _drawBackdrop(canvas);
    for (final balloon in _balloons) {
      if (!popped.contains(balloon.sizeRank)) _drawBalloon(canvas, balloon);
      if (burstIndex == balloon.sizeRank) _drawBurst(canvas, balloon);
    }
    canvas.restore();
  }

  void _drawBackdrop(Canvas canvas) {
    final cloud = Paint()..color = Colors.white.withValues(alpha: 0.72);
    for (final center in const [Offset(48, 38), Offset(296, 43)]) {
      canvas.drawCircle(center, 17, cloud);
      canvas.drawCircle(center + const Offset(20, 3), 13, cloud);
      canvas.drawOval(
          Rect.fromCenter(
              center: center + const Offset(8, 10), width: 52, height: 20),
          cloud);
    }
    final hill = Path()
      ..moveTo(0, 201)
      ..quadraticBezierTo(78, 169, 154, 202)
      ..quadraticBezierTo(260, 163, 360, 197)
      ..lineTo(360, 240)
      ..lineTo(0, 240)
      ..close();
    canvas.drawPath(hill, Paint()..color = const Color(0xFFB9E6A2));
    canvas.drawPath(
      Path()
        ..moveTo(0, 219)
        ..quadraticBezierTo(100, 190, 190, 222)
        ..quadraticBezierTo(280, 195, 360, 215)
        ..lineTo(360, 240)
        ..lineTo(0, 240)
        ..close(),
      Paint()..color = const Color(0xFF78C98B),
    );
  }

  void _drawBalloon(Canvas canvas, _BalloonData balloon) {
    var center = _floatingCenter(balloon, ambient);
    if (wrongIndex == balloon.sizeRank) {
      center += Offset(0, -math.sin(reaction * math.pi) * 18);
    }
    final radius = balloon.radius;
    final body = Path()
      ..moveTo(center.dx, center.dy - radius * 1.18)
      ..cubicTo(
          center.dx + radius * 0.88,
          center.dy - radius,
          center.dx + radius * 1.08,
          center.dy + radius * 0.34,
          center.dx,
          center.dy + radius * 1.12)
      ..cubicTo(
          center.dx - radius * 1.08,
          center.dy + radius * 0.34,
          center.dx - radius * 0.88,
          center.dy - radius,
          center.dx,
          center.dy - radius * 1.18)
      ..close();
    canvas.drawShadow(body, Colors.black.withValues(alpha: 0.25), 5, false);
    canvas.drawPath(body, Paint()..color = balloon.color);
    canvas.drawPath(
      body,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.45, -0.55),
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: 0.42),
            balloon.color.withValues(alpha: 0)
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.2)),
    );
    final knot = Path()
      ..moveTo(center.dx, center.dy + radius * 1.05)
      ..lineTo(center.dx - 5, center.dy + radius * 1.32)
      ..lineTo(center.dx + 5, center.dy + radius * 1.32)
      ..close();
    canvas.drawPath(
        knot, Paint()..color = balloon.color.withValues(alpha: 0.9));
    final string = Paint()
      ..color = const Color(0xFF647C7A).withValues(alpha: 0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final start = Offset(center.dx, center.dy + radius * 1.3);
    canvas.drawPath(
      Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(start.dx + 10, 184, start.dx - 2, 221),
      string,
    );
  }

  void _drawBurst(Canvas canvas, _BalloonData balloon) {
    final center = _floatingCenter(balloon, ambient);
    final t = Curves.easeOutCubic.transform(reaction);
    final fade = (1 - reaction).clamp(0.0, 1.0);
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi * 2 / 16 + balloon.phase;
      final distance = balloon.radius * (0.35 + t * 1.75);
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * distance;
      final paint = Paint()
        ..color = (i.isEven ? balloon.color : accent).withValues(alpha: fade);
      if (i % 3 == 0) {
        canvas.drawCircle(point, 2.5 + fade * 2.2, paint);
      } else {
        canvas.save();
        canvas.translate(point.dx, point.dy);
        canvas.rotate(angle);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromCenter(
                    center: Offset.zero, width: 8 * fade, height: 3.5),
                const Radius.circular(2)),
            paint);
        canvas.restore();
      }
    }
    canvas.drawCircle(
      center,
      balloon.radius * (0.5 + t * 1.25),
      Paint()
        ..color = balloon.color.withValues(alpha: fade * 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * fade,
    );
  }

  @override
  bool shouldRepaint(covariant _BalloonOrderPainter oldDelegate) => true;
}

class _BalloonSemantics {
  const _BalloonSemantics(this.instruction, this.remaining);

  final String instruction;
  final String remaining;

  String progress(int popped) => '$remaining ${5 - popped}';

  static _BalloonSemantics forLocale(Locale locale) =>
      _localized[locale.languageCode] ?? _localized['en']!;

  static const _localized = <String, _BalloonSemantics>{
    'ar': _BalloonSemantics(
        'افقع البالونات من الأصغر إلى الأكبر', 'البالونات المتبقية'),
    'de': _BalloonSemantics(
        'Lass die Ballons vom kleinsten zum größten platzen',
        'Verbleibende Ballons'),
    'en': _BalloonSemantics(
        'Pop the balloons from smallest to largest', 'Balloons remaining'),
    'es': _BalloonSemantics('Revienta los globos del más pequeño al más grande',
        'Globos restantes'),
    'fr': _BalloonSemantics(
        'Éclate les ballons du plus petit au plus grand', 'Ballons restants'),
    'hi': _BalloonSemantics(
        'गुब्बारों को सबसे छोटे से सबसे बड़े क्रम में फोड़ें',
        'बचे हुए गुब्बारे'),
    'it': _BalloonSemantics(
        'Scoppia i palloncini dal più piccolo al più grande',
        'Palloncini rimasti'),
    'ja': _BalloonSemantics('小さい風船から順に割ってください', '残りの風船'),
    'ko': _BalloonSemantics('가장 작은 풍선부터 가장 큰 풍선까지 터뜨리세요', '남은 풍선'),
    'pt': _BalloonSemantics(
        'Estoure os balões do menor para o maior', 'Balões restantes'),
    'ru': _BalloonSemantics(
        'Лопайте шары от самого маленького к самому большому',
        'Осталось шаров'),
    'zh': _BalloonSemantics('按从小到大的顺序戳破气球', '剩余气球'),
  };
}
