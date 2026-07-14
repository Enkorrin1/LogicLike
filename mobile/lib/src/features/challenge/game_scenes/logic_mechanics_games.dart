import 'dart:math' as math;

import 'package:flutter/material.dart';

class OddStepGameView extends StatefulWidget {
  const OddStepGameView({
    super.key,
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<OddStepGameView> createState() => _OddStepGameViewState();
}

class _OddStepGameViewState extends State<OddStepGameView> {
  static const _solution = [0, 1, 2, 3];
  final List<int> _steps = [2, 0, 3, 1];
  int _revision = 0;
  bool _complete = false;

  void _move(int oldIndex, int newIndex) {
    if (_complete) return;
    setState(() {
      final step = _steps.removeAt(oldIndex);
      _steps.insert(newIndex, step);
      _revision++;
    });
    if (_isSolved) {
      setState(() => _complete = true);
      Future<void>.delayed(
        const Duration(milliseconds: 520),
        () => widget.onAnswerSelected(widget.correctAnswer),
      );
    }
  }

  bool get _isSolved {
    for (var index = 0; index < _solution.length; index++) {
      if (_steps[index] != _solution[index]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 210.0 : 252.0;
    return Semantics(
      label: widget.semanticLabel,
      child: AnimatedContainer(
        key: ValueKey(_revision),
        duration: const Duration(milliseconds: 280),
        height: height,
        padding: EdgeInsets.all(widget.compact ? 10 : 14),
        decoration: _sceneDecoration(widget.accent),
        child: Stack(
          children: [
            const Positioned.fill(
                child: CustomPaint(painter: _WorkshopPainter())),
            Column(
              children: [
                _MissionRibbon(
                  color: widget.accent,
                  icon: Icons.route_rounded,
                  text: '1  ·  2  ·  3  ·  4',
                  complete: _complete,
                ),
                const SizedBox(height: 9),
                Expanded(
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    buildDefaultDragHandles: false,
                    itemCount: _steps.length,
                    onReorderItem: _move,
                    proxyDecorator: (child, _, animation) => ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.08).animate(animation),
                      child: Material(color: Colors.transparent, child: child),
                    ),
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      return ReorderableDragStartListener(
                        key: ValueKey(step),
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _ActionTile(
                            number: index + 1,
                            action: step,
                            color: widget.accent,
                            complete: _complete,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SecretCodeGameView extends StatefulWidget {
  const SecretCodeGameView({
    super.key,
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<SecretCodeGameView> createState() => _SecretCodeGameViewState();
}

class _SecretCodeGameViewState extends State<SecretCodeGameView> {
  static const _code = [2, 4, 8];
  final List<int> _entered = [];
  int _errors = 0;
  bool _complete = false;

  void _press(int digit) {
    if (_complete) return;
    final expected = _code[_entered.length];
    if (digit != expected) {
      setState(() {
        _entered.clear();
        _errors++;
      });
      return;
    }
    setState(() => _entered.add(digit));
    if (_entered.length == _code.length) {
      setState(() => _complete = true);
      Future<void>.delayed(
        const Duration(milliseconds: 600),
        () => widget.onAnswerSelected(widget.correctAnswer),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        height: widget.compact ? 306 : 326,
        padding: EdgeInsets.all(widget.compact ? 10 : 14),
        decoration: _sceneDecoration(widget.accent),
        child: Column(
          children: [
            _MissionRibbon(
              color: widget.accent,
              icon: Icons.lock_rounded,
              text: '●●  ●●●●  ●●●●●●●●',
              complete: _complete,
            ),
            const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween(begin: const Offset(.08, 0), end: Offset.zero)
                    .animate(animation),
                child: child,
              ),
              child: Row(
                key: ValueKey(_errors),
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final filled = index < _entered.length;
                  return Container(
                    width: 42,
                    height: 38,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: filled ? widget.accent : Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                          color: widget.accent.withValues(alpha: .45),
                          width: 2),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x16072D38), offset: Offset(0, 3))
                      ],
                    ),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.lock_outline_rounded,
                      color: filled
                          ? Colors.white
                          : widget.accent.withValues(alpha: .5),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: widget.compact ? 2.2 : 1.65,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 7,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final digit = index + 1;
                  return _KeyButton(
                    digit: digit,
                    color: widget.accent,
                    onTap: () => _press(digit),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoonClockGameView extends StatefulWidget {
  const MoonClockGameView({
    super.key,
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<MoonClockGameView> createState() => _MoonClockGameViewState();
}

class _MoonClockGameViewState extends State<MoonClockGameView> {
  double _minutes = 37;
  bool _complete = false;

  void _drag(Offset local, Size size) {
    if (_complete) return;
    final center = Offset(size.width / 2, size.height / 2);
    final delta = local - center;
    var angle = math.atan2(delta.dy, delta.dx) + math.pi / 2;
    if (angle < 0) angle += math.pi * 2;
    setState(() => _minutes = (angle / (math.pi * 2) * 60).roundToDouble());
  }

  void _release() {
    if (_complete || !(_minutes <= 2 || _minutes >= 58)) return;
    setState(() {
      _minutes = 0;
      _complete = true;
    });
    Future<void>.delayed(
      const Duration(milliseconds: 650),
      () => widget.onAnswerSelected(widget.correctAnswer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 204.0 : 244.0;
    return Semantics(
      label: widget.semanticLabel,
      child: Container(
        height: widget.compact ? 252 : 300,
        padding: const EdgeInsets.all(10),
        decoration: _sceneDecoration(widget.accent),
        child: Column(
          children: [
            _MissionRibbon(
              color: widget.accent,
              icon: Icons.rocket_launch_rounded,
              text: '3:00',
              complete: _complete,
            ),
            const SizedBox(height: 7),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanDown: (details) =>
                      _drag(details.localPosition, Size.square(size)),
                  onPanUpdate: (details) =>
                      _drag(details.localPosition, Size.square(size)),
                  onPanEnd: (_) => _release(),
                  child: AnimatedScale(
                    scale: _complete ? 1.04 : 1,
                    duration: const Duration(milliseconds: 250),
                    child: CustomPaint(
                      size: Size.square(size),
                      painter: _MoonClockPainter(
                        accent: widget.accent,
                        minutes: _minutes,
                        complete: _complete,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _sceneDecoration(Color accent) => BoxDecoration(
      gradient: LinearGradient(
        colors: [
          accent.withValues(alpha: .22),
          const Color(0xFFF2FBFF),
          Colors.white
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: accent.withValues(alpha: .28), width: 1.5),
    );

class _MissionRibbon extends StatelessWidget {
  const _MissionRibbon({
    required this.color,
    required this.icon,
    required this.text,
    required this.complete,
  });

  final Color color;
  final IconData icon;
  final String text;
  final bool complete;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        height: 43,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: complete ? const Color(0xFF42C997) : const Color(0xEFFFFFFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Color(0x17072D38), offset: Offset(0, 3))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(complete ? Icons.check_circle_rounded : icon,
                color: complete ? Colors.white : color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                style: TextStyle(
                  color: complete ? Colors.white : const Color(0xFF153E49),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.number,
    required this.action,
    required this.color,
    required this.complete,
  });

  final int number;
  final int action;
  final Color color;
  final bool complete;

  static const _icons = [
    Icons.water_drop_rounded,
    Icons.spa_rounded,
    Icons.wb_sunny_rounded,
    Icons.local_florist_rounded,
  ];

  @override
  Widget build(BuildContext context) => Container(
        width: 68,
        decoration: BoxDecoration(
          color: complete ? const Color(0xFFE7FFF3) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: complete
                  ? const Color(0xFF42C997)
                  : color.withValues(alpha: .32),
              width: 2),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1B072D38), offset: Offset(0, 5), blurRadius: 7)
          ],
        ),
        child: Stack(
          children: [
            Center(child: Icon(_icons[action], size: 31, color: color)),
            Positioned(
              top: 5,
              left: 7,
              child: Text('$number',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xFF58737A))),
            ),
            const Positioned(
                right: 5,
                bottom: 5,
                child: Icon(Icons.drag_indicator_rounded,
                    size: 18, color: Color(0xFF9DB2B8))),
          ],
        ),
      );
}

class _KeyButton extends StatefulWidget {
  const _KeyButton(
      {required this.digit, required this.color, required this.onTap});
  final int digit;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? .91 : 1,
          duration: const Duration(milliseconds: 80),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: widget.color.withValues(alpha: .28)),
              boxShadow: _pressed
                  ? null
                  : const [
                      BoxShadow(color: Color(0x28072D38), offset: Offset(0, 4))
                    ],
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.digit}',
              style: TextStyle(
                  color: widget.color,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0),
            ),
          ),
        ),
      );
}

class _MoonClockPainter extends CustomPainter {
  const _MoonClockPainter(
      {required this.accent, required this.minutes, required this.complete});
  final Color accent;
  final double minutes;
  final bool complete;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;
    canvas.drawCircle(center + const Offset(0, 5), radius,
        Paint()..color = const Color(0x24072D38));
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFFFD86B));
    canvas.drawCircle(
        center, radius - 8, Paint()..color = const Color(0xFFFFF5C8));

    final tickPaint = Paint()
      ..color = const Color(0xFF31515A)
      ..strokeCap = StrokeCap.round;
    for (var tick = 0; tick < 12; tick++) {
      final angle = tick * math.pi / 6 - math.pi / 2;
      final outer =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius - 14);
      final inner = center +
          Offset(math.cos(angle), math.sin(angle)) *
              (radius - (tick % 3 == 0 ? 29 : 22));
      tickPaint.strokeWidth = tick % 3 == 0 ? 4 : 2;
      canvas.drawLine(inner, outer, tickPaint);
    }

    _hand(
        canvas, center, -math.pi / 2, radius * .48, const Color(0xFFEF665F), 8);
    final minuteAngle = minutes / 60 * math.pi * 2 - math.pi / 2;
    _hand(canvas, center, minuteAngle, radius * .69, accent, 6);
    canvas.drawCircle(center, 10,
        Paint()..color = complete ? const Color(0xFF42C997) : accent);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);

    final rocket = Offset(size.width - 30, 32);
    canvas.drawCircle(
        rocket,
        19,
        Paint()
          ..color =
              complete ? const Color(0xFF42C997) : const Color(0xFFFFFFFF));
    final icon = TextPainter(
      text: TextSpan(
          text: complete ? '✓' : '★',
          style: TextStyle(
              color: complete ? Colors.white : accent,
              fontSize: 22,
              fontWeight: FontWeight.w900)),
      textDirection: TextDirection.ltr,
    )..layout();
    icon.paint(canvas, rocket - Offset(icon.width / 2, icon.height / 2));
  }

  void _hand(Canvas canvas, Offset center, double angle, double length,
      Color color, double width) {
    canvas.drawLine(
      center,
      center + Offset(math.cos(angle), math.sin(angle)) * length,
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _MoonClockPainter oldDelegate) =>
      oldDelegate.minutes != minutes ||
      oldDelegate.complete != complete ||
      oldDelegate.accent != accent;
}

class _WorkshopPainter extends CustomPainter {
  const _WorkshopPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x1600AFA6);
    for (var index = 0; index < 8; index++) {
      final x = 18.0 + index * (size.width - 36) / 7;
      final y = size.height - 18 - (index.isEven ? 7 : 0);
      canvas.drawCircle(Offset(x, y), index.isEven ? 4 : 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
