import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({
    required this.profile,
    required this.selectedLocale,
    required this.onLocaleChanged,
    required this.onResetProfile,
    super.key,
  });

  final FamilyProfile profile;
  final Locale selectedLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final Future<void> Function() onResetProfile;

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
        title: const Text('Родителю'),
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
              selectedLocale: selectedLocale,
              onLocaleChanged: onLocaleChanged,
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
          title: const Text('Сбросить профиль?'),
          content: const Text(
            'Онбординг откроется заново, а локальный прогресс ребенка будет очищен.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppPalette.coral,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Сбросить'),
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
                          'Родительский обзор',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Профиль ${profile.childName}, прогресс, сегодняшний план и подсказки для занятий дома.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            InfoPill(
                              icon: Icons.cake_rounded,
                              label: profile.childAge.label,
                              color: AppPalette.mint,
                            ),
                            InfoPill(
                              icon: Icons.star_rounded,
                              label: '$totalStars звезд',
                              color: const Color(0xFFFFE7A8),
                            ),
                            InfoPill(
                              icon: completedToday
                                  ? Icons.check_circle_rounded
                                  : Icons.flag_rounded,
                              label: completedToday
                                  ? 'миссия закрыта'
                                  : 'миссия ждет',
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
          const SectionTitle(
            title: 'Прогресс ребенка',
            trailing: InfoPill(
              icon: Icons.insights_rounded,
              label: 'обзор',
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
                  label: 'Уровни',
                  value: '$completedLevels из 8',
                  progress: levelProgress,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  icon: Icons.today_rounded,
                  color: AppPalette.lavender,
                  label: 'Сегодня',
                  value: '$todayDone из $todayTotal',
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
                  label: 'Звезды',
                  value: '$totalStars',
                  progress: math.min(1, totalStars / 160),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  icon: Icons.extension_rounded,
                  color: AppPalette.coral,
                  label: 'Контент',
                  value: '$completedPuzzleCount из $totalPuzzleCount',
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
            title: 'План на сегодня',
            trailing: InfoPill(
              icon: Icons.event_available_rounded,
              label: '${completedIds.length}/${puzzles.length}',
              color: AppPalette.mint,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Короткая серия без давления: лучше 2-3 спокойных подхода, чем длинная усталая сессия.',
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
                  puzzle.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  '${puzzle.skill} • ${puzzle.minutes} мин',
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
          const SectionTitle(
            title: 'Зоны развития',
            trailing: InfoPill(
              icon: Icons.psychology_rounded,
              label: 'баланс',
              color: Color(0xFFFFE7A8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Это внутренняя карта для взрослых: ребенку лучше видеть миссии и героев, а не сухие категории.',
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
                      area.title,
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
                area.subtitle,
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
        ? 'Сегодняшняя миссия закрыта. Хороший момент похвалить за старание, а не за скорость.'
        : todayDone > 0
            ? 'Сегодня уже есть прогресс: осталось ${todayTotal - todayDone} ${_taskWord(todayTotal - todayDone)}.'
            : 'Сегодня лучше начать с одной короткой миссии на 4-6 минут.';

    return PlayfulCard(
      color: const Color(0xFFFFFAEF),
      borderColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Рекомендации',
            trailing: InfoPill(
              icon: Icons.tips_and_updates_rounded,
              label: 'для дома',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          _AdviceTile(
            icon: Icons.favorite_rounded,
            color: AppPalette.coral,
            title: 'Темп',
            body: statusText,
          ),
          const SizedBox(height: 10),
          _AdviceTile(
            icon: Icons.explore_rounded,
            color: _areaColor(recommendedArea.id),
            title: 'Фокус недели',
            body:
                'Больше всего сейчас просится зона "${recommendedArea.title}": ${recommendedArea.subtitle.toLowerCase()}.',
          ),
          const SizedBox(height: 10),
          const _AdviceTile(
            icon: Icons.chat_bubble_rounded,
            color: AppPalette.lavender,
            title: 'Как обсуждать',
            body:
                'После задания спросите: "Как ты понял правило?" Это развивает объяснение, а не угадывание.',
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
    required this.selectedLocale,
    required this.onLocaleChanged,
    required this.onResetPressed,
  });

  final FamilyProfile profile;
  final Locale selectedLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback onResetPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PlayfulCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Семья и безопасность',
            trailing: InfoPill(
              icon: Icons.lock_rounded,
              label: 'локально',
              color: AppPalette.mint,
            ),
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.child_care_rounded,
            color: AppPalette.surfaceBlue,
            label: 'Ребенок',
            value: profile.childName,
          ),
          _InfoRow(
            icon: Icons.cake_rounded,
            color: AppPalette.mango.withValues(alpha: 0.42),
            label: 'Возраст',
            value: profile.childAge.label,
          ),
          const _InfoRow(
            icon: Icons.cloud_off_rounded,
            color: AppPalette.mint,
            label: 'Хранение',
            value: 'на устройстве',
          ),
          const _InfoRow(
            icon: Icons.workspace_premium_rounded,
            color: AppPalette.surfaceBlue,
            label: 'Подписка',
            value: 'скоро',
          ),
          DropdownButtonFormField<Locale>(
            initialValue: selectedLocale,
            decoration: InputDecoration(
              labelText: l10n.settingsLanguage,
              prefixIcon: const Icon(Icons.language_rounded),
            ),
            items: [
              for (final option in _languageOptions(l10n))
                DropdownMenuItem<Locale>(
                  value: option.locale,
                  child: Text(option.label),
                ),
            ],
            onChanged: (locale) {
              if (locale != null) {
                onLocaleChanged(locale);
              }
            },
          ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppPalette.coral,
              side: const BorderSide(color: AppPalette.coral, width: 1.2),
            ),
            onPressed: onResetPressed,
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Сбросить профиль'),
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

class _LanguageOption {
  const _LanguageOption(this.locale, this.label);

  final Locale locale;
  final String label;
}

List<_LanguageOption> _languageOptions(AppLocalizations l10n) {
  return [
    _LanguageOption(const Locale('ar'), l10n.languageArabic),
    _LanguageOption(const Locale('de'), l10n.languageGerman),
    _LanguageOption(const Locale('en'), l10n.languageEnglish),
    _LanguageOption(const Locale('es'), l10n.languageSpanish),
    _LanguageOption(const Locale('fr'), l10n.languageFrench),
    _LanguageOption(const Locale('hi'), l10n.languageHindi),
    _LanguageOption(const Locale('it'), l10n.languageItalian),
    _LanguageOption(const Locale('ja'), l10n.languageJapanese),
    _LanguageOption(const Locale('ko'), l10n.languageKorean),
    _LanguageOption(const Locale('pt'), l10n.languagePortuguese),
    _LanguageOption(const Locale('ru'), l10n.languageRussian),
    _LanguageOption(const Locale('zh'), l10n.languageChinese),
  ];
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

String _taskWord(int count) {
  final mod10 = count % 10;
  final mod100 = count % 100;
  if (mod10 == 1 && mod100 != 11) {
    return 'задание';
  }
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    return 'задания';
  }
  return 'заданий';
}
