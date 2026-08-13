import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../domain/puzzle_answer_rules.dart';
import '../../domain/puzzle_interaction_catalog.dart';
import '../../audio/puzzle_narration_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../l10n/localized_content.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';
import 'game_scenes/camp_differences_game.dart';
import 'game_scenes/animal_word_game.dart';
import 'game_scenes/beacon_signal_game.dart';
import 'game_scenes/arrow_maze_game.dart';
import 'game_scenes/balloon_order_game.dart';
import 'game_scenes/captain_command_game.dart';
import 'game_scenes/camp_story_game.dart';
import 'game_scenes/code_grid_game.dart';
import 'game_scenes/deduction_games.dart';
import 'game_scenes/deduction_board_games.dart';
import 'game_scenes/clean_row_game.dart';
import 'game_scenes/color_rhythm_game.dart';
import 'game_scenes/final_orbit_game.dart';
import 'game_scenes/fast_eyes_game.dart';
import 'game_scenes/hidden_star_game.dart';
import 'game_scenes/letter_field_game.dart';
import 'game_scenes/logic_mechanics_games.dart';
import 'game_scenes/memory_pairs_game.dart';
import 'game_scenes/math_reasoning_games.dart';
import 'game_scenes/math_workshop_games.dart';
import 'game_scenes/mirror_path_game.dart';
import 'game_scenes/rocket_route_game.dart';
import 'game_scenes/route_memory_game.dart';
import 'game_scenes/secret_cards_game.dart';
import 'game_scenes/sequence_workshop_games.dart';
import 'game_scenes/shadow_match_game.dart';
import 'game_scenes/silhouette_build_game.dart';
import 'game_scenes/shape_tangram_game.dart';
import 'game_scenes/shape_turn_game.dart';
import 'game_scenes/shape_tower_game.dart';
import 'game_scenes/sound_order_game.dart';
import 'game_scenes/space_proof_game.dart';
import 'game_scenes/story_order_game.dart';
import 'game_scenes/star_list_game.dart';
import 'game_scenes/tiny_detail_game.dart';
import 'game_scenes/two_differences_game.dart';
import 'game_scenes/what_changed_game.dart';
import 'game_scenes/word_grid_game.dart';
import 'game_scenes/word_builder_game.dart';
import 'game_scenes/why_chain_game.dart';
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
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppPalette.coral.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 12),
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
                  Container(
                    width: 62,
                    height: 62,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/home_astronaut_cutout.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
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
    return Column(
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: completed ? 0.82 : 0.70),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AreaCharacterBadge(
                      areaId: puzzle.areaId,
                      color: completed
                          ? AppPalette.mint.withValues(alpha: 0.90)
                          : accent.withValues(alpha: 0.46),
                      size: 56,
                      padding: 3,
                    ),
                    if (completed)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: const BoxDecoration(
                            color: AppPalette.teal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            _AreaHero(
              area: area,
              color: color,
              completedCount: completedCount,
            ),
            const SizedBox(height: 20),
            _PuzzleJourney(
              puzzles: area.puzzles,
              color: color,
              completedPracticeIds: _completedPracticeIds,
              nextIndex: nextIndex,
              onStart: (puzzle, puzzleIndex) => widget.onStart(
                context,
                puzzle,
                puzzleIndex,
                _markSolved,
              ),
            ),
          ],
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Text(
                    context.l10n.challengeAreaCompleted(
                      completedCount,
                      total,
                    ),
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
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

class _PuzzleJourney extends StatelessWidget {
  const _PuzzleJourney({
    required this.puzzles,
    required this.color,
    required this.completedPracticeIds,
    required this.nextIndex,
    required this.onStart,
  });

  final List<DailyChallenge> puzzles;
  final Color color;
  final Set<String> completedPracticeIds;
  final int nextIndex;
  final void Function(DailyChallenge puzzle, int index) onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4),
          child: Text(
            context.l10n.challengeFreePlay,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < puzzles.length; index++)
          _PuzzleRouteTile(
            puzzle: puzzles[index],
            levelNumber: index + 1,
            color: color,
            completed: completedPracticeIds.contains(puzzles[index].id),
            current: nextIndex == -1
                ? index == puzzles.length - 1
                : index == nextIndex,
            isLast: index == puzzles.length - 1,
            onTap: () => onStart(puzzles[index], index),
          ),
      ],
    );
  }
}

class _PuzzleRouteTile extends StatelessWidget {
  const _PuzzleRouteTile({
    required this.puzzle,
    required this.levelNumber,
    required this.color,
    required this.completed,
    required this.current,
    required this.isLast,
    required this.onTap,
  });

  final DailyChallenge puzzle;
  final int levelNumber;
  final Color color;
  final bool completed;
  final bool current;
  final bool isLast;
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
    final actionIcon = completed
        ? Icons.check_rounded
        : current
            ? Icons.play_arrow_rounded
            : Icons.arrow_forward_rounded;

    return Semantics(
      button: true,
      child: BouncyTap(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.only(bottom: isLast ? 0 : 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 64,
                height: isLast ? 108 : 122,
                child: Column(
                  children: [
                    _PuzzleRouteMarker(
                      levelNumber: levelNumber,
                      color: stateColor,
                      completed: completed,
                      current: current,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 4,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: stateColor.withValues(alpha: 0.26),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 108),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: completed
                        ? AppPalette.mint.withValues(alpha: 0.44)
                        : Colors.white.withValues(alpha: current ? 0.98 : 0.82),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: completed
                          ? AppPalette.teal.withValues(alpha: 0.34)
                          : current
                              ? color.withValues(alpha: 0.56)
                              : Colors.white,
                      width: current ? 2 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            stateColor.withValues(alpha: current ? 0.18 : 0.08),
                        blurRadius: current ? 18 : 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _PuzzleRoutePreview(
                        puzzleId: puzzle.id,
                        color: color,
                        isActive: current,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.challengeLevelNumber(levelNumber),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.puzzleTitle(puzzle),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppPalette.ink,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              stateLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: stateColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: completed || current
                              ? stateColor
                              : AppPalette.surfaceBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          actionIcon,
                          color: completed || current
                              ? Colors.white
                              : AppPalette.ink,
                          size: 24,
                        ),
                      ),
                    ],
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

class _PuzzleRouteMarker extends StatelessWidget {
  const _PuzzleRouteMarker({
    required this.levelNumber,
    required this.color,
    required this.completed,
    required this.current,
  });

  final int levelNumber;
  final Color color;
  final bool completed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: completed || current ? color : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: current ? 0.32 : 0.16),
            blurRadius: current ? 16 : 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: completed
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 28)
          : Text(
              '$levelNumber',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: current ? Colors.white : AppPalette.ink,
                    fontWeight: FontWeight.w900,
                  ),
            ),
    );
  }
}

class _PuzzleRoutePreview extends StatelessWidget {
  const _PuzzleRoutePreview({
    required this.puzzleId,
    required this.color,
    required this.isActive,
  });

  final String puzzleId;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final seed = puzzleId.codeUnits.fold<int>(0, (sum, value) => sum + value);
    final palette = <Color>[
      color,
      AppPalette.mango,
      AppPalette.coral,
      AppPalette.lavender,
    ];

    return Container(
      width: 64,
      height: 64,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var index = 0; index < 3; index++)
            PositionedDirectional(
              start: 9.0 + ((seed + index * 13) % 18),
              top: 10.0 + ((seed + index * 7) % 24),
              child: Transform.rotate(
                angle: ((seed + index) % 3 - 1) * 0.18,
                child: Container(
                  width: index == 1 ? 28 : 20,
                  height: index == 1 ? 28 : 20,
                  decoration: BoxDecoration(
                    color: palette[(seed + index) % palette.length].withValues(
                        alpha: isActive || index == 1 ? 0.95 : 0.62),
                    borderRadius: BorderRadius.circular(index == 0 ? 999 : 8),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.ink.withValues(alpha: 0.10),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
  // The device TTS engine is created only after the child asks to hear a task.
  // Opening or moving between puzzles must remain silent by default.
  PuzzleNarrationService? _narration;
  String? _selectedAnswer;
  _AnswerCheckState _answerState = _AnswerCheckState.idle;
  bool _showHint = false;
  bool _isSubmitting = false;
  bool _showSuccessBurst = false;
  bool _isNarrating = false;

  @override
  void dispose() {
    _narration?.stop();
    super.dispose();
  }

  Future<void> _toggleNarration(String prompt) async {
    if (_isNarrating) {
      await _narration?.stop();
      if (mounted) {
        setState(() => _isNarrating = false);
      }
      return;
    }

    setState(() => _isNarrating = true);
    final narration = _narration ??= PuzzleNarrationService();
    await narration.speak(prompt, Localizations.localeOf(context));
    if (mounted) {
      setState(() => _isNarrating = false);
    }
  }

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

  Future<void> _selectSceneAnswerAndSubmit(String answer) async {
    if (_isSubmitting) {
      return;
    }

    Feedback.forTap(context);
    setState(() {
      _selectedAnswer = answer;
      _answerState = _AnswerCheckState.idle;
    });

    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted || _isSubmitting) {
      return;
    }

    await _submit();
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
    final sceneAnswerPicker = usesInteractivePuzzleScene(widget.puzzle.id);
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
              padding: EdgeInsets.fromLTRB(
                18,
                compact ? 6 : 8,
                18,
                sceneAnswerPicker ? 24 : 96,
              ),
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
                      buildPuzzleScene(
                        puzzle: widget.puzzle,
                        accent: accent,
                        compact: compact,
                        onAnswerSelected: sceneAnswerPicker
                            ? _selectSceneAnswerAndSubmit
                            : _selectAnswer,
                      ),
                      SizedBox(height: compact ? 8 : 12),
                      _QuestionBubble(
                        prompt: l10n.puzzlePrompt(widget.puzzle),
                        accent: accent,
                        compact: compact,
                        isNarrating: _isNarrating,
                        listenLabel: l10n.puzzleListenPrompt,
                        stopLabel: l10n.puzzleStopNarration,
                        onNarrate: () => _toggleNarration(
                          l10n.puzzlePrompt(widget.puzzle),
                        ),
                      ),
                      SizedBox(height: compact ? 8 : 10),
                      if (sceneAnswerPicker)
                        const SizedBox.shrink()
                      else if (compact)
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
                        alignment: AlignmentDirectional.centerStart,
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
      bottomNavigationBar: sceneAnswerPicker
          ? null
          : _StickyAnswerBar(
              enabled: canSubmit,
              loading: _isSubmitting,
              selectedAnswerLabel: _selectedAnswer == null
                  ? null
                  : l10n.answerLabel(_selectedAnswer!),
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
                alignment: AlignmentDirectional.centerStart,
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
                style: compact
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: compact ? 2 : 4),
              Text(
                context.l10n.puzzleSkill(puzzle),
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

const genericPuzzleSceneFallbackKey =
    ValueKey<String>('generic-puzzle-scene-fallback');

Widget buildPuzzleScene({
  required DailyChallenge puzzle,
  required Color accent,
  required bool compact,
  required ValueChanged<String> onAnswerSelected,
}) {
  return _PuzzleStage(
    puzzle: puzzle,
    accent: accent,
    compact: compact,
    onAnswerSelected: onAnswerSelected,
  );
}

bool usesInteractivePuzzleScene(String puzzleId) {
  return isSceneDrivenPuzzle(puzzleId);
}

class _PuzzleStage extends StatelessWidget {
  const _PuzzleStage({
    required this.puzzle,
    required this.accent,
    required this.compact,
    required this.onAnswerSelected,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final stage = switch (puzzle.areaId) {
      'memory' => _MemoryStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
          onAnswerSelected: onAnswerSelected,
        ),
      'attention' => _AttentionStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
          onAnswerSelected: onAnswerSelected,
        ),
      'math' => _MathStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
          onAnswerSelected: onAnswerSelected,
        ),
      'space' => _PathStage(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
          onAnswerSelected: onAnswerSelected,
        ),
      _ => _PatternStrip(
          puzzle: puzzle,
          accent: accent,
          compact: compact,
          onAnswerSelected: onAnswerSelected,
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
    super.key,
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
    required this.onAnswerSelected,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    if (puzzle.id == 'star-list') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: StarListGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'route-memory') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: RouteMemoryGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'color-rhythm') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: ColorRhythmGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'what-changed') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: WhatChangedGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'captain-command') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: CaptainCommandGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'memory-pairs') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: MemoryPairsGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'sound-order') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: SoundOrderGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'camp-story') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: CampStoryGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'story-order') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: StoryOrderGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'hidden-cards') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: SecretCardsGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    final cardSize = compact ? 38.0 : 44.0;
    final spec = _memoryStageSpecFor(puzzle.id, accent);

    return _StageShell(
      key: genericPuzzleSceneFallbackKey,
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
            label: '->',
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
    required this.onAnswerSelected,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final correctAnswer = answerRuleForPuzzle(puzzle).correctAnswer;
    final customStage = switch (puzzle.id) {
      'tiny-detail' => TinyDetailGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'fast-eyes' => FastEyesGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'hidden-star' => HiddenStarGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'clean-row' => CleanRowGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'shadow-match' => ShadowMatchGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'balloon-order' => BalloonOrderGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'two-differences' => TwoDifferencesGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'beacon-signal' => BeaconSignalGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'odd-card' => OddCardInvestigationGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'word-grid' => WordGridGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'animal-word' => AnimalWordGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'word-builder' => LocaleWordBuilderGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'letter-field' => LocaleLetterFieldGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      'camp-differences' => CampDifferencesGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          onAnswerSelected: onAnswerSelected,
        ),
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
      key: genericPuzzleSceneFallbackKey,
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
          label: '^',
          icon: Icons.auto_awesome_rounded,
          color: AppPalette.mango,
          highlighted: true,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: '*',
          icon: Icons.crop_free_rounded,
          color: accent,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: 'v',
          icon: Icons.circle_rounded,
          color: AppPalette.sky,
          compact: compact,
        ),
      ],
    'shadow-match' => [
        _SearchChoiceCard(
          label: 'в…',
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
          label: 'в€’',
          icon: Icons.circle_rounded,
          color: AppPalette.coral,
          compact: compact,
        ),
        _SearchChoiceCard(
          label: 'вњ“',
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

class _CodeLockA11yCopy {
  const _CodeLockA11yCopy({
    required this.dial,
    required this.increase,
    required this.decrease,
    required this.check,
    required this.adjustHint,
    required this.checkHint,
    required this.round,
    required this.solved,
  });

  final String dial;
  final String increase;
  final String decrease;
  final String check;
  final String adjustHint;
  final String checkHint;
  final String round;
  final String solved;

  String dialLabel(int index) => '$dial ${index + 1}';
  String increaseLabel(int index) => '$increase ${dialLabel(index)}';
  String decreaseLabel(int index) => '$decrease ${dialLabel(index)}';
  String progress(int current, int total) => '$round $current / $total';

  static _CodeLockA11yCopy of(BuildContext context) =>
      _copies[Localizations.localeOf(context).languageCode] ?? _copies['en']!;

  static const _copies = <String, _CodeLockA11yCopy>{
    'ar': _CodeLockA11yCopy(
        dial: 'قرص',
        increase: 'زيادة',
        decrease: 'إنقاص',
        check: 'تحقق من القفل',
        adjustHint: 'غيّر الرقم على هذا القرص',
        checkHint: 'تحقق من الأرقام الثلاثة',
        round: 'الجولة',
        solved: 'تم فتح القفل'),
    'de': _CodeLockA11yCopy(
        dial: 'Drehrad',
        increase: 'Erhöhe',
        decrease: 'Verringere',
        check: 'Schloss prüfen',
        adjustHint: 'Ändere die Zahl auf diesem Drehrad',
        checkHint: 'Prüfe alle drei Zahlen',
        round: 'Runde',
        solved: 'Schloss geöffnet'),
    'en': _CodeLockA11yCopy(
        dial: 'Dial',
        increase: 'Increase',
        decrease: 'Decrease',
        check: 'Check lock',
        adjustHint: 'Change the number on this dial',
        checkHint: 'Check all three numbers',
        round: 'Round',
        solved: 'Lock opened'),
    'es': _CodeLockA11yCopy(
        dial: 'Disco',
        increase: 'Aumentar',
        decrease: 'Disminuir',
        check: 'Comprobar cerradura',
        adjustHint: 'Cambia el número de este disco',
        checkHint: 'Comprueba los tres números',
        round: 'Ronda',
        solved: 'Cerradura abierta'),
    'fr': _CodeLockA11yCopy(
        dial: 'Molette',
        increase: 'Augmenter',
        decrease: 'Diminuer',
        check: 'Vérifier le cadenas',
        adjustHint: 'Change le chiffre de cette molette',
        checkHint: 'Vérifie les trois chiffres',
        round: 'Manche',
        solved: 'Cadenas ouvert'),
    'hi': _CodeLockA11yCopy(
        dial: 'डायल',
        increase: 'बढ़ाएँ',
        decrease: 'घटाएँ',
        check: 'ताला जाँचें',
        adjustHint: 'इस डायल का अंक बदलें',
        checkHint: 'तीनों अंकों की जाँच करें',
        round: 'चरण',
        solved: 'ताला खुल गया'),
    'it': _CodeLockA11yCopy(
        dial: 'Rotella',
        increase: 'Aumenta',
        decrease: 'Diminuisci',
        check: 'Controlla lucchetto',
        adjustHint: 'Cambia il numero su questa rotella',
        checkHint: 'Controlla tutti e tre i numeri',
        round: 'Turno',
        solved: 'Lucchetto aperto'),
    'ja': _CodeLockA11yCopy(
        dial: 'ダイヤル',
        increase: '増やす',
        decrease: '減らす',
        check: '鍵を確認',
        adjustHint: 'このダイヤルの数字を変えます',
        checkHint: '3つの数字を確認します',
        round: 'ラウンド',
        solved: '鍵が開きました'),
    'ko': _CodeLockA11yCopy(
        dial: '다이얼',
        increase: '올리기',
        decrease: '내리기',
        check: '자물쇠 확인',
        adjustHint: '이 다이얼의 숫자를 바꿉니다',
        checkHint: '숫자 세 개를 확인합니다',
        round: '라운드',
        solved: '자물쇠가 열렸습니다'),
    'pt': _CodeLockA11yCopy(
        dial: 'Disco',
        increase: 'Aumentar',
        decrease: 'Diminuir',
        check: 'Verificar fechadura',
        adjustHint: 'Mude o número deste disco',
        checkHint: 'Verifique os três números',
        round: 'Rodada',
        solved: 'Fechadura aberta'),
    'ru': _CodeLockA11yCopy(
        dial: 'Диск',
        increase: 'Увеличить',
        decrease: 'Уменьшить',
        check: 'Проверить замок',
        adjustHint: 'Измените цифру на этом диске',
        checkHint: 'Проверьте все три цифры',
        round: 'Раунд',
        solved: 'Замок открыт'),
    'zh': _CodeLockA11yCopy(
        dial: '转盘',
        increase: '增大',
        decrease: '减小',
        check: '检查密码锁',
        adjustHint: '更改此转盘上的数字',
        checkHint: '检查三个数字',
        round: '回合',
        solved: '密码锁已打开'),
  };
}

class _CodeLockStage extends StatefulWidget {
  const _CodeLockStage({
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
  State<_CodeLockStage> createState() => _CodeLockStageState();
}

class _CodeLockStageState extends State<_CodeLockStage>
    with TickerProviderStateMixin {
  static const _starts = <List<int>>[
    [0, 2, 4],
    [3, 3, 7],
    [4, 6, 1],
  ];
  static const _targets = <List<int>>[
    [1, 3, 6],
    [2, 4, 8],
    [3, 5, 0],
  ];

  late final AnimationController _error;
  late final AnimationController _success;
  late List<int> _values;
  int _round = 0;
  bool _wrong = false;
  bool _solved = false;
  bool _answerSent = false;

  @override
  void initState() {
    super.initState();
    _values = List<int>.of(_starts.first);
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _success = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    _success.dispose();
    super.dispose();
  }

  void _turn(int index, int delta) {
    if (_solved) return;
    HapticFeedback.selectionClick();
    setState(() {
      _wrong = false;
      _values[index] = (_values[index] + delta + 10) % 10;
    });
  }

  void _check() {
    if (_solved) return;
    final target = _targets[_round];
    final correct = List.generate(3, (index) => _values[index] == target[index])
        .every((value) => value);
    if (!correct) {
      HapticFeedback.lightImpact();
      setState(() => _wrong = true);
      _error.forward(from: 0);
      return;
    }

    HapticFeedback.mediumImpact();
    _success.forward(from: 0);
    if (_round < _targets.length - 1) {
      setState(() {
        _round++;
        _values = List<int>.of(_starts[_round]);
        _wrong = false;
      });
      return;
    }

    setState(() {
      _solved = true;
      _wrong = false;
    });
    _success.forward(from: 0);
    Future<void>.delayed(const Duration(milliseconds: 620), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final copy = _CodeLockA11yCopy.of(context);
    final textDirection = Directionality.of(context);
    return Semantics(
      key: const ValueKey('code-lock-semantics'),
      container: true,
      explicitChildNodes: true,
      label: widget.semanticLabel,
      value: _solved ? copy.solved : copy.progress(_round + 1, _targets.length),
      textDirection: textDirection,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: AnimatedBuilder(
            animation: Listenable.merge([_error, _success]),
            builder: (context, child) {
              final shake =
                  math.sin(_error.value * math.pi * 7) * (1 - _error.value) * 6;
              return Transform.translate(
                  offset: Offset(shake, 0), child: child);
            },
            child: Container(
              key: const ValueKey('code-lock-board'),
              width: 328,
              height: widget.compact ? 176 : 192,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F8FF), Color(0xFFFFF0C8)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: (_wrong
                          ? AppPalette.coral
                          : _solved
                              ? AppPalette.mint
                              : widget.accent)
                      .withValues(alpha: 0.55),
                  width: _wrong || _solved ? 2.4 : 1.2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _solved ? Icons.lock_open_rounded : Icons.lock_rounded,
                        color: _solved ? AppPalette.mint : widget.accent,
                        size: 25,
                      ),
                      const Spacer(),
                      for (var index = 0; index < _targets.length; index++)
                        Container(
                          width: 30,
                          height: 8,
                          margin: const EdgeInsetsDirectional.only(start: 6),
                          decoration: BoxDecoration(
                            color: index < _round || _solved
                                ? AppPalette.mint
                                : index == _round
                                    ? widget.accent
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CodeHintPill(label: '=', color: AppPalette.sky),
                      SizedBox(width: 29),
                      _CodeHintPill(label: '+2', color: AppPalette.teal),
                      SizedBox(width: 29),
                      _CodeHintPill(label: 'x2', color: AppPalette.coral),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var index = 0; index < 3; index++) ...[
                        _CodeDial(
                          index: index,
                          value: _values[index],
                          copy: copy,
                          textDirection: textDirection,
                          accent: index == 0
                              ? AppPalette.sky
                              : index == 1
                                  ? AppPalette.teal
                                  : AppPalette.coral,
                          solved: _solved,
                          onUp: () => _turn(index, 1),
                          onDown: () => _turn(index, -1),
                        ),
                        if (index < 2)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF7890A7),
                              size: 18,
                            ),
                          ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  Semantics(
                    button: true,
                    enabled: !_solved,
                    label: copy.check,
                    hint: copy.checkHint,
                    textDirection: textDirection,
                    onTap: _solved ? null : _check,
                    child: ExcludeSemantics(
                      child: GestureDetector(
                        key: const ValueKey('code-lock-check'),
                        onTap: _check,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 82,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _solved ? AppPalette.mint : widget.accent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: widget.accent.withValues(alpha: 0.24),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            _solved
                                ? Icons.lock_open_rounded
                                : Icons.key_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

class _CodeDial extends StatelessWidget {
  const _CodeDial({
    required this.index,
    required this.value,
    required this.copy,
    required this.textDirection,
    required this.accent,
    required this.solved,
    required this.onUp,
    required this.onDown,
  });

  final int index;
  final int value;
  final _CodeLockA11yCopy copy;
  final TextDirection textDirection;
  final Color accent;
  final bool solved;
  final VoidCallback onUp;
  final VoidCallback onDown;

  @override
  Widget build(BuildContext context) {
    final color = solved ? AppPalette.mint : accent;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CodeDialButton(
          key: ValueKey('code-lock-dial-$index-up'),
          icon: Icons.keyboard_arrow_up_rounded,
          color: color,
          semanticLabel: copy.increaseLabel(index),
          semanticHint: copy.adjustHint,
          textDirection: textDirection,
          onTap: onUp,
        ),
        Semantics(
          label: copy.dialLabel(index),
          value: '$value',
          textDirection: textDirection,
          child: ExcludeSemantics(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 48,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                key: ValueKey('code-lock-dial-$index-value'),
                '$value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        _CodeDialButton(
          key: ValueKey('code-lock-dial-$index-down'),
          icon: Icons.keyboard_arrow_down_rounded,
          color: color,
          semanticLabel: copy.decreaseLabel(index),
          semanticHint: copy.adjustHint,
          textDirection: textDirection,
          onTap: onDown,
        ),
      ],
    );
  }
}

class _CodeDialButton extends StatelessWidget {
  const _CodeDialButton({
    required this.icon,
    required this.color,
    required this.semanticLabel,
    required this.semanticHint,
    required this.textDirection,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String semanticLabel;
  final String semanticHint;
  final TextDirection textDirection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      hint: semanticHint,
      textDirection: textDirection,
      onTap: onTap,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 42,
            height: 16,
            child: Icon(icon, color: color, size: 21),
          ),
        ),
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
              color: found ? accent : Colors.transparent,
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
          colors: [Color(0xFFBDEFFF), Color(0xFFFFF0C9)],
        ).createShader(rect),
    );

    _drawCloud(canvas, Offset(size.width * 0.18, size.height * 0.19), 0.72);
    _drawCloud(canvas, Offset(size.width * 0.74, size.height * 0.15), 0.50);
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.26),
      13,
      Paint()..color = const Color(0xFFFFD46B).withValues(alpha: 0.72),
    );

    final farHill = Path()
      ..moveTo(0, size.height * 0.64)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.42,
          size.width * 0.56, size.height * 0.63)
      ..quadraticBezierTo(
          size.width * 0.78, size.height * 0.78, size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      farHill,
      Paint()..color = const Color(0xFF9FE4C5).withValues(alpha: 0.60),
    );

    final nearHill = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.34, size.height * 0.64,
          size.width * 0.62, size.height * 0.76)
      ..quadraticBezierTo(
          size.width * 0.86, size.height * 0.88, size.width, size.height * 0.72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(nearHill, Paint()..color = const Color(0xFFBFF0B9));

    _drawTree(canvas, Offset(size.width * 0.08, size.height * 0.50), 0.72);
    _drawTree(canvas, Offset(size.width * 0.94, size.height * 0.53), 0.58);
    _drawCharacter(canvas, Offset(size.width * 0.20, size.height * 0.68));

    final tent = Path()
      ..moveTo(size.width * 0.23, size.height * 0.78)
      ..lineTo(size.width * 0.48, size.height * 0.33)
      ..lineTo(size.width * 0.74, size.height * 0.78)
      ..close();
    canvas.drawPath(
      tent.shift(const Offset(0, 5)),
      Paint()..color = AppPalette.ink.withValues(alpha: 0.08),
    );
    canvas.drawPath(tent, Paint()..color = const Color(0xFF8278FF));
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.48, size.height * 0.78)
        ..lineTo(size.width * 0.60, size.height * 0.78)
        ..lineTo(size.width * 0.48, size.height * 0.49)
        ..close(),
      Paint()..color = Colors.white.withValues(alpha: 0.80),
    );
    canvas.drawLine(
      Offset(size.width * 0.48, size.height * 0.33),
      Offset(size.width * 0.48, size.height * 0.78),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.42)
        ..strokeWidth = 2,
    );

    final flagColor = variant == 0 ? AppPalette.coral : AppPalette.teal;
    canvas.drawLine(
      Offset(size.width * 0.33, size.height * 0.31),
      Offset(size.width * 0.33, size.height * 0.14),
      Paint()
        ..color = AppPalette.ink.withValues(alpha: 0.52)
        ..strokeWidth = 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.33, size.height * 0.14, 24, 15),
        const Radius.circular(4),
      ),
      Paint()..color = flagColor,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.70,
          size.height * 0.76,
          size.width * 0.18,
          size.height * 0.08,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF8D5A35),
    );

    final flameCenter = Offset(size.width * 0.79, size.height * 0.67);
    _drawFire(canvas, flameCenter);

    final starCenter = variant == 0
        ? Offset(size.width * 0.88, size.height * 0.51)
        : Offset(size.width * 0.88, size.height * 0.65);
    _drawTinyStar(
        canvas, starCenter, variant == 0 ? AppPalette.mango : Colors.white);
  }

  void _drawCloud(Canvas canvas, Offset center, double scale) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.78);
    canvas.drawCircle(
        center.translate(-15 * scale, 2 * scale), 9 * scale, paint);
    canvas.drawCircle(center, 13 * scale, paint);
    canvas.drawCircle(
        center.translate(16 * scale, 3 * scale), 8 * scale, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, 8 * scale),
          width: 42 * scale,
          height: 12 * scale,
        ),
        Radius.circular(9 * scale),
      ),
      paint,
    );
  }

  void _drawTree(Canvas canvas, Offset base, double scale) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            base.dx - 4 * scale, base.dy - 25 * scale, 8 * scale, 31 * scale),
        Radius.circular(4 * scale),
      ),
      Paint()..color = const Color(0xFF8D5A35),
    );
    final leafPaint = Paint()..color = const Color(0xFF48BFA4);
    canvas.drawCircle(
        base.translate(-10 * scale, -28 * scale), 15 * scale, leafPaint);
    canvas.drawCircle(
        base.translate(7 * scale, -34 * scale), 17 * scale, leafPaint);
    canvas.drawCircle(
        base.translate(18 * scale, -22 * scale), 13 * scale, leafPaint);
  }

  void _drawCharacter(Canvas canvas, Offset center) {
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 25, height: 30),
      Paint()..color = const Color(0xFF57CDBB),
    );
    canvas.drawCircle(
        center.translate(-7, -6), 3, Paint()..color = Colors.white);
    canvas.drawCircle(
        center.translate(7, -6), 3, Paint()..color = Colors.white);
    canvas.drawCircle(
        center.translate(-7, -6), 1.4, Paint()..color = AppPalette.ink);
    canvas.drawCircle(
        center.translate(7, -6), 1.4, Paint()..color = AppPalette.ink);
    canvas.drawArc(
      Rect.fromCenter(center: center.translate(0, 4), width: 12, height: 8),
      0,
      math.pi,
      false,
      Paint()
        ..color = AppPalette.ink.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  void _drawFire(Canvas canvas, Offset center) {
    canvas.drawOval(
      Rect.fromCenter(center: center.translate(0, 8), width: 38, height: 12),
      Paint()..color = const Color(0xFF8D5A35),
    );
    final outer = Path()
      ..moveTo(center.dx, center.dy - 18)
      ..cubicTo(center.dx - 16, center.dy - 3, center.dx - 12, center.dy + 14,
          center.dx, center.dy + 14)
      ..cubicTo(center.dx + 13, center.dy + 11, center.dx + 15, center.dy - 2,
          center.dx, center.dy - 18);
    canvas.drawPath(outer, Paint()..color = AppPalette.coral);
    final inner = Path()
      ..moveTo(center.dx + 1, center.dy - 9)
      ..cubicTo(center.dx - 7, center.dy, center.dx - 5, center.dy + 9,
          center.dx + 1, center.dy + 9)
      ..cubicTo(center.dx + 8, center.dy + 7, center.dx + 9, center.dy,
          center.dx + 1, center.dy - 9);
    canvas.drawPath(inner, Paint()..color = AppPalette.mango);
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
    required this.onAnswerSelected,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final customStage = _customMathStageFor(
      puzzle.id,
      accent,
      compact,
      answerRuleForPuzzle(puzzle).correctAnswer,
      context.l10n.puzzleTitle(puzzle),
      onAnswerSelected,
    );

    if (customStage != null) {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: customStage,
      );
    }

    final children = _mathStageItemsFor(puzzle.id, accent, compact);

    return _StageShell(
      key: genericPuzzleSceneFallbackKey,
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

Widget? _customMathStageFor(
  String puzzleId,
  Color accent,
  bool compact,
  String correctAnswer,
  String semanticLabel,
  ValueChanged<String> onAnswerSelected,
) {
  return switch (puzzleId) {
    'fruit-fizz' => _FruitFizzStage(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        onAnswerSelected: onAnswerSelected,
      ),
    'moon-clock' => MoonClockGameView(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        semanticLabel: semanticLabel,
        onAnswerSelected: onAnswerSelected,
      ),
    'notebook-sum' => NotebookSumWorkshopGameView(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        semanticLabel: semanticLabel,
        onAnswerSelected: onAnswerSelected,
      ),
    'cookie-share' => _CookieShareStage(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        onAnswerSelected: onAnswerSelected,
      ),
    'math-crossword' => MathCrosswordWorkshopGameView(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        semanticLabel: semanticLabel,
        onAnswerSelected: onAnswerSelected,
      ),
    'market-change' => MarketChangeWorkshopGameView(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        semanticLabel: semanticLabel,
        onAnswerSelected: onAnswerSelected,
      ),
    'number-bridge' => NumberBridgeReasoningGameView(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        semanticLabel: semanticLabel,
        onAnswerSelected: onAnswerSelected,
      ),
    'star-balance' => StarBalanceReasoningGameView(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        semanticLabel: semanticLabel,
        onAnswerSelected: onAnswerSelected,
      ),
    'count-rockets' => _CountRocketsGameStage(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        onAnswerSelected: onAnswerSelected,
      ),
    'number-neighbors' => NumberNeighborsReasoningGameView(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        semanticLabel: semanticLabel,
        onAnswerSelected: onAnswerSelected,
      ),
    'planet-sum' => _PlanetSumGameStage(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        onAnswerSelected: onAnswerSelected,
      ),
    'cube-groups' => _CubeGroupsGameStage(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        onAnswerSelected: onAnswerSelected,
      ),
    'more-less' => _MoreLessGameStage(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        onAnswerSelected: onAnswerSelected,
      ),
    'sticker-shop' => _StickerShopGameStage(
        accent: accent,
        compact: compact,
        correctAnswer: correctAnswer,
        onAnswerSelected: onAnswerSelected,
      ),
    _ => null,
  };
}

class _FruitFizzStage extends StatefulWidget {
  const _FruitFizzStage({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_FruitFizzStage> createState() => _FruitFizzStageState();
}

class _FruitFizzStageState extends State<_FruitFizzStage> {
  static const _rounds =
      <({int first, int second, int total, List<int> options})>[
    (first: 3, second: 2, total: 8, options: [2, 3, 4]),
    (first: 2, second: 4, total: 7, options: [1, 2, 3]),
    (first: 4, second: 1, total: 9, options: [3, 4, 5]),
  ];

  int _round = 0;
  int? _wrongValue;
  bool _submitted = false;

  void _choose(int value) {
    if (_submitted) return;
    final task = _rounds[_round];
    if (value != task.total - task.first - task.second) {
      HapticFeedback.lightImpact();
      setState(() => _wrongValue = value);
      return;
    }

    HapticFeedback.selectionClick();
    if (_round < _rounds.length - 1) {
      setState(() {
        _round++;
        _wrongValue = null;
      });
    } else {
      _submitted = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _rounds[_round];
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 118 : 136,
          child: Column(
            children: [
              Row(
                children: [
                  _RoundProgressDots(
                    current: _round,
                    total: _rounds.length,
                    color: widget.accent,
                  ),
                  const Spacer(),
                  Text(
                    '${task.first} + ${task.second} + ? = ${task.total}',
                    key: const ValueKey('fruit-fizz-equation'),
                    style: const TextStyle(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF4D9), Color(0xFFE5F8F4)],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 92,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const _FruitDot(color: AppPalette.teal),
                            Transform.translate(
                              offset: const Offset(-24, 18),
                              child:
                                  const _FruitDot(color: AppPalette.lavender),
                            ),
                            Transform.translate(
                              offset: const Offset(24, 18),
                              child: const _FruitDot(color: AppPalette.mango),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      for (final value in task.options) ...[
                        _MathChoiceToken(
                          key: ValueKey('fruit-fizz-choice-$_round-$value'),
                          value: value,
                          color: AppPalette.mango,
                          wrong: _wrongValue == value,
                          onTap: () => _choose(value),
                        ),
                        const SizedBox(width: 7),
                      ],
                    ],
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

class _RoundProgressDots extends StatelessWidget {
  const _RoundProgressDots({
    required this.current,
    required this.total,
    required this.color,
  });

  final int current;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          total,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: index == current ? 18 : 7,
            height: 7,
            margin: const EdgeInsetsDirectional.only(end: 4),
            decoration: BoxDecoration(
              color: index <= current ? color : color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      );
}

class _MathChoiceToken extends StatelessWidget {
  const _MathChoiceToken({
    required this.value,
    required this.color,
    required this.wrong,
    required this.onTap,
    super.key,
  });

  final int value;
  final Color color;
  final bool wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: '$value',
        child: BouncyTap(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 48,
            height: 48,
            alignment: Alignment.center,
            transform: Matrix4.translationValues(wrong ? 4 : 0, 0, 0),
            decoration: BoxDecoration(
              color: wrong ? AppPalette.coral : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: wrong ? AppPalette.coral : color.withValues(alpha: .5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: .16),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              '$value',
              style: TextStyle(
                color: wrong ? Colors.white : AppPalette.ink,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
}

// Retained as visual building blocks for future recipe variants.
// ignore: unused_element
class _FruitFizzDraggable extends StatelessWidget {
  const _FruitFizzDraggable({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const visual = _FruitFizzToken(lifted: false);

    return Draggable<int>(
      data: 1,
      feedback: const Material(
        color: Colors.transparent,
        child: _FruitFizzToken(lifted: true),
      ),
      childWhenDragging: const Opacity(opacity: 0.35, child: visual),
      child: BouncyTap(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: visual,
      ),
    );
  }
}

class _FruitFizzToken extends StatelessWidget {
  const _FruitFizzToken({required this.lifted});

  final bool lifted;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: lifted ? 1.18 : 1,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppPalette.mango,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.4),
          boxShadow: [
            BoxShadow(
              color: AppPalette.mango.withValues(alpha: lifted ? 0.30 : 0.16),
              blurRadius: lifted ? 16 : 9,
              offset: Offset(0, lifted ? 8 : 5),
            ),
          ],
        ),
        child: Align(
          alignment: const Alignment(-0.35, -0.35),
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.56),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _FruitDropCounter extends StatelessWidget {
  const _FruitDropCounter({
    required this.value,
    required this.target,
    required this.color,
  });

  final int value;
  final int target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final complete = value >= target;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: complete ? AppPalette.mint : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: complete ? AppPalette.teal : color.withValues(alpha: 0.30),
        ),
      ),
      child: Text(
        '$value/$target',
        style: TextStyle(
          color: complete ? AppPalette.teal : color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ignore: unused_element
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

// ignore: unused_element
class _BlenderPainter extends CustomPainter {
  const _BlenderPainter(
    this.accent, {
    required this.addedMango,
    required this.active,
  });

  final Color accent;
  final int addedMango;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = AppPalette.lavender;
    final glass = Paint()
      ..color = Colors.white.withValues(alpha: 0.80)
      ..style = PaintingStyle.fill;
    final glassStroke = Paint()
      ..color = (active ? AppPalette.mango : accent).withValues(alpha: 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = active ? 3.2 : 2.4;

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
    _drawFruit(canvas, size, const Offset(0.62, 0.58), AppPalette.teal);
    const mangoPositions = [
      Offset(0.49, 0.54),
      Offset(0.42, 0.61),
      Offset(0.58, 0.68),
    ];
    for (var index = 0; index < addedMango.clamp(0, 3); index++) {
      _drawFruit(canvas, size, mangoPositions[index], AppPalette.mango);
    }
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
      oldDelegate.accent != accent ||
      oldDelegate.addedMango != addedMango ||
      oldDelegate.active != active;
}

class _CookieShareStage extends StatefulWidget {
  const _CookieShareStage({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_CookieShareStage> createState() => _CookieShareStageState();
}

class _CookieShareStageState extends State<_CookieShareStage> {
  static const _rounds = <({int cookies, int plates, List<int> options})>[
    (cookies: 6, plates: 3, options: [1, 2, 3]),
    (cookies: 8, plates: 4, options: [2, 3, 4]),
    (cookies: 9, plates: 3, options: [2, 3, 4]),
  ];

  int _round = 0;
  int? _wrongValue;
  bool _submitted = false;

  void _choose(int value) {
    if (_submitted) return;
    final task = _rounds[_round];
    if (value != task.cookies ~/ task.plates) {
      HapticFeedback.lightImpact();
      setState(() => _wrongValue = value);
      return;
    }
    HapticFeedback.selectionClick();
    if (_round < _rounds.length - 1) {
      setState(() {
        _round++;
        _wrongValue = null;
      });
    } else {
      _submitted = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _rounds[_round];
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 118 : 136,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF4D9), Color(0xFFE5F8F4)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _RoundProgressDots(
                    current: _round,
                    total: _rounds.length,
                    color: widget.accent,
                  ),
                  const Spacer(),
                  Text(
                    '${task.cookies} / ${task.plates} = ?',
                    key: const ValueKey('cookie-share-equation'),
                    style: const TextStyle(
                      color: AppPalette.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          task.cookies,
                          (_) => Transform.scale(
                            scale: .72,
                            child: const _CookieDot(),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: widget.accent,
                      size: 24,
                    ),
                    SizedBox(
                      width: 70,
                      child: Wrap(
                        spacing: 3,
                        runSpacing: 3,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          task.plates,
                          (_) => Container(
                            width: 29,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: AppPalette.teal),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    for (final value in task.options) ...[
                      _MathChoiceToken(
                        key: ValueKey('cookie-share-choice-$_round-$value'),
                        value: value,
                        color: AppPalette.teal,
                        wrong: _wrongValue == value,
                        onTap: () => _choose(value),
                      ),
                      const SizedBox(width: 5),
                    ],
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

// Retained for drag-based sharing variants.
// ignore: unused_element
class _CookieDraggable extends StatelessWidget {
  const _CookieDraggable({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const cookie = _CookieDot();

    return Draggable<int>(
      data: 1,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(scale: 1.16, child: cookie),
      ),
      childWhenDragging: const Opacity(opacity: 0.30, child: _CookieDot()),
      child: BouncyTap(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: cookie,
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

// ignore: unused_element
class _CookieDropPlate extends StatelessWidget {
  const _CookieDropPlate({
    required this.count,
    required this.target,
    required this.color,
    required this.onAccept,
  });

  final int count;
  final int target;
  final Color color;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final complete = count == target;

    return DragTarget<int>(
      onWillAcceptWithDetails: (_) => !complete,
      onAcceptWithDetails: (_) => onAccept(),
      builder: (context, candidateData, rejectedData) {
        final active = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 90,
          height: 26,
          decoration: BoxDecoration(
            color: complete ? AppPalette.mint : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: complete
                  ? AppPalette.teal
                  : active
                      ? color
                      : AppPalette.teal.withValues(alpha: 0.30),
              width: complete || active ? 2 : 1.2,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 0; index < count; index++)
                Transform.scale(scale: 0.46, child: const _CookieDot()),
              if (count == 0)
                Text(
                  '$count/$target',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CountRocketsGameStage extends StatefulWidget {
  const _CountRocketsGameStage({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_CountRocketsGameStage> createState() => _CountRocketsGameStageState();
}

class _CountRocketsGameStageState extends State<_CountRocketsGameStage> {
  final Set<int> _counted = {};
  bool _submitted = false;

  void _mark(int index) {
    if (_counted.contains(index)) {
      return;
    }

    setState(() => _counted.add(index));
    if (!_submitted && _counted.length == 6) {
      _submitted = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 116 : 132,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF262A66), Color(0xFF39689E)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 9,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var index = 0; index < 6; index++)
                      _RocketCounterToken(
                        key: ValueKey('count-rockets-token-$index'),
                        counted: _counted.contains(index),
                        color:
                            index.isEven ? AppPalette.coral : AppPalette.mango,
                        onTap: () => _mark(index),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 68,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: (_counted.length == 6
                            ? AppPalette.mint
                            : AppPalette.mango)
                        .withValues(alpha: 0.48),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: _counted.length == 6
                          ? AppPalette.teal
                          : AppPalette.muted,
                      size: 22,
                    ),
                    Text(
                      '${_counted.length}',
                      style: const TextStyle(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        height: 1,
                      ),
                    ),
                    const Text(
                      '/ 6',
                      style: TextStyle(
                        color: AppPalette.muted,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
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

class _RocketCounterToken extends StatelessWidget {
  const _RocketCounterToken({
    required this.counted,
    required this.color,
    required this.onTap,
    super.key,
  });

  final bool counted;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: counted ? 0.48 : 1,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: counted ? 0.86 : 1,
          child: SizedBox(
            width: 40,
            height: 48,
            child: CustomPaint(
              painter: _TinyRocketPainter(color: color, counted: counted),
            ),
          ),
        ),
      ),
    );
  }
}

class _TinyRocketPainter extends CustomPainter {
  const _TinyRocketPainter({required this.color, required this.counted});

  final Color color;
  final bool counted;

  @override
  void paint(Canvas canvas, Size size) {
    final shadow = Paint()..color = Colors.black.withValues(alpha: 0.12);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.90),
        width: size.width * 0.62,
        height: size.height * 0.12,
      ),
      shadow,
    );

    final body = Path()
      ..moveTo(size.width * 0.50, size.height * 0.04)
      ..cubicTo(
        size.width * 0.88,
        size.height * 0.24,
        size.width * 0.78,
        size.height * 0.72,
        size.width * 0.50,
        size.height * 0.78,
      )
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.72,
        size.width * 0.12,
        size.height * 0.24,
        size.width * 0.50,
        size.height * 0.04,
      );
    canvas.drawPath(body, Paint()..color = counted ? AppPalette.muted : color);

    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.34),
      size.width * 0.15,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.34),
      size.width * 0.09,
      Paint()..color = AppPalette.sky,
    );

    final leftFin = Path()
      ..moveTo(size.width * 0.28, size.height * 0.60)
      ..lineTo(size.width * 0.06, size.height * 0.82)
      ..lineTo(size.width * 0.36, size.height * 0.75)
      ..close();
    final rightFin = Path()
      ..moveTo(size.width * 0.72, size.height * 0.60)
      ..lineTo(size.width * 0.94, size.height * 0.82)
      ..lineTo(size.width * 0.64, size.height * 0.75)
      ..close();
    canvas
      ..drawPath(leftFin, Paint()..color = AppPalette.lavender)
      ..drawPath(rightFin, Paint()..color = AppPalette.lavender);

    if (!counted) {
      final flame = Path()
        ..moveTo(size.width * 0.50, size.height * 0.82)
        ..lineTo(size.width * 0.36, size.height)
        ..lineTo(size.width * 0.64, size.height)
        ..close();
      canvas.drawPath(flame, Paint()..color = AppPalette.mango);
    }
  }

  @override
  bool shouldRepaint(covariant _TinyRocketPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.counted != counted;
}

class _PlanetSumGameStage extends StatefulWidget {
  const _PlanetSumGameStage({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_PlanetSumGameStage> createState() => _PlanetSumGameStageState();
}

class _PlanetSumGameStageState extends State<_PlanetSumGameStage> {
  static const _rounds = <({int left, int right, List<int> options})>[
    (left: 2, right: 3, options: [4, 5, 6]),
    (left: 4, right: 2, options: [5, 6, 7]),
    (left: 3, right: 5, options: [7, 8, 9]),
  ];

  int _round = 0;
  int? _wrongValue;
  bool _submitted = false;

  void _choose(int value) {
    if (_submitted) return;
    final task = _rounds[_round];
    if (value != task.left + task.right) {
      HapticFeedback.lightImpact();
      setState(() => _wrongValue = value);
      return;
    }
    HapticFeedback.selectionClick();
    if (_round < _rounds.length - 1) {
      setState(() {
        _round++;
        _wrongValue = null;
      });
    } else {
      _submitted = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _rounds[_round];
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: widget.compact ? 286 : 328,
          height: widget.compact ? 112 : 128,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEAF4FF), Color(0xFFFFF2CC)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _RoundProgressDots(
                    current: _round,
                    total: _rounds.length,
                    color: widget.accent,
                  ),
                  const Spacer(),
                  Text(
                    '${task.left} + ${task.right} = ?',
                    key: const ValueKey('planet-sum-equation'),
                    style: const TextStyle(
                      color: AppPalette.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Row(
                  children: [
                    const _OrbitPlanet(
                      color: AppPalette.coral,
                      x: 0,
                      y: 0,
                      size: 42,
                    ),
                    Container(
                      width: 26,
                      height: 2,
                      color: widget.accent.withValues(alpha: .35),
                    ),
                    const _OrbitPlanet(
                      color: AppPalette.sky,
                      x: 0,
                      y: 0,
                      size: 34,
                    ),
                    const Spacer(),
                    for (final value in task.options) ...[
                      _MathChoiceToken(
                        key: ValueKey('planet-sum-choice-$_round-$value'),
                        value: value,
                        color: AppPalette.sky,
                        wrong: _wrongValue == value,
                        onTap: () => _choose(value),
                      ),
                      const SizedBox(width: 6),
                    ],
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

class _OrbitPlanet extends StatelessWidget {
  const _OrbitPlanet({
    required this.color,
    required this.x,
    required this.y,
    required this.size,
  });

  final Color color;
  final double x;
  final double y;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withValues(alpha: 0.86), color],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.24),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _PlanetDraggable extends StatelessWidget {
  const _PlanetDraggable({required this.hidden, required this.onTap});

  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const planet = _OrbitPlanet(
      color: AppPalette.teal,
      x: 0,
      y: 0,
      size: 32,
    );

    if (hidden) {
      return const Opacity(opacity: 0.22, child: planet);
    }

    return Draggable<int>(
      data: 1,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(scale: 1.12, child: planet),
      ),
      childWhenDragging: const Opacity(opacity: 0.24, child: planet),
      child: BouncyTap(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: planet,
      ),
    );
  }
}

class _CubeGroupsGameStage extends StatefulWidget {
  const _CubeGroupsGameStage({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_CubeGroupsGameStage> createState() => _CubeGroupsGameStageState();
}

class _CubeGroupsGameStageState extends State<_CubeGroupsGameStage> {
  final List<int> _left = [];
  final List<int> _right = [];
  bool _submitted = false;

  void _place(int cube, bool left) {
    if (_left.contains(cube) || _right.contains(cube)) return;
    setState(() => (left ? _left : _right).add(cube));
    if (!_submitted && _left.length == 2 && _right.length == 2) {
      _submitted = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubeSize = widget.compact ? 34.0 : 40.0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: widget.compact ? 132 : 150,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: _CubeBasket(
                    key: const ValueKey('cube-groups-left'),
                    color: AppPalette.sky,
                    cubes: _left,
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _CubeBasket(
                    key: const ValueKey('cube-groups-right'),
                    color: AppPalette.lavender,
                    cubes: _right,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final placed = _left.contains(index) || _right.contains(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Opacity(
                    opacity: placed ? 0.15 : 1,
                    child: Draggable<int>(
                      key: ValueKey('cube-groups-cube-$index'),
                      data: index,
                      maxSimultaneousDrags: placed ? 0 : 1,
                      feedback: Material(
                        color: Colors.transparent,
                        child: _ToyCube(
                            size: cubeSize + 4,
                            color: index.isEven
                                ? AppPalette.sky
                                : AppPalette.lavender),
                      ),
                      childWhenDragging:
                          SizedBox(width: cubeSize, height: cubeSize),
                      child: _ToyCube(
                          size: cubeSize,
                          color: index.isEven
                              ? AppPalette.sky
                              : AppPalette.lavender),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CubeBasket extends StatelessWidget {
  const _CubeBasket({
    required this.color,
    required this.cubes,
    super.key,
  });

  final Color color;
  final List<int> cubes;

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (_) => cubes.length < 2,
      onAcceptWithDetails: (details) {
        final state =
            context.findAncestorStateOfType<_CubeGroupsGameStageState>();
        state?._place(details.data, color == AppPalette.sky);
      },
      builder: (context, candidates, rejected) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: candidates.isNotEmpty
              ? color.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: color.withValues(alpha: 0.55),
              width: candidates.isNotEmpty ? 3 : 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8)))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: cubes
                  .map((id) => Padding(
                        padding: const EdgeInsets.all(3),
                        child: _ToyCube(
                            size: 34,
                            color: id.isEven
                                ? AppPalette.sky
                                : AppPalette.lavender),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToyCube extends StatelessWidget {
  const _ToyCube({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, color.withValues(alpha: 0.9)]),
          borderRadius: BorderRadius.circular(size * 0.25),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Align(
          alignment: const Alignment(-0.35, -0.35),
          child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  shape: BoxShape.circle)),
        ),
      );
}

class _MoreLessGameStage extends StatefulWidget {
  const _MoreLessGameStage(
      {required this.accent,
      required this.compact,
      required this.correctAnswer,
      required this.onAnswerSelected});
  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_MoreLessGameStage> createState() => _MoreLessGameStageState();
}

class _MoreLessGameStageState extends State<_MoreLessGameStage> {
  final Set<int> _paired = {};
  bool _submitted = false;

  void _pair(int item, int target) {
    if (item != target || _paired.contains(item)) return;
    setState(() => _paired.add(item));
  }

  void _finish() {
    if (_paired.length != 3 || _submitted) return;
    _submitted = true;
    widget.onAnswerSelected(widget.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.compact ? 132 : 150,
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 7,
              runSpacing: 8,
              children: List.generate(4, (index) {
                final paired = _paired.contains(index);
                final extra = index == 3;
                final ready = extra && _paired.length == 3;
                final token = _PairingToken(
                  color: AppPalette.teal,
                  paired: paired,
                  ready: ready,
                );
                if (extra) {
                  return BouncyTap(
                    key: const ValueKey('more-less-finish'),
                    borderRadius: BorderRadius.circular(22),
                    onTap: ready ? _finish : null,
                    child: token,
                  );
                }
                return Opacity(
                  opacity: paired ? 0.2 : 1,
                  child: Draggable<int>(
                    key: ValueKey('more-less-item-$index'),
                    data: index,
                    maxSimultaneousDrags: paired ? 0 : 1,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Transform.scale(scale: 1.12, child: token),
                    ),
                    childWhenDragging: const SizedBox(width: 44, height: 44),
                    child: token,
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.arrow_forward_rounded,
                color: widget.accent, size: 30),
          ),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 7,
              runSpacing: 8,
              children: List.generate(3, (index) {
                return DragTarget<int>(
                  key: ValueKey('more-less-target-$index'),
                  onWillAcceptWithDetails: (details) =>
                      details.data == index && !_paired.contains(index),
                  onAcceptWithDetails: (details) => _pair(details.data, index),
                  builder: (context, candidates, rejected) => _PairingTarget(
                    color: AppPalette.lavender,
                    filled: _paired.contains(index),
                    active: candidates.isNotEmpty,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _PairingToken extends StatelessWidget {
  const _PairingToken({
    required this.color,
    required this.paired,
    required this.ready,
  });

  final Color color;
  final bool paired;
  final bool ready;

  @override
  Widget build(BuildContext context) => AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: ready ? 1.14 : 1,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, color.withValues(alpha: 0.55)]),
            shape: BoxShape.circle,
            border: Border.all(
                color: ready ? AppPalette.mango : color.withValues(alpha: 0.45),
                width: ready ? 3 : 1.5),
            boxShadow: [
              BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: ready ? 14 : 7,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Icon(paired ? Icons.check_rounded : Icons.star_rounded,
              color: paired ? AppPalette.teal : color, size: 23),
        ),
      );
}

class _PairingTarget extends StatelessWidget {
  const _PairingTarget({
    required this.color,
    required this.filled,
    required this.active,
  });

  final Color color;
  final bool filled;
  final bool active;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: filled
              ? color.withValues(alpha: 0.65)
              : Colors.white.withValues(alpha: active ? 0.95 : 0.55),
          shape: BoxShape.circle,
          border: Border.all(
              color: active ? AppPalette.teal : color.withValues(alpha: 0.5),
              width: active ? 3 : 2),
        ),
        child: Icon(filled ? Icons.check_rounded : Icons.star_border_rounded,
            color: filled ? Colors.white : color.withValues(alpha: 0.7),
            size: 23),
      );
}

class _StickerShopGameStage extends StatefulWidget {
  const _StickerShopGameStage(
      {required this.accent,
      required this.compact,
      required this.correctAnswer,
      required this.onAnswerSelected});
  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_StickerShopGameStage> createState() => _StickerShopGameStageState();
}

class _StickerShopGameStageState extends State<_StickerShopGameStage> {
  static const _rounds = <({int coins, int price, List<int> options})>[
    (coins: 6, price: 2, options: [2, 3, 4]),
    (coins: 8, price: 2, options: [3, 4, 5]),
    (coins: 9, price: 3, options: [2, 3, 4]),
  ];

  int _round = 0;
  int? _wrongValue;
  bool _submitted = false;

  void _choose(int value) {
    if (_submitted) return;
    final task = _rounds[_round];
    if (value != task.coins ~/ task.price) {
      HapticFeedback.lightImpact();
      setState(() => _wrongValue = value);
      return;
    }
    HapticFeedback.selectionClick();
    if (_round < _rounds.length - 1) {
      setState(() {
        _round++;
        _wrongValue = null;
      });
    } else {
      _submitted = true;
      widget.onAnswerSelected(widget.correctAnswer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = _rounds[_round];
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: widget.compact ? 132 : 150,
        child: Column(
          children: [
            Row(
              children: [
                _RoundProgressDots(
                  current: _round,
                  total: _rounds.length,
                  color: widget.accent,
                ),
                const Spacer(),
                Text(
                  '${task.coins} / ${task.price} = ?',
                  key: const ValueKey('sticker-shop-equation'),
                  style: const TextStyle(
                    color: AppPalette.ink,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 3,
                      runSpacing: 3,
                      children: List.generate(
                        task.coins,
                        (index) => Container(
                          width: 23,
                          height: 23,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppPalette.mango,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded,
                      color: widget.accent, size: 30),
                  const SizedBox(width: 8),
                  const _StickerPack(size: 58),
                  const SizedBox(width: 8),
                  for (final value in task.options) ...[
                    _MathChoiceToken(
                      key: ValueKey('sticker-shop-choice-$_round-$value'),
                      value: value,
                      color: AppPalette.coral,
                      wrong: _wrongValue == value,
                      onTap: () => _choose(value),
                    ),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickerPack extends StatelessWidget {
  const _StickerPack({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFFFE7A2), Color(0xFFFFA9C2)]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
                color: AppPalette.coral.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: const Icon(Icons.auto_awesome_rounded,
            color: Colors.white, size: 30),
      );
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

class _ConstellationA11yCopy {
  const _ConstellationA11yCopy({
    required this.star,
    required this.map,
    required this.routeProgress,
    required this.hint,
    required this.solved,
  });

  final String star;
  final String map;
  final String routeProgress;
  final String hint;
  final String solved;

  String value(int starIndex, int round, int progress, int routeLength) =>
      '$star ${starIndex + 1}. $map ${round + 1} / 3. '
      '$routeProgress ${math.max(0, progress + 1)} / $routeLength';

  static _ConstellationA11yCopy of(BuildContext context) =>
      _copies[Localizations.localeOf(context).languageCode] ?? _copies['en']!;

  static const _copies = <String, _ConstellationA11yCopy>{
    'ar': _ConstellationA11yCopy(
        star: 'نجمة',
        map: 'خريطة',
        routeProgress: 'تقدم المسار',
        hint: 'اسحب لأعلى أو لأسفل لاختيار نجمة، ثم انقر لإضافتها إلى المسار',
        solved: 'اكتملت الخرائط الثلاث'),
    'de': _ConstellationA11yCopy(
        star: 'Stern',
        map: 'Karte',
        routeProgress: 'Routenfortschritt',
        hint:
            'Wische nach oben oder unten, um einen Stern zu wählen, und tippe zum Hinzufügen',
        solved: 'Alle drei Karten abgeschlossen'),
    'en': _ConstellationA11yCopy(
        star: 'Star',
        map: 'Map',
        routeProgress: 'Route progress',
        hint:
            'Swipe up or down to choose a star, then tap to add it to the route',
        solved: 'All three maps completed'),
    'es': _ConstellationA11yCopy(
        star: 'Estrella',
        map: 'Mapa',
        routeProgress: 'Progreso de la ruta',
        hint:
            'Desliza arriba o abajo para elegir una estrella y toca para añadirla',
        solved: 'Se completaron los tres mapas'),
    'fr': _ConstellationA11yCopy(
        star: 'Étoile',
        map: 'Carte',
        routeProgress: 'Progression du trajet',
        hint:
            'Balaye vers le haut ou le bas pour choisir une étoile, puis touche pour l’ajouter',
        solved: 'Les trois cartes sont terminées'),
    'hi': _ConstellationA11yCopy(
        star: 'तारा',
        map: 'मानचित्र',
        routeProgress: 'मार्ग की प्रगति',
        hint:
            'तारा चुनने के लिए ऊपर या नीचे स्वाइप करें, फिर मार्ग में जोड़ने के लिए टैप करें',
        solved: 'तीनों मानचित्र पूरे हुए'),
    'it': _ConstellationA11yCopy(
        star: 'Stella',
        map: 'Mappa',
        routeProgress: 'Avanzamento percorso',
        hint:
            'Scorri su o giù per scegliere una stella, poi tocca per aggiungerla',
        solved: 'Tutte e tre le mappe completate'),
    'ja': _ConstellationA11yCopy(
        star: '星',
        map: 'マップ',
        routeProgress: 'ルートの進み具合',
        hint: '上下にスワイプして星を選び、タップしてルートに追加します',
        solved: '3つのマップを完了しました'),
    'ko': _ConstellationA11yCopy(
        star: '별',
        map: '지도',
        routeProgress: '경로 진행',
        hint: '위아래로 밀어 별을 고른 뒤 탭하여 경로에 추가하세요',
        solved: '지도 세 개를 모두 완료했습니다'),
    'pt': _ConstellationA11yCopy(
        star: 'Estrela',
        map: 'Mapa',
        routeProgress: 'Progresso da rota',
        hint:
            'Deslize para cima ou para baixo, escolha uma estrela e toque para adicioná-la',
        solved: 'Os três mapas foram concluídos'),
    'ru': _ConstellationA11yCopy(
        star: 'Звезда',
        map: 'Карта',
        routeProgress: 'Прогресс маршрута',
        hint:
            'Смахните вверх или вниз, выберите звезду и нажмите, чтобы добавить её в маршрут',
        solved: 'Все три карты пройдены'),
    'zh': _ConstellationA11yCopy(
        star: '星星',
        map: '地图',
        routeProgress: '路线进度',
        hint: '上下轻扫选择星星，然后点按将它加入路线',
        solved: '三张地图均已完成'),
  };
}

class _ConstellationRouteStage extends StatefulWidget {
  const _ConstellationRouteStage({
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
  State<_ConstellationRouteStage> createState() =>
      _ConstellationRouteStageState();
}

class _ConstellationRouteStageState extends State<_ConstellationRouteStage>
    with SingleTickerProviderStateMixin {
  static const _rounds = <_ConstellationRound>[
    _ConstellationRound(
      route: [0, 1, 3, 6, 8],
      glyphs: [0, 1, 4, 2, 3, 5, 4, 0, 5],
    ),
    _ConstellationRound(
      route: [0, 2, 4, 6, 8],
      glyphs: [0, 3, 1, 5, 2, 4, 3, 5, 0],
    ),
    _ConstellationRound(
      route: [0, 2, 5, 7, 8],
      glyphs: [0, 2, 1, 4, 3, 5, 1, 2, 0],
    ),
  ];

  late final AnimationController _error;
  int _round = 0;
  int _progress = -1;
  bool _dragging = false;
  bool _submitted = false;
  bool _transitioning = false;
  bool _answerSent = false;
  int _semanticStar = 0;

  _ConstellationRound get _spec => _rounds[_round];

  @override
  void initState() {
    super.initState();
    _error = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _error.dispose();
    super.dispose();
  }

  List<Offset> _stars(Size size) => [
        Offset(size.width * 0.10, size.height * 0.68),
        Offset(size.width * 0.27, size.height * 0.43),
        Offset(size.width * 0.27, size.height * 0.79),
        Offset(size.width * 0.45, size.height * 0.28),
        Offset(size.width * 0.48, size.height * 0.59),
        Offset(size.width * 0.49, size.height * 0.84),
        Offset(size.width * 0.68, size.height * 0.38),
        Offset(size.width * 0.72, size.height * 0.72),
        Offset(size.width * 0.90, size.height * 0.52),
      ];

  int _hitStar(Offset point, Size size) =>
      _stars(size).indexWhere((star) => (point - star).distance <= 25);

  void _start(DragStartDetails details, Size size) {
    if (_submitted || _transitioning) return;
    if (_hitStar(details.localPosition, size) != _spec.route.first) {
      _fail();
      return;
    }
    setState(() {
      _dragging = true;
      _progress = 0;
    });
  }

  void _trace(DragUpdateDetails details, Size size) {
    if (!_dragging || _submitted || _transitioning) return;
    final hit = _hitStar(details.localPosition, size);
    if (hit < 0 || hit == _spec.route[_progress]) return;
    final next = _progress + 1;
    if (next < _spec.route.length && hit == _spec.route[next]) {
      HapticFeedback.selectionClick();
      setState(() => _progress = next);
      if (next == _spec.route.length - 1) _completeRound();
      return;
    }
    _fail();
  }

  void _end(DragEndDetails details) {
    if (_submitted || _transitioning) return;
    if (_dragging && _progress != _spec.route.length - 1) _fail();
  }

  void _moveSemanticStar(int delta) {
    if (_submitted || _transitioning) return;
    HapticFeedback.selectionClick();
    setState(() => _semanticStar = (_semanticStar + delta + 9) % 9);
  }

  void _selectSemanticStar() {
    if (_submitted || _transitioning) return;
    final selected = _semanticStar;
    if (_progress < 0) {
      if (selected != _spec.route.first) {
        _fail();
        return;
      }
      setState(() => _progress = 0);
      return;
    }

    final next = _progress + 1;
    if (next < _spec.route.length && selected == _spec.route[next]) {
      HapticFeedback.selectionClick();
      setState(() => _progress = next);
      if (next == _spec.route.length - 1) _completeRound();
      return;
    }
    _fail();
  }

  void _fail() {
    HapticFeedback.lightImpact();
    setState(() {
      _dragging = false;
      _progress = -1;
      _semanticStar = 0;
    });
    _error.forward(from: 0);
  }

  void _completeRound() {
    HapticFeedback.mediumImpact();
    setState(() {
      _dragging = false;
      _transitioning = true;
    });
    if (_round < _rounds.length - 1) {
      Future<void>.delayed(const Duration(milliseconds: 420), () {
        if (!mounted) return;
        setState(() {
          _round++;
          _progress = -1;
          _semanticStar = 0;
          _transitioning = false;
        });
      });
      return;
    }
    setState(() => _submitted = true);
    Future<void>.delayed(const Duration(milliseconds: 620), () {
      if (!mounted || _answerSent) return;
      _answerSent = true;
      widget.onAnswerSelected(widget.correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final copy = _ConstellationA11yCopy.of(context);
    final textDirection = Directionality.of(context);
    return Semantics(
      key: const ValueKey('constellation-route-semantics'),
      container: true,
      excludeSemantics: true,
      label: widget.semanticLabel,
      value: _submitted
          ? copy.solved
          : copy.value(
              _semanticStar,
              _round,
              _progress,
              _spec.route.length,
            ),
      hint: copy.hint,
      textDirection: textDirection,
      increasedValue: _submitted || _transitioning
          ? null
          : copy.value(
              (_semanticStar + 1) % 9,
              _round,
              _progress,
              _spec.route.length,
            ),
      decreasedValue: _submitted || _transitioning
          ? null
          : copy.value(
              (_semanticStar + 8) % 9,
              _round,
              _progress,
              _spec.route.length,
            ),
      onIncrease:
          _submitted || _transitioning ? null : () => _moveSemanticStar(1),
      onDecrease:
          _submitted || _transitioning ? null : () => _moveSemanticStar(-1),
      onTap: _submitted || _transitioning ? null : _selectSemanticStar,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            key: const ValueKey('constellation-route-board'),
            width: 328,
            height: widget.compact ? 166 : 184,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return AnimatedBuilder(
                  animation: _error,
                  builder: (context, child) {
                    final shake = math.sin(_error.value * math.pi * 7) *
                        (1 - _error.value) *
                        5;
                    return Transform.translate(
                      offset: Offset(shake, 0),
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) => _start(details, size),
                    onPanUpdate: (details) => _trace(details, size),
                    onPanEnd: _end,
                    child: CustomPaint(
                      painter: _ConstellationPainter(
                        widget.accent,
                        round: _round,
                        spec: _spec,
                        progress: _progress,
                        solved: _submitted,
                        transitioning: _transitioning,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  const _ConstellationPainter(
    this.accent, {
    required this.round,
    required this.spec,
    required this.progress,
    required this.solved,
    required this.transitioning,
  });

  final Color accent;
  final int round;
  final _ConstellationRound spec;
  final int progress;
  final bool solved;
  final bool transitioning;

  static const _edges = <List<int>>[
    [0, 1],
    [0, 2],
    [1, 3],
    [1, 4],
    [2, 4],
    [2, 5],
    [3, 6],
    [4, 6],
    [4, 7],
    [5, 7],
    [6, 8],
    [7, 8],
  ];

  List<Offset> _stars(Size size) => [
        Offset(size.width * 0.10, size.height * 0.68),
        Offset(size.width * 0.27, size.height * 0.43),
        Offset(size.width * 0.27, size.height * 0.79),
        Offset(size.width * 0.45, size.height * 0.28),
        Offset(size.width * 0.48, size.height * 0.59),
        Offset(size.width * 0.49, size.height * 0.84),
        Offset(size.width * 0.68, size.height * 0.38),
        Offset(size.width * 0.72, size.height * 0.72),
        Offset(size.width * 0.90, size.height * 0.52),
      ];

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

    final stars = _stars(size);
    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final pathPaint = Paint()
      ..color = solved ? AppPalette.mango : AppPalette.mint
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (final edge in _edges) {
      canvas.drawLine(stars[edge[0]], stars[edge[1]], guidePaint);
    }
    for (var index = 0; index < progress; index++) {
      canvas.drawLine(
        stars[spec.route[index]],
        stars[spec.route[index + 1]],
        pathPaint,
      );
    }

    for (var index = 0; index < stars.length; index++) {
      final active = spec.route.take(progress + 1).contains(index);
      _drawGlyph(
        canvas,
        stars[index],
        spec.glyphs[index],
        active
            ? (index == spec.route.last ? AppPalette.mango : AppPalette.mint)
            : Colors.white,
        glow: active,
      );
    }

    final tokenY = size.height * 0.105;
    final routeGlyphs = [for (final index in spec.route) spec.glyphs[index]];
    final tokenStart = size.width / 2 - (routeGlyphs.length - 1) * 15.0;
    for (var index = 0; index < routeGlyphs.length; index++) {
      if (index > 0) {
        canvas.drawLine(
          Offset(tokenStart + (index - 1) * 30 + 9, tokenY),
          Offset(tokenStart + index * 30 - 9, tokenY),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.36)
            ..strokeWidth = 2,
        );
      }
      _drawGlyph(
        canvas,
        Offset(tokenStart + index * 30, tokenY),
        routeGlyphs[index],
        index <= progress ? AppPalette.mint : Colors.white,
        radius: 8,
      );
    }

    for (var index = 0; index < 3; index++) {
      canvas.drawCircle(
        Offset(size.width * 0.44 + index * 20, size.height * 0.94),
        5,
        Paint()
          ..color = index < round || solved
              ? AppPalette.mint
              : index == round
                  ? (transitioning ? AppPalette.mango : accent)
                  : Colors.white.withValues(alpha: 0.24),
      );
    }
  }

  void _drawGlyph(
    Canvas canvas,
    Offset center,
    int glyph,
    Color color, {
    bool glow = false,
    double radius = 10,
  }) {
    if (glow) {
      canvas.drawCircle(
        center,
        radius * 1.85,
        Paint()..color = color.withValues(alpha: 0.20),
      );
    }

    canvas.drawCircle(
      center,
      radius + 4,
      Paint()..color = color.withValues(alpha: 0.22),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    switch (glyph) {
      case 0:
        canvas.drawCircle(center, radius * 0.62, paint);
      case 1:
        canvas.drawRect(
          Rect.fromCenter(
            center: center,
            width: radius * 1.15,
            height: radius * 1.15,
          ),
          paint,
        );
      case 2:
        final path = Path()
          ..moveTo(center.dx, center.dy - radius * 0.72)
          ..lineTo(center.dx + radius * 0.68, center.dy + radius * 0.55)
          ..lineTo(center.dx - radius * 0.68, center.dy + radius * 0.55)
          ..close();
        canvas.drawPath(path, paint);
      case 3:
        canvas.drawLine(
          center - Offset(radius * 0.65, 0),
          center + Offset(radius * 0.65, 0),
          paint,
        );
        canvas.drawLine(
          center - Offset(0, radius * 0.65),
          center + Offset(0, radius * 0.65),
          paint,
        );
      case 4:
        final path = Path();
        for (var point = 0; point < 10; point++) {
          final r = point.isEven ? radius * 0.72 : radius * 0.32;
          final angle = -math.pi / 2 + point * math.pi / 5;
          final p = center + Offset(math.cos(angle), math.sin(angle)) * r;
          if (point == 0) {
            path.moveTo(p.dx, p.dy);
          } else {
            path.lineTo(p.dx, p.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      case 5:
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius * 0.68),
          -math.pi / 2,
          math.pi * 1.55,
          false,
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) =>
      oldDelegate.accent != accent ||
      oldDelegate.round != round ||
      oldDelegate.spec != spec ||
      oldDelegate.progress != progress ||
      oldDelegate.solved != solved ||
      oldDelegate.transitioning != transitioning;
}

class _ConstellationRound {
  const _ConstellationRound({required this.route, required this.glyphs});

  final List<int> route;
  final List<int> glyphs;
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
  const _RouteMazeStage({
    required this.accent,
    required this.compact,
    required this.correctAnswer,
    required this.onAnswerSelected,
  });

  final Color accent;
  final bool compact;
  final String correctAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  State<_RouteMazeStage> createState() => _RouteMazeStageState();
}

class _RouteMazeStageState extends State<_RouteMazeStage> {
  static const _starCell = 6;
  static const _obstacles = {1, 7, 13, 15};

  int _row = 2;
  int _col = 0;
  bool _submitted = false;

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

    if (nextCell == _starCell && !_submitted) {
      _submitted = true;
      Future<void>.delayed(const Duration(milliseconds: 420), () {
        if (mounted) widget.onAnswerSelected(widget.correctAnswer);
      });
    }
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
                      key: hero ? ValueKey('route-maze-hero-$index') : null,
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
                      key: const ValueKey('route-maze-up'),
                      icon: Icons.keyboard_arrow_up_rounded,
                      color: widget.accent,
                      onTap: () => _move(-1, 0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MazeArrowButton(
                          key: const ValueKey('route-maze-left'),
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
                          key: const ValueKey('route-maze-right'),
                          icon: Icons.keyboard_arrow_right_rounded,
                          color: AppPalette.coral,
                          onTap: () => _move(0, 1),
                        ),
                      ],
                    ),
                    _MazeArrowButton(
                      key: const ValueKey('route-maze-down'),
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
    super.key,
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
    super.key,
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
    required this.onAnswerSelected,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    if (puzzle.id == 'silhouette-build') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: SilhouetteBuildGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'shape-tower') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: ShapeTowerGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'mirror-path') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: MirrorPathGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'rocket-route') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: RocketRouteGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'arrow-maze') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: ArrowMazeGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'shape-turn') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: ShapeTurnGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'final-orbit') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: FinalOrbitGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'code-grid') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: CodeGridGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'constellation-route') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _ConstellationRouteStage(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'picture-puzzle') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: RocketAssemblyWorkshopGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'shape-tangram') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: ShapeTangramGameView(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'route-maze') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _RouteMazeStage(
          accent: accent,
          compact: compact,
          correctAnswer: answerRuleForPuzzle(puzzle).correctAnswer,
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    final spec = _pathStageSpecFor(puzzle.id, accent, compact);

    return _StageShell(
      key: genericPuzzleSceneFallbackKey,
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
    required this.onAnswerSelected,
  });

  final DailyChallenge puzzle;
  final Color accent;
  final bool compact;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    final correctAnswer = answerRuleForPuzzle(puzzle).correctAnswer;

    if (puzzle.id == 'logic-train' || puzzle.id == 'shape-path') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: PatternTrainWorkshopGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          variant: puzzle.id == 'shape-path'
              ? PatternWorkshopVariant.path
              : PatternWorkshopVariant.train,
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'bridge-order') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: BridgeOrderGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'tower-rule') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: TowerRuleGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'home-clues') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: HomeCluesGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'odd-step') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: OddStepGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'secret-code') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: SecretCodeGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'why-chain') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: WhyChainGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'space-proof') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: SpaceProofGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'mini-sudoku') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: MiniSudokuBoardGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'logic-houses') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: LogicHousesDeductionGameView(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    if (puzzle.id == 'code-lock') {
      return _StageShell(
        accent: accent,
        compact: compact,
        child: _CodeLockStage(
          accent: accent,
          compact: compact,
          correctAnswer: correctAnswer,
          semanticLabel: context.l10n.puzzleTitle(puzzle),
          onAnswerSelected: onAnswerSelected,
        ),
      );
    }

    final items = _logicStageItemsFor(puzzle.id, accent, compact);

    return _StageShell(
      key: genericPuzzleSceneFallbackKey,
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
    required this.isNarrating,
    required this.listenLabel,
    required this.stopLabel,
    required this.onNarrate,
  });

  final String prompt;
  final Color accent;
  final bool compact;
  final bool isNarrating;
  final String listenLabel;
  final String stopLabel;
  final VoidCallback onNarrate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withValues(alpha: 0.12), AppPalette.surfaceBlue],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              prompt,
              style: compact
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 10),
          Semantics(
            container: true,
            explicitChildNodes: true,
            button: true,
            label: isNarrating ? stopLabel : listenLabel,
            child: Tooltip(
              message: isNarrating ? stopLabel : listenLabel,
              child: IconButton.filled(
                onPressed: onNarrate,
                icon: Icon(
                  isNarrating ? Icons.stop_rounded : Icons.volume_up_rounded,
                ),
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  backgroundColor: Colors.white,
                  foregroundColor: accent,
                  elevation: 2,
                  shadowColor: accent.withValues(alpha: 0.22),
                ),
              ),
            ),
          ),
        ],
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
  if (RegExp(r'^\d').hasMatch(label)) {
    return Icons.looks_one_rounded;
  }

  return switch (label) {
    'STAR' || 'word_star' || 'shape_star' => Icons.star_rounded,
    'word_moon' || 'shape_moon' => Icons.nightlight_round,
    'word_sun' => Icons.wb_sunny_rounded,
    'shape_rocket' => Icons.rocket_launch_rounded,
    'house_blue' || 'house_green' || 'house_yellow' => Icons.home_rounded,
    'piece_triangle' => Icons.change_history_rounded,
    'piece_square' => Icons.square_rounded,
    'piece_circle' => Icons.circle_rounded,
    'path_A' || 'path_B' || 'path_C' => Icons.alt_route_rounded,
    'DOG' || 'CAT' || 'FOX' => Icons.pets_rounded,
    _ => Icons.touch_app_rounded,
  };
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
