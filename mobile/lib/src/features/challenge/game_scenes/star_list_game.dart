import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StarListGameView extends StatefulWidget {
  const StarListGameView({
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
  State<StarListGameView> createState() => _StarListGameViewState();
}

enum _GamePhase { showing, choosing, solved }

enum _ObjectKind { star, rocket, planet, moon, crystal, satellite, comet }

class _StarListGameViewState extends State<StarListGameView>
    with TickerProviderStateMixin {
  static const _sequence = [
    _ObjectKind.star,
    _ObjectKind.rocket,
    _ObjectKind.planet,
    _ObjectKind.star,
    _ObjectKind.rocket,
  ];
  static const _targets = {
    _ObjectKind.star,
    _ObjectKind.rocket,
    _ObjectKind.planet,
  };
  static const _homes = [
    Offset(70, 150),
    Offset(145, 144),
    Offset(220, 151),
    Offset(294, 143),
    Offset(105, 205),
    Offset(180, 205),
    Offset(260, 202),
  ];

  late final AnimationController _flight;
  late final AnimationController _ambient;
  late final AnimationController _return;
  late final AnimationController _success;
  late final List<_MovingObject> _objects;
  _GamePhase _phase = _GamePhase.showing;
  int _shownIndex = 0;
  int? _active;
  int? _returning;
  Offset _dragAnchor = Offset.zero;
  Offset _returnFrom = Offset.zero;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _objects = List.generate(
      _ObjectKind.values.length,
      (index) => _MovingObject(_ObjectKind.values[index], _homes[index]),
    );
    _flight = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    );
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    _return = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..addListener(_animateReturn);
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _playSequence());
  }

  @override
  void dispose() {
    _flight.dispose();
    _ambient.dispose();
    _return.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _playSequence() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    for (var index = 0; index < _sequence.length; index++) {
      if (!mounted) return;
      setState(() => _shownIndex = index);
      await _flight.forward(from: 0);
      if (!mounted) return;
      await Future<void>.delayed(const Duration(milliseconds: 180));
    }
    if (mounted) setState(() => _phase = _GamePhase.choosing);
  }

  void _animateReturn() {
    final index = _returning;
    if (index == null) return;
    final t = Curves.easeOutBack.transform(_return.value);
    setState(() {
      _objects[index].position =
          Offset.lerp(_returnFrom, _objects[index].home, t)!;
    });
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
    if (_phase != _GamePhase.choosing || _return.isAnimating) return;
    final point = _toBoard(details.localPosition, size);
    for (var index = _objects.length - 1; index >= 0; index--) {
      final object = _objects[index];
      if (!object.placed && (point - object.position).distance < 31) {
        setState(() => _active = index);
        _dragAnchor = point - object.position;
        HapticFeedback.selectionClick();
        return;
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    final index = _active;
    if (index == null) return;
    final point = _toBoard(details.localPosition, size) - _dragAnchor;
    setState(() {
      _objects[index].position = Offset(
        point.dx.clamp(24, 336),
        point.dy.clamp(24, 216),
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final index = _active;
    if (index == null) return;
    final object = _objects[index];
    setState(() => _active = null);
    final dropped = (object.position - const Offset(180, 66)).distance < 61;
    if (dropped && _targets.contains(object.kind)) {
      final slot = _objects.where((item) => item.placed).length;
      setState(() {
        object
          ..placed = true
          ..position = Offset(152 + slot * 28, 68);
      });
      HapticFeedback.mediumImpact();
      if (_objects.where((item) => item.placed).length == _targets.length) {
        unawaited(_finish());
      }
      return;
    }
    HapticFeedback.lightImpact();
    _returning = index;
    _returnFrom = object.position;
    _return.forward(from: 0).whenComplete(() {
      if (mounted && _returning == index) setState(() => _returning = null);
    });
  }

  Future<void> _finish() async {
    setState(() => _phase = _GamePhase.solved);
    await _success.forward(from: 0);
    if (!mounted || _answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    final words = _StarListSemantics.forLocale(Localizations.localeOf(context));
    final selected = _objects.where((object) => object.placed).length;
    return Semantics(
      container: true,
      label: '${widget.semanticLabel}. ${words.instruction(_phase)}',
      hint: words.progress(selected, _phase == _GamePhase.solved),
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
                  onPanCancel: () {
                    if (_active != null) {
                      _onPanEnd(DragEndDetails());
                    }
                  },
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _flight,
                      _ambient,
                      _return,
                      _success,
                    ]),
                    builder: (context, child) => CustomPaint(
                      painter: _StarListPainter(
                        accent: widget.accent,
                        phase: _phase,
                        shown: _sequence[_shownIndex],
                        flight: _flight.value,
                        ambient: _ambient.value,
                        objects: _objects,
                        active: _active,
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

class _MovingObject {
  _MovingObject(this.kind, this.home) : position = home;

  final _ObjectKind kind;
  final Offset home;
  Offset position;
  bool placed = false;
}

class _StarListPainter extends CustomPainter {
  const _StarListPainter({
    required this.accent,
    required this.phase,
    required this.shown,
    required this.flight,
    required this.ambient,
    required this.objects,
    required this.active,
    required this.success,
  });

  final Color accent;
  final _GamePhase phase;
  final _ObjectKind shown;
  final double flight;
  final double ambient;
  final List<_MovingObject> objects;
  final int? active;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101C38), Color(0xFF24465B), Color(0xFF17283F)],
        ).createShader(bounds),
    );
    final scale = math.min(size.width / 360, size.height / 240);
    final origin = Offset(
      (size.width - 360 * scale) / 2,
      (size.height - 240 * scale) / 2,
    );
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    _drawStars(canvas);
    if (phase == _GamePhase.showing) {
      _drawTelescope(canvas);
      final eased = Curves.easeInOutCubic.transform(flight);
      final x = -35 + eased * 430;
      final y = 115 + math.sin(eased * math.pi) * -16;
      _drawObject(canvas, shown, Offset(x, y), 1.18, true);
    } else {
      _drawContainer(canvas);
      _drawCrate(canvas);
      for (var index = 0; index < objects.length; index++) {
        if (index != active) _drawMovingObject(canvas, objects[index], false);
      }
      if (active != null) _drawMovingObject(canvas, objects[active!], true);
      if (success > 0) _drawSuccess(canvas);
    }
    canvas.restore();
  }

  void _drawStars(Canvas canvas) {
    for (var index = 0; index < 25; index++) {
      final alpha =
          0.3 + 0.35 * math.sin(ambient * math.pi * 2 + index * 0.8).abs();
      canvas.drawCircle(
        Offset((13 + index * 79) % 355.0, (9 + index * 43) % 225.0),
        index % 5 == 0 ? 1.4 : 0.75,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
    }
  }

  void _drawTelescope(Canvas canvas) {
    final belt = RRect.fromRectAndRadius(
      const Rect.fromLTWH(18, 139, 324, 50),
      const Radius.circular(18),
    );
    canvas.drawRRect(belt, Paint()..color = const Color(0xFF172333));
    canvas.drawRRect(
      belt,
      Paint()
        ..color = accent.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    for (var x = 36.0; x < 335; x += 37) {
      canvas.drawCircle(
        Offset(x, 164),
        10,
        Paint()..color = const Color(0xFF536A78),
      );
      canvas.drawCircle(Offset(x, 164), 4, Paint()..color = accent);
    }
    final dome = Path()
      ..moveTo(105, 137)
      ..quadraticBezierTo(180, 30, 255, 137)
      ..close();
    canvas.drawPath(
      dome,
      Paint()..color = const Color(0xFF9EEBFA).withValues(alpha: 0.09),
    );
    canvas.drawPath(
      dome,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawContainer(Canvas canvas) {
    final glow = 0.16 + math.sin(ambient * math.pi * 2).abs() * 0.08;
    canvas.drawCircle(
      const Offset(180, 66),
      57,
      Paint()
        ..color = accent.withValues(alpha: glow)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(122, 29, 116, 74),
      const Radius.circular(19),
    );
    canvas.drawRRect(body, Paint()..color = const Color(0xFF243A55));
    canvas.drawRRect(
      body,
      Paint()
        ..color = const Color(0xFFFFD96B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    _drawStar(canvas, const Offset(180, 64), 20, accent, 0.42);
  }

  void _drawCrate(Canvas canvas) {
    final crate = RRect.fromRectAndRadius(
      const Rect.fromLTWH(31, 113, 298, 112),
      const Radius.circular(10),
    );
    canvas.drawRRect(crate, Paint()..color = const Color(0xFFA85F38));
    canvas.drawRRect(
      crate,
      Paint()
        ..color = const Color(0xFF603A2B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    for (final y in [128.0, 183.0]) {
      canvas.drawLine(
        Offset(36, y),
        Offset(324, y),
        Paint()
          ..color = const Color(0xFFD98B4F).withValues(alpha: 0.6)
          ..strokeWidth = 3,
      );
    }
    canvas.drawLine(
      const Offset(40, 218),
      const Offset(113, 119),
      Paint()
        ..color = const Color(0xFF70412D)
        ..strokeWidth = 8,
    );
    canvas.drawLine(
      const Offset(320, 218),
      const Offset(247, 119),
      Paint()
        ..color = const Color(0xFF70412D)
        ..strokeWidth = 8,
    );
  }

  void _drawMovingObject(Canvas canvas, _MovingObject object, bool active) {
    if (object.placed) return;
    _drawObject(
        canvas, object.kind, object.position, active ? 1.18 : 1, active);
  }

  void _drawObject(
    Canvas canvas,
    _ObjectKind kind,
    Offset center,
    double scale,
    bool lifted,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    if (lifted) {
      canvas.drawCircle(
        const Offset(0, 4),
        27,
        Paint()
          ..color = accent.withValues(alpha: 0.27)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
    }
    switch (kind) {
      case _ObjectKind.star:
        _drawStar(canvas, Offset.zero, 23, const Color(0xFFFFD75A), 1);
      case _ObjectKind.rocket:
        _drawRocket(canvas);
      case _ObjectKind.planet:
        _drawPlanet(canvas);
      case _ObjectKind.moon:
        canvas.drawCircle(
          Offset.zero,
          21,
          Paint()..color = const Color(0xFFF1F3D2),
        );
        canvas.drawCircle(
          const Offset(9, -5),
          19,
          Paint()..color = const Color(0xFF71839A),
        );
      case _ObjectKind.crystal:
        final path = Path()
          ..moveTo(0, -25)
          ..lineTo(18, -8)
          ..lineTo(11, 23)
          ..lineTo(-12, 23)
          ..lineTo(-19, -8)
          ..close();
        canvas.drawPath(path, Paint()..color = const Color(0xFF7DE5D0));
        canvas.drawLine(
          const Offset(0, -20),
          const Offset(0, 19),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.55)
            ..strokeWidth = 2,
        );
      case _ObjectKind.satellite:
        canvas.drawRect(
          const Rect.fromLTWH(-14, -12, 28, 24),
          Paint()..color = const Color(0xFFE9EEF2),
        );
        for (final x in [-29.0, 17.0]) {
          canvas.drawRect(
            Rect.fromLTWH(x, -9, 12, 18),
            Paint()..color = const Color(0xFF61A9D4),
          );
        }
        canvas.drawCircle(Offset.zero, 6, Paint()..color = accent);
      case _ObjectKind.comet:
        canvas.drawPath(
          Path()
            ..moveTo(-30, -10)
            ..quadraticBezierTo(-5, -5, 7, 7)
            ..lineTo(-28, 16)
            ..close(),
          Paint()..color = const Color(0xFFFF8C61),
        );
        canvas.drawCircle(
          const Offset(10, 0),
          18,
          Paint()..color = const Color(0xFFBFA5E8),
        );
    }
    canvas.restore();
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    final path = Path();
    for (var index = 0; index < 10; index++) {
      final angle = -math.pi / 2 + index * math.pi / 5;
      final r = index.isEven ? radius : radius * 0.44;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * r;
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: opacity));
  }

  void _drawRocket(Canvas canvas) {
    final body = Path()
      ..moveTo(0, -27)
      ..quadraticBezierTo(18, -10, 13, 18)
      ..lineTo(-13, 18)
      ..quadraticBezierTo(-18, -10, 0, -27)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFF4F7F8));
    canvas.drawCircle(const Offset(0, -6), 7, Paint()..color = accent);
    canvas.drawPath(
      Path()
        ..moveTo(-10, 15)
        ..lineTo(0, 30)
        ..lineTo(10, 15)
        ..close(),
      Paint()..color = const Color(0xFFFF8263),
    );
  }

  void _drawPlanet(Canvas canvas) {
    canvas.drawCircle(
        Offset.zero, 19, Paint()..color = const Color(0xFF9C7DD4));
    canvas.save();
    canvas.rotate(-0.25);
    canvas.drawOval(
      const Rect.fromLTWH(-31, -8, 62, 16),
      Paint()
        ..color = const Color(0xFFFFD36B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
    canvas.restore();
  }

  void _drawSuccess(Canvas canvas) {
    final t = Curves.easeOutCubic.transform(success);
    for (var index = 0; index < 16; index++) {
      final angle = index * math.pi / 8;
      final point = const Offset(180, 66) +
          Offset(math.cos(angle), math.sin(angle)) * (45 + 55 * t);
      canvas.drawCircle(
        point,
        4 * (1 - success),
        Paint()..color = index.isEven ? accent : const Color(0xFFFFD75A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarListPainter oldDelegate) => true;
}

class _StarListSemantics {
  const _StarListSemantics(this.watch, this.choose, this.steps, this.done);

  final String watch;
  final String choose;
  final String steps;
  final String done;

  String instruction(_GamePhase phase) =>
      phase == _GamePhase.showing ? watch : choose;
  String progress(int selected, bool solved) =>
      solved ? done : '$steps $selected/3';

  static _StarListSemantics forLocale(Locale locale) =>
      _localized[locale.languageCode] ?? _localized['en']!;

  static const _localized = <String, _StarListSemantics>{
    'ar': _StarListSemantics(
      'تذكر الأشياء التي تمر واحدا تلو الآخر',
      'اسحب الأشياء التي رأيتها إلى حاوية النجمة',
      'العناصر المختارة',
      'اكتملت القائمة',
    ),
    'de': _StarListSemantics(
      'Merke dir die Gegenstände, die nacheinander vorbeifliegen',
      'Ziehe die gesehenen Gegenstände in den Sternenbehälter',
      'Ausgewählte Gegenstände',
      'Liste vollständig',
    ),
    'en': _StarListSemantics(
      'Remember the objects flying past one by one',
      'Drag the objects you saw into the star container',
      'Objects selected',
      'List complete',
    ),
    'es': _StarListSemantics(
      'Recuerda los objetos que pasan uno por uno',
      'Arrastra los objetos que viste al contenedor estelar',
      'Objetos seleccionados',
      'Lista completa',
    ),
    'fr': _StarListSemantics(
      'Mémorise les objets qui passent un par un',
      'Fais glisser les objets vus dans le conteneur étoilé',
      'Objets sélectionnés',
      'Liste terminée',
    ),
    'hi': _StarListSemantics(
      'एक-एक करके उड़ती वस्तुओं को याद रखें',
      'देखी हुई वस्तुओं को तारा पात्र में खींचें',
      'चुनी गई वस्तुएं',
      'सूची पूरी हुई',
    ),
    'it': _StarListSemantics(
      'Ricorda gli oggetti che passano uno alla volta',
      'Trascina gli oggetti visti nel contenitore stellare',
      'Oggetti selezionati',
      'Elenco completo',
    ),
    'ja': _StarListSemantics(
      '一つずつ通り過ぎる物を覚えてください',
      '見た物を星のコンテナにドラッグしてください',
      '選んだ物',
      'リスト完成',
    ),
    'ko': _StarListSemantics(
      '하나씩 지나가는 물건을 기억하세요',
      '본 물건을 별 컨테이너로 드래그하세요',
      '선택한 물건',
      '목록 완성',
    ),
    'pt': _StarListSemantics(
      'Memorize os objetos que passam um de cada vez',
      'Arraste os objetos vistos para o recipiente estelar',
      'Objetos selecionados',
      'Lista completa',
    ),
    'ru': _StarListSemantics(
      'Запомните предметы, которые пролетают по одному',
      'Перетащите увиденные предметы в звёздный контейнер',
      'Выбрано предметов',
      'Список собран',
    ),
    'zh': _StarListSemantics(
      '记住逐个飞过的物品',
      '把看到的物品拖到星星容器中',
      '已选择物品',
      '列表完成',
    ),
  };
}
