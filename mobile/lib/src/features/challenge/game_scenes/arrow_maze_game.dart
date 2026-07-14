import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArrowMazeGameView extends StatefulWidget {
  const ArrowMazeGameView({
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
  State<ArrowMazeGameView> createState() => _ArrowMazeGameViewState();
}

class _ArrowMazeGameViewState extends State<ArrowMazeGameView>
    with TickerProviderStateMixin {
  static const _targets = [2, 0, 3, 1];
  final _turns = <int>[0, 2, 1, 3];
  late final AnimationController _run;
  late final AnimationController _turn;
  int _turning = -1;
  int _turnFrom = 0;
  int _reachable = 0;
  bool _running = false;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _run = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
    _turn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _run.dispose();
    _turn.dispose();
    super.dispose();
  }

  void _rotate(int index) {
    if (_running || _solved || _turn.isAnimating) return;
    HapticFeedback.selectionClick();
    setState(() {
      _turning = index;
      _turnFrom = _turns[index];
      _turns[index] = (_turns[index] + 1) % 4;
    });
    _turn.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _turning = -1);
    });
  }

  Future<void> _launch() async {
    if (_running || _solved || _turn.isAnimating) return;
    var reachable = 0;
    while (reachable < _targets.length &&
        _turns[reachable] == _targets[reachable]) {
      reachable++;
    }
    setState(() {
      _reachable = reachable;
      _running = true;
      _solved = reachable == _targets.length;
    });
    HapticFeedback.mediumImpact();
    await _run.forward(from: 0);
    if (!mounted) return;
    if (_solved) {
      HapticFeedback.heavyImpact();
      if (!_answerSent) {
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      }
    } else {
      HapticFeedback.lightImpact();
      setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = _MazeWords.forLocale(Localizations.localeOf(context));
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(builder: (context, constraints) {
              final layout = _MazeLayout(constraints.biggest);
              return Stack(fit: StackFit.expand, children: [
                AnimatedBuilder(
                  animation: Listenable.merge([_run, _turn]),
                  builder: (_, __) => CustomPaint(
                    painter: _MazePainter(
                      accent: widget.accent,
                      turns: List.of(_turns),
                      turning: _turning,
                      turnFrom: _turnFrom,
                      turnProgress: _turn.value,
                      runProgress: _run.value,
                      reachable: _reachable,
                      running: _running,
                      solved: _solved,
                    ),
                  ),
                ),
                for (var i = 0; i < layout.tiles.length; i++)
                  Positioned.fromRect(
                    rect: layout.tiles[i].inflate(5),
                    child: Semantics(
                      key: ValueKey('arrow-maze-tile-$i'),
                      button: true,
                      enabled: !_running && !_solved,
                      label: '${words.rotate} ${i + 1}',
                      onTap: !_running && !_solved ? () => _rotate(i) : null,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _rotate(i),
                      ),
                    ),
                  ),
                Positioned.fromRect(
                  rect: layout.launch.inflate(6),
                  child: Semantics(
                    key: const ValueKey('arrow-maze-launch'),
                    button: true,
                    enabled: !_running && !_solved,
                    label: words.launch,
                    onTap: !_running && !_solved ? _launch : null,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _launch,
                    ),
                  ),
                ),
              ]);
            }),
          ),
        ),
      ),
    );
  }
}

class _MazeLayout {
  _MazeLayout(Size size)
      : scale = math.min(size.width / 360, size.height / 240),
        origin = Offset(
          (size.width - 360 * math.min(size.width / 360, size.height / 240)) /
              2,
          (size.height - 240 * math.min(size.width / 360, size.height / 240)) /
              2,
        );
  final double scale;
  final Offset origin;
  Rect map(Rect rect) => Rect.fromLTWH(origin.dx + rect.left * scale,
      origin.dy + rect.top * scale, rect.width * scale, rect.height * scale);
  List<Rect> get tiles => _tileRects.map(map).toList();
  Rect get launch => map(const Rect.fromLTWH(278, 166, 58, 48));
}

const _tileRects = [
  Rect.fromLTWH(53, 31, 72, 72),
  Rect.fromLTWH(53, 127, 72, 72),
  Rect.fromLTWH(149, 127, 72, 72),
  Rect.fromLTWH(149, 31, 72, 72),
];
const _route = [
  Offset(18, 67),
  Offset(89, 67),
  Offset(89, 163),
  Offset(185, 163),
  Offset(185, 67),
  Offset(258, 67),
];

class _MazePainter extends CustomPainter {
  const _MazePainter({
    required this.accent,
    required this.turns,
    required this.turning,
    required this.turnFrom,
    required this.turnProgress,
    required this.runProgress,
    required this.reachable,
    required this.running,
    required this.solved,
  });
  final Color accent;
  final List<int> turns;
  final int turning;
  final int turnFrom;
  final double turnProgress;
  final double runProgress;
  final int reachable;
  final bool running;
  final bool solved;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin =
        Offset((size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFF4F1E8));
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.scale(scale);
    for (var y = 15.0; y < 235; y += 18) {
      for (var x = 12.0; x < 350; x += 18) {
        canvas.drawCircle(
            Offset(x, y), 1, Paint()..color = const Color(0xFFD9D0BF));
      }
    }
    for (var i = 0; i < 4; i++) {
      _tile(canvas, i);
    }
    _markers(canvas);
    _button(canvas);
    _hero(canvas);
    canvas.restore();
  }

  void _tile(Canvas canvas, int i) {
    final rect = _tileRects[i], center = rect.center;
    final angle = i == turning
        ? turnFrom + Curves.easeOutBack.transform(turnProgress)
        : turns[i].toDouble();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle * math.pi / 2);
    final body = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 66, height: 66),
        const Radius.circular(10));
    canvas.drawShadow(Path()..addRRect(body), Colors.black38, 5, false);
    canvas.drawRRect(body, Paint()..color = const Color(0xFFFFF9E8));
    final path = Path()
      ..moveTo(0, -33)
      ..lineTo(0, -4)
      ..quadraticBezierTo(0, 0, 5, 0)
      ..lineTo(33, 0);
    canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFD7C38E)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20);
    canvas.drawPath(
        path,
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round);
    canvas.restore();
  }

  void _markers(Canvas canvas) {
    canvas.drawCircle(
        _route.first, 17, Paint()..color = const Color(0xFF78D6A0));
    canvas.drawCircle(
        _route.last, 19, Paint()..color = const Color(0xFFFFD35A));
    final star = Path();
    for (var i = 0; i < 10; i++) {
      final a = -math.pi / 2 + i * math.pi / 5;
      final r = i.isEven ? 12.0 : 5.5;
      final p = _route.last + Offset(math.cos(a), math.sin(a)) * r;
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    star.close();
    canvas.drawPath(star, Paint()..color = Colors.white);
  }

  void _button(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(278, 166, 58, 48), const Radius.circular(16));
    canvas.drawShadow(Path()..addRRect(rect), Colors.black38, 6, false);
    canvas.drawRRect(
        rect, Paint()..color = solved ? const Color(0xFF55CF91) : accent);
    final triangle = Path()
      ..moveTo(302, 179)
      ..lineTo(302, 201)
      ..lineTo(320, 190)
      ..close();
    canvas.drawPath(triangle, Paint()..color = Colors.white);
  }

  void _hero(Canvas canvas) {
    var p = _route.first;
    if (running) {
      final segments = solved ? 5 : math.max(1, reachable);
      final travel = runProgress * segments;
      final index = travel.floor().clamp(0, segments - 1);
      p = Offset.lerp(_route[index], _route[index + 1], travel - index)!;
    }
    canvas.drawCircle(
        p + const Offset(0, 3), 12, Paint()..color = Colors.black26);
    canvas.drawCircle(p, 12, Paint()..color = const Color(0xFFEF765F));
    canvas.drawCircle(
        p + const Offset(-4, -2), 2, Paint()..color = Colors.white);
    canvas.drawCircle(
        p + const Offset(4, -2), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _MazePainter old) => true;
}

class _MazeWords {
  const _MazeWords(this.rotate, this.launch);
  final String rotate;
  final String launch;
  static _MazeWords forLocale(Locale locale) =>
      _values[locale.languageCode] ?? _values['en']!;
  static const _values = <String, _MazeWords>{
    'ar': _MazeWords('أدر بلاطة المسار', 'شغّل البطل'),
    'de': _MazeWords('Wegplatte drehen', 'Figur starten'),
    'en': _MazeWords('Rotate path tile', 'Start the character'),
    'es': _MazeWords('Girar la pieza del camino', 'Iniciar el personaje'),
    'fr': _MazeWords('Tourner la tuile du chemin', 'Lancer le personnage'),
    'hi': _MazeWords('रास्ते की टाइल घुमाएँ', 'पात्र को चलाएँ'),
    'it': _MazeWords('Ruota la tessera del percorso', 'Avvia il personaggio'),
    'ja': _MazeWords('道のタイルを回す', 'キャラクターを進める'),
    'ko': _MazeWords('길 타일 돌리기', '캐릭터 출발'),
    'pt': _MazeWords('Girar a peça do caminho', 'Iniciar o personagem'),
    'ru': _MazeWords('Повернуть плитку маршрута', 'Запустить героя'),
    'zh': _MazeWords('旋转路径方块', '启动角色'),
  };
}
