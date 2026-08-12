import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _MirrorPathA11yCopy {
  const _MirrorPathA11yCopy({
    required this.mirror,
    required this.aligned,
    required this.turnNeeded,
    required this.rotateHint,
    required this.launch,
    required this.launchHint,
    required this.trace,
    required this.traceHint,
    required this.node,
    required this.progress,
    required this.solved,
  });

  final String mirror;
  final String aligned;
  final String turnNeeded;
  final String rotateHint;
  final String launch;
  final String launchHint;
  final String trace;
  final String traceHint;
  final String node;
  final String progress;
  final String solved;

  String mirrorLabel(int index) => '$mirror ${index + 1}';
  String traceValue(int nodeIndex, int completed, int total) =>
      '$node ${nodeIndex + 1}. $progress $completed / $total';

  static _MirrorPathA11yCopy of(BuildContext context) =>
      _copies[Localizations.localeOf(context).languageCode] ?? _copies['en']!;

  static const _copies = <String, _MirrorPathA11yCopy>{
    'ar': _MirrorPathA11yCopy(
        mirror: 'مرآة',
        aligned: 'محاذاة صحيحة',
        turnNeeded: 'تحتاج إلى تدوير',
        rotateHint: 'انقر لتدوير المرآة',
        launch: 'أطلق الشعاع',
        launchHint: 'تحقق من المرايا وابدأ تتبع الشعاع',
        trace: 'مسار الشعاع',
        traceHint: 'اسحب لأعلى أو لأسفل لاختيار عقدة، ثم انقر لإضافتها',
        node: 'عقدة',
        progress: 'تقدم المسار',
        solved: 'وصل الشعاع إلى الهدف'),
    'de': _MirrorPathA11yCopy(
        mirror: 'Spiegel',
        aligned: 'Richtig ausgerichtet',
        turnNeeded: 'Muss gedreht werden',
        rotateHint: 'Tippe, um den Spiegel zu drehen',
        launch: 'Strahl starten',
        launchHint: 'Prüfe die Spiegel und beginne die Strahlroute',
        trace: 'Strahlroute',
        traceHint:
            'Wische nach oben oder unten, um einen Knoten zu wählen, und tippe zum Hinzufügen',
        node: 'Knoten',
        progress: 'Routenfortschritt',
        solved: 'Der Strahl hat das Ziel erreicht'),
    'en': _MirrorPathA11yCopy(
        mirror: 'Mirror',
        aligned: 'Aligned',
        turnNeeded: 'Needs rotation',
        rotateHint: 'Tap to rotate this mirror',
        launch: 'Launch beam',
        launchHint: 'Check the mirrors and start tracing the beam',
        trace: 'Beam route',
        traceHint: 'Swipe up or down to choose a node, then tap to add it',
        node: 'Node',
        progress: 'Route progress',
        solved: 'Beam reached the target'),
    'es': _MirrorPathA11yCopy(
        mirror: 'Espejo',
        aligned: 'Bien orientado',
        turnNeeded: 'Hay que girarlo',
        rotateHint: 'Toca para girar este espejo',
        launch: 'Lanzar rayo',
        launchHint: 'Comprueba los espejos y empieza a trazar el rayo',
        trace: 'Ruta del rayo',
        traceHint:
            'Desliza arriba o abajo para elegir un nodo y toca para añadirlo',
        node: 'Nodo',
        progress: 'Progreso de la ruta',
        solved: 'El rayo llegó al objetivo'),
    'fr': _MirrorPathA11yCopy(
        mirror: 'Miroir',
        aligned: 'Bien orienté',
        turnNeeded: 'À faire pivoter',
        rotateHint: 'Touche pour faire pivoter ce miroir',
        launch: 'Lancer le rayon',
        launchHint: 'Vérifie les miroirs et commence à tracer le rayon',
        trace: 'Trajet du rayon',
        traceHint:
            'Balaye vers le haut ou le bas pour choisir un nœud, puis touche pour l’ajouter',
        node: 'Nœud',
        progress: 'Progression du trajet',
        solved: 'Le rayon a atteint la cible'),
    'hi': _MirrorPathA11yCopy(
        mirror: 'दर्पण',
        aligned: 'सही दिशा में',
        turnNeeded: 'घुमाना है',
        rotateHint: 'इस दर्पण को घुमाने के लिए टैप करें',
        launch: 'किरण चलाएँ',
        launchHint: 'दर्पण जाँचें और किरण का मार्ग बनाना शुरू करें',
        trace: 'किरण मार्ग',
        traceHint:
            'नोड चुनने के लिए ऊपर या नीचे स्वाइप करें, फिर जोड़ने के लिए टैप करें',
        node: 'नोड',
        progress: 'मार्ग की प्रगति',
        solved: 'किरण लक्ष्य तक पहुँच गई'),
    'it': _MirrorPathA11yCopy(
        mirror: 'Specchio',
        aligned: 'Allineato',
        turnNeeded: 'Da ruotare',
        rotateHint: 'Tocca per ruotare questo specchio',
        launch: 'Avvia raggio',
        launchHint: 'Controlla gli specchi e inizia a tracciare il raggio',
        trace: 'Percorso del raggio',
        traceHint:
            'Scorri su o giù per scegliere un nodo, poi tocca per aggiungerlo',
        node: 'Nodo',
        progress: 'Avanzamento percorso',
        solved: 'Il raggio ha raggiunto il bersaglio'),
    'ja': _MirrorPathA11yCopy(
        mirror: '鏡',
        aligned: '向きが合っています',
        turnNeeded: '回転が必要です',
        rotateHint: 'タップしてこの鏡を回転します',
        launch: '光を発射',
        launchHint: '鏡を確認して光のルートをたどり始めます',
        trace: '光のルート',
        traceHint: '上下にスワイプして点を選び、タップして追加します',
        node: '点',
        progress: 'ルートの進み具合',
        solved: '光がゴールに届きました'),
    'ko': _MirrorPathA11yCopy(
        mirror: '거울',
        aligned: '방향이 맞음',
        turnNeeded: '회전 필요',
        rotateHint: '탭하여 이 거울을 돌리세요',
        launch: '빛 발사',
        launchHint: '거울을 확인하고 빛의 경로를 따라가세요',
        trace: '빛의 경로',
        traceHint: '위아래로 밀어 지점을 고른 뒤 탭하여 추가하세요',
        node: '지점',
        progress: '경로 진행',
        solved: '빛이 목표에 도착했습니다'),
    'pt': _MirrorPathA11yCopy(
        mirror: 'Espelho',
        aligned: 'Alinhado',
        turnNeeded: 'Precisa girar',
        rotateHint: 'Toque para girar este espelho',
        launch: 'Lançar feixe',
        launchHint: 'Verifique os espelhos e comece a traçar o feixe',
        trace: 'Rota do feixe',
        traceHint:
            'Deslize para cima ou para baixo, escolha um ponto e toque para adicioná-lo',
        node: 'Ponto',
        progress: 'Progresso da rota',
        solved: 'O feixe chegou ao alvo'),
    'ru': _MirrorPathA11yCopy(
        mirror: 'Зеркало',
        aligned: 'Повернуто правильно',
        turnNeeded: 'Нужно повернуть',
        rotateHint: 'Нажмите, чтобы повернуть зеркало',
        launch: 'Запустить луч',
        launchHint: 'Проверьте зеркала и начните проводить луч',
        trace: 'Маршрут луча',
        traceHint:
            'Смахните вверх или вниз, выберите узел и нажмите, чтобы добавить его',
        node: 'Узел',
        progress: 'Прогресс маршрута',
        solved: 'Луч достиг цели'),
    'zh': _MirrorPathA11yCopy(
        mirror: '镜子',
        aligned: '方向正确',
        turnNeeded: '需要旋转',
        rotateHint: '点按旋转这面镜子',
        launch: '发射光束',
        launchHint: '检查镜子并开始描绘光束路线',
        trace: '光束路线',
        traceHint: '上下轻扫选择节点，然后点按将它加入路线',
        node: '节点',
        progress: '路线进度',
        solved: '光束已到达目标'),
  };
}

class MirrorPathGameView extends StatefulWidget {
  const MirrorPathGameView({
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
  State<MirrorPathGameView> createState() => _MirrorPathGameViewState();
}

class _MirrorPathGameViewState extends State<MirrorPathGameView>
    with TickerProviderStateMixin {
  static const _route = [0, 1, 4, 7, 6];
  static const _mirrorNodes = [1, 4, 7];
  static const _targetTurns = [1, 0, 1];

  late final AnimationController _error;
  late final AnimationController _success;
  final List<int> _turns = [0, 1, 0];
  int _progress = -1;
  bool _traceReady = false;
  bool _dragging = false;
  bool _solved = false;
  bool _answerSent = false;
  int _semanticNode = 0;

  bool get _mirrorsAligned {
    for (var index = 0; index < _turns.length; index++) {
      if (_turns[index] != _targetTurns[index]) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    _success.dispose();
    super.dispose();
  }

  List<Offset> _nodes(Size size) => [
        for (var row = 0; row < 3; row++)
          for (var col = 0; col < 3; col++)
            Offset(
              size.width * (0.18 + col * 0.32),
              size.height * (0.25 + row * 0.24),
            ),
      ];

  int _hitNode(Offset point, Size size) => _nodes(size).indexWhere(
      (node) => (point - node).distance <= (widget.compact ? 25 : 29));

  void _turnMirror(int index) {
    if (_traceReady || _solved) return;
    HapticFeedback.selectionClick();
    setState(() => _turns[index] = 1 - _turns[index]);
  }

  void _launchTrace() {
    if (_solved || _traceReady) return;
    if (!_mirrorsAligned) {
      _fail(resetTrace: false);
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _traceReady = true);
  }

  void _start(DragStartDetails details, Size size) {
    if (!_traceReady || _solved) return;
    if (_hitNode(details.localPosition, size) != _route.first) {
      _fail();
      return;
    }
    setState(() {
      _dragging = true;
      _progress = 0;
    });
  }

  void _move(DragUpdateDetails details, Size size) {
    if (!_dragging || _solved) return;
    final hit = _hitNode(details.localPosition, size);
    if (hit < 0 || hit == _route[_progress]) return;
    final next = _progress + 1;
    if (next < _route.length && hit == _route[next]) {
      HapticFeedback.selectionClick();
      setState(() => _progress = next);
      if (next == _route.length - 1) _complete();
      return;
    }
    _fail();
  }

  void _end(DragEndDetails details) {
    if (_solved) return;
    if (_dragging && _progress != _route.length - 1) _fail();
  }

  void _moveSemanticNode(int delta) {
    if (!_traceReady || _solved) return;
    HapticFeedback.selectionClick();
    setState(() => _semanticNode = (_semanticNode + delta + 9) % 9);
  }

  void _selectSemanticNode() {
    if (!_traceReady || _solved) return;
    if (_progress < 0) {
      if (_semanticNode != _route.first) {
        _fail();
        return;
      }
      setState(() => _progress = 0);
      return;
    }

    final next = _progress + 1;
    if (next < _route.length && _semanticNode == _route[next]) {
      HapticFeedback.selectionClick();
      setState(() => _progress = next);
      if (next == _route.length - 1) _complete();
      return;
    }
    _fail();
  }

  void _fail({bool resetTrace = true}) {
    HapticFeedback.lightImpact();
    setState(() {
      _dragging = false;
      if (resetTrace) {
        _progress = -1;
        _semanticNode = 0;
      }
    });
    _error.forward(from: 0);
  }

  void _complete() {
    setState(() {
      _dragging = false;
      _solved = true;
    });
    HapticFeedback.heavyImpact();
    _success.forward(from: 0).whenComplete(() {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final copy = _MirrorPathA11yCopy.of(context);
    final textDirection = Directionality.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: widget.semanticLabel,
      value: _solved ? copy.solved : null,
      textDirection: textDirection,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            key: const ValueKey('mirror-path-board'),
            width: 360,
            height: widget.compact ? 220 : 250,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final nodes = _nodes(size);
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Semantics(
                        key: const ValueKey('mirror-path-trace-semantics'),
                        container: true,
                        excludeSemantics: true,
                        label: copy.trace,
                        value: _solved
                            ? copy.solved
                            : copy.traceValue(
                                _semanticNode,
                                math.max(0, _progress + 1),
                                _route.length,
                              ),
                        hint: _traceReady ? copy.traceHint : copy.launchHint,
                        textDirection: textDirection,
                        increasedValue: _traceReady && !_solved
                            ? copy.traceValue(
                                (_semanticNode + 1) % 9,
                                math.max(0, _progress + 1),
                                _route.length,
                              )
                            : null,
                        decreasedValue: _traceReady && !_solved
                            ? copy.traceValue(
                                (_semanticNode + 8) % 9,
                                math.max(0, _progress + 1),
                                _route.length,
                              )
                            : null,
                        onIncrease: _traceReady && !_solved
                            ? () => _moveSemanticNode(1)
                            : null,
                        onDecrease: _traceReady && !_solved
                            ? () => _moveSemanticNode(-1)
                            : null,
                        onTap: _traceReady && !_solved
                            ? _selectSemanticNode
                            : null,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (details) => _start(details, size),
                          onPanUpdate: (details) => _move(details, size),
                          onPanEnd: _end,
                          child: AnimatedBuilder(
                            animation: Listenable.merge([_error, _success]),
                            builder: (context, child) => CustomPaint(
                              painter: _MirrorPathPainter(
                                accent: widget.accent,
                                route: _route,
                                mirrorNodes: _mirrorNodes,
                                turns: List<int>.of(_turns),
                                targetTurns: _targetTurns,
                                traceReady: _traceReady,
                                progress: _progress,
                                error: _error.value,
                                success: _success.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!_traceReady && !_solved)
                      for (var index = 0; index < _mirrorNodes.length; index++)
                        Positioned(
                          left: nodes[_mirrorNodes[index]].dx - 26,
                          top: nodes[_mirrorNodes[index]].dy - 26,
                          child: Semantics(
                            label: copy.mirrorLabel(index),
                            value: _turns[index] == _targetTurns[index]
                                ? copy.aligned
                                : copy.turnNeeded,
                            hint: copy.rotateHint,
                            textDirection: textDirection,
                            button: true,
                            onTap: () => _turnMirror(index),
                            child: ExcludeSemantics(
                              child: GestureDetector(
                                key: ValueKey('mirror-path-mirror-$index'),
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _turnMirror(index),
                                child: const SizedBox(width: 52, height: 52),
                              ),
                            ),
                          ),
                        ),
                    Positioned(
                      right: 18,
                      bottom: 14,
                      child: Semantics(
                        label: copy.launch,
                        value: _traceReady ? copy.aligned : null,
                        hint: copy.launchHint,
                        textDirection: textDirection,
                        button: true,
                        enabled: !_solved,
                        onTap: _solved ? null : _launchTrace,
                        child: ExcludeSemantics(
                          child: GestureDetector(
                            key: const ValueKey('mirror-path-launch'),
                            onTap: _launchTrace,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 48,
                              height: 42,
                              decoration: BoxDecoration(
                                color: _traceReady
                                    ? const Color(0xFF6CE0A8)
                                    : (_mirrorsAligned
                                        ? widget.accent
                                        : Colors.white.withValues(alpha: 0.16)),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                              child: Icon(
                                _traceReady
                                    ? Icons.gesture_rounded
                                    : Icons.bolt_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
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

class _MirrorPathPainter extends CustomPainter {
  const _MirrorPathPainter({
    required this.accent,
    required this.route,
    required this.mirrorNodes,
    required this.turns,
    required this.targetTurns,
    required this.traceReady,
    required this.progress,
    required this.error,
    required this.success,
  });

  final Color accent;
  final List<int> route;
  final List<int> mirrorNodes;
  final List<int> turns;
  final List<int> targetTurns;
  final bool traceReady;
  final int progress;
  final double error;
  final double success;

  List<Offset> _nodes(Size size) => [
        for (var row = 0; row < 3; row++)
          for (var col = 0; col < 3; col++)
            Offset(
              size.width * (0.18 + col * 0.32),
              size.height * (0.25 + row * 0.24),
            ),
      ];

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bounds, const Radius.circular(24)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF172347), Color(0xFF315E78)],
        ).createShader(bounds),
    );

    final shake = math.sin(error * math.pi * 7) * (1 - error) * 5;
    canvas.save();
    canvas.translate(shake, 0);
    final nodes = _nodes(size);
    final guide = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    const edges = [
      [0, 1],
      [1, 2],
      [0, 3],
      [1, 4],
      [2, 5],
      [3, 4],
      [4, 5],
      [3, 6],
      [4, 7],
      [5, 8],
      [6, 7],
      [7, 8],
    ];
    for (final edge in edges) {
      canvas.drawLine(nodes[edge[0]], nodes[edge[1]], guide);
    }

    for (var index = 0; index < route.length - 1; index++) {
      if (index >= progress) break;
      canvas.drawLine(
        nodes[route[index]],
        nodes[route[index + 1]],
        Paint()
          ..color = success > 0 ? const Color(0xFF6CE0A8) : accent
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round,
      );
    }

    for (var index = 0; index < nodes.length; index++) {
      final active = route.take(progress + 1).contains(index);
      canvas.drawCircle(
        nodes[index],
        active ? 10 : 7,
        Paint()
          ..color = active
              ? (success > 0 ? const Color(0xFF6CE0A8) : accent)
              : Colors.white.withValues(alpha: 0.58),
      );
      canvas.drawCircle(nodes[index], 3, Paint()..color = Colors.white);
    }

    for (var index = 0; index < mirrorNodes.length; index++) {
      final center = nodes[mirrorNodes[index]];
      final aligned = turns[index] == targetTurns[index];
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(turns[index] == 0 ? -math.pi / 4 : math.pi / 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 42, height: 12),
          const Radius.circular(6),
        ),
        Paint()
          ..color = aligned ? const Color(0xFF6CE0A8) : const Color(0xFFB8D9F3),
      );
      canvas.drawLine(
        const Offset(-15, -2),
        const Offset(15, -2),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.9)
          ..strokeWidth = 2,
      );
      canvas.restore();
    }

    final source = nodes[route.first];
    canvas.drawCircle(source, 17, Paint()..color = const Color(0xFFFFD45D));
    canvas.drawCircle(source, 7, Paint()..color = Colors.white);

    final destination = nodes[route.last];
    canvas.drawCircle(
      destination,
      18 + success * 8,
      Paint()
        ..color = const Color(0xFFFFD45D).withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(
        Offset(size.width * 0.43 + index * 18, size.height * 0.89),
        5,
        Paint()
          ..color = (index == 0 && !traceReady) || (index == 1 && traceReady)
              ? const Color(0xFFFFD45D)
              : Colors.white.withValues(alpha: 0.24),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MirrorPathPainter oldDelegate) =>
      oldDelegate.turns != turns ||
      oldDelegate.traceReady != traceReady ||
      oldDelegate.progress != progress ||
      oldDelegate.error != error ||
      oldDelegate.success != success ||
      oldDelegate.accent != accent;
}
