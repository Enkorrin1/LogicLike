import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotebookSumWorkshopGameView extends StatefulWidget {
  const NotebookSumWorkshopGameView({
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
  State<NotebookSumWorkshopGameView> createState() =>
      _NotebookSumWorkshopGameViewState();
}

class _NotebookSumWorkshopGameViewState
    extends State<NotebookSumWorkshopGameView> {
  static const _rounds = <_NotebookRound>[
    _NotebookRound(
      top: 27,
      bottom: 18,
      solution: [1, 4, 5],
      tokens: [
        _DigitToken(0, 1),
        _DigitToken(1, 4),
        _DigitToken(2, 5),
        _DigitToken(3, 3),
        _DigitToken(4, 6),
      ],
    ),
    _NotebookRound(
      top: 46,
      bottom: 27,
      solution: [1, 7, 3],
      tokens: [
        _DigitToken(0, 1),
        _DigitToken(1, 7),
        _DigitToken(2, 3),
        _DigitToken(3, 6),
        _DigitToken(4, 9),
      ],
    ),
    _NotebookRound(
      top: 35,
      bottom: 49,
      solution: [1, 8, 4],
      tokens: [
        _DigitToken(0, 1),
        _DigitToken(1, 8),
        _DigitToken(2, 4),
        _DigitToken(3, 7),
        _DigitToken(4, 5),
      ],
    ),
  ];
  final List<_DigitToken?> _slots = List.filled(3, null);
  int _round = 0;
  int? _wrongSlot;
  bool _pageSolved = false;
  bool _complete = false;
  bool _sent = false;

  _NotebookRound get _current => _rounds[_round];

  void _drop(int slot, _DigitToken token) {
    if (_pageSolved ||
        _complete ||
        _slots.any((item) => item?.id == token.id)) {
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _slots[slot] = token;
      _wrongSlot = null;
    });
    if (_slots.every((item) => item != null)) _validate();
  }

  void _tapDigit(_DigitToken token) {
    final slot = _slots.indexOf(null);
    if (slot >= 0) _drop(slot, token);
  }

  void _remove(int slot) {
    if (_pageSolved || _complete || _slots[slot] == null) return;
    HapticFeedback.selectionClick();
    setState(() {
      _slots[slot] = null;
      _wrongSlot = null;
    });
  }

  void _validate() {
    final wrong = List.generate(3, (index) => index)
        .where((index) => _slots[index]!.value != _current.solution[index])
        .firstOrNull;
    if (wrong != null) {
      final failedRound = _round;
      HapticFeedback.lightImpact();
      setState(() => _wrongSlot = wrong);
      Timer(const Duration(milliseconds: 480), () {
        if (!mounted || _complete || _round != failedRound) return;
        setState(() {
          _slots[wrong] = null;
          _wrongSlot = null;
        });
      });
      return;
    }
    _finishPage();
  }

  void _finishPage() {
    if (_pageSolved || _complete) return;
    final solvedRound = _round;
    HapticFeedback.mediumImpact();
    setState(() => _pageSolved = true);
    Timer(const Duration(milliseconds: 700), () {
      if (!mounted || _round != solvedRound) return;
      if (_round < _rounds.length - 1) {
        setState(() {
          _round += 1;
          _slots.fillRange(0, _slots.length, null);
          _wrongSlot = null;
          _pageSolved = false;
        });
        return;
      }
      setState(() => _complete = true);
      if (_sent) return;
      _sent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      accent: widget.accent,
      complete: _complete,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        transitionBuilder: (child, animation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(.24, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Stack(
          key: ValueKey('notebook-page-$_round'),
          children: [
            const Positioned.fill(child: CustomPaint(painter: _PaperPainter())),
            Positioned(
              left: 48,
              top: 8,
              child: Text(
                '${_round + 1}/${_rounds.length}',
                style: TextStyle(
                  color: widget.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Positioned(
              left: 48,
              top: 30,
              width: 210,
              height: 158,
              child: _VerticalSum(
                round: _round,
                top: _current.top,
                bottom: _current.bottom,
                accent: widget.accent,
                semanticLabel: widget.semanticLabel,
                slots: _slots,
                wrongSlot: _wrongSlot,
                complete: _pageSolved || _complete,
                onDrop: _drop,
                onRemove: _remove,
              ),
            ),
            Positioned(
              right: 10,
              top: 27,
              width: 92,
              height: 158,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 8,
                children: _current.tokens
                    .where((token) =>
                        !_slots.any((placed) => placed?.id == token.id))
                    .map(
                      (token) => _DraggableDigit(
                        key: ValueKey('notebook-digit-$_round-${token.id}'),
                        token: token,
                        accent: widget.accent,
                        semanticLabel: widget.semanticLabel,
                        enabled: !_pageSolved && !_complete,
                        onTap: () => _tapDigit(token),
                      ),
                    )
                    .toList(),
              ),
            ),
            Positioned(
              left: 48,
              bottom: 10,
              child: _ProgressMarks(
                count: _rounds.length,
                active: _round + (_pageSolved ? 1 : 0),
                accent: widget.accent,
              ),
            ),
            if (_pageSolved)
              Positioned(
                right: 18,
                bottom: 10,
                child: Text(
                  String.fromCharCode(0x2713),
                  style: TextStyle(
                    color: widget.accent,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotebookRound {
  const _NotebookRound({
    required this.top,
    required this.bottom,
    required this.solution,
    required this.tokens,
  });

  final int top;
  final int bottom;
  final List<int> solution;
  final List<_DigitToken> tokens;
}

class MathCrosswordWorkshopGameView extends StatefulWidget {
  const MathCrosswordWorkshopGameView({
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
  State<MathCrosswordWorkshopGameView> createState() =>
      _MathCrosswordWorkshopGameViewState();
}

class _MathCrosswordWorkshopGameViewState
    extends State<MathCrosswordWorkshopGameView> {
  static const _solution = <int>[5, 3, 6];
  final List<int?> _values = List.filled(3, null);
  int _selected = 0;
  final Set<int> _wrong = {};
  bool _complete = false;
  bool _sent = false;

  void _enter(int value) {
    if (_complete) return;
    HapticFeedback.selectionClick();
    setState(() {
      _values[_selected] = value;
      _wrong.remove(_selected);
      final empty = _values.indexOf(null);
      if (empty >= 0) _selected = empty;
    });
    if (_values.every((value) => value != null)) _validate();
  }

  void _validate() {
    final invalid = <int>{};
    for (var i = 0; i < _solution.length; i++) {
      if (_values[i] != _solution[i]) invalid.add(i);
    }
    if (invalid.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _wrong.addAll(invalid));
      Timer(const Duration(milliseconds: 620), () {
        if (!mounted || _complete) return;
        setState(() {
          for (final index in invalid) {
            _values[index] = null;
          }
          _selected = invalid.first;
          _wrong.clear();
        });
      });
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _complete = true);
    Timer(const Duration(milliseconds: 650), () {
      if (!mounted || _sent) return;
      _sent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      accent: widget.accent,
      complete: _complete,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: _CrosswordBoard(
              values: _values,
              selected: _selected,
              wrong: _wrong,
              accent: widget.accent,
              complete: _complete,
              onDrop: _enter,
              onSelect: (index) {
                if (!_complete) setState(() => _selected = index);
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 18, 14, 18),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [2, 3, 4, 5, 6, 7]
                    .map(
                      (number) => _KeyButton(
                        key: ValueKey('math-crossword-crystal-$number'),
                        value: number,
                        accent: widget.accent,
                        enabled: !_complete,
                        onTap: () => _enter(number),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MarketChangeWorkshopGameView extends StatefulWidget {
  const MarketChangeWorkshopGameView({
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
  State<MarketChangeWorkshopGameView> createState() =>
      _MarketChangeWorkshopGameViewState();
}

class _MarketChangeWorkshopGameViewState
    extends State<MarketChangeWorkshopGameView> {
  static const _rounds = <_MarketRound>[
    _MarketRound(
      target: 12,
      product: 0,
      coins: [
        _Coin(0, 5),
        _Coin(1, 5),
        _Coin(2, 2),
        _Coin(3, 1),
      ],
    ),
    _MarketRound(
      target: 8,
      product: 1,
      coins: [
        _Coin(0, 4),
        _Coin(1, 3),
        _Coin(2, 2),
        _Coin(3, 1),
      ],
    ),
    _MarketRound(
      target: 14,
      product: 2,
      coins: [
        _Coin(0, 6),
        _Coin(1, 4),
        _Coin(2, 3),
        _Coin(3, 2),
        _Coin(4, 1),
      ],
    ),
  ];
  final List<_Coin> _tray = [];
  int _round = 0;
  bool _over = false;
  bool _serving = false;
  bool _complete = false;
  bool _sent = false;

  _MarketRound get _current => _rounds[_round];
  int get _sum => _tray.fold(0, (sum, coin) => sum + coin.value);

  void _add(_Coin coin) {
    if (_serving || _complete || _tray.any((item) => item.id == coin.id)) {
      return;
    }
    setState(() {
      _tray.add(coin);
      _over = _sum > _current.target;
    });
    HapticFeedback.selectionClick();
    if (_sum == _current.target) _finishPurchase();
  }

  void _remove(_Coin coin) {
    if (_serving || _complete) return;
    HapticFeedback.selectionClick();
    setState(() {
      _tray.removeWhere((item) => item.id == coin.id);
      _over = _sum > _current.target;
    });
    if (_sum == _current.target) _finishPurchase();
  }

  void _finishPurchase() {
    if (_serving || _complete) return;
    final finishedRound = _round;
    HapticFeedback.mediumImpact();
    setState(() {
      _serving = true;
      _over = false;
    });
    Timer(const Duration(milliseconds: 820), () {
      if (!mounted || _round != finishedRound) return;
      if (_round < _rounds.length - 1) {
        setState(() {
          _round += 1;
          _tray.clear();
          _over = false;
          _serving = false;
        });
        return;
      }
      setState(() => _complete = true);
      if (_sent) return;
      _sent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      accent: widget.accent,
      complete: _complete,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MarketPainter(accent: widget.accent),
            ),
          ),
          Positioned(
            left: 18,
            top: 18,
            child: _TargetBadge(
              key: ValueKey('market-target-$_round'),
              sum: _sum,
              target: _current.target,
              accent: widget.accent,
              over: _over,
              complete: _serving || _complete,
            ),
          ),
          Positioned(
            right: 24,
            top: 19,
            width: 68,
            height: 58,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeInBack,
              offset: _serving ? const Offset(1.8, .75) : Offset.zero,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 650),
                scale: _serving ? .72 : 1,
                child: _MarketProduct(
                  key: ValueKey('market-product-$_round'),
                  product: _current.product,
                  accent: widget.accent,
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 76,
            height: 78,
            child: DragTarget<_Coin>(
              key: ValueKey('market-tray-$_round'),
              onWillAcceptWithDetails: (details) =>
                  !_serving &&
                  !_complete &&
                  !_tray.any((coin) => coin.id == details.data.id),
              onAcceptWithDetails: (details) => _add(details.data),
              builder: (_, candidates, __) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: candidates.isNotEmpty
                      ? widget.accent.withValues(alpha: .22)
                      : Colors.white.withValues(alpha: .82),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _over
                        ? const Color(0xFFFF6B6B)
                        : widget.accent.withValues(alpha: .45),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _tray
                      .map(
                        (coin) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Semantics(
                            button: true,
                            label: '${widget.semanticLabel} ${coin.value}',
                            onTap: () => _remove(coin),
                            excludeSemantics: true,
                            child: GestureDetector(
                              key: ValueKey(
                                'market-tray-coin-$_round-${coin.id}',
                              ),
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _remove(coin),
                              child: _CoinFace(
                                coin: coin,
                                accent: widget.accent,
                                small: true,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 72,
            child: _ProgressMarks(
              count: _rounds.length,
              active: _round + (_serving ? 1 : 0),
              accent: widget.accent,
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 12,
            height: 50,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: Row(
                key: ValueKey('market-coins-$_round'),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _current.coins
                    .where((coin) => !_tray.any((item) => item.id == coin.id))
                    .map(
                      (coin) => _DraggableCoin(
                        key: ValueKey('market-coin-$_round-${coin.id}'),
                        coin: coin,
                        accent: widget.accent,
                        semanticLabel: widget.semanticLabel,
                        enabled: !_serving && !_complete,
                        onTap: () => _add(coin),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketRound {
  const _MarketRound({
    required this.target,
    required this.product,
    required this.coins,
  });

  final int target;
  final int product;
  final List<_Coin> coins;
}

class _WorkshopFrame extends StatelessWidget {
  const _WorkshopFrame({
    required this.compact,
    required this.semanticLabel,
    required this.accent,
    required this.complete,
    required this.child,
  });

  final bool compact;
  final String semanticLabel;
  final Color accent;
  final bool complete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: compact ? 218 : 250,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(accent, Colors.white, complete ? .72 : .86)!,
                const Color(0xFFF8FCFF),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: accent.withValues(alpha: complete ? .58 : .28),
              width: 2,
            ),
          ),
          child: LayoutBuilder(
            builder: (_, constraints) => FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(width: 360, height: 220, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _VerticalSum extends StatelessWidget {
  const _VerticalSum({
    required this.round,
    required this.top,
    required this.bottom,
    required this.accent,
    required this.semanticLabel,
    required this.slots,
    required this.wrongSlot,
    required this.complete,
    required this.onDrop,
    required this.onRemove,
  });

  final int round;
  final int top;
  final int bottom;
  final Color accent;
  final String semanticLabel;
  final List<_DigitToken?> slots;
  final int? wrongSlot;
  final bool complete;
  final void Function(int, _DigitToken) onDrop;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 22,
          top: 35,
          child: _InkNumber('$top'),
        ),
        const Positioned(left: 21, top: 71, child: _InkNumber('+')),
        Positioned(
          right: 22,
          top: 72,
          child: _InkNumber('$bottom'),
        ),
        Positioned(
          left: 18,
          right: 16,
          top: 108,
          child: Container(height: 3, color: const Color(0xFF274356)),
        ),
        Positioned(
          right: 67,
          top: 0,
          child: _DigitSlot(
            key: ValueKey('notebook-slot-$round-0'),
            slot: 0,
            token: slots[0],
            accent: accent,
            semanticLabel: semanticLabel,
            wrong: wrongSlot == 0,
            complete: complete,
            small: true,
            onDrop: onDrop,
            onRemove: onRemove,
          ),
        ),
        Positioned(
          right: 67,
          bottom: 0,
          child: _DigitSlot(
            key: ValueKey('notebook-slot-$round-1'),
            slot: 1,
            token: slots[1],
            accent: accent,
            semanticLabel: semanticLabel,
            wrong: wrongSlot == 1,
            complete: complete,
            onDrop: onDrop,
            onRemove: onRemove,
          ),
        ),
        Positioned(
          right: 17,
          bottom: 0,
          child: _DigitSlot(
            key: ValueKey('notebook-slot-$round-2'),
            slot: 2,
            token: slots[2],
            accent: accent,
            semanticLabel: semanticLabel,
            wrong: wrongSlot == 2,
            complete: complete,
            onDrop: onDrop,
            onRemove: onRemove,
          ),
        ),
      ],
    );
  }
}

class _DigitSlot extends StatelessWidget {
  const _DigitSlot({
    required this.slot,
    required this.token,
    required this.accent,
    required this.semanticLabel,
    required this.wrong,
    required this.complete,
    required this.onDrop,
    required this.onRemove,
    this.small = false,
    super.key,
  });

  final int slot;
  final _DigitToken? token;
  final Color accent;
  final String semanticLabel;
  final bool wrong;
  final bool complete;
  final void Function(int, _DigitToken) onDrop;
  final ValueChanged<int> onRemove;
  final bool small;

  @override
  Widget build(BuildContext context) {
    const side = 44.0;
    return Semantics(
      label: '$semanticLabel ${slot + 1}',
      button: token != null && !complete,
      onTap: token != null && !complete ? () => onRemove(slot) : null,
      excludeSemantics: true,
      child: DragTarget<_DigitToken>(
        onWillAcceptWithDetails: (_) => !complete && token == null,
        onAcceptWithDetails: (details) => onDrop(slot, details.data),
        builder: (_, candidates, __) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onRemove(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: side,
            height: side,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: wrong
                  ? const Color(0xFFFFB6B6)
                  : candidates.isNotEmpty
                      ? accent.withValues(alpha: .22)
                      : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: wrong ? const Color(0xFFFF5A67) : accent,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x1F000000), blurRadius: 4),
              ],
            ),
            child: token == null
                ? Text(
                    '?',
                    style: TextStyle(
                      color: accent.withValues(alpha: .55),
                      fontSize: small ? 18 : 23,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                : Text(
                    '${token!.value}',
                    style: const TextStyle(
                      color: Color(0xFF233B52),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _DraggableDigit extends StatelessWidget {
  const _DraggableDigit({
    required this.token,
    required this.accent,
    required this.semanticLabel,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final _DigitToken token;
  final Color accent;
  final String semanticLabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final face = _DigitFace(token: token, accent: accent);
    return Semantics(
      button: true,
      enabled: enabled,
      label: '$semanticLabel ${token.value}',
      onTap: enabled ? onTap : null,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Draggable<_DigitToken>(
          data: token,
          maxSimultaneousDrags: enabled ? 1 : 0,
          feedback: Material(color: Colors.transparent, child: face),
          childWhenDragging: Opacity(opacity: .18, child: face),
          child: face,
        ),
      ),
    );
  }
}

class _DigitFace extends StatelessWidget {
  const _DigitFace({required this.token, required this.accent});

  final _DigitToken token;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.lerp(accent, Colors.white, .72),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Text(
        '${token.value}',
        style: const TextStyle(
          color: Color(0xFF21394F),
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CrosswordBoard extends StatelessWidget {
  const _CrosswordBoard({
    required this.values,
    required this.selected,
    required this.wrong,
    required this.accent,
    required this.complete,
    required this.onDrop,
    required this.onSelect,
  });

  final List<int?> values;
  final int selected;
  final Set<int> wrong;
  final Color accent;
  final bool complete;
  final ValueChanged<int> onDrop;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _CrosswordPainter(accent: accent)),
        ),
        _fixed('7', 18, 34),
        _fixed('+', 60, 34),
        _entry(0, 102, 28),
        _fixed('=', 148, 34),
        _fixed('12', 190, 34),
        _fixed('+', 108, 75),
        _entry(1, 102, 104),
        _fixed('=', 108, 151),
        _fixed('8', 108, 187),
        _fixed('+', 148, 111),
        _entry(2, 184, 104),
        _fixed('=', 230, 111),
        _fixed('9', 268, 111),
      ],
    );
  }

  Widget _fixed(String value, double left, double top) => Positioned(
        left: left,
        top: top,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(child: _InkNumber(value, size: 22)),
        ),
      );

  Widget _entry(int index, double left, double top) => Positioned(
        left: left,
        top: top,
        child: DragTarget<int>(
          key: ValueKey('math-crossword-socket-$index'),
          onWillAcceptWithDetails: (_) => !complete,
          onAcceptWithDetails: (details) {
            onSelect(index);
            onDrop(details.data);
          },
          builder: (_, candidates, __) => GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: wrong.contains(index)
                    ? const Color(0xFFFFB7B7)
                    : candidates.isNotEmpty || selected == index && !complete
                        ? Color.lerp(accent, Colors.white, .7)
                        : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      wrong.contains(index) ? const Color(0xFFFF5A67) : accent,
                  width: selected == index ? 3 : 2,
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x1F000000), blurRadius: 5),
                ],
              ),
              child: Text(
                values[index]?.toString() ?? '?',
                style: const TextStyle(
                  color: Color(0xFF21394F),
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      );
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.value,
    required this.accent,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final int value;
  final Color accent;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: Color.lerp(accent, Colors.white, .76),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                color: Color(0xFF21394F),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
    return Draggable<int>(
      data: value,
      maxSimultaneousDrags: enabled ? 1 : 0,
      feedback: Material(color: Colors.transparent, child: button),
      childWhenDragging: Opacity(opacity: .25, child: button),
      child: button,
    );
  }
}

class _TargetBadge extends StatelessWidget {
  const _TargetBadge({
    required this.sum,
    required this.target,
    required this.accent,
    required this.over,
    required this.complete,
    super.key,
  });

  final int sum;
  final int target;
  final Color accent;
  final bool over;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    final color = over ? const Color(0xFFFF5A67) : accent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        complete
            ? '$sum / $target ${String.fromCharCode(0x2713)}'
            : '$sum / $target',
        style: TextStyle(
          color: color,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DraggableCoin extends StatelessWidget {
  const _DraggableCoin({
    required this.coin,
    required this.accent,
    required this.semanticLabel,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final _Coin coin;
  final Color accent;
  final String semanticLabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final face = _CoinFace(coin: coin, accent: accent);
    return Semantics(
      button: true,
      enabled: enabled,
      label: '$semanticLabel ${coin.value}',
      onTap: enabled ? onTap : null,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? onTap : null,
        child: Draggable<_Coin>(
          data: coin,
          maxSimultaneousDrags: enabled ? 1 : 0,
          feedback: Material(color: Colors.transparent, child: face),
          childWhenDragging: Opacity(opacity: .18, child: face),
          child: face,
        ),
      ),
    );
  }
}

class _CoinFace extends StatelessWidget {
  const _CoinFace({
    required this.coin,
    required this.accent,
    this.small = false,
  });

  final _Coin coin;
  final Color accent;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final side = small ? 44.0 : 48.0;
    return Container(
      width: side,
      height: side,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(accent, const Color(0xFFFFDF72), .45)!,
            const Color(0xFFFFB638),
          ],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
              color: Color(0x38000000), blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Text(
        '${coin.value}',
        style: TextStyle(
          color: const Color(0xFF664300),
          fontSize: small ? 17 : 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MarketProduct extends StatelessWidget {
  const _MarketProduct({
    required this.product,
    required this.accent,
    super.key,
  });

  final int product;
  final Color accent;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _MarketProductPainter(product: product, accent: accent),
        ),
      );
}

class _MarketProductPainter extends CustomPainter {
  const _MarketProductPainter({required this.product, required this.accent});

  final int product;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    switch (product) {
      case 0:
        _paintApple(canvas, size);
      case 1:
        _paintBoat(canvas, size);
      default:
        _paintKite(canvas, size);
    }
  }

  void _paintApple(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .56);
    final fruit = Paint()..color = const Color(0xFFFF6670);
    canvas.drawOval(
      Rect.fromCenter(center: center.translate(-8, 0), width: 23, height: 28),
      fruit,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center.translate(8, 0), width: 23, height: 28),
      fruit,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - 2, 8, 4, 15),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF79533A),
    );
    canvas.drawOval(
      Rect.fromLTWH(center.dx + 1, 8, 17, 9),
      Paint()..color = const Color(0xFF5CCB7A),
    );
    canvas.drawCircle(
      center.translate(-8, -6),
      4,
      Paint()..color = Colors.white.withValues(alpha: .42),
    );
  }

  void _paintBoat(Canvas canvas, Size size) {
    final hull = Path()
      ..moveTo(11, size.height * .58)
      ..lineTo(size.width - 9, size.height * .58)
      ..lineTo(size.width - 19, size.height * .82)
      ..lineTo(20, size.height * .82)
      ..close();
    canvas.drawPath(hull, Paint()..color = const Color(0xFFFF9D48));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .48, 8, 4, size.height * .52),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF76513B),
    );
    final sail = Path()
      ..moveTo(size.width * .48, 11)
      ..lineTo(size.width * .48, size.height * .54)
      ..lineTo(15, size.height * .54)
      ..close();
    canvas.drawPath(sail, Paint()..color = accent);
    canvas.drawCircle(
      Offset(size.width * .36, size.height * .34),
      4,
      Paint()..color = Colors.white.withValues(alpha: .45),
    );
  }

  void _paintKite(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .4);
    final kite = Path()
      ..moveTo(center.dx, 7)
      ..lineTo(size.width - 12, center.dy)
      ..lineTo(center.dx, size.height * .7)
      ..lineTo(12, center.dy)
      ..close();
    canvas.drawPath(kite, Paint()..color = accent);
    canvas.drawPath(
      Path()
        ..moveTo(center.dx, 7)
        ..lineTo(center.dx, size.height * .7)
        ..lineTo(size.width - 12, center.dy),
      Paint()
        ..color = Colors.white.withValues(alpha: .55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawPath(
      Path()
        ..moveTo(center.dx, size.height * .7)
        ..quadraticBezierTo(
          size.width * .72,
          size.height * .82,
          size.width * .56,
          size.height - 4,
        ),
      Paint()
        ..color = const Color(0xFF76513B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _MarketProductPainter oldDelegate) =>
      oldDelegate.product != product || oldDelegate.accent != accent;
}

class _ProgressMarks extends StatelessWidget {
  const _ProgressMarks({
    required this.count,
    required this.active,
    required this.accent,
  });

  final int count;
  final int active;
  final Color accent;

  @override
  Widget build(BuildContext context) => Row(
        children: List.generate(
          count,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: index < active ? 24 : 10,
            height: 8,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: index < active ? accent : accent.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}

class _InkNumber extends StatelessWidget {
  const _InkNumber(this.value, {this.size = 26});

  final String value;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
        value,
        style: TextStyle(
          color: const Color(0xFF274356),
          fontSize: size,
          height: 1,
          fontWeight: FontWeight.w900,
        ),
      );
}

class _PaperPainter extends CustomPainter {
  const _PaperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0x1F4596C7)
      ..strokeWidth = 1;
    for (var y = 28.0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    canvas.drawLine(
      const Offset(38, 0),
      Offset(38, size.height),
      Paint()
        ..color = const Color(0x2FFF6B7A)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _PaperPainter oldDelegate) => false;
}

class _CrosswordPainter extends CustomPainter {
  const _CrosswordPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, 16, size.width - 17, size.height - 32),
        const Radius.circular(22),
      ),
      Paint()..color = Colors.white.withValues(alpha: .48),
    );
    final dot = Paint()..color = accent.withValues(alpha: .18);
    for (var x = 24.0; x < size.width; x += 28) {
      for (var y = 24.0; y < size.height; y += 28) {
        canvas.drawCircle(Offset(x, y), 1.5, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CrosswordPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class _MarketPainter extends CustomPainter {
  const _MarketPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(accent, Colors.white, .78)!,
            const Color(0xFFFFF2C7),
          ],
        ).createShader(Offset.zero & size),
    );
    final awning = Paint()..color = const Color(0xFFFF6E72);
    for (var x = 0.0; x < size.width; x += 48) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 24, 14), awning);
    }
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 16, size.width, 16),
      Paint()..color = const Color(0xFFC88246),
    );
  }

  @override
  bool shouldRepaint(covariant _MarketPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class _DigitToken {
  const _DigitToken(this.id, this.value);

  final int id;
  final int value;
}

class _Coin {
  const _Coin(this.id, this.value);

  final int id;
  final int value;
}
