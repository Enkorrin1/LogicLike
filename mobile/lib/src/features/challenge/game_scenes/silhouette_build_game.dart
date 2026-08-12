import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SilhouetteBuildGameView extends StatefulWidget {
  const SilhouetteBuildGameView({
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
  State<SilhouetteBuildGameView> createState() =>
      _SilhouetteBuildGameViewState();
}

class _SilhouetteBuildGameViewState extends State<SilhouetteBuildGameView>
    with TickerProviderStateMixin {
  late final List<_CreaturePiece> _pieces;
  late final AnimationController _returnController;
  late final AnimationController _successController;
  int? _active;
  int? _returning;
  Offset _lastPoint = Offset.zero;
  Offset _returnFrom = Offset.zero;
  Offset _returnTo = Offset.zero;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _pieces = _blueprints
        .map(
          (item) => _CreaturePiece(
            kind: item.kind,
            home: item.home,
            target: item.target,
            position: item.home,
            color: item.color,
            angle: item.angle,
          ),
        )
        .toList();
    _returnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(_animateReturn);
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _returnController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _animateReturn() {
    final index = _returning;
    if (index == null) return;
    final t = Curves.easeOutBack.transform(_returnController.value);
    setState(() {
      _pieces[index].position = Offset.lerp(_returnFrom, _returnTo, t)!;
    });
  }

  void _startPiece(int index, Offset point) {
    if (_solved || _pieces[index].placed) return;
    _returnController.stop();
    _returning = null;
    _lastPoint = point;
    setState(() => _active = index);
  }

  void _updateTo(Offset point) {
    final index = _active;
    if (index == null) return;
    final delta = point - _lastPoint;
    _lastPoint = point;
    setState(() => _pieces[index].position += delta);
  }

  void _end(DragEndDetails details) {
    final index = _active;
    if (index == null) return;
    final piece = _pieces[index];
    setState(() => _active = null);

    final nearTarget = (piece.position - piece.target).distance <= 35;
    final correctTurn = piece.kind != _PieceKind.tail || piece.angle == 0;
    if (nearTarget && correctTurn) {
      setState(() {
        piece
          ..position = piece.target
          ..placed = true;
      });
      HapticFeedback.mediumImpact();
      if (_pieces.every((item) => item.placed)) _finish();
      return;
    }

    HapticFeedback.selectionClick();
    _returning = index;
    _returnFrom = piece.position;
    _returnTo = piece.home;
    _returnController.forward(from: 0).whenComplete(() {
      if (mounted && _returning == index) setState(() => _returning = null);
    });
  }

  void _rotateTail(int index) {
    if (_solved ||
        _pieces[index].placed ||
        _pieces[index].kind != _PieceKind.tail) {
      return;
    }
    setState(() {
      final piece = _pieces[index];
      piece.angle = piece.angle == 0 ? math.pi / 2 : 0;
    });
    HapticFeedback.selectionClick();
  }

  void _finish() {
    _solved = true;
    _successController.forward(from: 0).whenComplete(() {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  String _instruction(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    return _semanticInstructions[language] ?? _semanticInstructions['en']!;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.semanticLabel}. ${_instruction(context)}',
      button: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge(
                          [_returnController, _successController]),
                      builder: (context, child) => CustomPaint(
                        painter: _SilhouetteBuildPainter(
                          accent: widget.accent,
                          pieces: _pieces,
                          active: _active,
                          success: _successController.value,
                        ),
                      ),
                    ),
                    for (var i = 0; i < _pieces.length; i++)
                      if (!_pieces[i].placed) _pieceHitZone(size, i),
                    for (var i = 0; i < _pieces.length; i++)
                      _targetMarker(size, i),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _pieceHitZone(Size size, int index) {
    final piece = _pieces[index];
    return _positionedBoardZone(
      size: size,
      point: _active == index ? piece.home : piece.position,
      key: ValueKey('silhouette-piece-$index'),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: piece.kind == _PieceKind.tail && piece.angle != 0
            ? () => _rotateTail(index)
            : null,
        onPanStart: (_) {
          _startPiece(index, piece.position);
        },
        onPanUpdate: (details) {
          final scale = math.min(size.width / 360, size.height / 240);
          _updateTo(_lastPoint + details.delta / scale);
        },
        onPanEnd: _end,
        child: Semantics(
          key: piece.kind == _PieceKind.tail
              ? ValueKey(
                  piece.angle == 0
                      ? 'silhouette-tail-ready'
                      : 'silhouette-tail-turn',
                )
              : null,
          container: true,
          label: '${widget.semanticLabel} ${index + 1}',
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  Widget _targetMarker(Size size, int index) {
    return _positionedBoardZone(
      size: size,
      point: _pieces[index].target,
      key: ValueKey('silhouette-target-$index'),
      child: const IgnorePointer(child: SizedBox.expand()),
    );
  }

  Widget _positionedBoardZone({
    required Size size,
    required Offset point,
    required Key key,
    required Widget child,
  }) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin = Offset(
      (size.width - 360 * scale) / 2,
      (size.height - 240 * scale) / 2,
    );
    final center = origin + point * scale;
    return Positioned(
      left: center.dx - 34 * scale,
      top: center.dy - 34 * scale,
      width: 68 * scale,
      height: 68 * scale,
      key: key,
      child: child,
    );
  }
}

const _semanticInstructions = <String, String>{
  'ar': 'اسحب الأجزاء الأربعة إلى المخلوق. اضغط على الذيل الجانبي لتدويره.',
  'en':
      'Drag the four parts onto the creature. Tap the sideways tail to turn it.',
  'ru':
      'Перетащите четыре детали на силуэт. Нажмите на повёрнутый хвост, чтобы развернуть его.',
  'be':
      'Перацягніце чатыры дэталі на сілуэт. Націсніце на павернуты хвост, каб разгарнуць яго.',
  'uk':
      'Перетягніть чотири деталі на силует. Торкніться повернутого хвоста, щоб розвернути його.',
  'de':
      'Ziehe die vier Teile auf die Figur. Tippe auf den gedrehten Schwanz, um ihn zu drehen.',
  'es':
      'Arrastra las cuatro piezas a la criatura. Toca la cola girada para rotarla.',
  'fr':
      'Fais glisser les quatre pièces sur la créature. Touche la queue tournée pour la faire pivoter.',
  'hi':
      'चारों हिस्सों को प्राणी पर खींचें। तिरछी पूँछ को घुमाने के लिए उस पर टैप करें।',
  'it':
      'Trascina i quattro pezzi sulla creatura. Tocca la coda girata per ruotarla.',
  'ja': '4つのパーツを生き物の上へ動かします。横向きのしっぽをタップして回転させましょう。',
  'ko': '네 개의 조각을 캐릭터 위로 옮기세요. 옆으로 누운 꼬리를 탭해 돌리세요.',
  'pt':
      'Arraste as quatro peças para a criatura. Toque na cauda virada para girá-la.',
  'pl':
      'Przeciągnij cztery części na postać. Dotknij obróconego ogona, aby go przekręcić.',
  'tr':
      'Dört parçayı yaratığın üzerine sürükle. Yan duran kuyruğu çevirmek için dokun.',
  'kk':
      'Төрт бөлшекті кейіпкерге сүйреп апарыңыз. Қиғаш құйрықты бұру үшін түртіңіз.',
  'zh': '把四个部件拖到小动物身上。点击横着的尾巴将它旋转到正确方向。',
};

enum _PieceKind { ears, eyes, paws, tail }

class _PieceBlueprint {
  const _PieceBlueprint(this.kind, this.home, this.target, this.color,
      [this.angle = 0]);

  final _PieceKind kind;
  final Offset home;
  final Offset target;
  final Color color;
  final double angle;
}

const _blueprints = [
  _PieceBlueprint(
    _PieceKind.ears,
    Offset(43, 194),
    Offset(180, 47),
    Color(0xFFFFC857),
  ),
  _PieceBlueprint(
    _PieceKind.eyes,
    Offset(126, 194),
    Offset(180, 91),
    Color(0xFF63D7E8),
  ),
  _PieceBlueprint(
    _PieceKind.paws,
    Offset(220, 194),
    Offset(180, 145),
    Color(0xFFFF7A86),
  ),
  _PieceBlueprint(
    _PieceKind.tail,
    Offset(312, 194),
    Offset(262, 119),
    Color(0xFF9CE36D),
    math.pi / 2,
  ),
];

class _CreaturePiece {
  _CreaturePiece({
    required this.kind,
    required this.home,
    required this.target,
    required this.position,
    required this.color,
    required this.angle,
  });

  final _PieceKind kind;
  final Offset home;
  final Offset target;
  final Color color;
  Offset position;
  double angle;
  bool placed = false;
}

Path _piecePath(_PieceKind kind) {
  switch (kind) {
    case _PieceKind.ears:
      return Path()
        ..addOval(const Rect.fromLTWH(-31, -25, 23, 44))
        ..addOval(const Rect.fromLTWH(8, -25, 23, 44));
    case _PieceKind.eyes:
      return Path()
        ..addRRect(RRect.fromRectAndRadius(
          const Rect.fromLTWH(-34, -17, 68, 34),
          const Radius.circular(17),
        ));
    case _PieceKind.paws:
      return Path()
        ..addRRect(RRect.fromRectAndRadius(
          const Rect.fromLTWH(-35, -18, 28, 36),
          const Radius.circular(12),
        ))
        ..addRRect(RRect.fromRectAndRadius(
          const Rect.fromLTWH(7, -18, 28, 36),
          const Radius.circular(12),
        ));
    case _PieceKind.tail:
      return Path()
        ..moveTo(-23, 13)
        ..quadraticBezierTo(4, -26, 28, -7)
        ..quadraticBezierTo(5, -7, -12, 22)
        ..close();
  }
}

class _SilhouetteBuildPainter extends CustomPainter {
  const _SilhouetteBuildPainter({
    required this.accent,
    required this.pieces,
    required this.active,
    required this.success,
  });

  final Color accent;
  final List<_CreaturePiece> pieces;
  final int? active;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin = Offset(
      (size.width - 360 * scale) / 2,
      (size.height - 240 * scale) / 2,
    );
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF111C3A));
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    _paintSpace(canvas);

    final bounce = success == 0 ? 0.0 : -math.sin(success * math.pi * 3) * 5;
    canvas.save();
    canvas.translate(0, bounce);
    _paintCreatureBase(canvas);
    for (final piece in pieces.where((piece) => piece.placed)) {
      _paintPiece(canvas, piece, false, alive: success > 0);
    }
    canvas.restore();

    for (var i = 0; i < pieces.length; i++) {
      if (!pieces[i].placed && i != active) {
        _paintPiece(canvas, pieces[i], false);
      }
    }
    if (active != null) _paintPiece(canvas, pieces[active!], true);
    if (success > 0) _paintSparkles(canvas);
    canvas.restore();
  }

  void _paintSpace(Canvas canvas) {
    canvas.drawCircle(
      const Offset(180, 105),
      91,
      Paint()..color = accent.withValues(alpha: 0.12),
    );
    for (var i = 0; i < 18; i++) {
      canvas.drawCircle(
        Offset((i * 83 + 17) % 354, (i * 47 + 11) % 178),
        i % 3 == 0 ? 1.8 : 1,
        Paint()..color = Colors.white.withValues(alpha: 0.48),
      );
    }
    canvas.drawOval(
      const Rect.fromLTWH(111, 172, 138, 9),
      Paint()..color = Colors.black.withValues(alpha: 0.24),
    );
  }

  void _paintCreatureBase(Canvas canvas) {
    final silhouette = Paint()..color = const Color(0xFF344263);
    canvas
      ..drawOval(const Rect.fromLTWH(128, 42, 104, 91), silhouette)
      ..drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(133, 103, 94, 62),
          const Radius.circular(31),
        ),
        silhouette,
      )
      ..drawCircle(const Offset(132, 119), 19, silhouette)
      ..drawCircle(const Offset(228, 119), 19, silhouette);
    final seam = Paint()
      ..color = Colors.white.withValues(alpha: 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
        const Rect.fromLTWH(143, 54, 74, 67), 0.15, 2.8, false, seam);
    canvas.drawCircle(
      const Offset(180, 132),
      8,
      Paint()..color = accent.withValues(alpha: 0.42),
    );
  }

  void _paintPiece(Canvas canvas, _CreaturePiece piece, bool dragging,
      {bool alive = false}) {
    canvas.save();
    canvas.translate(piece.position.dx, piece.position.dy);
    if (alive && piece.kind == _PieceKind.tail) {
      canvas.rotate(math.sin(success * math.pi * 4) * 0.22);
    } else {
      canvas.rotate(piece.angle);
    }
    if (dragging) canvas.scale(1.1);
    final path = _piecePath(piece.kind);
    canvas.drawPath(
      path.shift(const Offset(0, 3)),
      Paint()..color = Colors.black.withValues(alpha: 0.28),
    );
    canvas.drawPath(path, Paint()..color = piece.color);
    _paintDetails(canvas, piece, alive);
    canvas.restore();
  }

  void _paintDetails(Canvas canvas, _CreaturePiece piece, bool alive) {
    final ink = Paint()
      ..color = const Color(0xFF17213E)
      ..strokeCap = StrokeCap.round;
    switch (piece.kind) {
      case _PieceKind.ears:
        canvas.drawCircle(const Offset(-19.5, -7), 5, ink);
        canvas.drawCircle(const Offset(19.5, -7), 5, ink);
      case _PieceKind.eyes:
        final eyeHeight = alive && success > 0.42 && success < 0.58 ? 1.5 : 6.0;
        canvas.drawOval(
            Rect.fromCenter(
                center: const Offset(-14, 0), width: 7, height: eyeHeight),
            ink);
        canvas.drawOval(
            Rect.fromCenter(
                center: const Offset(14, 0), width: 7, height: eyeHeight),
            ink);
        canvas.drawCircle(const Offset(0, 10), 2,
            Paint()..color = Colors.white.withValues(alpha: 0.7));
      case _PieceKind.paws:
        ink.strokeWidth = 2;
        for (final x in [-27.0, -17.0, 17.0, 27.0]) {
          canvas.drawLine(Offset(x, 9), Offset(x, 14), ink);
        }
      case _PieceKind.tail:
        canvas.drawCircle(const Offset(21, -8), 5,
            Paint()..color = Colors.white.withValues(alpha: 0.55));
    }
  }

  void _paintSparkles(Canvas canvas) {
    final opacity = math.sin(success * math.pi).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = const Color(0xFFFFE66D).withValues(alpha: opacity);
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 + success;
      final radius = 70 + success * 25;
      final point = Offset(
          180 + math.cos(angle) * radius, 106 + math.sin(angle) * radius);
      canvas.drawCircle(point, i.isEven ? 3 : 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SilhouetteBuildPainter oldDelegate) => true;
}
