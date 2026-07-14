import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Set<String> get animalWordSupportedLanguageCodes =>
    _AnimalWordData._localized.keys.toSet();

class AnimalWordGameView extends StatefulWidget {
  const AnimalWordGameView({
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
  State<AnimalWordGameView> createState() => _AnimalWordGameViewState();
}

class _AnimalWordGameViewState extends State<AnimalWordGameView>
    with TickerProviderStateMixin {
  late final AnimationController _reaction;
  late final AnimationController _success;
  final Map<int, int> _placed = <int, int>{};
  int? _wrongTile;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    _success.dispose();
    super.dispose();
  }

  void _drop(int slot, int tile, _AnimalWordData data) {
    if (_answerSent || _placed.containsKey(slot)) return;
    if (data.tiles[tile] != data.units[slot]) {
      HapticFeedback.lightImpact();
      setState(() => _wrongTile = tile);
      _reaction.forward(from: 0).whenComplete(() {
        if (mounted && _wrongTile == tile) setState(() => _wrongTile = null);
      });
      return;
    }

    HapticFeedback.selectionClick();
    setState(() {
      _wrongTile = null;
      _placed[slot] = tile;
    });
    if (_placed.length == data.units.length) _complete();
  }

  void _placeFromSemantics(int tile, _AnimalWordData data) {
    for (var slot = 0; slot < data.units.length; slot++) {
      if (!_placed.containsKey(slot) && data.units[slot] == data.tiles[tile]) {
        _drop(slot, tile, data);
        return;
      }
    }
  }

  void _complete() {
    if (_answerSent) return;
    _answerSent = true;
    HapticFeedback.mediumImpact();
    _success.forward(from: 0).whenComplete(() {
      if (mounted) widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _AnimalWordData.forLocale(Localizations.localeOf(context));
    return Semantics(
      container: true,
      label: '${widget.semanticLabel}. ${data.instruction}',
      child: Directionality(
        textDirection: data.rtl ? TextDirection.rtl : TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 290 : 338,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _AnimalWordLayout(
                  constraints.biggest,
                  data.units.length,
                  data.tiles.length,
                  compact: widget.compact,
                );
                return AnimatedBuilder(
                  animation: Listenable.merge([_reaction, _success]),
                  builder: (context, _) => Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(
                        painter: _AnimalWordPainter(
                          accent: widget.accent,
                          layout: layout,
                          data: data,
                          placed: _placed,
                          success: _success.value,
                        ),
                      ),
                      for (var slot = 0; slot < data.units.length; slot++)
                        Positioned.fromRect(
                          rect: layout.slotRect(slot),
                          child: DragTarget<int>(
                            onWillAcceptWithDetails: (details) =>
                                !_answerSent && !_placed.containsKey(slot),
                            onAcceptWithDetails: (details) =>
                                _drop(slot, details.data, data),
                            builder: (context, candidates, rejected) =>
                                Semantics(
                              label: _placed.containsKey(slot)
                                  ? '${data.filledSlot} ${data.units[slot]}'
                                  : '${data.emptySlot} ${slot + 1}',
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      for (var tile = 0; tile < data.tiles.length; tile++)
                        if (!_placed.containsValue(tile))
                          Positioned.fromRect(
                            rect: layout.tileRect(tile).translate(
                                  _wrongTile == tile
                                      ? math.sin(
                                              _reaction.value * math.pi * 4) *
                                          5 *
                                          (1 - _reaction.value)
                                      : 0,
                                  0,
                                ),
                            child: Semantics(
                              button: true,
                              label: '${data.tileLabel} ${data.tiles[tile]}',
                              onTap: _answerSent
                                  ? null
                                  : () => _placeFromSemantics(tile, data),
                              child: Draggable<int>(
                                data: tile,
                                maxSimultaneousDrags: _answerSent ? 0 : 1,
                                feedback: _TileFeedback(
                                  value: data.tiles[tile],
                                  accent: widget.accent,
                                  size: layout.tileRect(tile).size,
                                  rtl: data.rtl,
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.25,
                                  child: _Tile(
                                    value: data.tiles[tile],
                                    accent: widget.accent,
                                    rtl: data.rtl,
                                  ),
                                ),
                                child: _Tile(
                                  value: data.tiles[tile],
                                  accent: widget.accent,
                                  rtl: data.rtl,
                                ),
                              ),
                            ),
                          ),
                    ],
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

class _Tile extends StatelessWidget {
  const _Tile({required this.value, required this.accent, required this.rtl});

  final String value;
  final Color accent;
  final bool rtl;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accent.withValues(alpha: 0.5), width: 1.5),
          boxShadow: const [
            BoxShadow(
                color: Color(0x220B2638), blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                value,
                textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                style: const TextStyle(
                  color: Color(0xFF263744),
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      );
}

class _TileFeedback extends StatelessWidget {
  const _TileFeedback({
    required this.value,
    required this.accent,
    required this.size,
    required this.rtl,
  });

  final String value;
  final Color accent;
  final Size size;
  final bool rtl;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: _Tile(value: value, accent: accent, rtl: rtl),
        ),
      );
}

class _AnimalWordLayout {
  _AnimalWordLayout(
    this.size,
    this.slotCount,
    this.tileCount, {
    required this.compact,
  }) {
    const horizontalPadding = 18.0;
    final maxCell = compact ? 56.0 : 64.0;
    final gap = slotCount > 4 ? 5.0 : 8.0;
    cellWidth = math.min(
      maxCell,
      (size.width - horizontalPadding * 2 - gap * (slotCount - 1)) / slotCount,
    );
    cellHeight = compact ? 46.0 : 52.0;
    final wordWidth = cellWidth * slotCount + gap * (slotCount - 1);
    slotsLeft = (size.width - wordWidth) / 2;
    slotsTop = compact ? 142.0 : 166.0;
    slotGap = gap;

    final columns = tileCount <= 6 ? tileCount : (tileCount / 2).ceil();
    tileGap = 7;
    tileWidth = math.min(
      compact ? 54.0 : 61.0,
      (size.width - horizontalPadding * 2 - tileGap * (columns - 1)) / columns,
    );
    tileHeight = compact ? 44.0 : 48.0;
    tileColumns = columns;
    final paletteWidth = tileWidth * columns + tileGap * (columns - 1);
    tilesLeft = (size.width - paletteWidth) / 2;
    tilesTop = slotsTop + cellHeight + (compact ? 20 : 25);
  }

  final Size size;
  final int slotCount;
  final int tileCount;
  final bool compact;
  late final double cellWidth;
  late final double cellHeight;
  late final double slotsLeft;
  late final double slotsTop;
  late final double slotGap;
  late final int tileColumns;
  late final double tileWidth;
  late final double tileHeight;
  late final double tileGap;
  late final double tilesLeft;
  late final double tilesTop;

  Rect slotRect(int index) => Rect.fromLTWH(
        slotsLeft + index * (cellWidth + slotGap),
        slotsTop,
        cellWidth,
        cellHeight,
      );

  Rect tileRect(int index) => Rect.fromLTWH(
        tilesLeft + (index % tileColumns) * (tileWidth + tileGap),
        tilesTop + (index ~/ tileColumns) * (tileHeight + 7),
        tileWidth,
        tileHeight,
      );
}

class _AnimalWordPainter extends CustomPainter {
  const _AnimalWordPainter({
    required this.accent,
    required this.layout,
    required this.data,
    required this.placed,
    required this.success,
  });

  final Color accent;
  final _AnimalWordLayout layout;
  final _AnimalWordData data;
  final Map<int, int> placed;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFF5FAF8));
    _paintBackdrop(canvas, size);
    _paintCat(canvas, Offset(size.width / 2, layout.compact ? 75 : 88));
    for (var i = 0; i < data.units.length; i++) {
      final rect = layout.slotRect(i);
      final filled = placed.containsKey(i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()..color = filled ? accent.withValues(alpha: 0.13) : Colors.white,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()
          ..color = filled ? accent : const Color(0xFFB8C8C3)
          ..strokeWidth = filled ? 2 : 1.5
          ..style = PaintingStyle.stroke,
      );
      if (filled) _paintText(canvas, data.units[i], rect.center);
    }
  }

  void _paintBackdrop(Canvas canvas, Size size) {
    final ground = Paint()..color = const Color(0xFFDDEFE4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, layout.compact ? 124 : 145),
        width: math.min(size.width * 0.55, 205),
        height: 22,
      ),
      ground,
    );
    if (success > 0) {
      final sparkle = Paint()..color = accent.withValues(alpha: 1 - success);
      for (var i = 0; i < 8; i++) {
        final angle = i * math.pi / 4;
        final radius = 42 + success * 34;
        canvas.drawCircle(
          Offset(size.width / 2 + math.cos(angle) * radius,
              (layout.compact ? 75 : 88) + math.sin(angle) * radius),
          3.5 * (1 - success * 0.5),
          sparkle,
        );
      }
    }
  }

  void _paintCat(Canvas canvas, Offset center) {
    final bounce = math.sin(success * math.pi) * 5;
    canvas.save();
    canvas.translate(0, -bounce);
    final fur = Paint()..color = const Color(0xFFFFB85C);
    final dark = Paint()
      ..color = const Color(0xFF5A463B)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    final head = Rect.fromCenter(center: center, width: 78, height: 68);
    final ears = Path()
      ..moveTo(center.dx - 34, center.dy - 18)
      ..lineTo(center.dx - 29, center.dy - 48)
      ..lineTo(center.dx - 8, center.dy - 31)
      ..moveTo(center.dx + 34, center.dy - 18)
      ..lineTo(center.dx + 29, center.dy - 48)
      ..lineTo(center.dx + 8, center.dy - 31);
    canvas.drawPath(ears, fur);
    canvas.drawOval(head, fur);
    canvas.drawCircle(center.translate(-15, -4), 3, dark);
    canvas.drawCircle(center.translate(15, -4), 3, dark);
    canvas.drawCircle(center.translate(0, 10), 3.5, dark);
    canvas.drawArc(
        Rect.fromCenter(center: center.translate(-6, 12), width: 12, height: 9),
        0,
        math.pi,
        false,
        dark..style = PaintingStyle.stroke);
    canvas.drawArc(
        Rect.fromCenter(center: center.translate(6, 12), width: 12, height: 9),
        0,
        math.pi,
        false,
        dark);
    for (final y in const [6.0, 13.0]) {
      canvas.drawLine(
          center.translate(-9, y), center.translate(-37, y - 4), dark);
      canvas.drawLine(
          center.translate(9, y), center.translate(37, y - 4), dark);
    }
    canvas.restore();
  }

  void _paintText(Canvas canvas, String value, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: const Color(0xFF263744),
          fontSize: layout.compact ? 21 : 24,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      textDirection: data.rtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: layout.cellWidth - 8);
    painter.paint(
        canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _AnimalWordPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.placed.length != placed.length ||
      oldDelegate.success != success ||
      oldDelegate.data != data;
}

class _AnimalWordData {
  const _AnimalWordData({
    required this.units,
    required this.tiles,
    required this.instruction,
    required this.emptySlot,
    required this.filledSlot,
    required this.tileLabel,
    this.rtl = false,
  });

  final List<String> units;
  final List<String> tiles;
  final String instruction;
  final String emptySlot;
  final String filledSlot;
  final String tileLabel;
  final bool rtl;

  static _AnimalWordData forLocale(Locale locale) =>
      _localized[locale.languageCode] ?? _localized['en']!;

  static const _localized = <String, _AnimalWordData>{
    'ar': _AnimalWordData(
        units: ['ق', 'ط', 'ة'],
        tiles: ['ط', 'ب', 'ة', 'ق', 'س'],
        instruction: 'اسحب الحروف إلى الأماكن لتكوين اسم الحيوان',
        emptySlot: 'مكان فارغ',
        filledSlot: 'حرف صحيح',
        tileLabel: 'حرف',
        rtl: true),
    'de': _AnimalWordData(
        units: ['KA', 'T', 'ZE'],
        tiles: ['ZE', 'LO', 'KA', 'T', 'MI'],
        instruction: 'Ziehe die Teile in die Felder und bilde den Tiernamen',
        emptySlot: 'Leeres Feld',
        filledSlot: 'Richtiges Teil',
        tileLabel: 'Teil'),
    'en': _AnimalWordData(
        units: ['C', 'A', 'T'],
        tiles: ['A', 'D', 'T', 'C', 'O'],
        instruction: 'Drag the letters into the slots to name the animal',
        emptySlot: 'Empty slot',
        filledSlot: 'Correct letter',
        tileLabel: 'Letter'),
    'es': _AnimalWordData(
        units: ['GA', 'T', 'O'],
        tiles: ['O', 'PE', 'GA', 'T', 'LU'],
        instruction:
            'Arrastra las piezas a los huecos para formar el nombre del animal',
        emptySlot: 'Hueco vacío',
        filledSlot: 'Pieza correcta',
        tileLabel: 'Pieza'),
    'fr': _AnimalWordData(
        units: ['CH', 'A', 'T'],
        tiles: ['A', 'LO', 'T', 'CH', 'MI'],
        instruction:
            'Glisse les lettres dans les cases pour former le nom de l’animal',
        emptySlot: 'Case vide',
        filledSlot: 'Lettre correcte',
        tileLabel: 'Lettre'),
    'hi': _AnimalWordData(
        units: ['बि', 'ल्ली'],
        tiles: ['ल्ली', 'का', 'बि', 'ता'],
        instruction: 'जानवर का नाम बनाने के लिए अक्षर खानों में खींचें',
        emptySlot: 'खाली खाना',
        filledSlot: 'सही अक्षर',
        tileLabel: 'अक्षर'),
    'it': _AnimalWordData(
        units: ['GA', 'T', 'TO'],
        tiles: ['TO', 'LU', 'GA', 'T', 'MI'],
        instruction:
            'Trascina le parti negli spazi per formare il nome dell’animale',
        emptySlot: 'Spazio vuoto',
        filledSlot: 'Parte corretta',
        tileLabel: 'Parte'),
    'ja': _AnimalWordData(
        units: ['ね', 'こ'],
        tiles: ['い', 'こ', 'ね', 'ぬ'],
        instruction: '文字を枠に入れて動物の名前を作ろう',
        emptySlot: '空の枠',
        filledSlot: '正しい文字',
        tileLabel: '文字'),
    'ko': _AnimalWordData(
        units: ['고', '양', '이'],
        tiles: ['양', '개', '이', '고', '소'],
        instruction: '글자를 칸에 끌어 동물 이름을 만드세요',
        emptySlot: '빈칸',
        filledSlot: '맞는 글자',
        tileLabel: '글자'),
    'pt': _AnimalWordData(
        units: ['GA', 'T', 'O'],
        tiles: ['T', 'CA', 'O', 'GA', 'LU'],
        instruction:
            'Arraste as partes para os espaços e forme o nome do animal',
        emptySlot: 'Espaço vazio',
        filledSlot: 'Parte correta',
        tileLabel: 'Parte'),
    'ru': _AnimalWordData(
        units: ['КО', 'Ш', 'КА'],
        tiles: ['Ш', 'ЛА', 'КА', 'КО', 'МИ'],
        instruction: 'Перетащи части в ячейки и составь название животного',
        emptySlot: 'Пустая ячейка',
        filledSlot: 'Верная часть',
        tileLabel: 'Часть слова'),
    'zh': _AnimalWordData(
        units: ['小', '猫'],
        tiles: ['狗', '猫', '小', '鸟'],
        instruction: '把汉字拖进空格，组成动物名称',
        emptySlot: '空格',
        filledSlot: '正确的字',
        tileLabel: '汉字'),
  };
}
