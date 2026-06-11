import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    required this.profile,
    required this.onLessonComplete,
    required this.onBackToMap,
    this.lessonId,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function({
    required String lessonId,
    required DailyChallenge challenge,
    int correctAnswers,
    int totalQuestions,
    int usedHints,
    int wrongAttempts,
  }) onLessonComplete;
  final VoidCallback onBackToMap;
  final String? lessonId;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _stepIndex = 0;
  String? _selectedChoiceId;
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  bool _isComplete = false;
  bool _isSaving = false;
  bool _showHint = false;
  final Set<int> _hintedStepIndexes = <int>{};
  int _wrongAttempts = 0;

  @override
  Widget build(BuildContext context) {
    final child = widget.profile.activeChild;
    final lesson = widget.lessonId == null
        ? FoundationCatalog.lessonForNode(_currentNode(child))
        : FoundationCatalog.lessonForId(widget.lessonId!);
    final challenges = _lessonChallenges(child, lesson);
    final challenge = challenges[_stepIndex];

    if (_isComplete) {
      return _LessonCompleteView(
        lesson: lesson,
        onBackToMap: widget.onBackToMap,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _LessonHeader(
              currentStep: _stepIndex + 1,
              totalSteps: challenges.length,
              hearts: child.hearts,
            ),
            const SizedBox(height: 16),
            _LessonQuestionCard(
              challenge: challenge,
              selectedChoiceId: _selectedChoiceId,
              hasSubmitted: _hasSubmitted,
              isCorrect: _isCorrect,
              showHint: _showHint,
              onToggleHint: _toggleHint,
              onChoiceSelected: _selectChoice,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _selectedChoiceId == null || _isSaving
                  ? null
                  : () => _submitAnswer(lesson, challenge, challenges),
              icon: Icon(
                _hasSubmitted && _isCorrect
                    ? Icons.arrow_forward_rounded
                    : Icons.check_rounded,
              ),
              label: Text(_buttonLabel(context, challenges.length)),
            ),
          ],
        ),
      ),
    );
  }

  MapNode _currentNode(ChildProfile child) {
    return FoundationCatalog.starterMap.nodes.firstWhere(
      (node) =>
          node.stateForCompletedNodes(child.completedMapNodeIds) ==
          MapNodeState.current,
      orElse: () => FoundationCatalog.starterMap.nodes.last,
    );
  }

  List<DailyChallenge> _lessonChallenges(ChildProfile child, Lesson lesson) {
    final lessonSteps = FoundationCatalog.stepsForLesson(lesson);
    if (lessonSteps.isNotEmpty) {
      final challengeIds = [
        for (final step in lessonSteps)
          FoundationCatalog.puzzleForStep(step).payloadRef,
      ];
      return dailyChallengesByIds(challengeIds, age: child.age);
    }

    final baseChallenges = dailyChallengesForAge(child.age);
    return [
      for (var index = 0; index < lesson.stepIds.length; index += 1)
        baseChallenges[index % baseChallenges.length],
    ];
  }

  String _buttonLabel(BuildContext context, int totalSteps) {
    final l10n = context.l10n;
    if (_isSaving) {
      return l10n.checkingButton;
    }
    if (!_hasSubmitted || !_isCorrect) {
      return l10n.checkAnswerButton;
    }
    if (_stepIndex == totalSteps - 1) {
      return l10n.lessonFinishButton;
    }
    return l10n.lessonNextButton;
  }

  void _selectChoice(String choiceId) {
    setState(() {
      _selectedChoiceId = choiceId;
      _hasSubmitted = false;
      _isCorrect = false;
    });
  }

  Future<void> _submitAnswer(
    Lesson lesson,
    DailyChallenge challenge,
    List<DailyChallenge> challenges,
  ) async {
    if (_hasSubmitted && _isCorrect) {
      if (_stepIndex == challenges.length - 1) {
        setState(() {
          _isSaving = true;
        });
        await widget.onLessonComplete(
          lessonId: lesson.id,
          challenge: challenge,
          correctAnswers: challenges.length,
          totalQuestions: challenges.length,
          usedHints: _hintedStepIndexes.length,
          wrongAttempts: _wrongAttempts,
        );
        if (!mounted) {
          return;
        }
        setState(() {
          _isSaving = false;
          _isComplete = true;
        });
        return;
      }

      setState(() {
        _stepIndex += 1;
        _selectedChoiceId = null;
        _hasSubmitted = false;
        _isCorrect = false;
        _showHint = false;
      });
      return;
    }

    final choiceId = _selectedChoiceId;
    if (choiceId == null) {
      return;
    }

    final isCorrect = challenge.isCorrectChoice(choiceId);
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
      if (!isCorrect) {
        _wrongAttempts += 1;
      }
    });
  }

  void _toggleHint() {
    setState(() {
      final nextShowHint = !_showHint;
      _showHint = nextShowHint;
      if (nextShowHint) {
        _hintedStepIndexes.add(_stepIndex);
      }
    });
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.hearts,
  });

  final int currentStep;
  final int totalSteps;
  final int hearts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.lessonProgress(currentStep, totalSteps),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 12,
                      value: currentStep / totalSteps,
                      color: const Color(0xFF18B7AE),
                      backgroundColor: const Color(0xFFDDF8F4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            _HeartPill(hearts: hearts),
          ],
        ),
      ),
    );
  }
}

class _HeartPill extends StatelessWidget {
  const _HeartPill({required this.hearts});

  final int hearts;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFFF5A7D),
              size: 22,
            ),
            const SizedBox(width: 5),
            Text(
              '$hearts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonQuestionCard extends StatelessWidget {
  const _LessonQuestionCard({
    required this.challenge,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.showHint,
    required this.onToggleHint,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final bool showHint;
  final VoidCallback onToggleHint;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFECA8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.psychology_alt_rounded,
                    color: Color(0xFFFFB000),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.titleForChallenge(challenge),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.promptForChallenge(challenge),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _PuzzleVisual(challenge: challenge),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF9FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                l10n.questionForChallenge(challenge),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 23,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            _HintButton(
              expanded: showHint,
              onPressed: onToggleHint,
            ),
            if (showHint && !hasSubmitted) ...[
              const SizedBox(height: 10),
              _HintPanel(challenge: challenge),
            ],
            const SizedBox(height: 14),
            for (var index = 0; index < challenge.choices.length; index += 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LessonChoiceTile(
                  challenge: challenge,
                  choice: challenge.choices[index],
                  label: l10n.choiceLabelFor(
                    challenge,
                    challenge.choices[index],
                  ),
                  index: index,
                  selected: selectedChoiceId == challenge.choices[index].id,
                  submitted: hasSubmitted,
                  correct:
                      challenge.isCorrectChoice(challenge.choices[index].id),
                  onTap: () => onChoiceSelected(challenge.choices[index].id),
                ),
              ),
            if (hasSubmitted) ...[
              const SizedBox(height: 4),
              _LessonFeedback(
                isCorrect: isCorrect,
                challenge: challenge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LessonChoiceTile extends StatelessWidget {
  const _LessonChoiceTile({
    required this.challenge,
    required this.choice,
    required this.label,
    required this.index,
    required this.selected,
    required this.submitted,
    required this.correct,
    required this.onTap,
  });

  final DailyChallenge challenge;
  final ChallengeChoice choice;
  final String label;
  final int index;
  final bool selected;
  final bool submitted;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(
            color: _borderColor,
            width: selected || (submitted && correct) ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            _ChoiceVisual(
              challenge: challenge,
              choice: choice,
              index: index,
              selected: selected,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (submitted && (selected || correct)) ...[
              const SizedBox(width: 8),
              Icon(
                correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color:
                    correct ? const Color(0xFF18B7AE) : const Color(0xFFFF6F6B),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (submitted && correct) {
      return const Color(0xFFDDF8F4);
    }
    if (submitted && selected && !correct) {
      return const Color(0xFFFFEFEF);
    }
    if (selected) {
      return const Color(0xFFDDF8F4);
    }
    return Colors.white;
  }

  Color get _borderColor {
    if (submitted && correct) {
      return const Color(0xFF18B7AE);
    }
    if (submitted && selected && !correct) {
      return const Color(0xFFFF6F6B);
    }
    if (selected) {
      return const Color(0xFF18B7AE);
    }
    return const Color(0xFFE4F1EE);
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton({
    required this.expanded,
    required this.onPressed,
  });

  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          expanded
              ? Icons.visibility_off_rounded
              : Icons.tips_and_updates_rounded,
        ),
        label: Text(expanded ? l10n.hideHintButton : l10n.showHintButton),
      ),
    );
  }
}

class _HintPanel extends StatelessWidget {
  const _HintPanel({required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFD77A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFFF9D2E),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.hintForChallenge(challenge),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B5316),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceVisual extends StatelessWidget {
  const _ChoiceVisual({
    required this.challenge,
    required this.choice,
    required this.index,
    required this.selected,
  });

  final DailyChallenge challenge;
  final ChallengeChoice choice;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? const Color(0xFF18B7AE) : _colorForChoice(choice.id);
    final child = switch ('${challenge.id}:${choice.id}') {
      'shape-path:triangle' => Icon(Icons.change_history_rounded, color: color),
      'shape-path:circle' => Icon(Icons.circle, color: color),
      'shape-path:star' => Icon(Icons.star_rounded, color: color),
      'odd-card:apple' => Icon(Icons.apple_rounded, color: color),
      'odd-card:ball' => Icon(Icons.sports_basketball_rounded, color: color),
      'odd-card:banana' => Icon(Icons.eco_rounded, color: color),
      'logic-train:blue' => Icon(Icons.train_rounded, color: color),
      'logic-train:red' => Icon(Icons.train_rounded, color: color),
      'logic-train:green' => Icon(Icons.train_rounded, color: color),
      'memory-pairs:lock' => Icon(Icons.lock_rounded, color: color),
      'memory-pairs:shoe' => Icon(Icons.hiking_rounded, color: color),
      'memory-pairs:cloud' => Icon(Icons.cloud_rounded, color: color),
      'shadow-match:rocket' => Icon(Icons.rocket_launch_rounded, color: color),
      'shadow-match:planet' => Icon(Icons.public_rounded, color: color),
      'shadow-match:star' => Icon(Icons.star_rounded, color: color),
      'balance-scale:apple' => Icon(Icons.apple_rounded, color: color),
      'balance-scale:star' => Icon(Icons.star_rounded, color: color),
      'balance-scale:ball' =>
        Icon(Icons.sports_basketball_rounded, color: color),
      'shape-rotation:same' => Icon(Icons.change_history_rounded, color: color),
      'shape-rotation:circle' => Icon(Icons.circle, color: color),
      'shape-rotation:square' => Icon(Icons.square_rounded, color: color),
      'detail-count:blue-squares' => Icon(Icons.square_rounded, color: color),
      'detail-count:red-circles' => Icon(Icons.circle, color: color),
      'detail-count:green-stars' => Icon(Icons.star_rounded, color: color),
      _ => Text(
          choice.id.contains('+') ? '+' : choice.id,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
        ),
    };

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF18B7AE).withValues(alpha: 0.16)
            : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(17),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Color _colorForChoice(String choiceId) {
    return switch (choiceId) {
      'circle' || 'red' || 'red-circles' => const Color(0xFFFF6F6B),
      'triangle' || 'blue' || 'blue-squares' => const Color(0xFF5C8EF7),
      'star' || 'green' || 'green-stars' => const Color(0xFF35B37E),
      'apple' => const Color(0xFFFF6F6B),
      'ball' => const Color(0xFFFF9F43),
      'banana' => const Color(0xFFFFC739),
      'rocket' || 'same' => const Color(0xFF18B7AE),
      'planet' || 'square' => const Color(0xFF5C8EF7),
      'lock' || '4+2+1' => const Color(0xFF18B7AE),
      'shoe' || '4+1' => const Color(0xFF9C6AF2),
      'cloud' || '2+1' => const Color(0xFF5C8EF7),
      _ => const Color(0xFFFF9D2E),
    };
  }
}

class _PuzzleVisual extends StatelessWidget {
  const _PuzzleVisual({required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
      ),
      child: switch (challenge.id) {
        'shape-path' => const _ShapePatternVisual(),
        'toy-count' => const _ToyCountVisual(),
        'odd-card' => const _OddCardVisual(),
        'logic-train' => const _LogicTrainVisual(),
        'sticker-sum' => const _StickerSumVisual(),
        'memory-pairs' => const _MemoryPairsVisual(),
        'shadow-match' => const _ShadowMatchVisual(),
        'balance-scale' => const _BalanceScaleVisual(),
        'shape-rotation' => const _ShapeRotationVisual(),
        'code-grid' => const _CodeGridVisual(),
        'number-bridge' => const _NumberBridgeVisual(),
        'detail-count' => const _DetailCountVisual(),
        _ => const _DefaultPuzzleVisual(),
      },
    );
  }
}

class _ShapePatternVisual extends StatelessWidget {
  const _ShapePatternVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShapeToken.circle(color: Color(0xFF18B7AE)),
        _ShapeToken.square(color: Color(0xFF5C8EF7)),
        _ShapeToken.circle(color: Color(0xFF18B7AE)),
        _ShapeToken.square(color: Color(0xFF5C8EF7)),
        _QuestionToken(),
      ],
    );
  }
}

class _ToyCountVisual extends StatelessWidget {
  const _ToyCountVisual();

  @override
  Widget build(BuildContext context) {
    return const _ShelfScene(
      children: [
        _CubeToy(color: Color(0xFFFFB84D)),
        _CubeToy(color: Color(0xFF5C8EF7)),
        _BallToy(color: Color(0xFFFF6F6B)),
      ],
    );
  }
}

class _OddCardVisual extends StatelessWidget {
  const _OddCardVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(icon: Icons.apple_rounded, color: Color(0xFFFF6F6B)),
        _ObjectCard(icon: Icons.spa_rounded, color: Color(0xFF35B37E)),
        _ObjectCard(
            icon: Icons.sports_basketball_rounded, color: Color(0xFFFF9F43)),
        _ObjectCard(icon: Icons.eco_rounded, color: Color(0xFFFFC739)),
      ],
    );
  }
}

class _LogicTrainVisual extends StatelessWidget {
  const _LogicTrainVisual();

  @override
  Widget build(BuildContext context) {
    return const _TrainRow(
      colors: [
        Color(0xFFFF6F6B),
        Color(0xFF5C8EF7),
        Color(0xFF5C8EF7),
        Color(0xFFFF6F6B),
        Color(0xFF5C8EF7),
        Color(0xFF5C8EF7),
      ],
    );
  }
}

class _StickerSumVisual extends StatelessWidget {
  const _StickerSumVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _StickerGroup(count: 3, color: Color(0xFFFFC739)),
        _MathSign('+'),
        _StickerGroup(count: 2, color: Color(0xFF9C6AF2)),
        _MathSign('='),
        _QuestionToken(),
      ],
    );
  }
}

class _MemoryPairsVisual extends StatelessWidget {
  const _MemoryPairsVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(icon: Icons.key_rounded, color: Color(0xFFFFB84D)),
        _MathSign('+'),
        _QuestionToken(),
      ],
    );
  }
}

class _ShadowMatchVisual extends StatelessWidget {
  const _ShadowMatchVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShadowToken(),
        _MathSign('->'),
        _ObjectCard(
            icon: Icons.rocket_launch_rounded, color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _BalanceScaleVisual extends StatelessWidget {
  const _BalanceScaleVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _VisualRow(
          children: [
            _ObjectCard(icon: Icons.apple_rounded, color: Color(0xFFFF6F6B)),
            _ObjectCard(icon: Icons.apple_rounded, color: Color(0xFFFF6F6B)),
            _MathSign('='),
            _ObjectCard(icon: Icons.apple_rounded, color: Color(0xFFFF6F6B)),
            _QuestionToken(),
          ],
        ),
        SizedBox(height: 8),
        Icon(Icons.balance_rounded, color: Color(0xFF18B7AE), size: 42),
      ],
    );
  }
}

class _ShapeRotationVisual extends StatelessWidget {
  const _ShapeRotationVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShapeToken.triangle(color: Color(0xFF9C6AF2)),
        _MathSign('->'),
        _RotatedTriangleToken(),
      ],
    );
  }
}

class _CodeGridVisual extends StatelessWidget {
  const _CodeGridVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _NumberGridRow(values: ['2', '4', '6'], color: Color(0xFF5C8EF7)),
        SizedBox(height: 8),
        _NumberGridRow(values: ['3', '5', '?'], color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _NumberBridgeVisual extends StatelessWidget {
  const _NumberBridgeVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _NumberBubble('4', color: Color(0xFF5C8EF7)),
        _NumberBubble('2', color: Color(0xFF18B7AE)),
        _NumberBubble('1', color: Color(0xFFFFB84D)),
        _MathSign('->'),
        _NumberBubble('7', color: Color(0xFFFF6F6B)),
      ],
    );
  }
}

class _DetailCountVisual extends StatelessWidget {
  const _DetailCountVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _VisualRow(
          children: [
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
          ],
        ),
        SizedBox(height: 8),
        _VisualRow(
          children: [
            _ShapeToken.square(color: Color(0xFF5C8EF7)),
            _ShapeToken.square(color: Color(0xFF5C8EF7)),
            _ShapeToken.star(color: Color(0xFF35B37E)),
          ],
        ),
      ],
    );
  }
}

class _DefaultPuzzleVisual extends StatelessWidget {
  const _DefaultPuzzleVisual();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 82,
      child: Center(
        child: Icon(
          Icons.psychology_alt_rounded,
          color: Color(0xFF18B7AE),
          size: 54,
        ),
      ),
    );
  }
}

class _VisualRow extends StatelessWidget {
  const _VisualRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: children,
    );
  }
}

class _ShapeToken extends StatelessWidget {
  const _ShapeToken.circle({required this.color}) : shape = _TokenShape.circle;
  const _ShapeToken.square({required this.color}) : shape = _TokenShape.square;
  const _ShapeToken.star({required this.color}) : shape = _TokenShape.star;
  const _ShapeToken.triangle({required this.color})
      : shape = _TokenShape.triangle;

  final Color color;
  final _TokenShape shape;

  @override
  Widget build(BuildContext context) {
    final icon = switch (shape) {
      _TokenShape.circle => Icons.circle,
      _TokenShape.square => Icons.square_rounded,
      _TokenShape.star => Icons.star_rounded,
      _TokenShape.triangle => Icons.change_history_rounded,
    };

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}

enum _TokenShape { circle, square, star, triangle }

class _ShadowToken extends StatelessWidget {
  const _ShadowToken();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFF164C55).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.rocket_launch_rounded,
        color: Color(0xFF164C55),
        size: 38,
      ),
    );
  }
}

class _RotatedTriangleToken extends StatelessWidget {
  const _RotatedTriangleToken();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 1.5708,
      child: const _ShapeToken.triangle(color: Color(0xFF9C6AF2)),
    );
  }
}

class _QuestionToken extends StatelessWidget {
  const _QuestionToken();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFFFECA8),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        '?',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFFF9D2E),
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class _ShelfScene extends StatelessWidget {
  const _ShelfScene({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VisualRow(children: children),
        const SizedBox(height: 10),
        Container(
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFBFEAE4),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _CubeToy extends StatelessWidget {
  const _CubeToy({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.08,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.24),
              blurRadius: 10,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
      ),
    );
  }
}

class _BallToy extends StatelessWidget {
  const _BallToy({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.24),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const Icon(Icons.sports_basketball_rounded, color: Colors.white),
    );
  }
}

class _ObjectCard extends StatelessWidget {
  const _ObjectCard({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: color, size: 33),
    );
  }
}

class _TrainRow extends StatelessWidget {
  const _TrainRow({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final color in colors) ...[
            _TrainCar(color: color),
            const SizedBox(width: 6),
          ],
          const _QuestionToken(),
        ],
      ),
    );
  }
}

class _TrainCar extends StatelessWidget {
  const _TrainCar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 9, color: Color(0xFF164C55)),
            SizedBox(width: 18),
            Icon(Icons.circle, size: 9, color: Color(0xFF164C55)),
          ],
        ),
      ],
    );
  }
}

class _StickerGroup extends StatelessWidget {
  const _StickerGroup({
    required this.count,
    required this.color,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 58,
      child: Stack(
        children: [
          for (var index = 0; index < count; index += 1)
            Positioned(
              left: (index % 3) * 22,
              top: (index ~/ 3) * 20,
              child: Icon(Icons.star_rounded, color: color, size: 32),
            ),
        ],
      ),
    );
  }
}

class _MathSign extends StatelessWidget {
  const _MathSign(this.sign);

  final String sign;

  @override
  Widget build(BuildContext context) {
    return Text(
      sign,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF164C55),
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _NumberGridRow extends StatelessWidget {
  const _NumberGridRow({
    required this.values,
    required this.color,
  });

  final List<String> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _VisualRow(
      children: [
        for (final value in values) _NumberBubble(value, color: color),
      ],
    );
  }
}

class _NumberBubble extends StatelessWidget {
  const _NumberBubble(
    this.value, {
    required this.color,
  });

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class _LessonFeedback extends StatelessWidget {
  const _LessonFeedback({
    required this.isCorrect,
    required this.challenge,
  });

  final bool isCorrect;
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFDDF8F4) : const Color(0xFFFFEFE4),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.emoji_events_rounded : Icons.tips_and_updates,
            color:
                isCorrect ? const Color(0xFF18B7AE) : const Color(0xFFFF8A42),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCorrect
                  ? l10n.answerCorrect(l10n.explanationForChallenge(challenge))
                  : l10n.answerAlmost(l10n.hintForChallenge(challenge)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCompleteView extends StatelessWidget {
  const _LessonCompleteView({
    required this.lesson,
    required this.onBackToMap,
  });

  final Lesson lesson;
  final VoidCallback onBackToMap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            DecoratedBox(
              decoration: _panelDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    const _StickerReward(),
                    const SizedBox(height: 18),
                    Text(
                      l10n.lessonCompleteTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.lessonCompleteBody,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF426A70),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 18),
                    _StickerUnlockCard(
                      title: l10n.lessonStickerUnlockedTitle,
                      body: l10n.lessonStickerUnlockedBody,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _RewardTile(
                            icon: Icons.star_rounded,
                            label: l10n.lessonRewardStars,
                            color: const Color(0xFFFFC739),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _RewardTile(
                            icon: Icons.bolt_rounded,
                            label: l10n.lessonRewardXp(lesson.xpReward),
                            color: const Color(0xFF18B7AE),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _RewardTile(
                            icon: Icons.collections_bookmark_rounded,
                            label: l10n.lessonRewardCollection,
                            color: const Color(0xFF9C6AF2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _RewardTile(
                            icon: Icons.local_fire_department_rounded,
                            label: l10n.lessonRewardStreak,
                            color: const Color(0xFFFF6F6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: onBackToMap,
                        icon: const Icon(Icons.home_rounded),
                        label: Text(l10n.lessonBackToMap),
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
}

class _StickerReward extends StatelessWidget {
  const _StickerReward();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      height: 176,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 164,
            height: 164,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3D1),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFC739).withValues(alpha: 0.25),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Image(
              image: AssetImage('assets/images/generated/sticker.png'),
              fit: BoxFit.contain,
            ),
          ),
          const Positioned(
            top: 12,
            right: 14,
            child: Icon(Icons.star_rounded, color: Color(0xFFFFC739), size: 32),
          ),
          const Positioned(
            left: 12,
            bottom: 22,
            child: Icon(Icons.star_rounded, color: Color(0xFFFFC739), size: 24),
          ),
        ],
      ),
    );
  }
}

class _StickerUnlockCard extends StatelessWidget {
  const _StickerUnlockCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E9FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD7C5FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFF9C6AF2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF4C2A8A),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6A558F),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.96),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF7ABDB8).withValues(alpha: 0.17),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
  );
}
