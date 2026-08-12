import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ShadowMatchGameView extends StatefulWidget {
  const ShadowMatchGameView({
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
  State<ShadowMatchGameView> createState() => _ShadowMatchGameViewState();
}

class _ShadowMatchGameViewState extends State<ShadowMatchGameView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reaction;
  int _round = 0;
  Offset _piece = _home;
  Offset _anchor = Offset.zero;
  bool _dragging = false;
  bool _locked = false;
  bool _mistake = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }

  Offset _scenePoint(Offset local, Size size) {
    final scale = math.min(size.width / 360, size.height / 240);
    final origin =
        Offset((size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    return (local - origin) / scale;
  }

  void _start(DragStartDetails details, Size size) {
    if (_locked || _sent) return;
    final point = _scenePoint(details.localPosition, size);
    if ((point - _piece).distance > 44) return;
    setState(() => _dragging = true);
    _anchor = point - _piece;
  }

  void _move(DragUpdateDetails details, Size size) {
    if (!_dragging) return;
    final point = _scenePoint(details.localPosition, size) - _anchor;
    setState(() => _piece = Offset(
          point.dx.clamp(28, 332),
          point.dy.clamp(42, 214),
        ));
  }

  void _end(DragEndDetails details) {
    if (!_dragging) return;
    setState(() => _dragging = false);
    var nearest = 0;
    for (var index = 1; index < _targets.length; index++) {
      if ((_piece - _targets[index]).distance <
          (_piece - _targets[nearest]).distance) {
        nearest = index;
      }
    }
    _resolveTarget(nearest, (_piece - _targets[nearest]).distance <= 62);
  }

  void _selectTargetWithSemantics(int target) {
    if (_locked || _sent) return;
    setState(() => _piece = _targets[target]);
    _resolveTarget(target, true);
  }

  void _resolveTarget(int target, bool isCloseEnough) {
    if (target != _answers[_round] || !isCloseEnough) {
      HapticFeedback.selectionClick();
      setState(() {
        _piece = _home;
        _mistake = true;
      });
      _reaction.forward(from: 0).whenComplete(() {
        if (!mounted || _locked || _sent) return;
        setState(() => _mistake = false);
      });
      return;
    }
    HapticFeedback.lightImpact();
    setState(() {
      _locked = true;
      _mistake = false;
      _piece = _targets[target];
    });
    _reaction.forward(from: 0).whenComplete(() async {
      if (!mounted || _sent) return;
      if (_round == 2) {
        _sent = true;
        widget.onAnswerSelected(widget.correctAnswer);
        return;
      }
      setState(() {
        _round++;
        _piece = _home;
        _locked = false;
      });
      _reaction.reset();
    });
  }

  _ShadowA11yCopy _copy(BuildContext context) =>
      _shadowA11y[Localizations.localeOf(context).languageCode] ??
      _shadowA11y['en']!;

  @override
  Widget build(BuildContext context) {
    final copy = _copy(context);
    final semanticDirection = Directionality.of(context);
    final status = _mistake
        ? copy.error
        : _sent
            ? copy.complete
            : copy.progress(_round + 1, _answers.length, copy.objects[_round]);
    return Semantics(
      key: ValueKey(
        'shadow-semantic-round-$_round-${_locked ? 'locked' : 'ready'}',
      ),
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
            height: widget.compact ? 216 : 246,
            width: double.infinity,
            child: LayoutBuilder(builder: (context, constraints) {
              final size = constraints.biggest;
              final scale = math.min(size.width / 360, size.height / 240);
              final origin = Offset(
                (size.width - 360 * scale) / 2,
                (size.height - 240 * scale) / 2,
              );
              return Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeSemantics(
                    child: GestureDetector(
                      key: const ValueKey('shadow-match-board'),
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (event) => _start(event, size),
                      onPanUpdate: (event) => _move(event, size),
                      onPanEnd: _end,
                      child: AnimatedBuilder(
                        animation: _reaction,
                        builder: (context, child) => CustomPaint(
                          painter: _ShadowPainter(
                            accent: widget.accent,
                            round: _round,
                            piece: _piece,
                            dragging: _dragging,
                            reaction: _reaction.value,
                            locked: _locked,
                            mistake: _mistake,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!_sent)
                    for (var target = 0; target < _targets.length; target++)
                      Positioned(
                        left: origin.dx + (_targets[target].dx - 40) * scale,
                        top: origin.dy + (_targets[target].dy - 50) * scale,
                        width: 80 * scale,
                        height: 92 * scale,
                        child: _SemanticsOnlyOverlay(
                          child: Semantics(
                            key: ValueKey('shadow-semantic-target-$target'),
                            button: true,
                            textDirection: semanticDirection,
                            label: copy.targetLabel(target + 1),
                            hint: copy.targetHint(copy.objects[_round]),
                            onTap: () => _selectTargetWithSemantics(target),
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

class _ShadowA11yCopy {
  const _ShadowA11yCopy({
    required this.instruction,
    required this.error,
    required this.complete,
    required this.progressPattern,
    required this.targetLabelPattern,
    required this.targetHintPattern,
    required this.objects,
  });

  final String instruction;
  final String error;
  final String complete;
  final String progressPattern;
  final String targetLabelPattern;
  final String targetHintPattern;
  final List<String> objects;

  String progress(int round, int rounds, String object) => progressPattern
      .replaceAll('{round}', '$round')
      .replaceAll('{rounds}', '$rounds')
      .replaceAll('{object}', object);
  String targetLabel(int target) =>
      targetLabelPattern.replaceAll('{target}', '$target');
  String targetHint(String object) =>
      targetHintPattern.replaceAll('{object}', object);
}

const _shadowA11y = <String, _ShadowA11yCopy>{
  'ar': _ShadowA11yCopy(
    instruction: 'طابق كل غرض مع ظلّه الصحيح في ثلاث جولات.',
    error: 'هذا ليس الظل الصحيح. جرّب ظلًا آخر.',
    complete: 'تمت مطابقة الظلال الثلاثة.',
    progressPattern: 'الجولة {round} من {rounds}. اختر ظل {object}.',
    targetLabelPattern: 'الظل {target}',
    targetHintPattern: 'طابق {object} مع هذا الظل.',
    objects: ['الحقيبة', 'الحذاء', 'إبريق الشاي'],
  ),
  'de': _ShadowA11yCopy(
    instruction:
        'Ordne in drei Runden jeden Gegenstand seinem richtigen Schatten zu.',
    error: 'Das ist nicht der richtige Schatten. Versuche einen anderen.',
    complete: 'Alle drei Schatten sind richtig zugeordnet.',
    progressPattern:
        'Runde {round} von {rounds}. Finde den Schatten für {object}.',
    targetLabelPattern: 'Schatten {target}',
    targetHintPattern: '{object} diesem Schatten zuordnen.',
    objects: ['Tasche', 'Stiefel', 'Teekanne'],
  ),
  'en': _ShadowA11yCopy(
    instruction: 'Match each object to its correct shadow in three rounds.',
    error: 'That is not the correct shadow. Try another one.',
    complete: 'All three shadows are matched.',
    progressPattern: 'Round {round} of {rounds}. Find the shadow for {object}.',
    targetLabelPattern: 'Shadow {target}',
    targetHintPattern: 'Match {object} to this shadow.',
    objects: ['bag', 'boot', 'teapot'],
  ),
  'es': _ShadowA11yCopy(
    instruction: 'Relaciona cada objeto con su sombra correcta en tres rondas.',
    error: 'Esa no es la sombra correcta. Prueba otra.',
    complete: 'Las tres sombras están relacionadas.',
    progressPattern: 'Ronda {round} de {rounds}. Busca la sombra de {object}.',
    targetLabelPattern: 'Sombra {target}',
    targetHintPattern: 'Relaciona {object} con esta sombra.',
    objects: ['bolso', 'bota', 'tetera'],
  ),
  'fr': _ShadowA11yCopy(
    instruction: 'Associe chaque objet à son ombre en trois manches.',
    error: 'Ce n’est pas la bonne ombre. Essaie-en une autre.',
    complete: 'Les trois ombres sont associées.',
    progressPattern: 'Manche {round} sur {rounds}. Trouve l’ombre de {object}.',
    targetLabelPattern: 'Ombre {target}',
    targetHintPattern: 'Associe {object} à cette ombre.',
    objects: ['sac', 'botte', 'théière'],
  ),
  'hi': _ShadowA11yCopy(
    instruction: 'तीन दौरों में हर वस्तु को उसकी सही छाया से मिलाएं।',
    error: 'यह सही छाया नहीं है। दूसरी छाया चुनें।',
    complete: 'तीनों छायाएं मिल गईं।',
    progressPattern: 'दौर {round}, कुल {rounds}। {object} की छाया खोजें।',
    targetLabelPattern: 'छाया {target}',
    targetHintPattern: '{object} को इस छाया से मिलाएं।',
    objects: ['बैग', 'जूता', 'चायदानी'],
  ),
  'it': _ShadowA11yCopy(
    instruction: 'Abbina ogni oggetto alla sua ombra corretta in tre round.',
    error: 'Non è l’ombra corretta. Provane un’altra.',
    complete: 'Hai abbinato tutte e tre le ombre.',
    progressPattern: 'Round {round} di {rounds}. Trova l’ombra di {object}.',
    targetLabelPattern: 'Ombra {target}',
    targetHintPattern: 'Abbina {object} a questa ombra.',
    objects: ['borsa', 'stivale', 'teiera'],
  ),
  'ja': _ShadowA11yCopy(
    instruction: '3ラウンドで、それぞれの道具に合う影を選びましょう。',
    error: 'その影ではありません。別の影を試してください。',
    complete: '3つの影をすべて合わせました。',
    progressPattern: '{rounds}ラウンド中{round}。{object}の影を選びましょう。',
    targetLabelPattern: '影{target}',
    targetHintPattern: '{object}をこの影に合わせます。',
    objects: ['かばん', 'ブーツ', 'ティーポット'],
  ),
  'ko': _ShadowA11yCopy(
    instruction: '세 라운드에서 각 물건을 알맞은 그림자와 연결하세요.',
    error: '올바른 그림자가 아닙니다. 다른 그림자를 골라 보세요.',
    complete: '세 그림자를 모두 맞춰습니다.',
    progressPattern: '{rounds}라운드 중 {round}. {object}의 그림자를 찾으세요.',
    targetLabelPattern: '그림자 {target}',
    targetHintPattern: '{object}을 이 그림자와 연결합니다.',
    objects: ['가방', '부츠', '찻주전자'],
  ),
  'pt': _ShadowA11yCopy(
    instruction: 'Associe cada objeto à sombra correta em três rodadas.',
    error: 'Essa não é a sombra correta. Tente outra.',
    complete: 'As três sombras foram associadas.',
    progressPattern:
        'Rodada {round} de {rounds}. Encontre a sombra de {object}.',
    targetLabelPattern: 'Sombra {target}',
    targetHintPattern: 'Associe {object} a esta sombra.',
    objects: ['bolsa', 'bota', 'bule'],
  ),
  'ru': _ShadowA11yCopy(
    instruction: 'За три раунда сопоставь каждый предмет с его тенью.',
    error: 'Это не та тень. Попробуй другую.',
    complete: 'Все три тени сопоставлены.',
    progressPattern: 'Раунд {round} из {rounds}. Найди тень для: {object}.',
    targetLabelPattern: 'Тень {target}',
    targetHintPattern: 'Сопоставить {object} с этой тенью.',
    objects: ['сумка', 'ботинок', 'чайник'],
  ),
  'zh': _ShadowA11yCopy(
    instruction: '在三个回合中，将每件物品与正确的影子配对。',
    error: '这不是正确的影子，请试试其他影子。',
    complete: '三个影子全部配对完成。',
    progressPattern: '第 {round} 回合，共 {rounds} 回合。找到{object}的影子。',
    targetLabelPattern: '影子 {target}',
    targetHintPattern: '将{object}与这个影子配对。',
    objects: ['包', '靴子', '茶壶'],
  ),
};

const _home = Offset(180, 205);
const _targets = [Offset(70, 111), Offset(180, 101), Offset(290, 111)];
const _answers = [1, 0, 2];

class _ShadowPainter extends CustomPainter {
  const _ShadowPainter({
    required this.accent,
    required this.round,
    required this.piece,
    required this.dragging,
    required this.reaction,
    required this.locked,
    required this.mistake,
  });

  final Color accent;
  final int round;
  final Offset piece;
  final bool dragging;
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
    const scene = Rect.fromLTWH(0, 0, 360, 240);
    canvas.drawRect(
      scene,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF11173A), Color(0xFF315B5B)],
        ).createShader(scene),
    );
    _forest(canvas);
    for (var index = 0; index < 3; index++) {
      _pedestal(canvas, _targets[index]);
      _object(canvas, _targets[index], index, shadow: true);
    }
    final bounce = locked ? math.sin(reaction * math.pi) * 7 : 0.0;
    _object(canvas, piece - Offset(0, (dragging ? 5 : 0) + bounce), round);
    if (mistake) {
      final pulse = 26 + math.sin(reaction * math.pi) * 12;
      canvas.drawCircle(
        _home,
        pulse,
        Paint()
          ..color =
              const Color(0xFFFF6B6B).withValues(alpha: .75 - reaction * .35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5,
      );
    }
    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(
        Offset(154 + index * 26, 19),
        6,
        Paint()
          ..color = index < round
              ? const Color(0xFF62D6A5)
              : index == round
                  ? Colors.white
                  : Colors.white38,
      );
    }
    canvas.restore();
  }

  void _forest(Canvas canvas) {
    canvas.drawCircle(
        const Offset(300, 43), 23, Paint()..color = const Color(0xFFFFE7A5));
    final ground = Path()
      ..moveTo(0, 148)
      ..quadraticBezierTo(180, 126, 360, 150)
      ..lineTo(360, 240)
      ..lineTo(0, 240)
      ..close();
    canvas.drawPath(ground, Paint()..color = const Color(0xFF153C3A));
    final tree = Paint()..color = const Color(0xFF102831);
    for (var index = 0; index < 12; index++) {
      final x = index * 34.0 - 12;
      canvas.drawPath(
        Path()
          ..moveTo(x, 151)
          ..lineTo(x + 14, 75 + (index % 3) * 9)
          ..lineTo(x + 29, 151)
          ..close(),
        tree,
      );
    }
  }

  void _pedestal(Canvas canvas, Offset center) {
    canvas.drawOval(
        Rect.fromCenter(
            center: center + const Offset(0, 28), width: 72, height: 24),
        Paint()..color = const Color(0xFF8D6442));
  }

  void _object(Canvas canvas, Offset center, int kind, {bool shadow = false}) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    final color = shadow
        ? const Color(0xFF07151C)
        : [
            const Color(0xFFFFCB58),
            const Color(0xFFEF7D62),
            const Color(0xFF62C9BF)
          ][kind];
    if (kind == 0) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(-20, -21, 40, 40), const Radius.circular(8)),
          Paint()..color = color);
      canvas.drawArc(
          const Rect.fromLTWH(-16, -38, 32, 34),
          math.pi,
          math.pi,
          false,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5);
      if (!shadow) canvas.drawCircle(Offset.zero, 8, Paint()..color = accent);
    } else if (kind == 1) {
      final path = Path()
        ..moveTo(-19, 14)
        ..lineTo(-13, -28)
        ..quadraticBezierTo(5, -30, 9, -14)
        ..lineTo(3, 0)
        ..quadraticBezierTo(27, 2, 29, 14)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
    } else {
      canvas.drawOval(
          const Rect.fromLTWH(-23, -17, 46, 34), Paint()..color = color);
      canvas.drawArc(
          const Rect.fromLTWH(8, -15, 31, 28),
          -math.pi / 2,
          math.pi,
          false,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 7);
      final spout = Path()
        ..moveTo(-18, -8)
        ..quadraticBezierTo(-40, -20, -40, -6)
        ..quadraticBezierTo(-28, -2, -20, 6)
        ..close();
      canvas.drawPath(spout, Paint()..color = color);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShadowPainter oldDelegate) =>
      oldDelegate.round != round ||
      oldDelegate.piece != piece ||
      oldDelegate.dragging != dragging ||
      oldDelegate.reaction != reaction ||
      oldDelegate.locked != locked ||
      oldDelegate.mistake != mistake ||
      oldDelegate.accent != accent;
}
