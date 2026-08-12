import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class WhatChangedGameView extends StatefulWidget {
  const WhatChangedGameView({
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
  State<WhatChangedGameView> createState() => _WhatChangedGameViewState();
}

class _WhatChangedGameViewState extends State<WhatChangedGameView>
    with TickerProviderStateMixin {
  late final AnimationController _curtain;
  late final AnimationController _reaction;
  int _round = 0;
  int _dialTaps = 0;
  double _tubeSwipe = 0;
  Offset _flask = _flaskMoved;
  Offset _anchor = Offset.zero;
  bool _dragging = false;
  bool _roundLocked = false;
  bool _mistake = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _curtain = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )
      ..addStatusListener((status) {
        if (mounted && status == AnimationStatus.completed) setState(() {});
      })
      ..forward();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _curtain.dispose();
    _reaction.dispose();
    super.dispose();
  }

  bool get _ready => _curtain.isCompleted && !_roundLocked && !_sent;

  Offset _boardPoint(Offset local, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    return (local -
            Offset((size.width - 360 * scale) / 2,
                (size.height - 240 * scale) / 2)) /
        scale;
  }

  void _panStart(DragStartDetails details, Size size) {
    if (!_ready) return;
    final point = _boardPoint(details.localPosition, size);
    if (_round == 0 && (point - _flask).distance < 40) {
      _dragging = true;
      _anchor = point - _flask;
      setState(() {});
    } else if (_round == 2 && point.dx > 185 && point.dy > 108) {
      _dragging = true;
      _anchor = point;
      _tubeSwipe = 0;
    }
  }

  void _panUpdate(DragUpdateDetails details, Size size) {
    if (!_dragging) return;
    final point = _boardPoint(details.localPosition, size);
    if (_round == 0) {
      setState(() => _flask = point - _anchor);
    } else if (_round == 2) {
      setState(() => _tubeSwipe = point.dx - _anchor.dx);
    }
  }

  void _panEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;
    if (_round == 0 && (_flask - _flaskHome).distance < 38) {
      setState(() => _flask = _flaskHome);
      _finishRound();
    } else if (_round == 2 &&
        (_tubeSwipe < -55 || details.velocity.pixelsPerSecond.dx < -180)) {
      _finishRound();
    } else {
      _showMistake();
    }
  }

  void _showMistake() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_round == 0) _flask = _flaskMoved;
      _mistake = true;
    });
    _reaction.forward(from: 0).whenComplete(() {
      if (!mounted || _roundLocked || _sent) return;
      setState(() => _mistake = false);
    });
  }

  void _selectObjectWithSemantics(int object) {
    if (!_ready) return;
    if (object != _round) {
      _showMistake();
      return;
    }
    switch (_round) {
      case 0:
        setState(() => _flask = _flaskHome);
        _finishRound();
        return;
      case 1:
        HapticFeedback.selectionClick();
        setState(() => _dialTaps++);
        if (_dialTaps == 3) _finishRound();
        return;
      case 2:
        _finishRound();
        return;
    }
  }

  void _tap(TapUpDetails details, Size size) {
    if (!_ready || _round != 1) return;
    final point = _boardPoint(details.localPosition, size);
    if ((point - _dialCenter).distance > 37) return;
    HapticFeedback.selectionClick();
    setState(() => _dialTaps++);
    if (_dialTaps == 3) _finishRound();
  }

  void _finishRound() {
    if (_roundLocked || _sent) return;
    HapticFeedback.lightImpact();
    setState(() {
      _roundLocked = true;
      _mistake = false;
    });
    _reaction.forward(from: 0).whenComplete(() {
      if (!mounted || _sent) return;
      if (_round == 2) {
        _sent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      } else {
        setState(() {
          _round++;
          _roundLocked = false;
        });
        _reaction.reset();
        _curtain.forward(from: 0);
      }
    });
  }

  _ChangedA11yCopy _copy(BuildContext context) =>
      _changedA11y[Localizations.localeOf(context).languageCode] ??
      _changedA11y['en']!;

  @override
  Widget build(BuildContext context) {
    final copy = _copy(context);
    final semanticDirection = Directionality.of(context);
    final status = _mistake
        ? copy.error
        : _sent
            ? copy.complete
            : !_curtain.isCompleted
                ? copy.observe
                : copy.progress(
                    _round + 1,
                    3,
                    _round == 1 ? _dialTaps + 1 : 1,
                    _round == 1 ? 3 : 1,
                  );
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
            height: widget.compact ? 216 : 246,
            child: LayoutBuilder(builder: (context, constraints) {
              final size = constraints.biggest;
              final scale = math.min(size.width / 360, size.height / 240);
              final origin = Offset(
                (size.width - 360 * scale) / 2,
                (size.height - 240 * scale) / 2,
              );
              const centers = [_flaskHome, _dialCenter, Offset(247, 144)];
              return Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeSemantics(
                    child: GestureDetector(
                      key: const ValueKey('what-changed-board'),
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (event) => _panStart(event, size),
                      onPanUpdate: (event) => _panUpdate(event, size),
                      onPanEnd: _panEnd,
                      onTapUp: (event) => _tap(event, size),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_curtain, _reaction]),
                        builder: (context, child) => CustomPaint(
                          key: ValueKey(
                              'what-changed-round-$_round-taps-$_dialTaps'),
                          painter: _ChangedLabPainter(
                            accent: widget.accent,
                            round: _round,
                            dialTaps: _dialTaps,
                            flask: _flask,
                            dragging: _dragging,
                            curtain: _curtain.value,
                            reaction: _reaction.value,
                            locked: _roundLocked,
                            mistake: _mistake,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_ready)
                    for (var object = 0; object < centers.length; object++)
                      Positioned(
                        left: origin.dx + (centers[object].dx - 42) * scale,
                        top: origin.dy + (centers[object].dy - 42) * scale,
                        width: 84 * scale,
                        height: 84 * scale,
                        child: _SemanticsOnlyOverlay(
                          child: Semantics(
                            key: ValueKey('changed-semantic-object-$object'),
                            button: true,
                            textDirection: semanticDirection,
                            label: copy.objects[object],
                            hint: object == 1 && _round == 1
                                ? copy.dialHint(_dialTaps + 1, 3)
                                : copy.objectHint(copy.objects[object]),
                            onTap: () => _selectObjectWithSemantics(object),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                ],
              );
            }),
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

class _ChangedA11yCopy {
  const _ChangedA11yCopy({
    required this.instruction,
    required this.observe,
    required this.error,
    required this.complete,
    required this.progressPattern,
    required this.objectHintPattern,
    required this.dialHintPattern,
    required this.objects,
  });

  final String instruction;
  final String observe;
  final String error;
  final String complete;
  final String progressPattern;
  final String objectHintPattern;
  final String dialHintPattern;
  final List<String> objects;

  String progress(int round, int rounds, int step, int steps) => progressPattern
      .replaceAll('{round}', '$round')
      .replaceAll('{rounds}', '$rounds')
      .replaceAll('{step}', '$step')
      .replaceAll('{steps}', '$steps');
  String objectHint(String object) =>
      objectHintPattern.replaceAll('{object}', object);
  String dialHint(int step, int steps) => dialHintPattern
      .replaceAll('{step}', '$step')
      .replaceAll('{steps}', '$steps');
}

const _changedA11y = <String, _ChangedA11yCopy>{
  'ar': _ChangedA11yCopy(
    instruction: 'راقب المختبر، ثم حدد ما تغيّر وأصلحه في ثلاث جولات.',
    observe: 'راقب المشهد وانتظر حتى تفتح الستارة.',
    error: 'هذا ليس الشيء الذي تغيّر. حاول مرة أخرى.',
    complete: 'تم إصلاح التغيّرات الثلاثة.',
    progressPattern:
        'الجولة {round} من {rounds}، الخطوة {step} من {steps}. ما الذي تغيّر؟',
    objectHintPattern: 'اختر {object} إذا كان هو الذي تغيّر.',
    dialHintPattern: 'أدر القرص، الخطوة {step} من {steps}.',
    objects: ['الدورق', 'القرص', 'أنابيب الاختبار'],
  ),
  'de': _ChangedA11yCopy(
    instruction:
        'Beobachte das Labor, finde die Veränderung und stelle sie in drei Runden wieder her.',
    observe: 'Beobachte die Szene und warte, bis sich der Vorhang öffnet.',
    error: 'Dieser Gegenstand hat sich nicht verändert. Versuche es erneut.',
    complete: 'Alle drei Veränderungen sind behoben.',
    progressPattern:
        'Runde {round} von {rounds}, Schritt {step} von {steps}. Was hat sich verändert?',
    objectHintPattern: '{object} wählen, wenn es sich verändert hat.',
    dialHintPattern: 'Regler drehen, Schritt {step} von {steps}.',
    objects: ['Kolben', 'Regler', 'Reagenzgläser'],
  ),
  'en': _ChangedA11yCopy(
    instruction:
        'Watch the lab, identify what changed, and restore it in three rounds.',
    observe: 'Observe the scene and wait for the curtain to open.',
    error: 'That object did not change. Try again.',
    complete: 'All three changes are restored.',
    progressPattern:
        'Round {round} of {rounds}, step {step} of {steps}. What changed?',
    objectHintPattern: 'Choose {object} if it is what changed.',
    dialHintPattern: 'Turn the dial, step {step} of {steps}.',
    objects: ['flask', 'dial', 'test tubes'],
  ),
  'es': _ChangedA11yCopy(
    instruction:
        'Observa el laboratorio, identifica qué cambió y restáuralo en tres rondas.',
    observe: 'Observa la escena y espera a que se abra la cortina.',
    error: 'Ese objeto no cambió. Inténtalo de nuevo.',
    complete: 'Has restaurado los tres cambios.',
    progressPattern:
        'Ronda {round} de {rounds}, paso {step} de {steps}. ¿Qué cambió?',
    objectHintPattern: 'Elige {object} si es lo que cambió.',
    dialHintPattern: 'Gira el dial, paso {step} de {steps}.',
    objects: ['matraz', 'dial', 'tubos de ensayo'],
  ),
  'fr': _ChangedA11yCopy(
    instruction:
        'Observe le laboratoire, trouve ce qui a changé et rétablis-le en trois manches.',
    observe: 'Observe la scène et attends l’ouverture du rideau.',
    error: 'Cet objet n’a pas changé. Réessaie.',
    complete: 'Les trois changements sont corrigés.',
    progressPattern:
        'Manche {round} sur {rounds}, étape {step} sur {steps}. Qu’est-ce qui a changé ?',
    objectHintPattern: 'Choisis {object} si c’est ce qui a changé.',
    dialHintPattern: 'Tourne le cadran, étape {step} sur {steps}.',
    objects: ['fiole', 'cadran', 'éprouvettes'],
  ),
  'hi': _ChangedA11yCopy(
    instruction:
        'प्रयोगशाला देखें, बदलाव पहचानें और तीन दौरों में उसे ठीक करें।',
    observe: 'दृश्य देखें और परदा खुलने तक रुकें।',
    error: 'यह वस्तु नहीं बदली। फिर कोशिश करें।',
    complete: 'तीनों बदलाव ठीक हो गए।',
    progressPattern:
        'दौर {round}, कुल {rounds}; चरण {step}, कुल {steps}। क्या बदला?',
    objectHintPattern: 'अगर {object} बदला है तो इसे चुनें।',
    dialHintPattern: 'डायल घुमाएं, चरण {step}, कुल {steps}।',
    objects: ['फ्लास्क', 'डायल', 'परखनलियाँ'],
  ),
  'it': _ChangedA11yCopy(
    instruction:
        'Osserva il laboratorio, individua il cambiamento e ripristinalo in tre round.',
    observe: 'Osserva la scena e attendi che si apra il sipario.',
    error: 'Questo oggetto non è cambiato. Riprova.',
    complete: 'Hai ripristinato tutti e tre i cambiamenti.',
    progressPattern:
        'Round {round} di {rounds}, passo {step} di {steps}. Cosa è cambiato?',
    objectHintPattern: 'Scegli {object} se è ciò che è cambiato.',
    dialHintPattern: 'Gira la manopola, passo {step} di {steps}.',
    objects: ['beuta', 'manopola', 'provette'],
  ),
  'ja': _ChangedA11yCopy(
    instruction: '実験室を観察し、変わったものを見つけて3ラウンドで元に戻しましょう。',
    observe: '場面を観察し、カーテンが開くまで待ちましょう。',
    error: 'その道具は変わっていません。もう一度試してください。',
    complete: '3つの変化をすべて元に戻しました。',
    progressPattern: '{rounds}ラウンド中{round}、{steps}ステップ中{step}。何が変わったでしょう？',
    objectHintPattern: '{object}が変わったと思うなら選びます。',
    dialHintPattern: 'ダイヤルを回す。{steps}ステップ中{step}。',
    objects: ['フラスコ', 'ダイヤル', '試験管'],
  ),
  'ko': _ChangedA11yCopy(
    instruction: '실험실을 관찰하고 바뀐 것을 찾아 세 라운드에서 되돌리세요.',
    observe: '장면을 관찰하고 커튼이 열릴 때까지 기다리세요.',
    error: '이 물건은 바뀌지 않았습니다. 다시 시도하세요.',
    complete: '세 가지 변화를 모두 되돌렸습니다.',
    progressPattern: '{rounds}라운드 중 {round}, {steps}단계 중 {step}. 무엇이 바뀌었나요?',
    objectHintPattern: '{object}이 바뀐 것이라면 선택하세요.',
    dialHintPattern: '다이얼을 돌리세요. {steps}단계 중 {step}.',
    objects: ['플라스크', '다이얼', '시험관'],
  ),
  'pt': _ChangedA11yCopy(
    instruction:
        'Observe o laboratório, identifique o que mudou e restaure em três rodadas.',
    observe: 'Observe a cena e espere a cortina abrir.',
    error: 'Esse objeto não mudou. Tente novamente.',
    complete: 'As três mudanças foram restauradas.',
    progressPattern:
        'Rodada {round} de {rounds}, etapa {step} de {steps}. O que mudou?',
    objectHintPattern: 'Escolha {object} se foi o que mudou.',
    dialHintPattern: 'Gire o seletor, etapa {step} de {steps}.',
    objects: ['frasco', 'seletor', 'tubos de ensaio'],
  ),
  'ru': _ChangedA11yCopy(
    instruction:
        'Изучи лабораторию, найди изменение и исправь его в трёх раундах.',
    observe: 'Наблюдай за сценой и дождись, когда откроется занавес.',
    error: 'Этот предмет не изменился. Попробуй ещё раз.',
    complete: 'Все три изменения исправлены.',
    progressPattern:
        'Раунд {round} из {rounds}, шаг {step} из {steps}. Что изменилось?',
    objectHintPattern: 'Выбрать {object}, если изменился именно этот предмет.',
    dialHintPattern: 'Повернуть регулятор: шаг {step} из {steps}.',
    objects: ['колба', 'регулятор', 'пробирки'],
  ),
  'zh': _ChangedA11yCopy(
    instruction: '观察实验室，找出变化，并在三个回合中将其恢复。',
    observe: '观察场景，等待帷幕打开。',
    error: '这件物品没有变化，请再试一次。',
    complete: '三处变化全部恢复。',
    progressPattern: '第 {round} 回合，共 {rounds} 回合；第 {step} 步，共 {steps} 步。什么变了？',
    objectHintPattern: '如果变化的是{object}，请选择它。',
    dialHintPattern: '转动旋钮，第 {step} 步，共 {steps} 步。',
    objects: ['烧瓶', '旋钮', '试管'],
  ),
};

const _flaskHome = Offset(83, 167);
const _flaskMoved = Offset(280, 103);
const _dialCenter = Offset(155, 132);

class _ChangedLabPainter extends CustomPainter {
  const _ChangedLabPainter({
    required this.accent,
    required this.round,
    required this.dialTaps,
    required this.flask,
    required this.dragging,
    required this.curtain,
    required this.reaction,
    required this.locked,
    required this.mistake,
  });

  final Color accent;
  final int round;
  final int dialTaps;
  final Offset flask;
  final bool dragging;
  final double curtain;
  final double reaction;
  final bool locked;
  final bool mistake;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    canvas.save();
    canvas.translate(
        (size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    canvas.scale(scale);
    _room(canvas);
    _flaskObject(canvas, round == 0 ? flask : _flaskHome, dragging);
    _dial(canvas);
    _tubes(canvas);
    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(
          Offset(154 + index * 26, 18),
          6,
          Paint()
            ..color = index < round
                ? const Color(0xFF42C997)
                : index == round
                    ? accent
                    : const Color(0xFFB8CFCC));
    }
    if (curtain < .78) {
      final width = (1 - Curves.easeInOut.transform(curtain / .78)) * 180;
      canvas.drawRect(Rect.fromLTWH(0, 0, width, 240),
          Paint()..color = const Color(0xFF315A68));
      canvas.drawRect(Rect.fromLTWH(360 - width, 0, width, 240),
          Paint()..color = const Color(0xFF315A68));
    }
    if (locked) {
      canvas.drawCircle(
          [_flaskHome, _dialCenter, const Offset(247, 144)][round],
          30 + reaction * 34,
          Paint()
            ..color =
                const Color(0xFF42C997).withValues(alpha: (1 - reaction) * .35)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5);
    }
    if (mistake) {
      final center = round == 0 ? _flaskMoved : const Offset(247, 144);
      canvas.drawCircle(
        center,
        28 + math.sin(reaction * math.pi) * 10,
        Paint()
          ..color =
              const Color(0xFFFF6B6B).withValues(alpha: .8 - reaction * .35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5,
      );
    }
    canvas.restore();
  }

  void _room(Canvas canvas) {
    const wall = Rect.fromLTWH(0, 0, 360, 178);
    canvas.drawRect(
        wall,
        Paint()
          ..shader = const LinearGradient(
                  colors: [Color(0xFFF4FCF9), Color(0xFFCBE4E0)])
              .createShader(wall));
    final grid = Paint()
      ..color = const Color(0x258FB9B4)
      ..strokeWidth = 1;
    for (var x = 0.0; x <= 360; x += 45) {
      canvas.drawLine(Offset(x, 0), Offset(x, 178), grid);
    }
    for (var y = 44.0; y < 178; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(360, y), grid);
    }
    canvas.drawRect(const Rect.fromLTWH(0, 176, 360, 64),
        Paint()..color = const Color(0xFF31545A));
    canvas.drawRect(const Rect.fromLTWH(0, 173, 360, 13),
        Paint()..color = const Color(0xFFDAA76A));
  }

  void _flaskObject(Canvas canvas, Offset center, bool lifted) {
    canvas.save();
    canvas.translate(center.dx, center.dy - (lifted ? 5 : 0));
    final path = Path()
      ..moveTo(-8, -30)
      ..lineTo(8, -30)
      ..lineTo(8, -12)
      ..quadraticBezierTo(26, 11, 25, 19)
      ..quadraticBezierTo(20, 29, 0, 29)
      ..quadraticBezierTo(-20, 29, -25, 19)
      ..quadraticBezierTo(-26, 11, -8, -12)
      ..close();
    canvas.drawShadow(path, Colors.black, lifted ? 9 : 4, false);
    canvas.drawPath(path, Paint()..color = const Color(0xFFD9F5F0));
    canvas.drawOval(const Rect.fromLTWH(-22, 8, 44, 20),
        Paint()..color = const Color(0xFFEF6F91));
    canvas.drawRect(const Rect.fromLTWH(-11, -34, 22, 6),
        Paint()..color = const Color(0xFF345760));
    canvas.restore();
  }

  void _dial(Canvas canvas) {
    canvas.drawCircle(
        _dialCenter, 34, Paint()..color = const Color(0xFF315A68));
    canvas.drawCircle(
        _dialCenter, 27, Paint()..color = const Color(0xFFFFF2BF));
    final angle = (-.7 + dialTaps * .7) * math.pi;
    canvas.drawLine(
        _dialCenter,
        _dialCenter + Offset(math.cos(angle), math.sin(angle)) * 19,
        Paint()
          ..color = accent
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round);
    canvas.drawCircle(_dialCenter, 5, Paint()..color = accent);
  }

  void _tubes(Canvas canvas) {
    final shifted = round == 2;
    const colors = [Color(0xFFFFD36E), Color(0xFFEF738B), Color(0xFF6FC6DF)];
    for (var index = 0; index < 3; index++) {
      final x = 220.0 + index * 27 + (shifted ? 12 : 0);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(x, 112, 14, 54), const Radius.circular(7)),
          Paint()..color = const Color(0xFFE2F7F3));
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(x + 2, 138, 10, 26), const Radius.circular(5)),
          Paint()..color = colors[index]);
    }
    if (round == 2) {
      canvas.drawLine(
          const Offset(286, 180),
          const Offset(202, 180),
          Paint()
            ..color = accent
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(covariant _ChangedLabPainter oldDelegate) => true;
}
