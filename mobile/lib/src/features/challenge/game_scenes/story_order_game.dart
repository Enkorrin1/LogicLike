import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

class StoryOrderGameView extends StatefulWidget {
  const StoryOrderGameView({
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
  State<StoryOrderGameView> createState() => _StoryOrderGameViewState();
}

enum _StoryMoment { seed, water, flower }

class _StoryOrderGameViewState extends State<StoryOrderGameView>
    with TickerProviderStateMixin {
  static const _correctOrder = <_StoryMoment>[
    _StoryMoment.seed,
    _StoryMoment.water,
    _StoryMoment.flower,
  ];

  final List<_StoryMoment> _order = [
    _StoryMoment.flower,
    _StoryMoment.seed,
    _StoryMoment.water,
  ];
  late final AnimationController _shake;
  late final AnimationController _success;
  Timer? _completionTimer;
  bool _solved = false;
  bool _answerSent = false;
  int? _draggedIndex;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    _shake.dispose();
    _success.dispose();
    super.dispose();
  }

  void _move(int from, int to) {
    if (_solved || from == to || from < 0 || to < 0) return;
    HapticFeedback.selectionClick();
    setState(() {
      final moved = _order.removeAt(from);
      _order.insert(to, moved);
      _draggedIndex = null;
    });
    if (_isCorrect) {
      _complete();
    } else {
      HapticFeedback.lightImpact();
      _shake.forward(from: 0);
    }
  }

  bool get _isCorrect {
    for (var index = 0; index < _correctOrder.length; index++) {
      if (_order[index] != _correctOrder[index]) return false;
    }
    return true;
  }

  void _complete() {
    if (_solved) return;
    setState(() => _solved = true);
    HapticFeedback.mediumImpact();
    _success.forward(from: 0);
    _completionTimer = Timer(const Duration(milliseconds: 720), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = _StorySemantics.forLocale(Localizations.localeOf(context));
    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 218 : 252,
            child: AnimatedBuilder(
              animation: Listenable.merge([_shake, _success]),
              builder: (context, _) {
                final shake = math.sin(_shake.value * math.pi * 7) *
                    (1 - _shake.value) *
                    6;
                return CustomPaint(
                  painter: _StoryBackdropPainter(
                    accent: widget.accent,
                    success: _success.value,
                  ),
                  child: Transform.translate(
                    offset: Offset(shake, 0),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        widget.compact ? 10 : 16,
                        widget.compact ? 28 : 34,
                        widget.compact ? 10 : 16,
                        widget.compact ? 28 : 34,
                      ),
                      child: Row(
                        children: [
                          for (var index = 0;
                              index < _order.length;
                              index++) ...[
                            Expanded(
                              child: _buildSlot(index, labels),
                            ),
                            if (index != _order.length - 1)
                              SizedBox(width: widget.compact ? 8 : 12),
                          ],
                        ],
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

  Widget _buildSlot(int index, _StorySemantics labels) {
    final moment = _order[index];
    final card = _StoryCard(
      moment: moment,
      accent: widget.accent,
      solved: _solved,
      success: _success.value,
    );
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => !_solved && details.data != index,
      onAcceptWithDetails: (details) => _move(details.data, index),
      builder: (context, candidates, rejected) {
        final highlighted = candidates.isNotEmpty;
        return Semantics(
          label: '${labels.moment(moment)}. ${labels.position(index)}',
          hint: labels.hint,
          button: true,
          customSemanticsActions: {
            if (index > 0)
              CustomSemanticsAction(label: labels.moveLeft): () =>
                  _move(index, index - 1),
            if (index < 2)
              CustomSemanticsAction(label: labels.moveRight): () =>
                  _move(index, index + 1),
          },
          child: AnimatedScale(
            scale: highlighted ? 1.035 : 1,
            duration: const Duration(milliseconds: 140),
            child: Draggable<int>(
              data: index,
              maxSimultaneousDrags: _solved ? 0 : 1,
              onDragStarted: () => setState(() => _draggedIndex = index),
              onDragEnd: (_) {
                if (mounted) setState(() => _draggedIndex = null);
              },
              feedback: SizedBox(
                width: 128,
                height: widget.compact ? 154 : 176,
                child: Material(color: Colors.transparent, child: card),
              ),
              childWhenDragging: Opacity(opacity: 0.28, child: card),
              child: AnimatedOpacity(
                opacity: _draggedIndex == index ? 0.45 : 1,
                duration: const Duration(milliseconds: 120),
                child: card,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.moment,
    required this.accent,
    required this.solved,
    required this.success,
  });

  final _StoryMoment moment;
  final Color accent;
  final bool solved;
  final double success;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _StoryFramePainter(
          moment: moment,
          accent: accent,
          solved: solved,
          success: success,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _StoryBackdropPainter extends CustomPainter {
  const _StoryBackdropPainter({required this.accent, required this.success});

  final Color accent;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111D3B), Color(0xFF293A67), Color(0xFF53628A)],
        ).createShader(bounds),
    );
    final stars = Paint()..color = Colors.white.withValues(alpha: 0.55);
    for (var i = 0; i < 22; i++) {
      canvas.drawCircle(
        Offset(
          size.width * ((i * 0.173 + 0.04) % 0.94),
          size.height * ((i * 0.117 + 0.05) % 0.88),
        ),
        i % 4 == 0 ? 1.8 : 1,
        stars,
      );
    }
    if (success == 0) return;
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi * 2 / 16;
      final distance = size.height * (0.12 + success * 0.5);
      final color = i.isEven ? accent : const Color(0xFFFFD45C);
      canvas.drawCircle(
        size.center(Offset.zero) +
            Offset(math.cos(angle), math.sin(angle)) * distance,
        3,
        Paint()..color = color.withValues(alpha: 1 - success),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StoryBackdropPainter oldDelegate) =>
      oldDelegate.accent != accent || oldDelegate.success != success;
}

class _StoryFramePainter extends CustomPainter {
  const _StoryFramePainter({
    required this.moment,
    required this.accent,
    required this.solved,
    required this.success,
  });

  final _StoryMoment moment;
  final Color accent;
  final bool solved;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final bounce = solved ? math.sin(success * math.pi) * 5 : 0.0;
    canvas.save();
    canvas.translate(0, -bounce);
    final rect = Offset.zero & size;
    final radius = Radius.circular(math.min(14, size.width * 0.12));
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(const Offset(0, 5)), radius),
      Paint()..color = Colors.black.withValues(alpha: 0.24),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, radius),
      Paint()..color = const Color(0xFFDFF5FF),
    );
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(rect, radius));
    _drawSky(canvas, size);
    _drawPlanet(canvas, size);
    switch (moment) {
      case _StoryMoment.seed:
        _drawSeed(canvas, size);
      case _StoryMoment.water:
        _drawWater(canvas, size);
      case _StoryMoment.flower:
        _drawFlower(canvas, size);
    }
    canvas.restore();
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1), radius),
      Paint()
        ..color = solved ? const Color(0xFF72E6A6) : Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = solved ? 3 : 2,
    );
    canvas.restore();
  }

  void _drawSky(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF28457C), Color(0xFF77C6D8)],
        ).createShader(Offset.zero & size),
    );
    final star = Paint()..color = Colors.white.withValues(alpha: 0.8);
    for (var i = 0; i < 7; i++) {
      canvas.drawCircle(
        Offset(size.width * ((i * 0.31 + 0.12) % 0.9),
            size.height * (0.08 + (i % 3) * 0.09)),
        i.isEven ? 1.5 : 1,
        star,
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.18),
      size.width * 0.09,
      Paint()..color = const Color(0xFFFFE789),
    );
  }

  void _drawPlanet(Canvas canvas, Size size) {
    final ground = Rect.fromLTWH(
      -size.width * 0.12,
      size.height * 0.62,
      size.width * 1.24,
      size.height * 0.5,
    );
    canvas.drawOval(ground, Paint()..color = const Color(0xFFC88B65));
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.76),
        width: size.width * 0.62,
        height: size.height * 0.18,
      ),
      Paint()..color = const Color(0xFF8E5A49),
    );
  }

  void _drawSeed(Canvas canvas, Size size) {
    final hand = Paint()
      ..color = const Color(0xFFB6D2E8)
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.17, size.height * 0.42),
      Offset(size.width * 0.46, size.height * 0.60),
      hand,
    );
    final seed = Rect.fromCenter(
      center: Offset(size.width * 0.52, size.height * 0.59),
      width: size.width * 0.15,
      height: size.height * 0.10,
    );
    canvas.save();
    canvas.translate(seed.center.dx, seed.center.dy);
    canvas.rotate(-0.4);
    canvas.translate(-seed.center.dx, -seed.center.dy);
    canvas.drawOval(seed, Paint()..color = const Color(0xFFFFD45C));
    canvas.restore();
  }

  void _drawWater(Canvas canvas, Size size) {
    final can = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.13, size.height * 0.31, size.width * 0.42,
          size.height * 0.25),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(can, Paint()..color = accent);
    final spout = Path()
      ..moveTo(size.width * 0.51, size.height * 0.38)
      ..lineTo(size.width * 0.78, size.height * 0.49)
      ..lineTo(size.width * 0.73, size.height * 0.56)
      ..lineTo(size.width * 0.50, size.height * 0.49)
      ..close();
    canvas.drawPath(spout, Paint()..color = accent);
    for (var i = 0; i < 3; i++) {
      final x = size.width * (0.62 + i * 0.09);
      final y = size.height * (0.57 + i * 0.035);
      final drop = Path()
        ..moveTo(x, y - 8)
        ..quadraticBezierTo(x + 8, y + 2, x, y + 7)
        ..quadraticBezierTo(x - 8, y + 2, x, y - 8);
      canvas.drawPath(drop, Paint()..color = const Color(0xFF55C8F3));
    }
  }

  void _drawFlower(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.52, size.height * 0.43);
    canvas.drawLine(
      center,
      Offset(size.width * 0.52, size.height * 0.76),
      Paint()
        ..color = const Color(0xFF3EA56F)
        ..strokeWidth = size.width * 0.055
        ..strokeCap = StrokeCap.round,
    );
    final leaf = Paint()..color = const Color(0xFF63C984);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.40, size.height * 0.61),
        width: size.width * 0.24,
        height: size.height * 0.10,
      ),
      leaf,
    );
    for (var i = 0; i < 7; i++) {
      final angle = i * math.pi * 2 / 7;
      canvas.drawOval(
        Rect.fromCenter(
          center: center +
              Offset(math.cos(angle), math.sin(angle)) * size.width * 0.15,
          width: size.width * 0.21,
          height: size.width * 0.14,
        ),
        Paint()..color = i.isEven ? const Color(0xFFFF7096) : accent,
      );
    }
    canvas.drawCircle(
      center,
      size.width * 0.09,
      Paint()..color = const Color(0xFFFFD45C),
    );
  }

  @override
  bool shouldRepaint(covariant _StoryFramePainter oldDelegate) =>
      oldDelegate.moment != moment ||
      oldDelegate.accent != accent ||
      oldDelegate.solved != solved ||
      oldDelegate.success != success;
}

class _StorySemantics {
  const _StorySemantics(this.values);

  final List<String> values;

  String moment(_StoryMoment moment) => values[moment.index];
  String position(int index) => values[3 + index];
  String get hint => values[6];
  String get moveLeft => values[7];
  String get moveRight => values[8];

  static _StorySemantics forLocale(Locale locale) {
    return _localized[locale.languageCode] ?? _localized['en']!;
  }

  static const _localized = <String, _StorySemantics>{
    'ar': _StorySemantics([
      'زرع البذرة',
      'سقي البذرة',
      'نمت الزهرة',
      'الموضع الأول',
      'الموضع الثاني',
      'الموضع الثالث',
      'اسحب لتغيير ترتيب القصة',
      'انقل لليسار',
      'انقل لليمين'
    ]),
    'de': _StorySemantics([
      'Samen pflanzen',
      'Samen gießen',
      'Blume wächst',
      'Erste Position',
      'Zweite Position',
      'Dritte Position',
      'Ziehen, um die Geschichte zu ordnen',
      'Nach links bewegen',
      'Nach rechts bewegen'
    ]),
    'en': _StorySemantics([
      'Plant the seed',
      'Water the seed',
      'The flower grows',
      'First position',
      'Second position',
      'Third position',
      'Drag to put the story in order',
      'Move left',
      'Move right'
    ]),
    'es': _StorySemantics([
      'Plantar la semilla',
      'Regar la semilla',
      'Crece la flor',
      'Primera posición',
      'Segunda posición',
      'Tercera posición',
      'Arrastra para ordenar la historia',
      'Mover a la izquierda',
      'Mover a la derecha'
    ]),
    'fr': _StorySemantics([
      'Planter la graine',
      'Arroser la graine',
      'La fleur pousse',
      'Première position',
      'Deuxième position',
      'Troisième position',
      "Faites glisser pour remettre l'histoire dans l'ordre",
      'Déplacer à gauche',
      'Déplacer à droite'
    ]),
    'hi': _StorySemantics([
      'बीज बोना',
      'बीज को पानी देना',
      'फूल खिलना',
      'पहला स्थान',
      'दूसरा स्थान',
      'तीसरा स्थान',
      'कहानी को क्रम में लगाने के लिए खींचें',
      'बाईं ओर ले जाएँ',
      'दाईं ओर ले जाएँ'
    ]),
    'it': _StorySemantics([
      'Piantare il seme',
      'Annaffiare il seme',
      'Cresce il fiore',
      'Prima posizione',
      'Seconda posizione',
      'Terza posizione',
      'Trascina per ordinare la storia',
      'Sposta a sinistra',
      'Sposta a destra'
    ]),
    'ja': _StorySemantics([
      '種を植える',
      '種に水をやる',
      '花が咲く',
      '1番目',
      '2番目',
      '3番目',
      'ドラッグして物語を順番に並べます',
      '左へ移動',
      '右へ移動'
    ]),
    'ko': _StorySemantics([
      '씨앗 심기',
      '씨앗에 물주기',
      '꽃이 자람',
      '첫 번째 위치',
      '두 번째 위치',
      '세 번째 위치',
      '드래그하여 이야기를 순서대로 놓으세요',
      '왼쪽으로 이동',
      '오른쪽으로 이동'
    ]),
    'pt': _StorySemantics([
      'Plantar a semente',
      'Regar a semente',
      'A flor cresce',
      'Primeira posição',
      'Segunda posição',
      'Terceira posição',
      'Arraste para ordenar a história',
      'Mover para a esquerda',
      'Mover para a direita'
    ]),
    'ru': _StorySemantics([
      'Посадить семя',
      'Полить семя',
      'Вырос цветок',
      'Первая позиция',
      'Вторая позиция',
      'Третья позиция',
      'Перетаскивайте кадры, чтобы собрать историю',
      'Переместить влево',
      'Переместить вправо'
    ]),
    'zh': _StorySemantics([
      '种下种子',
      '给种子浇水',
      '花朵长大',
      '第一个位置',
      '第二个位置',
      '第三个位置',
      '拖动卡片按顺序排列故事',
      '向左移动',
      '向右移动'
    ]),
  };
}
