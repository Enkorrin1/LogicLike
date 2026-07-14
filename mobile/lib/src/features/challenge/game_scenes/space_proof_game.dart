import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpaceProofGameView extends StatefulWidget {
  const SpaceProofGameView({
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
  State<SpaceProofGameView> createState() => _SpaceProofGameViewState();
}

class _SpaceProofGameViewState extends State<SpaceProofGameView>
    with TickerProviderStateMixin {
  late final AnimationController _ambient;
  late final AnimationController _reaction;
  late final AnimationController _success;

  final List<_ProofPiece> _pieces = [
    _ProofPiece(_PieceKind.noMoon, const Offset(80, 202)),
    _ProofPiece(_PieceKind.noRings, const Offset(280, 202)),
    _ProofPiece(_PieceKind.capsule, const Offset(180, 202)),
  ];

  int? _active;
  int? _returning;
  Offset _dragAnchor = Offset.zero;
  Offset _returnFrom = Offset.zero;
  Offset _returnTo = Offset.zero;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..repeat();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    )..addListener(_animateReturn);
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
  }

  @override
  void dispose() {
    _ambient.dispose();
    _reaction.dispose();
    _success.dispose();
    super.dispose();
  }

  void _animateReturn() {
    final index = _returning;
    if (index == null) return;
    final t = Curves.easeOutBack.transform(_reaction.value);
    setState(() => _pieces[index].position = Offset.lerp(
          _returnFrom,
          _returnTo,
          t,
        )!);
  }

  Offset _toBoard(Offset local, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin = Offset(
      (size.width - 360 * scale) / 2,
      (size.height - 240 * scale) / 2,
    );
    return (local - origin) / scale;
  }

  void _onPanStart(DragStartDetails details, Size size) {
    if (_solved || _reaction.isAnimating) return;
    final point = _toBoard(details.localPosition, size);
    for (var i = _pieces.length - 1; i >= 0; i--) {
      final piece = _pieces[i];
      if (!piece.placed &&
          (point - piece.position).distance < piece.radius + 9) {
        setState(() => _active = i);
        _dragAnchor = point;
        HapticFeedback.selectionClick();
        return;
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final index = _active;
    if (index == null) return;
    final point = _toBoard(details.localPosition, size);
    final delta = point - _dragAnchor;
    _dragAnchor = point;
    setState(() {
      final next = _pieces[index].position + delta;
      _pieces[index].position = Offset(
        next.dx.clamp(24, 336),
        next.dy.clamp(24, 218),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final index = _active;
    if (index == null) return;
    final piece = _pieces[index];
    setState(() => _active = null);

    final target = _landingCenters.indexWhere(
      (center) => (piece.position - center).distance < 48,
    );
    if (_canPlace(piece.kind, target)) {
      setState(() {
        piece
          ..position = _landingCenters[target]
          ..placed = true;
      });
      HapticFeedback.mediumImpact();
      if (piece.kind == _PieceKind.capsule) _finish();
      return;
    }
    HapticFeedback.lightImpact();
    _returnPiece(index);
  }

  bool _canPlace(_PieceKind kind, int target) {
    if (kind == _PieceKind.noMoon) return target == 0;
    if (kind == _PieceKind.noRings) return target == 2;
    return target == 1 && _pieces[0].placed && _pieces[1].placed;
  }

  void _returnPiece(int index) {
    _returning = index;
    _returnFrom = _pieces[index].position;
    _returnTo = _pieces[index].home;
    _reaction.forward(from: 0).whenComplete(() {
      if (!mounted || _returning != index) return;
      setState(() => _returning = null);
    });
  }

  Future<void> _finish() async {
    setState(() => _solved = true);
    HapticFeedback.heavyImpact();
    await _success.forward(from: 0);
    if (!mounted || _answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    final semantics =
        _ProofSemantics.forLocale(Localizations.localeOf(context));
    return Semantics(
      label: '${widget.semanticLabel}. ${semantics.instruction}',
      hint: semantics.progress(
        _pieces.where((piece) => piece.placed).length,
        _solved,
      ),
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
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) => _onPanStart(details, size),
                  onPanUpdate: (details) => _onPanUpdate(details, size),
                  onPanEnd: _onPanEnd,
                  child: AnimatedBuilder(
                    animation:
                        Listenable.merge([_ambient, _reaction, _success]),
                    builder: (context, _) => CustomPaint(
                      painter: _SpaceProofPainter(
                        accent: widget.accent,
                        pieces: _pieces,
                        active: _active,
                        ambient: _ambient.value,
                        success: _success.value,
                      ),
                    ),
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

const _landingCenters = [
  Offset(72, 105),
  Offset(180, 105),
  Offset(288, 105),
];

enum _PieceKind { noMoon, noRings, capsule }

class _ProofPiece {
  _ProofPiece(this.kind, this.home) : position = home;

  final _PieceKind kind;
  final Offset home;
  Offset position;
  bool placed = false;

  double get radius => kind == _PieceKind.capsule ? 25 : 21;
}

class _SpaceProofPainter extends CustomPainter {
  const _SpaceProofPainter({
    required this.accent,
    required this.pieces,
    required this.active,
    required this.ambient,
    required this.success,
  });

  final Color accent;
  final List<_ProofPiece> pieces;
  final int? active;
  final double ambient;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin = Offset(
      (size.width - 360 * scale) / 2,
      (size.height - 240 * scale) / 2,
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1734), Color(0xFF18355A), Color(0xFF28516B)],
        ).createShader(Offset.zero & size),
    );
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    _paintStars(canvas);
    _paintClues(canvas);
    _paintLandings(canvas);
    for (var i = 0; i < pieces.length; i++) {
      if (i != active) _paintPiece(canvas, pieces[i], false);
    }
    if (active != null) _paintPiece(canvas, pieces[active!], true);
    if (success > 0) _paintSuccess(canvas);
    canvas.restore();
  }

  void _paintStars(Canvas canvas) {
    for (var i = 0; i < 30; i++) {
      final point = Offset(
        (17 + i * 83) % 354.0,
        (12 + i * 47) % 176.0,
      );
      final glow = 0.38 + 0.35 * math.sin(ambient * math.pi * 2 + i);
      canvas.drawCircle(
        point,
        i % 6 == 0 ? 1.5 : 0.8,
        Paint()..color = Colors.white.withValues(alpha: glow),
      );
    }
  }

  void _paintClues(Canvas canvas) {
    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.42)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(72, 36), const Offset(72, 55), line);
    canvas.drawLine(const Offset(288, 36), const Offset(288, 55), line);
    _paintMiniMoon(canvas, const Offset(72, 27), 10);
    _paintSlash(canvas, const Offset(72, 27), 14);
    _paintMiniRings(canvas, const Offset(288, 27), 10);
    _paintSlash(canvas, const Offset(288, 27), 14);
  }

  void _paintLandings(Canvas canvas) {
    for (var i = 0; i < _landingCenters.length; i++) {
      final center = _landingCenters[i];
      final colors = switch (i) {
        0 => const [Color(0xFF89D6DA), Color(0xFF397C9A)],
        1 => const [Color(0xFFFFD66B), Color(0xFFD26D69)],
        _ => const [Color(0xFFC5A7EF), Color(0xFF64559A)],
      };
      canvas.drawCircle(
        center + const Offset(0, 5),
        40,
        Paint()..color = Colors.black.withValues(alpha: 0.24),
      );
      canvas.drawCircle(
        center,
        39,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.45),
            colors: colors,
          ).createShader(Rect.fromCircle(center: center, radius: 39)),
      );
      canvas.drawCircle(
        center,
        30,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.17)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      if (i == 0) _paintMiniMoon(canvas, center, 13);
      if (i == 1) _paintCraterMark(canvas, center);
      if (i == 2) _paintMiniRings(canvas, center, 14);
    }
  }

  void _paintMiniMoon(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFEAF5FA));
    canvas.drawCircle(
      center + Offset(radius * 0.4, -radius * 0.18),
      radius * 0.86,
      Paint()..color = const Color(0xFF397C9A),
    );
  }

  void _paintMiniRings(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFEBC8FF));
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.22);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radius * 3, height: radius),
      Paint()
        ..color = const Color(0xFFFFD66B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.restore();
  }

  void _paintCraterMark(Canvas canvas, Offset center) {
    for (final crater in const [
      Offset(-11, -8),
      Offset(12, 7),
      Offset(-5, 15),
    ]) {
      canvas.drawCircle(
        center + crater,
        4,
        Paint()..color = const Color(0xFF9A526B).withValues(alpha: 0.42),
      );
    }
  }

  void _paintPiece(Canvas canvas, _ProofPiece piece, bool isActive) {
    final center = piece.position;
    canvas.drawCircle(
      center + const Offset(0, 4),
      piece.radius + 2,
      Paint()..color = Colors.black.withValues(alpha: 0.27),
    );
    if (piece.kind == _PieceKind.capsule) {
      _paintCapsule(canvas, center, isActive);
    } else {
      canvas.drawCircle(
        center,
        piece.radius,
        Paint()..color = isActive ? const Color(0xFFFFF4C4) : Colors.white,
      );
      canvas.drawCircle(
        center,
        piece.radius,
        Paint()
          ..color = accent.withValues(alpha: 0.34)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isActive ? 4 : 2,
      );
      if (piece.kind == _PieceKind.noMoon) {
        _paintMiniMoon(canvas, center, 9);
      } else {
        _paintMiniRings(canvas, center, 8);
      }
      _paintSlash(canvas, center, 14);
    }
  }

  void _paintSlash(Canvas canvas, Offset center, double radius) {
    canvas.drawLine(
      center + Offset(-radius * 0.72, -radius * 0.72),
      center + Offset(radius * 0.72, radius * 0.72),
      Paint()
        ..color = const Color(0xFFFF5C6C)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintCapsule(Canvas canvas, Offset center, bool isActive) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (isActive) canvas.scale(1.08);
    final body = Path()
      ..moveTo(0, -27)
      ..quadraticBezierTo(19, -14, 16, 14)
      ..quadraticBezierTo(0, 24, -16, 14)
      ..quadraticBezierTo(-19, -14, 0, -27)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFF7FAFC));
    canvas.drawPath(
      body,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(const Offset(0, -7), 7, Paint()..color = accent);
    canvas.drawPath(
      Path()
        ..moveTo(-14, 9)
        ..lineTo(-25, 21)
        ..lineTo(-12, 18)
        ..close(),
      Paint()..color = const Color(0xFFFFD66B),
    );
    canvas.drawPath(
      Path()
        ..moveTo(14, 9)
        ..lineTo(25, 21)
        ..lineTo(12, 18)
        ..close(),
      Paint()..color = const Color(0xFFFFD66B),
    );
    canvas.restore();
  }

  void _paintSuccess(Canvas canvas) {
    final center = _landingCenters[1];
    final t = Curves.easeOutCubic.transform(success);
    canvas.drawCircle(
      center,
      43 + t * 28,
      Paint()
        ..color = const Color(0xFFFFE57A).withValues(alpha: (1 - success) * 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6 * (1 - success),
    );
    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * (45 + 40 * t);
      canvas.drawCircle(
        point,
        3 * (1 - success * 0.55),
        Paint()..color = i.isEven ? accent : const Color(0xFFFFE57A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpaceProofPainter oldDelegate) => true;
}

class _ProofSemantics {
  const _ProofSemantics(this.instruction, this.steps, this.done);

  final String instruction;
  final String steps;
  final String done;

  String progress(int placed, bool solved) =>
      solved ? done : '$steps $placed/3';

  static _ProofSemantics forLocale(Locale locale) =>
      _localized[locale.languageCode] ?? _localized['en']!;

  static const _localized = <String, _ProofSemantics>{
    'ar': _ProofSemantics(
      'ضع رمزي المنع على الكوكبين المستحيلين، ثم ضع الكبسولة على المنصة المتبقية',
      'الخطوات المكتملة',
      'اكتمل البرهان',
    ),
    'de': _ProofSemantics(
      'Lege die Verbotsmarker auf die unmöglichen Planeten und dann die Kapsel auf den übrigen Landeplatz',
      'Abgeschlossene Schritte',
      'Beweis abgeschlossen',
    ),
    'en': _ProofSemantics(
      'Place the no tokens on the impossible planets, then place the capsule on the remaining landing pad',
      'Steps completed',
      'Proof complete',
    ),
    'es': _ProofSemantics(
      'Pon las fichas de prohibición en los planetas imposibles y luego la cápsula en la pista restante',
      'Pasos completados',
      'Prueba completada',
    ),
    'fr': _ProofSemantics(
      'Place les jetons interdits sur les planètes impossibles, puis la capsule sur la piste restante',
      'Étapes terminées',
      'Preuve terminée',
    ),
    'hi': _ProofSemantics(
      'असंभव ग्रहों पर निषेध टोकन रखें, फिर बचे हुए लैंडिंग स्थान पर कैप्सूल रखें',
      'पूरे किए गए चरण',
      'प्रमाण पूरा हुआ',
    ),
    'it': _ProofSemantics(
      'Metti i gettoni di divieto sui pianeti impossibili, poi la capsula sulla pista rimasta',
      'Passaggi completati',
      'Prova completata',
    ),
    'ja': _ProofSemantics(
      '不可能な惑星に禁止トークンを置き、残った着陸地点にカプセルを置いてください',
      '完了した手順',
      '証明完了',
    ),
    'ko': _ProofSemantics(
      '불가능한 행성에 금지 토큰을 놓고 남은 착륙장에 캡슐을 놓으세요',
      '완료한 단계',
      '증명 완료',
    ),
    'pt': _ProofSemantics(
      'Coloque as fichas de proibição nos planetas impossíveis e depois a cápsula na plataforma restante',
      'Etapas concluídas',
      'Prova concluída',
    ),
    'ru': _ProofSemantics(
      'Положите жетоны запрета на невозможные планеты, затем посадите капсулу на оставшуюся площадку',
      'Выполнено шагов',
      'Доказательство завершено',
    ),
    'zh': _ProofSemantics(
      '把禁止标记放到不可能的星球上，然后把太空舱放到剩下的着陆点',
      '已完成步骤',
      '推理完成',
    ),
  };
}
