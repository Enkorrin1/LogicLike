import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';
import '../../l10n/localized_content.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({
    required this.profile,
    required this.onResetProfile,
    required this.onLanguageChanged,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function() onResetProfile;
  final Future<void> Function(AppLanguage language) onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todaysPuzzles = dailyChallengesForAge(profile.childAge);
    final todaysCompletedIds = _todaysCompletedPuzzleIds(profile, now);
    final areas = puzzleAreasForAge(profile.childAge);
    final completedPuzzleIds = <String>{
      ...profile.completedPracticePuzzleIds,
      ...todaysCompletedIds,
    };
    final totalPuzzleCount = areas.fold<int>(
      0,
      (total, area) => total + area.puzzles.length,
    );
    final completedAreaPuzzleCount = _countExistingPuzzleIds(
      areas,
      completedPuzzleIds,
    );
    final completedLevels = profile.completedLevels.clamp(0, 8).toInt();
    final totalStars = 125 + profile.completedChallenges;
    final completedToday = profile.completedOn(now);
    final recommendedArea = _recommendedArea(areas, completedPuzzleIds);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.parentTitle),
      ),
      body: PlayfulBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _ParentHeroCard(
              profile: profile,
              totalStars: totalStars,
              completedToday: completedToday,
            ),
            const SizedBox(height: 16),
            _ProgressSummaryCard(
              completedLevels: completedLevels,
              totalStars: totalStars,
              todayDone: todaysCompletedIds.length,
              todayTotal: todaysPuzzles.length,
              completedPuzzleCount: completedAreaPuzzleCount,
              totalPuzzleCount: totalPuzzleCount,
            ),
            const SizedBox(height: 16),
            _TodayPlanCard(
              puzzles: todaysPuzzles,
              completedIds: todaysCompletedIds,
            ),
            const SizedBox(height: 16),
            _AreaProgressCard(
              areas: areas,
              completedPuzzleIds: completedPuzzleIds,
            ),
            const SizedBox(height: 16),
            _ParentRecommendationCard(
              profile: profile,
              recommendedArea: recommendedArea,
              completedToday: completedToday,
              todayDone: todaysCompletedIds.length,
              todayTotal: todaysPuzzles.length,
            ),
            const SizedBox(height: 16),
            _FamilySettingsCard(
              profile: profile,
              onLanguageChanged: onLanguageChanged,
              onResetPressed: () => _confirmReset(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.parentResetTitle),
          content: Text(context.l10n.parentResetBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppPalette.coral,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.commonReset),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      await onResetProfile();
    }
  }
}

class _ParentHeroCard extends StatelessWidget {
  const _ParentHeroCard({
    required this.profile,
    required this.totalStars,
    required this.completedToday,
  });

  final FamilyProfile profile;
  final int totalStars;
  final bool completedToday;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: EdgeInsets.zero,
      borderColor: Colors.white,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFEAF7FF),
          Color(0xFFFFF2D8),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -22,
              bottom: -26,
              child: Opacity(
                opacity: 0.42,
                child: Image.asset(
                  'assets/images/home_astronaut_cutout.png',
                  width: 152,
                  height: 152,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.ink.withValues(alpha: 0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar_lion.png',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.parentOverviewTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.parentOverviewBody(profile.childName),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            InfoPill(
                              icon: Icons.cake_rounded,
                              label: context.l10n.childAgeLabel(
                                profile.childAge,
                              ),
                              color: AppPalette.mint,
                            ),
                            InfoPill(
                              icon: Icons.star_rounded,
                              label: context.l10n.parentStarsCount(totalStars),
                              color: const Color(0xFFFFE7A8),
                            ),
                            InfoPill(
                              icon: completedToday
                                  ? Icons.check_circle_rounded
                                  : Icons.flag_rounded,
                              label: completedToday
                                  ? context.l10n.parentMissionClosed
                                  : context.l10n.parentMissionWaiting,
                              color: completedToday
                                  ? AppPalette.mint
                                  : const Color(0xFFFFE5E5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({
    required this.completedLevels,
    required this.totalStars,
    required this.todayDone,
    required this.todayTotal,
    required this.completedPuzzleCount,
    required this.totalPuzzleCount,
  });

  final int completedLevels;
  final int totalStars;
  final int todayDone;
  final int todayTotal;
  final int completedPuzzleCount;
  final int totalPuzzleCount;

  @override
  Widget build(BuildContext context) {
    final levelProgress = completedLevels / 8;
    final contentProgress =
        totalPuzzleCount == 0 ? 0.0 : completedPuzzleCount / totalPuzzleCount;

    return PlayfulCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: context.l10n.parentProgressTitle,
            trailing: InfoPill(
              icon: Icons.insights_rounded,
              label: context.l10n.parentOverviewBadge,
              color: AppPalette.surfaceBlue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.route_rounded,
                  color: AppPalette.teal,
                  label: context.l10n.parentLevelsLabel,
                  value: context.l10n.parentLevelsValue(completedLevels, 8),
                  progress: levelProgress,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  icon: Icons.today_rounded,
                  color: AppPalette.lavender,
                  label: context.l10n.parentTodayLabel,
                  value: context.l10n.parentTodayValue(todayDone, todayTotal),
                  progress: todayTotal == 0 ? 0 : todayDone / todayTotal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.auto_awesome_rounded,
                  color: AppPalette.mango,
                  label: context.l10n.parentStarsLabel,
                  value: '$totalStars',
                  progress: math.min(1, totalStars / 160),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  icon: Icons.extension_rounded,
                  color: AppPalette.coral,
                  label: context.l10n.parentContentLabel,
                  value: context.l10n.parentContentValue(
                    completedPuzzleCount,
                    totalPuzzleCount,
                  ),
                  progress: contentProgress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.progress,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(
            icon: icon,
            color: Colors.white,
            iconColor: color,
            size: 38,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppPalette.ink,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 7,
              color: color,
              backgroundColor: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayPlanCard extends StatelessWidget {
  const _TodayPlanCard({
    required this.puzzles,
    required this.completedIds,
  });

  final List<DailyChallenge> puzzles;
  final Set<String> completedIds;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: context.l10n.parentTodayPlanTitle,
            trailing: InfoPill(
              icon: Icons.event_available_rounded,
              label: '${completedIds.length}/${puzzles.length}',
              color: AppPalette.mint,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.parentTodayPlanBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          for (final puzzle in puzzles) ...[
            _TodayPuzzleRow(
              puzzle: puzzle,
              completed: completedIds.contains(puzzle.id),
            ),
            if (puzzle != puzzles.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _TodayPuzzleRow extends StatelessWidget {
  const _TodayPuzzleRow({
    required this.puzzle,
    required this.completed,
  });

  final DailyChallenge puzzle;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final color = _areaColor(puzzle.areaId);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: completed
            ? AppPalette.mint.withValues(alpha: 0.54)
            : AppPalette.surfaceBlue.withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        children: [
          AreaCharacterBadge(
            areaId: puzzle.areaId,
            color: color.withValues(alpha: 0.36),
            size: 54,
            padding: 2,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.puzzleTitle(puzzle),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  context.l10n.parentPuzzleMeta(
                    context.l10n.puzzleSkill(puzzle),
                    puzzle.minutes,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconBadge(
            icon: completed ? Icons.check_rounded : Icons.play_arrow_rounded,
            color: completed ? AppPalette.teal : Colors.white,
            iconColor: completed ? Colors.white : color,
            size: 38,
          ),
        ],
      ),
    );
  }
}

class _AreaProgressCard extends StatelessWidget {
  const _AreaProgressCard({
    required this.areas,
    required this.completedPuzzleIds,
  });

  final List<BrainArea> areas;
  final Set<String> completedPuzzleIds;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: context.l10n.parentAreasTitle,
            trailing: InfoPill(
              icon: Icons.psychology_rounded,
              label: context.l10n.parentBalanceBadge,
              color: const Color(0xFFFFE7A8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.parentAreasBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          for (final area in areas) ...[
            _AreaProgressRow(
              area: area,
              completedCount: _completedCountForArea(area, completedPuzzleIds),
            ),
            if (area != areas.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _AreaProgressRow extends StatelessWidget {
  const _AreaProgressRow({
    required this.area,
    required this.completedCount,
  });

  final BrainArea area;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final color = _areaColor(area.id);
    final total = area.puzzles.length;
    final progress = total == 0 ? 0.0 : completedCount / total;

    return Row(
      children: [
        AreaCharacterBadge(
          areaId: area.id,
          color: color.withValues(alpha: 0.38),
          size: 58,
          padding: 2,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.areaTitle(area.id),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '$completedCount/$total',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppPalette.ink,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                context.l10n.areaSubtitle(area.id),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0, 1),
                  minHeight: 8,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ParentRecommendationCard extends StatelessWidget {
  const _ParentRecommendationCard({
    required this.profile,
    required this.recommendedArea,
    required this.completedToday,
    required this.todayDone,
    required this.todayTotal,
  });

  final FamilyProfile profile;
  final BrainArea recommendedArea;
  final bool completedToday;
  final int todayDone;
  final int todayTotal;

  @override
  Widget build(BuildContext context) {
    final statusText = completedToday
        ? context.l10n.parentRecommendationDone
        : todayDone > 0
            ? context.l10n.parentRecommendationRemaining(
                todayTotal - todayDone,
              )
            : context.l10n.parentRecommendationStart;

    return PlayfulCard(
      color: const Color(0xFFFFFAEF),
      borderColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: context.l10n.parentRecommendationsTitle,
            trailing: InfoPill(
              icon: Icons.tips_and_updates_rounded,
              label: context.l10n.parentHomeBadge,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          _AdviceTile(
            icon: Icons.favorite_rounded,
            color: AppPalette.coral,
            title: context.l10n.parentPaceLabel,
            body: statusText,
          ),
          const SizedBox(height: 10),
          _AdviceTile(
            icon: Icons.explore_rounded,
            color: _areaColor(recommendedArea.id),
            title: context.l10n.parentWeekFocusLabel,
            body: context.l10n.parentFocusArea(
              context.l10n.areaTitle(recommendedArea.id),
              context.l10n.areaSubtitle(recommendedArea.id).toLowerCase(),
            ),
          ),
          const SizedBox(height: 10),
          _AdviceTile(
            icon: Icons.chat_bubble_rounded,
            color: AppPalette.lavender,
            title: context.l10n.parentDiscussLabel,
            body: context.l10n.parentDiscussBody,
          ),
        ],
      ),
    );
  }
}

class _AdviceTile extends StatelessWidget {
  const _AdviceTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(
            icon: icon,
            color: color.withValues(alpha: 0.16),
            iconColor: color,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilySettingsCard extends StatelessWidget {
  const _FamilySettingsCard({
    required this.profile,
    required this.onLanguageChanged,
    required this.onResetPressed,
  });

  final FamilyProfile profile;
  final Future<void> Function(AppLanguage language) onLanguageChanged;
  final VoidCallback onResetPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PlayfulCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: context.l10n.parentFamilySecurityTitle,
            trailing: InfoPill(
              icon: Icons.lock_rounded,
              label: context.l10n.parentLocalBadge,
              color: AppPalette.mint,
            ),
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.child_care_rounded,
            color: AppPalette.surfaceBlue,
            label: context.l10n.parentChildLabel,
            value: profile.childName,
          ),
          _InfoRow(
            icon: Icons.cake_rounded,
            color: AppPalette.mango.withValues(alpha: 0.42),
            label: context.l10n.parentAgeLabel,
            value: context.l10n.childAgeLabel(profile.childAge),
          ),
          _InfoRow(
            icon: Icons.cloud_off_rounded,
            color: AppPalette.mint,
            label: context.l10n.parentStorageLabel,
            value: context.l10n.parentStorageLocal,
          ),
          _InfoRow(
            icon: Icons.workspace_premium_rounded,
            color: AppPalette.surfaceBlue,
            label: context.l10n.parentSubscriptionTitle,
            value: context.l10n.parentSubscriptionSoon,
          ),
          const SizedBox(height: 8),
          SectionTitle(
            title: l10n.settingsLanguage,
            trailing: InfoPill(
              icon: Icons.language_rounded,
              label: profile.language.shortLabel,
              color: AppPalette.mint,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in AppLanguage.values)
                ChoiceChip(
                  label: Text(context.l10n.languageName(option)),
                  selected: option == profile.language,
                  onSelected: (_) => onLanguageChanged(option),
                ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppPalette.coral,
              side: const BorderSide(color: AppPalette.coral, width: 1.2),
            ),
            onPressed: onResetPressed,
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(context.l10n.parentResetProfile),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          IconBadge(
            icon: icon,
            color: color,
            size: 38,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink,
                  ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppPalette.ink,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

Set<String> _todaysCompletedPuzzleIds(FamilyProfile profile, DateTime now) {
  final progressDate = profile.dailyProgressDate;
  if (progressDate == null || !_isSameDate(progressDate, now)) {
    return const <String>{};
  }

  return profile.dailyCompletedPuzzleIds.toSet();
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

int _completedCountForArea(BrainArea area, Set<String> completedPuzzleIds) {
  return area.puzzles
      .where((puzzle) => completedPuzzleIds.contains(puzzle.id))
      .length;
}

int _countExistingPuzzleIds(
  List<BrainArea> areas,
  Set<String> completedPuzzleIds,
) {
  return areas.fold<int>(
    0,
    (total, area) => total + _completedCountForArea(area, completedPuzzleIds),
  );
}

BrainArea _recommendedArea(List<BrainArea> areas, Set<String> completedIds) {
  return areas.reduce((current, next) {
    final currentProgress = current.puzzles.isEmpty
        ? 1.0
        : _completedCountForArea(current, completedIds) /
            current.puzzles.length;
    final nextProgress = next.puzzles.isEmpty
        ? 1.0
        : _completedCountForArea(next, completedIds) / next.puzzles.length;

    return nextProgress < currentProgress ? next : current;
  });
}

Color _areaColor(String areaId) {
  return switch (areaId) {
    'logic' => AppPalette.teal,
    'memory' => const Color(0xFF5CA8FF),
    'attention' => AppPalette.coral,
    'math' => AppPalette.lavender,
    'space' => const Color(0xFF35B37E),
    _ => AppPalette.mango,
  };
}
