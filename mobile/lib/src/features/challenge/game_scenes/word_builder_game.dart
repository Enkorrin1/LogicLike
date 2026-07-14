import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Set<String> get wordBuilderSupportedLanguageCodes =>
    _WordBuilderData._localized.keys.toSet();

class LocaleWordBuilderGameView extends StatefulWidget {
  const LocaleWordBuilderGameView({
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
  State<LocaleWordBuilderGameView> createState() =>
      _LocaleWordBuilderGameViewState();
}

class _LocaleWordBuilderGameViewState extends State<LocaleWordBuilderGameView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _success;
  Timer? _completionTimer;
  List<int?> _slots = const [];
  String? _languageCode;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    _success.dispose();
    super.dispose();
  }

  void _ensureData(_WordBuilderData data, String languageCode) {
    if (_languageCode == languageCode && _slots.length == data.target.length) {
      return;
    }
    _languageCode = languageCode;
    _slots = List<int?>.filled(data.target.length, null);
    _answerSent = false;
    _completionTimer?.cancel();
    _success.reset();
  }

  void _drop(int destination, int tile, _WordBuilderData data) {
    if (_answerSent) return;
    final source = _slots.indexOf(tile);
    final displaced = _slots[destination];
    setState(() {
      if (source >= 0) _slots[source] = displaced;
      _slots[destination] = tile;
    });
    HapticFeedback.selectionClick();
    if (_isCorrect(data)) _complete();
  }

  void _placeFromSemantics(int tile, _WordBuilderData data) {
    if (_answerSent) return;
    final source = _slots.indexOf(tile);
    final destination =
        source < 0 ? _slots.indexOf(null) : (source + 1) % _slots.length;
    if (destination >= 0 && destination != source) {
      _drop(destination, tile, data);
    }
  }

  bool _isCorrect(_WordBuilderData data) {
    for (var index = 0; index < data.target.length; index++) {
      final tile = _slots[index];
      if (tile == null || data.tiles[tile] != data.target[index]) return false;
    }
    return true;
  }

  void _complete() {
    if (_answerSent) return;
    _answerSent = true;
    HapticFeedback.mediumImpact();
    _success.forward(from: 0);
    _completionTimer = Timer(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final data = _WordBuilderData.forLocale(locale);
    _ensureData(data, locale.languageCode);
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      child: Directionality(
        textDirection: data.rtl ? TextDirection.rtl : TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: widget.compact ? 278 : 326,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final layout = _WordBuilderLayout(
                  constraints.biggest,
                  data.target.length,
                  compact: widget.compact,
                  rtl: data.rtl,
                );
                return AnimatedBuilder(
                  animation: _success,
                  builder: (context, _) => Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(
                        painter: _WordBuilderPainter(
                          accent: widget.accent,
                          layout: layout,
                          occupied: _slots.map((tile) => tile != null).toList(),
                          success: _success.value,
                        ),
                      ),
                      Positioned.fromRect(
                        rect: layout.targetRect,
                        child: ExcludeSemantics(
                          child: _TokenText(
                            value: data.goal,
                            rtl: data.rtl,
                            fontSize: widget.compact ? 25 : 29,
                            color: const Color(0xFF263744),
                          ),
                        ),
                      ),
                      for (var slot = 0; slot < _slots.length; slot++)
                        Positioned.fromRect(
                          rect: layout.slotRect(slot),
                          child: DragTarget<int>(
                            onWillAcceptWithDetails: (_) => !_answerSent,
                            onAcceptWithDetails: (details) =>
                                _drop(slot, details.data, data),
                            builder: (context, candidates, rejected) {
                              final tile = _slots[slot];
                              if (tile == null) return const SizedBox.expand();
                              return _draggableTile(
                                tile,
                                data,
                                highlighted: candidates.isNotEmpty,
                              );
                            },
                          ),
                        ),
                      for (var tile = 0; tile < data.tiles.length; tile++)
                        if (!_slots.contains(tile))
                          Positioned.fromRect(
                            rect: layout.poolRect(tile),
                            child: _draggableTile(tile, data),
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

  Widget _draggableTile(
    int tile,
    _WordBuilderData data, {
    bool highlighted = false,
  }) {
    final child = _WordTile(
      value: data.tiles[tile],
      accent: widget.accent,
      rtl: data.rtl,
      highlighted: highlighted,
    );
    return Semantics(
      button: true,
      label: data.tiles[tile],
      onTap: _answerSent ? null : () => _placeFromSemantics(tile, data),
      child: Draggable<int>(
        data: tile,
        maxSimultaneousDrags: _answerSent ? 0 : 1,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(width: 58, height: 58, child: child),
        ),
        childWhenDragging: Opacity(opacity: 0.18, child: child),
        child: child,
      ),
    );
  }
}

class _WordTile extends StatelessWidget {
  const _WordTile({
    required this.value,
    required this.accent,
    required this.rtl,
    required this.highlighted,
  });

  final String value;
  final Color accent;
  final bool rtl;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: highlighted ? accent.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: accent.withValues(alpha: highlighted ? 0.9 : 0.5),
            width: highlighted ? 2.5 : 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x240B2638),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: _TokenText(
          value: value,
          rtl: rtl,
          fontSize: 24,
          color: const Color(0xFF263744),
        ),
      );
}

class _TokenText extends StatelessWidget {
  const _TokenText({
    required this.value,
    required this.rtl,
    required this.fontSize,
    required this.color,
  });

  final String value;
  final bool rtl;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) => Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Text(
              value,
              textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
        ),
      );
}

class _WordBuilderLayout {
  _WordBuilderLayout(
    this.size,
    this.count, {
    required this.compact,
    required this.rtl,
  }) {
    final tileSize = compact ? 51.0 : 58.0;
    final gap = compact ? 8.0 : 11.0;
    final rowWidth = count * tileSize + (count - 1) * gap;
    final left = (size.width - rowWidth) / 2;
    targetRect = Rect.fromLTWH(16, compact ? 18 : 22, size.width - 32, 46);
    _logicalSlots = List<Rect>.generate(count, (index) {
      final visualIndex = rtl ? count - index - 1 : index;
      return Rect.fromLTWH(
        left + visualIndex * (tileSize + gap),
        compact ? 91 : 108,
        tileSize,
        tileSize,
      );
    });
    _pool = List<Rect>.generate(count, (index) {
      final visualIndex = rtl ? count - index - 1 : index;
      return Rect.fromLTWH(
        left + visualIndex * (tileSize + gap),
        compact ? 194 : 225,
        tileSize,
        tileSize,
      );
    });
  }

  final Size size;
  final int count;
  final bool compact;
  final bool rtl;
  late final Rect targetRect;
  late final List<Rect> _logicalSlots;
  late final List<Rect> _pool;

  Rect slotRect(int index) => _logicalSlots[index];
  Rect poolRect(int index) => _pool[index];
}

class _WordBuilderPainter extends CustomPainter {
  const _WordBuilderPainter({
    required this.accent,
    required this.layout,
    required this.occupied,
    required this.success,
  });

  final Color accent;
  final _WordBuilderLayout layout;
  final List<bool> occupied;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFFF7FAFC));
    final glow = Paint()
      ..color = accent.withValues(alpha: 0.08 + success * 0.12);
    canvas.drawCircle(
      Offset(size.width / 2, layout.targetRect.center.dy),
      math.min(size.width * 0.32, 115) * (1 + success * 0.08),
      glow,
    );
    for (var index = 0; index < occupied.length; index++) {
      final rect = layout.slotRect(index);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()
          ..color = occupied[index]
              ? accent.withValues(alpha: 0.08)
              : const Color(0xFFFFFFFF),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(0.75), const Radius.circular(8)),
        Paint()
          ..color = accent.withValues(alpha: 0.34 + success * 0.4)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke,
      );
    }
    final lineY = layout.poolRect(0).top - (layout.compact ? 20 : 24);
    canvas.drawLine(
      Offset(size.width * 0.18, lineY),
      Offset(size.width * 0.82, lineY),
      Paint()
        ..color = const Color(0xFFDCE5EA)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _WordBuilderPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.success != success ||
      !_sameBools(oldDelegate.occupied, occupied);

  bool _sameBools(List<bool> a, List<bool> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}

class _WordBuilderData {
  const _WordBuilderData({
    required this.goal,
    required this.target,
    required this.tiles,
    this.rtl = false,
  });

  final String goal;
  final List<String> target;
  final List<String> tiles;
  final bool rtl;

  static _WordBuilderData forLocale(Locale locale) =>
      _localized[locale.languageCode] ?? _localized['en']!;

  static const Map<String, _WordBuilderData> _localized = {
    'ar': _WordBuilderData(
      goal: 'قمر',
      target: ['ق', 'م', 'ر'],
      tiles: ['م', 'ر', 'ق'],
      rtl: true,
    ),
    'de': _WordBuilderData(
      goal: 'MOND',
      target: ['M', 'O', 'N', 'D'],
      tiles: ['N', 'D', 'M', 'O'],
    ),
    'en': _WordBuilderData(
      goal: 'STAR',
      target: ['S', 'T', 'A', 'R'],
      tiles: ['A', 'R', 'S', 'T'],
    ),
    'es': _WordBuilderData(
      goal: 'LUNA',
      target: ['L', 'U', 'N', 'A'],
      tiles: ['N', 'A', 'L', 'U'],
    ),
    'fr': _WordBuilderData(
      goal: 'LUNE',
      target: ['L', 'U', 'N', 'E'],
      tiles: ['N', 'E', 'L', 'U'],
    ),
    'hi': _WordBuilderData(
      goal: 'तारा',
      target: ['ता', 'रा'],
      tiles: ['रा', 'ता'],
    ),
    'it': _WordBuilderData(
      goal: 'SOLE',
      target: ['S', 'O', 'L', 'E'],
      tiles: ['L', 'E', 'S', 'O'],
    ),
    'ja': _WordBuilderData(
      goal: 'ほし',
      target: ['ほ', 'し'],
      tiles: ['し', 'ほ'],
    ),
    'ko': _WordBuilderData(
      goal: '별빛',
      target: ['별', '빛'],
      tiles: ['빛', '별'],
    ),
    'pt': _WordBuilderData(
      goal: 'LUA',
      target: ['L', 'U', 'A'],
      tiles: ['A', 'L', 'U'],
    ),
    'ru': _WordBuilderData(
      goal: 'ЛУНА',
      target: ['Л', 'У', 'Н', 'А'],
      tiles: ['Н', 'А', 'Л', 'У'],
    ),
    'zh': _WordBuilderData(
      goal: '星光',
      target: ['星', '光'],
      tiles: ['光', '星'],
    ),
  };
}
