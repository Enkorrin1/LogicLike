import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const codeGridRoutes = <List<math.Point<int>>>[
  [math.Point(0, 0), math.Point(1, 0), math.Point(1, 1), math.Point(2, 1)],
  [math.Point(5, 0), math.Point(4, 0), math.Point(4, 1), math.Point(3, 1)],
  [math.Point(0, 4), math.Point(1, 4), math.Point(1, 3), math.Point(2, 3)],
];

const codeGridExtractedCode = <int>[6, 8, 3];

const codeGridValues = <List<int>>[
  [0, 2, 7, 5, 2, 1],
  [4, 4, 6, 8, 4, 3],
  [8, 1, 9, 0, 7, 6],
  [2, 5, 3, 1, 9, 4],
  [9, 7, 6, 8, 0, 2],
];

class CodeGridGameView extends StatefulWidget {
  const CodeGridGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
    this.routeGestureKey,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;
  final Key? routeGestureKey;

  @override
  State<CodeGridGameView> createState() => _CodeGridGameViewState();
}

class _CodeGridGameViewState extends State<CodeGridGameView> {
  static const _rules = ['+2', '×2', '−2'];
  static const _keypadValues = [3, 6, 8, 1, 5];

  final List<math.Point<int>> _path = [];
  final List<int> _codeInput = [];
  Timer? _feedbackTimer;
  Timer? _completionTimer;
  int _routeRound = 0;
  int _completedRoutes = 0;
  bool _dragging = false;
  bool _codePhase = false;
  bool _solved = false;
  bool _answerSent = false;
  bool _error = false;
  int _semanticChoice = 0;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _completionTimer?.cancel();
    super.dispose();
  }

  void _start(Offset point, _CodeGridLayout layout) {
    if (_solved || _codePhase) return;
    final cell = layout.cellAt(point);
    final route = codeGridRoutes[_routeRound];
    if (cell != route.first) {
      _fail();
      return;
    }
    _feedbackTimer?.cancel();
    setState(() {
      _dragging = true;
      _path
        ..clear()
        ..add(cell!);
      _error = false;
    });
    HapticFeedback.selectionClick();
  }

  void _move(Offset point, _CodeGridLayout layout) {
    if (!_dragging || _solved || _codePhase) return;
    final cell = layout.cellAt(point);
    if (cell == null || cell == _path.last) return;
    if (_path.length > 1 && cell == _path[_path.length - 2]) {
      setState(() => _path.removeLast());
      return;
    }
    final route = codeGridRoutes[_routeRound];
    final expectedIndex = _path.length;
    if (expectedIndex < route.length && cell == route[expectedIndex]) {
      setState(() => _path.add(cell));
      HapticFeedback.selectionClick();
      return;
    }
    final current = _path.last;
    if ((cell.x - current.x).abs() + (cell.y - current.y).abs() <= 1) {
      _fail();
    }
  }

  void _end() {
    if (!_dragging || _solved || _codePhase) return;
    final route = codeGridRoutes[_routeRound];
    if (_path.length != route.length) {
      _fail();
      return;
    }
    _finishRoute();
  }

  void _finishRoute() {
    HapticFeedback.mediumImpact();
    setState(() {
      _dragging = false;
      _path.clear();
      _completedRoutes++;
      if (_routeRound < codeGridRoutes.length - 1) {
        _routeRound++;
      } else {
        _codePhase = true;
        _semanticChoice = 0;
      }
    });
  }

  void _tapCode(Offset point, _CodeGridLayout layout) {
    if (!_codePhase || _solved) return;
    final keyIndex = layout.keyAt(point);
    if (keyIndex == null) return;
    _selectCodeValue(_keypadValues[keyIndex]);
  }

  void _selectCodeValue(int value) {
    if (!_codePhase || _solved) return;
    final expected = codeGridExtractedCode[_codeInput.length];
    if (value != expected) {
      _fail(clearCode: true);
      return;
    }
    setState(() {
      _error = false;
      _codeInput.add(value);
    });
    HapticFeedback.selectionClick();
    if (_codeInput.length == codeGridExtractedCode.length) _complete();
  }

  void _moveSemanticChoice(int delta) {
    if (_solved) return;
    final count = _codePhase ? _keypadValues.length : 30;
    setState(() => _semanticChoice = (_semanticChoice + delta) % count);
  }

  void _activateSemanticChoice() {
    if (_solved) return;
    if (_codePhase) {
      _selectCodeValue(_keypadValues[_semanticChoice]);
      return;
    }
    final cell = math.Point(_semanticChoice % 6, _semanticChoice ~/ 6);
    final route = codeGridRoutes[_routeRound];
    final expectedIndex = _path.length;
    if (expectedIndex >= route.length || cell != route[expectedIndex]) {
      _fail();
      return;
    }
    setState(() {
      _path.add(cell);
      _error = false;
    });
    HapticFeedback.selectionClick();
    if (_path.length == route.length) _finishRoute();
  }

  void _fail({bool clearCode = false}) {
    if (!mounted || _solved) return;
    _feedbackTimer?.cancel();
    HapticFeedback.lightImpact();
    setState(() {
      _dragging = false;
      _path.clear();
      if (clearCode) _codeInput.clear();
      _error = true;
    });
    _feedbackTimer = Timer(const Duration(milliseconds: 430), () {
      if (mounted && !_solved) setState(() => _error = false);
    });
  }

  void _complete() {
    if (_solved) return;
    setState(() => _solved = true);
    HapticFeedback.mediumImpact();
    _completionTimer = Timer(const Duration(milliseconds: 720), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final copy = _CodeGridA11y.forLocale(Localizations.localeOf(context));
    final semanticValue = _codePhase
        ? copy.codeValue(
            entered: _codeInput.length,
            total: codeGridExtractedCode.length,
            digit: _keypadValues[_semanticChoice],
          )
        : copy.routeValue(
            round: _routeRound + 1,
            total: codeGridRoutes.length,
            rule: _rules[_routeRound],
            row: _semanticChoice ~/ 6 + 1,
            column: _semanticChoice % 6 + 1,
            number: codeGridValues[_semanticChoice ~/ 6][_semanticChoice % 6],
            selected: _path.contains(
              math.Point(_semanticChoice % 6, _semanticChoice ~/ 6),
            ),
          );
    return Semantics(
      key: const ValueKey('code-grid-semantics'),
      label: widget.semanticLabel,
      value: semanticValue,
      hint: _codePhase ? copy.codeHint : copy.routeHint,
      increasedValue: copy.nextChoice,
      decreasedValue: copy.previousChoice,
      onIncrease: _solved ? null : () => _moveSemanticChoice(1),
      onDecrease: _solved ? null : () => _moveSemanticChoice(-1),
      onTap: _solved ? null : _activateSemanticChoice,
      container: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 278 : 318,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _CodeGridLayout(constraints.biggest);
                return GestureDetector(
                  key: widget.routeGestureKey,
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) =>
                      _start(details.localPosition, layout),
                  onPanUpdate: (details) =>
                      _move(details.localPosition, layout),
                  onPanEnd: (_) => _end(),
                  onPanCancel: _end,
                  onTapUp: (details) => _tapCode(details.localPosition, layout),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _error ? 1 : 0),
                    duration: const Duration(milliseconds: 130),
                    builder: (context, shake, child) => Transform.translate(
                      offset: Offset(math.sin(shake * math.pi * 4) * 5, 0),
                      child: child,
                    ),
                    child: CustomPaint(
                      painter: _CodeGridPainter(
                        layout: layout,
                        accent: widget.accent,
                        routeRound: _routeRound,
                        completedRoutes: _completedRoutes,
                        path: List<math.Point<int>>.of(_path),
                        codePhase: _codePhase,
                        codeInput: List<int>.of(_codeInput),
                        solved: _solved,
                        error: _error,
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

class _CodeGridLayout {
  _CodeGridLayout(this.size) {
    const boardHeightFactor = .68;
    final boardHeight = size.height * boardHeightFactor;
    cellSize = math.min((size.width - 60) / 6, (boardHeight - 20) / 5);
    board = Rect.fromLTWH(
      (size.width - cellSize * 6) / 2,
      14,
      cellSize * 6,
      cellSize * 5,
    );
    codeArea = Rect.fromLTWH(
      20,
      board.bottom + 9,
      size.width - 40,
      size.height - board.bottom - 15,
    );
  }

  final Size size;
  late final double cellSize;
  late final Rect board;
  late final Rect codeArea;

  Offset center(math.Point<int> cell) => Offset(
        board.left + (cell.x + .5) * cellSize,
        board.top + (cell.y + .5) * cellSize,
      );

  math.Point<int>? cellAt(Offset point) {
    if (!board.contains(point)) return null;
    final column = ((point.dx - board.left) / cellSize).floor().clamp(0, 5);
    final row = ((point.dy - board.top) / cellSize).floor().clamp(0, 4);
    return math.Point(column, row);
  }

  Rect keyRect(int index) {
    const gap = 6.0;
    final width = (codeArea.width - gap * 4) / 5;
    return Rect.fromLTWH(
      codeArea.left + index * (width + gap),
      codeArea.top + 4,
      width,
      codeArea.height - 8,
    );
  }

  int? keyAt(Offset point) {
    for (var index = 0; index < 5; index++) {
      if (keyRect(index).contains(point)) return index;
    }
    return null;
  }
}

class _CodeGridPainter extends CustomPainter {
  const _CodeGridPainter({
    required this.layout,
    required this.accent,
    required this.routeRound,
    required this.completedRoutes,
    required this.path,
    required this.codePhase,
    required this.codeInput,
    required this.solved,
    required this.error,
  });

  final _CodeGridLayout layout;
  final Color accent;
  final int routeRound;
  final int completedRoutes;
  final List<math.Point<int>> path;
  final bool codePhase;
  final List<int> codeInput;
  final bool solved;
  final bool error;

  static const _rules = ['+2', '×2', '−2'];
  static const _keypadValues = [3, 6, 8, 1, 5];
  static const _routeColors = [
    Color(0xFFFFC857),
    Color(0xFF65D6B4),
    Color(0xFF8AA4FF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF18284E), Color(0xFF086C77)],
        ).createShader(bounds),
    );
    for (var index = 0; index < completedRoutes; index++) {
      _paintRoute(canvas, codeGridRoutes[index], _routeColors[index], .27);
    }
    if (path.length > 1) {
      _paintRoute(
        canvas,
        path,
        error ? const Color(0xFFFF6E75) : _routeColors[routeRound],
        .24,
      );
    }
    final completedCells = <math.Point<int>>{
      for (var index = 0; index < completedRoutes; index++)
        ...codeGridRoutes[index],
    };
    for (var row = 0; row < 5; row++) {
      for (var column = 0; column < 6; column++) {
        final cell = math.Point(column, row);
        final rect = Rect.fromCenter(
          center: layout.center(cell),
          width: layout.cellSize - 6,
          height: layout.cellSize - 6,
        );
        final active = path.contains(cell);
        final complete = completedCells.contains(cell);
        final start = !codePhase && cell == codeGridRoutes[routeRound].first;
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(9)),
          Paint()
            ..color = active
                ? _routeColors[routeRound]
                : complete
                    ? const Color(0xFF225F6B)
                    : start
                        ? accent.withValues(alpha: .72)
                        : Colors.white.withValues(alpha: .10),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(9)),
          Paint()
            ..color = start
                ? Colors.white
                : Colors.white.withValues(alpha: complete ? .35 : .16)
            ..strokeWidth = start ? 2 : 1
            ..style = PaintingStyle.stroke,
        );
        _text(
          canvas,
          '${codeGridValues[row][column]}',
          rect.center,
          layout.cellSize * .31,
          Colors.white,
        );
      }
    }
    _paintFooter(canvas);
  }

  void _paintFooter(Canvas canvas) {
    if (!codePhase) {
      final rect = layout.codeArea.deflate(4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(14)),
        Paint()..color = Colors.white.withValues(alpha: .12),
      );
      _text(
        canvas,
        '${routeRound + 1}/3   ${_rules[routeRound]}   →   ?',
        rect.center,
        math.min(22, rect.height * .42),
        Colors.white,
      );
      return;
    }
    for (var index = 0; index < _keypadValues.length; index++) {
      final rect = layout.keyRect(index);
      final value = _keypadValues[index];
      final entered = codeInput.contains(value) && value != 8 ||
          value == 8 && codeInput.where((item) => item == 8).isNotEmpty;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        Paint()
          ..color = solved
              ? const Color(0xFF5ED29F)
              : entered
                  ? accent.withValues(alpha: .72)
                  : Colors.white.withValues(alpha: .14),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        Paint()
          ..color = Colors.white.withValues(alpha: .34)
          ..style = PaintingStyle.stroke,
      );
      _text(canvas, '$value', rect.center, 20, Colors.white);
    }
    for (var index = 0; index < codeGridExtractedCode.length; index++) {
      final center = Offset(layout.codeArea.center.dx + (index - 1) * 18, 8);
      canvas.drawCircle(
        center,
        3,
        Paint()
          ..color = index < codeInput.length
              ? const Color(0xFF67E0B2)
              : Colors.white.withValues(alpha: .35),
      );
    }
  }

  void _paintRoute(
    Canvas canvas,
    List<math.Point<int>> route,
    Color color,
    double widthFactor,
  ) {
    final beam = Path()
      ..moveTo(layout.center(route.first).dx, layout.center(route.first).dy);
    for (final cell in route.skip(1)) {
      beam.lineTo(layout.center(cell).dx, layout.center(cell).dy);
    }
    canvas.drawPath(
      beam,
      Paint()
        ..color = color.withValues(alpha: .66)
        ..style = PaintingStyle.stroke
        ..strokeWidth = layout.cellSize * widthFactor
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _text(
    Canvas canvas,
    String value,
    Offset center,
    double size,
    Color color,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CodeGridPainter oldDelegate) =>
      oldDelegate.routeRound != routeRound ||
      oldDelegate.completedRoutes != completedRoutes ||
      oldDelegate.path.length != path.length ||
      oldDelegate.codePhase != codePhase ||
      oldDelegate.codeInput.length != codeInput.length ||
      oldDelegate.solved != solved ||
      oldDelegate.error != error ||
      oldDelegate.accent != accent;
}

class _CodeGridA11y {
  const _CodeGridA11y({
    required this.route,
    required this.of,
    required this.rule,
    required this.row,
    required this.column,
    required this.number,
    required this.selected,
    required this.code,
    required this.entered,
    required this.digit,
    required this.routeHint,
    required this.codeHint,
    required this.nextChoice,
    required this.previousChoice,
  });

  final String route;
  final String of;
  final String rule;
  final String row;
  final String column;
  final String number;
  final String selected;
  final String code;
  final String entered;
  final String digit;
  final String routeHint;
  final String codeHint;
  final String nextChoice;
  final String previousChoice;

  String routeValue(
          {required int round,
          required int total,
          required String rule,
          required int row,
          required int column,
          required int number,
          required bool selected}) =>
      '$route $round $of $total, ${this.rule} $rule, ${this.row} $row, ${this.column} $column, ${this.number} $number${selected ? ', ${this.selected}' : ''}';

  String codeValue(
          {required int entered, required int total, required int digit}) =>
      '$code, ${this.entered} $entered $of $total, ${this.digit} $digit';

  static _CodeGridA11y forLocale(Locale locale) =>
      _copies[locale.languageCode] ?? _copies['en']!;

  static const _copies = <String, _CodeGridA11y>{
    'ar': _CodeGridA11y(
        route: 'المسار',
        of: 'من',
        rule: 'القاعدة',
        row: 'صف',
        column: 'عمود',
        number: 'الرقم',
        selected: 'محدد في المسار',
        code: 'الرمز',
        entered: 'تم إدخال',
        digit: 'الرقم المختار',
        routeHint:
            'اسحب لأعلى أو لأسفل لاستكشاف الخلايا، ثم انقر مرتين لاختيار الخلية التالية في المسار',
        codeHint: 'استكشف الأرقام ثم انقر مرتين لإدخال الرقم التالي من الرمز',
        nextChoice: 'الخيار التالي',
        previousChoice: 'الخيار السابق'),
    'de': _CodeGridA11y(
        route: 'Route',
        of: 'von',
        rule: 'Regel',
        row: 'Zeile',
        column: 'Spalte',
        number: 'Zahl',
        selected: 'im Pfad gewählt',
        code: 'Code',
        entered: 'Eingegeben',
        digit: 'gewählte Ziffer',
        routeHint:
            'Nach oben oder unten wischen, um Felder zu erkunden, dann doppeltippen, um das nächste Feld der Route zu wählen',
        codeHint:
            'Ziffern erkunden und doppeltippen, um die nächste Codeziffer einzugeben',
        nextChoice: 'Nächste Auswahl',
        previousChoice: 'Vorherige Auswahl'),
    'en': _CodeGridA11y(
        route: 'Route',
        of: 'of',
        rule: 'rule',
        row: 'row',
        column: 'column',
        number: 'number',
        selected: 'selected in route',
        code: 'Code',
        entered: 'entered',
        digit: 'selected digit',
        routeHint:
            'Swipe up or down to explore cells, then double tap to choose the next cell in the route',
        codeHint:
            'Explore digits, then double tap to enter the next code digit',
        nextChoice: 'Next choice',
        previousChoice: 'Previous choice'),
    'es': _CodeGridA11y(
        route: 'Ruta',
        of: 'de',
        rule: 'regla',
        row: 'fila',
        column: 'columna',
        number: 'número',
        selected: 'seleccionada en la ruta',
        code: 'Código',
        entered: 'introducidos',
        digit: 'dígito elegido',
        routeHint:
            'Desliza arriba o abajo para explorar casillas y toca dos veces para elegir la siguiente casilla de la ruta',
        codeHint:
            'Explora los dígitos y toca dos veces para introducir el siguiente',
        nextChoice: 'Siguiente opción',
        previousChoice: 'Opción anterior'),
    'fr': _CodeGridA11y(
        route: 'Parcours',
        of: 'sur',
        rule: 'règle',
        row: 'ligne',
        column: 'colonne',
        number: 'nombre',
        selected: 'sélectionnée dans le parcours',
        code: 'Code',
        entered: 'saisis',
        digit: 'chiffre choisi',
        routeHint:
            'Balaye vers le haut ou le bas pour explorer les cases, puis touche deux fois pour choisir la prochaine case',
        codeHint:
            'Explore les chiffres, puis touche deux fois pour saisir le prochain chiffre du code',
        nextChoice: 'Choix suivant',
        previousChoice: 'Choix précédent'),
    'hi': _CodeGridA11y(
        route: 'रास्ता',
        of: 'में से',
        rule: 'नियम',
        row: 'पंक्ति',
        column: 'स्तंभ',
        number: 'संख्या',
        selected: 'रास्ते में चुना गया',
        code: 'कोड',
        entered: 'दर्ज',
        digit: 'चुना अंक',
        routeHint:
            'खाने देखने के लिए ऊपर या नीचे स्वाइप करें, फिर रास्ते का अगला खाना चुनने के लिए दो बार टैप करें',
        codeHint: 'अंक देखें और अगला कोड अंक डालने के लिए दो बार टैप करें',
        nextChoice: 'अगला विकल्प',
        previousChoice: 'पिछला विकल्प'),
    'it': _CodeGridA11y(
        route: 'Percorso',
        of: 'di',
        rule: 'regola',
        row: 'riga',
        column: 'colonna',
        number: 'numero',
        selected: 'selezionata nel percorso',
        code: 'Codice',
        entered: 'inserite',
        digit: 'cifra scelta',
        routeHint:
            'Scorri in alto o in basso per esplorare le caselle, poi tocca due volte per scegliere la prossima casella',
        codeHint:
            'Esplora le cifre e tocca due volte per inserire la prossima cifra',
        nextChoice: 'Scelta successiva',
        previousChoice: 'Scelta precedente'),
    'ja': _CodeGridA11y(
        route: 'ルート',
        of: '/',
        rule: 'ルール',
        row: '行',
        column: '列',
        number: '数字',
        selected: 'ルートで選択済み',
        code: 'コード',
        entered: '入力済み',
        digit: '選択中の数字',
        routeHint: '上下にスワイプしてマスを探し、ダブルタップでルートの次のマスを選びます',
        codeHint: '数字を探し、ダブルタップで次のコードを入力します',
        nextChoice: '次の選択肢',
        previousChoice: '前の選択肢'),
    'ko': _CodeGridA11y(
        route: '경로',
        of: '/',
        rule: '규칙',
        row: '행',
        column: '열',
        number: '숫자',
        selected: '경로에서 선택됨',
        code: '코드',
        entered: '입력됨',
        digit: '선택한 숫자',
        routeHint: '위아래로 쓸어 칸을 탐색하고 두 번 탭하여 경로의 다음 칸을 선택하세요',
        codeHint: '숫자를 탐색하고 두 번 탭하여 다음 코드 숫자를 입력하세요',
        nextChoice: '다음 선택',
        previousChoice: '이전 선택'),
    'pt': _CodeGridA11y(
        route: 'Rota',
        of: 'de',
        rule: 'regra',
        row: 'linha',
        column: 'coluna',
        number: 'número',
        selected: 'selecionada na rota',
        code: 'Código',
        entered: 'inseridos',
        digit: 'dígito escolhido',
        routeHint:
            'Deslize para cima ou para baixo para explorar células e toque duas vezes para escolher a próxima da rota',
        codeHint:
            'Explore os dígitos e toque duas vezes para inserir o próximo dígito',
        nextChoice: 'Próxima opção',
        previousChoice: 'Opção anterior'),
    'ru': _CodeGridA11y(
        route: 'Маршрут',
        of: 'из',
        rule: 'правило',
        row: 'ряд',
        column: 'столбец',
        number: 'число',
        selected: 'выбрана в маршруте',
        code: 'Код',
        entered: 'введено',
        digit: 'выбранная цифра',
        routeHint:
            'Смахивайте вверх или вниз, чтобы изучать клетки, затем дважды нажмите, чтобы выбрать следующую клетку маршрута',
        codeHint:
            'Изучайте цифры и дважды нажмите, чтобы ввести следующую цифру кода',
        nextChoice: 'Следующий вариант',
        previousChoice: 'Предыдущий вариант'),
    'zh': _CodeGridA11y(
        route: '路径',
        of: '/',
        rule: '规则',
        row: '行',
        column: '列',
        number: '数字',
        selected: '已加入路径',
        code: '密码',
        entered: '已输入',
        digit: '所选数字',
        routeHint: '上下滑动浏览方格，双击选择路径中的下一个方格',
        codeHint: '浏览数字，双击输入下一位密码',
        nextChoice: '下一个选项',
        previousChoice: '上一个选项'),
  };
}
