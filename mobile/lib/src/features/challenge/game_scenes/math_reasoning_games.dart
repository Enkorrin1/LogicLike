import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberBridgeReasoningGameView extends StatefulWidget {
  const NumberBridgeReasoningGameView({
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
  State<NumberBridgeReasoningGameView> createState() =>
      _NumberBridgeReasoningGameViewState();
}

class _NumberBridgeReasoningGameViewState
    extends State<NumberBridgeReasoningGameView> with TickerProviderStateMixin {
  static const _choices = [3, 5, 4, 2, 6];
  final List<int?> _slots = List.filled(3, null);
  late final AnimationController _reaction;
  late final AnimationController _success;
  bool _collapsing = false;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _drop(int slot, int value) async {
    if (_collapsing || _solved || _slots.contains(value)) return;
    HapticFeedback.selectionClick();
    setState(() => _slots[slot] = value);
    if (_slots.any((value) => value == null)) return;
    if (_slots[0] == 3 && _slots[1] == 4 && _slots[2] == 5) {
      setState(() => _solved = true);
      HapticFeedback.mediumImpact();
      await _success.forward(from: 0);
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
      return;
    }
    setState(() => _collapsing = true);
    HapticFeedback.lightImpact();
    await _reaction.forward(from: 0);
    if (!mounted) return;
    setState(() {
      _slots.fillRange(0, _slots.length, null);
      _collapsing = false;
    });
    _reaction.reset();
  }

  @override
  Widget build(BuildContext context) {
    return _SceneFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _BoardLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_reaction, _success]),
                builder: (context, child) => CustomPaint(
                  painter: _BridgePainter(
                    accent: widget.accent,
                    slots: _slots,
                    collapse: _reaction.value,
                    success: _success.value,
                    solved: _solved,
                  ),
                ),
              ),
              for (var i = 0; i < 3; i++)
                Positioned.fromRect(
                  rect: layout.rect(155 + i * 58, 82, 50, 58),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (details) =>
                        !_collapsing &&
                        !_solved &&
                        _slots[i] == null &&
                        !_slots.contains(details.data),
                    onAcceptWithDetails: (details) => _drop(i, details.data),
                    builder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
              for (var i = 0; i < _choices.length; i++)
                if (!_slots.contains(_choices[i]))
                  Positioned.fromRect(
                    rect: layout.rect(37 + i * 58, 174, 46, 46),
                    child: _NumberDraggable(
                      value: _choices[i],
                      accent: widget.accent,
                      enabled: !_collapsing && !_solved,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class StarBalanceReasoningGameView extends StatefulWidget {
  const StarBalanceReasoningGameView({
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
  State<StarBalanceReasoningGameView> createState() =>
      _StarBalanceReasoningGameViewState();
}

class _StarBalanceReasoningGameViewState
    extends State<StarBalanceReasoningGameView> with TickerProviderStateMixin {
  final List<int> _left = [];
  final List<int> _right = [];
  late final AnimationController _motion;
  late final AnimationController _success;
  double _fromTilt = 0;
  double _tilt = 0;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _motion.dispose();
    _success.dispose();
    super.dispose();
  }

  double get _animatedTilt =>
      _fromTilt +
      (_tilt - _fromTilt) * Curves.easeOutBack.transform(_motion.value);

  Future<void> _place(int star, bool left) async {
    if (_solved || _left.contains(star) || _right.contains(star)) return;
    final bowl = left ? _left : _right;
    if (bowl.length >= 4) {
      HapticFeedback.lightImpact();
      _motion.forward(from: 0);
      return;
    }
    _fromTilt = _animatedTilt;
    setState(() {
      bowl.add(star);
      _tilt = ((_right.length - _left.length) * 0.095).clamp(-0.32, 0.32);
    });
    HapticFeedback.selectionClick();
    _motion.forward(from: 0);
    if (_left.length == 4 && _right.length == 4) {
      setState(() => _solved = true);
      HapticFeedback.mediumImpact();
      await _success.forward(from: 0);
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SceneFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _BoardLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_motion, _success]),
                builder: (_, __) => CustomPaint(
                  painter: _BalancePainter(
                    accent: widget.accent,
                    left: _left,
                    right: _right,
                    tilt: _animatedTilt,
                    success: _success.value,
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: layout.rect(18, 94, 140, 76),
                child: DragTarget<int>(
                  onWillAcceptWithDetails: (_) => !_solved && _left.length < 4,
                  onAcceptWithDetails: (details) => _place(details.data, true),
                  builder: (_, __, ___) => const SizedBox.expand(),
                ),
              ),
              Positioned.fromRect(
                rect: layout.rect(202, 94, 140, 76),
                child: DragTarget<int>(
                  onWillAcceptWithDetails: (_) => !_solved && _right.length < 4,
                  onAcceptWithDetails: (details) => _place(details.data, false),
                  builder: (_, __, ___) => const SizedBox.expand(),
                ),
              ),
              for (var i = 0; i < 8; i++)
                if (!_left.contains(i) && !_right.contains(i))
                  Positioned.fromRect(
                    rect: layout.rect(40 + i * 40, 187, 34, 34),
                    child: _StarDraggable(
                      id: i,
                      accent: widget.accent,
                      enabled: !_solved,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class NumberNeighborsReasoningGameView extends StatefulWidget {
  const NumberNeighborsReasoningGameView({
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
  State<NumberNeighborsReasoningGameView> createState() =>
      _NumberNeighborsReasoningGameViewState();
}

class _NumberNeighborsReasoningGameViewState
    extends State<NumberNeighborsReasoningGameView>
    with TickerProviderStateMixin {
  final Map<int, int> _placed = {};
  late final AnimationController _error;
  late final AnimationController _success;
  int _errorSlot = -1;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _drop(int slot, int value) async {
    if (_solved || _placed.containsValue(value)) return;
    final expected = slot == 1 ? 6 : 8;
    if (value != expected) {
      setState(() => _errorSlot = slot);
      HapticFeedback.lightImpact();
      await _error.forward(from: 0);
      if (!mounted) return;
      setState(() => _errorSlot = -1);
      _error.reset();
      return;
    }
    setState(() => _placed[slot] = value);
    HapticFeedback.selectionClick();
    if (_placed.length != 2) return;
    setState(() => _solved = true);
    HapticFeedback.mediumImpact();
    await _success.forward(from: 0);
    if (!mounted || _answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return _SceneFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _BoardLayout(constraints.biggest);
          const missingSlots = [1, 3];
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_error, _success]),
                builder: (_, __) => CustomPaint(
                  painter: _NeighborsPainter(
                    accent: widget.accent,
                    placed: _placed,
                    errorSlot: _errorSlot,
                    error: _error.value,
                    success: _success.value,
                  ),
                ),
              ),
              for (final slot in missingSlots)
                Positioned.fromRect(
                  rect: layout.rect(38 + slot * 58, 88, 52, 70),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (_) =>
                        !_solved && !_placed.containsKey(slot),
                    onAcceptWithDetails: (details) => _drop(slot, details.data),
                    builder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
              for (final value in const [8, 6])
                if (!_placed.containsValue(value))
                  Positioned.fromRect(
                    rect: layout.rect(value == 8 ? 116 : 198, 184, 50, 50),
                    child: _NumberDraggable(
                      value: value,
                      accent: widget.accent,
                      enabled: !_solved,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _SceneFrame extends StatelessWidget {
  const _SceneFrame({
    required this.compact,
    required this.semanticLabel,
    required this.child,
  });

  final bool compact;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: compact ? 216 : 246,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BoardLayout {
  _BoardLayout(this.size)
      : scale = math.min(size.width / 360, size.height / 240),
        origin = Offset(
          (size.width - 360 * math.min(size.width / 360, size.height / 240)) /
              2,
          (size.height - 240 * math.min(size.width / 360, size.height / 240)) /
              2,
        );

  final Size size;
  final double scale;
  final Offset origin;

  Rect rect(double x, double y, double width, double height) => Rect.fromLTWH(
        origin.dx + x * scale,
        origin.dy + y * scale,
        width * scale,
        height * scale,
      );
}

class _NumberDraggable extends StatelessWidget {
  const _NumberDraggable({
    required this.value,
    required this.accent,
    required this.enabled,
  });

  final int value;
  final Color accent;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tile = _PaintTile(value: value, accent: accent);
    return Semantics(
      label: '$value',
      child: Draggable<int>(
        data: value,
        maxSimultaneousDrags: enabled ? 1 : 0,
        feedback: Material(
            color: Colors.transparent,
            child: SizedBox.fromSize(size: const Size.square(52), child: tile)),
        childWhenDragging: Opacity(opacity: 0.2, child: tile),
        child: tile,
      ),
    );
  }
}

class _PaintTile extends StatelessWidget {
  const _PaintTile({required this.value, required this.accent});
  final int value;
  final Color accent;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _TilePainter(value: value, accent: accent),
      );
}

class _StarDraggable extends StatelessWidget {
  const _StarDraggable(
      {required this.id, required this.accent, required this.enabled});
  final int id;
  final Color accent;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final star = CustomPaint(painter: _StarPainter(accent));
    return Semantics(
      label: '${id + 1}',
      child: Draggable<int>(
        data: id,
        maxSimultaneousDrags: enabled ? 1 : 0,
        feedback: SizedBox.square(dimension: 42, child: star),
        childWhenDragging: Opacity(opacity: 0.15, child: star),
        child: star,
      ),
    );
  }
}

abstract class _BoardPainter extends CustomPainter {
  const _BoardPainter();

  void begin(Canvas canvas, Size size, List<Color> colors) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ).createShader(Offset.zero & size),
    );
    final scale = math.min(size.width / 360, size.height / 240);
    canvas.save();
    canvas.translate(
        (size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    canvas.scale(scale);
  }

  void number(
      Canvas canvas, int value, Offset center, double size, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: '$value',
        style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w900,
            color: color,
            height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  Path starPath(Offset center, double outer) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? outer : outer * 0.46;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final p = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }
}

class _BridgePainter extends _BoardPainter {
  const _BridgePainter(
      {required this.accent,
      required this.slots,
      required this.collapse,
      required this.success,
      required this.solved});
  final Color accent;
  final List<int?> slots;
  final double collapse;
  final double success;
  final bool solved;

  @override
  void paint(Canvas canvas, Size size) {
    begin(canvas, size, const [Color(0xFF8ED8E0), Color(0xFF307B91)]);
    canvas.drawRect(const Rect.fromLTWH(0, 137, 360, 103),
        Paint()..color = const Color(0xFF28718C));
    for (var i = 0; i < 8; i++) {
      final y = 151 + i * 12.0;
      canvas.drawArc(
          Rect.fromLTWH((i * 53) % 330.0, y, 42, 8),
          0,
          math.pi,
          false,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
    canvas.drawRect(const Rect.fromLTWH(0, 112, 34, 50),
        Paint()..color = const Color(0xFF4E8B58));
    canvas.drawRect(const Rect.fromLTWH(326, 112, 34, 50),
        Paint()..color = const Color(0xFF4E8B58));
    final values = <int?>[1, 2, ...slots];
    for (var i = 0; i < values.length; i++) {
      var center = Offset(51 + i * 58.0, 111);
      if (i >= 2 && collapse > 0) {
        center += Offset(math.sin(collapse * math.pi * 5 + i) * 7,
            75 * Curves.easeIn.transform(collapse));
      }
      _stone(canvas, center, values[i], accent, solved ? success : 0);
    }
    canvas.restore();
  }

  void _stone(Canvas canvas, Offset c, int? value, Color accent, double glow) {
    final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: 50, height: 43),
        const Radius.circular(16));
    canvas.drawShadow(Path()..addRRect(rect), Colors.black, 5, false);
    canvas.drawRRect(
        rect,
        Paint()
          ..color = value == null
              ? Colors.white.withValues(alpha: 0.18)
              : Color.lerp(
                  const Color(0xFFE9EFF0), accent, 0.18 + glow * 0.25)!);
    if (value != null) number(canvas, value, c, 25, const Color(0xFF173A4B));
  }

  @override
  bool shouldRepaint(covariant _BridgePainter old) => true;
}

class _BalancePainter extends _BoardPainter {
  const _BalancePainter(
      {required this.accent,
      required this.left,
      required this.right,
      required this.tilt,
      required this.success});
  final Color accent;
  final List<int> left;
  final List<int> right;
  final double tilt;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    begin(canvas, size, const [Color(0xFF18385B), Color(0xFF3C7181)]);
    for (var i = 0; i < 12; i++) {
      canvas.drawCircle(Offset(18 + i * 31, 22 + (i * 37) % 54), 1.4,
          Paint()..color = Colors.white.withValues(alpha: 0.45));
    }
    canvas.save();
    canvas.translate(180, 119);
    canvas.rotate(tilt);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-135, -5, 270, 10), const Radius.circular(5)),
        Paint()..color = const Color(0xFFE3B661));
    _bowl(canvas, const Offset(-105, 30), left);
    _bowl(canvas, const Offset(105, 30), right);
    canvas.restore();
    canvas.drawPath(
        Path()
          ..moveTo(180, 109)
          ..lineTo(151, 184)
          ..lineTo(209, 184)
          ..close(),
        Paint()..color = const Color(0xFFDFC06F));
    canvas.drawOval(const Rect.fromLTWH(132, 179, 96, 13),
        Paint()..color = const Color(0xFFB58A43));
    if (success > 0) {
      canvas.drawCircle(const Offset(180, 112), 22 + success * 15,
          Paint()..color = accent.withValues(alpha: (1 - success) * 0.3));
    }
    canvas.restore();
  }

  void _bowl(Canvas canvas, Offset center, List<int> stars) {
    canvas.drawLine(
        Offset(center.dx, -1),
        center,
        Paint()
          ..color = const Color(0xFFE9DDA8)
          ..strokeWidth = 2);
    final bowl = Path()
      ..moveTo(center.dx - 58, center.dy)
      ..quadraticBezierTo(center.dx, center.dy + 48, center.dx + 58, center.dy)
      ..close();
    canvas.drawPath(bowl, Paint()..color = const Color(0xFF74B9BE));
    for (var i = 0; i < stars.length; i++) {
      final p = center + Offset(-31 + (i % 2) * 31.0, 7 + (i ~/ 2) * 18.0);
      canvas.drawPath(
          starPath(p, 13), Paint()..color = const Color(0xFFFFD75E));
    }
  }

  @override
  bool shouldRepaint(covariant _BalancePainter old) => true;
}

class _NeighborsPainter extends _BoardPainter {
  const _NeighborsPainter(
      {required this.accent,
      required this.placed,
      required this.errorSlot,
      required this.error,
      required this.success});
  final Color accent;
  final Map<int, int> placed;
  final int errorSlot;
  final double error;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    begin(canvas, size, const [Color(0xFFB9E4E0), Color(0xFF70B5A5)]);
    canvas.drawRect(const Rect.fromLTWH(0, 160, 360, 80),
        Paint()..color = const Color(0xFF468677));
    canvas.drawLine(
        const Offset(18, 174),
        const Offset(342, 174),
        Paint()
          ..color = const Color(0xFF394F51)
          ..strokeWidth = 5);
    canvas.drawLine(
        const Offset(18, 205),
        const Offset(342, 205),
        Paint()
          ..color = const Color(0xFF394F51)
          ..strokeWidth = 5);
    const fixed = {0: 5, 2: 7, 4: 9};
    for (var slot = 0; slot < 5; slot++) {
      final value = fixed[slot] ?? placed[slot];
      var x = 64 + slot * 58.0;
      if (slot == errorSlot) x += math.sin(error * math.pi * 6) * 6;
      final body = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, 123), width: 52, height: 62),
          const Radius.circular(8));
      canvas.drawShadow(Path()..addRRect(body), Colors.black, 5, false);
      canvas.drawRRect(
          body,
          Paint()
            ..color = value == null
                ? Colors.white.withValues(alpha: 0.32)
                : Color.lerp(const Color(0xFFFFE58B), accent, success * 0.28)!);
      canvas.drawCircle(
          Offset(x - 15, 159), 7, Paint()..color = const Color(0xFF324B55));
      canvas.drawCircle(
          Offset(x + 15, 159), 7, Paint()..color = const Color(0xFF324B55));
      if (value != null) {
        number(canvas, value, Offset(x, 119), 27, const Color(0xFF244653));
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NeighborsPainter old) => true;
}

class _TilePainter extends _BoardPainter {
  const _TilePainter({required this.value, required this.accent});
  final int value;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
        Offset.zero & size, Radius.circular(size.shortestSide * 0.3));
    canvas.drawShadow(Path()..addRRect(rect), Colors.black45, 6, false);
    canvas.drawRRect(
        rect, Paint()..color = Color.lerp(Colors.white, accent, 0.2)!);
    final painter = TextPainter(
        text: TextSpan(
            text: '$value',
            style: TextStyle(
                fontSize: size.shortestSide * 0.55,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF203E4B),
                height: 1)),
        textDirection: TextDirection.ltr)
      ..layout();
    painter.paint(
        canvas,
        Offset((size.width - painter.width) / 2,
            (size.height - painter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant _TilePainter old) =>
      old.value != value || old.accent != accent;
}

class _StarPainter extends _BoardPainter {
  const _StarPainter(this.accent);
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final path = starPath(center, size.shortestSide * 0.46);
    canvas.drawShadow(path, Colors.black45, 5, false);
    canvas.drawPath(path,
        Paint()..color = Color.lerp(const Color(0xFFFFD75E), accent, 0.12)!);
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.accent != accent;
}
