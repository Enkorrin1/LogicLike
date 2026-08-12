import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberBridgeReasoningGameView extends StatefulWidget {
  const NumberBridgeReasoningGameView({
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
  State<NumberBridgeReasoningGameView> createState() =>
      _NumberBridgeReasoningGameViewState();
}

class _NumberBridgeReasoningGameViewState
    extends State<NumberBridgeReasoningGameView> with TickerProviderStateMixin {
  static const _rounds = <_NumberBridgeRound>[
    _NumberBridgeRound(
      fixed: [1, 2],
      expected: [3, 4, 5],
      choices: [3, 5, 4, 2, 6],
    ),
    _NumberBridgeRound(
      fixed: [10, 8],
      expected: [6, 4, 2],
      choices: [2, 7, 6, 4, 5],
    ),
    _NumberBridgeRound(
      fixed: [1, 2],
      expected: [4, 8, 16],
      choices: [8, 6, 16, 4, 12],
    ),
  ];

  final List<int?> _slots = List.filled(3, null);
  late final AnimationController _reaction;
  late final AnimationController _success;
  late final AnimationController _transition;
  int _roundIndex = 0;
  int? _selectedValue;
  int _failedSlot = -1;
  bool _collapsing = false;
  bool _solved = false;
  bool _answerSent = false;

  _NumberBridgeRound get _round => _rounds[_roundIndex];

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _transition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    _success.dispose();
    _transition.dispose();
    super.dispose();
  }

  void _select(int value) {
    if (_collapsing || _solved || _slots.contains(value)) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedValue = _selectedValue == value ? null : value);
  }

  Future<void> _drop(int slot, int value) async {
    if (_collapsing || _solved || _slots.contains(value)) return;
    if (_slots[slot] != null) return;

    setState(() {
      _slots[slot] = value;
      _selectedValue = null;
    });

    if (_round.expected[slot] != value) {
      setState(() {
        _failedSlot = slot;
        _collapsing = true;
      });
      HapticFeedback.heavyImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() {
        _slots.fillRange(0, _slots.length, null);
        _failedSlot = -1;
        _collapsing = false;
      });
      _reaction.reset();
      return;
    }

    HapticFeedback.selectionClick();
    if (_slots.any((placed) => placed == null)) return;

    setState(() => _solved = true);
    HapticFeedback.mediumImpact();
    await _success.forward(from: 0);
    if (!mounted) return;

    if (_roundIndex == _rounds.length - 1) {
      if (_answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
      return;
    }

    await _transition.forward(from: 0);
    if (!mounted) return;
    setState(() {
      _roundIndex += 1;
      _slots.fillRange(0, _slots.length, null);
      _selectedValue = null;
      _solved = false;
    });
    _success.reset();
    await _transition.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    return _SceneFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _BoardLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_reaction, _success, _transition]),
                builder: (context, child) => CustomPaint(
                  painter: _BridgePainter(
                    accent: widget.accent,
                    round: _round,
                    roundIndex: _roundIndex,
                    roundCount: _rounds.length,
                    slots: _slots,
                    failedSlot: _failedSlot,
                    collapse: _reaction.value,
                    success: _success.value,
                    transition: _transition.value,
                    solved: _solved,
                  ),
                ),
              ),
              for (var i = 0; i < 3; i++)
                Positioned.fromRect(
                  rect: layout.rect(155 + i * 58, 82, 50, 58),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (details) =>
                        !_collapsing &&
                        !_solved &&
                        _slots[i] == null &&
                        !_slots.contains(details.data),
                    onAcceptWithDetails: (details) => _drop(i, details.data),
                    builder: (_, candidates, __) => Semantics(
                      button: true,
                      label: '${widget.semanticLabel} ${i + 1}',
                      onTap: _selectedValue == null
                          ? null
                          : () => _drop(i, _selectedValue!),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _selectedValue == null
                            ? null
                            : () => _drop(i, _selectedValue!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: candidates.isEmpty
                                ? null
                                : Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              for (var i = 0; i < _round.choices.length; i++)
                if (!_slots.contains(_round.choices[i]))
                  Positioned.fromRect(
                    rect: layout.rect(35 + i * 58, 172, 50, 50),
                    child: _BridgeNumberDraggable(
                      key: ValueKey(
                        'number-bridge-$_roundIndex-${_round.choices[i]}',
                      ),
                      value: _round.choices[i],
                      accent: widget.accent,
                      enabled: !_collapsing && !_solved,
                      selected: _selectedValue == _round.choices[i],
                      onTap: () => _select(_round.choices[i]),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _NumberBridgeRound {
  const _NumberBridgeRound({
    required this.fixed,
    required this.expected,
    required this.choices,
  });

  final List<int> fixed;
  final List<int> expected;
  final List<int> choices;
}

class _BridgeNumberDraggable extends StatelessWidget {
  const _BridgeNumberDraggable({
    required this.value,
    required this.accent,
    required this.enabled,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final int value;
  final Color accent;
  final bool enabled;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tile = AnimatedScale(
      scale: selected ? 1.1 : 1,
      duration: const Duration(milliseconds: 150),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: .55),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : const [],
        ),
        child: _PaintTile(value: value, accent: accent),
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: '$value',
      onTap: enabled ? onTap : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Draggable<int>(
          data: value,
          maxSimultaneousDrags: enabled ? 1 : 0,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox.square(dimension: 52, child: tile),
          ),
          childWhenDragging: Opacity(opacity: .18, child: tile),
          child: tile,
        ),
      ),
    );
  }
}

class StarBalanceReasoningGameView extends StatefulWidget {
  const StarBalanceReasoningGameView({
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
  State<StarBalanceReasoningGameView> createState() =>
      _StarBalanceReasoningGameViewState();
}

class _StarBalanceReasoningGameViewState
    extends State<StarBalanceReasoningGameView> with TickerProviderStateMixin {
  static const _rounds = <_BalanceRound>[
    _BalanceRound([1, 1, 2, 2, 3, 3]),
    _BalanceRound([1, 2, 2, 3, 4, 4]),
    _BalanceRound([2, 3, 3, 4, 5, 7]),
  ];

  final Map<int, _BalanceSide> _placements = {};
  late final AnimationController _motion;
  late final AnimationController _error;
  late final AnimationController _success;
  double _fromTilt = 0;
  double _tilt = 0;
  int _roundIndex = 0;
  bool _solved = false;
  bool _answerSent = false;

  _BalanceRound get _round => _rounds[_roundIndex];

  List<int> get _left => _idsOn(_BalanceSide.left);
  List<int> get _right => _idsOn(_BalanceSide.right);

  List<int> _idsOn(_BalanceSide side) => [
        for (var id = 0; id < _round.weights.length; id++)
          if (_placements[id] == side) id,
      ];

  int _total(_BalanceSide side) =>
      _idsOn(side).fold(0, (total, id) => total + _round.weights[id]);

  @override
  void initState() {
    super.initState();
    _motion = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _motion.dispose();
    _error.dispose();
    _success.dispose();
    super.dispose();
  }

  double get _animatedTilt =>
      _fromTilt +
      (_tilt - _fromTilt) * Curves.easeOutBack.transform(_motion.value);

  Future<void> _move(int star, _BalanceSide? side) async {
    if (_solved || _placements[star] == side) return;
    _fromTilt = _animatedTilt;
    setState(() {
      if (side == null) {
        _placements.remove(star);
      } else {
        _placements[star] = side;
      }
      _tilt = ((_total(_BalanceSide.right) - _total(_BalanceSide.left)) * 0.036)
          .clamp(-0.34, 0.34);
    });
    HapticFeedback.selectionClick();
    _motion.forward(from: 0);
    if (_placements.length != _round.weights.length) return;

    if (_total(_BalanceSide.left) != _total(_BalanceSide.right)) {
      HapticFeedback.lightImpact();
      await _error.forward(from: 0);
      if (!mounted) return;
      _error.reset();
      return;
    }

    setState(() {
      _solved = true;
      _fromTilt = _animatedTilt;
      _tilt = 0;
    });
    HapticFeedback.mediumImpact();
    _motion.forward(from: 0);
    await _success.forward(from: 0);
    if (!mounted) return;

    if (_roundIndex < _rounds.length - 1) {
      await Future<void>.delayed(const Duration(milliseconds: 220));
      if (!mounted) return;
      setState(() {
        _roundIndex += 1;
        _placements.clear();
        _fromTilt = 0;
        _tilt = 0;
        _solved = false;
      });
      _motion.reset();
      _success.reset();
      return;
    }

    if (_answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  void _tapStar(int star) {
    final current = _placements[star];
    final next = switch (current) {
      null => _BalanceSide.left,
      _BalanceSide.left => _BalanceSide.right,
      _BalanceSide.right => null,
    };
    _move(star, next);
  }

  Rect _starRect(_BoardLayout layout, int id) {
    final side = _placements[id];
    if (side == null) {
      return _minimumTouchRect(layout.rect(29 + id * 50, 187, 46, 46));
    }
    final ids = _idsOn(side);
    final index = ids.indexOf(id);
    final baseX = side == _BalanceSide.left ? 26.0 : 206.0;
    final sideTotal = _total(side);
    final oppositeTotal = _total(
        side == _BalanceSide.left ? _BalanceSide.right : _BalanceSide.left);
    final drop = ((sideTotal - oppositeTotal) * 1.2).clamp(-11, 11).toDouble();
    return _minimumTouchRect(
      layout.rect(
        baseX + (index % 3) * 42,
        105 + (index ~/ 3) * 36 + drop,
        46,
        46,
      ),
    );
  }

  Rect _minimumTouchRect(Rect rect) => Rect.fromCenter(
        center: rect.center,
        width: math.max(44, rect.width),
        height: math.max(44, rect.height),
      );

  @override
  Widget build(BuildContext context) {
    return _SceneFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _BoardLayout(constraints.biggest);
          return Stack(
            key: ValueKey(
              'star-balance-state-$_roundIndex-'
              '${_total(_BalanceSide.left)}-'
              '${_total(_BalanceSide.right)}-${_placements.length}',
            ),
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_motion, _error, _success]),
                builder: (_, __) => CustomPaint(
                  painter: _BalancePainter(
                    accent: widget.accent,
                    leftTotal: _total(_BalanceSide.left),
                    rightTotal: _total(_BalanceSide.right),
                    tilt: _animatedTilt,
                    error: _error.value,
                    success: _success.value,
                    round: _roundIndex,
                    rounds: _rounds.length,
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: layout.rect(10, 78, 160, 105),
                child: Semantics(
                  label: '${widget.semanticLabel} ◀',
                  child: DragTarget<int>(
                    key: const ValueKey('star-balance-left'),
                    onWillAcceptWithDetails: (_) => !_solved,
                    onAcceptWithDetails: (details) =>
                        _move(details.data, _BalanceSide.left),
                    builder: (_, candidates, __) => ColoredBox(
                      color: candidates.isEmpty
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: layout.rect(190, 78, 160, 105),
                child: Semantics(
                  label: '${widget.semanticLabel} ▶',
                  child: DragTarget<int>(
                    key: const ValueKey('star-balance-right'),
                    onWillAcceptWithDetails: (_) => !_solved,
                    onAcceptWithDetails: (details) =>
                        _move(details.data, _BalanceSide.right),
                    builder: (_, candidates, __) => ColoredBox(
                      color: candidates.isEmpty
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: layout.rect(14, 181, 332, 58),
                child: Semantics(
                  label: '${widget.semanticLabel} ↩',
                  child: DragTarget<int>(
                    key: const ValueKey('star-balance-tray'),
                    onWillAcceptWithDetails: (_) => !_solved,
                    onAcceptWithDetails: (details) => _move(details.data, null),
                    builder: (_, candidates, __) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: candidates.isEmpty
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              for (var id = 0; id < _round.weights.length; id++)
                Positioned.fromRect(
                  rect: _starRect(layout, id),
                  child: _BalanceStarPiece(
                    key: ValueKey('star-balance-star-$_roundIndex-$id'),
                    id: id,
                    weight: _round.weights[id],
                    accent: widget.accent,
                    semanticLabel: widget.semanticLabel,
                    enabled: !_solved,
                    onTap: () => _tapStar(id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

enum _BalanceSide { left, right }

class _BalanceRound {
  const _BalanceRound(this.weights);

  final List<int> weights;
}

class NumberNeighborsReasoningGameView extends StatefulWidget {
  const NumberNeighborsReasoningGameView({
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
  State<NumberNeighborsReasoningGameView> createState() =>
      _NumberNeighborsReasoningGameViewState();
}

class _NumberNeighborsReasoningGameViewState
    extends State<NumberNeighborsReasoningGameView>
    with TickerProviderStateMixin {
  static const _rounds = <_NeighborRound>[
    _NeighborRound(fixed: {0: 5, 2: 7, 4: 9}, missing: {1: 6, 3: 8}),
    _NeighborRound(fixed: {0: 2, 2: 4, 4: 6}, missing: {1: 3, 3: 5}),
    _NeighborRound(fixed: {0: 8, 2: 10, 4: 12}, missing: {1: 9, 3: 11}),
  ];

  final Map<int, int> _placed = {};
  late final AnimationController _error;
  late final AnimationController _success;
  int _errorSlot = -1;
  int _roundIndex = 0;
  bool _solved = false;
  bool _answerSent = false;

  _NeighborRound get _round => _rounds[_roundIndex];

  @override
  void initState() {
    super.initState();
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _drop(int slot, int value) async {
    if (_solved || _placed.containsValue(value)) return;
    final expected = _round.missing[slot];
    if (value != expected) {
      setState(() => _errorSlot = slot);
      HapticFeedback.lightImpact();
      await _error.forward(from: 0);
      if (!mounted) return;
      setState(() => _errorSlot = -1);
      _error.reset();
      return;
    }
    setState(() => _placed[slot] = value);
    HapticFeedback.selectionClick();
    if (_placed.length != 2) return;
    setState(() => _solved = true);
    HapticFeedback.mediumImpact();
    await _success.forward(from: 0);
    if (!mounted) return;

    if (_roundIndex < _rounds.length - 1) {
      await Future<void>.delayed(const Duration(milliseconds: 260));
      if (!mounted) return;
      setState(() {
        _roundIndex += 1;
        _placed.clear();
        _errorSlot = -1;
        _solved = false;
      });
      _success.reset();
      return;
    }

    if (_answerSent) return;
    _answerSent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return _SceneFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _BoardLayout(constraints.biggest);
          const missingSlots = [1, 3];
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_error, _success]),
                builder: (_, __) => CustomPaint(
                  painter: _NeighborsPainter(
                    accent: widget.accent,
                    fixed: _round.fixed,
                    placed: _placed,
                    errorSlot: _errorSlot,
                    error: _error.value,
                    success: _success.value,
                    round: _roundIndex,
                    rounds: _rounds.length,
                  ),
                ),
              ),
              for (final slot in missingSlots)
                Positioned.fromRect(
                  rect: layout.rect(38 + slot * 58, 88, 52, 70),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (_) =>
                        !_solved && !_placed.containsKey(slot),
                    onAcceptWithDetails: (details) => _drop(slot, details.data),
                    builder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
              for (final value in _round.missing.values.toList().reversed)
                if (!_placed.containsValue(value))
                  Positioned.fromRect(
                    rect: layout.rect(
                      value == _round.missing[3] ? 116 : 198,
                      184,
                      50,
                      50,
                    ),
                    child: _NumberDraggable(
                      key: ValueKey('number-neighbors-$_roundIndex-$value'),
                      value: value,
                      accent: widget.accent,
                      enabled: !_solved,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _NeighborRound {
  const _NeighborRound({required this.fixed, required this.missing});

  final Map<int, int> fixed;
  final Map<int, int> missing;
}

class _SceneFrame extends StatelessWidget {
  const _SceneFrame({
    required this.compact,
    required this.semanticLabel,
    required this.child,
  });

  final bool compact;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: compact ? 216 : 246,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BoardLayout {
  _BoardLayout(this.size)
      : scale = math.min(size.width / 360, size.height / 240),
        origin = Offset(
          (size.width - 360 * math.min(size.width / 360, size.height / 240)) /
              2,
          (size.height - 240 * math.min(size.width / 360, size.height / 240)) /
              2,
        );

  final Size size;
  final double scale;
  final Offset origin;

  Rect rect(double x, double y, double width, double height) => Rect.fromLTWH(
        origin.dx + x * scale,
        origin.dy + y * scale,
        width * scale,
        height * scale,
      );
}

class _NumberDraggable extends StatelessWidget {
  const _NumberDraggable({
    super.key,
    required this.value,
    required this.accent,
    required this.enabled,
  });

  final int value;
  final Color accent;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tile = _PaintTile(value: value, accent: accent);
    return Semantics(
      label: '$value',
      child: Draggable<int>(
        data: value,
        maxSimultaneousDrags: enabled ? 1 : 0,
        feedback: Material(
            color: Colors.transparent,
            child: SizedBox.fromSize(size: const Size.square(52), child: tile)),
        childWhenDragging: Opacity(opacity: 0.2, child: tile),
        child: tile,
      ),
    );
  }
}

class _PaintTile extends StatelessWidget {
  const _PaintTile({required this.value, required this.accent});
  final int value;
  final Color accent;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _TilePainter(value: value, accent: accent),
      );
}

class _BalanceStarPiece extends StatelessWidget {
  const _BalanceStarPiece({
    super.key,
    required this.id,
    required this.weight,
    required this.accent,
    required this.semanticLabel,
    required this.enabled,
    required this.onTap,
  });

  final int id;
  final int weight;
  final Color accent;
  final String semanticLabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget star() => CustomPaint(
          painter: _StarPainter(accent: accent, weight: weight),
        );

    return Semantics(
      button: true,
      enabled: enabled,
      label: '$semanticLabel $weight',
      onTap: enabled ? onTap : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Draggable<int>(
          data: id,
          maxSimultaneousDrags: enabled ? 1 : 0,
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox.square(dimension: 52, child: star()),
          ),
          childWhenDragging: Opacity(opacity: 0.15, child: star()),
          child: star(),
        ),
      ),
    );
  }
}

abstract class _BoardPainter extends CustomPainter {
  const _BoardPainter();

  void begin(Canvas canvas, Size size, List<Color> colors) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ).createShader(Offset.zero & size),
    );
    final scale = math.min(size.width / 360, size.height / 240);
    canvas.save();
    canvas.translate(
        (size.width - 360 * scale) / 2, (size.height - 240 * scale) / 2);
    canvas.scale(scale);
  }

  void number(
      Canvas canvas, int value, Offset center, double size, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: '$value',
        style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w900,
            color: color,
            height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  Path starPath(Offset center, double outer) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? outer : outer * 0.46;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final p = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }
}

class _BridgePainter extends _BoardPainter {
  const _BridgePainter({
    required this.accent,
    required this.round,
    required this.roundIndex,
    required this.roundCount,
    required this.slots,
    required this.failedSlot,
    required this.collapse,
    required this.success,
    required this.transition,
    required this.solved,
  });

  final Color accent;
  final _NumberBridgeRound round;
  final int roundIndex;
  final int roundCount;
  final List<int?> slots;
  final int failedSlot;
  final double collapse;
  final double success;
  final double transition;
  final bool solved;

  @override
  void paint(Canvas canvas, Size size) {
    final skies = <List<Color>>[
      const [Color(0xFFB8EDF1), Color(0xFF70C1CC)],
      const [Color(0xFFFFD68A), Color(0xFFE78B65)],
      const [Color(0xFF303D76), Color(0xFF161C42)],
    ];
    begin(canvas, size, skies[roundIndex]);
    canvas.saveLayer(
      const Rect.fromLTWH(0, 0, 360, 240),
      Paint()..color = Colors.white.withValues(alpha: 1 - transition),
    );
    canvas.translate(transition * (roundIndex.isEven ? -54 : 54), 0);

    switch (roundIndex) {
      case 0:
        _paintRiver(canvas);
      case 1:
        _paintCanyon(canvas);
      default:
        _paintNightLake(canvas);
    }

    _paintProgress(canvas);
    final values = <int?>[...round.fixed, ...slots];
    for (var i = 0; i < values.length; i++) {
      var center = Offset(51 + i * 58.0, 111);
      var angle = 0.0;
      final slot = i - round.fixed.length;
      if (slot >= 0 && slots[slot] != null && collapse > 0) {
        final fall = Curves.easeInCubic.transform(collapse);
        final distance = slot == failedSlot ? 92.0 : 64.0;
        center += Offset(
          math.sin(collapse * math.pi * 5 + slot) * 9,
          distance * fall,
        );
        angle = (slot.isEven ? -1 : 1) * fall * .62;
      }
      _stone(
        canvas,
        center,
        values[i],
        accent,
        solved ? success : 0,
        angle,
      );
    }
    if (solved) _paintCrossingCart(canvas, success);
    canvas.restore();
    canvas.restore();
  }

  void _paintRiver(Canvas canvas) {
    canvas.drawRect(
      const Rect.fromLTWH(0, 137, 360, 103),
      Paint()..color = const Color(0xFF28718C),
    );
    for (var i = 0; i < 8; i++) {
      canvas.drawArc(
        Rect.fromLTWH((i * 53) % 330.0, 151 + i * 12.0, 42, 8),
        0,
        math.pi,
        false,
        Paint()
          ..color = Colors.white.withValues(alpha: .2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    _bank(canvas, const Rect.fromLTWH(0, 108, 35, 57));
    _bank(canvas, const Rect.fromLTWH(325, 108, 35, 57));
  }

  void _paintCanyon(Canvas canvas) {
    final canyon = Path()
      ..moveTo(0, 132)
      ..lineTo(82, 132)
      ..lineTo(124, 240)
      ..lineTo(236, 240)
      ..lineTo(278, 132)
      ..lineTo(360, 132)
      ..lineTo(360, 240)
      ..lineTo(0, 240)
      ..close();
    canvas.drawPath(canyon, Paint()..color = const Color(0xFF8F493E));
    canvas.drawRect(
      const Rect.fromLTWH(0, 132, 82, 12),
      Paint()..color = const Color(0xFFD1754D),
    );
    canvas.drawRect(
      const Rect.fromLTWH(278, 132, 82, 12),
      Paint()..color = const Color(0xFFD1754D),
    );
    for (final x in [34.0, 326.0]) {
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, 74), width: 9, height: 92),
        Paint()..color = const Color(0xFF704139),
      );
    }
    final cable = Paint()
      ..color = const Color(0xFF54363A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(
      Path()
        ..moveTo(34, 45)
        ..quadraticBezierTo(180, 136, 326, 45),
      cable,
    );
    for (var i = 0; i < 5; i++) {
      final x = 51 + i * 58.0;
      canvas.drawLine(Offset(x, 81), Offset(x, 94), cable);
    }
  }

  void _paintNightLake(Canvas canvas) {
    for (var i = 0; i < 16; i++) {
      canvas.drawCircle(
        Offset(16 + (i * 47) % 338, 15 + (i * 29) % 64),
        i.isEven ? 1.7 : 1.1,
        Paint()..color = Colors.white.withValues(alpha: .72),
      );
    }
    canvas.drawCircle(
      const Offset(306, 38),
      17,
      Paint()..color = const Color(0xFFFFE58A),
    );
    canvas.drawRect(
      const Rect.fromLTWH(0, 137, 360, 103),
      Paint()..color = const Color(0xFF202E63),
    );
    final truss = Paint()
      ..color = const Color(0xFF66D3D0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawPath(
      Path()
        ..moveTo(30, 137)
        ..lineTo(83, 74)
        ..lineTo(141, 137)
        ..lineTo(199, 74)
        ..lineTo(257, 137)
        ..lineTo(326, 70),
      truss,
    );
    _bank(canvas, const Rect.fromLTWH(0, 111, 34, 54));
    _bank(canvas, const Rect.fromLTWH(326, 111, 34, 54));
  }

  void _bank(Canvas canvas, Rect rect) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..color = const Color(0xFF4E8B58),
    );
  }

  void _paintProgress(Canvas canvas) {
    for (var i = 0; i < roundCount; i++) {
      final completed = i < roundIndex || (i == roundIndex && solved);
      canvas.drawCircle(
        Offset(164 + i * 16, 25),
        completed ? 5.5 : 4,
        Paint()
          ..color = completed
              ? const Color(0xFFFFD75E)
              : Colors.white.withValues(alpha: .58),
      );
    }
  }

  void _paintCrossingCart(Canvas canvas, double t) {
    final eased = Curves.easeInOutCubic.transform(t);
    final x = -24 + eased * 410;
    final bounce = math.sin(eased * math.pi * 8) * 2.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, 74 + bounce),
          width: 42,
          height: 24,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFFFC85C),
    );
    canvas.drawCircle(
      Offset(x - 12, 88 + bounce),
      6,
      Paint()..color = const Color(0xFF263449),
    );
    canvas.drawCircle(
      Offset(x + 12, 88 + bounce),
      6,
      Paint()..color = const Color(0xFF263449),
    );
  }

  void _stone(
    Canvas canvas,
    Offset c,
    int? value,
    Color accent,
    double glow,
    double angle,
  ) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    final rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-25, -21.5, 50, 43),
      const Radius.circular(16),
    );
    canvas.drawShadow(Path()..addRRect(rect), Colors.black, 5, false);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = value == null
            ? Colors.white.withValues(alpha: .2)
            : Color.lerp(
                const Color(0xFFE9EFF0),
                accent,
                .18 + glow * .3,
              )!,
    );
    if (value != null) {
      number(canvas, value, Offset.zero, 25, const Color(0xFF173A4B));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BridgePainter old) => true;
}

class _BalancePainter extends _BoardPainter {
  const _BalancePainter({
    required this.accent,
    required this.leftTotal,
    required this.rightTotal,
    required this.tilt,
    required this.error,
    required this.success,
    required this.round,
    required this.rounds,
  });

  final Color accent;
  final int leftTotal;
  final int rightTotal;
  final double tilt;
  final double error;
  final double success;
  final int round;
  final int rounds;

  @override
  void paint(Canvas canvas, Size size) {
    begin(canvas, size, const [Color(0xFF18385B), Color(0xFF3C7181)]);
    for (var i = 0; i < 12; i++) {
      canvas.drawCircle(Offset(18 + i * 31, 22 + (i * 37) % 54), 1.4,
          Paint()..color = Colors.white.withValues(alpha: 0.45));
    }
    for (var index = 0; index < rounds; index++) {
      final completed = index < round || (index == round && success > .7);
      canvas.drawCircle(
        Offset(164 + index * 16, 24),
        completed ? 5.5 : 4,
        Paint()
          ..color = completed
              ? const Color(0xFFFFD75E)
              : Colors.white.withValues(alpha: .5),
      );
    }
    final shake = math.sin(error * math.pi * 8) * 4;
    canvas.save();
    canvas.translate(180 + shake, 119);
    canvas.rotate(tilt + math.sin(error * math.pi * 6) * .025);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-135, -5, 270, 10), const Radius.circular(5)),
        Paint()
          ..color = Color.lerp(
            const Color(0xFFE3B661),
            const Color(0xFFFF6675),
            error,
          )!);
    _bowl(canvas, const Offset(-105, 30), leftTotal);
    _bowl(canvas, const Offset(105, 30), rightTotal);
    canvas.restore();
    canvas.drawPath(
        Path()
          ..moveTo(180, 109)
          ..lineTo(151, 184)
          ..lineTo(209, 184)
          ..close(),
        Paint()..color = const Color(0xFFDFC06F));
    canvas.drawOval(const Rect.fromLTWH(132, 179, 96, 13),
        Paint()..color = const Color(0xFFB58A43));
    number(canvas, leftTotal, const Offset(74, 77), 20, Colors.white);
    number(canvas, rightTotal, const Offset(286, 77), 20, Colors.white);
    final equals = TextPainter(
      text: TextSpan(
        text: '=',
        style: TextStyle(
          color: error > 0
              ? const Color(0xFFFF7A86)
              : Colors.white.withValues(alpha: .9),
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    equals.paint(canvas, Offset(180 - equals.width / 2, 62));
    if (success > 0) {
      canvas.drawCircle(const Offset(180, 112), 22 + success * 15,
          Paint()..color = accent.withValues(alpha: (1 - success) * 0.3));
    }
    canvas.restore();
  }

  void _bowl(Canvas canvas, Offset center, int total) {
    canvas.drawLine(
        Offset(center.dx, -1),
        center,
        Paint()
          ..color = const Color(0xFFE9DDA8)
          ..strokeWidth = 2);
    final bowl = Path()
      ..moveTo(center.dx - 58, center.dy)
      ..quadraticBezierTo(center.dx, center.dy + 48, center.dx + 58, center.dy)
      ..close();
    canvas.drawPath(
      bowl,
      Paint()
        ..color = Color.lerp(
          const Color(0xFF74B9BE),
          const Color(0xFFFF8A94),
          error * .45,
        )!,
    );
  }

  @override
  bool shouldRepaint(covariant _BalancePainter old) => true;
}

class _NeighborsPainter extends _BoardPainter {
  const _NeighborsPainter(
      {required this.accent,
      required this.fixed,
      required this.placed,
      required this.errorSlot,
      required this.error,
      required this.success,
      required this.round,
      required this.rounds});
  final Color accent;
  final Map<int, int> fixed;
  final Map<int, int> placed;
  final int errorSlot;
  final double error;
  final double success;
  final int round;
  final int rounds;

  @override
  void paint(Canvas canvas, Size size) {
    begin(canvas, size, const [Color(0xFFB9E4E0), Color(0xFF70B5A5)]);
    canvas.drawRect(const Rect.fromLTWH(0, 160, 360, 80),
        Paint()..color = const Color(0xFF468677));
    canvas.drawLine(
        const Offset(18, 174),
        const Offset(342, 174),
        Paint()
          ..color = const Color(0xFF394F51)
          ..strokeWidth = 5);
    canvas.drawLine(
        const Offset(18, 205),
        const Offset(342, 205),
        Paint()
          ..color = const Color(0xFF394F51)
          ..strokeWidth = 5);
    for (var slot = 0; slot < 5; slot++) {
      final value = fixed[slot] ?? placed[slot];
      var x = 64 + slot * 58.0;
      if (slot == errorSlot) x += math.sin(error * math.pi * 6) * 6;
      final body = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, 123), width: 52, height: 62),
          const Radius.circular(8));
      canvas.drawShadow(Path()..addRRect(body), Colors.black, 5, false);
      canvas.drawRRect(
          body,
          Paint()
            ..color = value == null
                ? Colors.white.withValues(alpha: 0.32)
                : Color.lerp(const Color(0xFFFFE58B), accent, success * 0.28)!);
      canvas.drawCircle(
          Offset(x - 15, 159), 7, Paint()..color = const Color(0xFF324B55));
      canvas.drawCircle(
          Offset(x + 15, 159), 7, Paint()..color = const Color(0xFF324B55));
      if (value != null) {
        number(canvas, value, Offset(x, 119), 27, const Color(0xFF244653));
      }
    }
    for (var index = 0; index < rounds; index++) {
      final completed = index < round || (index == round && success > .7);
      canvas.drawCircle(
        Offset(164 + index * 16, 31),
        completed ? 5.5 : 4,
        Paint()
          ..color = completed
              ? const Color(0xFFFFD75E)
              : Colors.white.withValues(alpha: .55),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NeighborsPainter old) => true;
}

class _TilePainter extends _BoardPainter {
  const _TilePainter({required this.value, required this.accent});
  final int value;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
        Offset.zero & size, Radius.circular(size.shortestSide * 0.3));
    canvas.drawShadow(Path()..addRRect(rect), Colors.black45, 6, false);
    canvas.drawRRect(
        rect, Paint()..color = Color.lerp(Colors.white, accent, 0.2)!);
    final painter = TextPainter(
        text: TextSpan(
            text: '$value',
            style: TextStyle(
                fontSize: size.shortestSide * 0.55,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF203E4B),
                height: 1)),
        textDirection: TextDirection.ltr)
      ..layout();
    painter.paint(
        canvas,
        Offset((size.width - painter.width) / 2,
            (size.height - painter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant _TilePainter old) =>
      old.value != value || old.accent != accent;
}

class _StarPainter extends _BoardPainter {
  const _StarPainter({required this.accent, required this.weight});

  final Color accent;
  final int weight;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final path = starPath(center, size.shortestSide * 0.46);
    canvas.drawShadow(path, Colors.black45, 5, false);
    canvas.drawPath(path,
        Paint()..color = Color.lerp(const Color(0xFFFFD75E), accent, 0.12)!);
    number(
      canvas,
      weight,
      center.translate(0, -1),
      size.shortestSide * .34,
      const Color(0xFF493D55),
    );
    final dotCount = math.min(weight, 7);
    final startX = center.dx - (dotCount - 1) * 2.25;
    for (var index = 0; index < dotCount; index++) {
      canvas.drawCircle(
        Offset(startX + index * 4.5, center.dy + size.shortestSide * .22),
        1.35,
        Paint()..color = const Color(0xFF725A5E),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) =>
      old.accent != accent || old.weight != weight;
}
