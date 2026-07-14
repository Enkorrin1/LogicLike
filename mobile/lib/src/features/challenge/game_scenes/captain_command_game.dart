import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaptainCommandGameView extends StatefulWidget {
  const CaptainCommandGameView({
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
  State<CaptainCommandGameView> createState() => _CaptainCommandGameViewState();
}

enum _CaptainPhase { demonstrating, input, wrong, success }

class _CaptainCommandGameViewState extends State<CaptainCommandGameView>
    with TickerProviderStateMixin {
  static const _sequence = [0, 2, 1];

  late final AnimationController _ambient;
  late final AnimationController _motion;
  late final AnimationController _reaction;
  late final AnimationController _success;
  _CaptainPhase _phase = _CaptainPhase.demonstrating;
  int? _activeCommand;
  int _progress = 0;
  int _run = 0;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _demonstrate());
  }

  @override
  void dispose() {
    _run++;
    _ambient.dispose();
    _motion.dispose();
    _reaction.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _demonstrate() async {
    final run = ++_run;
    if (!mounted) return;
    setState(() {
      _phase = _CaptainPhase.demonstrating;
      _progress = 0;
      _activeCommand = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 420));
    for (final command in _sequence) {
      if (!mounted || run != _run) return;
      setState(() => _activeCommand = command);
      _motion.forward(from: 0);
      HapticFeedback.selectionClick();
      await Future<void>.delayed(const Duration(milliseconds: 610));
      if (!mounted || run != _run) return;
      setState(() => _activeCommand = null);
      await Future<void>.delayed(const Duration(milliseconds: 190));
    }
    if (!mounted || run != _run) return;
    setState(() => _phase = _CaptainPhase.input);
  }

  void _choose(int command) {
    if (_phase != _CaptainPhase.input) return;
    setState(() => _activeCommand = command);
    _motion.forward(from: 0).whenComplete(() {
      if (mounted && _phase == _CaptainPhase.input) {
        setState(() => _activeCommand = null);
      }
    });

    if (command != _sequence[_progress]) {
      HapticFeedback.mediumImpact();
      setState(() => _phase = _CaptainPhase.wrong);
      _reaction.forward(from: 0).whenComplete(() {
        if (mounted && _phase == _CaptainPhase.wrong) _demonstrate();
      });
      return;
    }

    HapticFeedback.lightImpact();
    setState(() => _progress++);
    if (_progress == _sequence.length) _complete();
  }

  void _complete() {
    _run++;
    setState(() {
      _phase = _CaptainPhase.success;
      _activeCommand = null;
    });
    HapticFeedback.heavyImpact();
    _success.forward(from: 0).whenComplete(() {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  List<String> _commandLabels(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    return _labels[language] ?? _labels['en']!;
  }

  @override
  Widget build(BuildContext context) {
    final labels = _commandLabels(context);
    return Semantics(
      container: true,
      label: widget.semanticLabel,
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
                final panels = _CaptainLayout(size).panels;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _ambient,
                        _motion,
                        _reaction,
                        _success,
                      ]),
                      builder: (context, child) => CustomPaint(
                        painter: _CaptainPainter(
                          accent: widget.accent,
                          ambient: _ambient.value,
                          motion: _motion.value,
                          reaction: _reaction.value,
                          success: _success.value,
                          phase: _phase,
                          activeCommand: _activeCommand,
                          progress: _progress,
                        ),
                      ),
                    ),
                    for (var i = 0; i < panels.length; i++)
                      Positioned.fromRect(
                        rect: panels[i].inflate(5),
                        child: Semantics(
                          button: true,
                          enabled: _phase == _CaptainPhase.input,
                          label: labels[i],
                          onTap: _phase == _CaptainPhase.input
                              ? () => _choose(i)
                              : null,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _choose(i),
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

const Map<String, List<String>> _labels = {
  'en': ['Salute command', 'Turn command', 'Boost command'],
  'ru': ['Команда честь', 'Команда поворот', 'Команда прыжок'],
  'be': ['Каманда гонар', 'Каманда паварот', 'Каманда скачок'],
  'de': ['Grußbefehl', 'Drehbefehl', 'Sprungbefehl'],
  'es': ['Orden de saludo', 'Orden de giro', 'Orden de salto'],
  'fr': ['Commande salut', 'Commande rotation', 'Commande saut'],
  'it': ['Comando saluto', 'Comando giro', 'Comando salto'],
  'pt': ['Comando saudar', 'Comando girar', 'Comando saltar'],
  'pl': ['Rozkaz salut', 'Rozkaz obrót', 'Rozkaz skok'],
  'uk': ['Команда честь', 'Команда поворот', 'Команда стрибок'],
  'tr': ['Selam komutu', 'Dönüş komutu', 'Zıplama komutu'],
  'kk': ['Сәлем беру пәрмені', 'Бұрылу пәрмені', 'Секіру пәрмені'],
};

class _CaptainLayout {
  const _CaptainLayout(this.size);

  final Size size;

  double get unit => size.height / 252;
  Rect get captain => Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.40),
        width: math.min(size.width * 0.31, 126 * unit),
        height: 132 * unit,
      );
  List<Rect> get panels {
    final gap = math.max(9.0, size.width * 0.025);
    final width = math.min((size.width - gap * 4) / 3, 112 * unit);
    final total = width * 3 + gap * 2;
    final left = (size.width - total) / 2;
    final top = size.height * 0.72;
    return List.generate(
      3,
      (i) => Rect.fromLTWH(left + i * (width + gap), top, width, 49 * unit),
    );
  }
}

class _CaptainPainter extends CustomPainter {
  const _CaptainPainter({
    required this.accent,
    required this.ambient,
    required this.motion,
    required this.reaction,
    required this.success,
    required this.phase,
    required this.activeCommand,
    required this.progress,
  });

  final Color accent;
  final double ambient;
  final double motion;
  final double reaction;
  final double success;
  final _CaptainPhase phase;
  final int? activeCommand;
  final int progress;

  static const _panelColors = [
    Color(0xFFFFC857),
    Color(0xFF59D7C2),
    Color(0xFFFF718A),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _CaptainLayout(size);
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF111B38), Color(0xFF253C60), Color(0xFF182A3D)],
        ).createShader(bounds),
    );
    _drawBridge(canvas, size, layout.unit);
    _drawCaptain(canvas, layout);
    _drawPanels(canvas, layout);
    _drawProgress(canvas, size, layout.unit);
    if (phase == _CaptainPhase.success) _drawSuccess(canvas, size, layout.unit);
  }

  void _drawBridge(Canvas canvas, Size size, double unit) {
    final window = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.08, 12 * unit, size.width * 0.84, size.height * 0.46),
      Radius.circular(18 * unit),
    );
    canvas.drawRRect(window, Paint()..color = const Color(0xFF071126));
    canvas.save();
    canvas.clipRRect(window);
    for (var i = 0; i < 24; i++) {
      final x = size.width * ((i * 0.173 + 0.06 + ambient * 0.012) % 0.94);
      final y = size.height * (0.05 + (i * 0.097) % 0.36);
      canvas.drawCircle(
        Offset(x, y),
        i % 4 == 0 ? 1.4 : 0.75,
        Paint()..color = Colors.white.withValues(alpha: 0.45 + i % 3 * 0.18),
      );
    }
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.15),
      25 * unit,
      Paint()..color = accent.withValues(alpha: 0.72),
    );
    canvas.restore();
    canvas.drawRRect(
      window,
      Paint()
        ..color = const Color(0xFF7389A2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 * unit,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.65, size.width, size.height * 0.35),
      Paint()..color = const Color(0xFF142331),
    );
  }

  void _drawCaptain(Canvas canvas, _CaptainLayout layout) {
    final rect = layout.captain;
    final u = layout.unit;
    var dx = 0.0;
    var dy = 0.0;
    var angle = 0.0;
    if (phase == _CaptainPhase.wrong) {
      dx = math.sin(reaction * math.pi * 9) * (1 - reaction) * 8 * u;
      angle = math.sin(reaction * math.pi * 5) * 0.08;
    } else if (activeCommand == 1) {
      angle = math.sin(motion * math.pi) * 0.32;
    } else if (activeCommand == 2) {
      dy = -math.sin(motion * math.pi) * 22 * u;
    }
    if (phase == _CaptainPhase.success) {
      dy -= math.sin(success * math.pi * 4) * (1 - success) * 10 * u;
      angle += math.sin(success * math.pi * 4) * (1 - success) * 0.12;
    }

    canvas.save();
    canvas.translate(rect.center.dx + dx, rect.center.dy + dy);
    canvas.rotate(angle);
    canvas.translate(-rect.center.dx, -rect.center.dy);
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(rect.left + rect.width * 0.22,
          rect.top + rect.height * 0.43, rect.width * 0.56, rect.height * 0.46),
      Radius.circular(14 * u),
    );
    canvas.drawRRect(body.shift(Offset(0, 5 * u)),
        Paint()..color = Colors.black.withValues(alpha: 0.30));
    canvas.drawRRect(body, Paint()..color = const Color(0xFFE9EEF2));
    canvas.drawRRect(
      body,
      Paint()
        ..color = const Color(0xFF607D91)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * u,
    );
    final head = RRect.fromRectAndRadius(
      Rect.fromLTWH(rect.left + rect.width * 0.18,
          rect.top + rect.height * 0.08, rect.width * 0.64, rect.height * 0.42),
      Radius.circular(18 * u),
    );
    canvas.drawRRect(head, Paint()..color = const Color(0xFFF7FAFC));
    final visor = RRect.fromRectAndRadius(
      Rect.fromLTWH(head.left + 8 * u, head.top + 12 * u, head.width - 16 * u,
          head.height * 0.47),
      Radius.circular(10 * u),
    );
    canvas.drawRRect(visor, Paint()..color = const Color(0xFF18314B));
    final eyeY = visor.center.dy;
    final worried = phase == _CaptainPhase.wrong;
    final eye = Paint()
      ..color = worried ? const Color(0xFFFF718A) : const Color(0xFF75F1DB)
      ..strokeWidth = 3 * u
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(visor.center.dx - 14 * u, eyeY - (worried ? 2 : 0)),
        Offset(visor.center.dx - 7 * u, eyeY + (worried ? 2 : 0)), eye);
    canvas.drawLine(Offset(visor.center.dx + 7 * u, eyeY + (worried ? 2 : 0)),
        Offset(visor.center.dx + 14 * u, eyeY - (worried ? 2 : 0)), eye);
    canvas.drawCircle(body.center, 10 * u, Paint()..color = accent);

    final limb = Paint()
      ..color = const Color(0xFFCFD9E0)
      ..strokeWidth = 10 * u
      ..strokeCap = StrokeCap.round;
    final shoulderY = body.top + 13 * u;
    final salute = activeCommand == 0;
    canvas.drawLine(
      Offset(body.left + 2 * u, shoulderY),
      salute
          ? Offset(head.left + 7 * u, head.top + 7 * u)
          : Offset(rect.left + 8 * u, body.center.dy),
      limb,
    );
    canvas.drawLine(Offset(body.right - 2 * u, shoulderY),
        Offset(rect.right - 8 * u, body.center.dy), limb);
    canvas.drawLine(Offset(body.center.dx - 14 * u, body.bottom - 2 * u),
        Offset(body.center.dx - 19 * u, rect.bottom), limb);
    canvas.drawLine(Offset(body.center.dx + 14 * u, body.bottom - 2 * u),
        Offset(body.center.dx + 19 * u, rect.bottom), limb);
    canvas.restore();
  }

  void _drawPanels(Canvas canvas, _CaptainLayout layout) {
    final panels = layout.panels;
    for (var i = 0; i < panels.length; i++) {
      final rect = panels[i];
      final active = activeCommand == i;
      final press = active ? math.sin(motion * math.pi) * 4 * layout.unit : 0.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.shift(Offset(0, 5 * layout.unit)),
            Radius.circular(9 * layout.unit)),
        Paint()..color = const Color(0xFF07131D),
      );
      final face = rect.shift(Offset(0, press));
      canvas.drawRRect(
        RRect.fromRectAndRadius(face, Radius.circular(9 * layout.unit)),
        Paint()..color = active ? _panelColors[i] : const Color(0xFF334A5B),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            face.deflate(4 * layout.unit), Radius.circular(6 * layout.unit)),
        Paint()
          ..color = _panelColors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * layout.unit,
      );
      _drawGlyph(canvas, face.center, i, layout.unit,
          active ? const Color(0xFF142331) : _panelColors[i]);
    }
  }

  void _drawGlyph(
      Canvas canvas, Offset center, int index, double u, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * u
      ..strokeCap = StrokeCap.round;
    if (index == 0) {
      canvas.drawLine(center + Offset(-12 * u, 8 * u),
          center + Offset(8 * u, -10 * u), paint);
      canvas.drawLine(center + Offset(8 * u, -10 * u),
          center + Offset(14 * u, -3 * u), paint);
    } else if (index == 1) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: 13 * u), -0.7, 4.8,
          false, paint);
      canvas.drawLine(center + Offset(-13 * u, 3 * u),
          center + Offset(-16 * u, -7 * u), paint);
    } else {
      canvas.drawLine(
          center + Offset(0, 12 * u), center + Offset(0, -11 * u), paint);
      canvas.drawLine(
          center + Offset(0, -11 * u), center + Offset(-8 * u, -3 * u), paint);
      canvas.drawLine(
          center + Offset(0, -11 * u), center + Offset(8 * u, -3 * u), paint);
    }
  }

  void _drawProgress(Canvas canvas, Size size, double unit) {
    for (var i = 0; i < 3; i++) {
      final done = phase == _CaptainPhase.success || i < progress;
      canvas.drawCircle(
        Offset(size.width / 2 + (i - 1) * 19 * unit, 13 * unit),
        done ? 5 * unit : 4 * unit,
        Paint()..color = done ? accent : Colors.white.withValues(alpha: 0.25),
      );
    }
  }

  void _drawSuccess(Canvas canvas, Size size, double unit) {
    final fade = (1 - success).clamp(0.0, 1.0);
    final center = Offset(size.width / 2, size.height * 0.38);
    for (var i = 0; i < 18; i++) {
      final angle = i * math.pi * 2 / 18;
      final distance = (35 + success * 105) * unit;
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawCircle(
        point,
        (i.isEven ? 4 : 2.5) * unit * fade,
        Paint()..color = _panelColors[i % 3].withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CaptainPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.ambient != ambient ||
      oldDelegate.motion != motion ||
      oldDelegate.reaction != reaction ||
      oldDelegate.success != success ||
      oldDelegate.phase != phase ||
      oldDelegate.activeCommand != activeCommand ||
      oldDelegate.progress != progress;
}
