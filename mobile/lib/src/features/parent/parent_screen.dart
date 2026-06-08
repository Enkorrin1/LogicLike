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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Родительский контур'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _FamilyProfileCard(profile: profile),
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
              icon: Icons.task_alt_rounded,
              label: 'Заданий выполнено',
              value: '${profile.completedChallenges}',
            ),
          ],
        ),
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
          Text(
            'Семейная подписка',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Здесь появятся статус оплаты, семейные места и управление планом.',
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
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
