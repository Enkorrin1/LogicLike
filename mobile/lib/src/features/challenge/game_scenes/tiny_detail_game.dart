import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TinyDetailGameView extends StatefulWidget {
  const TinyDetailGameView({
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
  State<TinyDetailGameView> createState() => _TinyDetailGameViewState();
}

class _TinyDetailGameViewState extends State<TinyDetailGameView>
    with TickerProviderStateMixin {
  late final AnimationController _ambient;
  late final AnimationController _miss;
  late final AnimationController _success;

  Offset _lens = const Offset(112, 158);
  Offset _dragAnchor = Offset.zero;
  bool _dragging = false;
  bool _solved = false;
  bool _answerSent = false;
  int _round = 0;
  final Set<int> _found = <int>{};

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _miss = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 980),
    );
  }

  @override
  void dispose() {
    _ambient.dispose();
    _miss.dispose();
    _success.dispose();
    super.dispose();
  }

  Offset _toBoard(Offset local, Size size) {
    final scale = math.min(
      size.width / _board.width,
      size.height / _board.height,
    );
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    return (local - origin) / scale;
  }

  void _onPanStart(DragStartDetails details, Size size) {
    if (_solved || _miss.isAnimating) return;
    final point = _toBoard(details.localPosition, size);
    if ((point - _lens).distance > _lensRadius + 20) return;
    _dragAnchor = point - _lens;
    setState(() => _dragging = true);
    HapticFeedback.selectionClick();
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (!_dragging) return;
    final point = _toBoard(details.localPosition, size) - _dragAnchor;
    setState(() {
      _lens = Offset(
        point.dx.clamp(_lensRadius + 4, _board.width - _lensRadius - 4),
        point.dy.clamp(104, _board.height - _lensRadius - 4),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_dragging) return;
    setState(() => _dragging = false);
    _checkSelection();
  }

  void _onTap(TapUpDetails details, Size size) {
    if (_solved || _dragging || _miss.isAnimating) return;
    final point = _toBoard(details.localPosition, size);
    if (point.dy < 96) return;
    setState(() {
      _lens = Offset(
        point.dx.clamp(_lensRadius + 4, _board.width - _lensRadius - 4),
        point.dy.clamp(104, _board.height - _lensRadius - 4),
      );
    });
    _checkSelection();
  }

  Future<void> _checkSelection() async {
    final target = _targets[_round];
    if ((_lens - target).distance <= 24) {
      setState(() {
        _found.add(_round);
        _solved = _found.length == _targets.length;
        _lens = target;
      });
      HapticFeedback.mediumImpact();
      await _success.forward(from: 0);
      if (!mounted) return;
      if (!_solved) {
        setState(() {
          _round += 1;
          _lens = _round == 1 ? const Offset(74, 128) : const Offset(278, 192);
        });
        _success.reset();
        return;
      }
      if (_answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
      return;
    }
    HapticFeedback.lightImpact();
    await _miss.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final semantics = _TinyDetailSemantics.forLocale(
      Localizations.localeOf(context),
    );
    return Semantics(
      label: '${widget.semanticLabel}. ${semantics.instruction}',
      hint: _solved ? semantics.done : semantics.hint,
      value: 'round:$_round',
      button: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 248,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  key: const ValueKey('tiny-detail-surface'),
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) => _onPanStart(details, size),
                  onPanUpdate: (details) => _onPanUpdate(details, size),
                  onPanEnd: _onPanEnd,
                  onPanCancel: () => setState(() => _dragging = false),
                  onTapUp: (details) => _onTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_ambient, _miss, _success]),
                    builder: (context, _) => Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _TinyDetailPainter(
                              accent: widget.accent,
                              ambient: _ambient.value,
                              lens: _lens,
                              dragging: _dragging,
                              miss: _miss.value,
                              success: _success.value,
                              solved: _solved,
                              target: _targets[_round],
                              found: Set<int>.of(_found),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: _detailTargetRect(size, _targets[_round], 24),
                          child: GestureDetector(
                            key: ValueKey('tiny-detail-target-$_round'),
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() => _lens = _targets[_round]);
                              _checkSelection();
                            },
                          ),
                        ),
                      ],
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
const _targets = <Offset>[Offset(250, 159), Offset(119, 159), Offset(235, 181)];
const _lensRadius = 31.0;

Rect _detailTargetRect(Size size, Offset point, double radius) {
  final scale = math.min(
    size.width / _board.width,
    size.height / _board.height,
  );
  final origin = Offset(
    (size.width - _board.width * scale) / 2,
    (size.height - _board.height * scale) / 2,
  );
  return Rect.fromCircle(
    center: origin + point * scale,
    radius: radius * scale,
  );
}

class _TinyDetailPainter extends CustomPainter {
  const _TinyDetailPainter({
    required this.accent,
    required this.ambient,
    required this.lens,
    required this.dragging,
    required this.miss,
    required this.success,
    required this.solved,
    required this.target,
    required this.found,
  });

  final Color accent;
  final double ambient;
  final Offset lens;
  final bool dragging;
  final double miss;
  final double success;
  final bool solved;
  final Offset target;
  final Set<int> found;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(
      size.width / _board.width,
      size.height / _board.height,
    );
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF102842), Color(0xFF1F4960), Color(0xFF173348)],
        ).createShader(bounds),
    );
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    _drawStars(canvas);
    _drawSample(canvas);
    final shake = !solved && miss > 0 && miss < 1
        ? math.sin(miss * math.pi * 5) * (1 - miss) * 4
        : 0.0;
    canvas.save();
    canvas.translate(shake, 0);
    _drawSatellite(canvas);
    canvas.restore();
    _drawLens(canvas);
    if (solved) _drawSuccess(canvas);
    canvas.restore();
  }

  void _drawStars(Canvas canvas) {
    for (var i = 0; i < 28; i++) {
      final point = Offset((13 + i * 79) % 354.0, (9 + i * 43) % 232.0);
      final glow = 0.22 + 0.28 * math.sin(ambient * math.pi * 2 + i * 0.7);
      canvas.drawCircle(
        point,
        i % 7 == 0 ? 1.4 : 0.7,
        Paint()..color = Colors.white.withValues(alpha: glow.abs()),
      );
    }
  }

  void _drawSample(Canvas canvas) {
    final panel = RRect.fromRectAndRadius(
      const Rect.fromLTWH(112, 8, 136, 74),
      const Radius.circular(16),
    );
    canvas.drawRRect(
      panel.shift(const Offset(0, 3)),
      Paint()..color = Colors.black.withValues(alpha: 0.22),
    );
    canvas.drawRRect(panel, Paint()..color = const Color(0xFFF1E8D0));
    canvas.drawRRect(
      panel,
      Paint()
        ..color = accent.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.save();
    canvas.clipRRect(panel.deflate(5));
    canvas.translate(180, 45);
    canvas.scale(2.15);
    _drawTargetDetail(canvas, Offset.zero, true);
    canvas.restore();
    canvas.drawLine(
      const Offset(180, 82),
      const Offset(180, 91),
      Paint()
        ..color = const Color(0xFFE9D596)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawSatellite(Canvas canvas) {
    if (solved) {
      final pulse = 0.22 + 0.16 * math.sin(success * math.pi * 4).abs();
      canvas.drawCircle(
        const Offset(180, 164),
        100 + success * 8,
        Paint()
          ..color = accent.withValues(alpha: pulse)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 13),
      );
    }
    final metal = Paint()..color = const Color(0xFFD8D3C0);
    final dark = Paint()..color = const Color(0xFF405668);
    canvas.drawLine(
      const Offset(86, 150),
      const Offset(58, 123),
      dark..strokeWidth = 7,
    );
    canvas.drawLine(const Offset(274, 150), const Offset(302, 123), dark);
    _drawSolarPanel(canvas, const Rect.fromLTWH(15, 105, 72, 48));
    _drawSolarPanel(canvas, const Rect.fromLTWH(273, 105, 72, 48));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(92, 112, 176, 96),
        const Radius.circular(27),
      ),
      Paint()..color = const Color(0xFF263E50),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(98, 107, 164, 94),
        const Radius.circular(24),
      ),
      metal,
    );
    canvas.drawPath(
      Path()
        ..moveTo(115, 111)
        ..lineTo(144, 92)
        ..lineTo(216, 92)
        ..lineTo(245, 111)
        ..close(),
      Paint()..color = const Color(0xFF92AEB2),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(137, 122, 86, 65),
        const Radius.circular(14),
      ),
      Paint()..color = const Color(0xFF536C73),
    );
    canvas.drawCircle(
      const Offset(180, 154),
      25,
      Paint()..color = const Color(0xFF223D51),
    );
    canvas.drawCircle(
      const Offset(180, 154),
      17,
      Paint()..color = const Color(0xFF71BDD0),
    );
    canvas.drawCircle(
      const Offset(173, 147),
      7,
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
    _drawGear(canvas, const Offset(119, 159), 17, 8);
    _drawGear(canvas, const Offset(235, 181), 13, 7);
    for (var index = 0; index < _targets.length; index++) {
      _drawTargetDetail(canvas, _targets[index], found.contains(index));
    }
    _drawPipe(canvas, const Offset(117, 187), const Offset(151, 181));
    _drawPipe(canvas, const Offset(211, 123), const Offset(244, 137));
    for (final point in const [
      Offset(112, 128),
      Offset(127, 120),
      Offset(246, 124),
      Offset(252, 190),
    ]) {
      canvas.drawCircle(point, 3.2, Paint()..color = const Color(0xFF6B7880));
      canvas.drawLine(
        point - const Offset(2, 0),
        point + const Offset(2, 0),
        Paint()..color = const Color(0xFFCDD7CF),
      );
    }
    canvas.drawLine(
      const Offset(145, 201),
      const Offset(133, 222),
      dark..strokeWidth = 6,
    );
    canvas.drawLine(const Offset(215, 201), const Offset(227, 222), dark);
    canvas.drawCircle(
      const Offset(133, 224),
      7,
      Paint()..color = const Color(0xFFEEB85A),
    );
    canvas.drawCircle(
      const Offset(227, 224),
      7,
      Paint()..color = const Color(0xFFEEB85A),
    );
  }

  void _drawSolarPanel(Canvas canvas, Rect rect) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()..color = const Color(0xFF1E2C50),
    );
    final grid = Paint()
      ..color = const Color(0xFF6688A9)
      ..strokeWidth = 1.3;
    for (var i = 1; i < 4; i++) {
      final x = rect.left + rect.width * i / 4;
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), grid);
    }
    for (var i = 1; i < 3; i++) {
      final y = rect.top + rect.height * i / 3;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), grid);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()
        ..color = const Color(0xFF8CC7D1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _drawGear(Canvas canvas, Offset center, double radius, int teeth) {
    final path = Path();
    for (var i = 0; i < teeth * 2; i++) {
      final angle = i * math.pi / teeth;
      final r = i.isEven ? radius + 4 : radius;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * r;
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFE1A94E));
    canvas.drawCircle(
      center,
      radius * 0.42,
      Paint()..color = const Color(0xFF536C73),
    );
  }

  void _drawPipe(Canvas canvas, Offset from, Offset to) {
    canvas.drawLine(
      from,
      to,
      Paint()
        ..color = const Color(0xFFB36D6D)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(from, 4, Paint()..color = const Color(0xFFF2CF79));
    canvas.drawCircle(to, 4, Paint()..color = const Color(0xFFF2CF79));
  }

  void _drawTargetDetail(Canvas canvas, Offset center, bool enlarged) {
    final body = Paint()..color = const Color(0xFFE87A68);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-12, -9, 24, 18),
        const Radius.circular(5),
      ),
      body,
    );
    canvas.drawCircle(
      const Offset(-7, 0),
      3.4,
      Paint()..color = const Color(0xFFFFE48A),
    );
    canvas.drawCircle(
      const Offset(7, 0),
      3.4,
      Paint()..color = const Color(0xFF78D4CD),
    );
    canvas.drawLine(
      const Offset(0, -9),
      const Offset(0, -16),
      Paint()
        ..color = const Color(0xFF3C5260)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      const Offset(0, -17),
      2.6,
      Paint()..color = const Color(0xFFF3C65D),
    );
    if (enlarged) {
      canvas.drawArc(
        const Rect.fromLTWH(-16, -14, 32, 28),
        -0.9,
        1.4,
        false,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
    }
    canvas.restore();
  }

  void _drawLens(Canvas canvas) {
    final rejected = !solved && miss > 0 && miss < 1;
    final ringColor = rejected
        ? const Color(0xFFE9A8A0)
        : solved
            ? const Color(0xFFFFE77C)
            : const Color(0xFFE8D99F);
    canvas.drawCircle(
      lens + const Offset(2, 3),
      _lensRadius + 3,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );
    canvas.drawCircle(
      lens,
      _lensRadius,
      Paint()..color = const Color(0xFFBCEBF0).withValues(alpha: 0.13),
    );
    canvas.drawCircle(
      lens,
      _lensRadius + (dragging ? 3 : 1),
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
    canvas.drawLine(
      lens + const Offset(22, 22),
      lens + const Offset(43, 43),
      Paint()
        ..color = const Color(0xFF9C6470)
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      lens + const Offset(23, 23),
      lens + const Offset(42, 42),
      Paint()
        ..color = const Color(0xFFE69A8A)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      lens - const Offset(8, 0),
      lens + const Offset(8, 0),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..strokeWidth = 1.5,
    );
    canvas.drawLine(
      lens - const Offset(0, 8),
      lens + const Offset(0, 8),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..strokeWidth = 1.5,
    );
  }

  void _drawSuccess(Canvas canvas) {
    final t = Curves.easeOutCubic.transform(success);
    canvas.drawCircle(
      target,
      23 + t * 45,
      Paint()
        ..color = const Color(
          0xFFFFE77C,
        ).withValues(alpha: (1 - success) * 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 * (1 - success),
    );
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi / 8;
      final point = const Offset(180, 163) +
          Offset(math.cos(angle), math.sin(angle)) * (65 + t * 55);
      canvas.drawCircle(
        point,
        2.5 * (1 - success * 0.5),
        Paint()..color = i.isEven ? accent : const Color(0xFFFFE77C),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TinyDetailPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.ambient != ambient ||
      oldDelegate.lens != lens ||
      oldDelegate.dragging != dragging ||
      oldDelegate.miss != miss ||
      oldDelegate.success != success ||
      oldDelegate.solved != solved ||
      oldDelegate.target != target ||
      oldDelegate.found != found;
}

class _TinyDetailSemantics {
  const _TinyDetailSemantics(this.instruction, this.hint, this.done);

  final String instruction;
  final String hint;
  final String done;

  static _TinyDetailSemantics forLocale(Locale locale) =>
      _localized[locale.languageCode] ?? _localized['en']!;

  static const _localized = <String, _TinyDetailSemantics>{
    'ar': _TinyDetailSemantics(
      'حرّك العدسة فوق القمر الصناعي وابحث عن التفصيل المطابق للعينة المكبرة',
      'حرّك العدسة ثم ارفع إصبعك لتثبيت المكان',
      'تم العثور على التفصيل الصحيح',
    ),
    'de': _TinyDetailSemantics(
      'Bewege die Lupe über den Satelliten und finde das Detail aus der Vergrößerung',
      'Bewege die Lupe und lasse los, um die Stelle zu wählen',
      'Das passende Detail wurde gefunden',
    ),
    'en': _TinyDetailSemantics(
      'Move the magnifier over the satellite and find the detail shown in the close-up',
      'Move the magnifier, then release to choose the place',
      'The matching detail was found',
    ),
    'es': _TinyDetailSemantics(
      'Mueve la lupa por el satélite y encuentra el detalle de la ampliación',
      'Mueve la lupa y suéltala para elegir el lugar',
      'Se encontró el detalle correcto',
    ),
    'fr': _TinyDetailSemantics(
      'Déplace la loupe sur le satellite et retrouve le détail montré en gros plan',
      'Déplace la loupe puis relâche-la pour choisir cet endroit',
      'Le détail correspondant a été trouvé',
    ),
    'hi': _TinyDetailSemantics(
      'उपग्रह पर आवर्धक लेंस घुमाएँ और बड़े नमूने में दिखाई गई चीज़ खोजें',
      'जगह चुनने के लिए लेंस घुमाकर छोड़ें',
      'सही चीज़ मिल गई',
    ),
    'it': _TinyDetailSemantics(
      'Sposta la lente sul satellite e trova il dettaglio mostrato nell’ingrandimento',
      'Sposta la lente e rilasciala per scegliere il punto',
      'Il dettaglio corrispondente è stato trovato',
    ),
    'ja': _TinyDetailSemantics(
      '虫眼鏡を衛星の上で動かし、拡大見本と同じ部品を見つけてください',
      '虫眼鏡を動かし、指を離して場所を決めます',
      '同じ部品が見つかりました',
    ),
    'ko': _TinyDetailSemantics(
      '돋보기를 위성 위로 움직여 확대된 표본과 같은 부품을 찾으세요',
      '돋보기를 움직인 뒤 손을 떼어 위치를 선택하세요',
      '알맞은 부품을 찾았습니다',
    ),
    'pt': _TinyDetailSemantics(
      'Mova a lupa pelo satélite e encontre o detalhe mostrado na ampliação',
      'Mova a lupa e solte para escolher o local',
      'O detalhe correspondente foi encontrado',
    ),
    'ru': _TinyDetailSemantics(
      'Двигайте лупу по спутнику и найдите деталь с увеличенного образца',
      'Передвиньте лупу и отпустите, чтобы выбрать место',
      'Подходящая деталь найдена',
    ),
    'zh': _TinyDetailSemantics(
      '移动卫星上的放大镜，找到与放大样本相同的零件',
      '移动放大镜，然后松手选定位置',
      '已找到匹配的零件',
    ),
  };
}
