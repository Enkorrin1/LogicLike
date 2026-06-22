import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../domain/puzzle_answer_rules.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../l10n/localized_content.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';
import '../rewards/collection_screen.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({
    required this.profile,
    required this.onChallengeComplete,
    required this.onPracticeComplete,
    this.initialAreaId,
    this.onInitialAreaHandled,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function(DailyChallenge challenge) onChallengeComplete;
  final Future<void> Function(DailyChallenge challenge) onPracticeComplete;
  final String? initialAreaId;
  final VoidCallback? onInitialAreaHandled;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  String? _handledInitialAreaId;
  final _brainGymKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final daily = dailyChallengesForAge(widget.profile.childAge);
    final areas = puzzleAreasForAge(widget.profile.childAge);
    final completedToday = widget.profile.completedOn(DateTime.now());
    final completedDailyIds = _completedDailyIdsForToday(widget.profile);
    final completedPracticeIds =
        widget.profile.completedPracticePuzzleIds.toSet();
    _openInitialAreaIfNeeded(
      context,
      areas,
      completedToday,
      completedPracticeIds,
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.challengeTitle)),
      body: PlayfulBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            _DailyQuestPanel(
              completedToday: completedToday,
              completedDailyIds: completedDailyIds,
              daily: daily,
              onStart: (puzzle, index) => _openPuzzle(
                context,
                puzzles: daily,
                index: index,
                mode: _PuzzleMode.daily,
                completedToday: completedToday,
              ),
            ),
            const SizedBox(height: 18),
            KeyedSubtree(
              key: _brainGymKey,
              child: _BrainGymHeader(areasCount: areas.length),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: areas.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final area = areas[index];
                final completedInArea = area.puzzles
                    .where((puzzle) => completedPracticeIds.contains(puzzle.id))
                    .length;
                return _BrainAreaCard(
                  area: area,
                  color: _areaColor(index),
                  completedCount: completedInArea,
                  onTap: () {
                    _openArea(
                      context,
                      area,
                      index,
                      completedToday,
                      completedPracticeIds,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openInitialAreaIfNeeded(
    BuildContext context,
    List<BrainArea> areas,
    bool completedToday,
    Set<String> completedPracticeIds,
  ) {
    final initialAreaId = widget.initialAreaId;
    if (initialAreaId == null) {
      _handledInitialAreaId = null;
      return;
    }

    if (_handledInitialAreaId == initialAreaId) {
      return;
    }

    _handledInitialAreaId = initialAreaId;
    final areaIndex = areas.indexWhere((area) => area.id == initialAreaId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (areaIndex >= 0) {
        _openArea(
          context,
          areas[areaIndex],
          areaIndex,
          completedToday,
          completedPracticeIds,
        );
      }
      widget.onInitialAreaHandled?.call();
    });
  }

  void _openArea(
    BuildContext context,
    BrainArea area,
    int areaIndex,
    bool completedToday,
    Set<String> completedPracticeIds,
  ) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => _PuzzleAreaScreen(
          area: area,
          areaIndex: areaIndex,
          completedPracticeIds: completedPracticeIds,
          onStart: (
            areaContext,
            puzzle,
            puzzleIndex,
            onPracticeSolved,
          ) =>
              _openPuzzle(
            areaContext,
            puzzles: area.puzzles,
            index: puzzleIndex,
            mode: _PuzzleMode.practice,
            completedToday: completedToday,
            onPracticeSolved: onPracticeSolved,
          ),
        ),
      ),
    );
  }

  void _openPuzzle(
    BuildContext context, {
    required List<DailyChallenge> puzzles,
    required int index,
    required _PuzzleMode mode,
    required bool completedToday,
    ValueChanged<DailyChallenge>? onPracticeSolved,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => _buildPuzzlePlayScreen(
          puzzles: puzzles,
          index: index,
          mode: mode,
          completedToday: completedToday,
          onPracticeSolved: onPracticeSolved,
        ),
      ),
    );
  }

  Widget _buildPuzzlePlayScreen({
    required List<DailyChallenge> puzzles,
    required int index,
    required _PuzzleMode mode,
    required bool completedToday,
    ValueChanged<DailyChallenge>? onPracticeSolved,
  }) {
    final puzzle = puzzles[index];
    final nextIndex = index + 1;

    return _PuzzlePlayScreen(
      puzzle: puzzle,
      number: index + 1,
      total: puzzles.length,
      mode: mode,
      completedToday: completedToday,
      onDailyRewardContinue: _focusFreeTraining,
      nextPuzzleBuilder: mode == _PuzzleMode.daily && nextIndex < puzzles.length
          ? () => _buildPuzzlePlayScreen(
                puzzles: puzzles,
                index: nextIndex,
                mode: mode,
                completedToday: completedToday,
                onPracticeSolved: onPracticeSolved,
              )
          : null,
      onPracticeSolved: onPracticeSolved,
      onComplete: () {
        return mode == _PuzzleMode.daily
            ? widget.onChallengeComplete(puzzle)
            : widget.onPracticeComplete(puzzle);
      },
    );
  }

  void _focusFreeTraining() {
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) {
        return;
      }

      final targetContext = _brainGymKey.currentContext;
      if (targetContext == null || !targetContext.mounted) {
        return;
      }

      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        alignment: 0.06,
      );
    });
  }
}

enum _PuzzleMode { daily, practice }

class _DailyQuestPanel extends StatelessWidget {
  const _DailyQuestPanel({
    required this.completedToday,
    required this.completedDailyIds,
    required this.daily,
    required this.onStart,
  });

  final bool completedToday;
  final Set<String> completedDailyIds;
  final List<DailyChallenge> daily;
  final void Function(DailyChallenge puzzle, int index) onStart;

  @override
  Widget build(BuildContext context) {
    final completedCount =
        daily.where((puzzle) => completedDailyIds.contains(puzzle.id)).length;
    final total = daily.length;
    final progress = total == 0 ? 0.0 : completedCount / total;
    final allCompleted = completedToday || completedCount >= total;

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF1A6),
            Color(0xFFFFB0C7),
            Color(0xFFA8F3E6),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.coral.withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -26,
            top: -30,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 118,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 116,
            child: Icon(
              Icons.star_rounded,
              size: 28,
              color: Colors.white.withValues(alpha: 0.32),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconBadge(
                    icon: allCompleted
                        ? Icons.verified_rounded
                        : Icons.rocket_launch_rounded,
                    color: Colors.white,
                    iconColor:
                        allCompleted ? AppPalette.teal : AppPalette.coral,
                    size: 58,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allCompleted
                              ? context.l10n.challengeDayDone
                              : context.l10n.challengeDailyMission,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          allCompleted
                              ? context.l10n.challengeDayDoneBody
                              : context.l10n.challengeDailyBody,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppPalette.ink,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _DailyRewardBadge(completed: allCompleted, stars: total),
                ],
              ),
              const SizedBox(height: 16),
              _DailyMissionProgress(
                completed: completedCount,
                total: total,
                progress: progress,
              ),
              if (allCompleted && daily.isNotEmpty) ...[
                const SizedBox(height: 14),
                _DailyReplayCard(
                  steps: total,
                  onTap: () => onStart(daily.first, 0),
                ),
              ] else ...[
                const SizedBox(height: 14),
                for (var i = 0; i < daily.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i == daily.length - 1 ? 0 : 10,
                    ),
                    child: _DailyQuestRow(
                      puzzle: daily[i],
                      index: i,
                      completed: completedDailyIds.contains(daily[i].id),
                      onTap: () => onStart(daily[i], i),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyRewardBadge extends StatelessWidget {
  const _DailyRewardBadge({
    required this.completed,
    required this.stars,
  });

  final bool completed;
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 76),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completed ? Icons.card_giftcard_rounded : Icons.star_rounded,
            color: completed ? AppPalette.teal : const Color(0xFFFFC739),
            size: 25,
          ),
          const SizedBox(height: 2),
          Text(
            completed ? context.l10n.challengePrize : '+$stars',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
          ),
        ],
      ),
    );
  }
}

class _DailyMissionProgress extends StatelessWidget {
  const _DailyMissionProgress({
    required this.completed,
    required this.total,
    required this.progress,
  });

  final int completed;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.challengeMissionProgress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                context.l10n.countOfTotal(completed, total),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: progress.clamp(0, 1).toDouble(),
              backgroundColor: Colors.white.withValues(alpha: 0.68),
              valueColor: const AlwaysStoppedAnimation(AppPalette.teal),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < total; i++) ...[
                Expanded(
                  child: _DailyStepDot(index: i, completed: i < completed),
                ),
                if (i != total - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyReplayCard extends StatelessWidget {
  const _DailyReplayCard({
    required this.steps,
    required this.onTap,
  });

  final int steps;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppPalette.mint.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.replay_rounded,
                color: AppPalette.teal,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.challengeRepeatMission,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.l10n.challengeStepsTraining(steps),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: AppPalette.ink,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyStepDot extends StatelessWidget {
  const _DailyStepDot({
    required this.index,
    required this.completed,
  });

  final int index;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 34,
      decoration: BoxDecoration(
        color:
            completed ? AppPalette.teal : Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: completed ? AppPalette.teal : Colors.white,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        completed ? Icons.check_rounded : _dailyIcon(index),
        color: completed ? Colors.white : _areaColor(index),
        size: completed ? 20 : 19,
      ),
    );
  }
}

class _DailyQuestRow extends StatelessWidget {
  const _DailyQuestRow({
    required this.puzzle,
    required this.index,
    required this.completed,
    required this.onTap,
  });

  final DailyChallenge puzzle;
  final int index;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _areaColor(index);

    return BouncyTap(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Material(
        color: Colors.white.withValues(alpha: completed ? 0.88 : 0.78),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: completed
                      ? AppPalette.mint.withValues(alpha: 0.84)
                      : accent.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Icon(
                  completed ? Icons.check_circle_rounded : _dailyIcon(index),
                  color: completed ? AppPalette.teal : accent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.challengeStepNumber(index + 1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.puzzleTitle(puzzle),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      context.l10n.puzzleSkill(puzzle),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: completed
                      ? AppPalette.mint.withValues(alpha: 0.75)
                      : AppPalette.surfaceBlue,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      completed
                          ? Icons.replay_rounded
                          : Icons.play_arrow_rounded,
                      size: 17,
                      color: AppPalette.ink,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      completed
                          ? context.l10n.challengeAgain
                          : context.l10n.minutesShort(puzzle.minutes),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppPalette.ink,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrainGymHeader extends StatelessWidget {
  const _BrainGymHeader({required this.areasCount});

  final int areasCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconBadge(
          icon: Icons.psychology_alt_rounded,
          color: Color(0xFFEDEAFF),
          iconColor: AppPalette.lavender,
          size: 46,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.challengeBrainGymTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                context.l10n.challengeBrainGymSubtitle(areasCount),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BrainAreaCard extends StatelessWidget {
  const _BrainAreaCard({
    required this.area,
    required this.color,
    required this.completedCount,
    required this.onTap,
  });

  final BrainArea area;
  final Color color;
  final int completedCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = area.puzzles.length;
    final progress = total == 0 ? 0.0 : completedCount / total;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.96),
                color.withValues(alpha: 0.62)
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -2,
                right: -2,
                child: AreaCharacterBadge(
                  areaId: area.id,
                  color: Colors.white.withValues(alpha: 0.86),
                  size: 94,
                  padding: 0,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color.withValues(alpha: 0.00),
                        color.withValues(alpha: 0.30),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.areaTitle(area.id),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          context.l10n.areaSubtitle(area.id),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    height: 1.12,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.flag_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                context.l10n.challengeAreaLevels(
                                  completedCount,
                                  total,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            value: progress.clamp(0, 1).toDouble(),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.42),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
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

class _PuzzleAreaScreen extends StatefulWidget {
  const _PuzzleAreaScreen({
    required this.area,
    required this.areaIndex,
    required this.completedPracticeIds,
    required this.onStart,
  });

  final BrainArea area;
  final int areaIndex;
  final Set<String> completedPracticeIds;
  final void Function(
    BuildContext context,
    DailyChallenge puzzle,
    int index,
    ValueChanged<DailyChallenge> onPracticeSolved,
  ) onStart;

  @override
  State<_PuzzleAreaScreen> createState() => _PuzzleAreaScreenState();
}

class _PuzzleAreaScreenState extends State<_PuzzleAreaScreen> {
  late Set<String> _completedPracticeIds;

  @override
  void initState() {
    super.initState();
    _completedPracticeIds = {...widget.completedPracticeIds};
  }

  void _markSolved(DailyChallenge puzzle) {
    if (_completedPracticeIds.contains(puzzle.id)) {
      return;
    }

    setState(() {
      _completedPracticeIds = {..._completedPracticeIds, puzzle.id};
    });
  }

  @override
  Widget build(BuildContext context) {
    final area = widget.area;
    final color = _areaColor(widget.areaIndex);
    final completedCount = area.puzzles
        .where((puzzle) => _completedPracticeIds.contains(puzzle.id))
        .length;
    final nextIndex = area.puzzles.indexWhere(
      (puzzle) => !_completedPracticeIds.contains(puzzle.id),
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.areaTitle(area.id))),
      body: PlayfulBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          itemCount: area.puzzles.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _AreaHero(
                area: area,
                color: color,
                completedCount: completedCount,
              );
            }

            final puzzleIndex = index - 1;
            final puzzle = area.puzzles[puzzleIndex];
            final completed = _completedPracticeIds.contains(puzzle.id);
            final current = nextIndex == -1
                ? puzzleIndex == area.puzzles.length - 1
                : puzzleIndex == nextIndex;
            return _FreePuzzleCard(
              puzzle: puzzle,
              levelNumber: puzzleIndex + 1,
              color: color,
              completed: completed,
              current: current,
              onTap: () =>
                  widget.onStart(context, puzzle, puzzleIndex, _markSolved),
            );
          },
        ),
      ),
    );
  }
}

class _AreaHero extends StatelessWidget {
  const _AreaHero({
    required this.area,
    required this.color,
    required this.completedCount,
  });

  final BrainArea area;
  final Color color;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final total = area.puzzles.length;
    final progress = total == 0 ? 0.0 : completedCount / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.62)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Row(
        children: [
          AreaCharacterBadge(
            areaId: area.id,
            color: Colors.white.withValues(alpha: 0.9),
            size: 96,
            padding: 0,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.areaTitle(area.id),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.areaSubtitle(area.id),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.30),
                        ),
                      ),
                      child: Text(
                        context.l10n.challengeAreaCompleted(
                          completedCount,
                          total,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress.clamp(0, 1).toDouble(),
                    backgroundColor: Colors.white.withValues(alpha: 0.28),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
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

class _FreePuzzleCard extends StatelessWidget {
  const _FreePuzzleCard({
    required this.puzzle,
    required this.levelNumber,
    required this.color,
    required this.completed,
    required this.current,
    required this.onTap,
  });

  final DailyChallenge puzzle;
  final int levelNumber;
  final Color color;
  final bool completed;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stateColor = completed
        ? AppPalette.teal
        : current
            ? color
            : AppPalette.muted;
    final stateLabel = completed
        ? context.l10n.challengeStateCompleted
        : current
            ? context.l10n.challengeStateNext
            : context.l10n.challengeStatePlay;
    final stateIcon = completed
        ? Icons.check_circle_rounded
        : current
            ? Icons.play_circle_fill_rounded
            : Icons.arrow_forward_rounded;
    final actionIcon = completed
        ? Icons.check_rounded
        : current
            ? Icons.play_arrow_rounded
            : Icons.arrow_forward_rounded;

    return BouncyTap(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: PlayfulCard(
        color: completed
            ? AppPalette.mint.withValues(alpha: 0.46)
            : current
                ? Colors.white
                : Colors.white.withValues(alpha: 0.88),
        borderColor: completed
            ? AppPalette.teal.withValues(alpha: 0.38)
            : current
                ? color.withValues(alpha: 0.50)
                : AppPalette.border,
        child: Row(
          children: [
            AreaCharacterBadge(
              areaId: puzzle.areaId,
              color: completed
                  ? Colors.white.withValues(alpha: 0.88)
                  : color.withValues(alpha: current ? 0.24 : 0.16),
              size: 58,
              padding: 3,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.challengeLevelNumber(levelNumber),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: stateColor.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: stateColor.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(stateIcon, color: stateColor, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              stateLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: stateColor,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.puzzleTitle(puzzle),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.puzzlePrompt(puzzle),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: completed || current ? null : AppPalette.surfaceBlue,
                gradient: completed || current
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: completed
                            ? const [
                                AppPalette.teal,
                                Color(0xFF5EDBC9),
                              ]
                            : [
                                color,
                                color.withValues(alpha: 0.72),
                              ],
                      )
                    : null,
                shape: BoxShape.circle,
                border: completed || current
                    ? null
                    : Border.all(color: AppPalette.border),
                boxShadow: [
                  BoxShadow(
                    color: stateColor.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Icon(
                actionIcon,
                color: completed || current ? Colors.white : AppPalette.ink,
                size: 27,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuzzlePlayScreen extends StatefulWidget {
  const _PuzzlePlayScreen({
    required this.puzzle,
    required this.number,
    required this.total,
    required this.mode,
    required this.completedToday,
    required this.onDailyRewardContinue,
    required this.onComplete,
    this.onPracticeSolved,
    this.nextPuzzleBuilder,
  });

  final DailyChallenge puzzle;
  final int number;
  final int total;
  final _PuzzleMode mode;
  final bool completedToday;
  final VoidCallback onDailyRewardContinue;
  final Future<void> Function() onComplete;
  final ValueChanged<DailyChallenge>? onPracticeSolved;
  final Widget Function()? nextPuzzleBuilder;

  @override
  State<_PuzzlePlayScreen> createState() => _PuzzlePlayScreenState();
}

class _PuzzlePlayScreenState extends State<_PuzzlePlayScreen> {
  String? _selectedAnswer;
  _AnswerCheckState _answerState = _AnswerCheckState.idle;
  bool _showHint = false;
  bool _isSubmitting = false;
  bool _showSuccessBurst = false;

  void _selectAnswer(String answer) {
    if (_isSubmitting) {
      return;
    }

    Feedback.forTap(context);
    setState(() {
      _selectedAnswer = answer;
      _answerState = _AnswerCheckState.idle;
    });
  }

  Future<void> _submit() async {
    if (_selectedAnswer == null || _isSubmitting) {
      return;
    }

    if (!isCorrectAnswerForPuzzle(widget.puzzle, _selectedAnswer!)) {
      Feedback.forLongPress(context);
      setState(() {
        _answerState = _AnswerCheckState.wrong;
        _showHint = true;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _answerState = _AnswerCheckState.correct;
    });
    await widget.onComplete();
    if (widget.mode == _PuzzleMode.practice) {
      widget.onPracticeSolved?.call(widget.puzzle);
    }

    if (!mounted) {
      return;
    }

    setState(() => _showSuccessBurst = true);

    await Future<void>.delayed(const Duration(milliseconds: 850));

    if (!mounted) {
      return;
    }

    if (widget.mode == _PuzzleMode.practice) {
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    final nextPuzzleBuilder = widget.nextPuzzleBuilder;
    if (nextPuzzleBuilder == null) {
      if (widget.mode == _PuzzleMode.daily) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => _DailyMissionCompleteScreen(
              stars: widget.total,
              completedSteps: widget.total,
              onStartTraining: widget.onDailyRewardContinue,
            ),
          ),
        );
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => nextPuzzleBuilder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDaily = widget.mode == _PuzzleMode.daily;
    final accent = _areaAccentForId(widget.puzzle.areaId);
    final answerRule = answerRuleForPuzzle(widget.puzzle);
    final l10n = context.l10n;
    final answerOptions = _answerOptionsFor(answerRule, l10n);
    final correctAnswer = answerRule.correctAnswer;
    final compact = MediaQuery.sizeOf(context).height < 700;
    final canSubmit =
        _selectedAnswer != null && _answerState != _AnswerCheckState.wrong;
    final hintButton = OutlinedButton.icon(
      onPressed: () => setState(() => _showHint = !_showHint),
      icon: Icon(
        _showHint
            ? Icons.visibility_off_rounded
            : Icons.tips_and_updates_rounded,
      ),
      label: Text(_showHint ? l10n.challengeHideHint : l10n.challengeShowHint),
      style: compact
          ? OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              minimumSize: const Size(0, 38),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
          : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isDaily
              ? l10n.challengeDailyTaskTitle
              : l10n.challengePuzzleTaskTitle,
        ),
      ),
      body: Stack(
        children: [
          PlayfulBackground(
            child: ListView(
              padding: EdgeInsets.fromLTRB(18, compact ? 6 : 8, 18, 96),
              children: [
                _ProgressHeader(
                  current: widget.number,
                  total: widget.total,
                  label: isDaily
                      ? l10n.challengeDailyPath
                      : l10n.challengeFreePlay,
                  compact: compact,
                ),
                SizedBox(height: compact ? 10 : 16),
                PlayfulCard(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 14 : 16,
                    compact ? 12 : 14,
                    compact ? 14 : 16,
                    compact ? 8 : 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TaskIntro(
                        puzzle: widget.puzzle,
                        accent: accent,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 9 : 12),
                      _PuzzleStage(
                        puzzle: widget.puzzle,
                        accent: accent,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 8 : 12),
                      _QuestionBubble(
                        prompt: l10n.puzzlePrompt(widget.puzzle),
                        accent: accent,
                        compact: compact,
                      ),
                      SizedBox(height: compact ? 8 : 10),
                      if (compact)
                        Row(
                          children: [
                            for (var i = 0; i < answerOptions.length; i++) ...[
                              Expanded(
                                child: _AnswerOption(
                                  option: answerOptions[i],
                                  selected: _selectedAnswer ==
                                      answerOptions[i].answer,
                                  state: _stateForOption(
                                    answerOptions[i].answer,
                                    correctAnswer,
                                  ),
                                  compact: true,
                                  stacked: true,
                                  onTap: () =>
                                      _selectAnswer(answerOptions[i].answer),
                                ),
                              ),
                              if (i != answerOptions.length - 1)
                                const SizedBox(width: 7),
                            ],
                          ],
                        )
                      else
                        for (final option in answerOptions)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: _AnswerOption(
                              option: option,
                              selected: _selectedAnswer == option.answer,
                              state:
                                  _stateForOption(option.answer, correctAnswer),
                              compact: false,
                              stacked: false,
                              onTap: () => _selectAnswer(option.answer),
                            ),
                          ),
                      if (_answerState != _AnswerCheckState.idle) ...[
                        SizedBox(height: compact ? 6 : 8),
                        _AnswerFeedbackPanel(
                          state: _answerState,
                          retryText: l10n.retryTextForPuzzle(
                            widget.puzzle,
                            answerRule.retryText,
                          ),
                          compact: compact,
                        ),
                      ],
                      SizedBox(height: compact ? 4 : 0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: hintButton,
                      ),
                      if (_showHint) ...[
                        SizedBox(height: compact ? 6 : 10),
                        _HintBox(
                          areaId: widget.puzzle.areaId,
                          compact: compact,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_showSuccessBurst)
            Positioned.fill(
              child: IgnorePointer(
                child: _SuccessBurst(
                  accent: accent,
                  hasNextPuzzle: widget.nextPuzzleBuilder != null,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _StickyAnswerBar(
        enabled: canSubmit,
        loading: _isSubmitting,
        selectedAnswerLabel:
            _selectedAnswer == null ? null : l10n.answerLabel(_selectedAnswer!),
        answerState: _answerState,
        compact: compact,
        onSubmit: _submit,
      ),
    );
  }

  _AnswerCheckState _stateForOption(String label, String correctAnswer) {
    if (_answerState == _AnswerCheckState.correct && label == correctAnswer) {
      return _AnswerCheckState.correct;
    }

    if (_answerState == _AnswerCheckState.wrong && label == _selectedAnswer) {
      return _AnswerCheckState.wrong;
    }

    return _AnswerCheckState.idle;
  }
}

enum _AnswerCheckState { idle, wrong, correct }

class _SuccessBurst extends StatelessWidget {
  const _SuccessBurst({
    required this.accent,
    required this.hasNextPuzzle,
  });

  final Color accent;
  final bool hasNextPuzzle;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final fade = value < 0.88 ? 1.0 : (1 - value) / 0.12;

        return Opacity(
          opacity: fade.clamp(0, 1),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              _BurstStar(
                progress: value,
                alignment: const Alignment(-0.66, -0.38),
                color: AppPalette.mango,
                size: 34,
              ),
              _BurstStar(
                progress: value,
                alignment: const Alignment(0.62, -0.30),
                color: AppPalette.coral,
                size: 26,
              ),
              _BurstStar(
                progress: value,
                alignment: const Alignment(-0.38, 0.18),
                color: AppPalette.sky,
                size: 24,
              ),
              _BurstStar(
                progress: value,
                alignment: const Alignment(0.48, 0.24),
                color: AppPalette.mango,
                size: 30,
              ),
              Align(
                alignment: const Alignment(0, -0.10),
                child: Transform.scale(
                  scale: 0.72 + value * 0.28,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent,
                          accent.withValues(alpha: 0.72),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.28),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.l10n.challengeExcellent,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          hasNextPuzzle
                              ? context.l10n.challengeFlyNext
                              : context.l10n.challengeAllDone,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 132,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 7,
                              value: value.clamp(0, 1).toDouble(),
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.28),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withValues(alpha: 0.92),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BurstStar extends StatelessWidget {
  const _BurstStar({
    required this.progress,
    required this.alignment,
    required this.color,
    required this.size,
  });

  final double progress;
  final Alignment alignment;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOutBack.transform(progress.clamp(0, 1));

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(0, -18 * eased),
        child: Transform.scale(
          scale: 0.35 + eased * 0.65,
          child: Icon(
            Icons.star_rounded,
            color: color,
            size: size,
          ),
        ),
      ),
    );
  }
}

class _DailyMissionCompleteScreen extends StatelessWidget {
  const _DailyMissionCompleteScreen({
    required this.stars,
    required this.completedSteps,
    required this.onStartTraining,
  });

  final int stars;
  final int completedSteps;
  final VoidCallback onStartTraining;

  void _close(BuildContext context) {
    Feedback.forTap(context);
    Navigator.of(context).pop();
  }

  void _startTraining(BuildContext context) {
    Feedback.forTap(context);
    Navigator.of(context).pop();
    onStartTraining();
  }

  void _openCollection(BuildContext context) {
    Feedback.forTap(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CollectionScreen(
          stars: stars,
          completedLevels: completedSteps,
          highlightDailyPrize: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).height < 720;

    return Scaffold(
      body: PlayfulBackground(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(18, compact ? 8 : 14, 18, 24),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filledTonal(
                  onPressed: () => _close(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              SizedBox(height: compact ? 4 : 10),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 620),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0, 1),
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 18),
                      child: Transform.scale(
                        scale: 0.94 + value * 0.06,
                        child: child,
                      ),
                    ),
                  );
                },
                child: _DailyRewardHero(
                  stars: stars,
                  completedSteps: completedSteps,
                  compact: compact,
                ),
              ),
              SizedBox(height: compact ? 14 : 18),
              _RewardNextStepCard(compact: compact),
              SizedBox(height: compact ? 14 : 18),
              SoftShine(
                borderRadius: BorderRadius.circular(22),
                duration: const Duration(milliseconds: 1900),
                child: FilledButton.icon(
                  onPressed: () => _startTraining(context),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(context.l10n.challengePlayMore),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _openCollection(context),
                icon: const Icon(Icons.auto_awesome_rounded),
                label: Text(context.l10n.challengeMyCollection),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyRewardHero extends StatelessWidget {
  const _DailyRewardHero({
    required this.stars,
    required this.completedSteps,
    required this.compact,
  });

  final int stars;
  final int completedSteps;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.fromLTRB(20, compact ? 18 : 22, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF0A8),
            Color(0xFFFFB6C8),
            Color(0xFFA9F4E8),
          ],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.coral.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -18,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white.withValues(alpha: 0.36),
              size: 116,
            ),
          ),
          Positioned(
            bottom: 70,
            left: -8,
            child: Icon(
              Icons.star_rounded,
              color: Colors.white.withValues(alpha: 0.42),
              size: 44,
            ),
          ),
          Column(
            children: [
              Container(
                width: compact ? 118 : 136,
                height: compact ? 118 : 136,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.teal.withValues(alpha: 0.20),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar_lion.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: compact ? 14 : 18),
              Text(
                context.l10n.challengeDailyCompleteTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF075D5A),
                      fontWeight: FontWeight.w900,
                      height: 1.04,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.challengeDailyCompleteBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              SizedBox(height: compact ? 14 : 18),
              Row(
                children: [
                  Expanded(
                    child: _RewardMetric(
                      icon: Icons.star_rounded,
                      value: '+$stars',
                      label: context.l10n.challengeRewardStars,
                      color: AppPalette.mango,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _RewardMetric(
                      icon: Icons.local_fire_department_rounded,
                      value: '+1',
                      label: context.l10n.challengeRewardStreak,
                      color: AppPalette.coral,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _RewardMetric(
                      icon: Icons.card_giftcard_rounded,
                      value: '$completedSteps',
                      label: context.l10n.challengeRewardSteps,
                      color: AppPalette.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RewardMetric extends StatelessWidget {
  const _RewardMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _RewardNextStepCard extends StatelessWidget {
  const _RewardNextStepCard({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: EdgeInsets.all(compact ? 14 : 16),
      borderColor: AppPalette.mint.withValues(alpha: 0.72),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE9FFF8),
          Color(0xFFF7FBFF),
        ],
      ),
      child: Row(
        children: [
          AreaCharacterBadge(
            areaId: 'memory',
            color: AppPalette.mint.withValues(alpha: 0.42),
            size: compact ? 58 : 66,
            padding: 2,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.challengeWhatNextTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.challengeWhatNextBody,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.current,
    required this.total,
    required this.label,
    required this.compact,
  });

  final int current;
  final int total;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding:
          EdgeInsets.fromLTRB(16, compact ? 10 : 12, 16, compact ? 10 : 12),
      borderColor: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                SizedBox(height: compact ? 2 : 3),
                Text(
                  context.l10n.challengeProgressStep(current, total),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: compact ? 6 : 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: (current / total).clamp(0, 1).toDouble(),
                    minHeight: compact ? 10 : 12,
                    backgroundColor: AppPalette.mint.withValues(alpha: 0.42),
                    valueColor: const AlwaysStoppedAnimation(AppPalette.teal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const InfoPill(
            icon: Icons.favorite_rounded,
            label: '5',
            color: Color(0xFFFFE8F0),
          ),
        ],
      ),
    );
  }
}

class _TaskIntro extends StatelessWidget {
  const _TaskIntro({
    required this.puzzle,
    required this.accent,
    required this.compact,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AreaCharacterBadge(
          areaId: puzzle.areaId,
          color: accent.withValues(alpha: 0.18),
          size: compact ? 48 : 58,
          padding: 1,
        ),
        SizedBox(width: compact ? 10 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.puzzleTitle(puzzle),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: compact
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: compact ? 2 : 4),
              Text(
                context.l10n.puzzleSkill(puzzle),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PuzzleStage extends StatelessWidget {
  const _PuzzleStage({
    required this.puzzle,
    required this.accent,
    required this.compact,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final stage = switch (puzzle.areaId) {
      'memory' => _MemoryStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
        ),
      'attention' => _AttentionStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
        ),
      'math' => _MathStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
        ),
      'space' => _PathStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
        ),
      _ => _PatternStrip(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
        ),
    };

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: Transform.scale(
              scale: 0.96 + value * 0.04,
              child: child,
            ),
          ),
        );
      },
      child: stage,
    );
  }
}

class _StageShell extends StatelessWidget {
  const _StageShell({
    required this.accent,
    required this.child,
    required this.compact,
  });

  final Color accent;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24);

    return SoftShine(
      borderRadius: radius,
      duration: const Duration(milliseconds: 2600),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: compact ? 82 : 108),
        padding: EdgeInsets.all(compact ? 8 : 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.18),
              Colors.white,
              AppPalette.surfaceBlue.withValues(alpha: 0.70),
            ],
          ),
          borderRadius: radius,
          border: Border.all(color: accent.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _MemoryStage extends StatelessWidget {
  const _MemoryStage({
    required this.puzzle,
    required this.accent,
    required this.compact,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (puzzle.id == 'camp-story') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _CampStoryStage(accent: accent, compact: compact),
      );
    }

    if (puzzle.id == 'story-order') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _StoryOrderStage(accent: accent, compact: compact),
      );
    }

    final cardSize = compact ? 38.0 : 44.0;
    final spec = _memoryStageSpecFor(puzzle.id, accent);

    return _StageShell(
      accent: accent,
      compact: compact,
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: compact ? 6 : 8,
              runSpacing: compact ? 6 : 8,
              alignment: WrapAlignment.center,
              children: [
                for (final card in spec.cards)
                  _MemoryPreviewCard(
                    label: card.label,
                    icon: card.icon,
                    color: card.color,
                    size: cardSize,
                    covered: card.covered,
                  ),
              ],
            ),
          ),
          SizedBox(width: compact ? 8 : 12),
          _StageToken(
            icon: spec.answerIcon,
            color: spec.answerColor,
            size: compact ? 50 : 58,
            highlighted: true,
          ),
        ],
      ),
    );
  }
}

class _StoryOrderStage extends StatefulWidget {
  const _StoryOrderStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_StoryOrderStage> createState() => _StoryOrderStageState();
}

class _StoryOrderStageState extends State<_StoryOrderStage> {
  List<String> _frames = const ['rocket', 'map', 'star'];

  bool get _solved =>
      _frames[0] == 'map' && _frames[1] == 'rocket' && _frames[2] == 'star';

  void _moveFrame(int index) {
    setState(() {
      final next = [..._frames];
      final item = next.removeAt(index);
      next.insert(index == 0 ? next.length : index - 1, item);
      _frames = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.compact ? 72.0 : 82.0;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 108 : 126,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF3D9), Color(0xFFE8F8FF)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 38,
                right: 38,
                top: widget.compact ? 45 : 54,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 8,
                  decoration: BoxDecoration(
                    color: (_solved ? AppPalette.mint : widget.accent)
                        .withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var index = 0; index < _frames.length; index++)
                    _StoryFrameCard(
                      frame: _frames[index],
                      index: index,
                      width: cardWidth,
                      accent: widget.accent,
                      solved: _solved,
                      onTap: () => _moveFrame(index),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryFrameCard extends StatelessWidget {
  const _StoryFrameCard({
    required this.frame,
    required this.index,
    required this.width,
    required this.accent,
    required this.solved,
    required this.onTap,
  });

  final String frame;
  final int index;
  final double width;
  final Color accent;
  final bool solved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _storyFrameColor(frame, accent);

    return BouncyTap(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        height: width * 1.08,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: solved ? AppPalette.mint : color.withValues(alpha: 0.38),
            width: solved ? 3 : 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: solved ? 0.26 : 0.14),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: 8,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: width * 0.58,
                  height: width * 0.58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withValues(alpha: 0.20),
                        color.withValues(alpha: 0.07),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(_storyFrameIcon(frame), color: color, size: 34),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: solved ? AppPalette.mint : accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _storyFrameIcon(String frame) {
  return switch (frame) {
    'map' => Icons.map_rounded,
    'rocket' => Icons.rocket_launch_rounded,
    'star' => Icons.star_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}

Color _storyFrameColor(String frame, Color accent) {
  return switch (frame) {
    'map' => AppPalette.teal,
    'rocket' => AppPalette.coral,
    'star' => AppPalette.mango,
    _ => accent,
  };
}

class _MemoryStageSpec {
  const _MemoryStageSpec({
    required this.cards,
    required this.answerColor,
    this.answerIcon,
  });

  final List<_MemoryCardSpec> cards;
  final IconData? answerIcon;
  final Color answerColor;
}

class _MemoryCardSpec {
  const _MemoryCardSpec({
    required this.label,
    required this.icon,
    required this.color,
    this.covered = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool covered;
}

_MemoryStageSpec _memoryStageSpecFor(String puzzleId, Color accent) {
  return switch (puzzleId) {
    'sound-order' => const _MemoryStageSpec(
        cards: [
          _MemoryCardSpec(
            label: '1',
            icon: Icons.music_note_rounded,
            color: AppPalette.sky,
          ),
          _MemoryCardSpec(
            label: '2',
            icon: Icons.graphic_eq_rounded,
            color: AppPalette.mango,
          ),
          _MemoryCardSpec(
            label: '3',
            icon: Icons.music_note_rounded,
            color: AppPalette.sky,
          ),
        ],
        answerIcon: Icons.replay_rounded,
        answerColor: AppPalette.lavender,
      ),
    'route-memory' => const _MemoryStageSpec(
        cards: [
          _MemoryCardSpec(
            label: '1',
            icon: Icons.arrow_upward_rounded,
            color: AppPalette.sky,
          ),
          _MemoryCardSpec(
            label: '2',
            icon: Icons.arrow_forward_rounded,
            color: AppPalette.teal,
          ),
          _MemoryCardSpec(
            label: '3',
            icon: Icons.arrow_downward_rounded,
            color: AppPalette.lavender,
          ),
          _MemoryCardSpec(
            label: '4',
            icon: Icons.visibility_off_rounded,
            color: AppPalette.mango,
            covered: true,
          ),
        ],
        answerIcon: Icons.arrow_forward_rounded,
        answerColor: AppPalette.teal,
      ),
    'hidden-cards' => const _MemoryStageSpec(
        cards: [
          _MemoryCardSpec(
            label: 'A',
            icon: Icons.rocket_launch_rounded,
            color: AppPalette.coral,
          ),
          _MemoryCardSpec(
            label: 'B',
            icon: Icons.public_rounded,
            color: AppPalette.teal,
            covered: true,
          ),
          _MemoryCardSpec(
            label: 'C',
            icon: Icons.star_rounded,
            color: AppPalette.mango,
          ),
        ],
        answerIcon: Icons.public_rounded,
        answerColor: AppPalette.teal,
      ),
    'color-rhythm' => const _MemoryStageSpec(
        cards: [
          _MemoryCardSpec(
            label: '1',
            icon: Icons.circle_rounded,
            color: AppPalette.coral,
          ),
          _MemoryCardSpec(
            label: '2',
            icon: Icons.circle_rounded,
            color: AppPalette.sky,
          ),
          _MemoryCardSpec(
            label: '3',
            icon: Icons.circle_rounded,
            color: AppPalette.mango,
          ),
          _MemoryCardSpec(
            label: '4',
            icon: Icons.circle_rounded,
            color: AppPalette.coral,
          ),
        ],
        answerIcon: Icons.circle_rounded,
        answerColor: AppPalette.sky,
      ),
    'what-changed' => const _MemoryStageSpec(
        cards: [
          _MemoryCardSpec(
            label: 'A',
            icon: Icons.image_rounded,
            color: AppPalette.sky,
          ),
          _MemoryCardSpec(
            label: '→',
            icon: Icons.swap_horiz_rounded,
            color: AppPalette.lavender,
          ),
          _MemoryCardSpec(
            label: 'B',
            icon: Icons.place_rounded,
            color: AppPalette.teal,
          ),
        ],
        answerIcon: Icons.place_rounded,
        answerColor: AppPalette.teal,
      ),
    'star-list' => const _MemoryStageSpec(
        cards: [
          _MemoryCardSpec(
            label: '1',
            icon: Icons.star_rounded,
            color: AppPalette.mango,
          ),
          _MemoryCardSpec(
            label: '2',
            icon: Icons.nightlight_round,
            color: AppPalette.lavender,
          ),
          _MemoryCardSpec(
            label: '3',
            icon: Icons.rocket_launch_rounded,
            color: AppPalette.coral,
          ),
        ],
        answerIcon: Icons.star_rounded,
        answerColor: AppPalette.mango,
      ),
    'captain-command' => const _MemoryStageSpec(
        cards: [
          _MemoryCardSpec(
            label: '1',
            icon: Icons.directions_run_rounded,
            color: AppPalette.sky,
          ),
          _MemoryCardSpec(
            label: '2',
            icon: Icons.turn_right_rounded,
            color: AppPalette.teal,
          ),
          _MemoryCardSpec(
            label: '3',
            icon: Icons.pan_tool_alt_rounded,
            color: AppPalette.coral,
          ),
        ],
        answerIcon: Icons.turn_right_rounded,
        answerColor: AppPalette.teal,
      ),
    _ => _MemoryStageSpec(
        cards: const [
          _MemoryCardSpec(
            label: '1',
            icon: Icons.star_rounded,
            color: AppPalette.mango,
          ),
          _MemoryCardSpec(
            label: '2',
            icon: Icons.favorite_rounded,
            color: AppPalette.coral,
          ),
          _MemoryCardSpec(
            label: '3',
            icon: Icons.visibility_off_rounded,
            color: AppPalette.lavender,
            covered: true,
          ),
          _MemoryCardSpec(
            label: '4',
            icon: Icons.cloud_rounded,
            color: AppPalette.sky,
          ),
        ],
        answerIcon: Icons.favorite_rounded,
        answerColor: accent,
      ),
  };
}

class _MemoryPreviewCard extends StatelessWidget {
  const _MemoryPreviewCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.size,
    this.covered = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final double size;
  final bool covered;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: covered
              ? [
                  AppPalette.ink.withValues(alpha: 0.12),
                  AppPalette.lavender.withValues(alpha: 0.28),
                ]
              : [Colors.white, color.withValues(alpha: 0.72)],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 5,
            top: 4,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppPalette.ink.withValues(alpha: 0.52),
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          Center(
            child: Icon(
              covered ? Icons.lock_rounded : icon,
              color: covered ? AppPalette.muted : color,
              size: size * 0.46,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttentionStage extends StatelessWidget {
  const _AttentionStage({
    required this.puzzle,
    required this.accent,
    required this.compact,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final customStage = switch (puzzle.id) {
      'word-grid' => _WordGridStage(accent: accent, compact: compact),
      'animal-word' => _AnimalWordStage(accent: accent, compact: compact),
      'balloon-order' => _BalloonOrderStage(accent: accent, compact: compact),
      'word-builder' => _WordBuilderStage(accent: accent, compact: compact),
      'letter-field' => _LetterFieldStage(accent: accent, compact: compact),
      'camp-differences' =>
        _CampDifferencesStage(accent: accent, compact: compact),
      _ => null,
    };

    if (customStage != null) {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: customStage,
      );
    }

    final items = _attentionStageItemsFor(puzzle.id, accent, compact);

    return _StageShell(
      accent: accent,
      compact: compact,
      child: Row(
        children: [
          _StageToken(
            icon: Icons.search_rounded,
            color: accent,
            size: compact ? 44 : 54,
            highlighted: true,
          ),
          SizedBox(width: compact ? 8 : 12),
          Expanded(
            child: Wrap(
              spacing: compact ? 6 : 7,
              runSpacing: compact ? 6 : 7,
              alignment: WrapAlignment.center,
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _attentionStageItemsFor(
  String puzzleId,
  Color accent,
  bool compact,
) {
  return switch (puzzleId) {
    'odd-card' => [
        _SearchChoiceCard(
          label: '1',
          icon: Icons.circle_rounded,
          color: AppPalette.teal,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '2',
          icon: Icons.auto_awesome_rounded,
          color: accent,
          highlighted: true,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '3',
          icon: Icons.circle_rounded,
          color: AppPalette.teal,
          compact: compact,
        ),
      ],
    'tiny-detail' => [
        _SearchChoiceCard(
          label: '↑',
          icon: Icons.auto_awesome_rounded,
          color: AppPalette.mango,
          highlighted: true,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '•',
          icon: Icons.crop_free_rounded,
          color: accent,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '↓',
          icon: Icons.circle_rounded,
          color: AppPalette.sky,
          compact: compact,
        ),
      ],
    'shadow-match' => [
        _SearchChoiceCard(
          label: '★',
          icon: Icons.pets_rounded,
          color: AppPalette.teal,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '1',
          icon: Icons.eco_rounded,
          color: AppPalette.mango,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '2',
          icon: Icons.pets_rounded,
          color: accent,
          highlighted: true,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '3',
          icon: Icons.star_rounded,
          color: AppPalette.lavender,
          compact: compact,
        ),
      ],
    'fast-eyes' => [
        _SearchChoiceCard(
          label: '!',
          icon: Icons.bolt_rounded,
          color: AppPalette.mango,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '1',
          icon: Icons.circle_rounded,
          color: AppPalette.teal,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '2',
          icon: Icons.bolt_rounded,
          color: AppPalette.mango,
          highlighted: true,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '3',
          icon: Icons.square_rounded,
          color: AppPalette.lavender,
          compact: compact,
        ),
      ],
    'hidden-star' => [
        _SearchSpot(
            color: AppPalette.teal, icon: Icons.public, compact: compact),
        _SearchSpot(color: AppPalette.sky, icon: Icons.cloud, compact: compact),
        _SearchSpot(
          color: AppPalette.mango,
          icon: Icons.star_rounded,
          highlighted: true,
          compact: compact,
        ),
        _SearchSpot(
            color: AppPalette.coral,
            icon: Icons.rocket_launch_rounded,
            compact: compact),
        _SearchSpot(color: AppPalette.sky, icon: Icons.cloud, compact: compact),
      ],
    'two-differences' => [
        _SearchChoiceCard(
          label: '1',
          icon: Icons.image_rounded,
          color: AppPalette.sky,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '2',
          icon: Icons.difference_rounded,
          color: accent,
          highlighted: true,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '3',
          icon: Icons.image_rounded,
          color: AppPalette.lavender,
          compact: compact,
        ),
      ],
    'clean-row' => [
        _SearchSpot(color: AppPalette.teal, compact: compact),
        _SearchSpot(color: AppPalette.teal, compact: compact),
        _SearchSpot(
          color: AppPalette.mango,
          icon: Icons.star_rounded,
          highlighted: true,
          compact: compact,
        ),
        _SearchSpot(color: AppPalette.teal, compact: compact),
        _SearchSpot(color: AppPalette.teal, compact: compact),
      ],
    'beacon-signal' => [
        _SearchChoiceCard(
          label: '−',
          icon: Icons.circle_rounded,
          color: AppPalette.coral,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '✓',
          icon: Icons.circle_rounded,
          color: AppPalette.teal,
          highlighted: true,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '+',
          icon: Icons.circle_rounded,
          color: AppPalette.mango,
          compact: compact,
        ),
      ],
    _ => [
        _SearchSpot(color: AppPalette.teal, compact: compact),
        _SearchSpot(color: AppPalette.teal, compact: compact),
        _SearchSpot(
          color: accent,
          icon: Icons.auto_awesome_rounded,
          highlighted: true,
          compact: compact,
        ),
        _SearchSpot(color: AppPalette.teal, compact: compact),
        _SearchSpot(
          color: AppPalette.mango,
          icon: Icons.star_rounded,
          compact: compact,
        ),
        _SearchSpot(color: AppPalette.teal, compact: compact),
      ],
  };
}

class _CampStoryStage extends StatelessWidget {
  const _CampStoryStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: compact ? 286 : 328,
        height: compact ? 92 : 112,
        child: CustomPaint(
          painter: _CampStoryPainter(accent),
        ),
      ),
    );
  }
}

class _CampStoryPainter extends CustomPainter {
  const _CampStoryPainter(this.accent);

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = Radius.circular(size.height * 0.22);
    final sky = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppPalette.sky.withValues(alpha: 0.42),
          AppPalette.mint.withValues(alpha: 0.50),
        ],
      ).createShader(rect);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), sky);

    final ground = Paint()..color = const Color(0xFFBFEBCF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38),
        radius,
      ),
      ground,
    );

    final tent = Path()
      ..moveTo(size.width * 0.12, size.height * 0.70)
      ..lineTo(size.width * 0.30, size.height * 0.22)
      ..lineTo(size.width * 0.48, size.height * 0.70)
      ..close();
    canvas.drawPath(tent, Paint()..color = AppPalette.lavender);

    final tentDoor = Path()
      ..moveTo(size.width * 0.30, size.height * 0.70)
      ..lineTo(size.width * 0.39, size.height * 0.70)
      ..lineTo(size.width * 0.30, size.height * 0.36)
      ..close();
    canvas.drawPath(
        tentDoor, Paint()..color = Colors.white.withValues(alpha: 0.86));

    final logPaint = Paint()
      ..color = const Color(0xFF8D5A35)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.57, size.height * 0.76),
      Offset(size.width * 0.76, size.height * 0.66),
      logPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.58, size.height * 0.66),
      Offset(size.width * 0.76, size.height * 0.76),
      logPaint,
    );

    final flameOuter = Path()
      ..moveTo(size.width * 0.67, size.height * 0.66)
      ..cubicTo(size.width * 0.56, size.height * 0.55, size.width * 0.70,
          size.height * 0.38, size.width * 0.65, size.height * 0.28)
      ..cubicTo(size.width * 0.83, size.height * 0.45, size.width * 0.76,
          size.height * 0.59, size.width * 0.67, size.height * 0.66)
      ..close();
    canvas.drawPath(flameOuter, Paint()..color = AppPalette.coral);

    final flameInner = Path()
      ..moveTo(size.width * 0.68, size.height * 0.63)
      ..cubicTo(size.width * 0.61, size.height * 0.55, size.width * 0.70,
          size.height * 0.47, size.width * 0.69, size.height * 0.38)
      ..cubicTo(size.width * 0.79, size.height * 0.50, size.width * 0.74,
          size.height * 0.58, size.width * 0.68, size.height * 0.63)
      ..close();
    canvas.drawPath(flameInner, Paint()..color = AppPalette.mango);

    _drawCamper(
      canvas,
      Offset(size.width * 0.86, size.height * 0.57),
      size.height * 0.18,
      accent,
    );
    _drawCamper(
      canvas,
      Offset(size.width * 0.08, size.height * 0.58),
      size.height * 0.15,
      AppPalette.teal,
    );
  }

  void _drawCamper(Canvas canvas, Offset center, double radius, Color color) {
    final body = Paint()..color = color;
    final face = Paint()..color = const Color(0xFFFFD8A8);
    final eye = Paint()..color = AppPalette.ink;

    canvas.drawCircle(center + Offset(0, radius * 1.2), radius * 1.05, body);
    canvas.drawCircle(center, radius, face);
    canvas.drawCircle(
        center + Offset(-radius * 0.32, -radius * 0.08), radius * 0.10, eye);
    canvas.drawCircle(
        center + Offset(radius * 0.32, -radius * 0.08), radius * 0.10, eye);
    canvas.drawArc(
      Rect.fromCenter(
        center: center + Offset(0, radius * 0.12),
        width: radius * 0.74,
        height: radius * 0.52,
      ),
      0.15,
      math.pi - 0.30,
      false,
      Paint()
        ..color = AppPalette.ink
        ..strokeWidth = radius * 0.10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CampStoryPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class _WordGridStage extends StatelessWidget {
  const _WordGridStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    const letters = [
      ['M', 'H', 'X', 'B', 'S'],
      ['A', 'R', 'M', 'E', 'T'],
      ['R', 'J', 'C', 'I', 'A'],
      ['C', 'S', 'T', 'A', 'R'],
      ['H', 'K', 'T', 'V', 'T'],
    ];
    final cellSize = compact ? 28.0 : 32.0;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: compact ? 286 : 328,
          padding: EdgeInsets.all(compact ? 10 : 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF26255C), Color(0xFF58355F)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var row = 0; row < letters.length; row++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var col = 0; col < letters[row].length; col++)
                          _LetterCell(
                            letter: letters[row][col],
                            size: cellSize,
                            highlighted: row == 3 && col >= 1,
                          ),
                      ],
                    ),
                ],
              ),
              SizedBox(width: compact ? 12 : 18),
              const Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _WordChip(label: 'ARM', muted: true),
                    SizedBox(height: 7),
                    _WordChip(label: 'STAR'),
                    SizedBox(height: 7),
                    _WordChip(label: 'MARCH', muted: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LetterCell extends StatelessWidget {
  const _LetterCell({
    required this.letter,
    required this.size,
    required this.highlighted,
  });

  final String letter;
  final double size;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: highlighted
            ? AppPalette.mint
            : Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color:
              highlighted ? Colors.white : Colors.white.withValues(alpha: 0.12),
          width: highlighted ? 1.6 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: highlighted ? AppPalette.ink : Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: size * 0.52,
        ),
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({required this.label, this.muted = false});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: muted ? Colors.white.withValues(alpha: 0.12) : AppPalette.coral,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          color: muted ? Colors.white70 : Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _AnimalWordStage extends StatelessWidget {
  const _AnimalWordStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: compact ? 286 : 328,
          height: compact ? 92 : 108,
          padding: EdgeInsets.all(compact ? 8 : 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE4F9D8), Color(0xFFBEEED4)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              SizedBox(
                width: compact ? 78 : 92,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: compact ? 70 : 82,
                        height: compact ? 24 : 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5E34),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    _DogFace(color: accent, size: compact ? 58 : 68),
                  ],
                ),
              ),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _LetterTile(letter: 'D', color: AppPalette.sky),
                    _LetterTile(letter: 'O', color: AppPalette.teal),
                    _LetterTile(
                        letter: 'G', color: AppPalette.mango, missing: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DogFace extends StatelessWidget {
  const _DogFace({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: size * 0.05,
            top: size * 0.08,
            child: _Ear(color: color, size: size * 0.34),
          ),
          Positioned(
            right: size * 0.05,
            top: size * 0.08,
            child: Transform.scale(
              scaleX: -1,
              child: _Ear(color: color, size: size * 0.34),
            ),
          ),
          Container(
            width: size * 0.76,
            height: size * 0.76,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.24),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
          Positioned(
            top: size * 0.33,
            child: Container(
              width: size * 0.42,
              height: size * 0.30,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B7),
                borderRadius: BorderRadius.circular(size * 0.18),
              ),
            ),
          ),
          Positioned(
            top: size * 0.28,
            left: size * 0.24,
            child: _FaceDot(size: size * 0.07),
          ),
          Positioned(
            top: size * 0.28,
            right: size * 0.24,
            child: _FaceDot(size: size * 0.07),
          ),
          Positioned(
            top: size * 0.43,
            child: Container(
              width: size * 0.10,
              height: size * 0.08,
              decoration: const BoxDecoration(
                color: AppPalette.ink,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ear extends StatelessWidget {
  const _Ear({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.55,
      child: Container(
        width: size,
        height: size * 1.28,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(size),
        ),
      ),
    );
  }
}

class _FaceDot extends StatelessWidget {
  const _FaceDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppPalette.ink,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({
    required this.letter,
    required this.color,
    this.missing = false,
  });

  final String letter;
  final Color color;
  final bool missing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 52,
      decoration: BoxDecoration(
        color: missing ? const Color(0xFFFFEDAD) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        missing ? '?' : letter,
        style: TextStyle(
          color: missing ? const Color(0xFFFFA12B) : color,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BalloonOrderStage extends StatelessWidget {
  const _BalloonOrderStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: compact ? 286 : 328,
          height: compact ? 94 : 112,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEAF8FF), Color(0xFFFFF2D0)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const _Balloon(number: '3', color: AppPalette.coral, height: 78),
              _Balloon(
                number: '1',
                color: accent,
                height: 60,
                highlighted: true,
              ),
              const _Balloon(
                  number: '2', color: AppPalette.lavender, height: 70),
              Container(
                width: 58,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.80),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.24)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '1 2 3',
                  style: TextStyle(
                    color: AppPalette.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
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

class _Balloon extends StatelessWidget {
  const _Balloon({
    required this.number,
    required this.color,
    required this.height,
    this.highlighted = false,
  });

  final String number;
  final Color color;
  final double height;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final width = height * 0.62;

    return SizedBox(
      width: width + 10,
      height: height + 16,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: width,
              height: height * 0.72,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: highlighted
                      ? Colors.white
                      : color.withValues(alpha: 0.20),
                  width: highlighted ? 3 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: highlighted ? 0.28 : 0.16),
                    blurRadius: highlighted ? 16 : 10,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.62,
            child: Container(
              width: 10,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Positioned(
            top: height * 0.72,
            child: Container(
              width: 2,
              height: height * 0.28,
              color: AppPalette.muted.withValues(alpha: 0.52),
            ),
          ),
        ],
      ),
    );
  }
}

class _BridgeOrderStage extends StatelessWidget {
  const _BridgeOrderStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: compact ? 286 : 328,
          height: compact ? 94 : 112,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE5FBF3), Color(0xFFBFE8FF)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const _BridgePlank(width: 46, color: AppPalette.teal),
                    const SizedBox(width: 8),
                    const _BridgePlank(width: 62, color: AppPalette.sky),
                    const SizedBox(width: 8),
                    _BridgeGap(accent: accent),
                    const Spacer(),
                    const _BridgeChoice(label: 'A', width: 54),
                    const SizedBox(width: 5),
                    _BridgeChoice(
                      label: 'B',
                      width: 78,
                      color: accent,
                      highlighted: true,
                    ),
                    const SizedBox(width: 5),
                    const _BridgeChoice(label: 'C', width: 98),
                  ],
                ),
              ),
              Container(
                height: 9,
                decoration: BoxDecoration(
                  color: const Color(0xFF5AB0C8).withValues(alpha: 0.32),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BridgePlank extends StatelessWidget {
  const _BridgePlank({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.20),
            blurRadius: 9,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    );
  }
}

class _BridgeGap extends StatelessWidget {
  const _BridgeGap({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.34), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '?',
        style: TextStyle(
          color: accent,
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BridgeChoice extends StatelessWidget {
  const _BridgeChoice({
    required this.label,
    required this.width,
    this.color = AppPalette.mango,
    this.highlighted = false,
  });

  final String label;
  final double width;
  final Color color;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: width,
          height: highlighted ? 22 : 18,
          decoration: BoxDecoration(
            color: highlighted ? color : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.42)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: highlighted ? color : AppPalette.muted,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _WordBuilderStage extends StatefulWidget {
  const _WordBuilderStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_WordBuilderStage> createState() => _WordBuilderStageState();
}

class _WordBuilderStageState extends State<_WordBuilderStage> {
  final Set<int> _picked = {};

  @override
  Widget build(BuildContext context) {
    final target = _wordTokensFor(context, 'word_star');
    final letters = _wordBuilderLettersFor(context);
    final pickedLetters = [
      for (var index = 0; index < letters.length; index++)
        if (_picked.contains(index)) letters[index],
    ];
    final solved = _sameTokenList(pickedLetters, target);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 98 : 116,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF2C6), Color(0xFFE6F8F5)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var index = 0; index < letters.length; index++)
                      _InteractiveLetterTile(
                        label: letters[index],
                        selected: _picked.contains(index),
                        color: widget.accent,
                        onTap: () => setState(() {
                          if (_picked.contains(index)) {
                            _picked.remove(index);
                          } else {
                            _picked.add(index);
                          }
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 96,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: solved ? AppPalette.mint : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: solved
                        ? AppPalette.teal
                        : widget.accent.withValues(alpha: 0.24),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        pickedLetters.isEmpty ? '?' : pickedLetters.join(),
                        maxLines: 1,
                        style: TextStyle(
                          color: solved ? AppPalette.teal : AppPalette.ink,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    BouncyTap(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(_picked.clear),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: widget.accent,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LetterFieldStage extends StatefulWidget {
  const _LetterFieldStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_LetterFieldStage> createState() => _LetterFieldStageState();
}

class _LetterFieldStageState extends State<_LetterFieldStage> {
  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final target = _wordTokensFor(context, 'word_moon');
    final grid = _letterFieldGridFor(context);
    final targetIndexes = _letterFieldTargetIndexes(target.length);
    final solved = targetIndexes.every(_selected.contains);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 106 : 124,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF26316A), Color(0xFF5B3E82)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: grid.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final selected = _selected.contains(index);
                    final isTarget = targetIndexes.contains(index);
                    return _FieldLetterCell(
                      label: grid[index],
                      selected: selected,
                      hinted: isTarget && solved,
                      color: widget.accent,
                      onTap: () => setState(() {
                        if (selected) {
                          _selected.remove(index);
                        } else {
                          _selected.add(index);
                        }
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 82,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    context.l10n.answerLabel('word_moon'),
                    maxLines: 1,
                    style: TextStyle(
                      color: solved ? AppPalette.mint : Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
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

class _InteractiveLetterTile extends StatelessWidget {
  const _InteractiveLetterTile({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.white : color.withValues(alpha: 0.28),
            width: selected ? 2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: selected ? 0.24 : 0.10),
              blurRadius: 9,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLetterCell extends StatelessWidget {
  const _FieldLetterCell({
    required this.label,
    required this.selected,
    required this.hinted,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool hinted;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color:
              selected || hinted ? color : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected || hinted ? Colors.white : Colors.white24,
            width: selected || hinted ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: selected || hinted ? Colors.white : Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

List<String> _wordBuilderLettersFor(BuildContext context) {
  final language = Localizations.localeOf(context).languageCode;
  return switch (language) {
    'ru' => const ['З', 'Л', 'В', 'Е', 'З', 'Д', 'А', 'О'],
    'de' => const ['S', 'M', 'T', 'E', 'R', 'N', 'O'],
    'es' => const ['E', 'S', 'T', 'R', 'E', 'L', 'L', 'A'],
    'fr' => const ['É', 'T', 'O', 'I', 'L', 'E', 'U'],
    'hi' => const ['ता', 'रा', 'सू', 'रज', 'चाँ', 'द'],
    'it' => const ['S', 'T', 'E', 'L', 'L', 'A', 'O'],
    'ja' => const ['ほ', 'し', 'つ', 'き', 'た', 'い'],
    'ko' => const ['별', '달', '해', '빛'],
    'pt' => const ['E', 'S', 'T', 'R', 'E', 'L', 'A'],
    'ar' => const ['ن', 'ج', 'م', 'ق', 'ر', 'ش'],
    'zh' => const ['星', '星', '月', '亮', '太', '阳'],
    _ => const ['S', 'M', 'T', 'A', 'R', 'O', 'N'],
  };
}

List<String> _wordTokensFor(BuildContext context, String key) {
  final language = Localizations.localeOf(context).languageCode;
  if (key == 'word_moon') {
    return switch (language) {
      'ru' => const ['Л', 'У', 'Н', 'А'],
      'de' => const ['M', 'O', 'N', 'D'],
      'es' => const ['L', 'U', 'N', 'A'],
      'fr' => const ['L', 'U', 'N', 'E'],
      'hi' => const ['चाँ', 'द'],
      'it' => const ['L', 'U', 'N', 'A'],
      'ja' => const ['つ', 'き'],
      'ko' => const ['달'],
      'pt' => const ['L', 'U', 'A'],
      'ar' => const ['ق', 'م', 'ر'],
      'zh' => const ['月', '亮'],
      _ => const ['M', 'O', 'O', 'N'],
    };
  }

  if (key == 'word_sun') {
    return switch (language) {
      'ru' => const ['С', 'О', 'Л', 'Н', 'Ц', 'Е'],
      'de' => const ['S', 'O', 'N', 'N', 'E'],
      'es' => const ['S', 'O', 'L'],
      'fr' => const ['S', 'O', 'L', 'E', 'I', 'L'],
      'hi' => const ['सू', 'रज'],
      'it' => const ['S', 'O', 'L', 'E'],
      'ja' => const ['た', 'い', 'よ', 'う'],
      'ko' => const ['해'],
      'pt' => const ['S', 'O', 'L'],
      'ar' => const ['ش', 'م', 'س'],
      'zh' => const ['太', '阳'],
      _ => const ['S', 'U', 'N'],
    };
  }

  return switch (language) {
    'ru' => const ['З', 'В', 'Е', 'З', 'Д', 'А'],
    'de' => const ['S', 'T', 'E', 'R', 'N'],
    'es' => const ['E', 'S', 'T', 'R', 'E', 'L', 'L', 'A'],
    'fr' => const ['É', 'T', 'O', 'I', 'L', 'E'],
    'hi' => const ['ता', 'रा'],
    'it' => const ['S', 'T', 'E', 'L', 'L', 'A'],
    'ja' => const ['ほ', 'し'],
    'ko' => const ['별'],
    'pt' => const ['E', 'S', 'T', 'R', 'E', 'L', 'A'],
    'ar' => const ['ن', 'ج', 'م'],
    'zh' => const ['星', '星'],
    _ => const ['S', 'T', 'A', 'R'],
  };
}

List<String> _letterFieldGridFor(BuildContext context) {
  final target = _wordTokensFor(context, 'word_moon');
  final filler = [
    ..._wordTokensFor(context, 'word_star'),
    ..._wordTokensFor(context, 'word_sun'),
    ..._wordBuilderLettersFor(context),
  ];
  final cells =
      List<String>.generate(20, (index) => filler[index % filler.length]);
  final start = _letterFieldTargetIndexes(target.length).first;
  for (var i = 0; i < target.length; i++) {
    cells[start + i] = target[i];
  }
  return cells;
}

List<int> _letterFieldTargetIndexes(int length) {
  const start = 6;
  return [for (var i = 0; i < length.clamp(1, 5); i++) start + i];
}

bool _sameTokenList(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}

class _MiniSudokuStage extends StatefulWidget {
  const _MiniSudokuStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_MiniSudokuStage> createState() => _MiniSudokuStageState();
}

class _MiniSudokuStageState extends State<_MiniSudokuStage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['star', 'moon', 'rocket', 'planet'],
      ['planet', 'rocket', 'star', 'moon'],
      ['moon', 'star', null, 'planet'],
      ['rocket', 'planet', 'moon', 'star'],
    ];
    final solved = _selected == 'rocket';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 116 : 132,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE9F9FF), Color(0xFFFFF4CF)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 128,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    final row = index ~/ 4;
                    final col = index % 4;
                    final symbol = rows[row][col] ?? _selected;
                    return _SudokuSymbolTile(
                      symbol: symbol,
                      accent: widget.accent,
                      missing: rows[row][col] == null,
                      solved: solved && rows[row][col] == null,
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final symbol in const ['star', 'moon', 'rocket'])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _SudokuChoice(
                          symbol: symbol,
                          selected: _selected == symbol,
                          accent: widget.accent,
                          onTap: () => setState(() => _selected = symbol),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SudokuSymbolTile extends StatelessWidget {
  const _SudokuSymbolTile({
    required this.symbol,
    required this.accent,
    required this.missing,
    required this.solved,
  });

  final String? symbol;
  final Color accent;
  final bool missing;
  final bool solved;

  @override
  Widget build(BuildContext context) {
    final color = _sudokuColorFor(symbol, accent);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: solved ? AppPalette.mint : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: missing ? accent : color.withValues(alpha: 0.28),
          width: missing ? 2 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          _sudokuGlyphFor(symbol),
          style: TextStyle(
            color: symbol == null ? accent : color,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SudokuChoice extends StatelessWidget {
  const _SudokuChoice({
    required this.symbol,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String symbol;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 30,
        decoration: BoxDecoration(
          color: selected ? accent : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? Colors.white : accent),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: selected ? 0.22 : 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          _sudokuGlyphFor(symbol),
          style: TextStyle(
            color: selected ? Colors.white : _sudokuColorFor(symbol, accent),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

String _sudokuGlyphFor(String? symbol) {
  return switch (symbol) {
    'star' => '★',
    'moon' => '◐',
    'rocket' => '▲',
    'planet' => '●',
    _ => '?',
  };
}

Color _sudokuColorFor(String? symbol, Color accent) {
  return switch (symbol) {
    'star' => AppPalette.mango,
    'moon' => AppPalette.lavender,
    'rocket' => accent,
    'planet' => AppPalette.teal,
    _ => accent,
  };
}

class _LogicHousesStage extends StatefulWidget {
  const _LogicHousesStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_LogicHousesStage> createState() => _LogicHousesStageState();
}

class _LogicHousesStageState extends State<_LogicHousesStage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 108 : 124,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE7FAF1), Color(0xFFE9ECFF)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ClueHouse(
                      id: 'blue',
                      color: AppPalette.sky,
                      selected: _selected == 'blue',
                      onTap: () => setState(() => _selected = 'blue'),
                    ),
                    _ClueHouse(
                      id: 'yellow',
                      color: AppPalette.mango,
                      selected: _selected == 'yellow',
                      onTap: () => setState(() => _selected = 'yellow'),
                    ),
                    _ClueHouse(
                      id: 'green',
                      color: AppPalette.teal,
                      selected: _selected == 'green',
                      onTap: () => setState(() => _selected = 'green'),
                      marked: _selected == 'green',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ClueChip(label: '★ ≠', color: AppPalette.sky),
                  SizedBox(height: 7),
                  _ClueChip(label: '★ >', color: AppPalette.mango),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClueHouse extends StatelessWidget {
  const _ClueHouse({
    required this.id,
    required this.color,
    required this.selected,
    required this.onTap,
    this.marked = false,
  });

  final String id;
  final Color color;
  final bool selected;
  final bool marked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        width: 54,
        height: 82,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomPaint(
              size: const Size(54, 74),
              painter: _HousePainter(color, selected),
            ),
            Positioned(
              bottom: 15,
              child: Text(
                id == 'blue'
                    ? 'A'
                    : id == 'yellow'
                        ? 'B'
                        : 'C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (marked)
              Positioned(
                top: 3,
                right: 3,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppPalette.mango,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '★',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HousePainter extends CustomPainter {
  const _HousePainter(this.color, this.selected);

  final Color color;
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final body = Rect.fromLTWH(9, 30, size.width - 18, size.height - 34);
    final roof = Path()
      ..moveTo(size.width / 2, 7)
      ..lineTo(size.width - 4, 33)
      ..lineTo(4, 33)
      ..close();

    canvas.drawPath(
      roof.shift(const Offset(0, 3)),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.08),
    );
    canvas.drawPath(roof, Paint()..color = color);
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(11)),
      Paint()..color = selected ? color : color.withValues(alpha: 0.76),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(11)),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 3 : 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _HousePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.selected != selected;
}

class _ClueChip extends StatelessWidget {
  const _ClueChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.34)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _CodeLockStage extends StatefulWidget {
  const _CodeLockStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_CodeLockStage> createState() => _CodeLockStageState();
}

class _CodeLockStageState extends State<_CodeLockStage> {
  final List<String> _digits = [];

  bool get _solved => _digits.join() == '248';

  void _press(String digit) {
    if (_digits.length == 3) {
      return;
    }
    setState(() => _digits.add(digit));
  }

  void _backspace() {
    if (_digits.isEmpty) {
      return;
    }
    setState(() => _digits.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    final keypad = ['2', '4', '6', '8'];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 116 : 134,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F8FF), Color(0xFFFFF4CF)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: (_solved ? AppPalette.mint : widget.accent)
                          .withValues(alpha: 0.32),
                      width: _solved ? 2.4 : 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CodeHintPill(label: '2', color: AppPalette.sky),
                          _CodeHintPill(label: '+2', color: AppPalette.teal),
                          _CodeHintPill(label: 'x2', color: AppPalette.coral),
                        ],
                      ),
                      Icon(
                        _solved ? Icons.lock_open_rounded : Icons.lock_rounded,
                        color: _solved ? AppPalette.mint : widget.accent,
                        size: widget.compact ? 24 : 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var index = 0; index < 3; index++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: _CodeDigitSlot(
                                value: index < _digits.length
                                    ? _digits[index]
                                    : null,
                                solved: _solved,
                                accent: widget.accent,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.32,
                  children: [
                    for (final digit in keypad)
                      _CodePadButton(
                        label: digit,
                        color: widget.accent,
                        selected: _digits.contains(digit),
                        onTap: () => _press(digit),
                      ),
                    _CodePadButton(
                      icon: Icons.backspace_rounded,
                      color: AppPalette.coral,
                      selected: false,
                      onTap: _backspace,
                    ),
                    _CodePadButton(
                      icon: _solved
                          ? Icons.check_rounded
                          : Icons.auto_awesome_rounded,
                      color: _solved ? AppPalette.mint : AppPalette.mango,
                      selected: _solved,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeHintPill extends StatelessWidget {
  const _CodeHintPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 24,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CodeDigitSlot extends StatelessWidget {
  const _CodeDigitSlot({
    required this.value,
    required this.solved,
    required this.accent,
  });

  final String? value;
  final bool solved;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final color = solved ? AppPalette.mint : accent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: value == null ? Colors.white : color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.42), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: value == null ? 0.08 : 0.24),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        value ?? '?',
        style: TextStyle(
          color: value == null ? color : Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CodePadButton extends StatelessWidget {
  const _CodePadButton({
    required this.color,
    required this.selected,
    this.label,
    this.icon,
    this.onTap,
  });

  final String? label;
  final IconData? icon;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.42)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: selected ? 0.24 : 0.10),
              blurRadius: 9,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: icon == null
            ? Text(
                label ?? '',
                style: TextStyle(
                  color: selected ? Colors.white : color,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              )
            : Icon(icon, color: selected ? Colors.white : color, size: 20),
      ),
    );
  }
}

class _CampDifferencesStage extends StatefulWidget {
  const _CampDifferencesStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_CampDifferencesStage> createState() => _CampDifferencesStageState();
}

class _CampDifferencesStageState extends State<_CampDifferencesStage> {
  final Set<int> _found = {};

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 112 : 128,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF0C8), Color(0xFFDDF7F3)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: _CampPicture(
                  variant: 0,
                  found: const <int>{},
                  accent: widget.accent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CampPicture(
                  variant: 1,
                  found: _found,
                  accent: widget.accent,
                  onTapDifference: (index) => setState(() => _found.add(index)),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < 2; index++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: _found.contains(index)
                            ? AppPalette.teal
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: widget.accent),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: _found.contains(index)
                              ? Colors.white
                              : widget.accent,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampPicture extends StatelessWidget {
  const _CampPicture({
    required this.variant,
    required this.found,
    required this.accent,
    this.onTapDifference,
  });

  final int variant;
  final Set<int> found;
  final Color accent;
  final ValueChanged<int>? onTapDifference;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _CampDifferencePainter(variant)),
          if (variant == 1) ...[
            _DifferenceTapTarget(
              left: 28,
              top: 18,
              found: found.contains(0),
              accent: accent,
              onTap: () => onTapDifference?.call(0),
            ),
            _DifferenceTapTarget(
              left: 86,
              top: 62,
              found: found.contains(1),
              accent: accent,
              onTap: () => onTapDifference?.call(1),
            ),
          ],
        ],
      ),
    );
  }
}

class _DifferenceTapTarget extends StatelessWidget {
  const _DifferenceTapTarget({
    required this.left,
    required this.top,
    required this.found,
    required this.accent,
    required this.onTap,
  });

  final double left;
  final double top;
  final bool found;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: BouncyTap(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: found ? accent.withValues(alpha: 0.24) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: found ? accent : Colors.white.withValues(alpha: 0.55),
              width: found ? 3 : 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _CampDifferencePainter extends CustomPainter {
  const _CampDifferencePainter(this.variant);

  final int variant;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(17)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBEEFFF), Color(0xFFC9F1C6)],
        ).createShader(rect),
    );

    final tent = Path()
      ..moveTo(size.width * 0.12, size.height * 0.70)
      ..lineTo(size.width * 0.42, size.height * 0.24)
      ..lineTo(size.width * 0.72, size.height * 0.70)
      ..close();
    canvas.drawPath(tent, Paint()..color = AppPalette.lavender);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.42, size.height * 0.70)
        ..lineTo(size.width * 0.55, size.height * 0.70)
        ..lineTo(size.width * 0.42, size.height * 0.42)
        ..close(),
      Paint()..color = Colors.white.withValues(alpha: 0.80),
    );

    final flagColor = variant == 0 ? AppPalette.coral : AppPalette.teal;
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.22),
      Offset(size.width * 0.28, size.height * 0.08),
      Paint()
        ..color = AppPalette.ink.withValues(alpha: 0.52)
        ..strokeWidth = 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.28, size.height * 0.08, 22, 13),
        const Radius.circular(4),
      ),
      Paint()..color = flagColor,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.72,
          size.height * 0.66,
          size.width * 0.18,
          size.height * 0.08,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF8D5A35),
    );

    final flameCenter = Offset(size.width * 0.80, size.height * 0.58);
    canvas.drawCircle(flameCenter, 11, Paint()..color = AppPalette.coral);
    canvas.drawCircle(flameCenter, 6, Paint()..color = AppPalette.mango);

    final starCenter = variant == 0
        ? Offset(size.width * 0.88, size.height * 0.48)
        : Offset(size.width * 0.88, size.height * 0.60);
    _drawTinyStar(
        canvas, starCenter, variant == 0 ? AppPalette.mango : Colors.white);
  }

  void _drawTinyStar(Canvas canvas, Offset center, Color color) {
    final path = Path();
    const radius = 7.0;
    for (var point = 0; point < 10; point++) {
      final currentRadius = point.isEven ? radius : radius * 0.45;
      final angle = -math.pi / 2 + point * math.pi / 5;
      final offset = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      if (point == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CampDifferencePainter oldDelegate) =>
      oldDelegate.variant != variant;
}

class _SearchSpot extends StatelessWidget {
  const _SearchSpot({
    required this.color,
    required this.compact,
    this.icon,
    this.highlighted = false,
  });

  final Color color;
  final bool compact;
  final IconData? icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final size =
        highlighted ? (compact ? 38.0 : 42.0) : (compact ? 30.0 : 34.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: highlighted ? color : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: highlighted ? Colors.white : color.withValues(alpha: 0.34),
          width: highlighted ? 3 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: highlighted ? 0.28 : 0.12),
            blurRadius: highlighted ? 16 : 9,
            offset: Offset(0, highlighted ? 8 : 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        icon ?? Icons.circle_rounded,
        color: highlighted ? Colors.white : color,
        size: size * 0.50,
      ),
    );
  }
}

class _SearchChoiceCard extends StatelessWidget {
  const _SearchChoiceCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.compact,
    this.highlighted = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool compact;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final width = compact ? 64.0 : 74.0;
    final height = compact ? 54.0 : 62.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: width,
      height: height,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: highlighted ? color : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlighted ? Colors.white : color.withValues(alpha: 0.30),
          width: highlighted ? 3 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: highlighted ? 0.26 : 0.12),
            blurRadius: highlighted ? 16 : 9,
            offset: Offset(0, highlighted ? 8 : 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: highlighted ? Colors.white : color,
            size: compact ? 20 : 23,
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: highlighted ? Colors.white : AppPalette.ink,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MathStage extends StatelessWidget {
  const _MathStage({
    required this.puzzle,
    required this.accent,
    required this.compact,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final customStage = _customMathStageFor(puzzle.id, accent, compact);

    if (customStage != null) {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: customStage,
      );
    }

    final children = _mathStageItemsFor(puzzle.id, accent, compact);

    return _StageShell(
      accent: accent,
      compact: compact,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: compact ? 286 : 328,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }
}

Widget? _customMathStageFor(String puzzleId, Color accent, bool compact) {
  return switch (puzzleId) {
    'fruit-fizz' => _FruitFizzStage(accent: accent, compact: compact),
    'moon-clock' => _MoonClockStage(accent: accent, compact: compact),
    'notebook-sum' => _NotebookSumStage(accent: accent, compact: compact),
    'cookie-share' => _CookieShareStage(accent: accent, compact: compact),
    'math-crossword' => _MathCrosswordStage(accent: accent, compact: compact),
    'market-change' => _MarketChangeStage(accent: accent, compact: compact),
    _ => null,
  };
}

class _FruitFizzStage extends StatelessWidget {
  const _FruitFizzStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: compact ? 286 : 328,
          height: compact ? 92 : 110,
          child: Row(
            children: [
              _RecipeCard(accent: accent),
              const SizedBox(width: 12),
              Expanded(
                child: CustomPaint(
                  painter: _BlenderPainter(accent),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      height: 100,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _RecipeRow(number: '3', color: AppPalette.teal),
          _RecipeRow(number: '2', color: AppPalette.lavender),
          _RecipeRow(number: '?', color: AppPalette.mango),
          _RecipeTotal(),
        ],
      ),
    );
  }
}

class _RecipeRow extends StatelessWidget {
  const _RecipeRow({required this.number, required this.color});

  final String number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: AppPalette.ink,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        _FruitDot(color: color),
        const Spacer(),
        Container(
          width: 26,
          height: 2,
          decoration: BoxDecoration(
            color: AppPalette.border,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _RecipeTotal extends StatelessWidget {
  const _RecipeTotal();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '= 8',
          style: TextStyle(
            color: AppPalette.teal,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _FruitDot extends StatelessWidget {
  const _FruitDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.58),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _BlenderPainter extends CustomPainter {
  const _BlenderPainter(this.accent);

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = AppPalette.lavender;
    final glass = Paint()
      ..color = Colors.white.withValues(alpha: 0.80)
      ..style = PaintingStyle.fill;
    final glassStroke = Paint()
      ..color = accent.withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    final jar = Path()
      ..moveTo(size.width * 0.26, size.height * 0.14)
      ..lineTo(size.width * 0.76, size.height * 0.14)
      ..lineTo(size.width * 0.66, size.height * 0.74)
      ..lineTo(size.width * 0.34, size.height * 0.74)
      ..close();
    canvas.drawPath(jar, glass);
    canvas.drawPath(jar, glassStroke);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.31,
          size.height * 0.73,
          size.width * 0.38,
          size.height * 0.12,
        ),
        const Radius.circular(12),
      ),
      base,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.38,
          size.height * 0.84,
          size.width * 0.24,
          size.height * 0.10,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = accent,
    );

    _drawFruit(canvas, size, const Offset(0.40, 0.34), AppPalette.teal);
    _drawFruit(canvas, size, const Offset(0.56, 0.38), AppPalette.lavender);
    _drawFruit(canvas, size, const Offset(0.49, 0.54), AppPalette.mango);
    _drawFruit(canvas, size, const Offset(0.62, 0.58), AppPalette.teal);
  }

  void _drawFruit(Canvas canvas, Size size, Offset position, Color color) {
    final center = Offset(size.width * position.dx, size.height * position.dy);
    final radius = size.height * 0.08;
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(
      center + Offset(-radius * 0.35, -radius * 0.38),
      radius * 0.30,
      Paint()..color = Colors.white.withValues(alpha: 0.56),
    );
  }

  @override
  bool shouldRepaint(covariant _BlenderPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class _MoonClockStage extends StatelessWidget {
  const _MoonClockStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: compact ? 286 : 328,
          height: compact ? 94 : 112,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF20225B), Color(0xFF0F6FA8)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 86,
                height: 86,
                child: CustomPaint(painter: _ClockFacePainter(accent)),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SpacePebble(
                      color: AppPalette.lavender, size: compact ? 26 : 30),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppPalette.ink,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text(
                      '3:00',
                      style: TextStyle(
                        color: AppPalette.mint,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _SpacePebble(color: AppPalette.mango, size: compact ? 34 : 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClockFacePainter extends CustomPainter {
  const _ClockFacePainter(this.accent);

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.46;
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFFFD86B));
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    for (var index = 1; index <= 12; index++) {
      final angle = (index - 3) * math.pi / 6;
      final labelOffset = Offset(
        math.cos(angle) * radius * 0.72,
        math.sin(angle) * radius * 0.72,
      );
      final painter = TextPainter(
        text: TextSpan(
          text: '$index',
          style: const TextStyle(
            color: AppPalette.ink,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        center + labelOffset - Offset(painter.width / 2, painter.height / 2),
      );
    }

    final minutePaint = Paint()
      ..color = AppPalette.coral
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final hourPaint = Paint()
      ..color = accent
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, center + Offset(0, -radius * 0.64), minutePaint);
    canvas.drawLine(center, center + Offset(radius * 0.55, 0), hourPaint);
    canvas.drawCircle(center, radius * 0.11, Paint()..color = AppPalette.coral);
  }

  @override
  bool shouldRepaint(covariant _ClockFacePainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class _SpacePebble extends StatelessWidget {
  const _SpacePebble({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: size * 0.32,
          height: size * 0.32,
          margin: EdgeInsets.all(size * 0.18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.34),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _NotebookSumStage extends StatelessWidget {
  const _NotebookSumStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: compact ? 286 : 328,
          height: compact ? 94 : 112,
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFD9AA), Color(0xFFE8D7FF)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                width: 126,
                padding: const EdgeInsets.fromLTRB(18, 12, 16, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.16),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _NotebookLine(text: '15'),
                    _NotebookLine(text: '+ 20'),
                    Divider(height: 10, thickness: 2, color: AppPalette.sky),
                    _NotebookLine(text: '?', highlighted: true),
                  ],
                ),
              ),
              const Spacer(),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NumberTile(label: '25', color: AppPalette.sky),
                  SizedBox(height: 7),
                  _NumberTile(
                      label: '35', color: AppPalette.teal, selected: true),
                  SizedBox(height: 7),
                  _NumberTile(label: '45', color: AppPalette.lavender),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotebookLine extends StatelessWidget {
  const _NotebookLine({required this.text, this.highlighted = false});

  final String text;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: highlighted ? AppPalette.coral : AppPalette.ink,
        fontWeight: FontWeight.w900,
        fontSize: highlighted ? 18 : 17,
        height: 1.05,
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({
    required this.label,
    required this.color,
    this.selected = false,
  });

  final String label;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: selected ? color : Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? Colors.white : color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: selected ? 0.24 : 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : color,
          fontWeight: FontWeight.w900,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _CookieShareStage extends StatelessWidget {
  const _CookieShareStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: compact ? 286 : 328,
          height: compact ? 94 : 112,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF4D9), Color(0xFFE5F8F4)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 122,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _CookieDot(),
                    _CookieDot(),
                    _CookieDot(),
                    _CookieDot(),
                    _CookieDot(),
                    _CookieDot(),
                  ],
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '÷',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CookiePlate(label: '2'),
                  SizedBox(height: 6),
                  _CookiePlate(label: '2'),
                  SizedBox(height: 6),
                  _CookiePlate(label: '2'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CookieDot extends StatelessWidget {
  const _CookieDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFD9924B),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD9924B).withValues(alpha: 0.20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Stack(
        children: [
          _CookieChip(left: 8, top: 8),
          _CookieChip(left: 18, top: 11),
          _CookieChip(left: 13, top: 19),
        ],
      ),
    );
  }
}

class _CookieChip extends StatelessWidget {
  const _CookieChip({required this.left, required this.top});

  final double left;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: Color(0xFF7B4A25),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _CookiePlate extends StatelessWidget {
  const _CookiePlate({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppPalette.teal.withValues(alpha: 0.30)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: AppPalette.teal,
          fontWeight: FontWeight.w900,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _MathCrosswordStage extends StatefulWidget {
  const _MathCrosswordStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_MathCrosswordStage> createState() => _MathCrosswordStageState();
}

class _MathCrosswordStageState extends State<_MathCrosswordStage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final solved = _selected == '8';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 98 : 116,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F5FF), Color(0xFFFFF1C6)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const _CrosswordCell(label: '3'),
                          const _CrosswordCell(label: '+'),
                          const _CrosswordCell(label: '5'),
                          const _CrosswordCell(label: '='),
                          _CrosswordCell(
                            label: _selected ?? '?',
                            color: solved ? AppPalette.teal : widget.accent,
                            filled: true,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 40,
                      child: Column(
                        children: [
                          _CrosswordCell(
                            label: _selected ?? '?',
                            color: solved ? AppPalette.teal : widget.accent,
                            filled: true,
                          ),
                          const _CrosswordCell(label: '-'),
                          const _CrosswordCell(label: '2'),
                          const _CrosswordCell(label: '='),
                          const _CrosswordCell(label: '6'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final value in const ['7', '8', '9'])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: _NumberChoiceChip(
                        label: value,
                        selected: _selected == value,
                        color: widget.accent,
                        onTap: () => setState(() => _selected = value),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CrosswordCell extends StatelessWidget {
  const _CrosswordCell({
    required this.label,
    this.color = AppPalette.sky,
    this.filled = false,
  });

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: filled ? color : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.34)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: filled ? 0.22 : 0.08),
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: filled ? Colors.white : AppPalette.ink,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _NumberChoiceChip extends StatelessWidget {
  const _NumberChoiceChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 46,
        height: 28,
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? Colors.white : color),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _MarketChangeStage extends StatefulWidget {
  const _MarketChangeStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_MarketChangeStage> createState() => _MarketChangeStageState();
}

class _MarketChangeStageState extends State<_MarketChangeStage> {
  bool _bought = false;

  @override
  Widget build(BuildContext context) {
    final remaining = _bought ? 2 : 5;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 110 : 128,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF6D8), Color(0xFFEAF7FF)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var index = 0; index < 5; index++)
                      _MarketStarCoin(spent: _bought && index < 3),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _ShopRocketCard(
                bought: _bought,
                accent: widget.accent,
                onTap: () => setState(() => _bought = !_bought),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: widget.compact ? 62 : 72,
                height: widget.compact ? 78 : 92,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: (_bought ? AppPalette.mint : widget.accent)
                        .withValues(alpha: 0.34),
                    width: _bought ? 2 : 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_bought ? AppPalette.mint : widget.accent)
                          .withValues(alpha: 0.14),
                      blurRadius: 12,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppPalette.mango,
                      size: widget.compact ? 24 : 30,
                    ),
                    Text(
                      '$remaining',
                      style: TextStyle(
                        color: _bought ? AppPalette.mint : widget.accent,
                        fontSize: widget.compact ? 22 : 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketStarCoin extends StatelessWidget {
  const _MarketStarCoin({required this.spent});

  final bool spent;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: spent ? 0.28 : 1,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: spent ? 0.82 : 1,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF2A6), Color(0xFFFFC84D)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppPalette.mango.withValues(alpha: 0.24),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }
}

class _ShopRocketCard extends StatelessWidget {
  const _ShopRocketCard({
    required this.bought,
    required this.accent,
    required this.onTap,
  });

  final bool bought;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 82,
        height: 92,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              bought ? AppPalette.mint.withValues(alpha: 0.16) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: (bought ? AppPalette.mint : accent).withValues(alpha: 0.36),
            width: bought ? 2.2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.14),
              blurRadius: 12,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 5,
              child: Icon(
                Icons.rocket_launch_rounded,
                color: bought ? AppPalette.mint : AppPalette.coral,
                size: 38,
              ),
            ),
            Positioned(
              bottom: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppPalette.mango.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Text(
                      '3',
                      style: TextStyle(
                        color: AppPalette.ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.star_rounded,
                      color: AppPalette.mango,
                      size: 15,
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

List<Widget> _mathStageItemsFor(
  String puzzleId,
  Color accent,
  bool compact,
) {
  final tokenSize = compact ? 42.0 : 48.0;
  final smallTokenSize = compact ? 36.0 : 40.0;

  return switch (puzzleId) {
    'number-bridge' => [
        _StageToken(label: '1', color: AppPalette.sky, size: smallTokenSize),
        _StageToken(label: '2', color: AppPalette.sky, size: smallTokenSize),
        _StageToken(label: '3', color: AppPalette.sky, size: smallTokenSize),
        _StageToken(label: '4', color: AppPalette.sky, size: smallTokenSize),
        _StageToken(
          label: '?',
          color: AppPalette.mango,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'star-balance' => [
        _CounterGroup(
          colors: const [AppPalette.mango, AppPalette.mango],
          icon: Icons.star_rounded,
          compact: compact,
        ),
        _MathSign(icon: Icons.balance_rounded, color: accent),
        _CounterGroup(
          colors: const [AppPalette.mango, AppPalette.mango],
          icon: Icons.star_rounded,
          compact: compact,
        ),
        _StageToken(label: '=', color: AppPalette.muted, size: smallTokenSize),
        _StageToken(
          label: '?',
          color: AppPalette.mango,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'count-rockets' => [
        _CounterGroup(
          colors: const [
            AppPalette.coral,
            AppPalette.coral,
            AppPalette.coral,
          ],
          icon: Icons.rocket_launch_rounded,
          compact: compact,
        ),
        _MathSign(icon: Icons.rocket_launch_rounded, color: accent),
        _CounterGroup(
          colors: const [
            AppPalette.coral,
            AppPalette.coral,
            AppPalette.coral,
          ],
          icon: Icons.rocket_launch_rounded,
          compact: compact,
        ),
        _StageToken(
          label: '?',
          color: AppPalette.mango,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'number-neighbors' => [
        _StageToken(label: '6', color: AppPalette.sky, size: tokenSize),
        _StageToken(
          label: '?',
          color: AppPalette.mango,
          size: tokenSize,
          highlighted: true,
        ),
        _StageToken(label: '8', color: AppPalette.sky, size: tokenSize),
      ],
    'cube-groups' => [
        _CounterGroup(
          colors: const [
            AppPalette.sky,
            AppPalette.sky,
            AppPalette.lavender,
            AppPalette.lavender,
          ],
          compact: compact,
        ),
        _MathSign(icon: Icons.call_split_rounded, color: accent),
        _StageToken(
          label: '2 + 2',
          color: AppPalette.teal,
          size: compact ? 58 : 66,
          highlighted: true,
        ),
      ],
    'more-less' => [
        _CounterGroup(
          colors: const [
            AppPalette.teal,
            AppPalette.teal,
            AppPalette.teal,
            AppPalette.teal,
          ],
          compact: compact,
        ),
        _MathSign(icon: Icons.compare_arrows_rounded, color: accent),
        _CounterGroup(
          colors: const [
            AppPalette.lavender,
            AppPalette.lavender,
            AppPalette.lavender,
          ],
          compact: compact,
        ),
        _StageToken(
          label: '?',
          color: AppPalette.mango,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'sticker-shop' => [
        _StageToken(
          icon: Icons.star_rounded,
          color: AppPalette.mango,
          size: smallTokenSize,
        ),
        _StageToken(
          icon: Icons.star_rounded,
          color: AppPalette.mango,
          size: smallTokenSize,
        ),
        _StageToken(
          icon: Icons.star_rounded,
          color: AppPalette.mango,
          size: smallTokenSize,
        ),
        _MathSign(icon: Icons.sell_rounded, color: accent),
        _StageToken(
          label: '?',
          color: AppPalette.lavender,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    _ => [
        _CounterGroup(
          colors: const [
            AppPalette.coral,
            AppPalette.mango,
            AppPalette.sky,
          ],
          icon: Icons.public_rounded,
          compact: compact,
        ),
        _MathSign(icon: Icons.add_rounded, color: accent),
        _CounterGroup(
          colors: const [AppPalette.teal, AppPalette.lavender],
          icon: Icons.public_rounded,
          compact: compact,
        ),
        _StageToken(label: '=', color: AppPalette.muted, size: smallTokenSize),
        _StageToken(
          label: '?',
          color: AppPalette.mango,
          size: tokenSize,
          highlighted: true,
        ),
      ],
  };
}

class _MathSign extends StatelessWidget {
  const _MathSign({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 23),
    );
  }
}

class _ConstellationRouteStage extends StatelessWidget {
  const _ConstellationRouteStage({
    required this.accent,
    required this.compact,
  });

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: compact ? 286 : 328,
          height: compact ? 94 : 112,
          child: CustomPaint(
            painter: _ConstellationPainter(accent),
          ),
        ),
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  const _ConstellationPainter(this.accent);

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(22)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F255F), Color(0xFF173E70)],
        ).createShader(rect),
    );

    final stars = [
      Offset(size.width * 0.12, size.height * 0.68),
      Offset(size.width * 0.30, size.height * 0.42),
      Offset(size.width * 0.48, size.height * 0.56),
      Offset(size.width * 0.66, size.height * 0.30),
      Offset(size.width * 0.84, size.height * 0.52),
    ];
    final pathPaint = Paint()
      ..color = AppPalette.mint
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < stars.length - 1; index++) {
      canvas.drawLine(stars[index], stars[index + 1], pathPaint);
    }

    for (var index = 0; index < stars.length; index++) {
      final isFinish = index == stars.length - 1;
      _drawStar(
        canvas,
        stars[index],
        isFinish ? size.height * 0.11 : size.height * 0.075,
        isFinish ? accent : Colors.white,
        glow: isFinish,
      );
    }

    _drawFinishLabel(canvas, 'A', Offset(size.width * 0.74, size.height * 0.78),
        AppPalette.lavender);
    _drawFinishLabel(
        canvas, 'B', Offset(size.width * 0.88, size.height * 0.52), accent,
        highlighted: true);
    _drawFinishLabel(canvas, 'C', Offset(size.width * 0.92, size.height * 0.20),
        AppPalette.mango);
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    double radius,
    Color color, {
    bool glow = false,
  }) {
    if (glow) {
      canvas.drawCircle(
        center,
        radius * 1.85,
        Paint()..color = color.withValues(alpha: 0.20),
      );
    }

    final path = Path();
    for (var point = 0; point < 10; point++) {
      final currentRadius = point.isEven ? radius : radius * 0.46;
      final angle = -math.pi / 2 + point * math.pi / 5;
      final offset = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      if (point == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawFinishLabel(
    Canvas canvas,
    String label,
    Offset center,
    Color color, {
    bool highlighted = false,
  }) {
    final radius = highlighted ? 16.0 : 13.0;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = highlighted ? color : Colors.white.withValues(alpha: 0.86),
    );
    if (highlighted) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: highlighted ? Colors.white : color,
          fontSize: highlighted ? 17 : 14,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class _PicturePuzzleStage extends StatefulWidget {
  const _PicturePuzzleStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_PicturePuzzleStage> createState() => _PicturePuzzleStageState();
}

class _PicturePuzzleStageState extends State<_PicturePuzzleStage> {
  String? _centerPiece;

  @override
  Widget build(BuildContext context) {
    final solved = _centerPiece == 'B';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 108 : 126,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF17255E), Color(0xFF1FA7C1)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                width: 134,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    const _RocketPuzzleSlot(pieceId: 'A', fixed: true),
                    const SizedBox(height: 5),
                    DragTarget<String>(
                      onWillAcceptWithDetails: (_) => true,
                      onAcceptWithDetails: (details) {
                        setState(() => _centerPiece = details.data);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return _RocketPuzzleSlot(
                          pieceId: _centerPiece,
                          fixed: false,
                          highlighted: candidateData.isNotEmpty || solved,
                          accent: widget.accent,
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    const _RocketPuzzleSlot(pieceId: 'C', fixed: true),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final piece in const ['A', 'B', 'C'])
                      _DraggableRocketPiece(
                        pieceId: piece,
                        selected: _centerPiece == piece,
                        accent: widget.accent,
                        onTap: () => setState(() => _centerPiece = piece),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RocketPuzzleSlot extends StatelessWidget {
  const _RocketPuzzleSlot({
    required this.pieceId,
    required this.fixed,
    this.highlighted = false,
    this.accent = AppPalette.teal,
  });

  final String? pieceId;
  final bool fixed;
  final bool highlighted;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 112,
      height: 28,
      decoration: BoxDecoration(
        color: pieceId == null
            ? Colors.white.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted ? accent : Colors.white.withValues(alpha: 0.38),
          width: highlighted ? 2 : 1,
        ),
      ),
      child: pieceId == null
          ? Center(
              child: Text(
                '?',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          : CustomPaint(
              painter: _RocketPuzzlePiecePainter(pieceId!, fixed),
              child: const SizedBox.expand(),
            ),
    );
  }
}

class _DraggableRocketPiece extends StatelessWidget {
  const _DraggableRocketPiece({
    required this.pieceId,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String pieceId;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final piece = _RocketPieceThumb(
      pieceId: pieceId,
      selected: selected,
      accent: accent,
    );

    return Draggable<String>(
      data: pieceId,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(scale: 1.08, child: piece),
      ),
      childWhenDragging: Opacity(opacity: 0.38, child: piece),
      child: BouncyTap(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: piece,
      ),
    );
  }
}

class _RocketPieceThumb extends StatelessWidget {
  const _RocketPieceThumb({
    required this.pieceId,
    required this.selected,
    required this.accent,
  });

  final String pieceId;
  final bool selected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 58,
      height: 42,
      decoration: BoxDecoration(
        color: selected ? accent : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: selected ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: selected ? 0.28 : 0.13),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          CustomPaint(
            painter: _RocketPuzzlePiecePainter(pieceId, false),
            child: const SizedBox.expand(),
          ),
          Positioned(
            right: 5,
            bottom: 3,
            child: Text(
              pieceId,
              style: TextStyle(
                color: selected ? Colors.white : accent,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RocketPuzzlePiecePainter extends CustomPainter {
  const _RocketPuzzlePiecePainter(this.pieceId, this.fixed);

  final String pieceId;
  final bool fixed;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleY = size.height / 28;
    final scaleX = size.width / 112;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final bodyPaint = Paint()..color = const Color(0xFFFF6F61);
    final glassPaint = Paint()..color = AppPalette.sky;
    final firePaint = Paint()..color = AppPalette.mango;
    final shadowPaint = Paint()..color = AppPalette.ink.withValues(alpha: 0.10);

    if (pieceId == 'A') {
      final nose = Path()
        ..moveTo(56, 2)
        ..lineTo(84, 26)
        ..lineTo(28, 26)
        ..close();
      canvas.drawPath(nose.shift(const Offset(0, 2)), shadowPaint);
      canvas.drawPath(nose, bodyPaint);
      canvas.drawCircle(const Offset(56, 19), 7, glassPaint);
      canvas.drawCircle(
        const Offset(53, 16),
        2.5,
        Paint()..color = Colors.white.withValues(alpha: 0.68),
      );
    } else if (pieceId == 'B') {
      final body = RRect.fromRectAndRadius(
        const Rect.fromLTWH(31, 1, 50, 26),
        const Radius.circular(12),
      );
      canvas.drawRRect(body.shift(const Offset(0, 2)), shadowPaint);
      canvas.drawRRect(body, Paint()..color = Colors.white);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(40, 7, 32, 14),
          const Radius.circular(7),
        ),
        Paint()..color = AppPalette.teal,
      );
      canvas.drawCircle(const Offset(56, 14), 5, glassPaint);
    } else {
      final leftFin = Path()
        ..moveTo(33, 2)
        ..lineTo(18, 25)
        ..lineTo(45, 20)
        ..close();
      final rightFin = Path()
        ..moveTo(79, 2)
        ..lineTo(94, 25)
        ..lineTo(67, 20)
        ..close();
      canvas.drawPath(leftFin, Paint()..color = AppPalette.lavender);
      canvas.drawPath(rightFin, Paint()..color = AppPalette.lavender);
      canvas.drawOval(
        const Rect.fromLTWH(43, 1, 26, 22),
        Paint()..color = const Color(0xFFFF6F61),
      );
      final flame = Path()
        ..moveTo(56, 27)
        ..lineTo(46, 16)
        ..lineTo(66, 16)
        ..close();
      canvas.drawPath(flame, firePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RocketPuzzlePiecePainter oldDelegate) =>
      oldDelegate.pieceId != pieceId || oldDelegate.fixed != fixed;
}

class _RouteMazeStage extends StatefulWidget {
  const _RouteMazeStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_RouteMazeStage> createState() => _RouteMazeStageState();
}

class _RouteMazeStageState extends State<_RouteMazeStage> {
  static const _starCell = 6;
  static const _obstacles = {1, 7, 13, 15};

  int _row = 2;
  int _col = 0;

  bool get _solved => _cellCode(_row, _col) == _starCell;

  void _move(int rowDelta, int colDelta) {
    final nextRow = (_row + rowDelta).clamp(0, 3);
    final nextCol = (_col + colDelta).clamp(0, 3);
    final nextCell = _cellCode(nextRow, nextCol);
    if (_obstacles.contains(nextCell)) {
      return;
    }

    setState(() {
      _row = nextRow;
      _col = nextCol;
    });
  }

  static int _cellCode(int row, int col) => row * 4 + col;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 116 : 134,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEAF7FF), Color(0xFFF5E9FF)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: widget.compact ? 116 : 132,
                height: widget.compact ? 92 : 108,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.86),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: (_solved ? AppPalette.mint : widget.accent)
                        .withValues(alpha: 0.24),
                  ),
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    final hero = index == _cellCode(_row, _col);
                    final star = index == _starCell;
                    final blocked = _obstacles.contains(index);
                    return _MazeCell(
                      hero: hero,
                      star: star,
                      blocked: blocked,
                      solved: _solved,
                      accent: widget.accent,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MazeArrowButton(
                      icon: Icons.keyboard_arrow_up_rounded,
                      color: widget.accent,
                      onTap: () => _move(-1, 0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MazeArrowButton(
                          icon: Icons.keyboard_arrow_left_rounded,
                          color: AppPalette.teal,
                          onTap: () => _move(0, -1),
                        ),
                        const SizedBox(width: 10),
                        _MazeArrowButton(
                          icon: _solved
                              ? Icons.check_rounded
                              : Icons.my_location_rounded,
                          color: _solved ? AppPalette.mint : AppPalette.mango,
                        ),
                        const SizedBox(width: 10),
                        _MazeArrowButton(
                          icon: Icons.keyboard_arrow_right_rounded,
                          color: AppPalette.coral,
                          onTap: () => _move(0, 1),
                        ),
                      ],
                    ),
                    _MazeArrowButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      color: AppPalette.lavender,
                      onTap: () => _move(1, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MazeCell extends StatelessWidget {
  const _MazeCell({
    required this.hero,
    required this.star,
    required this.blocked,
    required this.solved,
    required this.accent,
  });

  final bool hero;
  final bool star;
  final bool blocked;
  final bool solved;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final color = blocked
        ? AppPalette.muted
        : star
            ? AppPalette.mango
            : accent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      decoration: BoxDecoration(
        color: blocked
            ? AppPalette.ink.withValues(alpha: 0.10)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hero
              ? (solved ? AppPalette.mint : accent)
              : color.withValues(alpha: 0.16),
          width: hero ? 2.4 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 160),
        child: hero
            ? Icon(
                solved ? Icons.emoji_events_rounded : Icons.face_rounded,
                key: ValueKey('hero-$solved'),
                color: solved ? AppPalette.mint : accent,
                size: 18,
              )
            : star
                ? const Icon(Icons.star_rounded,
                    key: ValueKey('star'), color: AppPalette.mango, size: 18)
                : blocked
                    ? Icon(Icons.circle,
                        key: const ValueKey('blocked'),
                        color: AppPalette.muted.withValues(alpha: 0.42),
                        size: 10)
                    : const SizedBox(key: ValueKey('empty')),
      ),
    );
  }
}

class _MazeArrowButton extends StatelessWidget {
  const _MazeArrowButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 36,
        height: 30,
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: onTap == null ? color.withValues(alpha: 0.18) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.32)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _ShapeTangramStage extends StatefulWidget {
  const _ShapeTangramStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  State<_ShapeTangramStage> createState() => _ShapeTangramStageState();
}

class _ShapeTangramStageState extends State<_ShapeTangramStage> {
  String? _nosePiece;

  @override
  Widget build(BuildContext context) {
    final solved = _nosePiece == 'triangle';

    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 112 : 128,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F8FF), Color(0xFFF4E8FF)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                width: 124,
                height: 104,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: widget.accent.withValues(alpha: 0.20)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 7,
                      child: DragTarget<String>(
                        onWillAcceptWithDetails: (_) => true,
                        onAcceptWithDetails: (details) {
                          setState(() => _nosePiece = details.data);
                        },
                        builder: (context, candidateData, rejectedData) {
                          return _TangramSlot(
                            piece: _nosePiece,
                            accent: widget.accent,
                            highlighted: candidateData.isNotEmpty || solved,
                          );
                        },
                      ),
                    ),
                    const Positioned(
                      top: 40,
                      child: Row(
                        children: [
                          _TangramPlacedBlock(color: AppPalette.sky),
                          SizedBox(width: 5),
                          _TangramPlacedBlock(color: AppPalette.teal),
                        ],
                      ),
                    ),
                    const Positioned(
                      bottom: 11,
                      child: Row(
                        children: [
                          _TangramFin(color: AppPalette.lavender),
                          SizedBox(width: 24),
                          _TangramFin(color: AppPalette.mango),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final piece in const ['triangle', 'square', 'circle'])
                      _DraggableTangramPiece(
                        piece: piece,
                        selected: _nosePiece == piece,
                        accent: widget.accent,
                        onTap: () => setState(() => _nosePiece = piece),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TangramSlot extends StatelessWidget {
  const _TangramSlot({
    required this.piece,
    required this.accent,
    required this.highlighted,
  });

  final String? piece;
  final Color accent;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 54,
      height: 38,
      decoration: BoxDecoration(
        color: piece == null ? Colors.white : AppPalette.mint,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: highlighted ? accent : accent.withValues(alpha: 0.24),
          width: highlighted ? 2 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: piece == null
          ? Text(
              '?',
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w900,
                fontSize: 19,
              ),
            )
          : CustomPaint(
              painter: _TangramPiecePainter(piece!, accent),
              child: const SizedBox(width: 42, height: 30),
            ),
    );
  }
}

class _TangramPlacedBlock extends StatelessWidget {
  const _TangramPlacedBlock({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _TangramFin extends StatelessWidget {
  const _TangramFin({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.7,
      child: Container(
        width: 24,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class _DraggableTangramPiece extends StatelessWidget {
  const _DraggableTangramPiece({
    required this.piece,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String piece;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final child = _TangramPieceChip(
      piece: piece,
      selected: selected,
      accent: accent,
    );

    return Draggable<String>(
      data: piece,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(scale: 1.08, child: child),
      ),
      childWhenDragging: Opacity(opacity: 0.36, child: child),
      child: BouncyTap(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class _TangramPieceChip extends StatelessWidget {
  const _TangramPieceChip({
    required this.piece,
    required this.selected,
    required this.accent,
  });

  final String piece;
  final bool selected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 56,
      height: 44,
      decoration: BoxDecoration(
        color: selected ? accent : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: selected ? 2 : 1),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: selected ? 0.24 : 0.10),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _TangramPiecePainter(piece, selected ? Colors.white : accent),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _TangramPiecePainter extends CustomPainter {
  const _TangramPiecePainter(this.piece, this.color);

  final String piece;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    if (piece == 'triangle') {
      final path = Path()
        ..moveTo(size.width / 2, size.height * 0.12)
        ..lineTo(size.width * 0.82, size.height * 0.82)
        ..lineTo(size.width * 0.18, size.height * 0.82)
        ..close();
      canvas.drawPath(path, paint);
    } else if (piece == 'square') {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width * 0.54,
            height: size.width * 0.54,
          ),
          const Radius.circular(7),
        ),
        paint,
      );
    } else {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.shortestSide * 0.30,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TangramPiecePainter oldDelegate) =>
      oldDelegate.piece != piece || oldDelegate.color != color;
}

class _PathStage extends StatelessWidget {
  const _PathStage({
    required this.puzzle,
    required this.accent,
    required this.compact,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (puzzle.id == 'constellation-route') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _ConstellationRouteStage(accent: accent, compact: compact),
      );
    }

    if (puzzle.id == 'picture-puzzle') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _PicturePuzzleStage(accent: accent, compact: compact),
      );
    }

    if (puzzle.id == 'shape-tangram') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _ShapeTangramStage(accent: accent, compact: compact),
      );
    }

    if (puzzle.id == 'route-maze') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _RouteMazeStage(accent: accent, compact: compact),
      );
    }

    final spec = _pathStageSpecFor(puzzle.id, accent, compact);

    return _StageShell(
      accent: accent,
      compact: compact,
      child: spec.linked
          ? Row(children: _linkedPathChildren(spec, accent, compact))
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: compact ? 286 : 328,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final node in spec.nodes)
                      _PathStageNode(node: node, compact: compact),
                  ],
                ),
              ),
            ),
    );
  }
}

class _PathStageSpec {
  const _PathStageSpec({
    required this.nodes,
    this.linked = false,
  });

  final List<_PathNodeSpec> nodes;
  final bool linked;
}

class _PathNodeSpec {
  const _PathNodeSpec({
    required this.color,
    this.icon,
    this.label,
    this.highlighted = true,
  });

  final IconData? icon;
  final String? label;
  final Color color;
  final bool highlighted;
}

class _PathStageNode extends StatelessWidget {
  const _PathStageNode({
    required this.node,
    required this.compact,
  });

  final _PathNodeSpec node;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StageToken(
      icon: node.icon,
      label: node.label,
      color: node.color,
      size: compact ? 42 : 48,
      highlighted: node.highlighted,
    );
  }
}

List<Widget> _linkedPathChildren(
  _PathStageSpec spec,
  Color accent,
  bool compact,
) {
  return [
    for (var index = 0; index < spec.nodes.length; index++) ...[
      _PathStageNode(node: spec.nodes[index], compact: compact),
      if (index != spec.nodes.length - 1) _PathLink(color: accent),
    ],
  ];
}

_PathStageSpec _pathStageSpecFor(
  String puzzleId,
  Color accent,
  bool compact,
) {
  return switch (puzzleId) {
    'code-grid' => const _PathStageSpec(
        nodes: [
          _PathNodeSpec(label: 'A', color: AppPalette.sky, highlighted: false),
          _PathNodeSpec(label: 'B', color: AppPalette.teal),
          _PathNodeSpec(
              label: 'C', color: AppPalette.lavender, highlighted: false),
          _PathNodeSpec(label: '?', color: AppPalette.mango),
        ],
      ),
    'rocket-route' => const _PathStageSpec(
        linked: true,
        nodes: [
          _PathNodeSpec(
              icon: Icons.rocket_launch_rounded, color: AppPalette.coral),
          _PathNodeSpec(
              icon: Icons.arrow_forward_rounded, color: AppPalette.sky),
          _PathNodeSpec(
              icon: Icons.turn_right_rounded, color: AppPalette.lavender),
          _PathNodeSpec(
              icon: Icons.arrow_downward_rounded, color: AppPalette.mango),
        ],
      ),
    'shape-turn' => const _PathStageSpec(
        nodes: [
          _PathNodeSpec(
              icon: Icons.change_history_rounded,
              color: AppPalette.sky,
              highlighted: false),
          _PathNodeSpec(
              icon: Icons.rotate_right_rounded, color: AppPalette.lavender),
          _PathNodeSpec(
              icon: Icons.change_history_rounded, color: AppPalette.teal),
          _PathNodeSpec(label: '?', color: AppPalette.mango),
        ],
      ),
    'silhouette-build' => const _PathStageSpec(
        nodes: [
          _PathNodeSpec(
              icon: Icons.contrast_rounded,
              color: AppPalette.muted,
              highlighted: false),
          _PathNodeSpec(label: '1', color: AppPalette.sky, highlighted: false),
          _PathNodeSpec(label: '2', color: AppPalette.teal),
          _PathNodeSpec(
              label: '3', color: AppPalette.lavender, highlighted: false),
        ],
      ),
    'mirror-path' => const _PathStageSpec(
        nodes: [
          _PathNodeSpec(
              icon: Icons.arrow_forward_rounded, color: AppPalette.sky),
          _PathNodeSpec(icon: Icons.flip_rounded, color: AppPalette.lavender),
          _PathNodeSpec(icon: Icons.arrow_back_rounded, color: AppPalette.teal),
          _PathNodeSpec(label: '?', color: AppPalette.mango),
        ],
      ),
    'arrow-maze' => const _PathStageSpec(
        linked: true,
        nodes: [
          _PathNodeSpec(icon: Icons.flag_rounded, color: AppPalette.sky),
          _PathNodeSpec(
              icon: Icons.arrow_forward_rounded, color: AppPalette.sky),
          _PathNodeSpec(
              icon: Icons.arrow_downward_rounded, color: AppPalette.lavender),
          _PathNodeSpec(label: 'C', color: AppPalette.mango),
        ],
      ),
    'shape-tower' => const _PathStageSpec(
        nodes: [
          _PathNodeSpec(
              icon: Icons.circle_rounded,
              color: AppPalette.teal,
              highlighted: false),
          _PathNodeSpec(
              icon: Icons.square_rounded,
              color: AppPalette.sky,
              highlighted: false),
          _PathNodeSpec(
              icon: Icons.change_history_rounded, color: AppPalette.lavender),
          _PathNodeSpec(label: '?', color: AppPalette.mango),
        ],
      ),
    'final-orbit' => const _PathStageSpec(
        nodes: [
          _PathNodeSpec(label: 'A', color: AppPalette.sky, highlighted: false),
          _PathNodeSpec(icon: Icons.public_rounded, color: AppPalette.teal),
          _PathNodeSpec(label: 'B', color: AppPalette.mango),
          _PathNodeSpec(
              label: 'C', color: AppPalette.lavender, highlighted: false),
        ],
      ),
    _ => _PathStageSpec(
        linked: true,
        nodes: [
          _PathNodeSpec(icon: Icons.flag_rounded, color: accent),
          const _PathNodeSpec(
            icon: Icons.arrow_forward_rounded,
            color: AppPalette.sky,
          ),
          const _PathNodeSpec(
            icon: Icons.turn_right_rounded,
            color: AppPalette.lavender,
          ),
          const _PathNodeSpec(label: '?', color: AppPalette.mango),
        ],
      ),
  };
}

class _StageToken extends StatelessWidget {
  const _StageToken({
    required this.color,
    this.icon,
    this.label,
    this.size = 44,
    this.highlighted = false,
  });

  final IconData? icon;
  final String? label;
  final Color color;
  final double size;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final foreground = highlighted ? Colors.white : color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: highlighted ? color : Colors.white,
        borderRadius: BorderRadius.circular(size * 0.34),
        border: Border.all(
          color: highlighted ? Colors.white : color.withValues(alpha: 0.36),
          width: highlighted ? 3 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: highlighted ? 0.30 : 0.14),
            blurRadius: highlighted ? 18 : 10,
            offset: Offset(0, highlighted ? 9 : 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: icon == null
          ? Text(
              label ?? '',
              style: TextStyle(
                color: foreground,
                fontSize: size * 0.46,
                fontWeight: FontWeight.w900,
              ),
            )
          : Icon(
              icon,
              color: foreground,
              size: size * 0.54,
            ),
    );
  }
}

class _CounterGroup extends StatelessWidget {
  const _CounterGroup({
    required this.colors,
    required this.compact,
    this.icon,
  });

  final List<Color> colors;
  final bool compact;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final blockSize = compact ? 30.0 : 34.0;
    final stepX = compact ? 9.0 : 10.0;
    final stepY = compact ? 8.0 : 9.0;

    return SizedBox(
      width: compact ? 54 : 62,
      height: compact ? 54 : 62,
      child: Stack(
        children: [
          for (var index = 0; index < colors.length; index++)
            Positioned(
              left: index * stepX,
              top: index * stepY,
              child: _MiniBlock(
                color: colors[index],
                icon: icon,
                size: blockSize,
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniBlock extends StatelessWidget {
  const _MiniBlock({
    required this.color,
    required this.size,
    this.icon,
  });

  final Color color;
  final double size;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: icon == null
              ? [Colors.white.withValues(alpha: 0.82), color]
              : [color.withValues(alpha: 0.66), color],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: icon == null
          ? null
          : Icon(
              icon,
              color: Colors.white.withValues(alpha: 0.94),
              size: size * 0.50,
            ),
    );
  }
}

class _PathLink extends StatelessWidget {
  const _PathLink({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 7,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.24),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _PatternStrip extends StatelessWidget {
  const _PatternStrip({
    required this.puzzle,
    required this.accent,
    required this.compact,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (puzzle.id == 'bridge-order') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _BridgeOrderStage(accent: accent, compact: compact),
      );
    }

    if (puzzle.id == 'mini-sudoku') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _MiniSudokuStage(accent: accent, compact: compact),
      );
    }

    if (puzzle.id == 'logic-houses') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _LogicHousesStage(accent: accent, compact: compact),
      );
    }

    if (puzzle.id == 'code-lock') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _CodeLockStage(accent: accent, compact: compact),
      );
    }

    final items = _logicStageItemsFor(puzzle.id, accent, compact);

    return _StageShell(
      accent: accent,
      compact: compact,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: compact ? 284 : 330,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items,
          ),
        ),
      ),
    );
  }
}

List<Widget> _logicStageItemsFor(
  String puzzleId,
  Color accent,
  bool compact,
) {
  final size = compact ? 38.0 : 42.0;
  final tokenSize = compact ? 42.0 : 48.0;

  return switch (puzzleId) {
    'tower-rule' => [
        _StageToken(label: '2-1', color: AppPalette.sky, size: tokenSize),
        _StageToken(label: '2-1', color: AppPalette.teal, size: tokenSize),
        _StageToken(
          label: '?',
          color: AppPalette.mango,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'home-clues' => [
        _StageToken(
            icon: Icons.home_rounded, color: AppPalette.sky, size: tokenSize),
        _StageToken(
            icon: Icons.home_rounded, color: AppPalette.mango, size: tokenSize),
        _StageToken(
          icon: Icons.home_rounded,
          color: AppPalette.teal,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'odd-step' => [
        _StageToken(label: '1', color: AppPalette.sky, size: tokenSize),
        _StageToken(
          icon: Icons.report_problem_rounded,
          color: AppPalette.coral,
          size: tokenSize,
          highlighted: true,
        ),
        _StageToken(label: '3', color: AppPalette.sky, size: tokenSize),
      ],
    'secret-code' => [
        _StageToken(
            icon: Icons.star_rounded, color: AppPalette.mango, size: size),
        _StageToken(
            icon: Icons.vpn_key_rounded, color: AppPalette.teal, size: size),
        _StageToken(
            icon: Icons.star_rounded, color: AppPalette.mango, size: size),
        _StageToken(
          label: '?',
          color: AppPalette.teal,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'why-chain' => [
        _StageToken(
            icon: Icons.flag_rounded, color: AppPalette.sky, size: size),
        _StageToken(
            icon: Icons.arrow_forward_rounded, color: accent, size: size),
        _StageToken(
            icon: Icons.lightbulb_rounded, color: AppPalette.mango, size: size),
        _StageToken(
            icon: Icons.check_rounded, color: AppPalette.teal, size: size),
      ],
    'space-proof' => [
        _StageToken(label: 'A', color: AppPalette.sky, size: tokenSize),
        _StageToken(label: 'B', color: AppPalette.lavender, size: tokenSize),
        _StageToken(
          icon: Icons.circle_rounded,
          color: AppPalette.teal,
          size: tokenSize,
          highlighted: true,
        ),
      ],
    'shape-path' => [
        _PatternItem(
          shape: _PatternShape.circle,
          color: AppPalette.teal,
          size: size,
        ),
        _PatternItem(
          shape: _PatternShape.square,
          color: const Color(0xFF5F8BEF),
          size: size,
        ),
        _StageToken(
            icon: Icons.arrow_forward_rounded, color: accent, size: size),
        _PatternQuestion(size: compact ? 40 : 42),
      ],
    _ => [
        _PatternItem(
          shape: _PatternShape.circle,
          color: AppPalette.teal,
          size: size,
        ),
        _PatternItem(
          shape: _PatternShape.square,
          color: const Color(0xFF5F8BEF),
          size: size,
        ),
        _PatternItem(
          shape: _PatternShape.circle,
          color: AppPalette.teal,
          size: size,
        ),
        _PatternItem(
          shape: _PatternShape.square,
          color: const Color(0xFF5F8BEF),
          size: size,
        ),
        _PatternQuestion(size: compact ? 40 : 42),
      ],
  };
}

enum _PatternShape { circle, square }

class _PatternItem extends StatelessWidget {
  const _PatternItem({
    required this.shape,
    required this.color,
    required this.size,
  });

  final _PatternShape shape;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.62,
        height: size * 0.62,
        decoration: BoxDecoration(
          color: color,
          shape: shape == _PatternShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius:
              shape == _PatternShape.square ? BorderRadius.circular(7) : null,
        ),
      ),
    );
  }
}

class _PatternQuestion extends StatelessWidget {
  const _PatternQuestion({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE89A),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        '?',
        style: TextStyle(
          color: const Color(0xFFFF9F2E),
          fontSize: size * 0.57,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _QuestionBubble extends StatelessWidget {
  const _QuestionBubble({
    required this.prompt,
    required this.accent,
    required this.compact,
  });

  final String prompt;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.12),
            AppPalette.surfaceBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Text(
        prompt,
        maxLines: compact ? 2 : 3,
        overflow: TextOverflow.ellipsis,
        style: compact
            ? Theme.of(context).textTheme.titleMedium
            : Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _HintBox extends StatelessWidget {
  const _HintBox({required this.areaId, required this.compact});

  final String areaId;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4CF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.mango),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFA726)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.hintForArea(areaId),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7A5A1A),
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOptionData {
  const _AnswerOptionData({
    required this.answer,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String answer;
  final String label;
  final IconData icon;
  final Color color;
}

List<_AnswerOptionData> _answerOptionsFor(
  PuzzleAnswerRule rule,
  AppLocalizations l10n,
) {
  return [
    for (var i = 0; i < rule.options.length; i++)
      _AnswerOptionData(
        answer: rule.options[i],
        label: l10n.answerLabel(rule.options[i]),
        icon: _iconForAnswer(rule.options[i]),
        color: _colorForAnswerIndex(i),
      ),
  ];
}

IconData _iconForAnswer(String label) {
  if (label.contains('Картинка 1')) {
    return Icons.filter_1_rounded;
  }

  if (label.contains('Картинка 2')) {
    return Icons.filter_2_rounded;
  }

  if (label.contains('Картинка 3')) {
    return Icons.filter_3_rounded;
  }

  if (label.contains('След 1')) {
    return Icons.eco_rounded;
  }

  if (label.contains('След 2')) {
    return Icons.pets_rounded;
  }

  if (label.contains('След 3')) {
    return Icons.star_rounded;
  }

  if (RegExp(r'^\d').hasMatch(label)) {
    return Icons.looks_one_rounded;
  }

  if (label.contains('Круг')) {
    return Icons.circle_rounded;
  }

  if (label.contains('Квадрат') || label.contains('Кубик')) {
    return Icons.square_rounded;
  }

  if (label.contains('Треугольник')) {
    return Icons.change_history_rounded;
  }

  if (label.contains('Звезда')) {
    return Icons.star_rounded;
  }

  if (label == 'STAR') {
    return Icons.star_rounded;
  }

  if (label == 'word_star') {
    return Icons.star_rounded;
  }

  if (label == 'word_moon') {
    return Icons.nightlight_round;
  }

  if (label == 'word_sun') {
    return Icons.wb_sunny_rounded;
  }

  if (label == 'shape_star') {
    return Icons.star_rounded;
  }

  if (label == 'shape_moon') {
    return Icons.nightlight_round;
  }

  if (label == 'shape_rocket') {
    return Icons.rocket_launch_rounded;
  }

  if (label == 'house_blue' ||
      label == 'house_green' ||
      label == 'house_yellow') {
    return Icons.home_rounded;
  }

  if (label == 'piece_triangle') {
    return Icons.change_history_rounded;
  }

  if (label == 'piece_square') {
    return Icons.square_rounded;
  }

  if (label == 'piece_circle') {
    return Icons.circle_rounded;
  }

  if (label == 'path_A' || label == 'path_B' || label == 'path_C') {
    return Icons.alt_route_rounded;
  }

  if (label == 'DOG' || label == 'CAT' || label == 'FOX') {
    return Icons.pets_rounded;
  }

  if (label.contains('Костер')) {
    return Icons.local_fire_department_rounded;
  }

  if (label.contains('Палатка')) {
    return Icons.festival_rounded;
  }

  if (label.contains('Подушка')) {
    return Icons.bed_rounded;
  }

  if (label.contains('Сердце')) {
    return Icons.favorite_rounded;
  }

  if (label.contains('Облако')) {
    return Icons.cloud_rounded;
  }

  if (label.contains('Вверх') || label.contains('Сверху')) {
    return Icons.arrow_upward_rounded;
  }

  if (label.contains('Вниз') || label.contains('Снизу')) {
    return Icons.arrow_downward_rounded;
  }

  if (label.contains('Слева') || label.contains('Влево')) {
    return Icons.arrow_back_rounded;
  }

  if (label.contains('Справа') ||
      label.contains('Вправо') ||
      label.contains('Вперёд')) {
    return Icons.arrow_forward_rounded;
  }

  if (label.contains('центр')) {
    return Icons.center_focus_strong_rounded;
  }

  if (label.contains('Тень')) {
    return Icons.contrast_rounded;
  }

  if (label.contains('Клетка') || label.contains('Финиш')) {
    return Icons.grid_view_rounded;
  }

  if (label.contains('Орбита')) {
    return Icons.public_rounded;
  }

  if (label.contains('Детали')) {
    return Icons.extension_rounded;
  }

  if (label.contains('наклейки')) {
    return Icons.auto_awesome_rounded;
  }

  return Icons.touch_app_rounded;
}

Color _colorForAnswerIndex(int index) {
  return switch (index % 3) {
    0 => const Color(0xFFFFF2C4),
    1 => const Color(0xFFDDF7F3),
    _ => const Color(0xFFECE8FF),
  };
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.option,
    required this.selected,
    required this.state,
    required this.compact,
    required this.stacked,
    required this.onTap,
  });

  final _AnswerOptionData option;
  final bool selected;
  final _AnswerCheckState state;
  final bool compact;
  final bool stacked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(stacked ? 22 : 20);
    final isCorrect = state == _AnswerCheckState.correct;
    final isWrong = state == _AnswerCheckState.wrong;
    final borderColor = isCorrect
        ? AppPalette.teal
        : isWrong
            ? AppPalette.coral
            : selected
                ? AppPalette.teal
                : AppPalette.border;
    final fillColor = isCorrect
        ? AppPalette.mint.withValues(alpha: 0.58)
        : isWrong
            ? AppPalette.coral.withValues(alpha: 0.12)
            : selected
                ? AppPalette.mint.withValues(alpha: 0.44)
                : Colors.white;
    final statusIcon = isCorrect
        ? Icons.check_circle_rounded
        : isWrong
            ? Icons.cancel_rounded
            : Icons.check_circle_rounded;
    final statusColor = isWrong ? AppPalette.coral : AppPalette.teal;

    return BouncyTap(
      borderRadius: borderRadius,
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        scale: selected ? 1.015 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: stacked ? 8 : 12,
            vertical: stacked ? 8 : (compact ? 7 : 9),
          ),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: borderColor,
              width: selected || isCorrect || isWrong ? 2 : 1.2,
            ),
            boxShadow: [
              if (selected || isCorrect || isWrong)
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
            ],
          ),
          child: stacked
              ? SizedBox(
                  height: 78,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconBadge(
                              icon: option.icon,
                              color: option.color,
                              iconColor: selected
                                  ? AppPalette.teal
                                  : AppPalette.lavender,
                              size: 36,
                            ),
                            const SizedBox(height: 5),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                option.label,
                                maxLines: 1,
                                softWrap: false,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppPalette.ink,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Icon(
                            statusIcon,
                            color: statusColor,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    IconBadge(
                      icon: option.icon,
                      color: option.color,
                      iconColor:
                          selected ? AppPalette.teal : AppPalette.lavender,
                      size: compact ? 36 : 40,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (selected)
                      Icon(
                        statusIcon,
                        color: statusColor,
                        size: 28,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AnswerFeedbackPanel extends StatelessWidget {
  const _AnswerFeedbackPanel({
    required this.state,
    required this.retryText,
    required this.compact,
  });

  final _AnswerCheckState state;
  final String retryText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isCorrect = state == _AnswerCheckState.correct;
    final color = isCorrect ? AppPalette.teal : AppPalette.coral;
    final icon = isCorrect ? Icons.celebration_rounded : Icons.refresh_rounded;
    final title = isCorrect
        ? context.l10n.challengeCorrectFeedbackTitle
        : context.l10n.challengeRetryFeedbackTitle;
    final text =
        isCorrect ? context.l10n.challengeCorrectFeedbackText : retryText;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.all(compact ? 10 : 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isCorrect ? 0.12 : 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          IconBadge(
            icon: icon,
            color: Colors.white.withValues(alpha: 0.82),
            iconColor: color,
            size: compact ? 36 : 42,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Text(
                  text,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.ink,
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

class _StickyAnswerBar extends StatelessWidget {
  const _StickyAnswerBar({
    required this.enabled,
    required this.loading,
    required this.selectedAnswerLabel,
    required this.answerState,
    required this.compact,
    required this.onSubmit,
  });

  final bool enabled;
  final bool loading;
  final String? selectedAnswerLabel;
  final _AnswerCheckState answerState;
  final bool compact;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final label = _answerBarLabel(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppPalette.surface,
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            compact ? 8 : 12,
            18,
            compact ? 10 : 14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: enabled ? AppPalette.ink : AppPalette.muted,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: compact ? 156 : 170,
                child: SoftShine(
                  borderRadius: BorderRadius.circular(18),
                  enabled: enabled && !loading,
                  duration: const Duration(milliseconds: 1800),
                  child: FilledButton.icon(
                    onPressed: enabled && !loading ? onSubmit : null,
                    style: compact
                        ? FilledButton.styleFrom(
                            minimumSize: const Size(0, 46),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          )
                        : null,
                    icon: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(
                      loading
                          ? context.l10n.challengeChecking
                          : context.l10n.challengeCheck,
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

  String _answerBarLabel(BuildContext context) {
    if (answerState == _AnswerCheckState.wrong) {
      return context.l10n.challengePickDifferentAnswer;
    }

    if (answerState == _AnswerCheckState.correct) {
      return context.l10n.challengeCorrectAnswer;
    }

    final answer = selectedAnswerLabel;
    return answer == null
        ? context.l10n.challengeChooseAnswer
        : context.l10n.challengeSelectedAnswer(answer);
  }
}

Color _areaColor(int index) {
  return switch (index % 5) {
    0 => AppPalette.coral,
    1 => AppPalette.lavender,
    2 => AppPalette.teal,
    3 => AppPalette.mango,
    _ => AppPalette.sky,
  };
}

Color _areaAccentForId(String areaId) {
  return switch (areaId) {
    'logic' => AppPalette.coral,
    'memory' => AppPalette.lavender,
    'attention' => AppPalette.teal,
    'math' => AppPalette.mango,
    'space' => AppPalette.sky,
    _ => AppPalette.teal,
  };
}

IconData _dailyIcon(int index) {
  return switch (index) {
    0 => Icons.looks_one_rounded,
    1 => Icons.looks_two_rounded,
    _ => Icons.looks_3_rounded,
  };
}

Set<String> _completedDailyIdsForToday(FamilyProfile profile) {
  final progressDate = profile.dailyProgressDate;
  if (progressDate == null) {
    return const {};
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final progressDay = DateTime(
    progressDate.year,
    progressDate.month,
    progressDate.day,
  );

  if (progressDay != today) {
    return const {};
  }

  return profile.dailyCompletedPuzzleIds.toSet();
}
