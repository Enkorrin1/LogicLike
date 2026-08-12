import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PatternWorkshopVariant { train, path }

class OddCardInvestigationGameView extends StatefulWidget {
  const OddCardInvestigationGameView({
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
  State<OddCardInvestigationGameView> createState() =>
      _OddCardInvestigationGameViewState();
}

class _OddCardInvestigationGameViewState
    extends State<OddCardInvestigationGameView> with TickerProviderStateMixin {
  static const _evidenceCounts = [3, 4, 3, 2, 4, 3];
  static const _correctEvidence = {0, 2, 5};
  static const _classificationCounts = [3, 5, 3, 2];
  static const _classificationAnswers = [true, false, true, false];
  late final AnimationController _entrance;
  late final AnimationController _reaction;
  final Set<int> _evidence = {};
  int _stage = 0;
  int _classification = 0;
  int _semanticChoice = 0;
  int? _wrongItem;
  bool _locked = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    )..forward();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );
  }

  @override
  void dispose() {
    _entrance.dispose();
    _reaction.dispose();
    super.dispose();
  }

  void _toggleEvidence(int index) {
    if (_locked || _stage != 0) return;
    setState(() {
      _wrongItem = null;
      _evidence.contains(index)
          ? _evidence.remove(index)
          : _evidence.add(index);
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _confirmEvidence() async {
    if (_locked || _stage != 0 || _evidence.isEmpty) return;
    if (!_sameSet(_evidence, _correctEvidence)) {
      setState(() => _wrongItem = -1);
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() {
        _wrongItem = null;
        _evidence.removeWhere((index) => !_correctEvidence.contains(index));
      });
      _reaction.reset();
      return;
    }
    await _advanceTo(1);
  }

  Future<void> _chooseRule(int index) async {
    if (_locked || _stage != 1) return;
    if (index != 1) {
      setState(() => _wrongItem = index);
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() => _wrongItem = null);
      _reaction.reset();
      return;
    }
    await _advanceTo(2);
  }

  Future<void> _classify(bool followsRule) async {
    if (_locked || _stage != 2 || _answerSent) return;
    if (followsRule != _classificationAnswers[_classification]) {
      setState(() => _wrongItem = followsRule ? 1 : 0);
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() => _wrongItem = null);
      _reaction.reset();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _locked = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    if (_classification + 1 < _classificationCounts.length) {
      setState(() {
        _classification++;
        _semanticChoice = 0;
        _locked = false;
      });
      _entrance.forward(from: 0);
      return;
    }
    if (!_answerSent) {
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  Future<void> _advanceTo(int stage) async {
    setState(() => _locked = true);
    HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _stage = stage;
      _semanticChoice = 0;
      _wrongItem = null;
      _locked = false;
    });
    _entrance.forward(from: 0);
  }

  bool _sameSet(Set<int> left, Set<int> right) {
    return left.length == right.length && left.containsAll(right);
  }

  int get _semanticChoiceCount => switch (_stage) {
        0 => _evidenceCounts.length + 1,
        1 => 3,
        _ => 2,
      };

  void _moveSemanticChoice(int delta) {
    if (_locked || _answerSent) return;
    setState(() {
      _semanticChoice = (_semanticChoice + delta) % _semanticChoiceCount;
    });
  }

  void _activateSemanticChoice() {
    if (_locked || _answerSent) return;
    switch (_stage) {
      case 0:
        if (_semanticChoice == _evidenceCounts.length) {
          _confirmEvidence();
        } else {
          _toggleEvidence(_semanticChoice);
        }
      case 1:
        _chooseRule(_semanticChoice);
      default:
        _classify(_semanticChoice == 0);
    }
  }

  String _semanticValue(_OddCardCopy copy) => switch (_stage) {
        0 when _semanticChoice == _evidenceCounts.length => copy.check,
        0 => copy.specimenLabel(
            _semanticChoice + 1,
            _evidenceCounts[_semanticChoice],
            _evidence.contains(_semanticChoice),
          ),
        1 => copy.ruleOption(_semanticChoice + 2),
        _ =>
          '${copy.stageProgress(_classification + 1, _classificationCounts.length)}, ${_semanticChoice == 0 ? copy.follows : copy.breaksRule}',
      };

  @override
  Widget build(BuildContext context) {
    final copy = _OddCardCopy.forLocale(Localizations.localeOf(context));
    final navigation =
        _OddNavigationCopy.forLocale(Localizations.localeOf(context));
    final direction = Localizations.localeOf(context).languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;
    return Semantics(
      key: const ValueKey('odd-card-semantics'),
      container: true,
      label: '${widget.semanticLabel}. ${copy.stageProgress(_stage + 1, 3)}',
      value: _semanticValue(copy),
      hint: switch (_stage) {
        0 => copy.evidenceHint,
        1 => copy.ruleHint,
        _ => copy.classifyHint,
      },
      increasedValue: navigation.nextChoice,
      decreasedValue: navigation.previousChoice,
      onIncrease: _locked || _answerSent ? null : () => _moveSemanticChoice(1),
      onDecrease: _locked || _answerSent ? null : () => _moveSemanticChoice(-1),
      onTap: _locked || _answerSent ? null : _activateSemanticChoice,
      child: _WorkshopFrame(
        compact: widget.compact,
        semanticLabel: copy.stageProgress(_stage + 1, 3),
        child: Directionality(
          textDirection: direction,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF13264C),
                  Color.lerp(const Color(0xFF13264C), widget.accent, .46)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: _InvestigationBackdropPainter()),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    widget.compact ? 12 : 16,
                    11,
                    widget.compact ? 12 : 16,
                    12,
                  ),
                  child: Column(
                    children: [
                      _InvestigationHeader(
                        stage: _stage,
                        title: [
                          copy.evidence,
                          copy.rule,
                          copy.classify,
                        ][_stage],
                        accent: widget.accent,
                      ),
                      const SizedBox(height: 9),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween(begin: .94, end: 1.0)
                                  .animate(animation),
                              child: child,
                            ),
                          ),
                          child: switch (_stage) {
                            0 => _buildEvidence(copy),
                            1 => _buildRuleChoice(copy),
                            _ => _buildClassification(copy),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvidence(_OddCardCopy copy) {
    final selected = _evidence.toList()..sort();
    return Column(
      key: const ValueKey('odd-stage-evidence'),
      children: [
        Expanded(
          child: GridView.builder(
            key: ValueKey('odd-evidence-state-${selected.join('-')}'),
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.45,
              crossAxisSpacing: 8,
              mainAxisSpacing: 7,
            ),
            itemCount: _evidenceCounts.length,
            itemBuilder: (context, index) => _SpecimenCard(
              key: ValueKey('odd-evidence-card-$index'),
              satelliteCount: _evidenceCounts[index],
              accent: widget.accent,
              selected: _evidence.contains(index),
              semanticsLabel: copy.specimenLabel(
                index + 1,
                _evidenceCounts[index],
                _evidence.contains(index),
              ),
              semanticsHint: copy.evidenceHint,
              onTap: () => _toggleEvidence(index),
            ),
          ),
        ),
        const SizedBox(height: 7),
        _InvestigationButton(
          key: const ValueKey('odd-evidence-confirm'),
          label: copy.check,
          icon: Icons.search_rounded,
          accent: _wrongItem == -1 ? const Color(0xFFFF6875) : widget.accent,
          semanticsKey: const ValueKey('odd-evidence-confirm-semantic'),
          onTap: _confirmEvidence,
          shake: _wrongItem == -1 ? _reaction.value : 0,
        ),
      ],
    );
  }

  Widget _buildRuleChoice(_OddCardCopy copy) {
    return Column(
      key: const ValueKey('odd-stage-rule'),
      children: [
        Text(
          copy.whichRule,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            children: List.generate(3, (index) {
              final count = index + 2;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _RuleLens(
                    key: ValueKey('odd-rule-$index'),
                    count: count,
                    accent: widget.accent,
                    wrong: _wrongItem == index,
                    semanticLabel: copy.ruleOption(count),
                    semanticHint: copy.ruleHint,
                    semanticsKey: ValueKey('odd-rule-semantic-$index'),
                    onTap: () => _chooseRule(index),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildClassification(_OddCardCopy copy) {
    final count = _classificationCounts[_classification];
    return Column(
      key: ValueKey('odd-stage-classify-$_classification'),
      children: [
        Expanded(
          child: Center(
            child: Draggable<int>(
              key: ValueKey('odd-classify-card-$_classification'),
              data: count,
              feedback: Material(
                type: MaterialType.transparency,
                child: SizedBox(
                  width: 112,
                  height: 82,
                  child: _SpecimenCard(
                    satelliteCount: count,
                    accent: widget.accent,
                    selected: true,
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: .22,
                child: _SpecimenCard(
                  satelliteCount: count,
                  accent: widget.accent,
                  selected: false,
                ),
              ),
              child: SizedBox(
                width: 112,
                child: _SpecimenCard(
                  satelliteCount: count,
                  accent: widget.accent,
                  selected: false,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _ClassificationBin(
                key: ValueKey('odd-bin-follows-$_classification'),
                label: copy.follows,
                icon: Icons.check_rounded,
                color: const Color(0xFF4DD5A5),
                wrong: _wrongItem == 1,
                semanticHint: copy.classifyHint,
                semanticsKey:
                    ValueKey('odd-bin-follows-semantic-$_classification'),
                onAccept: () => _classify(true),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _ClassificationBin(
                key: ValueKey('odd-bin-breaks-$_classification'),
                label: copy.breaksRule,
                icon: Icons.close_rounded,
                color: const Color(0xFFFF7581),
                wrong: _wrongItem == 0,
                semanticHint: copy.classifyHint,
                semanticsKey:
                    ValueKey('odd-bin-breaks-semantic-$_classification'),
                onAccept: () => _classify(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InvestigationHeader extends StatelessWidget {
  const _InvestigationHeader({
    required this.stage,
    required this.title,
    required this.accent,
  });

  final int stage;
  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), offset: Offset(0, 4)),
            ],
          ),
          child: Icon(Icons.manage_search_rounded, color: accent, size: 24),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
        Row(
          children: List.generate(3, (index) {
            final active = index <= stage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: index == stage ? 19 : 8,
              height: 8,
              margin: const EdgeInsetsDirectional.only(start: 5),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFFFD75E) : Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SpecimenCard extends StatelessWidget {
  const _SpecimenCard({
    required this.satelliteCount,
    required this.accent,
    required this.selected,
    this.onTap,
    this.semanticsLabel,
    this.semanticsHint,
    super.key,
  });

  final int satelliteCount;
  final Color accent;
  final bool selected;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final String? semanticsHint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: semanticsLabel ?? '$satelliteCount',
      hint: semanticsHint,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFF8D9) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? const Color(0xFFFFD65A) : Colors.white54,
              width: selected ? 3 : 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33071930),
                offset: Offset(0, 5),
                blurRadius: 7,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _SpecimenPainter(
              satelliteCount: satelliteCount,
              accent: accent,
              selected: selected,
            ),
          ),
        ),
      ),
    );
  }
}

class _RuleLens extends StatelessWidget {
  const _RuleLens({
    required this.count,
    required this.accent,
    required this.wrong,
    required this.semanticLabel,
    required this.semanticHint,
    required this.semanticsKey,
    required this.onTap,
    super.key,
  });

  final int count;
  final Color accent;
  final bool wrong;
  final String semanticLabel;
  final String semanticHint;
  final Key semanticsKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: semanticsKey,
      button: true,
      label: semanticLabel,
      hint: semanticHint,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: wrong ? const Color(0xFFFFDADD) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: wrong ? const Color(0xFFFF6472) : Colors.white70,
              width: 3,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x35000000), offset: Offset(0, 6)),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CustomPaint(
                  painter: _SpecimenPainter(
                    satelliteCount: count,
                    accent: accent,
                    selected: false,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              PositionedDirectional(
                end: 7,
                bottom: 6,
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF17294E),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
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

class _ClassificationBin extends StatelessWidget {
  const _ClassificationBin({
    required this.label,
    required this.icon,
    required this.color,
    required this.wrong,
    required this.semanticHint,
    required this.semanticsKey,
    required this.onAccept,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool wrong;
  final String semanticHint;
  final Key semanticsKey;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: semanticsKey,
      button: true,
      label: label,
      hint: semanticHint,
      onTap: onAccept,
      child: DragTarget<int>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (_) => onAccept(),
        builder: (context, candidates, _) {
          final hovering = candidates.isNotEmpty;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: wrong
                  ? const Color(0xFFFFDADD)
                  : hovering
                      ? color
                      : color.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: color, width: hovering ? 3 : 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: hovering ? Colors.white : color, size: 23),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hovering ? Colors.white : const Color(0xFFF8FBFF),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InvestigationButton extends StatelessWidget {
  const _InvestigationButton({
    required this.label,
    required this.icon,
    required this.accent,
    required this.semanticsKey,
    required this.onTap,
    required this.shake,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final Key semanticsKey;
  final VoidCallback onTap;
  final double shake;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(math.sin(shake * math.pi * 8) * (1 - shake) * 5, 0),
      child: Semantics(
        key: semanticsKey,
        button: true,
        label: label,
        excludeSemantics: true,
        onTap: onTap,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Color(0x44000000), offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 21),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecimenPainter extends CustomPainter {
  const _SpecimenPainter({
    required this.satelliteCount,
    required this.accent,
    required this.selected,
  });

  final int satelliteCount;
  final Color accent;
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * .2;
    canvas.drawCircle(
      center + const Offset(0, 3),
      radius * 1.12,
      Paint()..color = const Color(0x22000000),
    );
    canvas.drawCircle(center, radius, Paint()..color = accent);
    canvas.drawCircle(
      center.translate(-radius * .28, -radius * .32),
      radius * .25,
      Paint()..color = Colors.white.withValues(alpha: .66),
    );
    for (var index = 0; index < satelliteCount; index++) {
      final angle = -math.pi / 2 + index * math.pi * 2 / satelliteCount;
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * radius * 1.65;
      canvas.drawCircle(
        point + const Offset(0, 2),
        radius * .23,
        Paint()..color = const Color(0x26000000),
      );
      canvas.drawCircle(
        point,
        radius * .23,
        Paint()..color = const Color(0xFFFFD35C),
      );
    }
    if (selected) {
      final badge = Offset(size.width - 13, 13);
      canvas.drawCircle(badge, 10, Paint()..color = const Color(0xFF46C996));
      canvas.drawPath(
        Path()
          ..moveTo(badge.dx - 5, badge.dy)
          ..lineTo(badge.dx - 1, badge.dy + 4)
          ..lineTo(badge.dx + 6, badge.dy - 5),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpecimenPainter oldDelegate) {
    return oldDelegate.satelliteCount != satelliteCount ||
        oldDelegate.accent != accent ||
        oldDelegate.selected != selected;
  }
}

class _InvestigationBackdropPainter extends CustomPainter {
  const _InvestigationBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .12);
    for (var index = 0; index < 18; index++) {
      final x = (index * 73 % 347) / 347 * size.width;
      final y = (index * 47 % 271) / 271 * size.height;
      canvas.drawCircle(Offset(x, y), index % 4 == 0 ? 2.2 : 1.1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OddCardCopy {
  const _OddCardCopy({
    required this.evidence,
    required this.rule,
    required this.classify,
    required this.check,
    required this.whichRule,
    required this.follows,
    required this.breaksRule,
    required this.stage,
    required this.of,
    required this.specimen,
    required this.satellites,
    required this.selected,
    required this.evidenceHint,
    required this.ruleOptionPrefix,
    required this.ruleHint,
    required this.classifyHint,
  });

  final String evidence;
  final String rule;
  final String classify;
  final String check;
  final String whichRule;
  final String follows;
  final String breaksRule;
  final String stage;
  final String of;
  final String specimen;
  final String satellites;
  final String selected;
  final String evidenceHint;
  final String ruleOptionPrefix;
  final String ruleHint;
  final String classifyHint;

  String stageProgress(int current, int total) => '$stage $current $of $total';
  String specimenLabel(int position, int count, bool isSelected) =>
      '$specimen $position, $count $satellites${isSelected ? ', $selected' : ''}';
  String ruleOption(int count) => '$ruleOptionPrefix $count $satellites';

  static _OddCardCopy forLocale(Locale locale) {
    return _copies[locale.languageCode] ?? _copies['en']!;
  }

  static const _copies = <String, _OddCardCopy>{
    'ar': _OddCardCopy(
      evidence: 'اجمع الأدلة',
      rule: 'اكتشف القاعدة',
      classify: 'صنّف البطاقات',
      check: 'تحقق',
      whichRule: 'ما القاعدة التي تجمع الأدلة؟',
      follows: 'يتبع القاعدة',
      breaksRule: 'يخالف القاعدة',
      stage: 'المرحلة',
      of: 'من',
      specimen: 'بطاقة دليل',
      satellites: 'أقمار',
      selected: 'محددة',
      evidenceHint: 'انقر مرتين لتحديد هذه البطاقة أو إلغاء تحديدها',
      ruleOptionPrefix: 'قاعدة البطاقات ذات',
      ruleHint: 'انقر مرتين لاختيار هذه القاعدة',
      classifyHint: 'انقر مرتين لوضع البطاقة الحالية في هذه المجموعة',
    ),
    'de': _OddCardCopy(
      evidence: 'Beweise sammeln',
      rule: 'Regel finden',
      classify: 'Karten sortieren',
      check: 'Prüfen',
      whichRule: 'Welche Regel passt zu den Beweisen?',
      follows: 'Passt',
      breaksRule: 'Passt nicht',
      stage: 'Phase',
      of: 'von',
      specimen: 'Beweiskarte',
      satellites: 'Satelliten',
      selected: 'ausgewählt',
      evidenceHint: 'Doppeltippen, um diese Karte aus- oder abzuwählen',
      ruleOptionPrefix: 'Regel für Karten mit',
      ruleHint: 'Doppeltippen, um diese Regel zu wählen',
      classifyHint:
          'Doppeltippen, um die aktuelle Karte in diese Gruppe zu legen',
    ),
    'en': _OddCardCopy(
      evidence: 'Collect evidence',
      rule: 'Discover the rule',
      classify: 'Classify cards',
      check: 'Check evidence',
      whichRule: 'Which rule connects the evidence?',
      follows: 'Follows rule',
      breaksRule: 'Breaks rule',
      stage: 'Stage',
      of: 'of',
      specimen: 'Evidence card',
      satellites: 'satellites',
      selected: 'selected',
      evidenceHint: 'Double tap to select or clear this evidence card',
      ruleOptionPrefix: 'Rule for cards with',
      ruleHint: 'Double tap to choose this rule',
      classifyHint: 'Double tap to place the current card in this group',
    ),
    'es': _OddCardCopy(
      evidence: 'Reúne pruebas',
      rule: 'Descubre la regla',
      classify: 'Clasifica cartas',
      check: 'Comprobar',
      whichRule: '¿Qué regla une las pruebas?',
      follows: 'Cumple',
      breaksRule: 'No cumple',
      stage: 'Etapa',
      of: 'de',
      specimen: 'Carta de prueba',
      satellites: 'satélites',
      selected: 'seleccionada',
      evidenceHint: 'Toca dos veces para seleccionar o quitar esta carta',
      ruleOptionPrefix: 'Regla para cartas con',
      ruleHint: 'Toca dos veces para elegir esta regla',
      classifyHint: 'Toca dos veces para poner la carta actual en este grupo',
    ),
    'fr': _OddCardCopy(
      evidence: 'Trouve les indices',
      rule: 'Découvre la règle',
      classify: 'Classe les cartes',
      check: 'Vérifier',
      whichRule: 'Quelle règle relie les indices ?',
      follows: 'Respecte',
      breaksRule: 'Ne respecte pas',
      stage: 'Étape',
      of: 'sur',
      specimen: 'Carte indice',
      satellites: 'satellites',
      selected: 'sélectionnée',
      evidenceHint:
          'Touche deux fois pour sélectionner ou désélectionner cette carte',
      ruleOptionPrefix: 'Règle des cartes avec',
      ruleHint: 'Touche deux fois pour choisir cette règle',
      classifyHint:
          'Touche deux fois pour placer la carte actuelle dans ce groupe',
    ),
    'hi': _OddCardCopy(
      evidence: 'सबूत चुनें',
      rule: 'नियम खोजें',
      classify: 'कार्ड छाँटें',
      check: 'जाँचें',
      whichRule: 'सबूतों में कौन-सा नियम है?',
      follows: 'नियम मानता है',
      breaksRule: 'नियम तोड़ता है',
      stage: 'चरण',
      of: 'में से',
      specimen: 'सबूत कार्ड',
      satellites: 'उपग्रह',
      selected: 'चुना गया',
      evidenceHint: 'इस कार्ड को चुनने या हटाने के लिए दो बार टैप करें',
      ruleOptionPrefix: 'इतने उपग्रह वाले कार्ड का नियम',
      ruleHint: 'यह नियम चुनने के लिए दो बार टैप करें',
      classifyHint: 'मौजूदा कार्ड को इस समूह में रखने के लिए दो बार टैप करें',
    ),
    'it': _OddCardCopy(
      evidence: 'Raccogli indizi',
      rule: 'Scopri la regola',
      classify: 'Classifica carte',
      check: 'Verifica',
      whichRule: 'Quale regola unisce gli indizi?',
      follows: 'Segue la regola',
      breaksRule: 'Non la segue',
      stage: 'Fase',
      of: 'di',
      specimen: 'Carta indizio',
      satellites: 'satelliti',
      selected: 'selezionata',
      evidenceHint:
          'Tocca due volte per selezionare o deselezionare questa carta',
      ruleOptionPrefix: 'Regola delle carte con',
      ruleHint: 'Tocca due volte per scegliere questa regola',
      classifyHint:
          'Tocca due volte per mettere la carta attuale in questo gruppo',
    ),
    'ja': _OddCardCopy(
      evidence: '証拠を集めよう',
      rule: 'ルールを発見',
      classify: 'カードを分類',
      check: '確認する',
      whichRule: '証拠に共通するルールは？',
      follows: 'ルール通り',
      breaksRule: 'ルール外',
      stage: 'ステージ',
      of: '/',
      specimen: '証拠カード',
      satellites: '衛星',
      selected: '選択済み',
      evidenceHint: 'ダブルタップでこのカードを選択または解除します',
      ruleOptionPrefix: '衛星数のルール',
      ruleHint: 'ダブルタップでこのルールを選びます',
      classifyHint: 'ダブルタップで現在のカードをこのグループに入れます',
    ),
    'ko': _OddCardCopy(
      evidence: '증거 모으기',
      rule: '규칙 찾기',
      classify: '카드 분류',
      check: '확인',
      whichRule: '증거의 공통 규칙은 무엇일까요?',
      follows: '규칙에 맞음',
      breaksRule: '규칙과 다름',
      stage: '단계',
      of: '/',
      specimen: '증거 카드',
      satellites: '위성',
      selected: '선택됨',
      evidenceHint: '두 번 탭하여 이 카드를 선택하거나 해제하세요',
      ruleOptionPrefix: '위성 수 카드 규칙',
      ruleHint: '두 번 탭하여 이 규칙을 선택하세요',
      classifyHint: '두 번 탭하여 현재 카드를 이 그룹에 넣으세요',
    ),
    'pt': _OddCardCopy(
      evidence: 'Reúna pistas',
      rule: 'Descubra a regra',
      classify: 'Separe as cartas',
      check: 'Verificar',
      whichRule: 'Qual regra liga as pistas?',
      follows: 'Segue a regra',
      breaksRule: 'Quebra a regra',
      stage: 'Etapa',
      of: 'de',
      specimen: 'Carta de pista',
      satellites: 'satélites',
      selected: 'selecionada',
      evidenceHint: 'Toque duas vezes para selecionar ou desmarcar esta carta',
      ruleOptionPrefix: 'Regra das cartas com',
      ruleHint: 'Toque duas vezes para escolher esta regra',
      classifyHint: 'Toque duas vezes para colocar a carta atual neste grupo',
    ),
    'ru': _OddCardCopy(
      evidence: 'Собери улики',
      rule: 'Раскрой правило',
      classify: 'Распредели карточки',
      check: 'Проверить улики',
      whichRule: 'Какое правило объединяет улики?',
      follows: 'Подходит',
      breaksRule: 'Не подходит',
      stage: 'Этап',
      of: 'из',
      specimen: 'Карточка-улика',
      satellites: 'спутника',
      selected: 'выбрана',
      evidenceHint:
          'Дважды нажмите, чтобы выбрать или отменить выбор этой карточки',
      ruleOptionPrefix: 'Правило для карточек, где',
      ruleHint: 'Дважды нажмите, чтобы выбрать это правило',
      classifyHint:
          'Дважды нажмите, чтобы поместить текущую карточку в эту группу',
    ),
    'zh': _OddCardCopy(
      evidence: '收集线索',
      rule: '发现规律',
      classify: '卡片分类',
      check: '检查线索',
      whichRule: '这些线索有什么共同规律？',
      follows: '符合规律',
      breaksRule: '不符合规律',
      stage: '阶段',
      of: '/',
      specimen: '线索卡片',
      satellites: '颗卫星',
      selected: '已选择',
      evidenceHint: '双击选择或取消选择这张卡片',
      ruleOptionPrefix: '卫星数量规则',
      ruleHint: '双击选择这条规律',
      classifyHint: '双击将当前卡片放入此组',
    ),
  };
}

class _OddNavigationCopy {
  const _OddNavigationCopy(this.nextChoice, this.previousChoice);

  final String nextChoice;
  final String previousChoice;

  static _OddNavigationCopy forLocale(Locale locale) =>
      _copies[locale.languageCode] ?? _copies['en']!;

  static const _copies = <String, _OddNavigationCopy>{
    'ar': _OddNavigationCopy('الخيار التالي', 'الخيار السابق'),
    'de': _OddNavigationCopy('Nächste Auswahl', 'Vorherige Auswahl'),
    'en': _OddNavigationCopy('Next choice', 'Previous choice'),
    'es': _OddNavigationCopy('Siguiente opción', 'Opción anterior'),
    'fr': _OddNavigationCopy('Choix suivant', 'Choix précédent'),
    'hi': _OddNavigationCopy('अगला विकल्प', 'पिछला विकल्प'),
    'it': _OddNavigationCopy('Scelta successiva', 'Scelta precedente'),
    'ja': _OddNavigationCopy('次の選択肢', '前の選択肢'),
    'ko': _OddNavigationCopy('다음 선택', '이전 선택'),
    'pt': _OddNavigationCopy('Próxima opção', 'Opção anterior'),
    'ru': _OddNavigationCopy('Следующий вариант', 'Предыдущий вариант'),
    'zh': _OddNavigationCopy('下一个选项', '上一个选项'),
  };
}

class PatternTrainWorkshopGameView extends StatefulWidget {
  const PatternTrainWorkshopGameView({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.semanticLabel,
    required this.onAnswerSelected,
    this.variant = PatternWorkshopVariant.train,
    super.key,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final String semanticLabel;
  final ValueChanged<String> onAnswerSelected;
  final PatternWorkshopVariant variant;

  @override
  State<PatternTrainWorkshopGameView> createState() =>
      _PatternTrainWorkshopGameViewState();
}

class _PatternTrainWorkshopGameViewState
    extends State<PatternTrainWorkshopGameView> with TickerProviderStateMixin {
  static const _routes = <List<int>>[
    [1, 0, 2],
    [2, 0, 1],
    [0, 2, 1],
  ];
  final List<int?> _slots = List<int?>.filled(3, null);
  late final AnimationController _reaction;
  late final AnimationController _success;
  int? _wrongSlot;
  int _round = 0;
  bool _locked = false;
  bool _answerSent = false;

  List<int> get _answers => _routes[_round];

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    _success.dispose();
    super.dispose();
  }

  Future<void> _drop(int slot, int piece) async {
    if (_locked ||
        _slots.contains(piece) ||
        _slots[slot] != null ||
        _answerSent) {
      return;
    }
    if (_answers[slot] != piece) {
      setState(() {
        _wrongSlot = slot;
        _locked = true;
      });
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() {
        _wrongSlot = null;
        _locked = false;
      });
      _reaction.reset();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _slots[slot] = piece);
    if (_slots.every((piece) => piece != null)) {
      setState(() => _locked = true);
      HapticFeedback.mediumImpact();
      await _success.forward(from: 0);
      if (!mounted || _answerSent) return;
      if (_round + 1 < _routes.length) {
        setState(() {
          _round++;
          _wrongSlot = null;
          _slots.fillRange(0, _slots.length, null);
          _locked = false;
        });
        _success.reset();
        return;
      }
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _WorkshopLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_reaction, _success]),
                builder: (_, __) => CustomPaint(
                  painter: _PatternWorkshopPainter(
                    accent: widget.accent,
                    variant: widget.variant,
                    round: _round,
                    slots: _slots,
                    wrongSlot: _wrongSlot,
                    reaction: _reaction.value,
                    success: _success.value,
                  ),
                ),
              ),
              for (var slot = 0; slot < 3; slot++)
                Positioned.fromRect(
                  rect: layout.patternSlot(slot),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (details) =>
                        !_locked &&
                        !_answerSent &&
                        _slots[slot] == null &&
                        !_slots.contains(details.data),
                    onAcceptWithDetails: (details) => _drop(slot, details.data),
                    builder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
              for (var piece = 0; piece < 3; piece++)
                if (!_slots.contains(piece))
                  Positioned.fromRect(
                    rect: layout.patternPiece(piece).inflate(3),
                    child: Semantics(
                      key: ValueKey('pattern-route-$_round-piece-$piece'),
                      label: widget.semanticLabel,
                      value: '${_round + 1}/3',
                      button: true,
                      child: _PaintedDraggable(
                        data: piece,
                        size: layout.patternPiece(piece).size,
                        painter: _LoosePiecePainter(
                          accent: widget.accent,
                          piece: piece,
                          variant: widget.variant,
                        ),
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class RocketAssemblyWorkshopGameView extends StatefulWidget {
  const RocketAssemblyWorkshopGameView({
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
  State<RocketAssemblyWorkshopGameView> createState() =>
      _RocketAssemblyWorkshopGameViewState();
}

class _RocketAssemblyWorkshopGameViewState
    extends State<RocketAssemblyWorkshopGameView>
    with TickerProviderStateMixin {
  final List<bool> _placed = List<bool>.filled(4, false);
  late final AnimationController _reaction;
  late final AnimationController _launch;
  int? _wrongPart;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _reaction = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _launch = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
  }

  @override
  void dispose() {
    _reaction.dispose();
    _launch.dispose();
    super.dispose();
  }

  Future<void> _drop(int target, int part) async {
    if (_placed[part] || _answerSent) return;
    if (target != part) {
      setState(() => _wrongPart = part);
      HapticFeedback.lightImpact();
      await _reaction.forward(from: 0);
      if (!mounted) return;
      setState(() => _wrongPart = null);
      _reaction.reset();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _placed[part] = true);
    if (_placed.every((value) => value)) {
      HapticFeedback.heavyImpact();
      await _launch.forward(from: 0);
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _WorkshopFrame(
      compact: widget.compact,
      semanticLabel: widget.semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = _WorkshopLayout(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_reaction, _launch]),
                builder: (_, __) => CustomPaint(
                  painter: _RocketWorkshopPainter(
                    accent: widget.accent,
                    placed: _placed,
                    wrongPart: _wrongPart,
                    reaction: _reaction.value,
                    launch: _launch.value,
                  ),
                ),
              ),
              for (var target = 0; target < 4; target++)
                Positioned.fromRect(
                  rect: layout.rocketTarget(target),
                  child: DragTarget<int>(
                    onWillAcceptWithDetails: (details) =>
                        !_answerSent && !_placed[details.data],
                    onAcceptWithDetails: (details) =>
                        _drop(target, details.data),
                    builder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
              for (var part = 0; part < 4; part++)
                if (!_placed[part])
                  Positioned.fromRect(
                    rect: layout.rocketPart(part),
                    child: _PaintedDraggable(
                      data: part,
                      size: layout.rocketPart(part).size,
                      painter: _RocketPartPainter(
                        accent: widget.accent,
                        part: part,
                        wrong: _wrongPart == part,
                        reaction: _reaction.value,
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _WorkshopFrame extends StatelessWidget {
  const _WorkshopFrame({
    required this.compact,
    required this.semanticLabel,
    required this.child,
  });

  final bool compact;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: semanticLabel,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            width: double.infinity,
            height: compact ? 246 : 286,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _WorkshopLayout {
  const _WorkshopLayout(this.size);

  final Size size;

  Rect _rect(double x, double y, double width, double height) => Rect.fromLTWH(
        x / 360 * size.width,
        y / 286 * size.height,
        width / 360 * size.width,
        height / 286 * size.height,
      );

  Rect gridRect(int index) => _rect(
        31 + (index % 3) * 105,
        51 + (index ~/ 3) * 98,
        88,
        78,
      );

  Rect patternSlot(int index) => _rect(39 + index * 95, 99, 72, 66);

  Rect patternPiece(int index) => _rect(65 + index * 83, 208, 54, 50);

  Rect rocketTarget(int part) => switch (part) {
        0 => _rect(200, 42, 54, 58),
        1 => _rect(195, 92, 64, 88),
        2 => _rect(169, 145, 38, 56),
        _ => _rect(247, 145, 38, 56),
      };

  Rect rocketPart(int part) =>
      _rect(34 + (part % 2) * 68, 78 + (part ~/ 2) * 88, 54, 64);
}

class _PaintedDraggable extends StatelessWidget {
  const _PaintedDraggable({
    required this.data,
    required this.size,
    required this.painter,
  });

  final int data;
  final Size size;
  final CustomPainter painter;

  Widget _piece({double opacity = 1}) => Opacity(
        opacity: opacity,
        child: CustomPaint(size: size, painter: painter),
      );

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<int>(
      data: data,
      delay: const Duration(milliseconds: 90),
      hapticFeedbackOnStart: true,
      feedback: Material(
        type: MaterialType.transparency,
        child: Transform.scale(scale: 1.12, child: _piece()),
      ),
      childWhenDragging: _piece(opacity: 0.2),
      child: _piece(),
    );
  }
}

class _PatternWorkshopPainter extends CustomPainter {
  const _PatternWorkshopPainter({
    required this.accent,
    required this.variant,
    required this.round,
    required this.slots,
    required this.wrongSlot,
    required this.reaction,
    required this.success,
  });

  final Color accent;
  final PatternWorkshopVariant variant;
  final int round;
  final List<int?> slots;
  final int? wrongSlot;
  final double reaction;
  final double success;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackdrop(
        canvas,
        size,
        accent,
        variant == PatternWorkshopVariant.train
            ? const Color(0xFF244B67)
            : const Color(0xFF315745));
    final layout = _WorkshopLayout(size);
    final y = size.height * .57;
    if (variant == PatternWorkshopVariant.train) {
      canvas.drawRect(Rect.fromLTWH(0, y + size.height * .08, size.width, 5),
          Paint()..color = const Color(0xFFBAD4D9));
      for (var x = 0.0; x < size.width; x += size.width * .08) {
        canvas.drawRect(
            Rect.fromLTWH(x, y + size.height * .06, size.width * .045, 10),
            Paint()..color = const Color(0xFF8CA8AE));
      }
    } else {
      final path = Path()..moveTo(0, y + 8);
      for (var x = 0.0; x <= size.width; x += 8) {
        path.lineTo(x, y + math.sin(x / size.width * math.pi * 3) * 7);
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = const Color(0xFFFFD47B)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 18);
    }
    _paintStationFlags(canvas, size, round, success, accent);
    _paintRoundLights(canvas, size, round, 3, accent);
    for (var i = 0; i < 3; i++) {
      final rect = layout.patternSlot(i);
      final shake = wrongSlot == i
          ? math.sin(reaction * math.pi * 8) * (1 - reaction) * 7
          : 0.0;
      canvas.save();
      canvas.translate(
        shake + success * size.width * .42,
        -success * size.height * .025,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(14)),
        Paint()
          ..color = slots[i] == null
              ? Colors.white.withValues(alpha: .18)
              : Colors.white,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(14)),
        Paint()
          ..color = Colors.white.withValues(alpha: .65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      if (slots[i] != null) {
        _paintPatternPiece(canvas, rect, slots[i]!, variant, accent);
      }
      canvas.restore();
    }
    for (var i = 0; i < 4; i++) {
      final x = size.width * (.08 + i * .28);
      final c = Offset(x, size.height * .28);
      canvas.drawCircle(
          c,
          16,
          Paint()
            ..color =
                i.isEven ? const Color(0xFFFFCF5C) : const Color(0xFF65D9C8));
      canvas.drawCircle(c, 6, Paint()..color = const Color(0xFF405078));
    }
  }

  @override
  bool shouldRepaint(covariant _PatternWorkshopPainter oldDelegate) => true;
}

class _LoosePiecePainter extends CustomPainter {
  const _LoosePiecePainter(
      {required this.accent, required this.piece, required this.variant});
  final Color accent;
  final int piece;
  final PatternWorkshopVariant variant;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(2), const Radius.circular(13)),
        Paint()..color = Colors.white);
    _paintPatternPiece(canvas, rect, piece, variant, accent);
  }

  @override
  bool shouldRepaint(covariant _LoosePiecePainter oldDelegate) => false;
}

class _RocketWorkshopPainter extends CustomPainter {
  const _RocketWorkshopPainter({
    required this.accent,
    required this.placed,
    required this.wrongPart,
    required this.reaction,
    required this.launch,
  });
  final Color accent;
  final List<bool> placed;
  final int? wrongPart;
  final double reaction;
  final double launch;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackdrop(canvas, size, accent, const Color(0xFF182C59));
    final layout = _WorkshopLayout(size);
    for (var i = 0; i < 16; i++) {
      final x = ((i * 73) % 347) / 360 * size.width;
      final y = ((i * 47) % 210) / 286 * size.height;
      canvas.drawCircle(Offset(x, y), i.isEven ? 1.5 : 2.2,
          Paint()..color = Colors.white.withValues(alpha: .55));
    }
    final rise = Curves.easeIn.transform(launch) * size.height * .6;
    canvas.save();
    canvas.translate(0, -rise);
    for (var part = 0; part < 4; part++) {
      final rect = layout.rocketTarget(part);
      if (placed[part]) {
        _paintRocketPart(canvas, rect, part, accent);
      } else {
        _paintRocketSilhouette(canvas, rect, part);
      }
    }
    if (placed.every((value) => value)) {
      final flame = layout.rocketTarget(1).bottomCenter + const Offset(0, 14);
      final flicker = math.sin(launch * math.pi * 18).abs();
      final path = Path()
        ..moveTo(flame.dx - 13, flame.dy)
        ..quadraticBezierTo(
            flame.dx, flame.dy + 42 + flicker * 12, flame.dx + 13, flame.dy)
        ..close();
      canvas.drawPath(path, Paint()..color = const Color(0xFFFFB840));
      canvas.drawOval(
          Rect.fromCenter(
              center: flame + const Offset(0, 12), width: 10, height: 29),
          Paint()..color = const Color(0xFFFF6A65));
    }
    canvas.restore();
    _paintRoundLights(
        canvas, size, placed.where((value) => value).length, 4, accent);
  }

  @override
  bool shouldRepaint(covariant _RocketWorkshopPainter oldDelegate) => true;
}

class _RocketPartPainter extends CustomPainter {
  const _RocketPartPainter(
      {required this.accent,
      required this.part,
      required this.wrong,
      required this.reaction});
  final Color accent;
  final int part;
  final bool wrong;
  final double reaction;

  @override
  void paint(Canvas canvas, Size size) {
    final shake =
        wrong ? math.sin(reaction * math.pi * 8) * (1 - reaction) * 5 : 0.0;
    canvas.save();
    canvas.translate(shake, 0);
    _paintRocketPart(canvas, Offset.zero & size, part, accent);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RocketPartPainter oldDelegate) => true;
}

void _paintBackdrop(Canvas canvas, Size size, Color accent, Color dark) {
  final bounds = Offset.zero & size;
  canvas.drawRect(
    bounds,
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [dark, Color.lerp(dark, accent, .48)!, const Color(0xFFBDEBDD)],
      ).createShader(bounds),
  );
  canvas.drawCircle(Offset(size.width * .9, size.height * .13),
      size.height * .15, Paint()..color = Colors.white.withValues(alpha: .1));
}

void _paintRoundLights(
    Canvas canvas, Size size, int active, int total, Color accent) {
  const radius = 5.0;
  final gap = size.width * .043;
  final start = size.width / 2 - (total - 1) * gap / 2;
  for (var i = 0; i < total; i++) {
    canvas.drawCircle(
      Offset(start + i * gap, size.height * .055),
      radius,
      Paint()
        ..color = i < active
            ? const Color(0xFFFFD35C)
            : Colors.white.withValues(alpha: .28),
    );
  }
}

void _paintStationFlags(
  Canvas canvas,
  Size size,
  int round,
  double departing,
  Color accent,
) {
  final stationY = size.height * .16;
  for (var index = 0; index < 3; index++) {
    final x = size.width * (.2 + index * .3);
    final active = index == round;
    final cleared = index < round;
    final bob = active ? math.sin(departing * math.pi) * 5 : 0.0;
    canvas.save();
    canvas.translate(0, bob);
    canvas.drawRect(
      Rect.fromLTWH(x - 1.5, stationY - 14, 3, 29),
      Paint()..color = Colors.white.withValues(alpha: .72),
    );
    final flag = Path()
      ..moveTo(x + 1, stationY - 13)
      ..lineTo(x + 22, stationY - 7)
      ..lineTo(x + 1, stationY)
      ..close();
    canvas.drawPath(
      flag,
      Paint()
        ..color = cleared
            ? const Color(0xFF4DD5A5)
            : active
                ? const Color(0xFFFFD35C)
                : Colors.white.withValues(alpha: .25),
    );
    if (cleared) {
      canvas.drawCircle(
        Offset(x + 11, stationY - 7),
        3.2,
        Paint()..color = const Color(0xFF163855),
      );
    }
    canvas.restore();
  }
}

void _paintPatternPiece(Canvas canvas, Rect rect, int piece,
    PatternWorkshopVariant variant, Color accent) {
  final c = rect.center;
  final r = rect.shortestSide * .25;
  final color = [
    const Color(0xFFFF7F78),
    const Color(0xFF62D6C5),
    const Color(0xFFFFCE61)
  ][piece];
  if (variant == PatternWorkshopVariant.train) {
    final body = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: c.translate(0, -3), width: r * 2.25, height: r * 1.35),
        Radius.circular(r * .25));
    canvas.drawRRect(body, Paint()..color = color);
    canvas.drawRect(
        Rect.fromCenter(
            center: c.translate(r * .55, -r * .9), width: r * .55, height: r),
        Paint()..color = Color.lerp(color, Colors.white, .25)!);
    canvas.drawCircle(c.translate(-r * .6, r * .65), r * .32,
        Paint()..color = const Color(0xFF354466));
    canvas.drawCircle(c.translate(r * .6, r * .65), r * .32,
        Paint()..color = const Color(0xFF354466));
  } else {
    final path = Path();
    final count = piece + 3;
    for (var i = 0; i < count; i++) {
      final a = -math.pi / 2 + i * math.pi * 2 / count;
      final p = c + Offset(math.cos(a), math.sin(a)) * r;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(c, r * .3, Paint()..color = accent.withValues(alpha: .8));
  }
}

void _paintRocketSilhouette(Canvas canvas, Rect rect, int part) {
  final paint = Paint()..color = Colors.white.withValues(alpha: .16);
  _paintRocketPartShape(canvas, rect.deflate(2), part, paint);
  _paintRocketPartShape(
    canvas,
    rect.deflate(2),
    part,
    Paint()
      ..color = Colors.white.withValues(alpha: .45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

void _paintRocketPart(Canvas canvas, Rect rect, int part, Color accent) {
  final colors = [
    const Color(0xFFFF7C75),
    const Color(0xFFF5F8FF),
    const Color(0xFF64D4C5),
    const Color(0xFFFFCD58)
  ];
  _paintRocketPartShape(
      canvas, rect.deflate(2), part, Paint()..color = colors[part]);
  if (part == 1) {
    canvas.drawCircle(rect.center.translate(0, -rect.height * .12),
        rect.width * .18, Paint()..color = accent);
    canvas.drawCircle(
        rect.center.translate(-rect.width * .05, -rect.height * .17),
        rect.width * .06,
        Paint()..color = Colors.white.withValues(alpha: .75));
  }
}

void _paintRocketPartShape(Canvas canvas, Rect rect, int part, Paint paint) {
  final path = Path();
  if (part == 0) {
    path.moveTo(rect.center.dx, rect.top);
    path.quadraticBezierTo(
        rect.right, rect.bottom * .72, rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.quadraticBezierTo(
        rect.left, rect.bottom * .72, rect.center.dx, rect.top);
  } else if (part == 1) {
    path.addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.width * .32)));
  } else if (part == 2) {
    path.moveTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.quadraticBezierTo(rect.left, rect.center.dy, rect.right, rect.top);
  } else {
    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.right, rect.bottom);
    path.quadraticBezierTo(rect.right, rect.center.dy, rect.left, rect.top);
  }
  canvas.drawPath(path, paint);
}
