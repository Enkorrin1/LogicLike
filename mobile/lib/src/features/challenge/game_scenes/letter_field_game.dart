import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

Set<String> get letterFieldSupportedLanguageCodes =>
    _LetterFieldData.localized.keys.toSet();

class LocaleLetterFieldGameView extends StatefulWidget {
  const LocaleLetterFieldGameView({
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
  State<LocaleLetterFieldGameView> createState() =>
      _LocaleLetterFieldGameViewState();
}

class _LocaleLetterFieldGameViewState extends State<LocaleLetterFieldGameView>
    with SingleTickerProviderStateMixin {
  final Set<int> _selected = <int>{};
  final Set<_FieldEdge> _edges = <_FieldEdge>{};
  Timer? _roundTimer;
  late final AnimationController _celebration;
  int _round = 0;
  int _matched = 0;
  int? _cursor;
  int? _errorCell;
  String? _languageCode;
  bool _roundComplete = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _celebration = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    );
  }

  @override
  void dispose() {
    _roundTimer?.cancel();
    _celebration.dispose();
    super.dispose();
  }

  void _ensureLocale(String languageCode) {
    if (_languageCode == languageCode) return;
    _languageCode = languageCode;
    _roundTimer?.cancel();
    _round = 0;
    _matched = 0;
    _cursor = null;
    _errorCell = null;
    _roundComplete = false;
    _answerSent = false;
    _celebration.reset();
    _selected.clear();
    _edges.clear();
  }

  void _start(Offset position, _LetterFieldLayout layout, _FieldRound data) {
    if (_roundComplete) return;
    final cell = layout.cellAt(position);
    if (cell == null) return;

    if (_selected.contains(cell)) {
      setState(() => _cursor = cell);
      return;
    }

    _tryAdd(cell, data);
  }

  void _drag(Offset position, _LetterFieldLayout layout, _FieldRound data) {
    if (_roundComplete || _cursor == null) return;
    final cell = layout.cellAt(position);
    if (cell == null || cell == _cursor || !_neighbors(_cursor!, cell)) return;

    if (_selected.contains(cell)) {
      final edge = _FieldEdge(_cursor!, cell);
      if (_edges.contains(edge)) setState(() => _cursor = cell);
      return;
    }

    _tryAdd(cell, data);
  }

  void _tryAdd(int cell, _FieldRound data) {
    if (_cursor != null && !_neighbors(_cursor!, cell)) return;
    if (data.grid[cell] != data.target[_matched]) {
      HapticFeedback.lightImpact();
      setState(() => _errorCell = cell);
      Future<void>.delayed(const Duration(milliseconds: 360), () {
        if (!mounted || _errorCell != cell) return;
        setState(() {
          _errorCell = null;
          _matched = 0;
          _cursor = null;
          _selected.clear();
          _edges.clear();
        });
      });
      return;
    }

    HapticFeedback.selectionClick();
    setState(() {
      if (_cursor != null) _edges.add(_FieldEdge(_cursor!, cell));
      _selected.add(cell);
      _cursor = cell;
      _errorCell = null;
      _matched += 1;
    });
    if (_matched == data.target.length) _completeRound();
  }

  bool _neighbors(int a, int b) {
    final rowDistance = (a ~/ 4 - b ~/ 4).abs();
    final columnDistance = (a % 4 - b % 4).abs();
    return rowDistance + columnDistance == 1;
  }

  void _completeRound() {
    setState(() => _roundComplete = true);
    HapticFeedback.mediumImpact();
    _celebration.forward(from: 0);
    _roundTimer = Timer(const Duration(milliseconds: 820), () {
      if (!mounted) return;
      if (_round == 0) {
        setState(() {
          _round = 1;
          _matched = 0;
          _cursor = null;
          _errorCell = null;
          _roundComplete = false;
          _selected.clear();
          _edges.clear();
        });
      } else if (!_answerSent) {
        _answerSent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeData = _LetterFieldData.forLocale(locale);
    _ensureLocale(locale.languageCode);
    final roundData = localeData.rounds[_round];
    return Semantics(
      container: true,
      label: '${widget.semanticLabel}. ${localeData.semanticHint}',
      child: Directionality(
        textDirection: localeData.rtl ? TextDirection.rtl : TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 272 : 316,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _LetterFieldLayout(
                  constraints.biggest,
                  compact: widget.compact,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) =>
                      _start(details.localPosition, layout, roundData),
                  onPanStart: (details) =>
                      _start(details.localPosition, layout, roundData),
                  onPanUpdate: (details) =>
                      _drag(details.localPosition, layout, roundData),
                  child: CustomPaint(
                    painter: _LetterFieldPainter(
                      accent: widget.accent,
                      data: roundData,
                      layout: layout,
                      selected: Set<int>.of(_selected),
                      edges: Set<_FieldEdge>.of(_edges),
                      matched: _matched,
                      errorCell: _errorCell,
                      complete: _roundComplete,
                      completedRounds: _round,
                      totalRounds: localeData.rounds.length,
                      celebration: _celebration,
                      rtl: localeData.rtl,
                      onCellTapped: (cell) => _startAtCell(cell, roundData),
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

  void _startAtCell(int cell, _FieldRound data) {
    if (_roundComplete) return;
    if (_selected.contains(cell)) {
      setState(() => _cursor = cell);
      return;
    }
    _tryAdd(cell, data);
  }
}

class _LetterFieldLayout {
  _LetterFieldLayout(this.size, {required this.compact}) {
    final headerHeight = compact ? 58.0 : 67.0;
    final available =
        math.min(size.width - 24, size.height - headerHeight - 18);
    boardSize = math.min(available, compact ? 190.0 : 220.0);
    board = Rect.fromLTWH(
      (size.width - boardSize) / 2,
      headerHeight + 8,
      boardSize,
      boardSize,
    );
    cellSize = boardSize / 4;
  }

  final Size size;
  final bool compact;
  late final Rect board;
  late final double boardSize;
  late final double cellSize;

  Rect cellRect(int index) => Rect.fromLTWH(
        board.left + (index % 4) * cellSize,
        board.top + (index ~/ 4) * cellSize,
        cellSize,
        cellSize,
      );

  Offset center(int index) => cellRect(index).center;

  int? cellAt(Offset point) {
    if (!board.contains(point)) return null;
    final column = ((point.dx - board.left) / cellSize).floor().clamp(0, 3);
    final row = ((point.dy - board.top) / cellSize).floor().clamp(0, 3);
    return row * 4 + column;
  }
}

class _LetterFieldPainter extends CustomPainter {
  const _LetterFieldPainter({
    required this.accent,
    required this.data,
    required this.layout,
    required this.selected,
    required this.edges,
    required this.matched,
    required this.errorCell,
    required this.complete,
    required this.completedRounds,
    required this.totalRounds,
    required this.celebration,
    required this.rtl,
    required this.onCellTapped,
  });

  final Color accent;
  final _FieldRound data;
  final _LetterFieldLayout layout;
  final Set<int> selected;
  final Set<_FieldEdge> edges;
  final int matched;
  final int? errorCell;
  final bool complete;
  final int completedRounds;
  final int totalRounds;
  final Animation<double> celebration;
  final bool rtl;
  final ValueChanged<int> onCellTapped;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF7FAFC),
    );
    _paintTarget(canvas, size);
    _paintCollectibles(canvas, size);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        layout.board.inflate(4),
        Radius.circular(layout.compact ? 15 : 18),
      ),
      Paint()..color = Colors.white,
    );

    final branchPaint = Paint()
      ..color = accent.withValues(alpha: 0.46)
      ..strokeWidth = layout.cellSize * 0.2
      ..strokeCap = StrokeCap.round;
    for (final edge in edges) {
      canvas.drawLine(
        layout.center(edge.a),
        layout.center(edge.b),
        branchPaint,
      );
    }

    for (var index = 0; index < 16; index++) {
      final rect = layout.cellRect(index).deflate(layout.compact ? 3.5 : 4.5);
      final isSelected = selected.contains(index);
      final isError = errorCell == index;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(9)),
        Paint()
          ..color = isError
              ? const Color(0xFFFFE4E1)
              : isSelected
                  ? Color.lerp(accent, Colors.white, 0.14)!
                  : const Color(0xFFEDF2F6),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(9)),
        Paint()
          ..color = isError
              ? const Color(0xFFE45757)
              : isSelected
                  ? accent
                  : const Color(0xFFD9E1E8)
          ..strokeWidth = isSelected ? 2 : 1
          ..style = PaintingStyle.stroke,
      );
      _paintText(
        canvas,
        data.grid[index],
        rect.center,
        layout.compact ? 19 : 23,
        isSelected ? Colors.white : const Color(0xFF243443),
      );
    }
    if (complete) _paintCelebration(canvas);
  }

  void _paintTarget(Canvas canvas, Size size) {
    final width = math.min(size.width - 32, 270.0);
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, layout.compact ? 31 : 36),
      width: width,
      height: layout.compact ? 43 : 49,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()..color = Colors.white,
    );
    final spacing = rect.width / (data.target.length + 1);
    for (var i = 0; i < data.target.length; i++) {
      final visualIndex = rtl ? data.target.length - 1 - i : i;
      final center = Offset(
        rect.left + spacing * (visualIndex + 1),
        rect.center.dy - 2,
      );
      _paintText(
        canvas,
        data.target[i],
        center,
        layout.compact ? 19 : 22,
        i < matched || complete ? accent : const Color(0xFF445463),
      );
      canvas.drawCircle(
        Offset(center.dx, rect.bottom - 7),
        2.2,
        Paint()..color = i < matched ? accent : const Color(0xFFD4DCE3),
      );
    }
  }

  void _paintCollectibles(Canvas canvas, Size size) {
    final radius = layout.compact ? 11.0 : 13.0;
    final centers = <Offset>[
      Offset(25, layout.compact ? 29 : 34),
      Offset(size.width - 25, layout.compact ? 29 : 34),
    ];
    for (var index = 0; index < totalRounds; index++) {
      final claimed =
          index < completedRounds || (index == completedRounds && complete);
      final center = centers[index];
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = claimed
              ? Color.lerp(accent, Colors.white, .16)!
              : const Color(0xFFE7EDF2),
      );
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = claimed ? accent : const Color(0xFFC9D4DD)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      if (claimed)
        _paintText(canvas, '\u2605', center, radius + 3, Colors.white);
    }
  }

  void _paintCelebration(Canvas canvas) {
    final progress = Curves.easeOut.transform(celebration.value);
    final center = layout.board.center;
    final paint = Paint()
      ..color = accent.withValues(alpha: (1 - progress) * .34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, layout.boardSize * (.16 + progress * .55), paint);
    for (var index = 0; index < 8; index++) {
      final angle = math.pi * 2 * index / 8 + progress * .5;
      final from = center +
          Offset(math.cos(angle), math.sin(angle)) * layout.boardSize * .17;
      final to = center +
          Offset(math.cos(angle), math.sin(angle)) *
              layout.boardSize *
              (.22 + progress * .28);
      canvas.drawLine(from, to, paint);
    }
  }

  void _paintText(
    Canvas canvas,
    String value,
    Offset center,
    double fontSize,
    Color color,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _LetterFieldPainter oldDelegate) =>
      oldDelegate.data != data ||
      oldDelegate.selected.length != selected.length ||
      oldDelegate.edges.length != edges.length ||
      oldDelegate.matched != matched ||
      oldDelegate.errorCell != errorCell ||
      oldDelegate.complete != complete ||
      oldDelegate.completedRounds != completedRounds ||
      oldDelegate.celebration.value != celebration.value ||
      oldDelegate.accent != accent;

  @override
  SemanticsBuilderCallback get semanticsBuilder =>
      (size) => List<CustomPainterSemantics>.generate(
          16,
          (index) => CustomPainterSemantics(
                rect: layout.cellRect(index),
                properties: SemanticsProperties(
                  label: data.grid[index],
                  textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                  button: true,
                  onTap: () => onCellTapped(index),
                ),
              ));

  @override
  bool shouldRebuildSemantics(covariant _LetterFieldPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.complete != complete;
}

class _FieldEdge {
  const _FieldEdge(int first, int second)
      : a = first < second ? first : second,
        b = first < second ? second : first;

  final int a;
  final int b;

  @override
  bool operator ==(Object other) =>
      other is _FieldEdge && other.a == a && other.b == b;

  @override
  int get hashCode => Object.hash(a, b);
}

class _FieldRound {
  const _FieldRound({required this.target, required this.grid});

  final List<String> target;
  final List<String> grid;
}

class _LetterFieldData {
  const _LetterFieldData({
    required this.rounds,
    required this.semanticHint,
    this.rtl = false,
  });

  final List<_FieldRound> rounds;
  final String semanticHint;
  final bool rtl;

  static _LetterFieldData forLocale(Locale locale) {
    final code =
        localized.containsKey(locale.languageCode) ? locale.languageCode : 'en';
    final source = localized[code]!;
    final routes = _routes[code]!;
    return _LetterFieldData(
      rounds: [
        _relocate(source.rounds[0], routes.first),
        _relocate(source.rounds[1], routes.second),
      ],
      semanticHint: source.semanticHint,
      rtl: source.rtl,
    );
  }

  static _FieldRound _relocate(_FieldRound source, List<int> route) {
    final filler = source.grid.firstWhere(
      (value) => !source.target.contains(value),
      orElse: () => '?',
    );
    final grid = List<String>.of(source.grid);
    for (var index = 0; index < grid.length; index++) {
      if (source.target.contains(grid[index])) grid[index] = filler;
    }
    for (var index = 0; index < route.length; index++) {
      grid[route[index]] = source.target[index];
    }
    return _FieldRound(target: source.target, grid: grid);
  }

  static const Map<String, ({List<int> first, List<int> second})> _routes = {
    'ar': (first: [0, 1, 5, 4], second: [10, 11, 15]),
    'de': (first: [1, 2, 6, 10, 9], second: [4, 8, 9, 13]),
    'en': (first: [2, 3, 7, 6], second: [12, 8, 9]),
    'es': (first: [5, 1, 2, 6], second: [14, 10, 11]),
    'fr': (first: [15, 14, 10, 6, 7], second: [0, 4, 5, 9]),
    'hi': (first: [3, 7], second: [8, 12]),
    'it': (first: [4, 5, 1, 2, 6], second: [11, 10, 14, 13]),
    'ja': (first: [6, 10], second: [9, 5]),
    'ko': (first: [13, 14], second: [7]),
    'pt': (first: [8, 4, 0, 1, 5], second: [3, 2, 6]),
    'ru': (first: [9, 10, 6, 5], second: [0, 4, 8]),
    'zh': (first: [11, 15], second: [2]),
  };

  static final Map<String, _LetterFieldData> localized = {
    'ar': _data(
      ['ن', 'ج', 'م', 'ة'],
      ['ش', 'م', 'س'],
      ['ب', 'ر', 'ق', 'ل', 'و', 'ح', 'د', 'ي'],
      'صِل الرموز المتجاورة، وارجع على المسار لتكوين فروع',
      rtl: true,
    ),
    'de': _data(
      ['S', 'T', 'E', 'R', 'N'],
      ['M', 'O', 'N', 'D'],
      ['A', 'B', 'F', 'G', 'H', 'I', 'K', 'L'],
      'Verbinde benachbarte Zeichen und gehe auf dem Weg zurück, um abzuzweigen',
    ),
    'en': _data(
      ['S', 'T', 'A', 'R'],
      ['S', 'U', 'N'],
      ['B', 'C', 'D', 'E', 'F', 'G', 'L', 'M'],
      'Connect adjacent symbols and backtrack along the path to branch',
    ),
    'es': _data(
      ['L', 'U', 'N', 'A'],
      ['S', 'O', 'L'],
      ['B', 'C', 'D', 'E', 'F', 'G', 'M', 'R'],
      'Une símbolos vecinos y retrocede por el camino para crear ramas',
    ),
    'fr': _data(
      ['A', 'S', 'T', 'R', 'E'],
      ['L', 'U', 'N', 'E'],
      ['B', 'C', 'D', 'F', 'G', 'I', 'M', 'O'],
      'Relie les symboles voisins et reviens sur le chemin pour créer des branches',
    ),
    'hi': _data(
      ['ता', 'रा'],
      ['ज', 'ल'],
      ['क', 'म', 'न', 'प', 'ब', 'स', 'ह', 'र'],
      'पास के चिह्न जोड़ें और शाखा बनाने के लिए रास्ते पर पीछे जाएँ',
    ),
    'it': _data(
      ['A', 'S', 'T', 'R', 'O'],
      ['S', 'O', 'L', 'E'],
      ['B', 'C', 'D', 'F', 'G', 'I', 'M', 'N'],
      'Unisci i simboli vicini e torna indietro sul percorso per creare rami',
    ),
    'ja': _data(
      ['ほ', 'し'],
      ['つ', 'き'],
      ['あ', 'か', 'さ', 'た', 'な', 'は', 'ま', 'ゆ'],
      'となりの文字をつなぎ、道を戻って枝分かれさせます',
    ),
    'ko': _data(
      ['나', '무'],
      ['해'],
      ['가', '구', '다', '라', '마', '바', '사', '자'],
      '이웃한 글자를 잇고 지나온 길을 되돌아가 가지를 만드세요',
    ),
    'pt': _data(
      ['A', 'S', 'T', 'R', 'O'],
      ['S', 'O', 'L'],
      ['B', 'C', 'D', 'E', 'F', 'G', 'M', 'N'],
      'Ligue símbolos vizinhos e volte pelo caminho para criar ramificações',
    ),
    'ru': _data(
      ['Л', 'У', 'Н', 'А'],
      ['М', 'И', 'Р'],
      ['Б', 'В', 'Г', 'Д', 'Е', 'К', 'О', 'С'],
      'Соединяй соседние символы и возвращайся по пути, чтобы строить ветви',
    ),
    'zh': _data(
      ['太', '阳'],
      ['月'],
      ['山', '水', '木', '火', '田', '云', '风', '雨'],
      '连接相邻字符，并沿原路返回后创建分支',
    ),
  };

  static _LetterFieldData _data(
    List<String> first,
    List<String> second,
    List<String> fillers,
    String semanticHint, {
    bool rtl = false,
  }) =>
      _LetterFieldData(
        rounds: [
          _makeRound(first, fillers),
          _makeRound(second, fillers.reversed.toList()),
        ],
        semanticHint: semanticHint,
        rtl: rtl,
      );

  static _FieldRound _makeRound(List<String> target, List<String> fillers) {
    const routes = <int, List<int>>{
      1: [5],
      2: [5, 6],
      3: [5, 6, 10],
      4: [5, 6, 10, 9],
      5: [5, 6, 10, 9, 8],
    };
    final grid =
        List<String>.generate(16, (index) => fillers[index % fillers.length]);
    final route = routes[target.length]!;
    for (var i = 0; i < target.length; i++) {
      grid[route[i]] = target[i];
    }
    return _FieldRound(target: List.unmodifiable(target), grid: grid);
  }
}
