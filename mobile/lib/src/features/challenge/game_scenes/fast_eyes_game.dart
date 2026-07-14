import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FastEyesGameView extends StatefulWidget {
  const FastEyesGameView({
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
  State<FastEyesGameView> createState() => _FastEyesGameViewState();
}

enum _FastEyesPhase { settling, signal, reaction, betweenRounds, solved }

class _FastEyesGameViewState extends State<FastEyesGameView>
    with TickerProviderStateMixin {
  static const _targets = [4, 1];

  late final AnimationController _motionController;
  late final AnimationController _signalController;
  late final AnimationController _feedbackController;
  late final AnimationController _successController;

  _FastEyesPhase _phase = _FastEyesPhase.settling;
  int _round = 0;
  int? _missedDrone;
  bool _answerSent = false;
  int _sequence = 0;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8200),
    )..repeat();
    _signalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 880),
    );
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _startRound());
  }

  @override
  void dispose() {
    _sequence++;
    _motionController.dispose();
    _signalController.dispose();
    _feedbackController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _startRound() async {
    final sequence = ++_sequence;
    setState(() {
      _phase = _FastEyesPhase.settling;
      _missedDrone = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 680));
    if (!mounted || sequence != _sequence) return;
    setState(() => _phase = _FastEyesPhase.signal);
    HapticFeedback.selectionClick();
    await _signalController.forward(from: 0);
    if (!mounted || sequence != _sequence) return;
    setState(() => _phase = _FastEyesPhase.reaction);
  }

  void _handleTap(TapUpDetails details, Size size) {
    if (_phase != _FastEyesPhase.reaction || size.isEmpty) return;
    final centers = _FastEyesLayout.droneCenters(
      size,
      _motionController.value,
      _round,
    );
    final radius = _FastEyesLayout.droneRadius(size);
    var index = -1;
    var nearestDistance = double.infinity;
    for (var i = 0; i < centers.length; i++) {
      final distance = (details.localPosition - centers[i]).distance;
      if (distance < nearestDistance && distance <= radius * 1.55) {
        nearestDistance = distance;
        index = i;
      }
    }
    if (index < 0) return;
    if (index == _targets[_round]) {
      _handleCorrect();
    } else {
      _handleMiss(index);
    }
  }

  void _handleMiss(int index) {
    HapticFeedback.lightImpact();
    setState(() => _missedDrone = index);
    _feedbackController.forward(from: 0).whenComplete(() {
      if (mounted && _phase == _FastEyesPhase.reaction) {
        setState(() => _missedDrone = null);
      }
    });
  }

  Future<void> _handleCorrect() async {
    HapticFeedback.mediumImpact();
    if (_round == 0) {
      setState(() {
        _round = 1;
        _phase = _FastEyesPhase.betweenRounds;
        _missedDrone = null;
      });
      await Future<void>.delayed(const Duration(milliseconds: 520));
      if (mounted) unawaited(_startRound());
      return;
    }

    _sequence++;
    setState(() {
      _phase = _FastEyesPhase.solved;
      _missedDrone = null;
    });
    HapticFeedback.heavyImpact();
    unawaited(_successController.forward(from: 0));
    await Future<void>.delayed(const Duration(milliseconds: 760));
    if (!mounted || _answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  String _instruction(BuildContext context) {
    const instructions = <String, String>{
      'ar':
          'راقب الأجسام المتحركة. المس الجسم الذي غيّر لونه أو إيقاعه عند الإشارة.',
      'de':
          'Beobachte die bewegten Objekte. Tippe nach dem Signal auf das Objekt, das Farbe oder Rhythmus geandert hat.',
      'en':
          'Watch the moving objects. After the signal, tap the one that changed color or rhythm.',
      'es':
          'Observa los objetos en movimiento. Tras la senal, toca el que cambio de color o ritmo.',
      'fr':
          'Observe les objets en mouvement. Apres le signal, touche celui qui a change de couleur ou de rythme.',
      'hi':
          'चलती वस्तुओं को देखें। संकेत के बाद उस वस्तु को छुएँ जिसका रंग या लय बदली थी।',
      'it':
          'Osserva gli oggetti in movimento. Dopo il segnale, tocca quello che ha cambiato colore o ritmo.',
      'ja': '動く物体を見てください。合図の後、色やリズムが変わった物体をタップします。',
      'ko': '움직이는 물체를 보세요. 신호 후 색이나 리듬이 바뀐 물체를 누르세요.',
      'pt':
          'Observe os objetos em movimento. Apos o sinal, toque naquele que mudou de cor ou ritmo.',
      'ru':
          'Следи за движущимися объектами. После сигнала коснись того, который менял цвет или ритм.',
      'zh': '观察移动的物体。信号结束后，点击刚才改变颜色或节奏的物体。',
    };
    return instructions[Localizations.localeOf(context).languageCode] ??
        instructions['en']!;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.semanticLabel}. ${_instruction(context)}',
      value: '${_phase.name}:$_round',
      button: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 218 : 254,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return GestureDetector(
                  key: const ValueKey('fast-eyes-surface'),
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _handleTap(details, size),
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _motionController,
                      _signalController,
                      _feedbackController,
                      _successController,
                    ]),
                    builder: (context, child) {
                      final centers = _FastEyesLayout.droneCenters(
                        size,
                        _motionController.value,
                        _round,
                      );
                      final radius = _FastEyesLayout.droneRadius(size);
                      final target = _targets[_round];
                      return Stack(
                        children: [
                          CustomPaint(
                            size: size,
                            painter: _FastEyesPainter(
                              accent: widget.accent,
                              motion: _motionController.value,
                              signal: _signalController.value,
                              feedback: _feedbackController.value,
                              success: _successController.value,
                              phase: _phase,
                              round: _round,
                              target: target,
                              missedDrone: _missedDrone,
                            ),
                          ),
                          Positioned.fromRect(
                            rect: Rect.fromCircle(
                              center: centers[target],
                              radius: radius * 1.55,
                            ),
                            child: GestureDetector(
                              key: ValueKey(
                                'fast-eyes-target-$_round-${_phase.name}',
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: _phase == _FastEyesPhase.reaction
                                  ? _handleCorrect
                                  : null,
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

class _FastEyesLayout {
  static double droneRadius(Size size) =>
      math.min(size.height * 0.062, size.width * 0.038).clamp(10, 17);

  static List<Offset> droneCenters(Size size, double motion, int round) {
    const anchors = <Offset>[
      Offset(0.15, 0.28),
      Offset(0.31, 0.61),
      Offset(0.46, 0.31),
      Offset(0.61, 0.67),
      Offset(0.77, 0.27),
      Offset(0.85, 0.59),
      Offset(0.48, 0.77),
    ];
    final phase = motion * math.pi * 2;
    return List.generate(anchors.length, (i) {
      final anchor = anchors[(i + round * 2) % anchors.length];
      final xWave = math.sin(phase * (1.0 + i * 0.035) + i * 1.73);
      final yWave = math.cos(phase * (0.82 + i * 0.027) + i * 2.19);
      return Offset(
        size.width * (anchor.dx + xWave * (0.027 + i % 2 * 0.008)),
        size.height * (anchor.dy + yWave * (0.045 + i % 3 * 0.009)),
      );
    });
  }
}

class _FastEyesPainter extends CustomPainter {
  const _FastEyesPainter({
    required this.accent,
    required this.motion,
    required this.signal,
    required this.feedback,
    required this.success,
    required this.phase,
    required this.round,
    required this.target,
    required this.missedDrone,
  });

  final Color accent;
  final double motion;
  final double signal;
  final double feedback;
  final double success;
  final _FastEyesPhase phase;
  final int round;
  final int target;
  final int? missedDrone;

  static const _droneColors = <Color>[
    Color(0xFF6EE7D8),
    Color(0xFFFFD166),
    Color(0xFF7EB6FF),
    Color(0xFFFF8E9E),
    Color(0xFFB69CFF),
    Color(0xFF8BE28B),
    Color(0xFFFFA85C),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF071426), Color(0xFF17344C), Color(0xFF0A1C34)],
        ).createShader(bounds),
    );
    _drawSpace(canvas, size);
    _drawWindow(canvas, size);
    _drawPlanet(canvas, size);

    final centers = _FastEyesLayout.droneCenters(size, motion, round);
    final radius = _FastEyesLayout.droneRadius(size);
    for (var i = 0; i < centers.length; i++) {
      _drawTrail(canvas, centers[i], radius, i);
    }
    for (var i = 0; i < centers.length; i++) {
      _drawDrone(canvas, centers[i], radius, i);
    }
    _drawRoundLights(canvas, size);
    if (phase == _FastEyesPhase.solved) _drawSuccess(canvas, size);
  }

  void _drawSpace(Canvas canvas, Size size) {
    for (var i = 0; i < 48; i++) {
      final x = size.width * ((0.021 + i * 0.337) % 0.98);
      final y = size.height * ((0.035 + i * 0.173) % 0.92);
      final twinkle =
          0.35 + 0.48 * (0.5 + 0.5 * math.sin(motion * math.pi * 2 + i * 0.91));
      canvas.drawCircle(
        Offset(x, y),
        i % 9 == 0 ? 1.45 : 0.65,
        Paint()..color = Colors.white.withValues(alpha: twinkle),
      );
    }
  }

  void _drawWindow(Canvas canvas, Size size) {
    final frame = Paint()
      ..color = const Color(0xFF7190A4).withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 5, size.width - 10, size.height - 10),
        const Radius.circular(19),
      ),
      frame,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 1.12),
        width: size.width * 1.15,
        height: size.height * 0.62,
      ),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF9DB5C3).withValues(alpha: 0.13)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    for (final x in [0.07, 0.93]) {
      canvas.drawCircle(
        Offset(size.width * x, size.height * 0.11),
        3.2,
        Paint()..color = const Color(0xFFBBD1DC).withValues(alpha: 0.58),
      );
    }
  }

  void _drawPlanet(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.08, size.height * 0.84);
    final radius = size.height * 0.19;
    canvas.drawCircle(
      center,
      radius * 1.12,
      Paint()
        ..color = const Color(0xFF55C8C4).withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 13),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.4, -0.5),
          colors: [Color(0xFF79D9D0), Color(0xFF277A91), Color(0xFF173C65)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.72),
      3.5,
      1.35,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _drawTrail(Canvas canvas, Offset center, double radius, int index) {
    final phaseOffset = motion * math.pi * 2 + index * 1.73;
    final direction = Offset(
      -math.cos(phaseOffset) * radius * 1.7,
      math.sin(phaseOffset * 0.83) * radius * 0.9,
    );
    canvas.drawLine(
      center + direction,
      center,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _droneColors[index].withValues(alpha: 0),
            _droneColors[index].withValues(alpha: 0.34),
          ],
        ).createShader(Rect.fromPoints(center + direction, center))
        ..strokeWidth = radius * 0.35
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawDrone(Canvas canvas, Offset center, double radius, int index) {
    final isSignaling = phase == _FastEyesPhase.signal && index == target;
    final signalPulse = isSignaling
        ? math.sin(signal * math.pi * 5).abs() *
            math.sin(signal * math.pi).clamp(0.0, 1.0)
        : 0.0;
    final isMiss = index == missedDrone;
    final missPulse = isMiss ? math.sin(feedback * math.pi) : 0.0;
    final color = isSignaling
        ? Color.lerp(_droneColors[index], const Color(0xFFFFFFFF), signalPulse)!
        : _droneColors[index];
    final wobble = isMiss
        ? math.sin(feedback * math.pi * 6) * (1 - feedback) * radius * 0.28
        : 0.0;
    final droneCenter = center + Offset(wobble, 0);

    canvas.drawCircle(
      droneCenter,
      radius * (1.65 + signalPulse * 0.9 + missPulse * 0.18),
      Paint()
        ..color = (isMiss ? const Color(0xFFFFB7A2) : color).withValues(
          alpha: isSignaling ? 0.42 : 0.17,
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.75),
    );
    canvas.save();
    canvas.translate(droneCenter.dx, droneCenter.dy);
    canvas.rotate(math.sin(motion * math.pi * 2 + index) * 0.11);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.9, 0),
        width: radius * 1.22,
        height: radius * 0.56,
      ),
      Paint()..color = color.withValues(alpha: 0.62),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(radius * 0.9, 0),
        width: radius * 1.22,
        height: radius * 0.56,
      ),
      Paint()..color = color.withValues(alpha: 0.62),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.42),
          colors: [Colors.white, color, Color.lerp(color, Colors.black, 0.45)!],
          stops: const [0, 0.38, 1],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );
    canvas.drawCircle(
      Offset(-radius * 0.27, -radius * 0.22),
      radius * 0.18,
      Paint()..color = Colors.white.withValues(alpha: 0.86),
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius * 0.72),
      0.15,
      2.1,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.34)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.restore();
  }

  void _drawRoundLights(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.925);
    for (var i = 0; i < 2; i++) {
      final filled = phase == _FastEyesPhase.solved || i < round;
      final point = center + Offset((i - 0.5) * 22, 0);
      canvas.drawCircle(
        point,
        filled ? 4.5 : 3.3,
        Paint()..color = filled ? accent : Colors.white.withValues(alpha: 0.24),
      );
      if (filled) {
        canvas.drawCircle(
          point,
          8,
          Paint()
            ..color = accent.withValues(alpha: 0.16)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }
    }
  }

  void _drawSuccess(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.49);
    final fade = (1 - success).clamp(0.0, 1.0);
    for (var i = 0; i < 24; i++) {
      final angle = i * math.pi * 2 / 24 + success * 0.45;
      final distance = size.height * (0.05 + success * 0.42);
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * distance,
        (2.2 + i % 3) * fade,
        Paint()
          ..color = (i.isEven ? accent : _droneColors[i % 7]).withValues(
            alpha: fade,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FastEyesPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.motion != motion ||
      oldDelegate.signal != signal ||
      oldDelegate.feedback != feedback ||
      oldDelegate.success != success ||
      oldDelegate.phase != phase ||
      oldDelegate.round != round ||
      oldDelegate.target != target ||
      oldDelegate.missedDrone != missedDrone;
}
