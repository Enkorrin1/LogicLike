import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorRhythmGameView extends StatefulWidget {
  const ColorRhythmGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
    this.nowMilliseconds,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;
  final int Function()? nowMilliseconds;

  @override
  State<ColorRhythmGameView> createState() => _ColorRhythmGameViewState();
}

enum _RhythmPhase { showing, listening, retrying, solved }

class _ColorRhythmGameViewState extends State<ColorRhythmGameView>
    with TickerProviderStateMixin {
  static const _sequence = [0, 2, 1, 3];
  static const _gaps = [420, 860, 560];

  late final AnimationController _ambientController;
  late final AnimationController _timelineController;
  late final AnimationController _beatController;
  late final AnimationController _feedbackController;
  late final AnimationController _successController;

  _RhythmPhase _phase = _RhythmPhase.showing;
  final List<int> _taps = [];
  final List<int> _tapTimes = [];
  int? _activeCrystal;
  int _demoRun = 0;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4600),
    )..repeat();
    _timelineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1840),
    );
    _beatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 580),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRhythm());
  }

  @override
  void dispose() {
    _demoRun++;
    _ambientController.dispose();
    _timelineController.dispose();
    _beatController.dispose();
    _feedbackController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _showRhythm() async {
    final run = ++_demoRun;
    _timelineController.stop();
    _timelineController.value = 0;
    setState(() {
      _phase = _RhythmPhase.showing;
      _activeCrystal = null;
      _taps.clear();
      _tapTimes.clear();
    });
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted || run != _demoRun) return;
    unawaited(_timelineController.forward(from: 0));

    for (var i = 0; i < _sequence.length; i++) {
      if (i > 0) {
        await Future<void>.delayed(Duration(milliseconds: _gaps[i - 1]));
      }
      if (!mounted || run != _demoRun) return;
      setState(() => _activeCrystal = _sequence[i]);
      _beatController.forward(from: 0);
      HapticFeedback.selectionClick();
      await Future<void>.delayed(const Duration(milliseconds: 190));
      if (!mounted || run != _demoRun) return;
      setState(() => _activeCrystal = null);
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted || run != _demoRun) return;
    setState(() => _phase = _RhythmPhase.listening);
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (_phase != _RhythmPhase.listening || size.isEmpty) return;
    final crystals = _RhythmLayout.crystalRects(size);
    final index = crystals.indexWhere(
      (rect) => rect.inflate(10).contains(details.localPosition),
    );
    if (index < 0) return;

    final expectedPosition = _taps.length;
    setState(() => _activeCrystal = index);
    _beatController.forward(from: 0).whenComplete(() {
      if (mounted && _phase == _RhythmPhase.listening) {
        setState(() => _activeCrystal = null);
      }
    });

    if (index != _sequence[expectedPosition]) {
      _retry();
      return;
    }

    HapticFeedback.lightImpact();
    _taps.add(index);
    _tapTimes.add(
      widget.nowMilliseconds?.call() ?? DateTime.now().millisecondsSinceEpoch,
    );
    if (_taps.length < _sequence.length) {
      setState(() {});
      return;
    }

    if (_rhythmMatches()) {
      _complete();
    } else {
      _retry();
    }
  }

  bool _rhythmMatches() {
    final actual = List.generate(
      _tapTimes.length - 1,
      (i) => _tapTimes[i + 1] - _tapTimes[i],
    );
    final scales = List.generate(actual.length, (i) => actual[i] / _gaps[i])
      ..sort();
    final scale = scales[scales.length ~/ 2].clamp(0.65, 1.55);
    for (var i = 0; i < actual.length; i++) {
      final expected = _gaps[i] * scale;
      final tolerance = math.max(230.0, expected * 0.38);
      if ((actual[i] - expected).abs() > tolerance) return false;
    }
    return true;
  }

  void _retry() {
    HapticFeedback.mediumImpact();
    setState(() {
      _phase = _RhythmPhase.retrying;
      _activeCrystal = null;
    });
    _feedbackController.forward(from: 0).whenComplete(() {
      if (mounted && _phase == _RhythmPhase.retrying) _showRhythm();
    });
  }

  void _complete() {
    setState(() {
      _phase = _RhythmPhase.solved;
      _activeCrystal = null;
    });
    HapticFeedback.heavyImpact();
    _successController.forward(from: 0);
    Future<void>.delayed(const Duration(milliseconds: 760), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  String _instruction(BuildContext context) {
    const instructions = <String, String>{
      'ar': 'استمع إلى الإيقاع، ثم المس البلورات بالترتيب وبنفس التوقيت.',
      'de':
          'Hore den Rhythmus und tippe die Kristalle in gleicher Reihenfolge und gleichem Takt.',
      'en':
          'Watch the rhythm, then tap the crystals in the same order and timing.',
      'es': 'Observa el ritmo y toca los cristales en el mismo orden y tiempo.',
      'fr':
          'Observe le rythme, puis touche les cristaux dans le meme ordre et au meme tempo.',
      'hi': 'लय देखें, फिर उसी क्रम और समय में क्रिस्टल छुएं।',
      'it':
          'Osserva il ritmo, poi tocca i cristalli nello stesso ordine e tempo.',
      'ja': 'リズムを見て、同じ順番と間隔でクリスタルをタップします。',
      'ko': '리듬을 보고 같은 순서와 박자로 크리스털을 누르세요.',
      'pt':
          'Observe o ritmo e toque nos cristais na mesma ordem e no mesmo tempo.',
      'ru': 'Посмотри ритм, затем коснись кристаллов в том же порядке и темпе.',
      'zh': '观察节奏，然后按相同顺序和节拍点击水晶。',
    };
    return instructions[Localizations.localeOf(context).languageCode] ??
        instructions['en']!;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.semanticLabel}. ${_instruction(context)}',
      value: '${_phase.name}:${_taps.length}',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 218 : 252,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  key: const ValueKey('color-rhythm-surface'),
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _ambientController,
                      _timelineController,
                      _beatController,
                      _feedbackController,
                      _successController,
                    ]),
                    builder: (context, child) {
                      final pads = _RhythmLayout.crystalRects(size);
                      return Stack(
                        children: [
                          CustomPaint(
                            size: size,
                            painter: _ColorRhythmPainter(
                              accent: widget.accent,
                              ambient: _ambientController.value,
                              timeline: _timelineController.value,
                              beat: _beatController.value,
                              feedback: _feedbackController.value,
                              success: _successController.value,
                              phase: _phase,
                              activeCrystal: _activeCrystal,
                              progress: _taps.length,
                            ),
                          ),
                          for (var index = 0; index < pads.length; index++)
                            Positioned.fromRect(
                              rect: pads[index],
                              child: IgnorePointer(
                                child: SizedBox(
                                  key: ValueKey('color-rhythm-pad-$index'),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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

class _RhythmLayout {
  static List<Rect> crystalRects(Size size) {
    final gap = math.max(9.0, size.width * 0.025);
    final width = math.min((size.width - gap * 5) / 4, 78.0);
    final height = math.min(size.height * 0.39, width * 1.18);
    final left = (size.width - width * 4 - gap * 3) / 2;
    final top = size.height * 0.43;
    return List.generate(
      4,
      (i) => Rect.fromLTWH(left + i * (width + gap), top, width, height),
    );
  }
}

class _ColorRhythmPainter extends CustomPainter {
  const _ColorRhythmPainter({
    required this.accent,
    required this.ambient,
    required this.timeline,
    required this.beat,
    required this.feedback,
    required this.success,
    required this.phase,
    required this.activeCrystal,
    required this.progress,
  });

  final Color accent;
  final double ambient;
  final double timeline;
  final double beat;
  final double feedback;
  final double success;
  final _RhythmPhase phase;
  final int? activeCrystal;
  final int progress;

  static const _colors = [
    Color(0xFFFF6C7C),
    Color(0xFFFFCA55),
    Color(0xFF53E1B5),
    Color(0xFF67A9FF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF121A35), Color(0xFF253050), Color(0xFF18263D)],
        ).createShader(bounds),
    );
    _drawBackground(canvas, size);
    _drawRhythmWave(canvas, size);

    final shake = phase == _RhythmPhase.retrying
        ? math.sin(feedback * math.pi * 5) * (1 - feedback) * 5
        : 0.0;
    canvas.save();
    canvas.translate(shake, 0);
    final rects = _RhythmLayout.crystalRects(size);
    for (var i = 0; i < rects.length; i++) {
      _drawCrystal(canvas, rects[i], i, activeCrystal == i);
    }
    canvas.restore();
    _drawProgress(canvas, size);
    if (phase == _RhythmPhase.solved) _drawSuccess(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final dust = Paint()..color = Colors.white.withValues(alpha: 0.32);
    for (var i = 0; i < 22; i++) {
      final x = size.width * ((i * 0.173 + 0.03) % 0.96);
      final y = size.height * ((i * 0.097 + 0.05) % 0.88);
      final glow = 0.65 + 0.35 * math.sin(ambient * math.pi * 2 + i * 0.8);
      canvas.drawCircle(Offset(x, y), 0.6 + glow, dust);
    }
    final floor = Rect.fromLTRB(0, size.height * 0.81, size.width, size.height);
    canvas.drawRect(floor, Paint()..color = const Color(0xFF101A2C));
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.84),
        width: size.width * 0.86,
        height: size.height * 0.13,
      ),
      Paint()..color = accent.withValues(alpha: 0.09),
    );
  }

  void _drawRhythmWave(Canvas canvas, Size size) {
    final left = size.width * 0.09;
    final right = size.width * 0.91;
    final centerY = size.height * 0.22;
    final width = right - left;
    final onset = [0.0, 0.228, 0.696, 1.0];
    final path = Path()..moveTo(left, centerY);
    for (var x = 0.0; x <= width; x += 3) {
      final t = x / width;
      var wave = 0.0;
      for (final point in onset) {
        final distance = (t - point).abs();
        if (distance < 0.075) {
          wave +=
              math.sin((1 - distance / 0.075) * math.pi) * (t < point ? -1 : 1);
        }
      }
      path.lineTo(left + x, centerY - wave * size.height * 0.085);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    for (var i = 0; i < onset.length; i++) {
      final point = Offset(left + width * onset[i], centerY);
      final reached = phase != _RhythmPhase.showing || timeline >= onset[i];
      canvas.drawCircle(
        point,
        reached ? 5.5 : 3.5,
        Paint()
          ..color = _colors[_ColorRhythmGameViewState._sequence[i]].withValues(
            alpha: reached ? 0.92 : 0.28,
          ),
      );
    }
    if (phase == _RhythmPhase.showing) {
      final x = left + width * timeline;
      canvas.drawCircle(
        Offset(x, centerY),
        11,
        Paint()
          ..color = accent.withValues(alpha: 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
      canvas.drawCircle(Offset(x, centerY), 3.5, Paint()..color = Colors.white);
    }
  }

  void _drawCrystal(Canvas canvas, Rect rect, int index, bool active) {
    final color = _colors[index];
    final pulse = active ? math.sin(beat * math.pi) : 0.0;
    final center = rect.center;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1 + pulse * 0.10, 1 + pulse * 0.07);
    canvas.translate(-center.dx, -center.dy);
    if (active) {
      canvas.drawCircle(
        center,
        rect.width * (0.62 + pulse * 0.22),
        Paint()
          ..color = color.withValues(alpha: 0.48)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, rect.width * 0.22),
      );
    }
    final path = Path()
      ..moveTo(center.dx, rect.top)
      ..lineTo(rect.right - rect.width * 0.08, rect.top + rect.height * 0.34)
      ..lineTo(rect.right - rect.width * 0.18, rect.bottom)
      ..lineTo(rect.left + rect.width * 0.18, rect.bottom)
      ..lineTo(rect.left + rect.width * 0.08, rect.top + rect.height * 0.34)
      ..close();
    canvas.drawPath(
      path.shift(const Offset(0, 6)),
      Paint()..color = Colors.black26,
    );
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(color, Colors.white, 0.58)!,
            color,
            Color.lerp(color, Colors.black, 0.28)!,
          ],
        ).createShader(rect),
    );
    final facet = Path()
      ..moveTo(center.dx, rect.top)
      ..lineTo(center.dx, rect.bottom)
      ..lineTo(rect.left + rect.width * 0.08, rect.top + rect.height * 0.34)
      ..close();
    canvas.drawPath(
      facet,
      Paint()..color = Colors.white.withValues(alpha: 0.17),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: active ? 0.88 : 0.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = active ? 2.8 : 1.4,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, rect.bottom + 5),
        width: rect.width * 0.82,
        height: 9,
      ),
      Paint()..color = color.withValues(alpha: 0.22),
    );
    canvas.restore();
  }

  void _drawProgress(Canvas canvas, Size size) {
    final y = size.height * 0.91;
    const spacing = 18.0;
    final start = size.width / 2 - spacing * 1.5;
    for (var i = 0; i < 4; i++) {
      final filled = phase == _RhythmPhase.solved || i < progress;
      canvas.drawCircle(
        Offset(start + i * spacing, y),
        filled ? 4.5 : 3.2,
        Paint()
          ..color = filled
              ? _colors[_ColorRhythmGameViewState._sequence[i]]
              : Colors.white.withValues(alpha: 0.24),
      );
    }
  }

  void _drawSuccess(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.58);
    final fade = (1 - success).clamp(0.0, 1.0);
    for (var i = 0; i < 20; i++) {
      final angle = i * math.pi * 2 / 20 + success * 0.35;
      final distance = size.height * (0.10 + success * 0.35);
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * distance,
        (2.5 + i % 3) * fade,
        Paint()..color = _colors[i % 4].withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ColorRhythmPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.ambient != ambient ||
      oldDelegate.timeline != timeline ||
      oldDelegate.beat != beat ||
      oldDelegate.feedback != feedback ||
      oldDelegate.success != success ||
      oldDelegate.phase != phase ||
      oldDelegate.activeCrystal != activeCrystal ||
      oldDelegate.progress != progress;
}
