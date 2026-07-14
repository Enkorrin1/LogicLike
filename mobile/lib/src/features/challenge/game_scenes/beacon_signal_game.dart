import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BeaconSignalGameView extends StatefulWidget {
  const BeaconSignalGameView({
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
  State<BeaconSignalGameView> createState() => _BeaconSignalGameViewState();
}

class _BeaconSignalGameViewState extends State<BeaconSignalGameView>
    with TickerProviderStateMixin {
  static const _targets = <(double, double)>[
    (-0.68, 0.30),
    (-0.18, 0.23),
    (-1.08, 0.17),
  ];

  late final AnimationController _beam;
  late final AnimationController _pulse;
  late final AnimationController _celebration;
  int _round = 0;
  bool _transitioning = false;
  bool _answerSent = false;
  double _missSide = 0;

  @override
  void initState() {
    super.initState();
    _beam = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3300),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    );
    _celebration = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _beam.dispose();
    _pulse.dispose();
    _celebration.dispose();
    super.dispose();
  }

  double get _beamAngle => _beam.value * math.pi * 2 - math.pi;

  bool get _beamInsideTarget {
    final target = _targets[_round];
    return _delta(_beamAngle, target.$1).abs() <= target.$2;
  }

  double _delta(double a, double b) =>
      math.atan2(math.sin(a - b), math.cos(a - b));

  Future<void> _fire() async {
    if (_transitioning || _answerSent) return;
    final target = _targets[_round];
    final delta = _delta(_beamAngle, target.$1);
    if (delta.abs() > target.$2) {
      setState(() => _missSide = delta.sign);
      HapticFeedback.selectionClick();
      _pulse.forward(from: 0);
      return;
    }
    _transitioning = true;
    HapticFeedback.mediumImpact();
    await _pulse.forward(from: 0);
    if (!mounted) return;
    if (_round < _targets.length - 1) {
      setState(() {
        _round++;
        _transitioning = false;
      });
      return;
    }
    _beam.stop();
    await _celebration.forward(from: 0);
    if (!mounted || _answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: widget.semanticLabel,
        value: 'round:$_round',
        button: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: GestureDetector(
              key: const ValueKey('beacon-signal-surface'),
              behavior: HitTestBehavior.opaque,
              onTap: _fire,
              child: AnimatedBuilder(
                animation: Listenable.merge([_beam, _pulse, _celebration]),
                builder: (_, __) => Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BeaconPainter(
                          accent: widget.accent,
                          angle: _beamAngle,
                          round: _round,
                          pulse: _pulse.value,
                          celebration: _celebration.value,
                          missSide: _missSide,
                          transitioning: _transitioning,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        key: ValueKey(
                          _beamInsideTarget && !_transitioning
                              ? 'beacon-hit-window-$_round'
                              : 'beacon-seeking-$_round',
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: _fire,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _BeaconPainter extends CustomPainter {
  const _BeaconPainter({
    required this.accent,
    required this.angle,
    required this.round,
    required this.pulse,
    required this.celebration,
    required this.missSide,
    required this.transitioning,
  });

  final Color accent;
  final double angle;
  final int round;
  final double pulse;
  final double celebration;
  final double missSide;
  final bool transitioning;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF10213D), Color(0xFF23596B), Color(0xFF74ACA1)],
        ).createShader(bounds),
    );
    final u = size.height / 246;
    for (var i = 0; i < 24; i++) {
      canvas.drawCircle(
        Offset(
          size.width * ((i * .137 + .04) % .96),
          size.height * ((i * .083 + .05) % .58),
        ),
        i % 4 == 0 ? 1.4 * u : .75 * u,
        Paint()..color = Colors.white.withValues(alpha: .55),
      );
    }

    final lamp = Offset(size.width * .28, size.height * .38);
    const targets = <double>[-.68, -.18, -1.08];
    const widths = <double>[.30, .23, .17];
    for (var i = 0; i < targets.length; i++) {
      final radius = size.width * (.34 + i * .05);
      final active = i == round;
      final done = i < round;
      canvas.drawArc(
        Rect.fromCircle(center: lamp, radius: radius),
        targets[i] - widths[i],
        widths[i] * 2,
        false,
        Paint()
          ..color = (done ? const Color(0xFF65F1B8) : accent).withValues(
            alpha: active ? .95 : .36,
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = (active ? 6 : 3) * u
          ..strokeCap = StrokeCap.round,
      );
    }

    final beamAngle = transitioning ? targets[round] : angle;
    final direction = Offset(math.cos(beamAngle), math.sin(beamAngle));
    final normal = Offset(-direction.dy, direction.dx);
    final end = lamp + direction * size.width * .82;
    final beam = Path()
      ..moveTo(lamp.dx, lamp.dy)
      ..lineTo(end.dx + normal.dx * 18 * u, end.dy + normal.dy * 18 * u)
      ..lineTo(end.dx - normal.dx * 18 * u, end.dy - normal.dy * 18 * u)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFFFF4A4).withValues(alpha: .82),
            const Color(0xFFFFE778).withValues(alpha: .04),
          ],
        ).createShader(beam.getBounds()),
    );

    final tower = Path()
      ..moveTo(lamp.dx - 18 * u, lamp.dy + 18 * u)
      ..lineTo(lamp.dx + 18 * u, lamp.dy + 18 * u)
      ..lineTo(lamp.dx + 32 * u, size.height * .93)
      ..lineTo(lamp.dx - 32 * u, size.height * .93)
      ..close();
    canvas.drawShadow(tower, Colors.black, 8, false);
    canvas.drawPath(tower, Paint()..color = const Color(0xFFF5EFE2));
    canvas.drawCircle(lamp, 13 * u, Paint()..color = const Color(0xFFFFE46C));
    canvas.drawCircle(
      lamp,
      (14 + pulse * 26) * u,
      Paint()
        ..color = (transitioning ? const Color(0xFF71F1C1) : Colors.white)
            .withValues(alpha: (1 - pulse) * .7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * u,
    );

    final button = Offset(size.width * .72, size.height * .78);
    canvas.drawCircle(
      button.translate(0, 6 * u),
      32 * u,
      Paint()..color = const Color(0xFF132D3B),
    );
    canvas.drawCircle(button, 27 * u, Paint()..color = accent);
    canvas.drawCircle(
      button.translate(-7 * u, -8 * u),
      6 * u,
      Paint()..color = Colors.white.withValues(alpha: .45),
    );

    for (var i = 0; i < 3; i++) {
      final c = Offset(size.width * (.43 + i * .09), size.height * .88);
      canvas.drawCircle(
        c,
        7 * u,
        Paint()..color = i < round ? const Color(0xFF65F1B8) : Colors.white24,
      );
      if (i == round) {
        canvas.drawCircle(
          c,
          (10 + math.sin(pulse * math.pi) * 4) * u,
          Paint()
            ..color = accent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2 * u,
        );
      }
    }

    if (pulse > 0 && !transitioning) {
      canvas.drawLine(
        button,
        button.translate(-missSide * 28 * pulse, 0),
        Paint()
          ..color = const Color(0xFFFFB277).withValues(alpha: 1 - pulse)
          ..strokeWidth = 5 * u
          ..strokeCap = StrokeCap.round,
      );
    }
    if (celebration > 0) {
      for (var i = 0; i < 18; i++) {
        final a = i * math.pi * 2 / 18;
        final p = lamp +
            Offset(math.cos(a), math.sin(a)) *
                size.height *
                (.08 + celebration * .42);
        canvas.drawCircle(
          p,
          4 * u * (1 - celebration),
          Paint()..color = i.isEven ? accent : const Color(0xFFFFE46C),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BeaconPainter old) =>
      old.angle != angle ||
      old.round != round ||
      old.pulse != pulse ||
      old.celebration != celebration ||
      old.missSide != missSide ||
      old.transitioning != transitioning ||
      old.accent != accent;
}
