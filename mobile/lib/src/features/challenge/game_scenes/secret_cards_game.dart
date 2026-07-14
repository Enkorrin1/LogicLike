import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_theme.dart';

class SecretCardsGameView extends StatefulWidget {
  const SecretCardsGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
    this.previewDuration = const Duration(seconds: 3),
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;
  final Duration previewDuration;

  @override
  State<SecretCardsGameView> createState() => _SecretCardsGameViewState();
}

class _SecretCardsGameViewState extends State<SecretCardsGameView> {
  late SecretCardsGame _game;

  @override
  void initState() {
    super.initState();
    _createGame();
  }

  @override
  void didUpdateWidget(SecretCardsGameView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.correctAnswer != widget.correctAnswer ||
        oldWidget.accent != widget.accent ||
        oldWidget.previewDuration != widget.previewDuration) {
      _createGame();
    }
  }

  void _createGame() {
    _game = SecretCardsGame(
      accent: widget.accent,
      correctAnswer: widget.correctAnswer,
      onAnswerSelected: widget.onAnswerSelected,
      previewDuration: widget.previewDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '1 2 3 4 5 6',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 208 : 236,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GameWidget(game: _game),
                _CardHitZones(game: _game),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 220.ms).scale(
              begin: const Offset(0.985, 0.985),
              end: const Offset(1, 1),
              duration: 260.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }
}

class _CardHitZones extends StatelessWidget {
  const _CardHitZones({required this.game});

  final SecretCardsGame game;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: List.generate(6, (index) {
          final row = index ~/ 3;
          final column = index % 3;
          final width = constraints.maxWidth * 0.18;
          final height = constraints.maxHeight * 0.28;
          final centerX = constraints.maxWidth * (0.39 + column * 0.20);
          final centerY = constraints.maxHeight * (0.39 + row * 0.34);
          return Positioned(
            left: centerX - width / 2,
            top: centerY - height / 2,
            width: width,
            height: height,
            child: Semantics(
              button: true,
              label: '${index + 1}',
              child: GestureDetector(
                key: ValueKey('secret-card-$index'),
                behavior: HitTestBehavior.opaque,
                onTap: () => game.selectCard(index),
                child: const SizedBox.expand(),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SecretCardsGame extends FlameGame {
  SecretCardsGame({
    required this.accent,
    required this.correctAnswer,
    required this.onAnswerSelected,
    required Duration previewDuration,
  }) : _previewDuration = previewDuration.inMicroseconds / 1000000;

  final Color accent;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;
  final double _previewDuration;

  static const _symbols = <_CardSymbol>[
    _CardSymbol.rocket,
    _CardSymbol.planet,
    _CardSymbol.star,
    _CardSymbol.planet,
    _CardSymbol.star,
    _CardSymbol.rocket,
  ];

  final Set<int> _matched = {};
  final List<int> _open = [];
  double _time = 0;
  double _previewTime = 0;
  double _mismatchTime = 0;
  bool _preview = true;
  bool _locked = false;
  bool _completed = false;

  @override
  Color backgroundColor() => Colors.transparent;

  void selectCard(int index) {
    if (_preview || _locked || _completed || index < 0 || index >= 6) return;
    if (_matched.contains(index) || _open.contains(index)) return;
    _open.add(index);
    if (_open.length < 2) return;

    if (_symbols[_open[0]] == _symbols[_open[1]]) {
      _matched.addAll(_open);
      _open.clear();
      if (_matched.length == 6 && !_completed) {
        _completed = true;
        onAnswerSelected(correctAnswer);
      }
    } else {
      _locked = true;
      _mismatchTime = 0;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_preview) {
      _previewTime += dt;
      if (_previewTime >= _previewDuration) _preview = false;
    }
    if (_locked) {
      _mismatchTime += dt;
      if (_mismatchTime >= 0.65) {
        _open.clear();
        _locked = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final sceneSize = Size(size.x, size.y);
    if (sceneSize.isEmpty) return;
    _drawBackground(canvas, sceneSize);
    _drawHost(canvas, sceneSize);
    _drawBoard(canvas, sceneSize);
  }

  void _drawBackground(Canvas canvas, Size sceneSize) {
    final rect = Offset.zero & sceneSize;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4ECFF), Color(0xFFE2F8FF)],
        ).createShader(rect),
    );
    for (var index = 0; index < 10; index++) {
      final point = Offset(
        sceneSize.width * (0.06 + ((index * 0.13) % 0.88)),
        sceneSize.height * (0.10 + ((index * 0.19) % 0.78)),
      );
      canvas.drawCircle(
        point,
        1.4 + math.sin(_time * 1.7 + index).abs(),
        Paint()..color = Colors.white.withValues(alpha: 0.74),
      );
    }
  }

  void _drawHost(Canvas canvas, Size sceneSize) {
    final center = Offset(sceneSize.width * 0.14, sceneSize.height * 0.54);
    final scale = sceneSize.height * 0.34;
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, scale * 0.44),
        width: scale * 0.72,
        height: scale * 0.15,
      ),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.10),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, scale * 0.10),
        width: scale * 0.46,
        height: scale * 0.58,
      ),
      Paint()..color = const Color(0xFF83D6E5),
    );
    canvas.drawCircle(center.translate(0, -scale * 0.12), scale * 0.23,
        Paint()..color = const Color(0xFF83D6E5));
    for (final direction in [-1.0, 1.0]) {
      final eye = center.translate(direction * scale * 0.08, -scale * 0.17);
      canvas.drawCircle(eye, scale * 0.028, Paint()..color = Colors.white);
      canvas.drawCircle(eye, scale * 0.013, Paint()..color = AppPalette.ink);
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(scale * 0.03, scale * 0.01),
        width: scale * 0.16,
        height: scale * 0.28,
      ),
      Paint()..color = const Color(0xFF5CBFD0),
    );
  }

  void _drawBoard(Canvas canvas, Size sceneSize) {
    final board = Rect.fromLTWH(
      sceneSize.width * 0.25,
      sceneSize.height * 0.12,
      sceneSize.width * 0.70,
      sceneSize.height * 0.78,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          board.shift(const Offset(0, 6)), const Radius.circular(26)),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.08),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(board, const Radius.circular(26)),
      Paint()..color = Colors.white.withValues(alpha: 0.72),
    );

    for (var index = 0; index < 6; index++) {
      final center = Offset(
        sceneSize.width * (0.39 + (index % 3) * 0.20),
        sceneSize.height * (0.39 + (index ~/ 3) * 0.34),
      );
      _drawCard(
        canvas,
        center: center,
        size: math.min(sceneSize.width * 0.16, sceneSize.height * 0.27),
        symbol: _symbols[index],
        shown: _preview || _open.contains(index) || _matched.contains(index),
        matched: _matched.contains(index),
        error: _locked && _open.contains(index),
      );
    }

    final track = Rect.fromLTWH(
      board.left + board.width * 0.12,
      board.bottom - 9,
      board.width * 0.76,
      5,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(track, const Radius.circular(99)),
        Paint()..color = AppPalette.muted.withValues(alpha: 0.18));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            track.left, track.top, track.width * (_matched.length / 6), 5),
        const Radius.circular(99),
      ),
      Paint()..color = AppPalette.teal,
    );
  }

  void _drawCard(
    Canvas canvas, {
    required Offset center,
    required double size,
    required _CardSymbol symbol,
    required bool shown,
    required bool matched,
    required bool error,
  }) {
    final color = switch (symbol) {
      _CardSymbol.rocket => AppPalette.coral,
      _CardSymbol.planet => accent,
      _CardSymbol.star => AppPalette.mango,
    };
    final wobble = matched ? math.sin(_time * 5 + center.dx) * 2 : 0.0;
    final rect = Rect.fromCenter(
      center: center.translate(0, wobble),
      width: size,
      height: size,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect.shift(const Offset(0, 5)), const Radius.circular(16)),
      Paint()..color = color.withValues(alpha: 0.16),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: shown
              ? [Colors.white, color.withValues(alpha: 0.16)]
              : [const Color(0xFF8190C9), const Color(0xFF5667AC)],
        ).createShader(rect),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      Paint()
        ..color = error
            ? AppPalette.coral
            : matched
                ? AppPalette.teal
                : Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = error || matched ? 3 : 1.3,
    );
    if (shown) {
      _drawSymbol(canvas, rect.deflate(size * 0.18), symbol, color);
    } else {
      _drawBack(canvas, rect);
    }
  }

  void _drawBack(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(rect.center, rect.width * 0.23, paint);
    canvas.drawCircle(rect.center, rect.width * 0.09, paint);
    for (var index = 0; index < 6; index++) {
      final angle = index * math.pi / 3;
      canvas.drawLine(
        rect.center +
            Offset(math.cos(angle), math.sin(angle)) * rect.width * 0.12,
        rect.center +
            Offset(math.cos(angle), math.sin(angle)) * rect.width * 0.28,
        paint,
      );
    }
  }

  void _drawSymbol(Canvas canvas, Rect rect, _CardSymbol symbol, Color color) {
    switch (symbol) {
      case _CardSymbol.rocket:
        final body = Path()
          ..moveTo(rect.center.dx, rect.top)
          ..quadraticBezierTo(
              rect.right, rect.center.dy, rect.center.dx, rect.bottom)
          ..quadraticBezierTo(
              rect.left, rect.center.dy, rect.center.dx, rect.top)
          ..close();
        canvas.drawPath(body, Paint()..color = color);
        canvas.drawCircle(
            rect.center.translate(0, -rect.height * 0.12),
            rect.width * 0.10,
            Paint()..color = Colors.white.withValues(alpha: 0.84));
      case _CardSymbol.planet:
        canvas.drawOval(
          Rect.fromCenter(
              center: rect.center,
              width: rect.width,
              height: rect.height * 0.34),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4,
        );
        canvas.drawCircle(
            rect.center, rect.width * 0.27, Paint()..color = color);
      case _CardSymbol.star:
        final path = Path();
        for (var index = 0; index < 10; index++) {
          final radius = index.isEven ? rect.width * 0.46 : rect.width * 0.21;
          final angle = -math.pi / 2 + index * math.pi / 5;
          final point =
              rect.center + Offset(math.cos(angle), math.sin(angle)) * radius;
          if (index == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, Paint()..color = color);
    }
  }
}

enum _CardSymbol { rocket, planet, star }
