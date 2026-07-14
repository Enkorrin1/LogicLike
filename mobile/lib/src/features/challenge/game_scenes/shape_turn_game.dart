import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShapeTurnGameView extends StatefulWidget {
  const ShapeTurnGameView({
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
  State<ShapeTurnGameView> createState() => _ShapeTurnGameViewState();
}

class _ShapeTurnGameViewState extends State<ShapeTurnGameView>
    with TickerProviderStateMixin {
  static const _starts = <int>[1, 3, 2];
  static const _targets = <int>[0, 2, 1];
  static const _homes = <Offset>[
    Offset(76, 167),
    Offset(76, 112),
    Offset(76, 58),
  ];
  static const _slots = <Offset>[
    Offset(272, 167),
    Offset(272, 112),
    Offset(272, 58),
  ];

  late final AnimationController _turn;
  late final AnimationController _return;
  late final AnimationController _success;
  late final List<Offset> _positions;
  late final List<int> _rotations;
  final List<bool> _placed = [false, false, false];
  final GlobalKey _boardKey = GlobalKey();
  int? _active;
  Offset _anchor = Offset.zero;
  Offset _returnFrom = Offset.zero;
  int _turnFrom = 0;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _positions = List.of(_homes);
    _rotations = List.of(_starts);
    _turn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _return = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        final i = _active;
        if (i == null) return;
        setState(() => _positions[i] = Offset.lerp(
              _returnFrom,
              _homes[i],
              Curves.easeOutBack.transform(_return.value),
            )!);
      });
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _turn.dispose();
    _return.dispose();
    _success.dispose();
    super.dispose();
  }

  Offset _toBoard(Offset local, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin =
        Offset((size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    return (local - origin) / scale;
  }

  int? _hit(Offset point) {
    for (var i = 0; i < 3; i++) {
      if (!_placed[i] && (point - _positions[i]).distance < 35) return i;
    }
    return null;
  }

  void _start(DragStartDetails details, Size size) {
    final point = _toBoard(details.localPosition, size);
    final hit = _hit(point);
    if (hit == null) return;
    _return.stop();
    setState(() => _active = hit);
    _anchor = point - _positions[hit];
  }

  void _move(DragUpdateDetails details, Size size) {
    final i = _active;
    if (i == null || _return.isAnimating) return;
    setState(
        () => _positions[i] = _toBoard(details.localPosition, size) - _anchor);
  }

  Future<void> _end(DragEndDetails details) async {
    final i = _active;
    if (i == null || _return.isAnimating) return;
    if ((_positions[i] - _slots[i]).distance < 38 &&
        _rotations[i] % 4 == _targets[i]) {
      setState(() {
        _positions[i] = _slots[i];
        _placed[i] = true;
        _active = null;
      });
      HapticFeedback.mediumImpact();
      if (_placed.every((value) => value)) {
        await _success.forward(from: 0);
        if (!mounted || _answerSent) return;
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      }
      return;
    }
    HapticFeedback.selectionClick();
    _returnFrom = _positions[i];
    _return.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _active = null);
    });
  }

  void _rotate(Offset point) {
    final i = _hit(point);
    if (i == null || _turn.isAnimating || _return.isAnimating) return;
    _turnFrom = _rotations[i];
    setState(() {
      _active = i;
      _rotations[i] = (_rotations[i] + 1) % 4;
    });
    HapticFeedback.selectionClick();
    _turn.forward(from: 0).whenComplete(() {
      if (mounted && !_return.isAnimating) setState(() => _active = null);
    });
  }

  double _angleFor(int i) {
    if (_active == i && _turn.isAnimating) {
      return (_turnFrom + Curves.easeOutBack.transform(_turn.value)) *
          math.pi /
          2;
    }
    return _rotations[i] * math.pi / 2;
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: widget.semanticLabel,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(
              builder: (_, constraints) {
                final size = constraints.biggest;
                return Stack(
                  key: _boardKey,
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapUp: (d) => _rotate(_toBoard(d.localPosition, size)),
                      onPanStart: (d) => _start(d, size),
                      onPanUpdate: (d) => _move(d, size),
                      onPanEnd: _end,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_turn, _return, _success]),
                        builder: (_, __) => CustomPaint(
                          painter: _ShapeTurnPainter(
                            accent: widget.accent,
                            positions: List.of(_positions),
                            angles: List.generate(3, _angleFor),
                            placed: List.of(_placed),
                            active: _active,
                            success: _success.value,
                          ),
                        ),
                      ),
                    ),
                    for (var i = 0; i < 3; i++) ...[
                      _slotHook(
                        size,
                        _slots[i],
                        ValueKey('shape-turn-slot-$i'),
                      ),
                      if (!_placed[i]) _pieceHook(size, i),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      );

  ({Offset center, double extent}) _hookGeometry(Size size, Offset point) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin = Offset(
      (size.width - 360 * scale) / 2,
      (size.height - 240 * scale) / 2,
    );
    return (center: origin + point * scale, extent: 56 * scale);
  }

  Widget _slotHook(Size size, Offset point, Key key) {
    final geometry = _hookGeometry(size, point);
    return Positioned(
      left: geometry.center.dx - geometry.extent / 2,
      top: geometry.center.dy - geometry.extent / 2,
      width: geometry.extent,
      height: geometry.extent,
      child: Semantics(
        key: key,
        container: true,
        child: const ColoredBox(color: Colors.transparent),
      ),
    );
  }

  Widget _pieceHook(Size size, int index) {
    final geometry = _hookGeometry(size, _positions[index]);
    final topLeft =
        geometry.center - Offset(geometry.extent / 2, geometry.extent / 2);
    Offset toScene(Offset globalPosition) {
      final board = _boardKey.currentContext!.findRenderObject()! as RenderBox;
      return board.globalToLocal(globalPosition);
    }

    return Positioned(
      left: topLeft.dx,
      top: topLeft.dy,
      width: geometry.extent,
      height: geometry.extent,
      child: Semantics(
        container: true,
        child: Listener(
          onPointerDown: (event) => _start(
            DragStartDetails(
              sourceTimeStamp: event.timeStamp,
              globalPosition: event.position,
              localPosition: toScene(event.position),
              kind: event.kind,
            ),
            size,
          ),
          child: GestureDetector(
            key: ValueKey('shape-turn-piece-$index'),
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) =>
                _rotate(_toBoard(toScene(details.globalPosition), size)),
            onPanUpdate: (details) => _move(
              DragUpdateDetails(
                sourceTimeStamp: details.sourceTimeStamp,
                delta: details.delta,
                primaryDelta: details.primaryDelta,
                globalPosition: details.globalPosition,
                localPosition: toScene(details.globalPosition),
              ),
              size,
            ),
            onPanEnd: _end,
          ),
        ),
      ),
    );
  }
}

class _ShapeTurnPainter extends CustomPainter {
  const _ShapeTurnPainter({
    required this.accent,
    required this.positions,
    required this.angles,
    required this.placed,
    required this.active,
    required this.success,
  });

  final Color accent;
  final List<Offset> positions;
  final List<double> angles;
  final List<bool> placed;
  final int? active;
  final double success;

  Path _shape(int type) {
    switch (type) {
      case 0:
        return Path()
          ..moveTo(0, -28)
          ..lineTo(25, 18)
          ..lineTo(-25, 18)
          ..close();
      case 1:
        return Path()
          ..moveTo(-27, -15)
          ..lineTo(8, -15)
          ..lineTo(8, -28)
          ..lineTo(28, 0)
          ..lineTo(8, 28)
          ..lineTo(8, 15)
          ..lineTo(-27, 15)
          ..close();
      default:
        return Path()
          ..moveTo(-25, -22)
          ..lineTo(25, -22)
          ..lineTo(12, 0)
          ..lineTo(25, 22)
          ..lineTo(-25, 22)
          ..lineTo(-12, 0)
          ..close();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin =
        Offset((size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF182750), Color(0xFF347D8C)],
        ).createShader(Offset.zero & size),
    );
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.scale(scale);
    for (var i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset((i * 67 + 12) % 350, (i * 41 + 9) % 225),
        i.isEven ? 1.4 : .8,
        Paint()..color = Colors.white38,
      );
    }
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(_ShapeTurnGameViewState._slots[i].dx,
          _ShapeTurnGameViewState._slots[i].dy);
      canvas.rotate(_ShapeTurnGameViewState._targets[i] * math.pi / 2);
      canvas.drawPath(
        _shape(i),
        Paint()
          ..color = placed[i]
              ? const Color(0xFF6AF0BE).withValues(alpha: .3)
              : accent.withValues(alpha: .1),
      );
      canvas.drawPath(
        _shape(i),
        Paint()
          ..color = placed[i] ? Colors.white : accent.withValues(alpha: .75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = placed[i] ? 3 : 2,
      );
      canvas.restore();

      canvas.save();
      canvas.translate(
          positions[i].dx, positions[i].dy - (active == i ? 5 : 0));
      canvas.rotate(angles[i]);
      final shape = _shape(i);
      canvas.drawShadow(shape, Colors.black, active == i ? 12 : 6, false);
      final colors = <List<Color>>[
        const [Color(0xFFFFD45C), Color(0xFFFF7181)],
        const [Color(0xFF67E8C2), Color(0xFF45A9E8)],
        const [Color(0xFFC58AFF), Color(0xFFFF7DC2)],
      ];
      canvas.drawPath(
        shape,
        Paint()
          ..shader = LinearGradient(colors: colors[i])
              .createShader(const Rect.fromLTWH(-30, -30, 60, 60)),
      );
      canvas.drawPath(
        shape,
        Paint()
          ..color = Colors.white.withValues(alpha: .8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.restore();
    }
    if (success > 0) {
      for (var i = 0; i < 20; i++) {
        final a = i * math.pi * 2 / 20;
        final p = const Offset(180, 120) +
            Offset(math.cos(a), math.sin(a)) * (42 + success * 115);
        canvas.drawCircle(p, 4 * (1 - success),
            Paint()..color = i.isEven ? accent : const Color(0xFFFFD45C));
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShapeTurnPainter old) =>
      old.positions != positions ||
      old.angles != angles ||
      old.placed != placed ||
      old.active != active ||
      old.success != success ||
      old.accent != accent;
}
