import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class RouteMemoryGameView extends StatefulWidget {
  const RouteMemoryGameView({
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
  State<RouteMemoryGameView> createState() => _RouteMemoryGameViewState();
}

enum _RoutePhase { showing, tracing, retrying, transitioning, solved }

class _RouteMemoryGameViewState extends State<RouteMemoryGameView>
    with TickerProviderStateMixin {
  static const _routes = <List<int>>[
    [12, 8, 9, 5, 6],
    [3, 2, 6, 10, 9, 13],
    [0, 4, 5, 6, 10, 14, 15],
  ];

  late final AnimationController _ambient;
  late final AnimationController _feedback;
  late final AnimationController _success;
  _RoutePhase _phase = _RoutePhase.showing;
  final List<int> _trace = [];
  int _showRun = 0;
  int _round = 0;
  bool _dragging = false;
  bool _answerSent = false;

  List<int> get _route => _routes[_round];

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _feedback = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRoute());
  }

  @override
  void dispose() {
    _showRun++;
    _ambient.dispose();
    _feedback.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _showRoute({bool retry = false}) async {
    final run = ++_showRun;
    setState(() {
      _phase = retry ? _RoutePhase.retrying : _RoutePhase.showing;
      _dragging = false;
      _trace.clear();
    });
    await Future<void>.delayed(
      Duration(milliseconds: retry ? 850 : 1400),
    );
    if (!mounted || run != _showRun) return;
    setState(() => _phase = _RoutePhase.tracing);
  }

  int _cellAt(Offset point, Size size) {
    final board = _RouteLayout.board(size);
    if (!board.contains(point)) return -1;
    final column = ((point.dx - board.left) / (board.width / 4)).floor();
    final row = ((point.dy - board.top) / (board.height / 4)).floor();
    return row * 4 + column;
  }

  void _start(DragStartDetails details, Size size) {
    if (_phase != _RoutePhase.tracing) return;
    _dragging = true;
    final cell = _cellAt(details.localPosition, size);
    if (cell != _route.first) {
      _retry();
      return;
    }
    setState(() => _trace.add(cell));
    HapticFeedback.selectionClick();
  }

  void _move(DragUpdateDetails details, Size size) {
    if (!_dragging || _phase != _RoutePhase.tracing || _trace.isEmpty) return;
    final cell = _cellAt(details.localPosition, size);
    if (cell < 0 || cell == _trace.last) return;
    final expectedIndex = _trace.length;
    if (expectedIndex >= _route.length || cell != _route[expectedIndex]) {
      _retry();
      return;
    }
    setState(() => _trace.add(cell));
    HapticFeedback.selectionClick();
    if (_trace.length == _route.length) _completeRound();
  }

  void _end(DragEndDetails details) {
    if (_phase == _RoutePhase.tracing && _dragging) _retry();
  }

  void _selectCellWithSemantics(int cell) {
    if (_phase != _RoutePhase.tracing) return;
    final expectedIndex = _trace.length;
    if (expectedIndex >= _route.length || cell != _route[expectedIndex]) {
      _retry();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _trace.add(cell));
    if (_trace.length == _route.length) _completeRound();
  }

  void _retry() {
    if (_phase != _RoutePhase.tracing) return;
    _dragging = false;
    HapticFeedback.lightImpact();
    setState(() => _phase = _RoutePhase.retrying);
    _feedback.forward(from: 0).whenComplete(() {
      if (mounted && _phase == _RoutePhase.retrying) {
        unawaited(_showRoute(retry: true));
      }
    });
  }

  void _completeRound() {
    _dragging = false;
    HapticFeedback.mediumImpact();
    if (_round < _routes.length - 1) {
      final run = ++_showRun;
      setState(() => _phase = _RoutePhase.transitioning);
      _success.forward(from: 0).whenComplete(() async {
        if (!mounted || run != _showRun) return;
        await Future<void>.delayed(const Duration(milliseconds: 340));
        if (!mounted || run != _showRun) return;
        setState(() {
          _round++;
          _trace.clear();
        });
        _success.reset();
        await _showRoute();
      });
      return;
    }
    setState(() => _phase = _RoutePhase.solved);
    _success.forward(from: 0).whenComplete(() {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  _RouteA11yCopy _copy(BuildContext context) =>
      _routeA11y[Localizations.localeOf(context).languageCode] ??
      _routeA11y['en']!;

  @override
  Widget build(BuildContext context) {
    final copy = _copy(context);
    final semanticDirection = Directionality.of(context);
    final status = switch (_phase) {
      _RoutePhase.showing => copy.memorize,
      _RoutePhase.retrying => copy.error,
      _RoutePhase.transitioning => copy.roundComplete,
      _RoutePhase.solved => copy.complete,
      _RoutePhase.tracing => copy.progress(
          _round + 1,
          _routes.length,
          _trace.length + 1,
          _route.length,
        ),
    };
    return Semantics(
      container: true,
      explicitChildNodes: true,
      liveRegion: true,
      textDirection: semanticDirection,
      label: '${widget.semanticLabel}. ${copy.instruction}. $status',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 252 : 292,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final board = _RouteLayout.board(size);
                final cellSide = board.width / 4;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ExcludeSemantics(
                      child: GestureDetector(
                        key: const ValueKey('route-memory-board'),
                        behavior: HitTestBehavior.opaque,
                        onPanStart: (details) => _start(details, size),
                        onPanUpdate: (details) => _move(details, size),
                        onPanEnd: _end,
                        onPanCancel: () {
                          if (_phase == _RoutePhase.tracing && _dragging) {
                            _retry();
                          }
                        },
                        child: AnimatedBuilder(
                          animation: Listenable.merge(
                            [_ambient, _feedback, _success],
                          ),
                          builder: (context, child) => CustomPaint(
                            key: ValueKey(
                              'route-memory-round-$_round-${_phase.name}-${_trace.length}',
                            ),
                            painter: _RouteMemoryPainter(
                              accent: widget.accent,
                              route: _route,
                              round: _round,
                              roundCount: _routes.length,
                              trace: List<int>.of(_trace),
                              phase: _phase,
                              ambient: _ambient.value,
                              feedback: _feedback.value,
                              success: _success.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_phase == _RoutePhase.tracing)
                      for (var cell = 0; cell < 16; cell++)
                        Positioned(
                          left: board.left + (cell % 4) * cellSide,
                          top: board.top + (cell ~/ 4) * cellSide,
                          width: cellSide,
                          height: cellSide,
                          child: _SemanticsOnlyOverlay(
                            child: Semantics(
                              key: ValueKey('route-semantic-cell-$cell'),
                              button: true,
                              textDirection: semanticDirection,
                              label:
                                  copy.cellLabel(cell ~/ 4 + 1, cell % 4 + 1),
                              hint: copy.cellHint(
                                _trace.length + 1,
                                _route.length,
                              ),
                              onTap: () => _selectCellWithSemantics(cell),
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

class _RouteA11yCopy {
  const _RouteA11yCopy({
    required this.instruction,
    required this.memorize,
    required this.error,
    required this.roundComplete,
    required this.complete,
    required this.progressPattern,
    required this.cellLabelPattern,
    required this.cellHintPattern,
  });

  final String instruction;
  final String memorize;
  final String error;
  final String roundComplete;
  final String complete;
  final String progressPattern;
  final String cellLabelPattern;
  final String cellHintPattern;

  String progress(int round, int rounds, int step, int steps) => progressPattern
      .replaceAll('{round}', '$round')
      .replaceAll('{rounds}', '$rounds')
      .replaceAll('{step}', '$step')
      .replaceAll('{steps}', '$steps');

  String cellLabel(int row, int column) => cellLabelPattern
      .replaceAll('{row}', '$row')
      .replaceAll('{column}', '$column');

  String cellHint(int step, int steps) => cellHintPattern
      .replaceAll('{step}', '$step')
      .replaceAll('{steps}', '$steps');
}

const _routeA11y = <String, _RouteA11yCopy>{
  'ar': _RouteA11yCopy(
    instruction:
        'احفظ المسار المضيء، ثم اتبعه من البداية إلى النهاية. أكمل ثلاث جولات.',
    memorize: 'احفظ المسار المضيء الآن.',
    error: 'خلية غير صحيحة. سيظهر المسار مرة أخرى.',
    roundComplete: 'اكتملت الجولة.',
    complete: 'اكتملت المسارات الثلاثة.',
    progressPattern:
        'الجولة {round} من {rounds}، الخطوة {step} من {steps}. اختر الخلية التالية.',
    cellLabelPattern: 'الصف {row}، العمود {column}',
    cellHintPattern: 'اختر هذه الخلية كالخطوة {step} من {steps}.',
  ),
  'de': _RouteA11yCopy(
    instruction:
        'Merke dir den leuchtenden Weg und folge ihm vom Start bis zum Ziel. Schaffe drei Runden.',
    memorize: 'Merke dir jetzt den leuchtenden Weg.',
    error: 'Falsches Feld. Der Weg wird noch einmal gezeigt.',
    roundComplete: 'Runde geschafft.',
    complete: 'Alle drei Wege sind geschafft.',
    progressPattern:
        'Runde {round} von {rounds}, Schritt {step} von {steps}. Wähle das nächste Feld.',
    cellLabelPattern: 'Zeile {row}, Spalte {column}',
    cellHintPattern: 'Dieses Feld als Schritt {step} von {steps} wählen.',
  ),
  'en': _RouteA11yCopy(
    instruction:
        'Remember the glowing route, then follow it from start to finish. Complete three rounds.',
    memorize: 'Memorize the glowing route now.',
    error: 'Wrong cell. The route will be shown again.',
    roundComplete: 'Round complete.',
    complete: 'All three routes are complete.',
    progressPattern:
        'Round {round} of {rounds}, step {step} of {steps}. Choose the next cell.',
    cellLabelPattern: 'Row {row}, column {column}',
    cellHintPattern: 'Choose this cell as step {step} of {steps}.',
  ),
  'es': _RouteA11yCopy(
    instruction:
        'Recuerda la ruta luminosa y síguela del inicio al final. Completa tres rondas.',
    memorize: 'Memoriza ahora la ruta luminosa.',
    error: 'Casilla incorrecta. La ruta volverá a mostrarse.',
    roundComplete: 'Ronda completada.',
    complete: 'Has completado las tres rutas.',
    progressPattern:
        'Ronda {round} de {rounds}, paso {step} de {steps}. Elige la siguiente casilla.',
    cellLabelPattern: 'Fila {row}, columna {column}',
    cellHintPattern: 'Elige esta casilla como paso {step} de {steps}.',
  ),
  'fr': _RouteA11yCopy(
    instruction:
        'Mémorise le chemin lumineux, puis suis-le du départ à l’arrivée. Termine trois manches.',
    memorize: 'Mémorise maintenant le chemin lumineux.',
    error: 'Mauvaise case. Le chemin va être montré à nouveau.',
    roundComplete: 'Manche terminée.',
    complete: 'Les trois chemins sont terminés.',
    progressPattern:
        'Manche {round} sur {rounds}, étape {step} sur {steps}. Choisis la case suivante.',
    cellLabelPattern: 'Ligne {row}, colonne {column}',
    cellHintPattern: 'Choisis cette case pour l’étape {step} sur {steps}.',
  ),
  'hi': _RouteA11yCopy(
    instruction:
        'चमकता रास्ता याद रखें, फिर शुरुआत से अंत तक उसका अनुसरण करें। तीन दौर पूरे करें।',
    memorize: 'अभी चमकता रास्ता याद करें।',
    error: 'गलत खाना। रास्ता फिर दिखाया जाएगा।',
    roundComplete: 'दौर पूरा हुआ।',
    complete: 'तीनों रास्ते पूरे हुए।',
    progressPattern:
        'दौर {round}, कुल {rounds}; चरण {step}, कुल {steps}। अगला खाना चुनें।',
    cellLabelPattern: 'पंक्ति {row}, स्तंभ {column}',
    cellHintPattern: 'इस खाने को चरण {step}, कुल {steps} के लिए चुनें।',
  ),
  'it': _RouteA11yCopy(
    instruction:
        'Memorizza il percorso luminoso e seguilo dall’inizio alla fine. Completa tre round.',
    memorize: 'Memorizza ora il percorso luminoso.',
    error: 'Casella errata. Il percorso verrà mostrato di nuovo.',
    roundComplete: 'Round completato.',
    complete: 'Hai completato tutti e tre i percorsi.',
    progressPattern:
        'Round {round} di {rounds}, passo {step} di {steps}. Scegli la prossima casella.',
    cellLabelPattern: 'Riga {row}, colonna {column}',
    cellHintPattern: 'Scegli questa casella come passo {step} di {steps}.',
  ),
  'ja': _RouteA11yCopy(
    instruction: '光るルートを覚え、スタートからゴールまでたどりましょう。3ラウンド完成します。',
    memorize: '光るルートを今覚えましょう。',
    error: '間違ったマスです。ルートをもう一度表示します。',
    roundComplete: 'ラウンド完了。',
    complete: '3つのルートをすべて完成しました。',
    progressPattern: '{rounds}ラウンド中{round}、{steps}ステップ中{step}。次のマスを選びましょう。',
    cellLabelPattern: '{row}行{column}列',
    cellHintPattern: '{steps}ステップ中{step}としてこのマスを選びます。',
  ),
  'ko': _RouteA11yCopy(
    instruction: '빛나는 경로를 기억한 뒤 시작점에서 도착점까지 따라가세요. 세 라운드를 완료하세요.',
    memorize: '지금 빛나는 경로를 기억하세요.',
    error: '잘못된 칸입니다. 경로를 다시 보여 드립니다.',
    roundComplete: '라운드 완료.',
    complete: '세 경로를 모두 완료했습니다.',
    progressPattern: '{rounds}라운드 중 {round}, {steps}단계 중 {step}. 다음 칸을 고르세요.',
    cellLabelPattern: '{row}행 {column}열',
    cellHintPattern: '{steps}단계 중 {step}단계로 이 칸을 선택합니다.',
  ),
  'pt': _RouteA11yCopy(
    instruction:
        'Memorize a rota brilhante e siga-a do início ao fim. Complete três rodadas.',
    memorize: 'Memorize agora a rota brilhante.',
    error: 'Célula errada. A rota será mostrada novamente.',
    roundComplete: 'Rodada concluída.',
    complete: 'As três rotas foram concluídas.',
    progressPattern:
        'Rodada {round} de {rounds}, etapa {step} de {steps}. Escolha a próxima célula.',
    cellLabelPattern: 'Linha {row}, coluna {column}',
    cellHintPattern: 'Escolha esta célula como etapa {step} de {steps}.',
  ),
  'ru': _RouteA11yCopy(
    instruction:
        'Запомни светящийся маршрут, затем пройди его от старта до финиша. Заверши три раунда.',
    memorize: 'Сейчас запомни светящийся маршрут.',
    error: 'Неверная клетка. Маршрут будет показан ещё раз.',
    roundComplete: 'Раунд завершён.',
    complete: 'Все три маршрута пройдены.',
    progressPattern:
        'Раунд {round} из {rounds}, шаг {step} из {steps}. Выбери следующую клетку.',
    cellLabelPattern: 'Строка {row}, столбец {column}',
    cellHintPattern: 'Выбрать эту клетку как шаг {step} из {steps}.',
  ),
  'zh': _RouteA11yCopy(
    instruction: '记住发光路线，然后从起点走到终点。完成三个回合。',
    memorize: '现在记住发光路线。',
    error: '单元格错误，路线将再次显示。',
    roundComplete: '本回合完成。',
    complete: '三条路线全部完成。',
    progressPattern:
        '第 {round} 回合，共 {rounds} 回合；第 {step} 步，共 {steps} 步。选择下一个单元格。',
    cellLabelPattern: '第 {row} 行，第 {column} 列',
    cellHintPattern: '将此单元格选为第 {step} 步，共 {steps} 步。',
  ),
};

class _RouteLayout {
  static Rect board(Size size) {
    final side = math.min(size.width * 0.78, size.height * 0.82);
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: side,
      height: side,
    );
  }

  static Offset center(Rect board, int cell) => Offset(
        board.left + (cell % 4 + 0.5) * board.width / 4,
        board.top + (cell ~/ 4 + 0.5) * board.height / 4,
      );
}

class _RouteMemoryPainter extends CustomPainter {
  const _RouteMemoryPainter({
    required this.accent,
    required this.route,
    required this.round,
    required this.roundCount,
    required this.trace,
    required this.phase,
    required this.ambient,
    required this.feedback,
    required this.success,
  });

  final Color accent;
  final List<int> route;
  final int round;
  final int roundCount;
  final List<int> trace;
  final _RoutePhase phase;
  final double ambient;
  final double feedback;
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
          colors: [Color(0xFF13223A), Color(0xFF244C59), Color(0xFF172C45)],
        ).createShader(bounds),
    );
    _drawStars(canvas, size);
    _drawRoundProgress(canvas, size);
    final shake = phase == _RoutePhase.retrying
        ? math.sin(feedback * math.pi * 5) * (1 - feedback) * 4
        : 0.0;
    canvas.save();
    canvas.translate(shake, 0);
    final board = _RouteLayout.board(size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(board, const Radius.circular(18)),
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );
    final gap = math.max(3.0, board.width * 0.018);
    final cellSide = board.width / 4;
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 4; col++) {
        final rect = Rect.fromLTWH(
          board.left + col * cellSide + gap,
          board.top + row * cellSide + gap,
          cellSide - gap * 2,
          cellSide - gap * 2,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(9)),
          Paint()..color = Colors.white.withValues(alpha: 0.075),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(9)),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.13)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }

    final showing = phase == _RoutePhase.showing ||
        phase == _RoutePhase.retrying ||
        phase == _RoutePhase.transitioning;
    final visible = showing ? route : trace;
    final pathColor = phase == _RoutePhase.solved
        ? const Color(0xFF67E6A4)
        : Color.lerp(accent, Colors.white, showing ? 0.22 : 0.05)!;
    if (visible.isNotEmpty) {
      final path = Path()
        ..moveTo(
          _RouteLayout.center(board, visible.first).dx,
          _RouteLayout.center(board, visible.first).dy,
        );
      for (final cell in visible.skip(1)) {
        final point = _RouteLayout.center(board, cell);
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = pathColor.withValues(alpha: 0.38)
          ..style = PaintingStyle.stroke
          ..strokeWidth = cellSide * 0.28
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, cellSide * 0.16),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = pathColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = cellSide * 0.11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    _drawMarker(canvas, board, route.first, const Color(0xFFFFD35A), true);
    _drawMarker(canvas, board, route.last, const Color(0xFF67E6A4), false);
    if (phase == _RoutePhase.solved) _drawSuccess(canvas, board);
    canvas.restore();
  }

  void _drawStars(Canvas canvas, Size size) {
    for (var i = 0; i < 18; i++) {
      final pulse = 0.45 + 0.35 * math.sin(ambient * math.pi * 2 + i);
      canvas.drawCircle(
        Offset(size.width * ((i * 0.173 + 0.04) % 0.94),
            size.height * ((i * 0.263 + 0.06) % 0.88)),
        0.7 + (i % 3) * 0.35,
        Paint()..color = Colors.white.withValues(alpha: pulse),
      );
    }
  }

  void _drawRoundProgress(Canvas canvas, Size size) {
    const spacing = 20.0;
    final startX = size.width / 2 - (roundCount - 1) * spacing / 2;
    for (var index = 0; index < roundCount; index++) {
      final center = Offset(startX + index * spacing, 13);
      canvas.drawCircle(
        center,
        index == round ? 5.5 : 4,
        Paint()
          ..color = index < round
              ? const Color(0xFF67E6A4)
              : index == round
                  ? const Color(0xFFFFD35A)
                  : Colors.white.withValues(alpha: .3),
      );
    }
  }

  void _drawMarker(
    Canvas canvas,
    Rect board,
    int cell,
    Color color,
    bool start,
  ) {
    final center = _RouteLayout.center(board, cell);
    final radius = board.width / 4 * 0.14;
    canvas.drawCircle(
      center,
      radius * 1.8,
      Paint()
        ..color = color.withValues(alpha: 0.22)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius),
    );
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(
      center,
      radius * (start ? 0.38 : 0.52),
      Paint()
        ..color = start ? Colors.white : const Color(0xFF173846)
        ..style = start ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  void _drawSuccess(Canvas canvas, Rect board) {
    final fade = (1 - success).clamp(0.0, 1.0);
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi * 2 / 16;
      final distance = board.width * (0.18 + success * 0.48);
      canvas.drawCircle(
        board.center + Offset(math.cos(angle), math.sin(angle)) * distance,
        (2.5 + i % 3) * fade,
        Paint()
          ..color = (i.isEven ? accent : const Color(0xFFFFD35A))
              .withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RouteMemoryPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.round != round ||
      oldDelegate.phase != phase ||
      oldDelegate.trace.length != trace.length ||
      oldDelegate.ambient != ambient ||
      oldDelegate.feedback != feedback ||
      oldDelegate.success != success;
}
