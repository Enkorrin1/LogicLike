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
    final completedToday = profile.completedOn(DateTime.now());

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
            completedToday: completedToday,
          ),
          const SizedBox(height: 16),
          _ProgressCard(profile: profile),
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
    required this.completedToday,
  });

  final String childName;
  final String ageLabel;
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
            '$ageLabel • ${completedToday ? 'ритм дня закрыт' : 'ждет короткое задание'}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.profile});

  final FamilyProfile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department_rounded, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.completedChallenges} выполнено',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text('Каждый день добавляет один короткий шаг.'),
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
              'Сегодняшний цикл',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            const _RoutineStep(
              icon: Icons.timer_rounded,
              title: '3-6 минут',
              description: 'Короткая сессия подходит для буднего дня.',
            ),
            const _RoutineStep(
              icon: Icons.psychology_rounded,
              title: '1 навык',
              description: 'Фокус на логике, внимании или памяти.',
            ),
            const _RoutineStep(
              icon: Icons.emoji_events_rounded,
              title: 'Мягкое завершение',
              description: 'Родитель видит прогресс без давления.',
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
