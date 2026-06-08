import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({
    required this.profile,
    required this.onChallengeComplete,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function(DailyChallenge challenge) onChallengeComplete;

  @override
  Widget build(BuildContext context) {
    final challenges = dailyChallengesForAge(profile.childAge);
    final completedToday = profile.completedOn(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задание дня'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: challenges.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _DailyStatusCard(
              childName: profile.childName,
              completedToday: completedToday,
            );
          }

          final challenge = challenges[index - 1];
          return _ChallengeCard(
            challenge: challenge,
            completedToday: completedToday,
            onComplete: () => onChallengeComplete(challenge),
          );
        },
      ),
    );
  }
}

class _DailyStatusCard extends StatelessWidget {
  const _DailyStatusCard({
    required this.childName,
    required this.completedToday,
  });

  final String childName;
  final bool completedToday;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: completedToday
            ? colorScheme.tertiaryContainer
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            completedToday ? 'Готово на сегодня' : '$childName, начинаем?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            completedToday
                ? 'Ежедневный цикл закрыт. Завтра появится новое задание.'
                : 'Одно короткое задание помогает держать ритм без перегруза.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.completedToday,
    required this.onComplete,
  });

  final DailyChallenge challenge;
  final bool completedToday;
  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_alt_rounded,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    challenge.skill,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                  ),
                ),
                Text('${challenge.minutes} мин'),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              challenge.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(challenge.prompt),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: completedToday ? null : onComplete,
                icon: Icon(
                  completedToday
                      ? Icons.check_circle_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(completedToday ? 'Выполнено' : 'Сделали'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
