import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Set<String> get wordGridSupportedLanguageCodes =>
    _WordGridData._localized.keys.toSet();

class WordGridGameView extends StatefulWidget {
  const WordGridGameView({
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
  State<WordGridGameView> createState() => _WordGridGameViewState();
}

class _WordGridGameViewState extends State<WordGridGameView>
    with SingleTickerProviderStateMixin {
  final List<int> _path = [];
  late final AnimationController _pulse;
  Timer? _completionTimer;
  int _errorCell = -1;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _start(Offset position, _WordGridLayout layout, _WordGridData data) {
    if (_solved) return;
    final cell = layout.cellAt(position);
    if (cell == null) return;
    setState(() {
      _path.clear();
      _errorCell = -1;
    });
    _visit(cell, data);
  }

  void _drag(Offset position, _WordGridLayout layout, _WordGridData data) {
    if (_solved) return;
    final cell = layout.cellAt(position);
    if (cell == null || (_path.isNotEmpty && cell == _path.last)) return;
    _visit(cell, data);
  }

  void _visit(int cell, _WordGridData data) {
    if (_path.contains(cell)) return;
    if (_path.isNotEmpty && !_neighbors(_path.last, cell)) return;
    final expected = data.target[_path.length];
    if (data.grid[cell] != expected) {
      HapticFeedback.lightImpact();
      setState(() {
        _errorCell = cell;
        if (_path.isNotEmpty) _path.removeLast();
      });
      Future<void>.delayed(const Duration(milliseconds: 180), () {
        if (mounted && _errorCell == cell) setState(() => _errorCell = -1);
      });
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _errorCell = -1;
      _path.add(cell);
    });
    if (_path.length == data.target.length) _complete();
  }

  bool _neighbors(int a, int b) {
    final rowDistance = (a ~/ 4 - b ~/ 4).abs();
    final columnDistance = (a % 4 - b % 4).abs();
    return rowDistance + columnDistance == 1;
  }

  void _complete() {
    if (_solved) return;
    setState(() => _solved = true);
    HapticFeedback.mediumImpact();
    _pulse.repeat(reverse: true);
    _completionTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _WordGridData.forLocale(Localizations.localeOf(context));
    return Semantics(
      container: true,
      label: '${widget.semanticLabel}. ${data.semanticHint}',
      child: Directionality(
        textDirection: data.rtl ? TextDirection.rtl : TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 272 : 316,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _WordGridLayout(
                  constraints.biggest,
                  compact: widget.compact,
                );
                return AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) =>
                        _start(details.localPosition, layout, data),
                    onPanUpdate: (details) =>
                        _drag(details.localPosition, layout, data),
                    child: CustomPaint(
                      painter: _WordGridPainter(
                        accent: widget.accent,
                        data: data,
                        layout: layout,
                        path: List<int>.of(_path),
                        errorCell: _errorCell,
                        solved: _solved,
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

class _WordGridLayout {
  _WordGridLayout(this.size, {required this.compact}) {
    final targetHeight = compact ? 63.0 : 73.0;
    final available =
        math.min(size.width - 24, size.height - targetHeight - 18);
    boardSize = math.min(available, compact ? 190.0 : 220.0);
    board = Rect.fromLTWH(
      (size.width - boardSize) / 2,
      targetHeight + 8,
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

class _WordGridPainter extends CustomPainter {
  const _WordGridPainter({
    required this.accent,
    required this.data,
    required this.layout,
    required this.path,
    required this.errorCell,
    required this.solved,
    required this.pulse,
  });

  final Color accent;
  final _WordGridData data;
  final _WordGridLayout layout;
  final List<int> path;
  final int errorCell;
  final bool solved;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFF7FAFC));
    _paintTarget(canvas, size);
    final boardRadius = Radius.circular(layout.compact ? 15 : 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(layout.board.inflate(4), boardRadius),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    if (path.length > 1) {
      final line = Paint()
        ..color = accent.withValues(alpha: 0.48)
        ..strokeWidth = layout.cellSize * 0.22
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final route = Path()
        ..moveTo(layout.center(path.first).dx, layout.center(path.first).dy);
      for (final cell in path.skip(1)) {
        route.lineTo(layout.center(cell).dx, layout.center(cell).dy);
      }
      canvas.drawPath(route, line);
    }

    for (var index = 0; index < 16; index++) {
      final rect = layout.cellRect(index).deflate(layout.compact ? 3.5 : 4.5);
      final selected = path.contains(index);
      final error = errorCell == index;
      final scale = solved && selected ? 1 + pulse * 0.04 : 1.0;
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.scale(scale);
      canvas.translate(-rect.center.dx, -rect.center.dy);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()
          ..color = error
              ? const Color(0xFFFFE4E1)
              : selected
                  ? Color.lerp(accent, Colors.white, 0.16)!
                  : const Color(0xFFEDF2F6),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()
          ..color = error
              ? const Color(0xFFE45757)
              : selected
                  ? accent
                  : const Color(0xFFD9E1E8)
          ..strokeWidth = selected ? 2.0 : 1.0
          ..style = PaintingStyle.stroke,
      );
      _text(
        canvas,
        data.grid[index],
        rect.center,
        layout.compact ? 20 : 24,
        selected ? Colors.white : const Color(0xFF243443),
      );
      canvas.restore();
    }
  }

  void _paintTarget(Canvas canvas, Size size) {
    final iconCenter = Offset(
      data.rtl ? size.width - 43 : 43,
      layout.compact ? 32 : 37,
    );
    final iconRadius = layout.compact ? 24.0 : 27.0;
    canvas.drawCircle(
        iconCenter, iconRadius, Paint()..color = const Color(0xFFFFE7A3));
    _paintCat(canvas, iconCenter, iconRadius * 0.68);

    final targetWidth = math.min(size.width * 0.62, 235.0);
    final targetRect = Rect.fromCenter(
      center: Offset(
        data.rtl ? (size.width - 86) / 2 : (size.width + 86) / 2,
        iconCenter.dy,
      ),
      width: targetWidth,
      height: layout.compact ? 42 : 48,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(targetRect, const Radius.circular(12)),
      Paint()..color = Colors.white,
    );
    final display = data.rtl ? data.target.reversed : data.target;
    final symbols = display.toList();
    final spacing = targetRect.width / (symbols.length + 1);
    for (var i = 0; i < symbols.length; i++) {
      final done = i < path.length;
      _text(
        canvas,
        symbols[i],
        Offset(targetRect.left + spacing * (i + 1), targetRect.center.dy - 2),
        layout.compact ? 19 : 22,
        done || solved ? accent : const Color(0xFF445463),
      );
      canvas.drawCircle(
        Offset(targetRect.left + spacing * (i + 1), targetRect.bottom - 7),
        2.2,
        Paint()..color = done ? accent : const Color(0xFFD4DCE3),
      );
    }
  }

  void _paintCat(Canvas canvas, Offset center, double radius) {
    final fill = Paint()..color = const Color(0xFF59636D);
    final head =
        Rect.fromCircle(center: center.translate(0, 2), radius: radius * 0.68);
    final ears = Path()
      ..moveTo(center.dx - radius * 0.55, center.dy - radius * 0.22)
      ..lineTo(center.dx - radius * 0.48, center.dy - radius)
      ..lineTo(center.dx - radius * 0.05, center.dy - radius * 0.5)
      ..moveTo(center.dx + radius * 0.55, center.dy - radius * 0.22)
      ..lineTo(center.dx + radius * 0.48, center.dy - radius)
      ..lineTo(center.dx + radius * 0.05, center.dy - radius * 0.5);
    canvas.drawPath(ears, fill);
    canvas.drawOval(head, fill);
    final detail = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center.translate(-radius * 0.25, 0), 2, detail);
    canvas.drawCircle(center.translate(radius * 0.25, 0), 2, detail);
    canvas.drawLine(center.translate(-3, radius * 0.3),
        center.translate(3, radius * 0.3), detail);
  }

  void _text(
      Canvas canvas, String value, Offset center, double size, Color color) {
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
    )..layout();
    painter.paint(
        canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _WordGridPainter oldDelegate) =>
      oldDelegate.path.length != path.length ||
      oldDelegate.errorCell != errorCell ||
      oldDelegate.solved != solved ||
      oldDelegate.pulse != pulse ||
      oldDelegate.accent != accent ||
      oldDelegate.data != data;
}

class _WordGridData {
  const _WordGridData({
    required this.target,
    required this.grid,
    required this.semanticHint,
    this.rtl = false,
  });

  final List<String> target;
  final List<String> grid;
  final String semanticHint;
  final bool rtl;

  static _WordGridData forLocale(Locale locale) =>
      _localized[locale.languageCode] ?? _localized['en']!;

  static const _localized = <String, _WordGridData>{
    'ar': _WordGridData(
      target: ['ق', 'ط'],
      grid: [
        'س',
        'م',
        'ط',
        'ق',
        'ر',
        'ب',
        'ل',
        'ن',
        'ف',
        'د',
        'ك',
        'و',
        'ه',
        'ج',
        'ي',
        'ت'
      ],
      semanticHint: 'مرر إصبعك بين الخلايا المتجاورة لتكوين الرموز الظاهرة',
      rtl: true,
    ),
    'de': _WordGridData(
      target: ['K', 'A', 'T', 'Z', 'E'],
      grid: [
        'K',
        'A',
        'R',
        'M',
        'L',
        'T',
        'O',
        'S',
        'D',
        'Z',
        'E',
        'N',
        'P',
        'I',
        'U',
        'B'
      ],
      semanticHint: 'Verbinde benachbarte Felder zu den gezeigten Zeichen',
    ),
    'en': _WordGridData(
      target: ['C', 'A', 'T'],
      grid: [
        'C',
        'A',
        'R',
        'M',
        'L',
        'T',
        'O',
        'S',
        'D',
        'E',
        'N',
        'P',
        'I',
        'U',
        'B',
        'G'
      ],
      semanticHint: 'Trace adjacent cells to make the shown characters',
    ),
    'es': _WordGridData(
      target: ['G', 'A', 'T', 'O'],
      grid: [
        'G',
        'A',
        'R',
        'M',
        'L',
        'T',
        'O',
        'S',
        'D',
        'E',
        'N',
        'P',
        'I',
        'U',
        'B',
        'C'
      ],
      semanticHint: 'Une casillas vecinas para formar los caracteres mostrados',
    ),
    'fr': _WordGridData(
      target: ['C', 'H', 'A', 'T'],
      grid: [
        'C',
        'H',
        'R',
        'M',
        'L',
        'A',
        'T',
        'S',
        'D',
        'E',
        'N',
        'P',
        'I',
        'U',
        'B',
        'O'
      ],
      semanticHint:
          'Relie les cases voisines pour former les caractères affichés',
    ),
    'hi': _WordGridData(
      target: ['बि', 'ल्ली'],
      grid: [
        'बि',
        'ल्ली',
        'का',
        'म',
        'ना',
        'री',
        'तो',
        'स',
        'दी',
        'पे',
        'मु',
        'ल',
        'जा',
        'हो',
        'गु',
        'च'
      ],
      semanticHint: 'दिखाए गए अक्षर बनाने के लिए पास वाली कोठरियों को जोड़ें',
    ),
    'it': _WordGridData(
      target: ['G', 'A', 'T', 'T', 'O'],
      grid: [
        'G',
        'A',
        'R',
        'M',
        'L',
        'T',
        'O',
        'S',
        'D',
        'T',
        'O',
        'N',
        'P',
        'I',
        'U',
        'B'
      ],
      semanticHint: 'Unisci le caselle vicine per formare i caratteri mostrati',
    ),
    'ja': _WordGridData(
      target: ['ね', 'こ'],
      grid: [
        'ね',
        'こ',
        'さ',
        'み',
        'り',
        'た',
        'の',
        'す',
        'き',
        'め',
        'ふ',
        'ら',
        'は',
        'ゆ',
        'ち',
        'も'
      ],
      semanticHint: 'となり合うマスをなぞって、表示された文字を作ります',
    ),
    'ko': _WordGridData(
      target: ['고', '양', '이'],
      grid: [
        '고',
        '양',
        '나',
        '마',
        '라',
        '이',
        '도',
        '소',
        '기',
        '네',
        '주',
        '바',
        '하',
        '우',
        '치',
        '모'
      ],
      semanticHint: '이웃한 칸을 이어 표시된 글자를 만드세요',
    ),
    'pt': _WordGridData(
      target: ['G', 'A', 'T', 'O'],
      grid: [
        'G',
        'A',
        'R',
        'M',
        'L',
        'T',
        'O',
        'S',
        'D',
        'E',
        'N',
        'P',
        'I',
        'U',
        'B',
        'C'
      ],
      semanticHint:
          'Ligue células vizinhas para formar os caracteres mostrados',
    ),
    'ru': _WordGridData(
      target: ['К', 'О', 'Т'],
      grid: [
        'К',
        'О',
        'Р',
        'М',
        'Л',
        'Т',
        'А',
        'С',
        'Д',
        'Е',
        'Н',
        'П',
        'И',
        'У',
        'Б',
        'Г'
      ],
      semanticHint: 'Проведи по соседним клеткам и собери показанные символы',
    ),
    'zh': _WordGridData(
      target: ['小', '猫'],
      grid: [
        '小',
        '猫',
        '山',
        '月',
        '花',
        '鸟',
        '日',
        '水',
        '星',
        '云',
        '木',
        '鱼',
        '雨',
        '火',
        '风',
        '田'
      ],
      semanticHint: '连接相邻方格，组成显示的字符',
    ),
  };
}
