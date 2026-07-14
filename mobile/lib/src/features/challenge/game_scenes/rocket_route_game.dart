import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RocketRouteGameView extends StatefulWidget {
  const RocketRouteGameView({
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
  State<RocketRouteGameView> createState() => _RocketRouteGameViewState();
}

enum _Command { forward, left, right }

class _RocketRouteGameViewState extends State<RocketRouteGameView>
    with TickerProviderStateMixin {
  static const _start = math.Point<int>(0, 3);
  static const _goal = math.Point<int>(3, 1);
  static final _rocks = {
    const math.Point<int>(1, 2),
    const math.Point<int>(2, 2),
    const math.Point<int>(2, 0),
  };

  final List<_Command?> _program = List.filled(6, null);
  late final AnimationController _ambient;
  late final AnimationController _step;
  late final AnimationController _reaction;
  math.Point<int> _cell = _start;
  math.Point<int> _fromCell = _start;
  int _direction = 0;
  int _fromDirection = 0;
  int _activeSlot = -1;
  bool _running = false;
  bool _collision = false;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    _step = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
  }

  @override
  void dispose() {
    _ambient.dispose();
    _step.dispose();
    _reaction.dispose();
    super.dispose();
  }

  void _dropCommand(int index, _Command command) {
    if (_running || _solved) return;
    HapticFeedback.selectionClick();
    setState(() => _program[index] = command);
  }

  void _removeCommand(int index) {
    if (_running || _solved || _program[index] == null) return;
    HapticFeedback.selectionClick();
    setState(() => _program[index] = null);
  }

  Future<void> _launch() async {
    if (_running || _solved || _program.every((command) => command == null)) {
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      _running = true;
      _collision = false;
      _cell = _start;
      _fromCell = _start;
      _direction = 0;
      _fromDirection = 0;
      _activeSlot = -1;
    });

    for (var i = 0; i < _program.length; i++) {
      final command = _program[i];
      if (command == null) break;
      _fromCell = _cell;
      _fromDirection = _direction;
      var collided = false;
      if (command == _Command.left) {
        _direction = (_direction + 3) % 4;
      } else if (command == _Command.right) {
        _direction = (_direction + 1) % 4;
      } else {
        const delta = [
          math.Point<int>(0, -1),
          math.Point<int>(1, 0),
          math.Point<int>(0, 1),
          math.Point<int>(-1, 0),
        ];
        final next = _cell + delta[_direction];
        collided = next.x < 0 ||
            next.x > 3 ||
            next.y < 0 ||
            next.y > 3 ||
            _rocks.contains(next);
        if (!collided) _cell = next;
      }
      setState(() => _activeSlot = i);
      await _step.forward(from: 0);
      if (!mounted) return;
      if (collided) {
        setState(() => _collision = true);
        HapticFeedback.heavyImpact();
        await _reaction.forward(from: 0);
        if (!mounted) return;
        setState(() {
          _running = false;
          _collision = false;
          _activeSlot = -1;
        });
        return;
      }
    }

    if (_cell == _goal) {
      setState(() {
        _solved = true;
        _running = false;
      });
      HapticFeedback.heavyImpact();
      await _reaction.forward(from: 0);
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    } else {
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (mounted) {
        setState(() {
          _running = false;
          _activeSlot = -1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = _RouteSemantics.forLocale(Localizations.localeOf(context));
    return Semantics(
      container: true,
      label: '${widget.semanticLabel}. ${words.instruction}',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 326 : 372,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _RouteLayout(constraints.biggest);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([_ambient, _step, _reaction]),
                      builder: (context, child) => CustomPaint(
                        painter: _RocketRoutePainter(
                          accent: widget.accent,
                          layout: layout,
                          program: _program,
                          cell: _cell,
                          fromCell: _fromCell,
                          direction: _direction,
                          fromDirection: _fromDirection,
                          activeSlot: _activeSlot,
                          step: _step.value,
                          reaction: _reaction.value,
                          ambient: _ambient.value,
                          collision: _collision,
                          solved: _solved,
                        ),
                      ),
                    ),
                    for (var i = 0; i < _program.length; i++)
                      Positioned.fromRect(
                        rect: layout.slots[i],
                        child: DragTarget<_Command>(
                          key: ValueKey('rocket-route-slot-$i'),
                          onWillAcceptWithDetails: (_) => !_running && !_solved,
                          onAcceptWithDetails: (details) =>
                              _dropCommand(i, details.data),
                          builder: (context, candidates, rejected) => Semantics(
                            button: _program[i] != null,
                            label: _program[i] == null
                                ? '${words.emptySlot} ${i + 1}'
                                : '${words.command(_program[i]!)} ${i + 1}',
                            onTap: _program[i] == null
                                ? null
                                : () => _removeCommand(i),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _removeCommand(i),
                            ),
                          ),
                        ),
                      ),
                    for (var i = 0; i < _Command.values.length; i++)
                      Positioned.fromRect(
                        rect: layout.palette[i],
                        child: Semantics(
                          label: words.command(_Command.values[i]),
                          child: Draggable<_Command>(
                            key: ValueKey('rocket-route-command-$i'),
                            data: _Command.values[i],
                            maxSimultaneousDrags: _running || _solved ? 0 : 1,
                            feedback: _CommandFeedback(
                              command: _Command.values[i],
                              accent: widget.accent,
                              size: layout.palette[i].size,
                            ),
                            childWhenDragging: const SizedBox.expand(),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ),
                    Positioned.fromRect(
                      rect: layout.launch.inflate(5),
                      child: Semantics(
                        button: true,
                        enabled: !_running && !_solved,
                        label: words.launch,
                        onTap: !_running && !_solved ? _launch : null,
                        child: GestureDetector(
                          key: const ValueKey('rocket-route-launch'),
                          behavior: HitTestBehavior.opaque,
                          onTap: _launch,
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

class _CommandFeedback extends StatelessWidget {
  const _CommandFeedback({
    required this.command,
    required this.accent,
    required this.size,
  });

  final _Command command;
  final Color accent;
  final Size size;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: CustomPaint(
          size: size,
          painter: _CommandTilePainter(command: command, accent: accent),
        ),
      );
}

class _RouteLayout {
  _RouteLayout(this.size)
      : scale = math.min(size.width / 360, size.height / 372),
        origin = Offset(
          (size.width - 360 * math.min(size.width / 360, size.height / 372)) /
              2,
          (size.height - 372 * math.min(size.width / 360, size.height / 372)) /
              2,
        );

  final Size size;
  final double scale;
  final Offset origin;

  Rect map(Rect rect) => Rect.fromLTWH(
        origin.dx + rect.left * scale,
        origin.dy + rect.top * scale,
        rect.width * scale,
        rect.height * scale,
      );

  Rect get board => map(const Rect.fromLTWH(76, 16, 208, 208));
  List<Rect> get slots => List.generate(
        6,
        (i) => map(Rect.fromLTWH(15 + i * 46, 244, 40, 44)),
      );
  List<Rect> get palette => List.generate(
        3,
        (i) => map(Rect.fromLTWH(40 + i * 66, 305, 52, 50)),
      );
  Rect get launch => map(const Rect.fromLTWH(264, 301, 62, 58));
}

class _RocketRoutePainter extends CustomPainter {
  const _RocketRoutePainter({
    required this.accent,
    required this.layout,
    required this.program,
    required this.cell,
    required this.fromCell,
    required this.direction,
    required this.fromDirection,
    required this.activeSlot,
    required this.step,
    required this.reaction,
    required this.ambient,
    required this.collision,
    required this.solved,
  });

  final Color accent;
  final _RouteLayout layout;
  final List<_Command?> program;
  final math.Point<int> cell;
  final math.Point<int> fromCell;
  final int direction;
  final int fromDirection;
  final int activeSlot;
  final double step;
  final double reaction;
  final double ambient;
  final bool collision;
  final bool solved;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(bounds, Paint()..color = const Color(0xFF10233B));
    canvas.save();
    canvas.translate(layout.origin.dx, layout.origin.dy);
    canvas.scale(layout.scale);
    _drawSky(canvas);
    _drawBoard(canvas);
    _drawTape(canvas);
    _drawPalette(canvas);
    _drawLaunch(canvas);
    _drawRocket(canvas);
    canvas.restore();
  }

  void _drawSky(Canvas canvas) {
    for (var i = 0; i < 34; i++) {
      final x = (i * 83 + 17) % 360.0;
      final y = (i * 47 + 11) % 372.0;
      final glow = 0.35 + 0.35 * math.sin(ambient * math.pi * 2 + i);
      canvas.drawCircle(
        Offset(x, y),
        i % 7 == 0 ? 1.4 : 0.7,
        Paint()..color = Colors.white.withValues(alpha: glow),
      );
    }
  }

  void _drawBoard(Canvas canvas) {
    const rect = Rect.fromLTWH(76, 16, 208, 208);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      Paint()..color = const Color(0xFF23415D),
    );
    const cellSize = 48.0;
    for (var y = 0; y < 4; y++) {
      for (var x = 0; x < 4; x++) {
        final tile = RRect.fromRectAndRadius(
          Rect.fromLTWH(84 + x * cellSize, 24 + y * cellSize, 44, 44),
          const Radius.circular(7),
        );
        canvas.drawRRect(
          tile,
          Paint()
            ..color = (x + y).isEven
                ? const Color(0xFF2D526D)
                : const Color(0xFF315B74),
        );
      }
    }
    for (final rock in _RocketRouteGameViewState._rocks) {
      _drawRock(canvas, _cellCenter(rock), rock.x + rock.y * 4);
    }
    _drawStar(canvas, _cellCenter(_RocketRouteGameViewState._goal));
  }

  Offset _cellCenter(math.Point<int> point) =>
      Offset(106 + point.x * 48, 46 + point.y * 48);

  void _drawRock(Canvas canvas, Offset center, int seed) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final radius = i.isEven ? 16.0 : 13.0 + seed % 3;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF8191A1));
    canvas.drawCircle(center + const Offset(-5, -4), 4,
        Paint()..color = const Color(0xFF5E7182));
    canvas.drawCircle(center + const Offset(6, 6), 2.5,
        Paint()..color = const Color(0xFFA9B5BF));
  }

  void _drawStar(Canvas canvas, Offset center) {
    final pulse = 1 + math.sin(ambient * math.pi * 2) * 0.08;
    canvas.drawCircle(center, 21 * pulse,
        Paint()..color = const Color(0xFFFFD75A).withValues(alpha: 0.16));
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final radius = i.isEven ? 17.0 : 7.5;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD75A));
  }

  void _drawTape(Canvas canvas) {
    final rail = RRect.fromRectAndRadius(
      const Rect.fromLTWH(8, 237, 292, 58),
      const Radius.circular(12),
    );
    canvas.drawRRect(rail, Paint()..color = const Color(0xFF0A1729));
    for (var i = 0; i < 6; i++) {
      final rect = Rect.fromLTWH(15 + i * 46, 244, 40, 44);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(7)),
        Paint()
          ..color = i == activeSlot
              ? accent.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.09),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(7)),
        Paint()
          ..color = i == activeSlot ? accent : Colors.white24
          ..style = PaintingStyle.stroke
          ..strokeWidth = i == activeSlot ? 2.5 : 1.2,
      );
      if (program[i] != null) {
        _drawCommand(canvas, rect.center, program[i]!, 14, Colors.white);
      } else {
        canvas.drawCircle(rect.center, 2.2, Paint()..color = Colors.white30);
      }
    }
  }

  void _drawPalette(Canvas canvas) {
    for (var i = 0; i < _Command.values.length; i++) {
      const colors = [Color(0xFF41B8D5), Color(0xFFFFB84D), Color(0xFFFF7183)];
      final rect = Rect.fromLTWH(40 + i * 66, 305, 52, 50);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            rect.shift(const Offset(0, 3)), const Radius.circular(8)),
        Paint()..color = Colors.black.withValues(alpha: 0.28),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()..color = colors[i],
      );
      _drawCommand(canvas, rect.center, _Command.values[i], 18, Colors.white);
    }
  }

  void _drawLaunch(Canvas canvas) {
    const rect = Rect.fromLTWH(264, 301, 62, 58);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect.shift(const Offset(0, 4)), const Radius.circular(17)),
      Paint()..color = const Color(0xFF07101E),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(17)),
      Paint()..color = accent,
    );
    final rocket = Path()
      ..moveTo(295, 312)
      ..quadraticBezierTo(309, 322, 301, 343)
      ..lineTo(289, 343)
      ..quadraticBezierTo(281, 322, 295, 312)
      ..close();
    canvas.drawPath(rocket, Paint()..color = Colors.white);
    canvas.drawCircle(
        const Offset(295, 325), 4, Paint()..color = const Color(0xFF41B8D5));
    final flame = Path()
      ..moveTo(290, 343)
      ..lineTo(295, 352)
      ..lineTo(300, 343)
      ..close();
    canvas.drawPath(flame, Paint()..color = const Color(0xFFFFD75A));
  }

  void _drawCommand(
    Canvas canvas,
    Offset center,
    _Command command,
    double radius,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.22
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (command == _Command.forward) {
      canvas.drawLine(center + Offset(0, radius * 0.7),
          center - Offset(0, radius * 0.65), paint);
      final arrow = Path()
        ..moveTo(center.dx - radius * 0.48, center.dy - radius * 0.18)
        ..lineTo(center.dx, center.dy - radius * 0.7)
        ..lineTo(center.dx + radius * 0.48, center.dy - radius * 0.18);
      canvas.drawPath(arrow, paint);
      return;
    }
    final left = command == _Command.left;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.62),
      left ? -0.2 : math.pi + 0.2,
      left ? -math.pi * 1.25 : math.pi * 1.25,
      false,
      paint,
    );
    final tip = center + Offset(left ? -radius * 0.60 : radius * 0.60, -2);
    final arrow = Path()
      ..moveTo(tip.dx + (left ? 7 : -7), tip.dy - 6)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(tip.dx + (left ? 7 : -7), tip.dy + 6);
    canvas.drawPath(arrow, paint);
  }

  void _drawRocket(Canvas canvas) {
    final eased = Curves.easeInOutCubic.transform(step);
    final position =
        Offset.lerp(_cellCenter(fromCell), _cellCenter(cell), eased)!;
    var angle = fromDirection * math.pi / 2;
    var turnDelta = direction - fromDirection;
    if (turnDelta > 2) turnDelta -= 4;
    if (turnDelta < -2) turnDelta += 4;
    angle += turnDelta * math.pi / 2 * Curves.easeOutBack.transform(step);
    final shake =
        collision ? math.sin(reaction * math.pi * 8) * 5 * (1 - reaction) : 0.0;
    canvas.save();
    canvas.translate(position.dx + shake, position.dy);
    canvas.rotate(angle);
    if (activeSlot >= 0 && cell != fromCell) {
      final flame = Path()
        ..moveTo(-6, 12)
        ..lineTo(0, 23 + math.sin(step * 30) * 3)
        ..lineTo(6, 12)
        ..close();
      canvas.drawPath(flame, Paint()..color = const Color(0xFFFFB84D));
    }
    final body = Path()
      ..moveTo(0, -19)
      ..quadraticBezierTo(13, -7, 9, 13)
      ..lineTo(-9, 13)
      ..quadraticBezierTo(-13, -7, 0, -19)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFF7FAFC));
    canvas.drawPath(
      Path()
        ..moveTo(-8, 5)
        ..lineTo(-15, 15)
        ..lineTo(-7, 12)
        ..close(),
      Paint()..color = accent,
    );
    canvas.drawPath(
      Path()
        ..moveTo(8, 5)
        ..lineTo(15, 15)
        ..lineTo(7, 12)
        ..close(),
      Paint()..color = accent,
    );
    canvas.drawCircle(
        const Offset(0, -5), 4.5, Paint()..color = const Color(0xFF41B8D5));
    canvas.restore();

    if (collision && reaction < 0.75) {
      for (var i = 0; i < 6; i++) {
        final a = i * math.pi / 3;
        canvas.drawCircle(
          position + Offset(math.cos(a), math.sin(a)) * (20 + reaction * 14),
          3 * (1 - reaction),
          Paint()..color = i.isEven ? const Color(0xFFFF7183) : Colors.white,
        );
      }
    }
    if (solved) {
      for (var i = 0; i < 12; i++) {
        final a = i * math.pi / 6 + ambient;
        canvas.drawCircle(
          position + Offset(math.cos(a), math.sin(a)) * (25 + reaction * 22),
          3 * (1 - reaction.clamp(0.0, 0.9)),
          Paint()..color = i.isEven ? accent : const Color(0xFFFFD75A),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RocketRoutePainter oldDelegate) => true;
}

class _CommandTilePainter extends CustomPainter {
  const _CommandTilePainter({required this.command, required this.accent});

  final _Command command;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..color = accent,
    );
    final helper = _RocketRoutePainter(
      accent: accent,
      layout: _RouteLayout(size),
      program: const [],
      cell: const math.Point(0, 0),
      fromCell: const math.Point(0, 0),
      direction: 0,
      fromDirection: 0,
      activeSlot: -1,
      step: 0,
      reaction: 0,
      ambient: 0,
      collision: false,
      solved: false,
    );
    helper._drawCommand(
        canvas, rect.center, command, size.shortestSide * 0.34, Colors.white);
  }

  @override
  bool shouldRepaint(covariant _CommandTilePainter oldDelegate) =>
      oldDelegate.command != command || oldDelegate.accent != accent;
}

class _RouteSemantics {
  const _RouteSemantics({
    required this.instruction,
    required this.forward,
    required this.left,
    required this.right,
    required this.emptySlot,
    required this.launch,
  });

  final String instruction;
  final String forward;
  final String left;
  final String right;
  final String emptySlot;
  final String launch;

  String command(_Command command) => switch (command) {
        _Command.forward => forward,
        _Command.left => left,
        _Command.right => right,
      };

  static _RouteSemantics forLocale(Locale locale) =>
      _values[locale.languageCode] ?? _values['en']!;

  static const _values = <String, _RouteSemantics>{
    'en': _RouteSemantics(
        instruction: 'Drag commands into the program and launch the rocket',
        forward: 'Forward command',
        left: 'Turn left command',
        right: 'Turn right command',
        emptySlot: 'Empty program slot',
        launch: 'Launch rocket'),
    'ru': _RouteSemantics(
        instruction: 'Перетащите команды в программу и запустите ракету',
        forward: 'Команда вперёд',
        left: 'Команда повернуть налево',
        right: 'Команда повернуть направо',
        emptySlot: 'Пустая ячейка программы',
        launch: 'Запустить ракету'),
    'de': _RouteSemantics(
        instruction: 'Befehle ins Programm ziehen und die Rakete starten',
        forward: 'Befehl vorwärts',
        left: 'Befehl links drehen',
        right: 'Befehl rechts drehen',
        emptySlot: 'Leerer Programmplatz',
        launch: 'Rakete starten'),
    'es': _RouteSemantics(
        instruction: 'Arrastra comandos al programa y lanza el cohete',
        forward: 'Comando avanzar',
        left: 'Comando girar a la izquierda',
        right: 'Comando girar a la derecha',
        emptySlot: 'Espacio vacío del programa',
        launch: 'Lanzar cohete'),
    'fr': _RouteSemantics(
        instruction:
            'Glissez les commandes dans le programme et lancez la fusée',
        forward: 'Commande avancer',
        left: 'Commande tourner à gauche',
        right: 'Commande tourner à droite',
        emptySlot: 'Emplacement vide du programme',
        launch: 'Lancer la fusée'),
    'it': _RouteSemantics(
        instruction: 'Trascina i comandi nel programma e lancia il razzo',
        forward: 'Comando avanti',
        left: 'Comando gira a sinistra',
        right: 'Comando gira a destra',
        emptySlot: 'Spazio vuoto del programma',
        launch: 'Lancia il razzo'),
    'pt': _RouteSemantics(
        instruction: 'Arraste comandos para o programa e lance o foguete',
        forward: 'Comando avançar',
        left: 'Comando virar à esquerda',
        right: 'Comando virar à direita',
        emptySlot: 'Espaço vazio do programa',
        launch: 'Lançar foguete'),
    'ar': _RouteSemantics(
        instruction: 'اسحب الأوامر إلى البرنامج ثم أطلق الصاروخ',
        forward: 'أمر التقدم',
        left: 'أمر الانعطاف يسارًا',
        right: 'أمر الانعطاف يمينًا',
        emptySlot: 'خانة برنامج فارغة',
        launch: 'إطلاق الصاروخ'),
    'hi': _RouteSemantics(
        instruction: 'कमांड को प्रोग्राम में खींचें और रॉकेट चलाएँ',
        forward: 'आगे बढ़ने का कमांड',
        left: 'बाएँ मुड़ने का कमांड',
        right: 'दाएँ मुड़ने का कमांड',
        emptySlot: 'प्रोग्राम का खाली स्थान',
        launch: 'रॉकेट चलाएँ'),
    'ja': _RouteSemantics(
        instruction: 'コマンドをプログラムにドラッグしてロケットを発射します',
        forward: '前進コマンド',
        left: '左折コマンド',
        right: '右折コマンド',
        emptySlot: '空のプログラムスロット',
        launch: 'ロケットを発射'),
    'ko': _RouteSemantics(
        instruction: '명령을 프로그램으로 끌어 로켓을 발사하세요',
        forward: '앞으로 명령',
        left: '왼쪽 회전 명령',
        right: '오른쪽 회전 명령',
        emptySlot: '빈 프로그램 칸',
        launch: '로켓 발사'),
    'zh': _RouteSemantics(
        instruction: '将指令拖入程序并发射火箭',
        forward: '前进指令',
        left: '左转指令',
        right: '右转指令',
        emptySlot: '空程序槽',
        launch: '发射火箭'),
  };
}
