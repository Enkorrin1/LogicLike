import 'dart:async';

import 'package:flutter/material.dart';

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

class _BridgeOrderGameViewState extends State<BridgeOrderGameView> {
  static const _target = <int>[0, 1, 2, 3];
  final List<int> _planks = <int>[2, 0, 3, 1];
  int? _dragging;
  bool _complete = false;

  void _move(int from, int to) {
    if (_complete || from == to) return;
    setState(() {
      final plank = _planks.removeAt(from);
      _planks.insert(to, plank);
      _dragging = null;
    });
    if (_sameOrder(_planks, _target)) _finish();
  }

  bool _sameOrder(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _finish() {
    if (_complete) return;
    setState(() => _complete = true);
    Timer(const Duration(milliseconds: 650), () {
      if (mounted) widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 218.0 : 260.0;
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
                  icon: _complete
                      ? Icons.check_rounded
                      : Icons.swap_horiz_rounded,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ProgressDots(
                    count: _planks.length,
                    active: _orderedPrefix(),
                    color: widget.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(
                      child:
                          CustomPaint(painter: _RiverPainter(widget.accent))),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(_planks.length, (index) {
                      final plank = _planks[index];
                      return Expanded(
                        child: DragTarget<int>(
                          onWillAcceptWithDetails: (_) => !_complete,
                          onAcceptWithDetails: (details) =>
                              _move(details.data, index),
                          builder: (context, candidates, rejected) {
                            final highlighted = candidates.isNotEmpty;
                            return LongPressDraggable<int>(
                              data: index,
                              maxSimultaneousDrags: _complete ? 0 : 1,
                              onDragStarted: () =>
                                  setState(() => _dragging = index),
                              onDraggableCanceled: (_, __) =>
                                  setState(() => _dragging = null),
                              feedback: Material(
                                color: Colors.transparent,
                                child: _BridgePlank(
                                  rank: plank,
                                  color: widget.accent,
                                  lifted: true,
                                ),
                              ),
                              childWhenDragging: const SizedBox(height: 46),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 180),
                                scale: highlighted
                                    ? 1.08
                                    : (_dragging == index ? .94 : 1),
                                child: _BridgePlank(
                                    rank: plank, color: widget.accent),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Icon(Icons.grass_rounded,
                        color: Colors.green.shade500, size: 35),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(Icons.flag_rounded,
                        color: widget.accent, size: 34),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _orderedPrefix() {
    var count = 0;
    for (var i = 0; i < _planks.length; i++) {
      if (_planks[i] != i) break;
      count++;
    }
    return count;
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
  final List<int?> _slots = <int?>[null, null, null];
  bool _complete = false;
  int? _wrongSlot;

  void _place(int pieceId, int slot) {
    if (_complete) return;
    final previous = _slots.indexOf(pieceId);
    setState(() {
      if (previous >= 0) _slots[previous] = null;
      _slots[slot] = pieceId;
      _wrongSlot = null;
    });
    if (_slots.every((value) => value != null)) {
      final valid = _slots[0] == 0 && _slots[1] == 1 && _slots[2] == 2;
      if (valid) {
        _finish();
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
      if (_slots[i] != i) return i;
    }
    return 0;
  }

  void _finish() {
    if (_complete) return;
    setState(() => _complete = true);
    Timer(const Duration(milliseconds: 700), () {
      if (mounted) widget.onAnswerSelected(widget.correctAnswer);
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
        ...available.map(
          (piece) => Expanded(
            child: Center(
              child: LongPressDraggable<int>(
                data: piece.id,
                maxSimultaneousDrags: _complete ? 0 : 1,
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
                onWillAcceptWithDetails: (_) => !_complete,
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
                          turns: _wrongSlot == slot ? .025 : 0,
                          duration: const Duration(milliseconds: 90),
                          child:
                              _TowerBlock(piece: _pieces[pieceId], scale: .9),
                        ),
                ),
              );
            }),
          ),
        ),
        if (_complete)
          Positioned(
            top: 4,
            child: Icon(Icons.auto_awesome_rounded,
                color: Colors.amber.shade600, size: 34),
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

class _BridgePlank extends StatelessWidget {
  const _BridgePlank(
      {required this.rank, required this.color, this.lifted = false});

  final int rank;
  final Color color;
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    final width = 48.0 + rank * 10;
    return Container(
      width: width,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Color.lerp(const Color(0xFFFFD277), color, rank * .08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC98742), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: lifted ? 12 : 3,
            offset: Offset(0, lifted ? 8 : 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(2 + rank, (_) => const _WoodNail()),
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
  const _RiverPainter(this.accent);
  final Color accent;

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
  }

  @override
  bool shouldRepaint(covariant _RiverPainter oldDelegate) =>
      oldDelegate.accent != accent;
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
