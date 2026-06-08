import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({
    required this.profile,
    required this.onResetProfile,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function() onResetProfile;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weeklySessions = profile.sessionsInLastDays(days: 7, now: now);
    final weeklyMinutes = weeklySessions.fold<int>(
      0,
      (total, session) => total + session.minutes,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Родительский контур'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _FamilyProfileCard(profile: profile),
          const SizedBox(height: 16),
          _WeeklyProgressCard(
            profile: profile,
            weeklySessionsCount: weeklySessions.length,
            weeklyMinutes: weeklyMinutes,
          ),
          const SizedBox(height: 16),
          const _SubscriptionCard(),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _confirmReset(context),
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Сбросить профиль'),
          ),
        ],
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
            'Onboarding откроется заново, а локальный прогресс будет очищен.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
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

class _FamilyProfileCard extends StatelessWidget {
  const _FamilyProfileCard({required this.profile});

  final FamilyProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Семейный профиль',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.child_care_rounded,
              label: 'Ребенок',
              value: profile.childName,
            ),
            _InfoRow(
              icon: Icons.cake_rounded,
              label: 'Возраст',
              value: profile.childAge.label,
            ),
            _InfoRow(
              icon: Icons.flag_rounded,
              label: 'Цель',
              value: profile.learningGoal.label,
            ),
            _InfoRow(
              icon: Icons.task_alt_rounded,
              label: 'Всего заданий',
              value: '${profile.completedChallenges}',
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard({
    required this.profile,
    required this.weeklySessionsCount,
    required this.weeklyMinutes,
  });

  final FamilyProfile profile;
  final int weeklySessionsCount;
  final int weeklyMinutes;

  @override
  Widget build(BuildContext context) {
    final lastSession = profile.lastSession;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Аналитика занятий',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    label: 'Серия',
                    value: '${profile.currentStreak} дн.',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryStat(
                    label: 'Лучшее',
                    value: '${profile.bestStreak} дн.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    label: 'За 7 дней',
                    value: '$weeklySessionsCount сесс.',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryStat(
                    label: 'Минуты',
                    value: '$weeklyMinutes мин',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.school_rounded,
              label: 'Последний навык',
              value: lastSession?.skill ?? 'Пока нет',
            ),
            _InfoRow(
              icon: Icons.event_available_rounded,
              label: 'Последняя сессия',
              value: lastSession == null
                  ? 'Пока нет'
                  : _formatDate(lastSession.completedAt),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                'Семейная подписка',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Здесь будет parent-paid контур: статус оплаты, семейные места и управление планом.',
          ),
          const SizedBox(height: 14),
          const _SubscriptionBenefit(
            icon: Icons.group_rounded,
            text: 'До 3 детских профилей в семье',
          ),
          const _SubscriptionBenefit(
            icon: Icons.insights_rounded,
            text: 'Прогресс и недельная динамика для родителя',
          ),
          const _SubscriptionBenefit(
            icon: Icons.no_accounts_rounded,
            text: 'Короткие задания без рекламы',
          ),
        ],
      ),
    );
  }
}

class _SubscriptionBenefit extends StatelessWidget {
  const _SubscriptionBenefit({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${_twoDigits(date.day)}.${_twoDigits(date.month)}.${date.year}';
}

String _twoDigits(int value) {
  return value.toString().padLeft(2, '0');
}
