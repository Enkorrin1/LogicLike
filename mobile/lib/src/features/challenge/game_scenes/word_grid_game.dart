import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Set<String> get wordGridSupportedLanguageCodes =>
    _WordGridData.localized.keys.toSet();

List<List<int>> wordGridRoutesForLanguageCode(String languageCode) =>
    _WordGridData.forLanguageCode(languageCode)
        .routes
        .map(List<int>.of)
        .toList(growable: false);

class WordGridGameView extends StatefulWidget {
  const WordGridGameView({
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
  State<WordGridGameView> createState() => _WordGridGameViewState();
}

class _WordGridGameViewState extends State<WordGridGameView>
    with SingleTickerProviderStateMixin {
  final List<int> _path = [];
  final Set<int> _foundWords = {};
  late final AnimationController _pulse;
  Timer? _feedbackTimer;
  Timer? _completionTimer;
  String? _languageCode;
  int _errorCell = -1;
  int _semanticCell = 0;
  bool _error = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void didUpdateWidget(covariant WordGridGameView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.semanticLabel != widget.semanticLabel) _reset();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_languageCode != null && _languageCode != languageCode) _reset();
    _languageCode = languageCode;
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    _completionTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _reset() {
    _feedbackTimer?.cancel();
    _completionTimer?.cancel();
    _pulse.stop();
    _path.clear();
    _foundWords.clear();
    _errorCell = -1;
    _error = false;
    _answerSent = false;
  }

  void _start(Offset position, _WordGridLayout layout) {
    if (_answerSent || _foundWords.length == 3) return;
    final cell = layout.cellAt(position);
    if (cell == null) return;
    _feedbackTimer?.cancel();
    setState(() {
      _path
        ..clear()
        ..add(cell);
      _errorCell = -1;
      _error = false;
    });
    HapticFeedback.selectionClick();
  }

  void _drag(Offset position, _WordGridLayout layout) {
    if (_path.isEmpty || _foundWords.length == 3) return;
    final cell = layout.cellAt(position);
    if (cell == null || cell == _path.last) return;
    if (_path.length > 1 && cell == _path[_path.length - 2]) {
      setState(() => _path.removeLast());
      return;
    }
    if (!_neighbors(_path.last, cell) || _path.contains(cell)) {
      _fail(cell);
      return;
    }
    setState(() => _path.add(cell));
    HapticFeedback.selectionClick();
  }

  void _end(_WordGridData data) {
    if (_path.isEmpty || _error || _foundWords.length == 3) return;
    final match = _matchingWord(data.routes, _path);
    if (match == null || _foundWords.contains(match)) {
      _fail(_path.last);
      return;
    }
    setState(() {
      _foundWords.add(match);
      _path.clear();
    });
    HapticFeedback.mediumImpact();
    _pulse.forward(from: 0);
    if (_foundWords.length == data.words.length) _complete();
  }

  int? _matchingWord(List<List<int>> routes, List<int> path) {
    for (var index = 0; index < routes.length; index++) {
      final route = routes[index];
      if (_same(path, route) || _same(path, route.reversed.toList())) {
        return index;
      }
    }
    return null;
  }

  bool _same(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  bool _neighbors(int a, int b) {
    final rowDistance = (a ~/ 5 - b ~/ 5).abs();
    final columnDistance = (a % 5 - b % 5).abs();
    return rowDistance + columnDistance == 1;
  }

  void _fail(int cell) {
    if (!mounted) return;
    _feedbackTimer?.cancel();
    HapticFeedback.lightImpact();
    setState(() {
      _path.clear();
      _errorCell = cell;
      _error = true;
    });
    _feedbackTimer = Timer(const Duration(milliseconds: 430), () {
      if (!mounted || _foundWords.length == 3) return;
      setState(() {
        _errorCell = -1;
        _error = false;
      });
    });
  }

  void _complete() {
    _feedbackTimer?.cancel();
    _pulse.repeat(reverse: true);
    _completionTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      _pulse.stop();
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  void _moveSemanticCursor(int delta) {
    if (_answerSent) return;
    setState(() => _semanticCell = (_semanticCell + delta) % 25);
  }

  void _activateSemanticCell(_WordGridData data) {
    if (_answerSent || _foundWords.length == data.words.length) return;
    final candidate = [..._path, _semanticCell];
    if (_path.isNotEmpty &&
        _path.length > 1 &&
        _semanticCell == _path[_path.length - 2]) {
      setState(() => _path.removeLast());
      return;
    }
    if (_path.contains(_semanticCell) ||
        (_path.isNotEmpty && !_neighbors(_path.last, _semanticCell)) ||
        !_isRemainingRoutePrefix(data, candidate)) {
      _fail(_semanticCell);
      return;
    }
    setState(() {
      _path.add(_semanticCell);
      _error = false;
      _errorCell = -1;
    });
    HapticFeedback.selectionClick();
    if (_matchingWord(data.routes, _path) != null) _end(data);
  }

  bool _isRemainingRoutePrefix(_WordGridData data, List<int> candidate) {
    for (var index = 0; index < data.routes.length; index++) {
      if (_foundWords.contains(index)) continue;
      final route = data.routes[index];
      if (_isPrefix(candidate, route) ||
          _isPrefix(candidate, route.reversed.toList())) {
        return true;
      }
    }
    return false;
  }

  bool _isPrefix(List<int> candidate, List<int> route) {
    if (candidate.length > route.length) return false;
    for (var index = 0; index < candidate.length; index++) {
      if (candidate[index] != route[index]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final data = _WordGridData.forLocale(Localizations.localeOf(context));
    final a11y = _WordGridA11y.forLocale(Localizations.localeOf(context));
    final row = _semanticCell ~/ 5 + 1;
    final column = _semanticCell % 5 + 1;
    final cellValue = a11y.cellValue(
      row: row,
      column: column,
      letter: data.grid[_semanticCell],
      selected: _path.contains(_semanticCell),
    );
    return Semantics(
      key: const ValueKey('word-grid-semantics'),
      container: true,
      explicitChildNodes: true,
      label: widget.semanticLabel,
      value:
          '${a11y.progress(_foundWords.length, data.words.length)}. $cellValue',
      hint: '${data.semanticHint}. ${a11y.navigationHint}',
      increasedValue: a11y.nextCell,
      decreasedValue: a11y.previousCell,
      onIncrease: _answerSent ? null : () => _moveSemanticCursor(1),
      onDecrease: _answerSent ? null : () => _moveSemanticCursor(-1),
      onTap: _answerSent ? null : () => _activateSemanticCell(data),
      child: Directionality(
        textDirection: data.rtl ? TextDirection.rtl : TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 276 : 316,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _WordGridLayout(
                  constraints.biggest,
                  compact: widget.compact,
                );
                return AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) => GestureDetector(
                    key: widget.routeGestureKey,
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) =>
                        _start(details.localPosition, layout),
                    onPanUpdate: (details) =>
                        _drag(details.localPosition, layout),
                    onPanEnd: (_) => _end(data),
                    onPanCancel: () => _end(data),
                    child: CustomPaint(
                      painter: _WordGridPainter(
                        accent: widget.accent,
                        data: data,
                        layout: layout,
                        path: List<int>.of(_path),
                        foundWords: Set<int>.of(_foundWords),
                        errorCell: _errorCell,
                        error: _error,
                        pulse: _pulse.value,
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

class _WordGridA11y {
  const _WordGridA11y({
    required this.found,
    required this.of,
    required this.cell,
    required this.row,
    required this.column,
    required this.letter,
    required this.selected,
    required this.navigationHint,
    required this.nextCell,
    required this.previousCell,
  });

  final String found;
  final String of;
  final String cell;
  final String row;
  final String column;
  final String letter;
  final String selected;
  final String navigationHint;
  final String nextCell;
  final String previousCell;

  String progress(int current, int total) => '$found $current $of $total';

  String cellValue({
    required int row,
    required int column,
    required String letter,
    required bool selected,
  }) =>
      '$cell, ${this.row} $row, ${this.column} $column, ${this.letter} $letter${selected ? ', ${this.selected}' : ''}';

  static _WordGridA11y forLocale(Locale locale) =>
      _copies[locale.languageCode] ?? _copies['en']!;

  static const _copies = <String, _WordGridA11y>{
    'ar': _WordGridA11y(
        found: 'تم العثور على',
        of: 'من',
        cell: 'خلية',
        row: 'صف',
        column: 'عمود',
        letter: 'حرف',
        selected: 'محددة في المسار',
        navigationHint:
            'اسحب لأعلى أو لأسفل لاستكشاف الخلايا، ثم انقر مرتين لإضافتها إلى المسار',
        nextCell: 'الخلية التالية',
        previousCell: 'الخلية السابقة'),
    'de': _WordGridA11y(
        found: 'Gefunden',
        of: 'von',
        cell: 'Feld',
        row: 'Zeile',
        column: 'Spalte',
        letter: 'Buchstabe',
        selected: 'im Pfad gewählt',
        navigationHint:
            'Nach oben oder unten wischen, um Felder zu erkunden, dann doppeltippen, um sie zum Pfad hinzuzufügen',
        nextCell: 'Nächstes Feld',
        previousCell: 'Vorheriges Feld'),
    'en': _WordGridA11y(
        found: 'Found',
        of: 'of',
        cell: 'Cell',
        row: 'row',
        column: 'column',
        letter: 'letter',
        selected: 'selected in path',
        navigationHint:
            'Swipe up or down to explore cells, then double tap to add one to the path',
        nextCell: 'Next cell',
        previousCell: 'Previous cell'),
    'es': _WordGridA11y(
        found: 'Encontradas',
        of: 'de',
        cell: 'Casilla',
        row: 'fila',
        column: 'columna',
        letter: 'letra',
        selected: 'seleccionada en la ruta',
        navigationHint:
            'Desliza arriba o abajo para explorar casillas y toca dos veces para añadir una a la ruta',
        nextCell: 'Casilla siguiente',
        previousCell: 'Casilla anterior'),
    'fr': _WordGridA11y(
        found: 'Trouvés',
        of: 'sur',
        cell: 'Case',
        row: 'ligne',
        column: 'colonne',
        letter: 'lettre',
        selected: 'sélectionnée dans le tracé',
        navigationHint:
            'Balaye vers le haut ou le bas pour explorer les cases, puis touche deux fois pour en ajouter une au tracé',
        nextCell: 'Case suivante',
        previousCell: 'Case précédente'),
    'hi': _WordGridA11y(
        found: 'मिले',
        of: 'में से',
        cell: 'खाना',
        row: 'पंक्ति',
        column: 'स्तंभ',
        letter: 'अक्षर',
        selected: 'रास्ते में चुना गया',
        navigationHint:
            'खाने देखने के लिए ऊपर या नीचे स्वाइप करें, फिर रास्ते में जोड़ने के लिए दो बार टैप करें',
        nextCell: 'अगला खाना',
        previousCell: 'पिछला खाना'),
    'it': _WordGridA11y(
        found: 'Trovate',
        of: 'su',
        cell: 'Casella',
        row: 'riga',
        column: 'colonna',
        letter: 'lettera',
        selected: 'selezionata nel percorso',
        navigationHint:
            'Scorri in alto o in basso per esplorare le caselle, poi tocca due volte per aggiungerne una al percorso',
        nextCell: 'Casella successiva',
        previousCell: 'Casella precedente'),
    'ja': _WordGridA11y(
        found: '見つけた単語',
        of: '/',
        cell: 'マス',
        row: '行',
        column: '列',
        letter: '文字',
        selected: '経路で選択済み',
        navigationHint: '上下にスワイプしてマスを探し、ダブルタップで経路に追加します',
        nextCell: '次のマス',
        previousCell: '前のマス'),
    'ko': _WordGridA11y(
        found: '찾은 단어',
        of: '/',
        cell: '칸',
        row: '행',
        column: '열',
        letter: '글자',
        selected: '경로에서 선택됨',
        navigationHint: '위아래로 쓸어 칸을 탐색하고 두 번 탭하여 경로에 추가하세요',
        nextCell: '다음 칸',
        previousCell: '이전 칸'),
    'pt': _WordGridA11y(
        found: 'Encontradas',
        of: 'de',
        cell: 'Célula',
        row: 'linha',
        column: 'coluna',
        letter: 'letra',
        selected: 'selecionada no caminho',
        navigationHint:
            'Deslize para cima ou para baixo para explorar células e toque duas vezes para adicionar uma ao caminho',
        nextCell: 'Próxima célula',
        previousCell: 'Célula anterior'),
    'ru': _WordGridA11y(
        found: 'Найдено',
        of: 'из',
        cell: 'Клетка',
        row: 'ряд',
        column: 'столбец',
        letter: 'буква',
        selected: 'выбрана в маршруте',
        navigationHint:
            'Смахивайте вверх или вниз, чтобы изучать клетки, затем дважды нажмите, чтобы добавить клетку в маршрут',
        nextCell: 'Следующая клетка',
        previousCell: 'Предыдущая клетка'),
    'zh': _WordGridA11y(
        found: '已找到',
        of: '/',
        cell: '方格',
        row: '行',
        column: '列',
        letter: '字母',
        selected: '已加入路径',
        navigationHint: '上下滑动浏览方格，双击将方格加入路径',
        nextCell: '下一个方格',
        previousCell: '上一个方格'),
  };
}

class _WordGridLayout {
  _WordGridLayout(this.size, {required this.compact}) {
    final headerHeight = compact ? 59.0 : 68.0;
    final available =
        math.min(size.width - 26, size.height - headerHeight - 14);
    boardSize = math.min(available, compact ? 195.0 : 224.0);
    board = Rect.fromLTWH(
      (size.width - boardSize) / 2,
      headerHeight + 5,
      boardSize,
      boardSize,
    );
    cellSize = boardSize / 5;
  }

  final Size size;
  final bool compact;
  late final Rect board;
  late final double boardSize;
  late final double cellSize;

  Rect cellRect(int index) => Rect.fromLTWH(
        board.left + (index % 5) * cellSize,
        board.top + (index ~/ 5) * cellSize,
        cellSize,
        cellSize,
      );

  Offset center(int index) => cellRect(index).center;

  int? cellAt(Offset point) {
    if (!board.contains(point)) return null;
    final column = ((point.dx - board.left) / cellSize).floor().clamp(0, 4);
    final row = ((point.dy - board.top) / cellSize).floor().clamp(0, 4);
    return row * 5 + column;
  }
}

class _WordGridPainter extends CustomPainter {
  const _WordGridPainter({
    required this.accent,
    required this.data,
    required this.layout,
    required this.path,
    required this.foundWords,
    required this.errorCell,
    required this.error,
    required this.pulse,
  });

  final Color accent;
  final _WordGridData data;
  final _WordGridLayout layout;
  final List<int> path;
  final Set<int> foundWords;
  final int errorCell;
  final bool error;
  final double pulse;

  static const _routeColors = [
    Color(0xFF24AF9B),
    Color(0xFF6C83F7),
    Color(0xFFFFA34E),
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
          colors: [Color(0xFFF2FCFA), Color(0xFFF7F4FF)],
        ).createShader(bounds),
    );
    _paintWordChips(canvas, size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        layout.board.inflate(6),
        const Radius.circular(19),
      ),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    for (final wordIndex in foundWords) {
      _paintRoute(canvas, data.routes[wordIndex], _routeColors[wordIndex], .28);
    }
    if (path.length > 1) {
      _paintRoute(
        canvas,
        path,
        error ? const Color(0xFFE85D68) : accent,
        .25,
      );
    }
    final foundCells = <int>{
      for (final wordIndex in foundWords) ...data.routes[wordIndex],
    };
    for (var index = 0; index < 25; index++) {
      final rect = layout.cellRect(index).deflate(layout.compact ? 2.8 : 3.8);
      final active = path.contains(index);
      final found = foundCells.contains(index);
      final failed = errorCell == index;
      final scale = foundWords.length == 3 ? 1 + pulse * .035 : 1.0;
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.scale(scale);
      canvas.translate(-rect.center.dx, -rect.center.dy);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()
          ..color = failed
              ? const Color(0xFFFFDADC)
              : active
                  ? accent.withValues(alpha: .88)
                  : found
                      ? const Color(0xFFDDF8F2)
                      : const Color(0xFFF0F4F7),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()
          ..color = failed
              ? const Color(0xFFE85D68)
              : active
                  ? accent
                  : found
                      ? const Color(0xFF7ACDBE)
                      : const Color(0xFFD9E2E8)
          ..strokeWidth = active || failed ? 2.2 : 1.0
          ..style = PaintingStyle.stroke,
      );
      _text(
        canvas,
        data.grid[index],
        rect.center,
        layout.compact ? 16 : 19,
        active ? Colors.white : const Color(0xFF263847),
      );
      canvas.restore();
    }
  }

  void _paintRoute(
    Canvas canvas,
    List<int> route,
    Color color,
    double widthFactor,
  ) {
    if (route.length < 2) return;
    final line = Path()
      ..moveTo(layout.center(route.first).dx, layout.center(route.first).dy);
    for (final cell in route.skip(1)) {
      line.lineTo(layout.center(cell).dx, layout.center(cell).dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = color.withValues(alpha: .42)
        ..strokeWidth = layout.cellSize * widthFactor
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  void _paintWordChips(Canvas canvas, Size size) {
    final chipWidth = math.min((size.width - 36) / 3, 120.0);
    final totalWidth = chipWidth * 3 + 12;
    final start = (size.width - totalWidth) / 2;
    final order = data.rtl ? const [2, 1, 0] : const [0, 1, 2];
    for (var position = 0; position < order.length; position++) {
      final index = order[position];
      final found = foundWords.contains(index);
      final rect = Rect.fromLTWH(
        start + position * (chipWidth + 6),
        layout.compact ? 10 : 12,
        chipWidth,
        layout.compact ? 39 : 45,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(13)),
        Paint()..color = found ? _routeColors[index] : Colors.white,
      );
      _text(
        canvas,
        data.words[index].join(),
        rect.center,
        layout.compact ? 13 : 15,
        found ? Colors.white : const Color(0xFF405260),
      );
      if (found) {
        canvas.drawCircle(
          Offset(rect.right - 11, rect.top + 10),
          4,
          Paint()..color = Colors.white,
        );
      }
    }
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
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      textDirection: data.rtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    )..layout(maxWidth: layout.cellSize * 2.4);
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _WordGridPainter oldDelegate) =>
      oldDelegate.path.length != path.length ||
      oldDelegate.foundWords.length != foundWords.length ||
      oldDelegate.errorCell != errorCell ||
      oldDelegate.error != error ||
      oldDelegate.pulse != pulse ||
      oldDelegate.accent != accent ||
      oldDelegate.data != data;
}

class _WordGridData {
  const _WordGridData({
    required this.words,
    required this.fillers,
    required this.semanticHint,
    this.rtl = false,
  });

  final List<List<String>> words;
  final List<String> fillers;
  final String semanticHint;
  final bool rtl;

  List<List<int>> get routes {
    final first = List<int>.generate(words[0].length, (index) => index);
    final second = List<int>.generate(
      words[1].length,
      (index) => first.last + index * 5,
    );
    final secondEnd = second.last;
    final direction = secondEnd % 5 <= 2 ? 1 : -1;
    final third = List<int>.generate(
      words[2].length,
      (index) => secondEnd + index * direction,
    );
    return [first, second, third];
  }

  List<String> get grid {
    final result = List<String>.generate(
      25,
      (index) => fillers[index % fillers.length],
    );
    final paths = routes;
    for (var wordIndex = 0; wordIndex < words.length; wordIndex++) {
      for (var index = 0; index < words[wordIndex].length; index++) {
        result[paths[wordIndex][index]] = words[wordIndex][index];
      }
    }
    return result;
  }

  static _WordGridData forLocale(Locale locale) =>
      forLanguageCode(locale.languageCode);

  static _WordGridData forLanguageCode(String languageCode) =>
      localized[languageCode] ?? localized['en']!;

  static const localized = <String, _WordGridData>{
    'ar': _WordGridData(
      words: [
        ['ق', 'م', 'ر'],
        ['ر', 'ب', 'ي', 'ع'],
        ['ع', 'س', 'ل'],
      ],
      fillers: ['ن', 'و', 'ت', 'ك', 'د', 'ه', 'ج'],
      semanticHint:
          'اعثر على الكلمات الثلاث بتمرير إصبعك بين الخلايا المتجاورة',
      rtl: true,
    ),
    'de': _WordGridData(
      words: [
        ['E', 'I', 'S'],
        ['S', 'T', 'E', 'R', 'N'],
        ['N', 'E', 'U'],
      ],
      fillers: ['A', 'O', 'L', 'M', 'K', 'B', 'D'],
      semanticHint: 'Finde alle drei Wörter in benachbarten Feldern',
    ),
    'en': _WordGridData(
      words: [
        ['C', 'A', 'T'],
        ['T', 'I', 'G', 'E', 'R'],
        ['R', 'E', 'D'],
      ],
      fillers: ['O', 'N', 'S', 'L', 'M', 'P', 'B'],
      semanticHint: 'Find all three words by tracing adjacent cells',
    ),
    'es': _WordGridData(
      words: [
        ['S', 'O', 'L'],
        ['L', 'I', 'B', 'R', 'O'],
        ['O', 'R', 'O'],
      ],
      fillers: ['A', 'E', 'N', 'M', 'P', 'C', 'D'],
      semanticHint: 'Encuentra las tres palabras uniendo casillas vecinas',
    ),
    'fr': _WordGridData(
      words: [
        ['L', 'A', 'C'],
        ['C', 'H', 'I', 'E', 'N'],
        ['N', 'E', 'Z'],
      ],
      fillers: ['O', 'U', 'R', 'M', 'P', 'B', 'D'],
      semanticHint: 'Trouve les trois mots en reliant les cases voisines',
    ),
    'hi': _WordGridData(
      words: [
        ['व', 'न'],
        ['न', 'म', 'क'],
        ['क', 'ल'],
      ],
      fillers: ['र', 'स', 'प', 'त', 'ग', 'द', 'ज'],
      semanticHint: 'पास वाली खाने जोड़कर तीनों शब्द खोजें',
    ),
    'it': _WordGridData(
      words: [
        ['T', 'R', 'E'],
        ['E', 'R', 'B', 'A'],
        ['A', 'P', 'E'],
      ],
      fillers: ['O', 'I', 'N', 'M', 'L', 'C', 'D'],
      semanticHint: 'Trova tutte e tre le parole unendo caselle vicine',
    ),
    'ja': _WordGridData(
      words: [
        ['山'],
        ['山', '道'],
        ['道', '具'],
      ],
      fillers: ['川', '空', '花', '森', '月', '星', '雨'],
      semanticHint: 'となり合うマスをなぞって3つの言葉を見つけよう',
    ),
    'ko': _WordGridData(
      words: [
        ['별'],
        ['별', '빛'],
        ['빛', '깔'],
      ],
      fillers: ['달', '산', '물', '꽃', '눈', '길', '숲'],
      semanticHint: '이웃한 칸을 이어 세 단어를 모두 찾으세요',
    ),
    'pt': _WordGridData(
      words: [
        ['S', 'O', 'L'],
        ['L', 'I', 'V', 'R', 'O'],
        ['O', 'V', 'O'],
      ],
      fillers: ['A', 'E', 'N', 'M', 'P', 'C', 'D'],
      semanticHint: 'Encontre as três palavras ligando células vizinhas',
    ),
    'ru': _WordGridData(
      words: [
        ['К', 'О', 'Т'],
        ['Т', 'И', 'Г', 'Р'],
        ['Р', 'А', 'К'],
      ],
      fillers: ['М', 'Н', 'С', 'Л', 'П', 'Б', 'Д'],
      semanticHint: 'Найди три слова, соединяя соседние клетки',
    ),
    'zh': _WordGridData(
      words: [
        ['猫'],
        ['猫', '头', '鹰'],
        ['鹰', '眼'],
      ],
      fillers: ['山', '月', '花', '鸟', '水', '云', '林'],
      semanticHint: '连接相邻方格，找出三个词语',
    ),
  };
}
