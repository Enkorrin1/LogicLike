import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CampStoryGameView extends StatefulWidget {
  const CampStoryGameView({
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
  State<CampStoryGameView> createState() => _CampStoryGameViewState();
}

enum _CampItem { lantern, bottle, compass, map, boot }

class _CampStoryGameViewState extends State<CampStoryGameView>
    with TickerProviderStateMixin {
  late final AnimationController _curtain;
  late final AnimationController _return;
  late final AnimationController _success;
  Timer? _memoryTimer;
  Timer? _answerTimer;
  _CampItem? _dragged;
  final Set<_CampItem> _placed = {};
  Offset _dragPosition = Offset.zero;
  Offset _returnFrom = Offset.zero;
  bool _changed = false;
  bool _solved = false;
  bool _answerSent = false;
  bool _wrong = false;

  static const _restoreOrder = [
    _CampItem.compass,
    _CampItem.map,
    _CampItem.lantern,
  ];
  static const _availableItems = [
    _CampItem.lantern,
    _CampItem.compass,
    _CampItem.map,
    _CampItem.boot,
  ];

  @override
  void initState() {
    super.initState();
    _curtain = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    _return = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    )..addListener(() {
        if (!mounted || _dragged == null) return;
        final t = Curves.easeOutBack.transform(_return.value);
        setState(() {
          _dragPosition = Offset.lerp(
            _returnFrom,
            _itemHome(_dragged!),
            t,
          )!;
        });
        if (_return.isCompleted) setState(() => _dragged = null);
      });
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
    _memoryTimer = Timer(const Duration(milliseconds: 1400), _changeScene);
  }

  void _changeScene() {
    if (!mounted) return;
    _curtain.forward(from: 0);
    Timer(const Duration(milliseconds: 360), () {
      if (mounted) setState(() => _changed = true);
    });
  }

  @override
  void dispose() {
    _memoryTimer?.cancel();
    _answerTimer?.cancel();
    _curtain.dispose();
    _return.dispose();
    _success.dispose();
    super.dispose();
  }

  bool get _interactive =>
      _changed && !_solved && !_wrong && !_return.isAnimating;

  Offset _toBoard(Offset local, Size size) {
    final scale =
        math.min(size.width / _board.width, size.height / _board.height);
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    return (local - origin) / scale;
  }

  void _start(DragStartDetails details, Size size) {
    if (!_interactive) return;
    final point = _toBoard(details.localPosition, size);
    for (final item in _availableItems.reversed) {
      if (!_placed.contains(item) && (point - _itemHome(item)).distance < 25) {
        HapticFeedback.selectionClick();
        setState(() {
          _dragged = item;
          _dragPosition = point;
        });
        return;
      }
    }
  }

  void _update(DragUpdateDetails details, Size size) {
    if (_dragged == null || _return.isAnimating) return;
    final point = _toBoard(details.localPosition, size);
    setState(() {
      _dragPosition = Offset(
        point.dx.clamp(18, 342),
        point.dy.clamp(24, 238),
      );
    });
  }

  void _end(DragEndDetails details) {
    final item = _dragged;
    if (item == null) return;
    final expected = _restoreOrder[_placed.length];
    final target = _itemTarget(expected);
    if (item == expected && (_dragPosition - target).distance < 40) {
      _placeItem(item);
      return;
    }
    _rejectItem();
  }

  void _placeItem(_CampItem item) {
    HapticFeedback.mediumImpact();
    setState(() {
      _placed.add(item);
      _dragged = null;
      _solved = _placed.length == _restoreOrder.length;
    });
    _success.forward(from: 0);
    if (_solved) {
      _answerTimer = Timer(const Duration(milliseconds: 720), () {
        if (!mounted || _answerSent) return;
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      });
    }
  }

  void _rejectItem() {
    HapticFeedback.lightImpact();
    _returnFrom = _dragPosition;
    setState(() => _wrong = true);
    _return.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _wrong = false);
    });
  }

  void _selectItemWithSemantics(_CampItem item) {
    if (!_changed || _solved || _answerSent || _placed.contains(item)) return;
    if (_return.isAnimating || _wrong) {
      _return.stop();
      _return.reset();
      setState(() {
        _wrong = false;
        _dragged = null;
      });
    }
    if (item == _restoreOrder[_placed.length]) {
      _placeItem(item);
    } else {
      _dragged = item;
      _dragPosition = _itemHome(item);
      _rejectItem();
    }
  }

  _CampA11yCopy _copy(BuildContext context) =>
      _campA11y[Localizations.localeOf(context).languageCode] ??
      _campA11y['en']!;

  @override
  Widget build(BuildContext context) {
    final copy = _copy(context);
    final semanticDirection = Directionality.of(context);
    final status = _wrong
        ? copy.error
        : _solved
            ? copy.complete
            : _changed
                ? copy.progress(_placed.length + 1, _restoreOrder.length)
                : copy.memorize;
    return Semantics(
      label: '${widget.semanticLabel}. ${copy.instruction}. $status',
      container: true,
      explicitChildNodes: true,
      liveRegion: true,
      textDirection: semanticDirection,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 224 : 258,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final scale = math.min(
                  size.width / _board.width,
                  size.height / _board.height,
                );
                final origin = Offset(
                  (size.width - _board.width * scale) / 2,
                  (size.height - _board.height * scale) / 2,
                );
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ExcludeSemantics(
                      child: GestureDetector(
                        key: const ValueKey('camp-story-board'),
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) => _start(details, size),
                        onPanUpdate: (details) => _update(details, size),
                        onPanEnd: _end,
                        child: AnimatedBuilder(
                          animation:
                              Listenable.merge([_curtain, _return, _success]),
                          builder: (context, _) => CustomPaint(
                            painter: _CampPainter(
                              accent: widget.accent,
                              curtain: _curtain.value,
                              success: _success.value,
                              changed: _changed,
                              solved: _solved,
                              wrong: _wrong,
                              placed: Set<_CampItem>.of(_placed),
                              stage: _placed.length,
                              successTarget: _placed.isEmpty
                                  ? _lanternTarget
                                  : _itemTarget(
                                      _restoreOrder[_placed.length - 1],
                                    ),
                              dragged: _dragged,
                              dragPosition: _dragPosition,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_changed && !_solved)
                      for (final item in _availableItems)
                        if (!_placed.contains(item))
                          Positioned(
                            left: origin.dx + (_itemHome(item).dx - 22) * scale,
                            top: origin.dy + (_itemHome(item).dy - 22) * scale,
                            width: 44 * scale,
                            height: 44 * scale,
                            child: _SemanticsOnlyOverlay(
                              child: Semantics(
                                key: ValueKey('camp-semantic-${item.name}'),
                                button: true,
                                textDirection: semanticDirection,
                                label: copy.itemNames[item]!,
                                hint: copy.itemHint(
                                  copy.itemNames[item]!,
                                  _placed.length + 1,
                                  _restoreOrder.length,
                                ),
                                onTap: () => _selectItemWithSemantics(item),
                                child: const SizedBox.expand(),
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

class _SemanticsOnlyOverlay extends SingleChildRenderObjectWidget {
  const _SemanticsOnlyOverlay({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSemanticsOnlyOverlay();
}

class _RenderSemanticsOnlyOverlay extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => false;
}

class _CampA11yCopy {
  const _CampA11yCopy({
    required this.instruction,
    required this.memorize,
    required this.error,
    required this.complete,
    required this.progressPattern,
    required this.itemHintPattern,
    required this.itemNames,
  });

  final String instruction;
  final String memorize;
  final String error;
  final String complete;
  final String progressPattern;
  final String itemHintPattern;
  final Map<_CampItem, String> itemNames;

  String progress(int step, int total) => progressPattern
      .replaceAll('{step}', '$step')
      .replaceAll('{total}', '$total');

  String itemHint(String item, int step, int total) => itemHintPattern
      .replaceAll('{item}', item)
      .replaceAll('{step}', '$step')
      .replaceAll('{total}', '$total');
}

const _campA11y = <String, _CampA11yCopy>{
  'ar': _CampA11yCopy(
    instruction:
        'تذكّر المخيم. أعد الأشياء الثلاثة المفقودة بالترتيب وتجنّب الشيء الدخيل.',
    memorize: 'استمع إلى المشهد وتذكّر مواقع الأشياء.',
    error: 'هذا ليس الشيء التالي. جرّب شيئًا آخر.',
    complete: 'اكتمل المخيم.',
    progressPattern: 'الخطوة {step} من {total}. اختر الشيء التالي.',
    itemHintPattern: 'ضع {item} كالخطوة {step} من {total}.',
    itemNames: {
      _CampItem.lantern: 'الفانوس',
      _CampItem.bottle: 'الزجاجة',
      _CampItem.compass: 'البوصلة',
      _CampItem.map: 'الخريطة',
      _CampItem.boot: 'الحذاء',
    },
  ),
  'de': _CampA11yCopy(
    instruction:
        'Merke dir das Lager. Lege die drei fehlenden Dinge der Reihe nach zurück und meide den Fremdkörper.',
    memorize: 'Merke dir die Positionen der Gegenstände.',
    error: 'Das ist nicht der nächste Gegenstand. Versuche einen anderen.',
    complete: 'Das Lager ist wieder vollständig.',
    progressPattern:
        'Schritt {step} von {total}. Wähle den nächsten Gegenstand.',
    itemHintPattern: '{item} als Schritt {step} von {total} einsetzen.',
    itemNames: {
      _CampItem.lantern: 'Laterne',
      _CampItem.bottle: 'Flasche',
      _CampItem.compass: 'Kompass',
      _CampItem.map: 'Karte',
      _CampItem.boot: 'Stiefel',
    },
  ),
  'en': _CampA11yCopy(
    instruction:
        'Remember the camp. Restore the three missing objects in order and avoid the decoy.',
    memorize: 'Memorize where the objects belong.',
    error: 'That is not the next object. Try another one.',
    complete: 'The camp is restored.',
    progressPattern: 'Step {step} of {total}. Choose the next object.',
    itemHintPattern: 'Place {item} as step {step} of {total}.',
    itemNames: {
      _CampItem.lantern: 'Lantern',
      _CampItem.bottle: 'Bottle',
      _CampItem.compass: 'Compass',
      _CampItem.map: 'Map',
      _CampItem.boot: 'Boot',
    },
  ),
  'es': _CampA11yCopy(
    instruction:
        'Recuerda el campamento. Devuelve los tres objetos perdidos en orden y evita el intruso.',
    memorize: 'Memoriza dónde va cada objeto.',
    error: 'Ese no es el siguiente objeto. Prueba con otro.',
    complete: 'El campamento está completo.',
    progressPattern: 'Paso {step} de {total}. Elige el siguiente objeto.',
    itemHintPattern: 'Coloca {item} como paso {step} de {total}.',
    itemNames: {
      _CampItem.lantern: 'Linterna',
      _CampItem.bottle: 'Botella',
      _CampItem.compass: 'Brújula',
      _CampItem.map: 'Mapa',
      _CampItem.boot: 'Bota',
    },
  ),
  'fr': _CampA11yCopy(
    instruction:
        'Mémorise le camp. Replace les trois objets disparus dans l’ordre et évite l’intrus.',
    memorize: 'Mémorise la place de chaque objet.',
    error: 'Ce n’est pas le prochain objet. Essaie-en un autre.',
    complete: 'Le camp est reconstitué.',
    progressPattern: 'Étape {step} sur {total}. Choisis le prochain objet.',
    itemHintPattern: 'Place {item} à l’étape {step} sur {total}.',
    itemNames: {
      _CampItem.lantern: 'Lanterne',
      _CampItem.bottle: 'Bouteille',
      _CampItem.compass: 'Boussole',
      _CampItem.map: 'Carte',
      _CampItem.boot: 'Botte',
    },
  ),
  'hi': _CampA11yCopy(
    instruction:
        'शिविर याद रखें। तीन गायब वस्तुओं को क्रम से वापस रखें और नकली वस्तु से बचें।',
    memorize: 'वस्तुओं की जगह याद करें।',
    error: 'यह अगली वस्तु नहीं है। कोई और चुनें।',
    complete: 'शिविर पूरा हो गया।',
    progressPattern: 'चरण {step}, कुल {total}। अगली वस्तु चुनें।',
    itemHintPattern: '{item} को चरण {step}, कुल {total} में रखें।',
    itemNames: {
      _CampItem.lantern: 'लालटेन',
      _CampItem.bottle: 'बोतल',
      _CampItem.compass: 'दिशासूचक',
      _CampItem.map: 'नक्शा',
      _CampItem.boot: 'जूता',
    },
  ),
  'it': _CampA11yCopy(
    instruction:
        'Memorizza il campo. Rimetti in ordine i tre oggetti mancanti ed evita l’intruso.',
    memorize: 'Memorizza la posizione degli oggetti.',
    error: 'Non è il prossimo oggetto. Provane un altro.',
    complete: 'Il campo è completo.',
    progressPattern: 'Passo {step} di {total}. Scegli il prossimo oggetto.',
    itemHintPattern: 'Metti {item} al passo {step} di {total}.',
    itemNames: {
      _CampItem.lantern: 'Lanterna',
      _CampItem.bottle: 'Bottiglia',
      _CampItem.compass: 'Bussola',
      _CampItem.map: 'Mappa',
      _CampItem.boot: 'Stivale',
    },
  ),
  'ja': _CampA11yCopy(
    instruction: 'キャンプを覚え、3つの道具を順番に戻して、まぎらわしい道具を避けましょう。',
    memorize: '道具の場所を覚えましょう。',
    error: '次の道具ではありません。別の道具を選んでください。',
    complete: 'キャンプが元に戻りました。',
    progressPattern: '{total}ステップ中{step}。次の道具を選びましょう。',
    itemHintPattern: '{item}を{total}ステップ中{step}として置きます。',
    itemNames: {
      _CampItem.lantern: 'ランタン',
      _CampItem.bottle: 'ボトル',
      _CampItem.compass: 'コンパス',
      _CampItem.map: '地図',
      _CampItem.boot: 'ブーツ',
    },
  ),
  'ko': _CampA11yCopy(
    instruction: '야영장을 기억하고 사라진 물건 세 개를 순서대로 돌려놓으세요. 가짜 물건은 피하세요.',
    memorize: '물건의 자리를 기억하세요.',
    error: '다음 물건이 아닙니다. 다른 물건을 골라 보세요.',
    complete: '야영장을 모두 복원했습니다.',
    progressPattern: '{total}단계 중 {step}단계. 다음 물건을 고르세요.',
    itemHintPattern: '{item}을 {total}단계 중 {step}단계로 놓습니다.',
    itemNames: {
      _CampItem.lantern: '랜턴',
      _CampItem.bottle: '물병',
      _CampItem.compass: '나침반',
      _CampItem.map: '지도',
      _CampItem.boot: '부츠',
    },
  ),
  'pt': _CampA11yCopy(
    instruction:
        'Memorize o acampamento. Recoloque os três objetos perdidos na ordem e evite o intruso.',
    memorize: 'Memorize onde fica cada objeto.',
    error: 'Esse não é o próximo objeto. Tente outro.',
    complete: 'O acampamento foi restaurado.',
    progressPattern: 'Etapa {step} de {total}. Escolha o próximo objeto.',
    itemHintPattern: 'Coloque {item} na etapa {step} de {total}.',
    itemNames: {
      _CampItem.lantern: 'Lanterna',
      _CampItem.bottle: 'Garrafa',
      _CampItem.compass: 'Bússola',
      _CampItem.map: 'Mapa',
      _CampItem.boot: 'Bota',
    },
  ),
  'ru': _CampA11yCopy(
    instruction:
        'Запомни лагерь. Верни три пропавших предмета по порядку и не бери лишний.',
    memorize: 'Запомни, где лежат предметы.',
    error: 'Это не следующий предмет. Попробуй другой.',
    complete: 'Лагерь восстановлен.',
    progressPattern: 'Шаг {step} из {total}. Выбери следующий предмет.',
    itemHintPattern: 'Поставить {item}: шаг {step} из {total}.',
    itemNames: {
      _CampItem.lantern: 'Фонарь',
      _CampItem.bottle: 'Бутылка',
      _CampItem.compass: 'Компас',
      _CampItem.map: 'Карта',
      _CampItem.boot: 'Ботинок',
    },
  ),
  'zh': _CampA11yCopy(
    instruction: '记住营地，把三个消失的物品按顺序放回去，并避开干扰物。',
    memorize: '记住每件物品的位置。',
    error: '这不是下一件物品，请试试其他物品。',
    complete: '营地已恢复完整。',
    progressPattern: '第 {step} 步，共 {total} 步。选择下一件物品。',
    itemHintPattern: '将{item}作为第 {step} 步，共 {total} 步。',
    itemNames: {
      _CampItem.lantern: '提灯',
      _CampItem.bottle: '水瓶',
      _CampItem.compass: '指南针',
      _CampItem.map: '地图',
      _CampItem.boot: '靴子',
    },
  ),
};

const _board = Size(360, 252);
const _lanternTarget = Offset(183, 93);

Offset _itemTarget(_CampItem item) => switch (item) {
      _CampItem.lantern => _lanternTarget,
      _CampItem.bottle => const Offset(145, 169),
      _CampItem.compass => const Offset(274, 170),
      _CampItem.map => const Offset(302, 127),
      _CampItem.boot => const Offset(0, 0),
    };

Offset _itemHome(_CampItem item) => switch (item) {
      _CampItem.lantern => const Offset(235, 219),
      _CampItem.bottle => const Offset(270, 219),
      _CampItem.compass => const Offset(305, 219),
      _CampItem.map => const Offset(337, 219),
      _CampItem.boot => const Offset(202, 219),
    };

class _CampPainter extends CustomPainter {
  const _CampPainter({
    required this.accent,
    required this.curtain,
    required this.success,
    required this.changed,
    required this.solved,
    required this.wrong,
    required this.placed,
    required this.stage,
    required this.successTarget,
    required this.dragged,
    required this.dragPosition,
  });

  final Color accent;
  final double curtain;
  final double success;
  final bool changed;
  final bool solved;
  final bool wrong;
  final Set<_CampItem> placed;
  final int stage;
  final Offset successTarget;
  final _CampItem? dragged;
  final Offset dragPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final scale =
        math.min(size.width / _board.width, size.height / _board.height);
    final origin = Offset(
      (size.width - _board.width * scale) / 2,
      (size.height - _board.height * scale) / 2,
    );
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFB9DCCA));
    canvas
      ..save()
      ..translate(origin.dx, origin.dy)
      ..scale(scale);
    _drawLandscape(canvas);
    _drawTent(canvas);
    _drawCampfire(canvas);
    _drawSceneItems(canvas);
    _drawBackpack(canvas);
    if (dragged != null) {
      _drawItem(canvas, dragged!, dragPosition, lifted: true);
    }
    if (curtain > 0 && curtain < 1) _drawCurtain(canvas);
    if (changed && !solved) _drawProgress(canvas);
    if (wrong) _drawWrongFlash(canvas);
    if (solved) _drawSuccess(canvas);
    canvas.restore();
  }

  void _drawLandscape(Canvas canvas) {
    const sky = Rect.fromLTWH(0, 0, 360, 252);
    canvas.drawRect(
      sky,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8CC9D1), Color(0xFFF6D39A), Color(0xFF739A64)],
          stops: [0, .56, .57],
        ).createShader(sky),
    );
    canvas.drawCircle(
        const Offset(311, 36), 18, Paint()..color = const Color(0xFFFFE59A));
    final far = Paint()..color = const Color(0xFF4F8069);
    final near = Paint()..color = const Color(0xFF315F4C);
    for (final x in <double>[8, 47, 91, 284, 330]) {
      _tree(canvas, Offset(x, 112), 48, far);
    }
    for (final x in <double>[22, 322]) {
      _tree(canvas, Offset(x, 145), 68, near);
    }
    canvas.drawOval(const Rect.fromLTWH(-25, 170, 410, 108),
        Paint()..color = const Color(0xFF577D4D));
    final grass = Paint()
      ..color = const Color(0xFF315F43)
      ..strokeWidth = 1.5;
    for (var x = 5.0; x < 360; x += 17) {
      final y = 187 + (x % 23);
      canvas.drawLine(Offset(x, y), Offset(x + 4, y - 8), grass);
      canvas.drawLine(Offset(x + 5, y), Offset(x + 2, y - 6), grass);
    }
  }

  void _tree(Canvas canvas, Offset base, double height, Paint paint) {
    canvas.drawRect(
        Rect.fromLTWH(base.dx - 3, base.dy - height * .3, 6, height * .3),
        Paint()..color = const Color(0xFF5A4435));
    final path = Path()
      ..moveTo(base.dx, base.dy - height)
      ..lineTo(base.dx - height * .3, base.dy - height * .2)
      ..lineTo(base.dx + height * .3, base.dy - height * .2)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawTent(Canvas canvas) {
    final tent = Path()
      ..moveTo(42, 187)
      ..lineTo(104, 99)
      ..lineTo(166, 187)
      ..close();
    canvas.drawShadow(tent, Colors.black, 7, false);
    canvas.drawPath(tent, Paint()..color = const Color(0xFFE6A653));
    final door = Path()
      ..moveTo(104, 107)
      ..lineTo(104, 187)
      ..lineTo(139, 187)
      ..close();
    canvas.drawPath(door, Paint()..color = const Color(0xFF9E593C));
    canvas.drawLine(
        const Offset(104, 99),
        const Offset(104, 190),
        Paint()
          ..color = const Color(0xFFFFE0A0)
          ..strokeWidth = 2);
    canvas.drawLine(
        const Offset(38, 187),
        const Offset(171, 187),
        Paint()
          ..color = const Color(0xFF5C493A)
          ..strokeWidth = 4);
  }

  void _drawCampfire(Canvas canvas) {
    canvas.drawOval(const Rect.fromLTWH(166, 174, 75, 22),
        Paint()..color = Colors.black.withValues(alpha: .16));
    final log = Paint()
      ..color = const Color(0xFF6A4432)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(180, 188), const Offset(222, 174), log);
    canvas.drawLine(const Offset(181, 175), const Offset(222, 189), log);
    final flame = Path()
      ..moveTo(201, 178)
      ..cubicTo(185, 164, 201, 151, 204, 139)
      ..cubicTo(222, 157, 220, 171, 201, 178)
      ..close();
    canvas.drawPath(flame, Paint()..color = const Color(0xFFF36B3B));
    canvas.drawOval(const Rect.fromLTWH(197, 156, 12, 19),
        Paint()..color = const Color(0xFFFFD45F));
  }

  void _drawSceneItems(Canvas canvas) {
    final rope = Paint()
      ..color = const Color(0xFF5B4637)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(166, 70), const Offset(199, 70), rope);
    canvas.drawLine(const Offset(182, 70), const Offset(182, 76), rope);
    if (!changed || placed.contains(_CampItem.lantern)) {
      _drawItem(canvas, _CampItem.lantern, _itemTarget(_CampItem.lantern));
    }
    _drawItem(canvas, _CampItem.bottle, const Offset(145, 169));
    if (!changed || placed.contains(_CampItem.compass)) {
      _drawItem(canvas, _CampItem.compass, _itemTarget(_CampItem.compass));
    }
    if (!changed || placed.contains(_CampItem.map)) {
      _drawItem(canvas, _CampItem.map, _itemTarget(_CampItem.map));
    }
    if (changed &&
        !solved &&
        stage < _CampStoryGameViewState._restoreOrder.length) {
      final target = _itemTarget(_CampStoryGameViewState._restoreOrder[stage]);
      canvas.drawCircle(
          target,
          22,
          Paint()
            ..color = accent.withValues(alpha: .18)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
    }
  }

  void _drawBackpack(Canvas canvas) {
    final bag = RRect.fromRectAndRadius(
        const Rect.fromLTWH(212, 195, 145, 55), const Radius.circular(17));
    canvas.drawShadow(Path()..addRRect(bag), Colors.black, 6, false);
    canvas.drawRRect(bag, Paint()..color = const Color(0xFF6E4939));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(218, 199, 133, 44), const Radius.circular(13)),
        Paint()..color = const Color(0xFFB97948));
    canvas.drawRect(const Rect.fromLTWH(220, 198, 129, 9),
        Paint()..color = const Color(0xFF49352D));
    for (final item in _CampItem.values) {
      if (item != _CampItem.bottle &&
          dragged != item &&
          !placed.contains(item)) {
        _drawItem(canvas, item, _itemHome(item));
      }
    }
  }

  void _drawItem(Canvas canvas, _CampItem item, Offset center,
      {bool lifted = false}) {
    canvas.save();
    canvas.translate(center.dx, center.dy - (lifted ? 6 : 0));
    if (lifted) {
      canvas.drawCircle(Offset.zero, 25,
          Paint()..color = Colors.white.withValues(alpha: .22));
    }
    switch (item) {
      case _CampItem.lantern:
        canvas.drawRRect(
            RRect.fromRectAndRadius(const Rect.fromLTWH(-10, -12, 20, 25),
                const Radius.circular(6)),
            Paint()..color = const Color(0xFFFFD56A));
        canvas.drawRect(const Rect.fromLTWH(-13, 10, 26, 5),
            Paint()..color = const Color(0xFF384C4A));
        canvas.drawRect(const Rect.fromLTWH(-12, -16, 24, 5),
            Paint()..color = const Color(0xFF384C4A));
        canvas.drawArc(
            const Rect.fromLTWH(-10, -24, 20, 17),
            math.pi,
            math.pi,
            false,
            Paint()
              ..color = const Color(0xFF384C4A)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3);
      case _CampItem.bottle:
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                const Rect.fromLTWH(-8, -15, 16, 29), const Radius.circular(5)),
            Paint()..color = const Color(0xFF72C7C2));
        canvas.drawRect(const Rect.fromLTWH(-5, -20, 10, 7),
            Paint()..color = const Color(0xFF345B59));
        canvas.drawRect(const Rect.fromLTWH(-8, 1, 16, 5),
            Paint()..color = Colors.white.withValues(alpha: .65));
      case _CampItem.compass:
        canvas.drawCircle(
            Offset.zero, 13, Paint()..color = const Color(0xFFE9C068));
        canvas.drawCircle(
            Offset.zero, 9, Paint()..color = const Color(0xFFF7F0D5));
        final needle = Path()
          ..moveTo(0, -7)
          ..lineTo(4, 3)
          ..lineTo(0, 1)
          ..lineTo(-4, 3)
          ..close();
        canvas.drawPath(needle, Paint()..color = accent);
      case _CampItem.map:
        final map = Path()
          ..moveTo(-14, -11)
          ..lineTo(-5, -14)
          ..lineTo(5, -10)
          ..lineTo(14, -13)
          ..lineTo(14, 12)
          ..lineTo(5, 9)
          ..lineTo(-5, 13)
          ..lineTo(-14, 10)
          ..close();
        canvas.drawPath(map, Paint()..color = const Color(0xFFF2E4B4));
        canvas.drawLine(const Offset(-5, -13), const Offset(-5, 12),
            Paint()..color = const Color(0xFFB9A775));
        canvas.drawLine(const Offset(5, -10), const Offset(5, 9),
            Paint()..color = const Color(0xFFB9A775));
        canvas.drawCircle(const Offset(8, 1), 3, Paint()..color = accent);
      case _CampItem.boot:
        final boot = Path()
          ..moveTo(-9, -17)
          ..lineTo(5, -17)
          ..lineTo(6, 4)
          ..quadraticBezierTo(16, 5, 16, 12)
          ..quadraticBezierTo(8, 18, -12, 13)
          ..close();
        canvas.drawPath(boot, Paint()..color = const Color(0xFF7656B5));
        canvas.drawLine(
          const Offset(-9, 7),
          const Offset(14, 10),
          Paint()
            ..color = const Color(0xFFDCCCFB)
            ..strokeWidth = 3,
        );
    }
    canvas.restore();
  }

  void _drawCurtain(Canvas canvas) {
    final wave = math.sin(curtain * math.pi);
    final x = -90 + curtain * 540;
    final path = Path()
      ..moveTo(x - 105, 0)
      ..lineTo(x + 55, 0)
      ..quadraticBezierTo(x + 105 + wave * 25, 126, x + 45, 252)
      ..lineTo(x - 115, 252)
      ..quadraticBezierTo(x - 55, 126, x - 105, 0)
      ..close();
    canvas.drawPath(
        path, Paint()..color = const Color(0xFF315D59).withValues(alpha: .94));
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: .10)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8);
  }

  void _drawSuccess(Canvas canvas) {
    final t = Curves.easeOutCubic.transform(success);
    final fade = 1 - t;
    canvas.drawCircle(
        successTarget,
        25 + t * 55,
        Paint()
          ..color = const Color(0xFFFFDA68).withValues(alpha: fade * .55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final p =
          successTarget + Offset(math.cos(a), math.sin(a)) * (31 + t * 45);
      canvas.drawCircle(p, 3.5 * fade,
          Paint()..color = i.isEven ? accent : const Color(0xFFFFE487));
    }
  }

  void _drawProgress(Canvas canvas) {
    for (var index = 0; index < 3; index++) {
      final center = Offset(16 + index * 19, 16);
      canvas.drawCircle(
        center,
        6,
        Paint()
          ..color = index < stage
              ? const Color(0xFF67E6A4)
              : Colors.white.withValues(alpha: .55),
      );
      if (index < stage) {
        canvas.drawLine(
          center + const Offset(-2.5, 0),
          center + const Offset(-.5, 2.5),
          Paint()
            ..color = const Color(0xFF245648)
            ..strokeWidth = 1.5
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawLine(
          center + const Offset(-.5, 2.5),
          center + const Offset(3, -2.5),
          Paint()
            ..color = const Color(0xFF245648)
            ..strokeWidth = 1.5
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  void _drawWrongFlash(Canvas canvas) {
    canvas.drawRect(
      Offset.zero & _board,
      Paint()..color = const Color(0xFFFF6D73).withValues(alpha: .12),
    );
  }

  @override
  bool shouldRepaint(covariant _CampPainter oldDelegate) => true;
}
