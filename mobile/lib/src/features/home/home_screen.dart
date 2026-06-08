import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.profile,
    super.key,
  });

  final FamilyProfile profile;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final completedToday = profile.completedOn(now);
    final weeklySessions = profile.sessionsInLastDays(days: 7, now: now);
    final weeklyMinutes = weeklySessions.fold<int>(
      0,
      (total, session) => total + session.minutes,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('LogicLike'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _GreetingCard(
            childName: profile.childName,
            ageLabel: profile.childAge.label,
            goalLabel: profile.learningGoal.label,
            completedToday: completedToday,
          ),
          const SizedBox(height: 16),
          _ProgressCard(
            profile: profile,
            weeklyMinutes: weeklyMinutes,
            weeklySessionsCount: weeklySessions.length,
          ),
          const SizedBox(height: 16),
          _TodayCard(
            completedToday: completedToday,
            lastSession: profile.lastSession,
          ),
          const SizedBox(height: 16),
          const _RoutineCard(),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard({
    required this.childName,
    required this.ageLabel,
    required this.goalLabel,
    required this.completedToday,
  });

  final String childName;
  final String ageLabel;
  final String goalLabel;
  final bool completedToday;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Привет, $childName',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '$ageLabel • цель: $goalLabel',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          _StatusPill(
            icon: completedToday
                ? Icons.check_circle_rounded
                : Icons.play_circle_rounded,
            label: completedToday ? 'Ритм дня закрыт' : 'Ждет короткое задание',
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.profile,
    required this.weeklyMinutes,
    required this.weeklySessionsCount,
  });

  final FamilyProfile profile;
  final int weeklyMinutes;
  final int weeklySessionsCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Прогресс',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MetricTile(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Серия',
                  value: '${profile.currentStreak} дн.',
                ),
                _MetricTile(
                  icon: Icons.timer_rounded,
                  label: 'Минуты',
                  value: '${profile.totalPracticeMinutes}',
                ),
                _MetricTile(
                  icon: Icons.task_alt_rounded,
                  label: 'Задания',
                  value: '${profile.completedChallenges}',
                ),
                _MetricTile(
                  icon: Icons.calendar_view_week_rounded,
                  label: 'За неделю',
                  value: '$weeklySessionsCount / $weeklyMinutes мин',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 142,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 2),
          Text(label),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.completedToday,
    required this.lastSession,
  });

  final bool completedToday;
  final PracticeSession? lastSession;

  @override
  Widget build(BuildContext context) {
    final session = lastSession;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              completedToday
                  ? Icons.emoji_events_rounded
                  : Icons.extension_rounded,
              size: 34,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    completedToday ? 'Сегодня готово' : 'Сегодняшнее задание',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    completedToday
                        ? 'Можно спокойно закрывать день. Завтра появится новое короткое задание.'
                        : 'Откройте вкладку "Задание" и пройдите один короткий цикл.',
                  ),
                  if (session != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Последний навык: ${session.skill}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
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

class _RoutineCard extends StatelessWidget {
  const _RoutineCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ежедневный цикл',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            const _RoutineStep(
              icon: Icons.timer_rounded,
              title: '3-6 минут',
              description:
                  'Короткая сессия подходит для обычного семейного дня.',
            ),
            const _RoutineStep(
              icon: Icons.psychology_rounded,
              title: '1 навык',
              description:
                  'Фокус на логике, внимании, памяти или математическом мышлении.',
            ),
            const _RoutineStep(
              icon: Icons.family_restroom_rounded,
              title: 'Без давления',
              description:
                  'Родитель видит прогресс, а ребенок получает понятный маленький шаг.',
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineStep extends StatelessWidget {
  const _RoutineStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
