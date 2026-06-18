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
