import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';

class ParentScreen extends StatelessWidget {
  const ParentScreen({
    required this.profile,
    required this.onSubscriptionPlanChanged,
    required this.onResetProfile,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function(FamilySubscriptionPlan plan)
      onSubscriptionPlanChanged;
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
          _SubscriptionCard(
            profile: profile,
            onPlanChanged: onSubscriptionPlanChanged,
          ),
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
  const _SubscriptionCard({
    required this.profile,
    required this.onPlanChanged,
  });

  final FamilyProfile profile;
  final Future<void> Function(FamilySubscriptionPlan plan) onPlanChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentPlan = profile.subscriptionPlan;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.workspace_premium_rounded, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Семейная подписка',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _PlanStatus(plan: currentPlan),
            ],
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.credit_card_rounded,
            label: 'Текущий план',
            value: currentPlan.label,
          ),
          _InfoRow(
            icon: Icons.group_rounded,
            label: 'Семейные места',
            value: currentPlan.capacityLabel,
          ),
          _InfoRow(
            icon: Icons.update_rounded,
            label: 'Обновлен',
            value: profile.subscriptionUpdatedAt == null
                ? 'Пока нет'
                : _formatDate(profile.subscriptionUpdatedAt!),
          ),
          const SizedBox(height: 8),
          for (final plan in FamilySubscriptionPlan.values) ...[
            _PlanOption(
              plan: plan,
              selected: plan == currentPlan,
              recommended: plan == FamilySubscriptionPlan.annual,
              onSelect: () => onPlanChanged(plan),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _PlanStatus extends StatelessWidget {
  const _PlanStatus({required this.plan});

  final FamilySubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            plan.isPaid ? colorScheme.tertiaryContainer : colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          plan.statusLabel,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.plan,
    required this.selected,
    required this.recommended,
    required this.onSelect,
  });

  final FamilySubscriptionPlan plan;
  final bool selected;
  final bool recommended;
  final Future<void> Function() onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? colorScheme.primaryContainer : colorScheme.surface,
        border: Border.all(
          color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  plan.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (recommended)
                Text(
                  'Выгодно',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            plan.priceLabel,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(plan.description),
          const SizedBox(height: 12),
          selected
              ? OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Текущий план'),
                )
              : FilledButton.icon(
                  onPressed: onSelect,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Выбрать'),
                ),
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
