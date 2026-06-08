import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../shared/practice_habit_strip.dart';

typedef AddChildProfile = Future<void> Function({
  required String childName,
  required ChildAge childAge,
  required LearningGoal learningGoal,
});

class ParentScreen extends StatelessWidget {
  const ParentScreen({
    required this.profile,
    required this.onChildSelected,
    required this.onChildAdded,
    required this.onSubscriptionPlanChanged,
    required this.onResetProfile,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function(String childId) onChildSelected;
  final AddChildProfile onChildAdded;
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
    final practiceDays = profile.practiceDays(days: 7, now: now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Родительский контур'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _FamilyProfileCard(profile: profile),
          const SizedBox(height: 16),
          _ChildrenCard(
            profile: profile,
            onChildSelected: onChildSelected,
            onChildAdded: onChildAdded,
          ),
          const SizedBox(height: 16),
          _WeeklyProgressCard(
            profile: profile,
            weeklySessionsCount: weeklySessions.length,
            weeklyMinutes: weeklyMinutes,
            practiceDays: practiceDays,
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
              label: 'Активный ребенок',
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

class _ChildrenCard extends StatelessWidget {
  const _ChildrenCard({
    required this.profile,
    required this.onChildSelected,
    required this.onChildAdded,
  });

  final FamilyProfile profile;
  final Future<void> Function(String childId) onChildSelected;
  final AddChildProfile onChildAdded;

  @override
  Widget build(BuildContext context) {
    final children = profile.children;
    final limit = profile.subscriptionPlan.childProfileLimit;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Детские профили',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '${children.length} / $limit',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final child in children) ...[
              _ChildProfileTile(
                child: child,
                selected: child.id == profile.activeChild.id,
                onTap: () => onChildSelected(child.id),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 4),
            if (profile.canAddChild)
              FilledButton.icon(
                onPressed: () => _showAddChildDialog(context),
                icon: const Icon(Icons.person_add_alt_rounded),
                label: const Text('Добавить ребенка'),
              )
            else
              Text(
                profile.subscriptionPlan.isPaid
                    ? 'Все семейные места уже заняты.'
                    : 'Еще профили доступны на семейном плане.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddChildDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return _AddChildDialog(onChildAdded: onChildAdded);
      },
    );
  }
}

class _ChildProfileTile extends StatelessWidget {
  const _ChildProfileTile({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final ChildProfile child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: selected ? null : onTap,
      child: AnimatedContainer(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text('${child.age.label} • ${child.learningGoal.label}'),
                  const SizedBox(height: 6),
                  Text(
                    '${child.completedChallenges} заданий • серия ${child.currentStreak} дн.',
                    style: Theme.of(context).textTheme.labelMedium,
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

class _AddChildDialog extends StatefulWidget {
  const _AddChildDialog({required this.onChildAdded});

  final AddChildProfile onChildAdded;

  @override
  State<_AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<_AddChildDialog> {
  final _nameController = TextEditingController();

  ChildAge _selectedAge = ChildAge.six;
  LearningGoal _selectedGoal = LearningGoal.logic;
  bool _showNameError = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final childName = _nameController.text.trim();
    if (childName.isEmpty) {
      setState(() {
        _showNameError = true;
      });
      return;
    }

    setState(() {
      _showNameError = false;
      _isSaving = true;
    });

    await widget.onChildAdded(
      childName: childName,
      childAge: _selectedAge,
      learningGoal: _selectedGoal,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новый ребенок'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Имя ребенка',
                errorText: _showNameError ? 'Введите имя' : null,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 18),
            Text(
              'Возраст',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final age in ChildAge.values)
                  ChoiceChip(
                    label: Text(age.label),
                    selected: _selectedAge == age,
                    onSelected: (_) {
                      setState(() {
                        _selectedAge = age;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Цель',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final goal in LearningGoal.values) ...[
              _GoalOption(
                goal: goal,
                selected: _selectedGoal == goal,
                onTap: () {
                  setState(() {
                    _selectedGoal = goal;
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: Text(_isSaving ? 'Сохраняем' : 'Добавить'),
        ),
      ],
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final LearningGoal goal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primaryContainer : colorScheme.surface,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(goal.description),
                ],
              ),
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
    required this.practiceDays,
  });

  final FamilyProfile profile;
  final int weeklySessionsCount;
  final int weeklyMinutes;
  final List<PracticeDaySummary> practiceDays;

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
            const SizedBox(height: 10),
            PracticeHabitStrip(
              title: 'Ритм недели',
              subtitle: 'Дни с практикой и минуты по каждому дню.',
              days: practiceDays,
              showMinutes: true,
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
