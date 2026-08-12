import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OddStepGameView extends StatefulWidget {
  const OddStepGameView({
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
  State<OddStepGameView> createState() => _OddStepStoryGameViewState();
}

class LegacyOddStepGameViewState extends State<OddStepGameView> {
  static const _solution = [0, 1, 2, 3];
  final List<int> _steps = [2, 0, 3, 1];
  int _revision = 0;
  bool _complete = false;

  void _move(int oldIndex, int newIndex) {
    if (_complete) return;
    setState(() {
      final step = _steps.removeAt(oldIndex);
      _steps.insert(newIndex, step);
      _revision++;
    });
    if (_isSolved) {
      setState(() => _complete = true);
      Future<void>.delayed(
        const Duration(milliseconds: 520),
        () => widget.onAnswerSelected(widget.correctAnswer),
      );
    }
  }

  bool get _isSolved {
    for (var index = 0; index < _solution.length; index++) {
      if (_steps[index] != _solution[index]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 210.0 : 252.0;
    return Semantics(
      label: widget.semanticLabel,
      child: AnimatedContainer(
        key: ValueKey(_revision),
        duration: const Duration(milliseconds: 280),
        height: height,
        padding: EdgeInsets.all(widget.compact ? 10 : 14),
        decoration: _sceneDecoration(widget.accent),
        child: Stack(
          children: [
            const Positioned.fill(
                child: CustomPaint(painter: _WorkshopPainter())),
            Column(
              children: [
                _MissionRibbon(
                  color: widget.accent,
                  icon: Icons.route_rounded,
                  text: '1  \u2022  2  \u2022  3  \u2022  4',
                  complete: _complete,
                ),
                const SizedBox(height: 9),
                Expanded(
                  child: ReorderableListView.builder(
                    scrollDirection: Axis.horizontal,
                    buildDefaultDragHandles: false,
                    itemCount: _steps.length,
                    onReorderItem: _move,
                    proxyDecorator: (child, _, animation) => ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.08).animate(animation),
                      child: Material(color: Colors.transparent, child: child),
                    ),
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      return ReorderableDragStartListener(
                        key: ValueKey(step),
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _ActionTile(
                            number: index + 1,
                            action: step,
                            color: widget.accent,
                            complete: _complete,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OddStepStoryGameViewState extends State<OddStepGameView>
    with SingleTickerProviderStateMixin {
  static const _rounds = <_StoryRound>[
    _StoryRound(
      steps: [
        _StoryAction(0, Icons.eco_rounded, Color(0xFF62C97B)),
        _StoryAction(1, Icons.agriculture_rounded, Color(0xFFB78558)),
        _StoryAction(4, Icons.bedtime_rounded, Color(0xFF746FEB)),
        _StoryAction(3, Icons.local_florist_rounded, Color(0xFFFF7E95)),
      ],
      repair: _StoryAction(2, Icons.water_drop_rounded, Color(0xFF58BCEB)),
      decoy: _StoryAction(5, Icons.rocket_launch_rounded, Color(0xFFFFB64A)),
    ),
    _StoryRound(
      steps: [
        _StoryAction(10, Icons.face_rounded, Color(0xFFFFC58B)),
        _StoryAction(11, Icons.cleaning_services_rounded, Color(0xFF6CCCE7)),
        _StoryAction(14, Icons.palette_rounded, Color(0xFFB589EF)),
        _StoryAction(
            13, Icons.sentiment_very_satisfied_rounded, Color(0xFFFFD35C)),
      ],
      repair: _StoryAction(12, Icons.water_rounded, Color(0xFF58BCEB)),
      decoy:
          _StoryAction(15, Icons.catching_pokemon_rounded, Color(0xFFFF7E95)),
    ),
    _StoryRound(
      steps: [
        _StoryAction(20, Icons.directions_walk_rounded, Color(0xFF776FF0)),
        _StoryAction(21, Icons.soap_rounded, Color(0xFF59CFC1)),
        _StoryAction(24, Icons.fastfood_rounded, Color(0xFFFFB64A)),
        _StoryAction(23, Icons.auto_awesome_rounded, Color(0xFFFFD35C)),
      ],
      repair: _StoryAction(22, Icons.air_rounded, Color(0xFF78C6EB)),
      decoy: _StoryAction(25, Icons.sports_esports_rounded, Color(0xFFB589EF)),
    ),
  ];

  late final AnimationController _runner;
  int _roundIndex = 0;
  _StoryStage _stage = _StoryStage.spot;
  int _wrongId = -1;
  bool _wrongDrop = false;
  bool _running = false;
  bool _sent = false;

  _StoryRound get _round => _rounds[_roundIndex];

  @override
  void initState() {
    super.initState();
    _runner = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _runner.dispose();
    super.dispose();
  }

  void _spot(_StoryAction action) {
    if (_stage != _StoryStage.spot || _running) return;
    if (action.id != _round.broken.id) {
      HapticFeedback.lightImpact();
      setState(() => _wrongId = action.id);
      Future<void>.delayed(const Duration(milliseconds: 380), () {
        if (mounted) setState(() => _wrongId = -1);
      });
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _stage = _StoryStage.repair);
  }

  void _repair(_StoryAction action) {
    if (_stage != _StoryStage.repair || _running) return;
    if (action.id != _round.repair.id) {
      HapticFeedback.lightImpact();
      setState(() => _wrongDrop = true);
      Future<void>.delayed(const Duration(milliseconds: 360), () {
        if (mounted) setState(() => _wrongDrop = false);
      });
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _stage = _StoryStage.launch);
  }

  Future<void> _launch() async {
    if (_stage != _StoryStage.launch || _running || _sent) return;
    HapticFeedback.mediumImpact();
    setState(() => _running = true);
    await _runner.forward(from: 0);
    if (!mounted) return;
    if (_roundIndex == _rounds.length - 1) {
      setState(() => _sent = true);
      widget.onAnswerSelected(widget.correctAnswer);
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() {
      _roundIndex++;
      _stage = _StoryStage.spot;
      _wrongId = -1;
      _wrongDrop = false;
      _running = false;
    });
    _runner.reset();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 292.0 : 360.0;
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        height: height,
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.all(widget.compact ? 10 : 14),
        decoration: _sceneDecoration(widget.accent),
        child: AnimatedBuilder(
          animation: _runner,
          builder: (context, _) => Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _StoryScenePainter(
                    progress: _runner.value,
                    running: _running,
                    complete: _sent,
                  ),
                ),
              ),
              Column(
                children: [
                  _StoryMeter(
                    accent: widget.accent,
                    active: _roundIndex,
                    completed: _roundIndex + (_sent ? 1 : 0),
                  ),
                  const SizedBox(height: 9),
                  Expanded(
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: _stepCard(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  _bottomControls(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepCard(int index) {
    const brokenIndex = 2;
    final repaired = _stage == _StoryStage.launch || _running || _sent;
    final action =
        index == brokenIndex && repaired ? _round.repair : _round.steps[index];
    final card = _StoryActionCard(
      key: ValueKey('odd-step-card-$_roundIndex-${action.id}'),
      action: action,
      accent: widget.accent,
      number: index + 1,
      selected: index == brokenIndex && _stage != _StoryStage.spot,
      wrong: _wrongId == action.id || (index == brokenIndex && _wrongDrop),
      muted: index == brokenIndex && _stage == _StoryStage.repair,
      running: _running && (_runner.value * 4).floor() == index,
      onTap: _stage == _StoryStage.spot ? () => _spot(action) : null,
    );
    if (index != brokenIndex || _stage != _StoryStage.repair) return card;
    return DragTarget<_StoryAction>(
      key: ValueKey('odd-step-slot-$_roundIndex'),
      onWillAcceptWithDetails: (_) => !_running,
      onAcceptWithDetails: (details) => _repair(details.data),
      builder: (context, candidates, _) => AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: candidates.isNotEmpty ? 1.05 : 1,
        child: card,
      ),
    );
  }

  Widget _bottomControls() {
    if (_stage == _StoryStage.spot) return const SizedBox(height: 54);
    if (_stage == _StoryStage.repair) {
      return SizedBox(
        height: 54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StoryDraggable(
              key: ValueKey('odd-step-repair-$_roundIndex-${_round.repair.id}'),
              action: _round.repair,
              accent: widget.accent,
            ),
            const SizedBox(width: 18),
            _StoryDraggable(
              key: ValueKey('odd-step-repair-$_roundIndex-${_round.decoy.id}'),
              action: _round.decoy,
              accent: widget.accent,
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 54,
      child: Semantics(
        button: true,
        label: widget.semanticLabel,
        child: IconButton.filled(
          key: ValueKey('odd-step-run-$_roundIndex'),
          onPressed: _running || _sent ? null : _launch,
          icon: const Icon(Icons.play_arrow_rounded),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: widget.accent,
            minimumSize: const Size(52, 52),
          ),
        ),
      ),
    );
  }
}

enum _StoryStage { spot, repair, launch }

class _StoryRound {
  const _StoryRound({
    required this.steps,
    required this.repair,
    required this.decoy,
  });

  final List<_StoryAction> steps;
  final _StoryAction repair;
  final _StoryAction decoy;

  _StoryAction get broken => steps[2];
}

class _StoryAction {
  const _StoryAction(this.id, this.icon, this.color);
  final int id;
  final IconData icon;
  final Color color;
}

class _StoryMeter extends StatelessWidget {
  const _StoryMeter({
    required this.accent,
    required this.active,
    required this.completed,
  });
  final Color accent;
  final int active;
  final int completed;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: index == active ? 34 : 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index < completed
                  ? const Color(0xFFFFD35C)
                  : index == active
                      ? accent
                      : Colors.white.withValues(alpha: .62),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withValues(alpha: .8)),
            ),
          ),
        ),
      );
}

class _StoryActionCard extends StatelessWidget {
  const _StoryActionCard({
    super.key,
    required this.action,
    required this.accent,
    required this.number,
    required this.selected,
    required this.wrong,
    required this.muted,
    required this.running,
    this.onTap,
  });
  final _StoryAction action;
  final Color accent;
  final int number;
  final bool selected;
  final bool wrong;
  final bool muted;
  final bool running;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: onTap != null,
        selected: selected,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(17),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 170),
              transform: Matrix4.identity()
                ..translateByDouble(wrong ? 4 : 0, 0, 0, 1),
              decoration: BoxDecoration(
                color: wrong
                    ? const Color(0xFFFFD4D4)
                    : selected
                        ? const Color(0xFFDDF8EA)
                        : Colors.white.withValues(alpha: .92),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: running
                      ? const Color(0xFFFFD35C)
                      : selected
                          ? accent
                          : Colors.white,
                  width: running ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: action.color.withValues(alpha: .26),
                    blurRadius: running ? 15 : 7,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Opacity(
                opacity: muted ? .33 : 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$number',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Icon(action.icon, color: action.color, size: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _StoryDraggable extends StatelessWidget {
  const _StoryDraggable({
    super.key,
    required this.action,
    required this.accent,
  });
  final _StoryAction action;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final token = Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: accent.withValues(alpha: .35), width: 2),
        boxShadow: [
          BoxShadow(
            color: action.color.withValues(alpha: .26),
            blurRadius: 11,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(action.icon, color: action.color, size: 29),
    );
    return Draggable<_StoryAction>(
      data: action,
      feedback: Material(color: Colors.transparent, child: token),
      childWhenDragging: Opacity(opacity: .22, child: token),
      child: token,
    );
  }
}

class _StoryScenePainter extends CustomPainter {
  const _StoryScenePainter({
    required this.progress,
    required this.running,
    required this.complete,
  });
  final double progress;
  final bool running;
  final bool complete;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(22)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFAEEBFF),
            complete ? const Color(0xFFD9F7C9) : const Color(0xFFFFEDC7),
          ],
        ).createShader(rect),
    );
    final hill = Path()
      ..moveTo(0, size.height * .78)
      ..quadraticBezierTo(size.width * .28, size.height * .62, size.width * .5,
          size.height * .79)
      ..quadraticBezierTo(
          size.width * .76, size.height * .9, size.width, size.height * .68)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = const Color(0xFF98D68A));
    if (running || complete) {
      final x = 24 + (size.width - 48) * progress;
      canvas.drawCircle(
        Offset(x, size.height * .69),
        complete ? 24 : 19,
        Paint()..color = const Color(0xFFFFD35C).withValues(alpha: .82),
      );
      canvas.drawCircle(
        Offset(x - 6, size.height * .65),
        4,
        Paint()..color = Colors.white.withValues(alpha: .85),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StoryScenePainter oldDelegate) =>
      progress != oldDelegate.progress ||
      running != oldDelegate.running ||
      complete != oldDelegate.complete;
}

class SecretCodeGameView extends StatefulWidget {
  const SecretCodeGameView({
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
  State<SecretCodeGameView> createState() => _SecretCodeGameViewState();
}

class _SecretCodeGameViewState extends State<SecretCodeGameView> {
  static const _rounds = [
    _CodeRound(code: [
      3,
      7,
      1
    ], clues: [
      [3, 1, 7],
      [3, 9, 0],
      [0, 7, 1],
    ]),
    _CodeRound(code: [
      6,
      2,
      9
    ], clues: [
      [2, 6, 9],
      [6, 1, 8],
      [0, 2, 9],
    ]),
    _CodeRound(code: [
      4,
      8,
      5
    ], clues: [
      [8, 4, 5],
      [4, 1, 0],
      [0, 8, 5],
    ]),
  ];

  final List<int?> _slots = List<int?>.filled(3, null);
  final List<_CodeAttempt> _attempts = [];
  int _round = 0;
  int? _selectedRune;
  int _feedbackToken = 0;
  bool _locked = false;
  bool _mistake = false;
  bool _sent = false;

  _CodeRound get _currentRound => _rounds[_round];

  List<int> get _runes => <int>{
        ..._currentRound.code,
        (_currentRound.code.first + 4 - 1) % 9 + 1,
      }.toList();

  bool get _ready => _slots.every((digit) => digit != null);

  void _selectRune(int digit) {
    if (_locked || _sent) return;
    HapticFeedback.selectionClick();
    setState(() {
      _mistake = false;
      _selectedRune = _selectedRune == digit ? null : digit;
    });
  }

  void _placeRune(int digit, int slot) {
    if (_locked || _sent) return;
    setState(() {
      _mistake = false;
      final previousSlot = _slots.indexOf(digit);
      if (previousSlot >= 0) _slots[previousSlot] = null;
      _slots[slot] = digit;
      _selectedRune = null;
    });
    HapticFeedback.selectionClick();
  }

  void _tapSocket(int slot) {
    if (_locked || _sent) return;
    final selected = _selectedRune;
    if (selected != null) {
      _placeRune(selected, slot);
      return;
    }
    if (_slots[slot] != null) {
      HapticFeedback.lightImpact();
      setState(() => _slots[slot] = null);
    }
  }

  Future<void> _submit() async {
    if (_locked || _sent || !_ready) return;
    final entered = _slots.cast<int>();
    final feedback = _feedback(entered, _currentRound.code);
    setState(() {
      _attempts.add(_CodeAttempt(
        digits: List<int>.of(entered),
        exact: feedback.$1,
        misplaced: feedback.$2,
      ));
      _slots.fillRange(0, _slots.length, null);
      _selectedRune = null;
      _mistake = feedback.$1 != 3;
    });

    if (feedback.$1 != 3) {
      final token = ++_feedbackToken;
      await Future<void>.delayed(const Duration(milliseconds: 420));
      if (!mounted || token != _feedbackToken || _sent) return;
      setState(() => _mistake = false);
      return;
    }

    _feedbackToken++;
    _locked = true;
    await Future<void>.delayed(const Duration(milliseconds: 620));
    if (!mounted || _sent) return;
    if (_round + 1 < _rounds.length) {
      setState(() {
        _round++;
        _attempts.clear();
        _slots.fillRange(0, _slots.length, null);
        _selectedRune = null;
        _locked = false;
        _mistake = false;
      });
      return;
    }
    _sent = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  (int, int) _feedback(List<int> guess, List<int> code) {
    var exact = 0;
    final remainingGuess = <int>[];
    final remainingCode = <int>[];
    for (var index = 0; index < code.length; index++) {
      if (guess[index] == code[index]) {
        exact++;
      } else {
        remainingGuess.add(guess[index]);
        remainingCode.add(code[index]);
      }
    }
    var misplaced = 0;
    for (final digit in remainingGuess) {
      final match = remainingCode.indexOf(digit);
      if (match >= 0) {
        misplaced++;
        remainingCode.removeAt(match);
      }
    }
    return (exact, misplaced);
  }

  @override
  Widget build(BuildContext context) {
    final copy = _SecretCodeCopy.forLocale(Localizations.localeOf(context));
    final direction = Directionality.of(context);
    return Semantics(
      label: widget.semanticLabel,
      child: Directionality(
        textDirection: direction,
        child: AnimatedContainer(
          key: ValueKey('secret-code-round-$_round'),
          duration: const Duration(milliseconds: 240),
          height: widget.compact ? 390 : 430,
          padding: EdgeInsets.all(widget.compact ? 10 : 14),
          decoration: _sceneDecoration(widget.accent),
          child: Column(
            children: [
              _MissionRibbon(
                color: widget.accent,
                icon: Icons.lock_rounded,
                text: '${copy.round} ${_round + 1}/${_rounds.length}',
                complete: _locked,
              ),
              const SizedBox(height: 8),
              _CodeClueBoard(
                round: _currentRound,
                accent: widget.accent,
                copy: copy,
              ),
              const SizedBox(height: 8),
              _CodeAssemblyBoard(
                runes: _runes,
                slots: _slots,
                selectedRune: _selectedRune,
                accent: widget.accent,
                mistake: _mistake,
                locked: _locked,
                onRuneTap: _selectRune,
                onRuneDropped: _placeRune,
                onSocketTap: _tapSocket,
                onSubmit: _submit,
                copy: copy,
              ),
              if (_attempts.isNotEmpty) ...[
                const SizedBox(height: 6),
                _AttemptStrip(
                  attempt: _attempts.last,
                  accent: widget.accent,
                  copy: copy,
                  attemptIndex: _attempts.length - 1,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeRound {
  const _CodeRound({required this.code, required this.clues});

  final List<int> code;
  final List<List<int>> clues;
}

class _CodeAttempt {
  const _CodeAttempt({
    required this.digits,
    required this.exact,
    required this.misplaced,
  });

  final List<int> digits;
  final int exact;
  final int misplaced;
}

class _CodeClueBoard extends StatelessWidget {
  const _CodeClueBoard({
    required this.round,
    required this.accent,
    required this.copy,
  });

  final _CodeRound round;
  final Color accent;
  final _SecretCodeCopy copy;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: copy.clues,
      child: Container(
        height: 62,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xCFFFFFFF),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: accent.withValues(alpha: .22)),
        ),
        child: Row(
          children: List.generate(round.clues.length, (index) {
            final clue = round.clues[index];
            final feedback = _feedback(clue, round.code);
            return Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(
                  end: index == round.clues.length - 1 ? 0 : 5,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14072D38),
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      clue.join(),
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: Color(0xFF173E49),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FeedbackPeg(
                          color: const Color(0xFF43C997),
                          value: feedback.$1,
                          semanticLabel: copy.exact,
                        ),
                        const SizedBox(width: 5),
                        _FeedbackPeg(
                          color: const Color(0xFFFFC857),
                          value: feedback.$2,
                          semanticLabel: copy.misplaced,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  static (int, int) _feedback(List<int> guess, List<int> code) {
    var exact = 0;
    final remainingGuess = <int>[];
    final remainingCode = <int>[];
    for (var index = 0; index < code.length; index++) {
      if (guess[index] == code[index]) {
        exact++;
      } else {
        remainingGuess.add(guess[index]);
        remainingCode.add(code[index]);
      }
    }
    var misplaced = 0;
    for (final digit in remainingGuess) {
      final match = remainingCode.indexOf(digit);
      if (match >= 0) {
        misplaced++;
        remainingCode.removeAt(match);
      }
    }
    return (exact, misplaced);
  }
}

class _FeedbackPeg extends StatelessWidget {
  const _FeedbackPeg({
    required this.color,
    required this.value,
    required this.semanticLabel,
  });

  final Color color;
  final int value;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$semanticLabel: $value',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 2),
          Text(
            '$value',
            style: const TextStyle(
              color: Color(0xFF526F77),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeAssemblyBoard extends StatelessWidget {
  const _CodeAssemblyBoard({
    required this.runes,
    required this.slots,
    required this.selectedRune,
    required this.accent,
    required this.mistake,
    required this.locked,
    required this.onRuneTap,
    required this.onRuneDropped,
    required this.onSocketTap,
    required this.onSubmit,
    required this.copy,
  });

  final List<int> runes;
  final List<int?> slots;
  final int? selectedRune;
  final Color accent;
  final bool mistake;
  final bool locked;
  final ValueChanged<int> onRuneTap;
  final void Function(int digit, int slot) onRuneDropped;
  final ValueChanged<int> onSocketTap;
  final VoidCallback onSubmit;
  final _SecretCodeCopy copy;

  @override
  Widget build(BuildContext context) {
    final ready = slots.every((digit) => digit != null);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 68,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: mistake ? const Color(0xFFFFE2E4) : const Color(0xBFFFFFFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: mistake
                  ? const Color(0xFFFF6572)
                  : accent.withValues(alpha: .28),
              width: 2,
            ),
          ),
          child: Row(
            textDirection: TextDirection.ltr,
            children: List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: index == 2 ? 0 : 7),
                  child: _CodeSocket(
                    key: ValueKey('secret-code-slot-$index'),
                    digit: slots[index],
                    accent: accent,
                    index: index,
                    label: copy.socket,
                    locked: locked,
                    onDrop: (digit) => onRuneDropped(digit, index),
                    onTap: () => onSocketTap(index),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final digit in runes)
              _CodeRune(
                key: ValueKey('secret-code-rune-$digit'),
                digit: digit,
                accent: accent,
                selected: selectedRune == digit,
                placed: slots.contains(digit),
                label: copy.rune(digit),
                onTap: () => onRuneTap(digit),
              ),
            _CodeIconButton(
              key: const ValueKey('secret-code-submit'),
              icon: Icons.cell_tower_rounded,
              color: ready ? accent : const Color(0xFFB5C8CC),
              tooltip: copy.tryCode,
              onTap: ready ? onSubmit : () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _CodeSocket extends StatelessWidget {
  const _CodeSocket({
    required this.digit,
    required this.accent,
    required this.index,
    required this.label,
    required this.locked,
    required this.onDrop,
    required this.onTap,
    super.key,
  });

  final int? digit;
  final Color accent;
  final int index;
  final String label;
  final bool locked;
  final ValueChanged<int> onDrop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (_) => !locked,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidates, _) {
        final active = candidates.isNotEmpty;
        return Semantics(
          button: true,
          label: '$label ${index + 1}',
          value: digit == null ? null : '$digit',
          onTap: locked ? null : onTap,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: locked ? null : onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: digit == null
                    ? (active ? accent.withValues(alpha: .18) : Colors.white)
                    : accent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: active ? accent : accent.withValues(alpha: .34),
                  width: active ? 3 : 1.5,
                ),
                boxShadow: digit == null
                    ? null
                    : const [
                        BoxShadow(
                          color: Color(0x26072D38),
                          offset: Offset(0, 4),
                          blurRadius: 7,
                        ),
                      ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: digit == null
                    ? Icon(Icons.add_rounded,
                        color: accent.withValues(alpha: .55))
                    : Text(
                        '$digit',
                        key: ValueKey('secret-code-slot-digit-$index-$digit'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CodeRune extends StatelessWidget {
  const _CodeRune({
    required this.digit,
    required this.accent,
    required this.selected,
    required this.placed,
    required this.label,
    required this.onTap,
    super.key,
  });

  final int digit;
  final Color accent;
  final bool selected;
  final bool placed;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tile = AnimatedScale(
      duration: const Duration(milliseconds: 130),
      scale: selected ? 1.1 : (placed ? .82 : 1),
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: placed ? accent.withValues(alpha: .16) : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected ? accent : accent.withValues(alpha: .26),
            width: selected ? 3 : 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1B072D38),
              offset: Offset(0, 4),
              blurRadius: 7,
            ),
          ],
        ),
        child: Text(
          '$digit',
          style: TextStyle(
            color: accent,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      label: label,
      selected: selected,
      onTap: onTap,
      child: Draggable<int>(
        data: digit,
        feedback: Material(
            color: Colors.transparent,
            child: Opacity(opacity: .9, child: tile)),
        childWhenDragging: Opacity(opacity: .35, child: tile),
        child: GestureDetector(onTap: onTap, child: tile),
      ),
    );
  }
}

class _CodeIconButton extends StatelessWidget {
  const _CodeIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            width: 52,
            height: 52,
            child: Icon(icon, color: color, size: 26),
          ),
        ),
      ),
    );
  }
}

class _AttemptStrip extends StatelessWidget {
  const _AttemptStrip({
    required this.attempt,
    required this.accent,
    required this.copy,
    required this.attemptIndex,
  });

  final _CodeAttempt attempt;
  final Color accent;
  final _SecretCodeCopy copy;
  final int attemptIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('secret-code-attempt-$attemptIndex'),
      height: 29,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: attempt.exact == 3
            ? const Color(0xFFE4FFF1)
            : const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            attempt.digits.join(),
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          KeyedSubtree(
            key: ValueKey(
              'secret-code-feedback-${attempt.exact}-${attempt.misplaced}',
            ),
            child: Row(
              children: [
                _FeedbackPeg(
                  color: const Color(0xFF43C997),
                  value: attempt.exact,
                  semanticLabel: copy.exact,
                ),
                const SizedBox(width: 9),
                _FeedbackPeg(
                  color: const Color(0xFFFFC857),
                  value: attempt.misplaced,
                  semanticLabel: copy.misplaced,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecretCodeCopy {
  const _SecretCodeCopy({
    required this.round,
    required this.clues,
    required this.exact,
    required this.misplaced,
    required this.tryCode,
    required this.socket,
    required this.runeName,
  });

  final String round;
  final String clues;
  final String exact;
  final String misplaced;
  final String tryCode;
  final String socket;
  final String runeName;

  String rune(int digit) => '$runeName $digit';

  static _SecretCodeCopy forLocale(Locale locale) {
    return _copies[locale.languageCode] ?? _copies['en']!;
  }

  static const _copies = <String, _SecretCodeCopy>{
    'ar': _SecretCodeCopy(
      round: 'الجولة',
      clues: 'دلائل الرمز',
      exact: 'مكان صحيح',
      misplaced: 'رقم موجود',
      tryCode: 'جرّب الرمز',
      socket: 'فتحة الرمز',
      runeName: 'رون',
    ),
    'de': _SecretCodeCopy(
      round: 'Runde',
      clues: 'Code-Hinweise',
      exact: 'Richtige Stelle',
      misplaced: 'Falsche Stelle',
      tryCode: 'Code testen',
      socket: 'Codeplatz',
      runeName: 'Rune',
    ),
    'en': _SecretCodeCopy(
      round: 'Round',
      clues: 'Code clues',
      exact: 'Exact place',
      misplaced: 'Wrong place',
      tryCode: 'Try code',
      socket: 'Code socket',
      runeName: 'Rune',
    ),
    'es': _SecretCodeCopy(
      round: 'Ronda',
      clues: 'Pistas del código',
      exact: 'Lugar exacto',
      misplaced: 'Otro lugar',
      tryCode: 'Probar código',
      socket: 'Ranura de código',
      runeName: 'Runa',
    ),
    'fr': _SecretCodeCopy(
      round: 'Manche',
      clues: 'Indices du code',
      exact: 'Bonne place',
      misplaced: 'Autre place',
      tryCode: 'Tester le code',
      socket: 'Emplacement du code',
      runeName: 'Rune',
    ),
    'hi': _SecretCodeCopy(
      round: 'दौर',
      clues: 'कोड के संकेत',
      exact: 'सही जगह',
      misplaced: 'दूसरी जगह',
      tryCode: 'कोड आज़माएँ',
      socket: 'कोड स्थान',
      runeName: 'रून',
    ),
    'it': _SecretCodeCopy(
      round: 'Turno',
      clues: 'Indizi del codice',
      exact: 'Posto esatto',
      misplaced: 'Altro posto',
      tryCode: 'Prova codice',
      socket: 'Alloggiamento codice',
      runeName: 'Runa',
    ),
    'ja': _SecretCodeCopy(
      round: 'ラウンド',
      clues: 'コードのヒント',
      exact: '正しい位置',
      misplaced: '別の位置',
      tryCode: 'コードを試す',
      socket: 'コードの枠',
      runeName: 'ルーン',
    ),
    'ko': _SecretCodeCopy(
      round: '라운드',
      clues: '암호 단서',
      exact: '정확한 자리',
      misplaced: '다른 자리',
      tryCode: '암호 확인',
      socket: '암호 칸',
      runeName: '룬',
    ),
    'pt': _SecretCodeCopy(
      round: 'Rodada',
      clues: 'Pistas do código',
      exact: 'Lugar certo',
      misplaced: 'Outro lugar',
      tryCode: 'Testar código',
      socket: 'Espaço do código',
      runeName: 'Runa',
    ),
    'ru': _SecretCodeCopy(
      round: 'Раунд',
      clues: 'Подсказки к коду',
      exact: 'Точное место',
      misplaced: 'Другое место',
      tryCode: 'Проверить код',
      socket: 'Ячейка кода',
      runeName: 'Руна',
    ),
    'zh': _SecretCodeCopy(
      round: '回合',
      clues: '密码线索',
      exact: '位置正确',
      misplaced: '位置不同',
      tryCode: '尝试密码',
      socket: '密码槽',
      runeName: '符文',
    ),
  };
}

class MoonClockGameView extends StatefulWidget {
  const MoonClockGameView({
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
  State<MoonClockGameView> createState() => _MoonClockGameViewState();
}

class _MoonClockGameViewState extends State<MoonClockGameView> {
  static const _targets = [
    _ClockTarget(hour: 3, minute: 0, startMinute: 37),
    _ClockTarget(hour: 6, minute: 15, startMinute: 48),
    _ClockTarget(hour: 9, minute: 45, startMinute: 8),
  ];

  int _round = 0;
  double _minutes = _targets.first.startMinute.toDouble();
  bool _roundLocked = false;
  bool _mistake = false;
  bool _sent = false;
  int _feedbackToken = 0;

  _ClockTarget get _target => _targets[_round];

  void _drag(Offset local, Size size) {
    if (_roundLocked || _sent) return;
    final center = Offset(size.width / 2, size.height / 2);
    final delta = local - center;
    var angle = math.atan2(delta.dy, delta.dx) + math.pi / 2;
    if (angle < 0) angle += math.pi * 2;
    setState(() => _minutes = (angle / (math.pi * 2) * 60).roundToDouble());
  }

  void _release() {
    if (_roundLocked || _sent) return;
    final difference = (_minutes - _target.minute).abs();
    final circularDifference = math.min(difference, 60 - difference);
    if (circularDifference > 3) {
      final token = ++_feedbackToken;
      setState(() => _mistake = true);
      Future<void>.delayed(const Duration(milliseconds: 380), () {
        if (!mounted || token != _feedbackToken || _roundLocked || _sent) {
          return;
        }
        setState(() => _mistake = false);
      });
      return;
    }

    _feedbackToken++;
    setState(() {
      _minutes = _target.minute.toDouble();
      _mistake = false;
      _roundLocked = true;
    });
    Future<void>.delayed(
      const Duration(milliseconds: 560),
      () {
        if (!mounted || _sent) return;
        if (_round == _targets.length - 1) {
          _sent = true;
          widget.onAnswerSelected(widget.correctAnswer);
          return;
        }
        setState(() {
          _round++;
          _minutes = _target.startMinute.toDouble();
          _roundLocked = false;
        });
      },
    );
  }

  void _adjustSemantically(int direction) {
    if (_roundLocked || _sent) return;
    final snapped = (_minutes / 5).round() * 5;
    setState(() => _minutes = ((snapped + direction * 5) % 60).toDouble());
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.compact ? 204.0 : 244.0;
    final copy = _MoonClockA11y.forLocale(Localizations.localeOf(context));
    final currentMinute = _minutes.round() % 60;
    return Directionality(
      textDirection: copy.rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Semantics(
        key: const ValueKey('moon-clock-semantics'),
        container: true,
        label: widget.semanticLabel,
        value: copy.value(
          round: _round + 1,
          total: _targets.length,
          targetHour: _target.hour,
          targetMinute: _target.minute,
          currentMinute: currentMinute,
        ),
        hint: copy.hint,
        increasedValue: copy.later,
        decreasedValue: copy.earlier,
        onIncrease: _roundLocked || _sent ? null : () => _adjustSemantically(1),
        onDecrease:
            _roundLocked || _sent ? null : () => _adjustSemantically(-1),
        onTap: _roundLocked || _sent ? null : _release,
        child: Container(
          height: widget.compact ? 252 : 300,
          padding: const EdgeInsets.all(10),
          decoration: _sceneDecoration(widget.accent),
          child: Column(
            children: [
              _MissionRibbon(
                color: widget.accent,
                icon: Icons.rocket_launch_rounded,
                text:
                    '${_target.hour}:${_target.minute.toString().padLeft(2, '0')}',
                complete: _roundLocked,
              ),
              const SizedBox(height: 7),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onPanDown: (details) =>
                        _drag(details.localPosition, Size.square(size)),
                    onPanUpdate: (details) =>
                        _drag(details.localPosition, Size.square(size)),
                    onPanEnd: (_) => _release(),
                    child: AnimatedScale(
                      scale: _roundLocked ? 1.04 : 1,
                      duration: const Duration(milliseconds: 250),
                      child: CustomPaint(
                        key: const ValueKey('moon-clock-face'),
                        size: Size.square(size),
                        painter: _MoonClockPainter(
                          accent: widget.accent,
                          minutes: _minutes,
                          targetHour: _target.hour,
                          round: _round,
                          complete: _roundLocked,
                          mistake: _mistake,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoonClockA11y {
  const _MoonClockA11y({
    required this.round,
    required this.of,
    required this.target,
    required this.current,
    required this.minutes,
    required this.hint,
    required this.later,
    required this.earlier,
    this.rtl = false,
  });

  final String round;
  final String of;
  final String target;
  final String current;
  final String minutes;
  final String hint;
  final String later;
  final String earlier;
  final bool rtl;

  String value(
          {required int round,
          required int total,
          required int targetHour,
          required int targetMinute,
          required int currentMinute}) =>
      '${this.round} $round $of $total, $target $targetHour:${targetMinute.toString().padLeft(2, '0')}, $current $currentMinute $minutes';

  static _MoonClockA11y forLocale(Locale locale) =>
      _copies[locale.languageCode] ?? _copies['en']!;

  static const _copies = <String, _MoonClockA11y>{
    'ar': _MoonClockA11y(
        round: 'الجولة',
        of: 'من',
        target: 'الوقت المطلوب',
        current: 'الدقائق الحالية',
        minutes: 'دقيقة',
        hint:
            'اسحب لأعلى أو لأسفل لتحريك عقرب الدقائق خمس دقائق، ثم انقر مرتين للتحقق',
        later: 'بعد خمس دقائق',
        earlier: 'قبل خمس دقائق',
        rtl: true),
    'de': _MoonClockA11y(
        round: 'Runde',
        of: 'von',
        target: 'Zielzeit',
        current: 'aktuelle Minuten',
        minutes: 'Minuten',
        hint:
            'Nach oben oder unten wischen, um den Minutenzeiger um fünf Minuten zu bewegen, dann doppeltippen zum Prüfen',
        later: 'Fünf Minuten später',
        earlier: 'Fünf Minuten früher'),
    'en': _MoonClockA11y(
        round: 'Round',
        of: 'of',
        target: 'target time',
        current: 'current minutes',
        minutes: 'minutes',
        hint:
            'Swipe up or down to move the minute hand by five minutes, then double tap to check',
        later: 'Five minutes later',
        earlier: 'Five minutes earlier'),
    'es': _MoonClockA11y(
        round: 'Ronda',
        of: 'de',
        target: 'hora objetivo',
        current: 'minutos actuales',
        minutes: 'minutos',
        hint:
            'Desliza arriba o abajo para mover el minutero cinco minutos y toca dos veces para comprobar',
        later: 'Cinco minutos después',
        earlier: 'Cinco minutos antes'),
    'fr': _MoonClockA11y(
        round: 'Manche',
        of: 'sur',
        target: 'heure cible',
        current: 'minutes actuelles',
        minutes: 'minutes',
        hint:
            'Balaye vers le haut ou le bas pour déplacer l’aiguille de cinq minutes, puis touche deux fois pour vérifier',
        later: 'Cinq minutes plus tard',
        earlier: 'Cinq minutes plus tôt'),
    'hi': _MoonClockA11y(
        round: 'दौर',
        of: 'में से',
        target: 'लक्ष्य समय',
        current: 'अभी के मिनट',
        minutes: 'मिनट',
        hint:
            'मिनट की सुई को पाँच मिनट चलाने के लिए ऊपर या नीचे स्वाइप करें, फिर जाँचने के लिए दो बार टैप करें',
        later: 'पाँच मिनट बाद',
        earlier: 'पाँच मिनट पहले'),
    'it': _MoonClockA11y(
        round: 'Turno',
        of: 'di',
        target: 'ora obiettivo',
        current: 'minuti attuali',
        minutes: 'minuti',
        hint:
            'Scorri in alto o in basso per spostare la lancetta di cinque minuti, poi tocca due volte per verificare',
        later: 'Cinque minuti dopo',
        earlier: 'Cinque minuti prima'),
    'ja': _MoonClockA11y(
        round: 'ラウンド',
        of: '/',
        target: '目標時刻',
        current: '現在の分',
        minutes: '分',
        hint: '上下にスワイプして分針を5分動かし、ダブルタップで確認します',
        later: '5分後',
        earlier: '5分前'),
    'ko': _MoonClockA11y(
        round: '라운드',
        of: '/',
        target: '목표 시각',
        current: '현재 분',
        minutes: '분',
        hint: '위아래로 쓸어 분침을 5분씩 움직이고 두 번 탭하여 확인하세요',
        later: '5분 뒤',
        earlier: '5분 전'),
    'pt': _MoonClockA11y(
        round: 'Rodada',
        of: 'de',
        target: 'hora-alvo',
        current: 'minutos atuais',
        minutes: 'minutos',
        hint:
            'Deslize para cima ou para baixo para mover o ponteiro cinco minutos e toque duas vezes para verificar',
        later: 'Cinco minutos depois',
        earlier: 'Cinco minutos antes'),
    'ru': _MoonClockA11y(
        round: 'Раунд',
        of: 'из',
        target: 'нужное время',
        current: 'текущие минуты',
        minutes: 'минут',
        hint:
            'Смахивайте вверх или вниз, чтобы двигать минутную стрелку на пять минут, затем дважды нажмите для проверки',
        later: 'На пять минут позже',
        earlier: 'На пять минут раньше'),
    'zh': _MoonClockA11y(
        round: '回合',
        of: '/',
        target: '目标时间',
        current: '当前分钟',
        minutes: '分钟',
        hint: '上下滑动让分针移动五分钟，双击检查',
        later: '五分钟后',
        earlier: '五分钟前'),
  };
}

class _ClockTarget {
  const _ClockTarget({
    required this.hour,
    required this.minute,
    required this.startMinute,
  });

  final int hour;
  final int minute;
  final int startMinute;
}

BoxDecoration _sceneDecoration(Color accent) => BoxDecoration(
      gradient: LinearGradient(
        colors: [
          accent.withValues(alpha: .22),
          const Color(0xFFF2FBFF),
          Colors.white
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: accent.withValues(alpha: .28), width: 1.5),
    );

class _MissionRibbon extends StatelessWidget {
  const _MissionRibbon({
    required this.color,
    required this.icon,
    required this.text,
    required this.complete,
  });

  final Color color;
  final IconData icon;
  final String text;
  final bool complete;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        height: 43,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: complete ? const Color(0xFF42C997) : const Color(0xEFFFFFFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Color(0x17072D38), offset: Offset(0, 3))
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(complete ? Icons.check_circle_rounded : icon,
                color: complete ? Colors.white : color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                style: TextStyle(
                  color: complete ? Colors.white : const Color(0xFF153E49),
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.number,
    required this.action,
    required this.color,
    required this.complete,
  });

  final int number;
  final int action;
  final Color color;
  final bool complete;

  static const _icons = [
    Icons.water_drop_rounded,
    Icons.spa_rounded,
    Icons.wb_sunny_rounded,
    Icons.local_florist_rounded,
  ];

  @override
  Widget build(BuildContext context) => Container(
        width: 68,
        decoration: BoxDecoration(
          color: complete ? const Color(0xFFE7FFF3) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: complete
                  ? const Color(0xFF42C997)
                  : color.withValues(alpha: .32),
              width: 2),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1B072D38), offset: Offset(0, 5), blurRadius: 7)
          ],
        ),
        child: Stack(
          children: [
            Center(child: Icon(_icons[action], size: 31, color: color)),
            Positioned(
              top: 5,
              left: 7,
              child: Text('$number',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xFF58737A))),
            ),
            const Positioned(
                right: 5,
                bottom: 5,
                child: Icon(Icons.drag_indicator_rounded,
                    size: 18, color: Color(0xFF9DB2B8))),
          ],
        ),
      );
}

class _KeyButton extends StatefulWidget {
  const _KeyButton({
    required this.digit,
    required this.color,
    required this.onTap,
    super.key,
  });
  final int digit;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? .91 : 1,
          duration: const Duration(milliseconds: 80),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: widget.color.withValues(alpha: .28)),
              boxShadow: _pressed
                  ? null
                  : const [
                      BoxShadow(color: Color(0x28072D38), offset: Offset(0, 4))
                    ],
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.digit}',
              style: TextStyle(
                  color: widget.color,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0),
            ),
          ),
        ),
      );
}

class _MoonClockPainter extends CustomPainter {
  const _MoonClockPainter({
    required this.accent,
    required this.minutes,
    required this.targetHour,
    required this.round,
    required this.complete,
    required this.mistake,
  });
  final Color accent;
  final double minutes;
  final int targetHour;
  final int round;
  final bool complete;
  final bool mistake;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;
    canvas.drawCircle(center + const Offset(0, 5), radius,
        Paint()..color = const Color(0x24072D38));
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFFFD86B));
    canvas.drawCircle(
        center, radius - 8, Paint()..color = const Color(0xFFFFF5C8));

    final tickPaint = Paint()
      ..color = const Color(0xFF31515A)
      ..strokeCap = StrokeCap.round;
    for (var tick = 0; tick < 12; tick++) {
      final angle = tick * math.pi / 6 - math.pi / 2;
      final outer =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius - 14);
      final inner = center +
          Offset(math.cos(angle), math.sin(angle)) *
              (radius - (tick % 3 == 0 ? 29 : 22));
      tickPaint.strokeWidth = tick % 3 == 0 ? 4 : 2;
      canvas.drawLine(inner, outer, tickPaint);
    }

    final hourAngle =
        ((targetHour % 12) + minutes / 60) / 12 * math.pi * 2 - math.pi / 2;
    _hand(canvas, center, hourAngle, radius * .48, const Color(0xFFEF665F), 8);
    final minuteAngle = minutes / 60 * math.pi * 2 - math.pi / 2;
    _hand(canvas, center, minuteAngle, radius * .69, accent, 6);
    canvas.drawCircle(
        center,
        10,
        Paint()
          ..color = mistake
              ? const Color(0xFFEF665F)
              : complete
                  ? const Color(0xFF42C997)
                  : accent);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);

    if (mistake) {
      canvas.drawCircle(
        center,
        radius - 3,
        Paint()
          ..color = const Color(0xFFEF665F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7,
      );
    }

    final rocket = Offset(size.width - 30, 32);
    canvas.drawCircle(
        rocket,
        19,
        Paint()
          ..color =
              complete ? const Color(0xFF42C997) : const Color(0xFFFFFFFF));
    final iconPaint = Paint()
      ..color = complete ? Colors.white : accent
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    if (complete) {
      canvas.drawPath(
        Path()
          ..moveTo(rocket.dx - 8, rocket.dy)
          ..lineTo(rocket.dx - 2, rocket.dy + 6)
          ..lineTo(rocket.dx + 9, rocket.dy - 7),
        iconPaint,
      );
    } else {
      final star = Path();
      for (var point = 0; point < 10; point++) {
        final angle = -math.pi / 2 + point * math.pi / 5;
        final length = point.isEven ? 9.0 : 4.2;
        final vertex =
            rocket + Offset(math.cos(angle), math.sin(angle)) * length;
        if (point == 0) {
          star.moveTo(vertex.dx, vertex.dy);
        } else {
          star.lineTo(vertex.dx, vertex.dy);
        }
      }
      star.close();
      canvas.drawPath(star, iconPaint..style = PaintingStyle.fill);
    }

    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(
        Offset(center.dx - 20 + index * 20, size.height - 15),
        5,
        Paint()
          ..color = index < round || (index == round && complete)
              ? const Color(0xFF42C997)
              : index == round
                  ? accent
                  : const Color(0xFFC4D9DB),
      );
    }
  }

  void _hand(Canvas canvas, Offset center, double angle, double length,
      Color color, double width) {
    canvas.drawLine(
      center,
      center + Offset(math.cos(angle), math.sin(angle)) * length,
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _MoonClockPainter oldDelegate) =>
      oldDelegate.minutes != minutes ||
      oldDelegate.targetHour != targetHour ||
      oldDelegate.round != round ||
      oldDelegate.complete != complete ||
      oldDelegate.mistake != mistake ||
      oldDelegate.accent != accent;
}

class _WorkshopPainter extends CustomPainter {
  const _WorkshopPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x1600AFA6);
    for (var index = 0; index < 8; index++) {
      final x = 18.0 + index * (size.width - 36) / 7;
      final y = size.height - 18 - (index.isEven ? 7 : 0);
      canvas.drawCircle(Offset(x, y), index.isEven ? 4 : 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
