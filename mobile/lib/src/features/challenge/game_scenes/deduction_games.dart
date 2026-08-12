import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BridgeOrderGameView extends StatefulWidget {
  const BridgeOrderGameView({
    super.key,
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<BridgeOrderGameView> createState() => _BridgeOrderGameViewState();
}

class _BridgeOrderGameViewState extends State<BridgeOrderGameView>
    with TickerProviderStateMixin {
  static const _pieces = <_BridgePiece>[
    _BridgePiece(0, 0, Color(0xFF56C8B8), Icons.circle_rounded),
    _BridgePiece(1, 1, Color(0xFFFFC85B), Icons.change_history_rounded),
    _BridgePiece(2, 2, Color(0xFF65BDF0), Icons.square_rounded),
    _BridgePiece(3, 3, Color(0xFFFF817B), Icons.star_rounded),
  ];
  static const _stages = <_BridgeStage>[
    _BridgeStage(_BridgeRule.ramp, [0, 1, 2, 3]),
    _BridgeStage(_BridgeRule.symbols, [2, 0, 3, 1]),
    _BridgeStage(_BridgeRule.loads, [1, 3, 2, 0]),
  ];

  final List<int?> _slots = <int?>[null, null, null, null];
  late final AnimationController _vehicleController;
  late final AnimationController _errorController;
  int _stage = 0;
  int? _selectedPiece;
  Set<int> _wrongSlots = <int>{};
  bool _testing = false;
  bool _complete = false;
  bool _sent = false;

  _BridgeStage get _currentStage => _stages[_stage];

  bool get _locked => _testing || _complete || _wrongSlots.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _vehicleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _errorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
    );
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  void _selectPiece(int piece) {
    if (_locked) return;
    setState(() {
      _selectedPiece = _selectedPiece == piece ? null : piece;
    });
  }

  void _placePiece(int piece, int slot) {
    if (_locked) return;
    final source = _slots.indexOf(piece);
    if (source == slot) {
      setState(() => _selectedPiece = null);
      return;
    }
    final displaced = _slots[slot];
    setState(() {
      if (source >= 0) _slots[source] = displaced;
      _slots[slot] = piece;
      _selectedPiece = null;
    });
    if (_slots.every((piece) => piece != null)) _checkBridge();
  }

  void _activateSlot(int slot) {
    if (_selectedPiece != null) _placePiece(_selectedPiece!, slot);
  }

  void _checkBridge() {
    final wrong = <int>{};
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] != _currentStage.target[i]) wrong.add(i);
    }
    if (wrong.isEmpty) {
      _testBridge();
      return;
    }
    HapticFeedback.heavyImpact();
    setState(() => _wrongSlots = wrong);
    _errorController.forward(from: 0);
    Timer(const Duration(milliseconds: 720), () {
      if (!mounted || _complete) return;
      setState(() {
        for (final slot in wrong) {
          _slots[slot] = null;
        }
        _wrongSlots = <int>{};
      });
    });
  }

  Future<void> _testBridge() async {
    if (_locked) return;
    HapticFeedback.mediumImpact();
    setState(() => _testing = true);
    await _vehicleController.forward(from: 0);
    if (!mounted || _complete) return;
    if (_stage < _stages.length - 1) {
      setState(() {
        _stage++;
        _slots.fillRange(0, _slots.length, null);
        _testing = false;
      });
      _vehicleController.reset();
      return;
    }
    setState(() {
      _testing = false;
      _complete = true;
    });
    Timer(const Duration(milliseconds: 420), () {
      if (!mounted || _sent) return;
      _sent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 276.0 : 320.0;
    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: height,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        decoration: _sceneDecoration(widget.accent, _complete),
        child: Column(
          children: [
            Row(
              children: [
                _RoundBadge(
                  color: widget.accent,
                  icon: _complete ? Icons.check_rounded : _currentStage.icon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ProgressDots(
                    count: _stages.length,
                    active: _complete ? _stages.length : _stage + 1,
                    color: widget.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(.08, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _buildConstructionSite(),
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(height: 52, child: _buildSupplyYard()),
          ],
        ),
      ),
    );
  }

  Widget _buildConstructionSite() {
    return Stack(
      key: ValueKey('bridge-stage-$_stage'),
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _RiverPainter(widget.accent, _currentStage.rule),
          ),
        ),
        Positioned(
          top: 0,
          left: 8,
          right: 8,
          child: _BridgeBlueprint(
            stage: _currentStage,
            pieces: _pieces,
            accent: widget.accent,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 1,
          child: AnimatedBuilder(
            animation: _errorController,
            builder: (context, child) => Transform.translate(
              offset: Offset(
                math.sin(_errorController.value * math.pi * 6) *
                    (1 - _errorController.value) *
                    8,
                0,
              ),
              child: child,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                _slots.length,
                (slot) => Expanded(child: _buildSlot(slot)),
              ),
            ),
          ),
        ),
        if (_testing || _complete)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _vehicleController,
                builder: (context, child) => Align(
                  alignment: Alignment(
                    -1.18 + _vehicleController.value * 2.36,
                    .58 - math.sin(_vehicleController.value * math.pi) * .05,
                  ),
                  child: child,
                ),
                child: Icon(
                  _complete
                      ? Icons.auto_awesome_rounded
                      : Icons.local_shipping_rounded,
                  color: _complete ? Colors.amber.shade600 : widget.accent,
                  size: 34,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSlot(int slot) {
    final pieceId = _slots[slot];
    final wrong = _wrongSlots.contains(slot);
    return Semantics(
      key: ValueKey('bridge-slot-$_stage-$slot'),
      button: true,
      label: '${widget.semanticLabel} ${slot + 1}',
      onTap: _locked ? null : () => _activateSlot(slot),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _locked ? null : () => _activateSlot(slot),
        child: DragTarget<int>(
          onWillAcceptWithDetails: (_) => !_locked,
          onAcceptWithDetails: (details) => _placePiece(details.data, slot),
          builder: (context, candidates, rejected) => AnimatedContainer(
            key: wrong ? ValueKey('bridge-slot-error-$slot') : null,
            duration: const Duration(milliseconds: 180),
            height: 66,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: wrong
                  ? const Color(0xFFFFD9D7)
                  : candidates.isNotEmpty
                      ? widget.accent.withValues(alpha: .18)
                      : Colors.white.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: wrong
                    ? const Color(0xFFFF625F)
                    : widget.accent.withValues(alpha: .28),
                width: wrong || candidates.isNotEmpty ? 2.5 : 1.5,
              ),
            ),
            child: pieceId == null
                ? _BridgeSlotGuide(
                    rule: _currentStage.rule,
                    piece: _pieces[_currentStage.target[slot]],
                    accent: widget.accent,
                  )
                : ExcludeSemantics(
                    child: LongPressDraggable<int>(
                      key: ValueKey('bridge-installed-$_stage-$pieceId'),
                      data: pieceId,
                      maxSimultaneousDrags: _locked ? 0 : 1,
                      feedback: Material(
                        color: Colors.transparent,
                        child: _BridgePlank(
                          piece: _pieces[pieceId],
                          lifted: true,
                        ),
                      ),
                      childWhenDragging: const SizedBox(width: 52, height: 48),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _locked ? null : () => _selectPiece(pieceId),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 160),
                          scale: _selectedPiece == pieceId ? 1.08 : 1,
                          child: _BridgePlank(piece: _pieces[pieceId]),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplyYard() {
    final available = _pieces.where((piece) => !_slots.contains(piece.id));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: available.map((piece) {
        return Semantics(
          key: ValueKey('bridge-piece-$_stage-${piece.id}'),
          button: true,
          selected: _selectedPiece == piece.id,
          label: '${widget.semanticLabel} ${piece.id + 1}',
          onTap: _locked ? null : () => _selectPiece(piece.id),
          child: ExcludeSemantics(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _locked ? null : () => _selectPiece(piece.id),
              child: LongPressDraggable<int>(
                data: piece.id,
                maxSimultaneousDrags: _locked ? 0 : 1,
                feedback: Material(
                  color: Colors.transparent,
                  child: _BridgePlank(piece: piece, lifted: true),
                ),
                childWhenDragging: const SizedBox(width: 54, height: 48),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 160),
                  scale: _selectedPiece == piece.id ? 1.08 : 1,
                  child: _BridgePlank(piece: piece),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TowerRuleGameView extends StatefulWidget {
  const TowerRuleGameView({
    super.key,
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<TowerRuleGameView> createState() => _TowerRuleGameViewState();
}

class _TowerRuleGameViewState extends State<TowerRuleGameView> {
  static const _pieces = <_TowerPiece>[
    _TowerPiece(0, 88, Color(0xFF54C9B4), Icons.circle_rounded),
    _TowerPiece(1, 70, Color(0xFFFFC85B), Icons.star_rounded),
    _TowerPiece(2, 52, Color(0xFFFF7E79), Icons.change_history_rounded),
  ];
  static const _rounds = <List<int>>[
    [0, 1, 2],
    [2, 1, 0],
    [1, 0, 2],
  ];
  final List<int?> _slots = <int?>[null, null, null];
  int _round = 0;
  bool _checking = false;
  bool _complete = false;
  bool _sent = false;
  int? _wrongSlot;

  void _place(int pieceId, int slot) {
    if (_complete || _checking) return;
    final previous = _slots.indexOf(pieceId);
    setState(() {
      if (previous >= 0) _slots[previous] = null;
      _slots[slot] = pieceId;
      _wrongSlot = null;
    });
    if (_slots.every((value) => value != null)) {
      final valid = List.generate(3, (index) => index)
          .every((index) => _slots[index] == _rounds[_round][index]);
      if (valid) {
        _checkTower();
      } else {
        setState(() => _wrongSlot = _firstWrongSlot());
        Timer(const Duration(milliseconds: 550), () {
          if (!mounted || _complete) return;
          setState(() {
            if (_wrongSlot != null) _slots[_wrongSlot!] = null;
            _wrongSlot = null;
          });
        });
      }
    }
  }

  int _firstWrongSlot() {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] != _rounds[_round][i]) return i;
    }
    return 0;
  }

  void _checkTower() {
    if (_checking || _complete) return;
    HapticFeedback.mediumImpact();
    setState(() => _checking = true);
    Timer(const Duration(milliseconds: 720), () {
      if (!mounted || _complete) return;
      if (_round < _rounds.length - 1) {
        setState(() {
          _round++;
          _slots.fillRange(0, _slots.length, null);
          _checking = false;
        });
        return;
      }
      setState(() {
        _checking = false;
        _complete = true;
      });
      Timer(const Duration(milliseconds: 480), () {
        if (!mounted || _sent) return;
        _sent = true;
        widget.onAnswerSelected(widget.correctAnswer);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: widget.compact ? 250 : 292,
        padding: const EdgeInsets.all(14),
        decoration: _sceneDecoration(widget.accent, _complete),
        child: Row(
          children: [
            Expanded(child: _buildRuleCard()),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: _buildTower()),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard() {
    final available = _pieces.where((piece) => !_slots.contains(piece.id));
    return Column(
      children: [
        _RoundBadge(color: widget.accent, icon: Icons.architecture_rounded),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _rounds.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: index == _round ? 24 : 9,
              height: 9,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index < _round
                    ? const Color(0xFFFFCF54)
                    : index == _round
                        ? widget.accent
                        : Colors.white.withValues(alpha: .62),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        ...available.map(
          (piece) => Expanded(
            child: Center(
              child: LongPressDraggable<int>(
                data: piece.id,
                maxSimultaneousDrags: _complete || _checking ? 0 : 1,
                feedback: Material(
                  color: Colors.transparent,
                  child: _TowerBlock(piece: piece, scale: .8),
                ),
                childWhenDragging: const SizedBox.shrink(),
                child: _TowerBlock(piece: piece, scale: .62),
              ),
            ),
          ),
        ),
        if (available.isEmpty) const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_downward_rounded, size: 17, color: widget.accent),
            Icon(Icons.compress_rounded, size: 20, color: widget.accent),
          ],
        ),
      ],
    );
  }

  Widget _buildTower() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          bottom: 2,
          child: Container(
            width: 130,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFF8A6B5A),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, 4),
                    blurRadius: 4)
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(3, (visualIndex) {
              final slot = 2 - visualIndex;
              final pieceId = _slots[slot];
              return DragTarget<int>(
                onWillAcceptWithDetails: (_) => !_complete && !_checking,
                onAcceptWithDetails: (details) => _place(details.data, slot),
                builder: (context, candidates, rejected) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 56,
                  width: 116,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: candidates.isNotEmpty
                        ? widget.accent.withValues(alpha: .13)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: pieceId == null
                        ? Border.all(
                            color: widget.accent.withValues(alpha: .3),
                            width: 2)
                        : null,
                  ),
                  child: pieceId == null
                      ? Icon(Icons.add_rounded,
                          color: widget.accent.withValues(alpha: .5))
                      : AnimatedRotation(
                          turns: _wrongSlot == slot
                              ? .025
                              : _checking
                                  ? (slot.isEven ? .012 : -.012)
                                  : 0,
                          duration: const Duration(milliseconds: 90),
                          child:
                              _TowerBlock(piece: _pieces[pieceId], scale: .9),
                        ),
                ),
              );
            }),
          ),
        ),
        if (_checking || _complete)
          Positioned(
            top: 4,
            child: Icon(
              _complete ? Icons.auto_awesome_rounded : Icons.bolt_rounded,
              color: Colors.amber.shade600,
              size: 34,
            ),
          ),
      ],
    );
  }
}

class HomeCluesGameView extends StatefulWidget {
  const HomeCluesGameView({
    super.key,
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<HomeCluesGameView> createState() => _HomeCluesGameViewState();
}

class _HomeCluesGameViewState extends State<HomeCluesGameView> {
  static const _characters = <_Character>[
    _Character(0, Icons.pets_rounded, Color(0xFFFF8B78)),
    _Character(1, Icons.cruelty_free_rounded, Color(0xFF8175E8)),
    _Character(2, Icons.flutter_dash_rounded, Color(0xFF2AB5A5)),
  ];
  static const _homes = <Color>[
    Color(0xFF5CC6E8),
    Color(0xFFFFC451),
    Color(0xFF47B991),
  ];
  static const _solution = <int>[1, 2, 0];
  final List<int?> _residents = <int?>[null, null, null];
  int _clue = 0;
  int? _wrongHome;
  bool _complete = false;

  void _place(int characterId, int home) {
    if (_complete) return;
    final previous = _residents.indexOf(characterId);
    setState(() {
      if (previous >= 0) _residents[previous] = null;
      _residents[home] = characterId;
      _wrongHome = null;
    });
    if (_residents.every((resident) => resident != null)) _checkSolution();
  }

  void _checkSolution() {
    for (var home = 0; home < _solution.length; home++) {
      if (_residents[home] != _solution[home]) {
        setState(() => _wrongHome = home);
        Timer(const Duration(milliseconds: 600), () {
          if (!mounted || _complete) return;
          setState(() {
            _residents[home] = null;
            _wrongHome = null;
          });
        });
        return;
      }
    }
    setState(() => _complete = true);
    Timer(const Duration(milliseconds: 750), () {
      if (mounted) widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final available =
        _characters.where((character) => !_residents.contains(character.id));
    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: widget.compact ? 270 : 312,
        padding: EdgeInsets.all(widget.compact ? 8 : 12),
        decoration: _sceneDecoration(widget.accent, _complete),
        child: Column(
          children: [
            SizedBox(
              height: widget.compact ? 50 : 58,
              child: Row(
                children: [
                  Expanded(
                      child: _ClueCard(index: _clue, accent: widget.accent)),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: _complete
                        ? null
                        : () => setState(() => _clue = (_clue + 1) % 3),
                    icon: const Icon(Icons.navigate_next_rounded),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.compact ? 4 : 8),
            Expanded(
              child: Row(
                children: List.generate(3, (home) {
                  final resident = _residents[home];
                  return Expanded(
                    child: DragTarget<int>(
                      onWillAcceptWithDetails: (_) => !_complete,
                      onAcceptWithDetails: (details) =>
                          _place(details.data, home),
                      builder: (context, candidates, rejected) => AnimatedScale(
                        duration: const Duration(milliseconds: 180),
                        scale: candidates.isNotEmpty ? 1.05 : 1,
                        child: _Home(
                          color: _homes[home],
                          character:
                              resident == null ? null : _characters[resident],
                          shaking: _wrongHome == home,
                          complete: _complete,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: widget.compact ? 4 : 8),
            SizedBox(
              height: widget.compact ? 42 : 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: available
                    .map(
                      (character) => LongPressDraggable<int>(
                        data: character.id,
                        maxSimultaneousDrags: _complete ? 0 : 1,
                        feedback: Material(
                          color: Colors.transparent,
                          child:
                              _CharacterToken(character: character, size: 52),
                        ),
                        childWhenDragging: const SizedBox(width: 48),
                        child: _CharacterToken(character: character, size: 44),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _BridgeRule { ramp, symbols, loads }

class _BridgePiece {
  const _BridgePiece(this.id, this.rank, this.color, this.icon);

  final int id;
  final int rank;
  final Color color;
  final IconData icon;
}

class _BridgeStage {
  const _BridgeStage(this.rule, this.target);

  final _BridgeRule rule;
  final List<int> target;

  IconData get icon => switch (rule) {
        _BridgeRule.ramp => Icons.trending_up_rounded,
        _BridgeRule.symbols => Icons.extension_rounded,
        _BridgeRule.loads => Icons.balance_rounded,
      };
}

class _BridgeBlueprint extends StatelessWidget {
  const _BridgeBlueprint({
    required this.stage,
    required this.pieces,
    required this.accent,
  });

  final _BridgeStage stage;
  final List<_BridgePiece> pieces;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .82),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: .24)),
        ),
        child: Row(
          children: [
            Icon(stage.icon, color: accent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(stage.target.length, (index) {
                  final piece = pieces[stage.target[index]];
                  return switch (stage.rule) {
                    _BridgeRule.ramp => Container(
                        width: 17 + piece.rank * 4,
                        height: 7 + piece.rank * 3,
                        decoration: BoxDecoration(
                          color: piece.color.withValues(alpha: .76),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    _BridgeRule.symbols => Icon(
                        piece.icon,
                        color: piece.color,
                        size: 19,
                      ),
                    _BridgeRule.loads => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          piece.rank + 1,
                          (_) => Container(
                            width: 5,
                            height: 9,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: piece.color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                  };
                }),
              ),
            ),
          ],
        ),
      );
}

class _BridgeSlotGuide extends StatelessWidget {
  const _BridgeSlotGuide({
    required this.rule,
    required this.piece,
    required this.accent,
  });

  final _BridgeRule rule;
  final _BridgePiece piece;
  final Color accent;

  @override
  Widget build(BuildContext context) => Center(
        child: switch (rule) {
          _BridgeRule.ramp => Container(
              width: 27 + piece.rank * 6,
              height: 8 + piece.rank * 4,
              decoration: BoxDecoration(
                color: piece.color.withValues(alpha: .22),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: piece.color.withValues(alpha: .5)),
              ),
            ),
          _BridgeRule.symbols => Icon(
              piece.icon,
              color: piece.color.withValues(alpha: .5),
              size: 28,
            ),
          _BridgeRule.loads => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.scale_rounded,
                    color: accent.withValues(alpha: .45), size: 18),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    piece.rank + 1,
                    (_) => Container(
                      width: 6,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: piece.color.withValues(alpha: .46),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        },
      );
}

class _BridgePlank extends StatelessWidget {
  const _BridgePlank({required this.piece, this.lifted = false});

  final _BridgePiece piece;
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    final width = 46.0 + piece.rank * 7;
    return Container(
      width: width,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(piece.color, Colors.white, .22)!,
            piece.color,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: lifted ? 12 : 3,
            offset: Offset(0, lifted ? 8 : 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(piece.icon, color: Colors.white, size: 23),
          Positioned(
            left: 5,
            right: 5,
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [_WoodNail(), _WoodNail()],
            ),
          ),
        ],
      ),
    );
  }
}

class _WoodNail extends StatelessWidget {
  const _WoodNail();

  @override
  Widget build(BuildContext context) => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
            color: Color(0xFF9E623A), shape: BoxShape.circle),
      );
}

class _RiverPainter extends CustomPainter {
  const _RiverPainter(this.accent, this.rule);
  final Color accent;
  final _BridgeRule rule;

  @override
  void paint(Canvas canvas, Size size) {
    final river = Paint()..color = const Color(0xFF92E0F2);
    final path = Path()
      ..moveTo(0, size.height * .58)
      ..quadraticBezierTo(size.width * .25, size.height * .42, size.width * .5,
          size.height * .62)
      ..quadraticBezierTo(
          size.width * .78, size.height * .78, size.width, size.height * .56)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, river);
    final ripple = Paint()
      ..color = Colors.white.withValues(alpha: .65)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
        Rect.fromLTWH(18, size.height * .72, 46, 12), 0, 3.14, false, ripple);
    canvas.drawArc(Rect.fromLTWH(size.width - 78, size.height * .77, 52, 12), 0,
        3.14, false, ripple);

    final bank = Paint()..color = const Color(0xFF73C98B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * .78, 28, size.height * .22),
        const Radius.circular(8),
      ),
      bank,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width - 28,
          size.height * .78,
          28,
          size.height * .22,
        ),
        const Radius.circular(8),
      ),
      bank,
    );

    if (rule == _BridgeRule.loads) {
      final support = Paint()..color = accent.withValues(alpha: .34);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * .38, size.height * .81),
            width: 12,
            height: 38,
          ),
          const Radius.circular(4),
        ),
        support,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * .62, size.height * .81),
            width: 12,
            height: 38,
          ),
          const Radius.circular(4),
        ),
        support,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RiverPainter oldDelegate) =>
      oldDelegate.accent != accent || oldDelegate.rule != rule;
}

class _TowerPiece {
  const _TowerPiece(this.id, this.width, this.color, this.icon);
  final int id;
  final double width;
  final Color color;
  final IconData icon;
}

class _TowerBlock extends StatelessWidget {
  const _TowerBlock({required this.piece, required this.scale});
  final _TowerPiece piece;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
        width: piece.width * scale,
        height: 45 * scale,
        decoration: BoxDecoration(
          color: piece.color,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
                color: Color(0x28000000), offset: Offset(0, 4), blurRadius: 5)
          ],
        ),
        child: Icon(piece.icon, color: Colors.white, size: 24 * scale),
      );
}

class _Character {
  const _Character(this.id, this.icon, this.color);
  final int id;
  final IconData icon;
  final Color color;
}

class _CharacterToken extends StatelessWidget {
  const _CharacterToken({required this.character, required this.size});
  final _Character character;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: character.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
                color: Color(0x30000000), offset: Offset(0, 4), blurRadius: 6)
          ],
        ),
        child: Icon(character.icon, color: Colors.white, size: size * .56),
      );
}

class _Home extends StatelessWidget {
  const _Home(
      {required this.color,
      required this.character,
      required this.shaking,
      required this.complete});
  final Color color;
  final _Character? character;
  final bool shaking;
  final bool complete;

  @override
  Widget build(BuildContext context) => AnimatedRotation(
        turns: shaking ? .018 : 0,
        duration: const Duration(milliseconds: 90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.roofing_rounded, color: color, size: 54),
            Container(
              height: 76,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Color.lerp(color, Colors.white, .66),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border.all(color: color, width: 2),
              ),
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 45,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .72),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: character == null
                    ? Icon(Icons.login_rounded,
                        color: color.withValues(alpha: .55))
                    : _CharacterToken(character: character!, size: 38),
              ),
            ),
            if (complete)
              Icon(Icons.auto_awesome_rounded,
                  color: Colors.amber.shade600, size: 18),
          ],
        ),
      );
}

class _ClueCard extends StatelessWidget {
  const _ClueCard({required this.index, required this.accent});
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final clues = <Widget>[
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets_rounded, color: Color(0xFFFF8B78)),
          SizedBox(width: 5),
          Icon(Icons.compare_arrows_rounded, size: 18),
          SizedBox(width: 5),
          Icon(Icons.home_rounded, color: Color(0xFF47B991)),
        ],
      ),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cruelty_free_rounded, color: Color(0xFF8175E8)),
          Icon(Icons.arrow_forward_rounded, size: 18),
          Icon(Icons.home_rounded, color: Color(0xFF47B991)),
        ],
      ),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flutter_dash_rounded, color: Color(0xFF2AB5A5)),
          Icon(Icons.arrow_forward_rounded, size: 18),
          Icon(Icons.home_rounded, color: Color(0xFF5CC6E8)),
        ],
      ),
    ];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: Container(
        key: ValueKey(index),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .84),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withValues(alpha: .25)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: accent.withValues(alpha: .12),
              child: Text('${index + 1}',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 8),
            Expanded(child: clues[index]),
          ],
        ),
      ),
    );
  }
}

class _RoundBadge extends StatelessWidget {
  const _RoundBadge({required this.color, required this.icon});
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 23),
      );
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots(
      {required this.count, required this.active, required this.color});
  final int count;
  final int active;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(
          count,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: index < active ? 20 : 9,
            height: 9,
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: index < active ? color : color.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}

BoxDecoration _sceneDecoration(Color accent, bool complete) => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(accent, Colors.white, complete ? .76 : .84)!,
          const Color(0xFFF8FCFF),
        ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
          color: accent.withValues(alpha: complete ? .55 : .25), width: 2),
      boxShadow: const [
        BoxShadow(
            color: Color(0x160D5370), offset: Offset(0, 7), blurRadius: 14)
      ],
    );
