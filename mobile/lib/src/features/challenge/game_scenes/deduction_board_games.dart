import 'dart:math' as math;

import 'package:flutter/material.dart';

class MiniSudokuBoardGameView extends StatefulWidget {
  const MiniSudokuBoardGameView({
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
  State<MiniSudokuBoardGameView> createState() =>
      _MiniSudokuBoardGameViewState();
}

class _MiniSudokuBoardGameViewState extends State<MiniSudokuBoardGameView>
    with SingleTickerProviderStateMixin {
  static const _solution = <List<int>>[
    [0, 1, 2, 3],
    [2, 3, 0, 1],
    [1, 0, 3, 2],
    [3, 2, 1, 0],
  ];
  static const _emptyCells = <int>{1, 7, 8, 14};

  late final AnimationController _pulse;
  final Map<int, int> _entries = {};
  int? _selectedCell = 1;
  int? _wrongCell;
  bool _solved = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _placeToken(int token) {
    final cell = _selectedCell;
    if (cell == null || _solved) return;
    _placeTokenAt(token, cell);
  }

  void _placeTokenAt(int token, int cell) {
    if (_solved || !_emptyCells.contains(cell)) return;
    setState(() {
      _entries[cell] = token;
      _wrongCell = null;
      _selectedCell = _emptyCells
          .where((index) => !_entries.containsKey(index))
          .cast<int?>()
          .firstOrNull;
    });
    if (_entries.length == _emptyCells.length) _checkBoard();
  }

  void _checkBoard() {
    final wrong = _emptyCells.cast<int?>().firstWhere(
          (index) => _entries[index] != _solution[index! ~/ 4][index % 4],
          orElse: () => null,
        );
    if (wrong != null) {
      setState(() {
        _wrongCell = wrong;
        _selectedCell = wrong;
        _entries.remove(wrong);
      });
      _pulse.forward(from: 0);
      return;
    }
    setState(() {
      _solved = true;
      _selectedCell = null;
    });
    _pulse.repeat(reverse: true);
    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (mounted) widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 270.0 : 340.0;
    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boardSize = math.min(
              constraints.maxWidth - (widget.compact ? 92 : 122),
              widget.compact ? 222.0 : 276.0,
            );
            return Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: _SoftGameBackdropPainter(
                    accent: widget.accent,
                    success: _solved,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(widget.compact ? 12 : 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: boardSize,
                        height: boardSize,
                        child: _buildBoard(),
                      ),
                      SizedBox(width: widget.compact ? 10 : 18),
                      SizedBox(
                        width: widget.compact ? 54 : 66,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (token) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: LongPressDraggable<int>(
                                  data: token,
                                  maxSimultaneousDrags: _solved ? 0 : 1,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: widget.compact ? 54 : 66,
                                      height: widget.compact ? 48 : 60,
                                      child: _TokenButton(
                                        token: token,
                                        accent: widget.accent,
                                        enabled: true,
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: .28,
                                    child: _TokenButton(
                                      token: token,
                                      accent: widget.accent,
                                      enabled: false,
                                      onTap: () {},
                                    ),
                                  ),
                                  child: _TokenButton(
                                    token: token,
                                    accent: widget.accent,
                                    enabled: _selectedCell != null && !_solved,
                                    onTap: () => _placeToken(token),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_solved)
                  IgnorePointer(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, child) => Transform.scale(
                          scale: 1 + (_pulse.value * .08),
                          child: child,
                        ),
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: widget.compact ? 42 : 54,
                          color: const Color(0xFFFFC83D),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final shake =
            _wrongCell == null ? 0.0 : math.sin(_pulse.value * math.pi * 6) * 4;
        return Transform.translate(offset: Offset(shake, 0), child: child);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .94),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x220B4A5A),
              blurRadius: 16,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              final isEmpty = _emptyCells.contains(index);
              final token =
                  isEmpty ? _entries[index] : _solution[index ~/ 4][index % 4];
              final selected = _selectedCell == index;
              return DragTarget<int>(
                onWillAcceptWithDetails: (_) => isEmpty && !_solved,
                onAcceptWithDetails: (details) =>
                    _placeTokenAt(details.data, index),
                builder: (context, candidates, rejected) => InkWell(
                  onTap: isEmpty && !_solved
                      ? () => setState(() => _selectedCell = index)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: candidates.isNotEmpty
                          ? widget.accent.withValues(alpha: .30)
                          : selected
                              ? widget.accent.withValues(alpha: .18)
                              : isEmpty
                                  ? const Color(0xFFF7FCFD)
                                  : const Color(0xFFEAF7F5),
                      border: Border(
                        right: BorderSide(
                          width: index % 2 == 1 ? 2.2 : .7,
                          color: const Color(0xFF8CBEC2),
                        ),
                        bottom: BorderSide(
                          width: index ~/ 4 == 1 ? 2.2 : .7,
                          color: const Color(0xFF8CBEC2),
                        ),
                      ),
                    ),
                    child: token == null
                        ? Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: selected ? 18 : 10,
                              height: selected ? 18 : 10,
                              decoration: BoxDecoration(
                                color: widget.accent.withValues(
                                  alpha: selected ? .52 : .16,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8),
                            child: CustomPaint(
                              painter: _SudokuTokenPainter(
                                token: token,
                                accent: widget.accent,
                                muted: !isEmpty,
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LogicHousesDeductionGameView extends StatefulWidget {
  const LogicHousesDeductionGameView({
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
  State<LogicHousesDeductionGameView> createState() =>
      _LogicHousesDeductionGameViewState();
}

class _LogicHousesDeductionGameViewState
    extends State<LogicHousesDeductionGameView>
    with SingleTickerProviderStateMixin {
  static const _rounds = <Map<int, int>>[
    {0: 2, 1: 0, 2: 1},
    {0: 1, 1: 2, 2: 0},
    {0: 0, 1: 1, 2: 2},
  ];
  final Map<int, int> _placements = {};
  final Set<int> _wrongHouses = {};
  late final AnimationController _reaction;
  int _round = 0;
  int? _selectedCharacter;
  bool _roundCleared = false;
  bool _solved = false;

  Map<int, int> get _solution => _rounds[_round];

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }

  void _selectCharacter(int character) {
    if (_solved || _roundCleared || _placements.containsKey(character)) return;
    setState(() {
      _selectedCharacter = _selectedCharacter == character ? null : character;
      _wrongHouses.clear();
    });
  }

  void _place(int character, int house) {
    if (_solved || _roundCleared) return;
    setState(() {
      _placements.removeWhere((_, value) => value == house);
      _placements[character] = house;
      _selectedCharacter = null;
      _wrongHouses.clear();
    });
    if (_placements.length == 3) _checkSolution();
  }

  void _checkSolution() {
    final wrong = <int>{};
    for (final entry in _solution.entries) {
      if (_placements[entry.key] != entry.value) wrong.add(entry.value);
    }
    if (wrong.isNotEmpty) {
      setState(() => _wrongHouses.addAll(wrong));
      _reaction.forward(from: 0);
      Future<void>.delayed(const Duration(milliseconds: 520), () {
        if (!mounted || _solved) return;
        setState(() {
          final wrongCharacters = _placements.entries
              .where((entry) => _solution[entry.key] != entry.value)
              .map((entry) => entry.key)
              .toList();
          for (final character in wrongCharacters) {
            _placements.remove(character);
          }
          _wrongHouses.clear();
        });
      });
      return;
    }
    setState(() => _roundCleared = true);
    _reaction.forward(from: 0);
    Future<void>.delayed(const Duration(milliseconds: 760), () {
      if (!mounted) return;
      if (_round < _rounds.length - 1) {
        setState(() {
          _round++;
          _placements.clear();
          _wrongHouses.clear();
          _selectedCharacter = null;
          _roundCleared = false;
        });
        return;
      }
      setState(() => _solved = true);
      Future<void>.delayed(const Duration(milliseconds: 380), () {
        if (mounted) widget.onAnswerSelected(widget.correctAnswer);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: SizedBox(
        height: widget.compact ? 276 : 354,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _VillageBackdropPainter(
                accent: widget.accent,
                success: _solved,
              ),
            ),
            AnimatedBuilder(
              animation: _reaction,
              builder: (context, child) {
                final errorShake = _wrongHouses.isEmpty
                    ? 0.0
                    : math.sin(_reaction.value * math.pi * 8) * 3.5;
                return Transform.translate(
                  offset: Offset(errorShake, 0),
                  child: child,
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  widget.compact ? 10 : 16,
                  widget.compact ? 8 : 12,
                  widget.compact ? 10 : 16,
                  widget.compact ? 10 : 14,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: widget.compact ? 48 : 62,
                      child: _ClueStrip(
                        accent: widget.accent,
                        solution: _solution,
                        round: _round,
                        cleared: _roundCleared || _solved,
                      ),
                    ),
                    SizedBox(height: widget.compact ? 5 : 9),
                    Expanded(
                      child: Row(
                        children: List.generate(
                          3,
                          (house) => Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: _buildHouse(house),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.compact ? 5 : 8),
                    SizedBox(
                      height: widget.compact ? 52 : 68,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, _buildCharacterSource),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouse(int house) {
    final character = _placements.entries
        .where((entry) => entry.value == house)
        .map((entry) => entry.key)
        .firstOrNull;
    return Semantics(
      button: true,
      selected: _selectedCharacter != null,
      onTap: _selectedCharacter == null || _solved || _roundCleared
          ? null
          : () => _place(_selectedCharacter!, house),
      child: DragTarget<int>(
        onWillAcceptWithDetails: (_) => !_solved,
        onAcceptWithDetails: (details) => _place(details.data, house),
        builder: (context, candidates, rejected) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          transform: Matrix4.identity()
            ..scaleByDouble(
              candidates.isNotEmpty ? 1.035 : 1,
              candidates.isNotEmpty ? 1.035 : 1,
              1,
              1,
            ),
          decoration: BoxDecoration(
            color: _wrongHouses.contains(house)
                ? const Color(0xFFFFD7D7)
                : candidates.isNotEmpty
                    ? widget.accent.withValues(alpha: .18)
                    : Colors.white.withValues(alpha: .84),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _wrongHouses.contains(house)
                  ? const Color(0xFFFF6B6B)
                  : widget.accent.withValues(alpha: .38),
              width: candidates.isNotEmpty ? 2.5 : 1.3,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _HousePainter(
                    house: house,
                    accent: widget.accent,
                    occupied: character != null,
                    success: _solved,
                  ),
                ),
              ),
              if (character != null)
                Positioned(
                  bottom: widget.compact ? 8 : 12,
                  child: _draggableCharacter(character, inHouse: true),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterSource(int character) {
    if (_placements.containsKey(character)) {
      return SizedBox(width: widget.compact ? 48 : 62);
    }
    return _draggableCharacter(character);
  }

  Widget _draggableCharacter(int character, {bool inHouse = false}) {
    final avatar = _CharacterToken(
      character: character,
      size: widget.compact ? (inHouse ? 39 : 46) : (inHouse ? 50 : 60),
      accent: widget.accent,
    );
    if (_solved) return avatar;
    if (inHouse) return avatar;
    return Semantics(
      button: true,
      selected: _selectedCharacter == character,
      onTap: () => _selectCharacter(character),
      child: LongPressDraggable<int>(
        data: character,
        feedback: Material(color: Colors.transparent, child: avatar),
        childWhenDragging: Opacity(opacity: .22, child: avatar),
        child: GestureDetector(
          onTap: () => _selectCharacter(character),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 160),
            scale: _selectedCharacter == character ? 1.1 : 1,
            child: avatar,
          ),
        ),
      ),
    );
  }
}

class _TokenButton extends StatelessWidget {
  const _TokenButton({
    required this.token,
    required this.accent,
    required this.enabled,
    required this.onTap,
  });

  final int token;
  final Color accent;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: enabled ? onTap : null,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : .45,
          duration: const Duration(milliseconds: 160),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: accent.withValues(alpha: .38)),
              boxShadow: const [
                BoxShadow(color: Color(0x180B4A5A), blurRadius: 7),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CustomPaint(
                painter: _SudokuTokenPainter(token: token, accent: accent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CharacterToken extends StatelessWidget {
  const _CharacterToken({
    required this.character,
    required this.size,
    required this.accent,
  });

  final int character;
  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _CharacterPainter(character: character, accent: accent),
      ),
    );
  }
}

class _ClueStrip extends StatelessWidget {
  const _ClueStrip({
    required this.accent,
    required this.solution,
    required this.round,
    required this.cleared,
  });

  final Color accent;
  final Map<int, int> solution;
  final int round;
  final bool cleared;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: .26)),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _VisualClue(character: 0, house: solution[0]!, accent: accent),
              Container(
                  width: 1, height: 30, color: accent.withValues(alpha: .2)),
              _VisualClue(character: 1, house: solution[1]!, accent: accent),
              Container(
                  width: 1, height: 30, color: accent.withValues(alpha: .2)),
              _VisualClue(character: 2, house: solution[2]!, accent: accent),
            ],
          ),
          Positioned(
            top: 5,
            right: 7,
            child: Row(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: index < round || (index == round && cleared)
                          ? const Color(0xFFFFC83D)
                          : accent.withValues(alpha: .22),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisualClue extends StatelessWidget {
  const _VisualClue({
    required this.character,
    required this.house,
    required this.accent,
  });

  final int character;
  final int house;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 28,
            child: CustomPaint(
              painter: _CharacterPainter(
                character: character,
                accent: accent,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Icon(Icons.arrow_forward_rounded, size: 15),
          ),
          SizedBox.square(
            dimension: 27,
            child: CustomPaint(
              painter: _MiniHousePainter(house: house, accent: accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _SudokuTokenPainter extends CustomPainter {
  const _SudokuTokenPainter({
    required this.token,
    required this.accent,
    this.muted = false,
  });

  final int token;
  final Color accent;
  final bool muted;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) * .29;
    final colors = [
      const Color(0xFF2FB5A5),
      const Color(0xFFFFC64A),
      const Color(0xFF6E78F7),
      const Color(0xFFFF7383),
    ];
    final color = Color.lerp(colors[token], accent, muted ? .18 : .05)!;
    final paint = Paint()..color = color;
    final shadow = Paint()..color = color.withValues(alpha: .2);
    canvas.drawCircle(center + const Offset(0, 3), radius * 1.1, shadow);
    switch (token) {
      case 0:
        canvas.drawCircle(center, radius, paint);
      case 1:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: center,
              width: radius * 1.75,
              height: radius * 1.75,
            ),
            Radius.circular(radius * .38),
          ),
          paint,
        );
      case 2:
        final path = Path();
        for (var i = 0; i < 10; i++) {
          final angle = -math.pi / 2 + i * math.pi / 5;
          final r = i.isEven ? radius : radius * .46;
          final point =
              center + Offset(math.cos(angle) * r, math.sin(angle) * r);
          i == 0
              ? path.moveTo(point.dx, point.dy)
              : path.lineTo(point.dx, point.dy);
        }
        canvas.drawPath(path..close(), paint);
      case 3:
        final path = Path()
          ..moveTo(center.dx, center.dy - radius)
          ..lineTo(center.dx + radius, center.dy + radius * .82)
          ..lineTo(center.dx - radius, center.dy + radius * .82)
          ..close();
        canvas.drawPath(path, paint);
    }
    canvas.drawCircle(
      center - Offset(radius * .28, radius * .28),
      radius * .13,
      Paint()..color = Colors.white.withValues(alpha: .65),
    );
  }

  @override
  bool shouldRepaint(covariant _SudokuTokenPainter oldDelegate) =>
      token != oldDelegate.token ||
      accent != oldDelegate.accent ||
      muted != oldDelegate.muted;
}

class _SoftGameBackdropPainter extends CustomPainter {
  const _SoftGameBackdropPainter({
    required this.accent,
    required this.success,
  });

  final Color accent;
  final bool success;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            success ? const Color(0xFFD6F8DA) : const Color(0xFFE1F8F5),
            const Color(0xFFF8F2FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect),
    );
    for (var i = 0; i < 8; i++) {
      final x = size.width * ((i * 37 % 91) / 100);
      final y = size.height * ((i * 29 % 83) / 100);
      canvas.drawCircle(
        Offset(x, y),
        2 + i % 3,
        Paint()..color = accent.withValues(alpha: .12),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SoftGameBackdropPainter oldDelegate) =>
      accent != oldDelegate.accent || success != oldDelegate.success;
}

class _VillageBackdropPainter extends CustomPainter {
  const _VillageBackdropPainter({
    required this.accent,
    required this.success,
  });

  final Color accent;
  final bool success;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFDDF7FF),
            success ? const Color(0xFFD9F8DC) : const Color(0xFFFFF0D6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );
    final hill = Path()
      ..moveTo(0, size.height * .72)
      ..quadraticBezierTo(
        size.width * .25,
        size.height * .57,
        size.width * .52,
        size.height * .72,
      )
      ..quadraticBezierTo(
        size.width * .78,
        size.height * .84,
        size.width,
        size.height * .66,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = const Color(0xFFBDE9B9));
  }

  @override
  bool shouldRepaint(covariant _VillageBackdropPainter oldDelegate) =>
      accent != oldDelegate.accent || success != oldDelegate.success;
}

class _HousePainter extends CustomPainter {
  const _HousePainter({
    required this.house,
    required this.accent,
    required this.occupied,
    required this.success,
  });

  final int house;
  final Color accent;
  final bool occupied;
  final bool success;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF61C7EC),
      const Color(0xFFFFC94F),
      const Color(0xFF55C6A9),
    ];
    final color = colors[house];
    final body = Rect.fromLTWH(
      size.width * .16,
      size.height * .32,
      size.width * .68,
      size.height * .5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(9)),
      Paint()..color = color.withValues(alpha: .92),
    );
    final roof = Path()
      ..moveTo(size.width * .08, size.height * .38)
      ..lineTo(size.width * .5, size.height * .08)
      ..lineTo(size.width * .92, size.height * .38)
      ..close();
    canvas.drawPath(roof, Paint()..color = Color.lerp(color, accent, .35)!);
    final door = Rect.fromLTWH(
      size.width * .41,
      size.height * .57,
      size.width * .18,
      size.height * .25,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(door, const Radius.circular(5)),
      Paint()..color = const Color(0xFFF8FAF4),
    );
    if (success && occupied) {
      canvas.drawCircle(
        Offset(size.width * .78, size.height * .19),
        size.width * .07,
        Paint()..color = const Color(0xFFFFC83D),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HousePainter oldDelegate) =>
      house != oldDelegate.house ||
      accent != oldDelegate.accent ||
      occupied != oldDelegate.occupied ||
      success != oldDelegate.success;
}

class _MiniHousePainter extends CustomPainter {
  const _MiniHousePainter({required this.house, required this.accent});

  final int house;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF61C7EC),
      const Color(0xFFFFC94F),
      const Color(0xFF55C6A9),
    ];
    final color = colors[house];
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, size.height * .38, size.width - 8, size.height * .5),
        const Radius.circular(4),
      ),
      Paint()..color = color,
    );
    final roof = Path()
      ..moveTo(1, size.height * .43)
      ..lineTo(size.width / 2, 2)
      ..lineTo(size.width - 1, size.height * .43)
      ..close();
    canvas.drawPath(roof, Paint()..color = Color.lerp(color, accent, .35)!);
  }

  @override
  bool shouldRepaint(covariant _MiniHousePainter oldDelegate) =>
      house != oldDelegate.house || accent != oldDelegate.accent;
}

class _CharacterPainter extends CustomPainter {
  const _CharacterPainter({required this.character, required this.accent});

  final int character;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFF7C74),
      const Color(0xFF746FEB),
      const Color(0xFF2FB5A5),
    ];
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * .32;
    canvas.drawCircle(
      center + Offset(0, size.height * .05),
      radius * 1.12,
      Paint()..color = Colors.white.withValues(alpha: .92),
    );
    canvas.drawCircle(center, radius, Paint()..color = colors[character]);
    final earOffset = radius * .75;
    final earY = center.dy - radius * .55;
    if (character == 0) {
      canvas.drawCircle(
        Offset(center.dx - earOffset, earY),
        radius * .38,
        Paint()..color = colors[character],
      );
      canvas.drawCircle(
        Offset(center.dx + earOffset, earY),
        radius * .38,
        Paint()..color = colors[character],
      );
    } else if (character == 1) {
      final left = Path()
        ..moveTo(center.dx - radius * .82, center.dy - radius * .35)
        ..lineTo(center.dx - radius * .62, center.dy - radius * 1.18)
        ..lineTo(center.dx - radius * .16, center.dy - radius * .72)
        ..close();
      final right = Path()
        ..moveTo(center.dx + radius * .82, center.dy - radius * .35)
        ..lineTo(center.dx + radius * .62, center.dy - radius * 1.18)
        ..lineTo(center.dx + radius * .16, center.dy - radius * .72)
        ..close();
      canvas.drawPath(left, Paint()..color = colors[character]);
      canvas.drawPath(right, Paint()..color = colors[character]);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy - radius * .85),
            width: radius * 1.05,
            height: radius * .62,
          ),
          Radius.circular(radius * .25),
        ),
        Paint()..color = Color.lerp(colors[character], accent, .35)!,
      );
    }
    final eye = Paint()..color = const Color(0xFF183B4A);
    canvas.drawCircle(
      center + Offset(-radius * .35, -radius * .08),
      radius * .09,
      eye,
    );
    canvas.drawCircle(
      center + Offset(radius * .35, -radius * .08),
      radius * .09,
      eye,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center + Offset(0, radius * .18),
        width: radius * .7,
        height: radius * .45,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF183B4A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, radius * .08)
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CharacterPainter oldDelegate) =>
      character != oldDelegate.character || accent != oldDelegate.accent;
}
