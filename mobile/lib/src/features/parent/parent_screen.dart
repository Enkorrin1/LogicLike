import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

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
      body: PlayfulBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const _ParentIntroCard(),
            const SizedBox(height: 16),
            _FamilyProfileCard(profile: profile),
            const SizedBox(height: 16),
            const _SubscriptionCard(),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppPalette.coral,
                side: const BorderSide(color: AppPalette.coral, width: 1.2),
              ),
              onPressed: () => _confirmReset(context),
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Сбросить профиль'),
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

class _ParentIntroCard extends StatelessWidget {
  const _ParentIntroCard();

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: const EdgeInsets.all(18),
      borderColor: Colors.white,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFEAF7FF),
        ],
      ),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.family_restroom_rounded,
            color: AppPalette.surfaceBlue,
            iconColor: AppPalette.teal,
            size: 52,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Спокойная зона для взрослых',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Профиль, прогресс и будущая подписка собраны отдельно от детской миссии.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyProfileCard extends StatelessWidget {
  const _FamilyProfileCard({required this.profile});

  final FamilyProfile profile;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Семейный профиль',
            trailing: InfoPill(
              icon: Icons.lock_rounded,
              label: 'локально',
              color: AppPalette.mint,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.child_care_rounded,
            color: AppPalette.surfaceBlue,
            label: 'Ребенок',
            value: profile.childName,
          ),
          _InfoRow(
            icon: Icons.cake_rounded,
            color: AppPalette.mango,
            label: 'Возраст',
            value: profile.childAge.label,
          ),
          _InfoRow(
            icon: Icons.task_alt_rounded,
            color: AppPalette.mint,
            label: 'Заданий выполнено',
            value: '${profile.completedChallenges}',
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard();

  @override
  Widget build(BuildContext context) {
    return const PlayfulCard(
      color: AppPalette.surfaceBlue,
      borderColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Семейная подписка',
            trailing: InfoPill(
              icon: Icons.hourglass_top_rounded,
              label: 'скоро',
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Здесь появятся статус оплаты, семейные места и управление планом.',
          ),
          SizedBox(height: 14),
          _InfoRow(
            icon: Icons.groups_rounded,
            color: AppPalette.surface,
            label: 'Семейные места',
            value: 'в плане',
          ),
          _InfoRow(
            icon: Icons.payments_rounded,
            color: AppPalette.surface,
            label: 'Оплата',
            value: 'не подключена',
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
