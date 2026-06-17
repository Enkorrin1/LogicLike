import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/adaptive_learning.dart';
import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../domain/puzzle_content.dart';
import '../../l10n/l10n.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    required this.profile,
    required this.onLessonComplete,
    required this.onBackToMap,
    required this.onNextLessonSelected,
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
  final ValueChanged<String> onNextLessonSelected;
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
    final adaptivePlan = AdaptiveLessonPlan.forChild(
      child,
      now: DateTime.now(),
    );
    final lesson = widget.lessonId == null
        ? FoundationCatalog.lessonForNode(_currentNode(child))
        : FoundationCatalog.lessonForId(widget.lessonId!);
    final lessonSteps = FoundationCatalog.stepsForLesson(lesson);
    final challenges = _lessonChallenges(child, lesson, adaptivePlan);
    final challenge = challenges[_stepIndex];
    final stepRole = lessonSteps.isEmpty
        ? LessonStepRole.core
        : FoundationCatalog.roleForStep(lessonSteps[_stepIndex]);

    if (_isComplete) {
      return _LessonCompleteView(
        lesson: lesson,
        totalQuestions: challenges.length,
        usedHints: _hintedStepIndexes.length,
        wrongAttempts: _wrongAttempts,
        nextLessonId: _nextLessonIdAfter(lesson.id, child),
        onNextLessonSelected: widget.onNextLessonSelected,
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
              stepRole: stepRole,
              adaptivePlan: adaptivePlan,
              hearts: child.hearts,
              challenge: challenge,
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

  List<DailyChallenge> _lessonChallenges(
    ChildProfile child,
    Lesson lesson,
    AdaptiveLessonPlan adaptivePlan,
  ) {
    final lessonSteps = FoundationCatalog.stepsForLesson(lesson);
    if (lessonSteps.isNotEmpty) {
      return [
        for (final step in lessonSteps)
          dailyChallengeForLessonStep(
            step,
            FoundationCatalog.puzzleForStep(step),
            age: child.age,
            adaptivePlan: adaptivePlan,
          ),
      ];
    }

    final baseChallenges = dailyChallengesForAge(child.age);
    return [
      for (var index = 0; index < lesson.stepIds.length; index += 1)
        baseChallenges[index % baseChallenges.length],
    ];
  }

  String? _nextLessonIdAfter(String lessonId, ChildProfile child) {
    final completedLessonIds = {
      ...child.completedLessonIds,
      lessonId,
    };

    for (final course in FoundationCatalog.starterCourses) {
      final lessonIndex = course.lessonIds.indexOf(lessonId);
      if (lessonIndex == -1) {
        continue;
      }

      for (var index = lessonIndex + 1;
          index < course.lessonIds.length;
          index += 1) {
        final candidateId = course.lessonIds[index];
        if (!completedLessonIds.contains(candidateId)) {
          return candidateId;
        }
      }
    }

    for (final course in FoundationCatalog.starterCourses) {
      for (final candidateId in course.lessonIds) {
        if (!completedLessonIds.contains(candidateId)) {
          return candidateId;
        }
      }
    }

    return null;
  }

  String _buttonLabel(BuildContext context, int totalSteps) {
    final l10n = context.l10n;
    if (_isSaving) {
      return l10n.checkingButton;
    }
    if (_hasSubmitted && !_isCorrect) {
      return l10n.lessonTryAgainButton;
    }
    if (!_hasSubmitted) {
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
    if (_hasSubmitted && !_isCorrect) {
      setState(() {
        _selectedChoiceId = null;
        _hasSubmitted = false;
        _isCorrect = false;
        _showHint = true;
        _hintedStepIndexes.add(_stepIndex);
      });
      return;
    }

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
        _showHint = true;
        _hintedStepIndexes.add(_stepIndex);
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
    required this.stepRole,
    required this.adaptivePlan,
    required this.hearts,
    required this.challenge,
  });

  final int currentStep;
  final int totalSteps;
  final LessonStepRole stepRole;
  final AdaptiveLessonPlan adaptivePlan;
  final int hearts;
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final content = PuzzleContentCatalog.byFamilyId(challenge.visualId);
    final theme = PuzzleContentCatalog.themeForWorld(content.world);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _themeColors(theme.gradientColors),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: _themeColor(theme.accentColor).withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
                  const SizedBox(height: 6),
                  Text(
                    l10n.lessonStepRoleLabel(stepRole),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF18B7AE),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 6),
                  _AdaptiveModePill(plan: adaptivePlan),
                  const SizedBox(height: 8),
                  _WorldStoryPill(content: content),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 12,
                      value: currentStep / totalSteps,
                      color: _themeColor(theme.accentColor),
                      backgroundColor: Colors.white.withValues(alpha: 0.56),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CharacterBadge(content: content),
                const SizedBox(height: 8),
                _HeartPill(hearts: hearts),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorldStoryPill extends StatelessWidget {
  const _WorldStoryPill({required this.content});

  final PuzzleContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = PuzzleContentCatalog.themeForWorld(content.world);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        key: ValueKey('world-pill-${content.world.name}'),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _themeColor(theme.accentColor).withValues(alpha: 0.24),
          ),
        ),
        child: Text(
          '${l10n.labelForPuzzleWorld(content.world)} / '
          '${l10n.labelForPuzzleCharacter(content.character)}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _themeColor(theme.textColor),
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}

class _CharacterBadge extends StatelessWidget {
  const _CharacterBadge({required this.content});

  final PuzzleContent content;

  @override
  Widget build(BuildContext context) {
    final theme = PuzzleContentCatalog.themeForWorld(content.world);
    final poseAsset = PuzzleContentCatalog.characterPoseAsset(
      content.character,
      content.characterPose,
    );
    final motion = _motionEnabled(context);

    final badge = Container(
      key: ValueKey('character-badge-${content.character.name}'),
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        shape: BoxShape.circle,
        border: Border.all(
          color: _themeColor(theme.accentColor).withValues(alpha: 0.32),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(7),
            child: SvgPicture.asset(
              poseAsset.baseAsset,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: _CharacterPoseChip(
              poseAsset: poseAsset,
              size: 19,
            ),
          ),
        ],
      ),
    );

    if (!motion) {
      return badge;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.94, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: badge,
    );
  }
}

class _CharacterPoseChip extends StatelessWidget {
  const _CharacterPoseChip({
    required this.poseAsset,
    required this.size,
  });

  final PuzzleCharacterPoseAsset poseAsset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(
        'character-pose-${poseAsset.character.name}-${poseAsset.pose.name}',
      ),
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.18),
      decoration: BoxDecoration(
        color: Color(poseAsset.accentColor),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: SvgPicture.asset(
        poseAsset.propAsset,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _AdaptiveModePill extends StatelessWidget {
  const _AdaptiveModePill({required this.plan});

  final AdaptiveLessonPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = switch (plan.mode) {
      AdaptiveDifficultyMode.warmUp => const Color(0xFF44A8F2),
      AdaptiveDifficultyMode.steady => const Color(0xFF18B7AE),
      AdaptiveDifficultyMode.stretch => const Color(0xFFFF9D2E),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          l10n.adaptiveModeLabel(plan.mode),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
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
            const _PolishMarker(),
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFECA8),
                    shape: BoxShape.circle,
                  ),
                  child: const _PuzzleSvg(
                    asset: _PuzzleAssets.puzzleCard,
                    size: 42,
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
            if (showHint && (!hasSubmitted || !isCorrect)) ...[
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
    final wrongSelected = submitted && selected && !correct;
    final correctGlow = submitted && correct;
    final motion = _motionEnabled(context);

    return AnimatedSlide(
      offset: motion && wrongSelected ? const Offset(0.018, 0) : Offset.zero,
      duration: motion ? const Duration(milliseconds: 110) : Duration.zero,
      curve: Curves.easeOut,
      child: AnimatedScale(
        scale: motion && (selected || correctGlow) ? 1.018 : 1,
        duration: motion ? const Duration(milliseconds: 160) : Duration.zero,
        curve: Curves.easeOutBack,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: motion && correctGlow ? 1 : 0),
            duration:
                motion ? const Duration(milliseconds: 360) : Duration.zero,
            curve: Curves.easeOutCubic,
            builder: (context, glow, child) {
              return AnimatedContainer(
                duration:
                    motion ? const Duration(milliseconds: 190) : Duration.zero,
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  border: Border.all(
                    color: _borderColor,
                    width: selected || correctGlow ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    if (selected || correctGlow)
                      BoxShadow(
                        color: _borderColor.withValues(
                          alpha: 0.20 + glow * 0.12,
                        ),
                        blurRadius: 16 + glow * 12,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: child,
              );
            },
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
                AnimatedSwitcher(
                  duration: motion
                      ? const Duration(milliseconds: 180)
                      : Duration.zero,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: submitted && (selected || correct)
                      ? Padding(
                          key: ValueKey(
                            correct ? 'choice-correct' : 'choice-wrong',
                          ),
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            correct
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: correct
                                ? const Color(0xFF18B7AE)
                                : const Color(0xFFFF6F6B),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('choice-empty')),
                ),
              ],
            ),
          ),
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
    return const Color(0xFFDDEDEA);
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
    final motion = _motionEnabled(context);

    final panel = Container(
      key: const ValueKey('hint-lightbulb-moment'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lessonHintTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF6B5316),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.hintForChallenge(challenge),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B5316),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!motion) {
      return panel;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: Transform.scale(
              scale: 0.97 + value * 0.03,
              child: child,
            ),
          ),
        );
      },
      child: panel,
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
    final asset = _assetForChoice(challenge.visualId, choice.id);
    final child = _ChoiceArt(
      asset: asset,
      choiceId: choice.id,
      color: color,
    );

    return AnimatedScale(
      scale: selected ? 1.08 : 1,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
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
      ),
    );
  }

  Color _colorForChoice(String choiceId) {
    return switch (choiceId) {
      'circle' || 'red' || 'red-circles' => const Color(0xFFFF6F6B),
      'triangle' || 'blue' || 'blue-squares' => const Color(0xFF5C8EF7),
      'star' || 'green' || 'green-stars' => const Color(0xFF35B37E),
      'left' => const Color(0xFF5C8EF7),
      'right' => const Color(0xFF18B7AE),
      'up' => const Color(0xFF9C6AF2),
      'down' => const Color(0xFFFF9D2E),
      'apple' => const Color(0xFFFF6F6B),
      'ball' => const Color(0xFFFF9F43),
      'banana' => const Color(0xFFFFC739),
      'pear' => const Color(0xFF35B37E),
      'rocket' || 'same' => const Color(0xFF18B7AE),
      'planet' || 'square' => const Color(0xFF5C8EF7),
      'lock' || '4+2+1' => const Color(0xFF18B7AE),
      'shoe' || '4+1' => const Color(0xFF9C6AF2),
      'cloud' || '2+1' => const Color(0xFF5C8EF7),
      _ => const Color(0xFFFF9D2E),
    };
  }
}

String? _assetForChoice(String challengeId, String choiceId) {
  return switch ('$challengeId:$choiceId') {
    'shape-path:triangle' => _PuzzleAssets.triangle,
    'shape-path:circle' => _PuzzleAssets.circle,
    'shape-path:square' => _PuzzleAssets.square,
    'shape-path:star' => _PuzzleAssets.star,
    'fruit-pattern:apple' => _PuzzleAssets.apple,
    'fruit-pattern:banana' => _PuzzleAssets.banana,
    'fruit-pattern:pear' => _PuzzleAssets.pear,
    'odd-card:apple' => _PuzzleAssets.apple,
    'odd-card:pear' => _PuzzleAssets.pear,
    'odd-card:ball' => _PuzzleAssets.ball,
    'odd-card:banana' => _PuzzleAssets.banana,
    'odd-card:cloud' => _PuzzleAssets.cloud,
    'odd-card:shoe' => _PuzzleAssets.shoe,
    'odd-card:rocket' => _PuzzleAssets.rocket,
    'odd-card:planet' => _PuzzleAssets.planet,
    'odd-card:star' => _PuzzleAssets.star,
    'odd-card:circle' => _PuzzleAssets.circle,
    'odd-card:square' => _PuzzleAssets.square,
    'odd-card:triangle' => _PuzzleAssets.triangle,
    'logic-train:blue' => _PuzzleAssets.trainBlue,
    'logic-train:red' => _PuzzleAssets.trainRed,
    'logic-train:green' => _PuzzleAssets.trainGreen,
    'memory-pairs:lock' => _PuzzleAssets.lock,
    'memory-pairs:shoe' => _PuzzleAssets.shoe,
    'memory-pairs:cloud' => _PuzzleAssets.cloud,
    'lock-key:lock' => _PuzzleAssets.lock,
    'lock-key:shoe' => _PuzzleAssets.shoe,
    'lock-key:cloud' => _PuzzleAssets.cloud,
    'shadow-match:rocket' => _PuzzleAssets.rocket,
    'shadow-match:planet' => _PuzzleAssets.planet,
    'shadow-match:star' => _PuzzleAssets.star,
    'balance-scale:apple' => _PuzzleAssets.apple,
    'balance-scale:star' => _PuzzleAssets.star,
    'balance-scale:ball' => _PuzzleAssets.ball,
    'shape-rotation:same' => _PuzzleAssets.triangle,
    'shape-rotation:circle' => _PuzzleAssets.circle,
    'shape-rotation:square' => _PuzzleAssets.square,
    'detail-count:blue-squares' => _PuzzleAssets.square,
    'detail-count:red-circles' => _PuzzleAssets.circle,
    'detail-count:green-stars' => _PuzzleAssets.star,
    'space-sequence:rocket' => _PuzzleAssets.rocket,
    'space-sequence:planet' => _PuzzleAssets.planet,
    'space-sequence:star' => _PuzzleAssets.star,
    'shape-stack:square' => _PuzzleAssets.square,
    'shape-stack:circle' => _PuzzleAssets.circle,
    'shape-stack:triangle' => _PuzzleAssets.triangle,
    'shape-stack:star' => _PuzzleAssets.star,
    'memory-recall:star' => _PuzzleAssets.star,
    'memory-recall:key' => _PuzzleAssets.key,
    'memory-recall:banana' => _PuzzleAssets.banana,
    'memory-recall:triangle' => _PuzzleAssets.triangle,
    'sorting-rule:pear' => _PuzzleAssets.pear,
    'sorting-rule:star' => _PuzzleAssets.star,
    'sorting-rule:planet' => _PuzzleAssets.planet,
    'sorting-rule:lock' => _PuzzleAssets.lock,
    'missing-piece:circle' => _PuzzleAssets.circle,
    'missing-piece:star' => _PuzzleAssets.star,
    'missing-piece:key' => _PuzzleAssets.key,
    'logic-deduction:rocket' => _PuzzleAssets.rocket,
    'logic-deduction:key' => _PuzzleAssets.key,
    'logic-deduction:banana' => _PuzzleAssets.banana,
    _ => null,
  };
}

class _PuzzleAssets {
  static const circle = 'assets/images/puzzles/shape_circle.svg';
  static const square = 'assets/images/puzzles/shape_square.svg';
  static const triangle = 'assets/images/puzzles/shape_triangle.svg';
  static const star = 'assets/images/puzzles/shape_star.svg';
  static const cubeOrange = 'assets/images/puzzles/toy_cube_orange.svg';
  static const cubeBlue = 'assets/images/puzzles/toy_cube_blue.svg';
  static const ball = 'assets/images/puzzles/ball.svg';
  static const apple = 'assets/images/puzzles/apple.svg';
  static const banana = 'assets/images/puzzles/banana.svg';
  static const pear = 'assets/images/puzzles/pear.svg';
  static const rocket = 'assets/images/puzzles/rocket.svg';
  static const planet = 'assets/images/puzzles/planet.svg';
  static const lock = 'assets/images/puzzles/lock.svg';
  static const key = 'assets/images/puzzles/key.svg';
  static const shoe = 'assets/images/puzzles/shoe.svg';
  static const cloud = 'assets/images/puzzles/cloud.svg';
  static const trainBlue = 'assets/images/puzzles/train_blue.svg';
  static const trainRed = 'assets/images/puzzles/train_red.svg';
  static const trainGreen = 'assets/images/puzzles/train_green.svg';
  static const shadowRocket = 'assets/images/puzzles/shadow_rocket.svg';
  static const scale = 'assets/images/puzzles/scale.svg';
  static const puzzleCard = 'assets/images/puzzles/puzzle_card.svg';
  static const plus = 'assets/images/puzzles/sign_plus.svg';
  static const equals = 'assets/images/puzzles/sign_equals.svg';
  static const arrow = 'assets/images/puzzles/sign_arrow.svg';
  static const question = 'assets/images/puzzles/sign_question.svg';

  static String number(int value) => 'assets/images/puzzles/number_$value.svg';
}

class _PuzzleSvg extends StatelessWidget {
  const _PuzzleSvg({
    required this.asset,
    this.size = 48,
  });

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class _ChoiceArt extends StatelessWidget {
  const _ChoiceArt({
    required this.asset,
    required this.choiceId,
    required this.color,
  });

  final String? asset;
  final String choiceId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (asset != null) {
      return _PuzzleSvg(asset: asset!, size: 40);
    }

    if (_isPositiveNumber(choiceId)) {
      return _NumberGlyph(
        value: int.parse(choiceId),
        size: 40,
      );
    }

    if (_isSumExpression(choiceId)) {
      return _ExpressionGlyph(
        expression: choiceId,
        color: color,
      );
    }

    if (_isDirection(choiceId)) {
      return _DirectionGlyph(
        direction: choiceId,
        color: color,
        size: 34,
      );
    }

    return const _PuzzleSvg(asset: _PuzzleAssets.puzzleCard, size: 40);
  }
}

bool _isPositiveNumber(String value) {
  final parsed = int.tryParse(value);
  return parsed != null && parsed >= 0 && parsed <= 20;
}

bool _isSumExpression(String value) {
  return RegExp(r'^\d+(\+\d+)+$').hasMatch(value);
}

bool _isDirection(String value) {
  return value == 'left' ||
      value == 'right' ||
      value == 'up' ||
      value == 'down';
}

class _NumberGlyph extends StatelessWidget {
  const _NumberGlyph({
    required this.value,
    this.size = 42,
  });

  final int value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      key: ValueKey('number-svg-$value'),
      _PuzzleAssets.number(value.clamp(0, 20).toInt()),
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class _ExpressionGlyph extends StatelessWidget {
  const _ExpressionGlyph({
    required this.expression,
    required this.color,
  });

  final String expression;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final parts = expression.split('+');

    return FittedBox(
      key: ValueKey('expression-svg-$expression'),
      fit: BoxFit.contain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < parts.length; index += 1) ...[
            _NumberGlyph(value: int.parse(parts[index]), size: 28),
            if (index < parts.length - 1)
              _SignGlyph(
                asset: _PuzzleAssets.plus,
                color: color,
                size: 18,
              ),
          ],
        ],
      ),
    );
  }
}

class _DirectionGlyph extends StatelessWidget {
  const _DirectionGlyph({
    required this.direction,
    required this.color,
    required this.size,
  });

  final String direction;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: switch (direction) {
        'up' => -1.5708,
        'down' => 1.5708,
        'left' => 3.1416,
        _ => 0,
      },
      child: _SignGlyph(
        key: ValueKey('direction-svg-$direction'),
        asset: _PuzzleAssets.arrow,
        color: color,
        size: size,
      ),
    );
  }
}

class _PuzzleVisual extends StatelessWidget {
  const _PuzzleVisual({required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final content = PuzzleContentCatalog.byFamilyId(challenge.visualId);
    final theme = PuzzleContentCatalog.themeForWorld(content.world);

    return Container(
      key: ValueKey('puzzle-world-${content.world.name}'),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _themeColors(theme.sceneColors),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
        boxShadow: [
          BoxShadow(
            color: _themeColor(theme.accentColor).withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: switch (challenge.visualId) {
        'shape-path' => _ShapePatternVisual(tokens: challenge.tokens),
        'fruit-pattern' => _FruitPatternVisual(tokens: challenge.tokens),
        'toy-count' => _ToyCountVisual(numbers: challenge.numbers),
        'odd-card' => _OddCardVisual(tokens: challenge.tokens),
        'logic-train' => _LogicTrainVisual(tokens: challenge.tokens),
        'sticker-sum' => _StickerSumVisual(numbers: challenge.numbers),
        'memory-pairs' => _MemoryPairsVisual(tokens: challenge.tokens),
        'lock-key' => _LockKeyVisual(tokens: challenge.tokens),
        'shadow-match' => _ShadowMatchVisual(tokens: challenge.tokens),
        'balance-scale' => _BalanceScaleVisual(numbers: challenge.numbers),
        'shape-rotation' => const _ShapeRotationVisual(),
        'code-grid' => _CodeGridVisual(numbers: challenge.numbers),
        'number-bridge' => _NumberBridgeVisual(numbers: challenge.numbers),
        'detail-count' => _DetailCountVisual(numbers: challenge.numbers),
        'space-sequence' => _SpaceSequenceVisual(tokens: challenge.tokens),
        'shape-stack' => _ShapeStackVisual(tokens: challenge.tokens),
        'path-maze' => _PathMazeVisual(tokens: challenge.tokens),
        'memory-recall' => _MemoryRecallVisual(tokens: challenge.tokens),
        'sorting-rule' => _SortingRuleVisual(tokens: challenge.tokens),
        'missing-piece' => _MissingPieceVisual(tokens: challenge.tokens),
        'logic-deduction' => _LogicDeductionVisual(tokens: challenge.tokens),
        _ => const _DefaultPuzzleVisual(),
      },
    );
  }
}

class _ShapePatternVisual extends StatelessWidget {
  const _ShapePatternVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final first = tokens.elementAtOrNull(0) ?? 'circle';
    final second = tokens.elementAtOrNull(1) ?? 'square';

    return _VisualRow(
      children: [
        _TokenCard(token: first),
        _TokenCard(token: second),
        _TokenCard(token: first),
        _TokenCard(token: second),
        const _QuestionToken(),
      ],
    );
  }
}

class _FruitPatternVisual extends StatelessWidget {
  const _FruitPatternVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final first = tokens.elementAtOrNull(0) ?? 'apple';
    final second = tokens.elementAtOrNull(1) ?? 'banana';

    return _VisualRow(
      children: [
        _TokenCard(token: first),
        _TokenCard(token: second),
        _TokenCard(token: first),
        _TokenCard(token: second),
        const _QuestionToken(),
      ],
    );
  }
}

class _ToyCountVisual extends StatelessWidget {
  const _ToyCountVisual({required this.numbers});

  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    final cubes = numbers.elementAtOrNull(0) ?? 1;
    final balls = numbers.elementAtOrNull(1) ?? 1;

    return _ShelfScene(
      children: [
        for (var index = 0; index < cubes; index += 1)
          _CubeToy(
            color: index.isEven
                ? const Color(0xFFFFB84D)
                : const Color(0xFF5C8EF7),
            asset: index.isEven
                ? _PuzzleAssets.cubeOrange
                : _PuzzleAssets.cubeBlue,
          ),
        for (var index = 0; index < balls; index += 1)
          const _BallToy(color: Color(0xFFFF6F6B)),
      ],
    );
  }
}

class _OddCardVisual extends StatelessWidget {
  const _OddCardVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final items = tokens.isEmpty
        ? const ['apple', 'banana', 'pear', 'ball']
        : tokens.take(4).toList(growable: false);

    return _VisualRow(
      children: [
        for (final item in items) _TokenCard(token: item),
      ],
    );
  }
}

class _LogicTrainVisual extends StatelessWidget {
  const _LogicTrainVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final first = tokens.elementAtOrNull(0) ?? 'red';
    final second = tokens.elementAtOrNull(1) ?? 'blue';

    return _TrainRow(tokens: [first, second, second, first, second, second]);
  }
}

class _StickerSumVisual extends StatelessWidget {
  const _StickerSumVisual({required this.numbers});

  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    final first = numbers.elementAtOrNull(0) ?? 3;
    final second = numbers.elementAtOrNull(1) ?? 2;

    return _VisualRow(
      children: [
        _StickerGroup(count: first, color: const Color(0xFFFFC739)),
        const _MathSign('+'),
        _StickerGroup(count: second, color: const Color(0xFF9C6AF2)),
        const _MathSign('='),
        const _QuestionToken(),
      ],
    );
  }
}

class _MemoryPairsVisual extends StatelessWidget {
  const _MemoryPairsVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final clue = tokens.elementAtOrNull(0) ?? 'key';

    return _VisualRow(
      children: [
        _TokenCard(token: clue),
        const _MathSign('+'),
        const _QuestionToken(),
      ],
    );
  }
}

class _LockKeyVisual extends StatelessWidget {
  const _LockKeyVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final clue = tokens.elementAtOrNull(0) ?? 'key';
    final answer = tokens.elementAtOrNull(1) ?? 'lock';

    return _VisualRow(
      children: [
        _TokenCard(token: clue),
        const _MathSign('+'),
        _TokenCard(token: answer),
      ],
    );
  }
}

class _ShadowMatchVisual extends StatelessWidget {
  const _ShadowMatchVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final token = tokens.elementAtOrNull(0) ?? 'rocket';

    return _VisualRow(
      children: [
        _ShadowToken(token: token),
        const _MathSign('->'),
        _TokenCard(token: token),
      ],
    );
  }
}

class _BalanceScaleVisual extends StatelessWidget {
  const _BalanceScaleVisual({required this.numbers});

  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    final left = numbers.elementAtOrNull(0) ?? 2;
    final known = numbers.elementAtOrNull(1) ?? 1;

    return Column(
      children: [
        _VisualRow(
          children: [
            _MiniGroup(
              token: 'apple',
              count: left,
            ),
            const _MathSign('='),
            _MiniGroup(
              token: 'apple',
              count: known,
            ),
            const _QuestionToken(),
          ],
        ),
        const SizedBox(height: 8),
        const _PuzzleSvg(asset: _PuzzleAssets.scale, size: 84),
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
  const _CodeGridVisual({required this.numbers});

  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    final safeNumbers =
        numbers.length >= 6 ? numbers : const [2, 4, 6, 3, 5, 7, 2];

    return Column(
      children: [
        _NumberGridRow(
          values: [
            '${safeNumbers[0]}',
            '${safeNumbers[1]}',
            '${safeNumbers[2]}',
          ],
          color: const Color(0xFF5C8EF7),
        ),
        const SizedBox(height: 8),
        _NumberGridRow(
          values: ['${safeNumbers[3]}', '${safeNumbers[4]}', '?'],
          color: const Color(0xFF18B7AE),
        ),
      ],
    );
  }
}

class _NumberBridgeVisual extends StatelessWidget {
  const _NumberBridgeVisual({required this.numbers});

  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    final safeNumbers = numbers.length >= 4 ? numbers : const [4, 2, 1, 7];

    return _VisualRow(
      children: [
        _NumberBubble('${safeNumbers[0]}', color: const Color(0xFF5C8EF7)),
        _NumberBubble('${safeNumbers[1]}', color: const Color(0xFF18B7AE)),
        _NumberBubble('${safeNumbers[2]}', color: const Color(0xFFFFB84D)),
        const _MathSign('->'),
        _NumberBubble('${safeNumbers[3]}', color: const Color(0xFFFF6F6B)),
      ],
    );
  }
}

class _DetailCountVisual extends StatelessWidget {
  const _DetailCountVisual({required this.numbers});

  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    final red = numbers.elementAtOrNull(0) ?? 3;
    final blue = numbers.elementAtOrNull(1) ?? 2;
    final green = numbers.elementAtOrNull(2) ?? 1;

    return Column(
      children: [
        _VisualRow(
          children: [
            for (var index = 0; index < red; index += 1)
              _ShapeToken.circle(
                key: ValueKey('detail-red-circle-${index + 1}'),
                color: const Color(0xFFFF6F6B),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _VisualRow(
          children: [
            for (var index = 0; index < blue; index += 1)
              _ShapeToken.square(
                key: ValueKey('detail-blue-square-${index + 1}'),
                color: const Color(0xFF5C8EF7),
              ),
            for (var index = 0; index < green; index += 1)
              const _ShapeToken.star(color: Color(0xFF35B37E)),
          ],
        ),
      ],
    );
  }
}

class _SpaceSequenceVisual extends StatelessWidget {
  const _SpaceSequenceVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final first = tokens.elementAtOrNull(0) ?? 'rocket';
    final second = tokens.elementAtOrNull(1) ?? 'planet';

    return _VisualRow(
      children: [
        _TokenCard(token: first),
        _TokenCard(token: second),
        _TokenCard(token: first),
        _TokenCard(token: second),
        const _QuestionToken(),
      ],
    );
  }
}

class _ShapeStackVisual extends StatelessWidget {
  const _ShapeStackVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final first = tokens.elementAtOrNull(0) ?? 'square';
    final second = tokens.elementAtOrNull(1) ?? 'circle';

    return _VisualRow(
      children: [
        _TokenCard(token: first),
        _TokenCard(token: second),
        _TokenCard(token: first),
        _TokenCard(token: second),
        const _QuestionToken(),
      ],
    );
  }
}

class _PathMazeVisual extends StatelessWidget {
  const _PathMazeVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final start = tokens.elementAtOrNull(0) ?? 'rocket';
    final target = tokens.elementAtOrNull(1) ?? 'planet';
    final direction = tokens.elementAtOrNull(2) ?? 'right';
    final motion = _motionEnabled(context);

    return SizedBox(
      key: const ValueKey('path-maze-visual'),
      height: 138,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MazePathPainter(direction: direction),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 18,
            child: TweenAnimationBuilder<double>(
              key: const ValueKey('path-move-cue'),
              tween: Tween(begin: 0, end: motion ? 1 : 0),
              duration:
                  motion ? const Duration(milliseconds: 760) : Duration.zero,
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                final offset = _startMoveOffset(direction) * value;
                return Transform.translate(
                  offset: offset,
                  child: child,
                );
              },
              child: _TokenCard(token: start),
            ),
          ),
          Positioned(
            right: _targetRight(direction),
            top: _targetTop(direction),
            bottom: _targetBottom(direction),
            child: _TokenCard(token: target),
          ),
          Positioned(
            left: 80,
            bottom: 34,
            child: _MazeFork(direction: direction),
          ),
        ],
      ),
    );
  }

  double _targetRight(String direction) => direction == 'left' ? 110 : 10;

  Offset _startMoveOffset(String direction) => switch (direction) {
        'up' => const Offset(42, -26),
        'down' => const Offset(42, 18),
        'left' => const Offset(32, -16),
        _ => const Offset(52, -18),
      };

  double? _targetTop(String direction) => switch (direction) {
        'up' => 4,
        'left' || 'right' => 14,
        _ => null,
      };

  double? _targetBottom(String direction) => direction == 'down' ? 4 : null;
}

class _MemoryRecallVisual extends StatelessWidget {
  const _MemoryRecallVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final visible = tokens.isEmpty
        ? const ['rocket', 'planet', 'star']
        : tokens.take(3).toList(growable: false);

    return Column(
      key: const ValueKey('memory-recall-visual'),
      children: [
        _VisualRow(
          children: [
            for (final token in visible.take(2)) _TokenCard(token: token),
            _HiddenMemoryCard(token: visible.last),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 8,
          width: 150,
          decoration: BoxDecoration(
            color: const Color(0xFFBFEAE4),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _HiddenMemoryCard extends StatelessWidget {
  const _HiddenMemoryCard({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.26,
          child: _TokenCard(token: token),
        ),
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF9C6AF2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C6AF2).withValues(alpha: 0.20),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const _SignGlyph(
            asset: _PuzzleAssets.question,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }
}

class _SortingRuleVisual extends StatelessWidget {
  const _SortingRuleVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final safeTokens = tokens.length >= 4
        ? tokens
        : const ['apple', 'banana', 'pear', 'rocket'];

    return Column(
      key: const ValueKey('sorting-rule-visual'),
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE7FBF7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF18B7AE), width: 2),
          ),
          child: _VisualRow(
            children: [
              _TokenCard(token: safeTokens[0]),
              _TokenCard(token: safeTokens[1]),
              const _QuestionToken(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _VisualRow(
          children: [
            _TokenCard(token: safeTokens[2]),
            _TokenCard(token: safeTokens[3]),
          ],
        ),
      ],
    );
  }
}

class _MissingPieceVisual extends StatelessWidget {
  const _MissingPieceVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final subject = tokens.elementAtOrNull(0) ?? 'rocket';
    final missing = tokens.elementAtOrNull(1) ?? 'circle';

    return Column(
      key: const ValueKey('missing-piece-visual'),
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            _TokenCard(token: subject),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E7),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: const Color(0xFFFFC739),
                    width: 3,
                  ),
                ),
                child: const _SignGlyph(
                  asset: _PuzzleAssets.question,
                  color: Color(0xFFFF9D2E),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _VisualRow(
          children: [
            const _MathSign('->'),
            _TokenCard(token: missing),
          ],
        ),
      ],
    );
  }
}

class _LogicDeductionVisual extends StatelessWidget {
  const _LogicDeductionVisual({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    final clueOne = tokens.elementAtOrNull(0) ?? 'flies';
    final clueTwo = tokens.elementAtOrNull(1) ?? 'not-fruit';
    final answer = tokens.elementAtOrNull(2) ?? 'rocket';

    return Column(
      key: const ValueKey('logic-deduction-visual'),
      children: [
        _VisualRow(
          children: [
            _ClueCard(clue: clueOne),
            const _MathSign('+'),
            _ClueCard(clue: clueTwo),
          ],
        ),
        const SizedBox(height: 10),
        _VisualRow(
          children: [
            const _QuestionToken(),
            const _MathSign('->'),
            _TokenCard(token: answer),
          ],
        ),
      ],
    );
  }
}

class _ClueCard extends StatelessWidget {
  const _ClueCard({required this.clue});

  final String clue;

  @override
  Widget build(BuildContext context) {
    final asset = switch (clue) {
      'flies' => _PuzzleAssets.rocket,
      'opens' => _PuzzleAssets.key,
      'fruit' || 'yellow' => _PuzzleAssets.banana,
      'not-fruit' || 'not-cloud' => _PuzzleAssets.question,
      _ => _PuzzleAssets.question,
    };

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF164C55).withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _PuzzleSvg(asset: asset, size: 42),
          if (clue.startsWith('not-'))
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6F6B),
                borderRadius: BorderRadius.circular(999),
              ),
              transform: Matrix4.rotationZ(-0.66),
            ),
        ],
      ),
    );
  }
}

class _MazeFork extends StatelessWidget {
  const _MazeFork({required this.direction});

  final String direction;

  @override
  Widget build(BuildContext context) {
    final directions = ['up', 'right', 'down', 'left'];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in directions)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: item == direction
                    ? const Color(0xFF18B7AE).withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.76),
                borderRadius: BorderRadius.circular(13),
              ),
              alignment: Alignment.center,
              child: _DirectionGlyph(
                direction: item,
                color: item == direction
                    ? const Color(0xFF18B7AE)
                    : const Color(0xFF9FB7BB),
                size: 23,
              ),
            ),
          ),
      ],
    );
  }
}

class _MazePathPainter extends CustomPainter {
  const _MazePathPainter({required this.direction});

  final String direction;

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = const Color(0xFFBFEAE4)
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final activePaint = Paint()
      ..color = const Color(0xFF18B7AE)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final start = Offset(62, size.height - 44);
    final fork = Offset(size.width * 0.42, size.height - 44);
    final endpoints = {
      'up': Offset(size.width - 62, 38),
      'right': Offset(size.width - 62, 48),
      'down': Offset(size.width - 62, size.height - 34),
      'left': Offset(size.width * 0.58, 38),
    };

    for (final entry in endpoints.entries) {
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(fork.dx, fork.dy)
        ..lineTo(entry.value.dx, entry.value.dy);
      canvas.drawPath(path, entry.key == direction ? activePaint : basePaint);
    }
  }

  @override
  bool shouldRepaint(_MazePathPainter oldDelegate) {
    return oldDelegate.direction != direction;
  }
}

class _DefaultPuzzleVisual extends StatelessWidget {
  const _DefaultPuzzleVisual();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 82,
      child: Center(
        child: _PuzzleSvg(asset: _PuzzleAssets.puzzleCard, size: 64),
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

class _TokenCard extends StatelessWidget {
  const _TokenCard({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final child = switch (token) {
      'circle' => const _ShapeToken.circle(color: Color(0xFF18B7AE)),
      'square' => const _ShapeToken.square(color: Color(0xFF5C8EF7)),
      'triangle' => const _ShapeToken.triangle(color: Color(0xFF9C6AF2)),
      'star' => const _ShapeToken.star(color: Color(0xFFFFC739)),
      _ => _ObjectCard(
          asset: _assetForToken(token) ?? _PuzzleAssets.puzzleCard,
          color: _colorForToken(token),
        ),
    };

    return KeyedSubtree(
      key: ValueKey('visual-token-$token'),
      child: child,
    );
  }
}

String? _assetForToken(String token) {
  return switch (token) {
    'apple' => _PuzzleAssets.apple,
    'banana' => _PuzzleAssets.banana,
    'pear' => _PuzzleAssets.pear,
    'ball' => _PuzzleAssets.ball,
    'rocket' => _PuzzleAssets.rocket,
    'planet' => _PuzzleAssets.planet,
    'lock' => _PuzzleAssets.lock,
    'key' => _PuzzleAssets.key,
    'shoe' || 'foot' => _PuzzleAssets.shoe,
    'cloud' || 'rain' => _PuzzleAssets.cloud,
    _ => null,
  };
}

Color _colorForToken(String token) {
  return switch (token) {
    'apple' || 'red' => const Color(0xFFFF6F6B),
    'banana' || 'star' => const Color(0xFFFFC739),
    'pear' || 'green' => const Color(0xFF35B37E),
    'ball' => const Color(0xFFFF9F43),
    'rocket' || 'key' || 'lock' => const Color(0xFF18B7AE),
    'planet' || 'blue' || 'square' => const Color(0xFF5C8EF7),
    'shoe' || 'foot' || 'triangle' => const Color(0xFF9C6AF2),
    'cloud' || 'rain' => const Color(0xFF8DD7FF),
    'circle' => const Color(0xFF18B7AE),
    _ => const Color(0xFFFFB84D),
  };
}

class _MiniGroup extends StatelessWidget {
  const _MiniGroup({
    required this.token,
    required this.count,
  });

  final String token;
  final int count;

  @override
  Widget build(BuildContext context) {
    final asset = _assetForToken(token) ?? _PuzzleAssets.puzzleCard;

    return SizedBox(
      width: 76,
      height: 58,
      child: Stack(
        children: [
          for (var index = 0; index < count; index += 1)
            Positioned(
              left: (index % 3) * 22,
              top: (index ~/ 3) * 20,
              child: _PuzzleSvg(asset: asset, size: 32),
            ),
        ],
      ),
    );
  }
}

class _ShapeToken extends StatelessWidget {
  const _ShapeToken.circle({required this.color, super.key})
      : shape = _TokenShape.circle;
  const _ShapeToken.square({required this.color, super.key})
      : shape = _TokenShape.square;
  const _ShapeToken.star({required this.color}) : shape = _TokenShape.star;
  const _ShapeToken.triangle({required this.color})
      : shape = _TokenShape.triangle;

  final Color color;
  final _TokenShape shape;

  @override
  Widget build(BuildContext context) {
    final svgKey =
        key is ValueKey ? ValueKey('${(key! as ValueKey).value}-svg') : null;
    final asset = switch (shape) {
      _TokenShape.circle => _PuzzleAssets.circle,
      _TokenShape.square => _PuzzleAssets.square,
      _TokenShape.star => _PuzzleAssets.star,
      _TokenShape.triangle => _PuzzleAssets.triangle,
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
      child: SvgPicture.asset(
        key: svgKey,
        asset,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}

enum _TokenShape { circle, square, star, triangle }

class _ShadowToken extends StatelessWidget {
  const _ShadowToken({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    final asset = _assetForToken(token) ?? _PuzzleAssets.shadowRocket;

    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFF164C55).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SvgPicture.asset(
        asset,
        width: 54,
        height: 54,
        fit: BoxFit.contain,
        colorFilter: const ColorFilter.mode(
          Color(0xFF164C55),
          BlendMode.srcIn,
        ),
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
      child: const _SignGlyph(
        asset: _PuzzleAssets.question,
        color: Color(0xFFFF9D2E),
        size: 34,
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
  const _CubeToy({
    required this.color,
    required this.asset,
  });

  final Color color;
  final String asset;

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
        child: _PuzzleSvg(asset: asset, size: 44),
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
      child: const _PuzzleSvg(asset: _PuzzleAssets.ball, size: 46),
    );
  }
}

class _ObjectCard extends StatelessWidget {
  const _ObjectCard({
    required this.asset,
    required this.color,
  });

  final String asset;
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
      child: _PuzzleSvg(asset: asset, size: 48),
    );
  }
}

class _TrainRow extends StatelessWidget {
  const _TrainRow({required this.tokens});

  final List<String> tokens;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final token in tokens) ...[
            _TrainCar(color: _colorForToken(token)),
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
            _TrainWheel(),
            SizedBox(width: 18),
            _TrainWheel(),
          ],
        ),
      ],
    );
  }
}

class _TrainWheel extends StatelessWidget {
  const _TrainWheel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        color: Color(0xFF164C55),
        shape: BoxShape.circle,
      ),
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
              child: const _PuzzleSvg(asset: _PuzzleAssets.star, size: 32),
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
    final asset = switch (sign) {
      '+' => _PuzzleAssets.plus,
      '=' => _PuzzleAssets.equals,
      '->' => _PuzzleAssets.arrow,
      _ => _PuzzleAssets.question,
    };

    return _SignGlyph(
      asset: asset,
      color: const Color(0xFF164C55),
      size: 32,
    );
  }
}

class _SignGlyph extends StatelessWidget {
  const _SignGlyph({
    required this.asset,
    required this.color,
    this.size = 32,
    super.key,
  });

  final String asset;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
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
      child: value == '?'
          ? _SignGlyph(
              asset: _PuzzleAssets.question,
              color: color,
              size: 30,
            )
          : _NumberGlyph(
              value: int.tryParse(value) ?? 0,
              size: 40,
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey('lesson-feedback-$isCorrect'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCorrect ? const Color(0xFFDDF8F4) : const Color(0xFFFFEFE4),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.82, end: 1),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Icon(
                isCorrect ? Icons.emoji_events_rounded : Icons.tips_and_updates,
                color: isCorrect
                    ? const Color(0xFF18B7AE)
                    : const Color(0xFFFF8A42),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isCorrect
                    ? l10n
                        .answerCorrect(l10n.explanationForChallenge(challenge))
                    : l10n.lessonRetryFeedback,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonCompleteView extends StatelessWidget {
  const _LessonCompleteView({
    required this.lesson,
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
    required this.nextLessonId,
    required this.onNextLessonSelected,
    required this.onBackToMap,
  });

  final Lesson lesson;
  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;
  final String? nextLessonId;
  final ValueChanged<String> onNextLessonSelected;
  final VoidCallback onBackToMap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final firstStep = FoundationCatalog.stepsForLesson(lesson).firstOrNull;
    final rewardContent = firstStep == null
        ? null
        : PuzzleContentCatalog.maybeByFamilyId(
            FoundationCatalog.puzzleForStep(firstStep).payloadRef,
          );

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
                    const _RewardPolishMarker(),
                    const _StickerReward(),
                    if (rewardContent != null) ...[
                      const SizedBox(height: 12),
                      _RewardCharacter(content: rewardContent),
                    ],
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
                    _LessonReviewCard(
                      totalQuestions: totalQuestions,
                      usedHints: usedHints,
                      wrongAttempts: wrongAttempts,
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
                    if (nextLessonId != null) ...[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => onNextLessonSelected(nextLessonId!),
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: Text(l10n.lessonNextRecommendedButton),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
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
    final motion = _motionEnabled(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: motion ? const Duration(milliseconds: 620) : Duration.zero,
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final scale = motion ? 0.78 + (value * 0.22) : 1.0;
        final turns = motion ? (1 - value) * -0.035 : 0.0;
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.rotate(
            angle: turns,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: SizedBox(
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
              child: Icon(
                Icons.star_rounded,
                color: Color(0xFFFFC739),
                size: 32,
              ),
            ),
            const Positioned(
              left: 12,
              bottom: 22,
              child: Icon(
                Icons.star_rounded,
                color: Color(0xFFFFC739),
                size: 24,
              ),
            ),
            const _RewardFlyingStars(),
          ],
        ),
      ),
    );
  }
}

class _RewardCharacter extends StatelessWidget {
  const _RewardCharacter({required this.content});

  final PuzzleContent content;

  @override
  Widget build(BuildContext context) {
    final profile = PuzzleContentCatalog.characterProfile(content.character);
    final poseAsset = PuzzleContentCatalog.characterPoseAsset(
      content.character,
      CharacterPose.victory,
    );
    final motion = _motionEnabled(context);
    final child = Container(
      key: const ValueKey('reward-character-victory'),
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: Color(profile.accentColor).withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(profile.accentColor).withValues(alpha: 0.32),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(9),
            child: SvgPicture.asset(
              poseAsset.baseAsset,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            right: 7,
            bottom: 7,
            child: _CharacterPoseChip(
              poseAsset: poseAsset,
              size: 25,
            ),
          ),
        ],
      ),
    );

    if (!motion) {
      return child;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 680),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.75 + value * 0.25,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _RewardFlyingStars extends StatelessWidget {
  const _RewardFlyingStars();

  @override
  Widget build(BuildContext context) {
    final motion = _motionEnabled(context);

    return SizedBox.expand(
      key: const ValueKey('reward-flying-stars'),
      child: Stack(
        children: [
          _RewardFlyStar(
            begin: const Offset(76, 88),
            end: const Offset(130, 18),
            size: 22,
            motion: motion,
          ),
          _RewardFlyStar(
            begin: const Offset(84, 90),
            end: const Offset(20, 44),
            size: 18,
            motion: motion,
          ),
          _RewardFlyStar(
            begin: const Offset(82, 96),
            end: const Offset(142, 120),
            size: 16,
            motion: motion,
          ),
        ],
      ),
    );
  }
}

class _RewardFlyStar extends StatelessWidget {
  const _RewardFlyStar({
    required this.begin,
    required this.end,
    required this.size,
    required this.motion,
  });

  final Offset begin;
  final Offset end;
  final double size;
  final bool motion;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: motion ? 1 : 0),
        duration: motion ? const Duration(milliseconds: 780) : Duration.zero,
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          final position = Offset.lerp(begin, end, value)!;
          return Transform.translate(
            offset: position,
            child: Align(
              alignment: Alignment.topLeft,
              child: Opacity(
                opacity:
                    motion ? (1 - (value - 0.72).clamp(0.0, 0.28) / 0.28) : 1,
                child: Transform.scale(
                  scale: motion ? 0.7 + value * 0.55 : 1,
                  child: child,
                ),
              ),
            ),
          );
        },
        child: Icon(
          Icons.star_rounded,
          color: const Color(0xFFFFC739).withValues(alpha: 0.92),
          size: size,
        ),
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

class _LessonReviewCard extends StatelessWidget {
  const _LessonReviewCard({
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
  });

  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final perfectRun = usedHints == 0 && wrongAttempts == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FAF8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC7F1EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF18B7AE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.lessonReviewTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF164C55),
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      perfectRun
                          ? l10n.lessonReviewPerfectBody
                          : l10n.lessonReviewSupportBody,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF426A70),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ReviewMetric(
                  value: '$totalQuestions',
                  label: l10n.lessonReviewQuestionsLabel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ReviewMetric(
                  value: '$usedHints',
                  label: l10n.lessonReviewHintsLabel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ReviewMetric(
                  value: '$wrongAttempts',
                  label: l10n.lessonReviewMistakesLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewMetric extends StatelessWidget {
  const _ReviewMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF164C55),
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF426A70),
                  fontWeight: FontWeight.w800,
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
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
      ),
    );
  }
}

class _PolishMarker extends StatelessWidget {
  const _PolishMarker();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(
      key: ValueKey('lesson-polish-marker'),
    );
  }
}

class _RewardPolishMarker extends StatelessWidget {
  const _RewardPolishMarker();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(
      key: ValueKey('reward-polish-marker'),
    );
  }
}

Color _themeColor(int value) => Color(value);

List<Color> _themeColors(List<int> values) {
  return [for (final value in values) Color(value)];
}

bool _motionEnabled(BuildContext context) {
  final media = MediaQuery.maybeOf(context);
  return media == null || !media.disableAnimations;
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
