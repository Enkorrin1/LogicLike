import 'package:flutter/material.dart';
import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    final daily = dailyChallengesForAge(widget.profile.childAge);
    final areas = puzzleAreasForAge(widget.profile.childAge);
    final completedToday = widget.profile.completedOn(DateTime.now());
    final completedDailyIds = _completedDailyIdsForToday(widget.profile);
    _openInitialAreaIfNeeded(context, areas, completedToday);

    return Scaffold(
      appBar: AppBar(title: const Text('Игры для мозга')),
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
            _BrainGymHeader(areasCount: areas.length),
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
                return _BrainAreaCard(
                  area: area,
                  color: _areaColor(index),
                  onTap: () {
                    _openArea(context, area, index, completedToday);
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
        _openArea(context, areas[areaIndex], areaIndex, completedToday);
      }
      widget.onInitialAreaHandled?.call();
    });
  }

  void _openArea(
    BuildContext context,
    BrainArea area,
    int areaIndex,
    bool completedToday,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _PuzzleAreaScreen(
          area: area,
          areaIndex: areaIndex,
          onStart: (puzzle, puzzleIndex) => _openPuzzle(
            context,
            puzzles: area.puzzles,
            index: puzzleIndex,
            mode: _PuzzleMode.practice,
            completedToday: completedToday,
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
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _buildPuzzlePlayScreen(
          puzzles: puzzles,
          index: index,
          mode: mode,
          completedToday: completedToday,
        ),
      ),
    );
  }

  Widget _buildPuzzlePlayScreen({
    required List<DailyChallenge> puzzles,
    required int index,
    required _PuzzleMode mode,
    required bool completedToday,
  }) {
    final puzzle = puzzles[index];
    final nextIndex = index + 1;

    return _PuzzlePlayScreen(
      puzzle: puzzle,
      number: index + 1,
      total: puzzles.length,
      mode: mode,
      completedToday: completedToday,
      nextPuzzleBuilder: nextIndex < puzzles.length
          ? () => _buildPuzzlePlayScreen(
                puzzles: puzzles,
                index: nextIndex,
                mode: mode,
                completedToday: completedToday,
              )
          : null,
      onComplete: () {
        return mode == _PuzzleMode.daily
            ? widget.onChallengeComplete(puzzle)
            : widget.onPracticeComplete(puzzle);
      },
    );
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
                          allCompleted ? 'День закрыт' : 'Миссия дня',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          allCompleted
                              ? 'Награда получена. Можно повторять или играть свободно.'
                              : 'Пройди 3 шага, чтобы сохранить серию и забрать приз.',
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
              const SizedBox(height: 14),
              for (var i = 0; i < daily.length; i++)
                Padding(
                  padding:
                      EdgeInsets.only(bottom: i == daily.length - 1 ? 0 : 10),
                  child: _DailyQuestRow(
                    puzzle: daily[i],
                    index: i,
                    completed: completedDailyIds.contains(daily[i].id),
                    onTap: () => onStart(daily[i], i),
                  ),
                ),
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
            completed ? 'приз' : '+$stars',
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
                  'Прогресс миссии',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                '$completed из $total',
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
                      'Шаг ${index + 1}',
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
                      puzzle.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      puzzle.skill,
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
                      completed ? 'еще' : '${puzzle.minutes} мин',
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
                'Тренажер мозга',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '$areasCount областей, играй в любом порядке',
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
    required this.onTap,
  });

  final BrainArea area;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                          area.title,
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
                          area.subtitle,
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
                              Icons.extension_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${area.puzzles.length} уровней',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
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

class _PuzzleAreaScreen extends StatelessWidget {
  const _PuzzleAreaScreen({
    required this.area,
    required this.areaIndex,
    required this.onStart,
  });

  final BrainArea area;
  final int areaIndex;
  final void Function(DailyChallenge puzzle, int index) onStart;

  @override
  Widget build(BuildContext context) {
    final color = _areaColor(areaIndex);

    return Scaffold(
      appBar: AppBar(title: Text(area.title)),
      body: PlayfulBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          itemCount: area.puzzles.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _AreaHero(area: area, color: color);
            }

            final puzzleIndex = index - 1;
            final puzzle = area.puzzles[puzzleIndex];
            return _FreePuzzleCard(
              puzzle: puzzle,
              levelNumber: puzzleIndex + 1,
              color: color,
              onTap: () => onStart(puzzle, puzzleIndex),
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
  });

  final BrainArea area;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
                  area.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  area.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Text(
                    '${area.puzzles.length} уровней',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
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
    required this.onTap,
  });

  final DailyChallenge puzzle;
  final int levelNumber;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BouncyTap(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: PlayfulCard(
        borderColor: color.withValues(alpha: 0.35),
        child: Row(
          children: [
            AreaCharacterBadge(
              areaId: puzzle.areaId,
              color: color.withValues(alpha: 0.20),
              size: 58,
              padding: 3,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Уровень $levelNumber',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    puzzle.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    puzzle.prompt,
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withValues(alpha: 0.72),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
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
    required this.onComplete,
    this.nextPuzzleBuilder,
  });

  final DailyChallenge puzzle;
  final int number;
  final int total;
  final _PuzzleMode mode;
  final bool completedToday;
  final Future<void> Function() onComplete;
  final Widget Function()? nextPuzzleBuilder;

  @override
  State<_PuzzlePlayScreen> createState() => _PuzzlePlayScreenState();
}

class _PuzzlePlayScreenState extends State<_PuzzlePlayScreen> {
  String? _selectedAnswer;
  bool _showHint = false;
  bool _isSubmitting = false;
  bool _showSuccessBurst = false;

  void _selectAnswer(String answer) {
    if (_isSubmitting) {
      return;
    }

    Feedback.forTap(context);
    setState(() => _selectedAnswer = answer);
  }

  Future<void> _submit() async {
    if (_selectedAnswer == null || _isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);
    await widget.onComplete();

    if (!mounted) {
      return;
    }

    setState(() => _showSuccessBurst = true);

    await Future<void>.delayed(const Duration(milliseconds: 850));

    if (!mounted) {
      return;
    }

    final nextPuzzleBuilder = widget.nextPuzzleBuilder;
    if (nextPuzzleBuilder == null) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => nextPuzzleBuilder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDaily = widget.mode == _PuzzleMode.daily;
    final accent = _areaAccentForId(widget.puzzle.areaId);
    final answerOptions = _answerOptionsFor(widget.puzzle.areaId);
    final compact = MediaQuery.sizeOf(context).height < 700;
    final hintButton = OutlinedButton.icon(
      onPressed: () => setState(() => _showHint = !_showHint),
      icon: Icon(
        _showHint
            ? Icons.visibility_off_rounded
            : Icons.tips_and_updates_rounded,
      ),
      label: Text(_showHint ? 'Скрыть подсказку' : 'Показать подсказку'),
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
      appBar: AppBar(title: Text(isDaily ? 'Задание дня' : 'Головоломка')),
      body: Stack(
        children: [
          PlayfulBackground(
            child: ListView(
              padding: EdgeInsets.fromLTRB(18, compact ? 6 : 8, 18, 96),
              children: [
                _ProgressHeader(
                  current: widget.number,
                  total: widget.total,
                  label: isDaily ? 'Ежедневный путь' : 'Свободная игра',
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
                        prompt: widget.puzzle.prompt,
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
                                  selected:
                                      _selectedAnswer == answerOptions[i].label,
                                  compact: true,
                                  stacked: true,
                                  onTap: () =>
                                      _selectAnswer(answerOptions[i].label),
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
                              selected: _selectedAnswer == option.label,
                              compact: false,
                              stacked: false,
                              onTap: () => _selectAnswer(option.label),
                            ),
                          ),
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
        enabled: _selectedAnswer != null,
        loading: _isSubmitting,
        selectedAnswer: _selectedAnswer,
        compact: compact,
        onSubmit: _submit,
      ),
    );
  }
}

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
                              'Отлично!',
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
                          hasNextPuzzle ? 'Летим дальше' : 'Все готово',
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
                  'Шаг $current из $total',
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
                puzzle.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: compact
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: compact ? 2 : 4),
              Text(
                puzzle.skill,
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
      'memory' => _MemoryStage(accent: accent, compact: compact),
      'attention' => _AttentionStage(accent: accent, compact: compact),
      'math' => _MathStage(accent: accent, compact: compact),
      'space' => _PathStage(accent: accent, compact: compact),
      _ => _PatternStrip(accent: accent, compact: compact),
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
  const _MemoryStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cardSize = compact ? 38.0 : 44.0;

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
                _MemoryPreviewCard(
                  label: '1',
                  icon: Icons.star_rounded,
                  color: AppPalette.mango,
                  size: cardSize,
                ),
                _MemoryPreviewCard(
                  label: '2',
                  icon: Icons.favorite_rounded,
                  color: AppPalette.coral,
                  size: cardSize,
                ),
                _MemoryPreviewCard(
                  label: '3',
                  icon: Icons.visibility_off_rounded,
                  color: AppPalette.lavender,
                  size: cardSize,
                  covered: true,
                ),
                _MemoryPreviewCard(
                  label: '4',
                  icon: Icons.cloud_rounded,
                  color: AppPalette.sky,
                  size: cardSize,
                ),
              ],
            ),
          ),
          SizedBox(width: compact ? 8 : 12),
          _StageToken(
            label: '?',
            color: accent,
            size: compact ? 50 : 58,
            highlighted: true,
          ),
        ],
      ),
    );
  }
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
  const _AttentionStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
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
              children: [
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
                _SearchSpot(
                  color: AppPalette.mango,
                  icon: Icons.star_rounded,
                  compact: compact,
                ),
                _SearchSpot(color: AppPalette.teal, compact: compact),
              ],
            ),
          ),
        ],
      ),
    );
  }
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

class _MathStage extends StatelessWidget {
  const _MathStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StageShell(
      accent: accent,
      compact: compact,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: compact ? 286 : 328,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CounterGroup(
                colors: const [
                  AppPalette.coral,
                  AppPalette.mango,
                  AppPalette.sky,
                ],
                compact: compact,
              ),
              _MathSign(icon: Icons.add_rounded, color: accent),
              _CounterGroup(
                colors: const [AppPalette.teal, AppPalette.lavender],
                compact: compact,
              ),
              Text(
                '=',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppPalette.ink.withValues(alpha: 0.72),
                    ),
              ),
              _StageToken(
                label: '?',
                color: AppPalette.mango,
                size: compact ? 48 : 54,
                highlighted: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
  const _PathStage({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StageShell(
      accent: accent,
      compact: compact,
      child: Row(
        children: [
          _PathNode(
            icon: Icons.flag_rounded,
            color: accent,
            compact: compact,
          ),
          _PathLink(color: accent),
          _PathNode(
            icon: Icons.arrow_forward_rounded,
            color: AppPalette.sky,
            compact: compact,
          ),
          _PathLink(color: accent),
          _PathNode(
            icon: Icons.turn_right_rounded,
            color: AppPalette.lavender,
            compact: compact,
          ),
          _PathLink(color: accent),
          _StageToken(
            label: '?',
            color: AppPalette.mango,
            size: compact ? 42 : 48,
            highlighted: true,
          ),
        ],
      ),
    );
  }
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
  });

  final List<Color> colors;
  final bool compact;

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
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withValues(alpha: 0.82), color],
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
    );
  }
}

class _PathNode extends StatelessWidget {
  const _PathNode({
    required this.icon,
    required this.color,
    required this.compact,
  });

  final IconData icon;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StageToken(
      icon: icon,
      color: color,
      size: compact ? 38 : 44,
      highlighted: true,
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
  const _PatternStrip({required this.accent, required this.compact});

  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StageShell(
      accent: accent,
      compact: compact,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: compact ? 284 : 330,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PatternItem(
                shape: _PatternShape.circle,
                color: AppPalette.teal,
                size: compact ? 38 : 42,
              ),
              _PatternItem(
                shape: _PatternShape.square,
                color: const Color(0xFF5F8BEF),
                size: compact ? 38 : 42,
              ),
              _PatternItem(
                shape: _PatternShape.circle,
                color: AppPalette.teal,
                size: compact ? 38 : 42,
              ),
              _PatternItem(
                shape: _PatternShape.square,
                color: const Color(0xFF5F8BEF),
                size: compact ? 38 : 42,
              ),
              _PatternQuestion(size: compact ? 40 : 42),
            ],
          ),
        ),
      ),
    );
  }
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
              _hintTextForArea(areaId),
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
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

List<_AnswerOptionData> _answerOptionsFor(String areaId) {
  return switch (areaId) {
    'memory' => const [
        _AnswerOptionData(
          label: 'Звезда',
          icon: Icons.star_rounded,
          color: Color(0xFFFFF2C4),
        ),
        _AnswerOptionData(
          label: 'Облако',
          icon: Icons.cloud_rounded,
          color: Color(0xFFE7F6FF),
        ),
        _AnswerOptionData(
          label: 'Сердце',
          icon: Icons.favorite_rounded,
          color: Color(0xFFFFE6EE),
        ),
      ],
    'attention' => const [
        _AnswerOptionData(
          label: 'Слева',
          icon: Icons.arrow_back_rounded,
          color: Color(0xFFE4EDFF),
        ),
        _AnswerOptionData(
          label: 'В центре',
          icon: Icons.center_focus_strong_rounded,
          color: Color(0xFFDDF7F3),
        ),
        _AnswerOptionData(
          label: 'Справа',
          icon: Icons.arrow_forward_rounded,
          color: Color(0xFFFFF2C4),
        ),
      ],
    'math' => const [
        _AnswerOptionData(
          label: '6',
          icon: Icons.filter_6_rounded,
          color: Color(0xFFFFF2C4),
        ),
        _AnswerOptionData(
          label: '7',
          icon: Icons.filter_7_rounded,
          color: Color(0xFFDDF7F3),
        ),
        _AnswerOptionData(
          label: '8',
          icon: Icons.filter_8_rounded,
          color: Color(0xFFECE8FF),
        ),
      ],
    'space' => const [
        _AnswerOptionData(
          label: 'Вверх',
          icon: Icons.arrow_upward_rounded,
          color: Color(0xFFE7F6FF),
        ),
        _AnswerOptionData(
          label: 'Вперёд',
          icon: Icons.arrow_forward_rounded,
          color: Color(0xFFDDF7F3),
        ),
        _AnswerOptionData(
          label: 'Вниз',
          icon: Icons.arrow_downward_rounded,
          color: Color(0xFFFFE6EE),
        ),
      ],
    _ => const [
        _AnswerOptionData(
          label: 'Треугольник',
          icon: Icons.change_history_rounded,
          color: Color(0xFFECE8FF),
        ),
        _AnswerOptionData(
          label: 'Круг',
          icon: Icons.circle_rounded,
          color: Color(0xFFDDF7F3),
        ),
        _AnswerOptionData(
          label: 'Квадрат',
          icon: Icons.square_rounded,
          color: Color(0xFFE4EDFF),
        ),
      ],
  };
}

String _hintTextForArea(String areaId) {
  return switch (areaId) {
    'memory' =>
      'Сначала вспомни, какие картинки уже были открыты. Потом ищи такую же пару.',
    'attention' =>
      'Сравни детали по одной: цвет, форму, размер и место. Отличие обычно маленькое.',
    'math' =>
      'Считай не всё сразу, а маленькими группами. Так легче не сбиться.',
    'space' =>
      'Следи за дорожкой от старта к финишу и называй следующий поворот.',
    _ => 'Правило повторяется. Найди начало нового повтора и продолжи ряд.',
  };
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.option,
    required this.selected,
    required this.compact,
    required this.stacked,
    required this.onTap,
  });

  final _AnswerOptionData option;
  final bool selected;
  final bool compact;
  final bool stacked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(stacked ? 22 : 20);

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
            color: selected
                ? AppPalette.mint.withValues(alpha: 0.44)
                : Colors.white,
            borderRadius: borderRadius,
            border: Border.all(
              color: selected ? AppPalette.teal : AppPalette.border,
              width: selected ? 2 : 1.2,
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: AppPalette.teal.withValues(alpha: 0.18),
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
                        const Positioned(
                          top: -2,
                          right: -2,
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: AppPalette.teal,
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
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppPalette.teal,
                        size: 28,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _StickyAnswerBar extends StatelessWidget {
  const _StickyAnswerBar({
    required this.enabled,
    required this.loading,
    required this.selectedAnswer,
    required this.compact,
    required this.onSubmit,
  });

  final bool enabled;
  final bool loading;
  final String? selectedAnswer;
  final bool compact;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
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
                  selectedAnswer == null
                      ? 'Выбери ответ'
                      : 'Ответ: $selectedAnswer',
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
                    label: Text(loading ? 'Проверяем' : 'Проверить'),
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
