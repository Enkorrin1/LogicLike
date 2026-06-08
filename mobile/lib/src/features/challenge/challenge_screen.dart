import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({
    required this.profile,
    required this.onChallengeComplete,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function(DailyChallenge challenge) onChallengeComplete;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  String? _selectedChoiceId;
  String? _activeChallengeId;
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final challenge = dailyChallengeForDate(
      widget.profile.childAge,
      DateTime.now(),
      goal: widget.profile.learningGoal,
    );
    final completedToday = widget.profile.completedOn(DateTime.now());
    _syncChallenge(challenge);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задание дня'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _DailyStatusCard(
            childName: widget.profile.childName,
            goalLabel: widget.profile.learningGoal.label,
            completedToday: completedToday,
            challenge: challenge,
          ),
          const SizedBox(height: 16),
          if (completedToday)
            _CompletedChallengeCard(challenge: challenge)
          else
            _InteractiveChallengeCard(
              challenge: challenge,
              selectedChoiceId: _selectedChoiceId,
              hasSubmitted: _hasSubmitted,
              isCorrect: _isCorrect,
              isCompleting: _isCompleting,
              onChoiceSelected: _selectChoice,
              onSubmit: _submitAnswer,
            ),
        ],
      ),
    );
  }

  void _syncChallenge(DailyChallenge challenge) {
    if (_activeChallengeId == challenge.id) {
      return;
    }

    _activeChallengeId = challenge.id;
    _selectedChoiceId = null;
    _hasSubmitted = false;
    _isCorrect = false;
    _isCompleting = false;
  }

  void _selectChoice(String choiceId) {
    setState(() {
      _selectedChoiceId = choiceId;
      _hasSubmitted = false;
      _isCorrect = false;
    });
  }

  Future<void> _submitAnswer(DailyChallenge challenge) async {
    final choiceId = _selectedChoiceId;
    if (choiceId == null || _isCompleting) {
      return;
    }

    final isCorrect = challenge.isCorrectChoice(choiceId);
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
      _isCompleting = isCorrect;
    });

    if (!isCorrect) {
      return;
    }

    await widget.onChallengeComplete(challenge);

    if (!mounted) {
      return;
    }

    setState(() {
      _isCompleting = false;
    });
  }
}

class _DailyStatusCard extends StatelessWidget {
  const _DailyStatusCard({
    required this.childName,
    required this.goalLabel,
    required this.completedToday,
    required this.challenge,
  });

  final String childName;
  final String goalLabel;
  final bool completedToday;
  final DailyChallenge challenge;

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
          Row(
            children: [
              Icon(
                completedToday
                    ? Icons.check_circle_rounded
                    : Icons.psychology_alt_rounded,
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
            completedToday ? 'Готово на сегодня' : '$childName, начинаем?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            completedToday
                ? 'Ежедневный цикл закрыт. Завтра появится новое задание.'
                : challenge.prompt,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Цель профиля: $goalLabel',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}

class _InteractiveChallengeCard extends StatelessWidget {
  const _InteractiveChallengeCard({
    required this.challenge,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.isCompleting,
    required this.onChoiceSelected,
    required this.onSubmit,
  });

  final DailyChallenge challenge;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final bool isCompleting;
  final ValueChanged<String> onChoiceSelected;
  final Future<void> Function(DailyChallenge challenge) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              challenge.question,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 18),
            for (final choice in challenge.choices) ...[
              _ChoiceTile(
                choice: choice,
                selected: selectedChoiceId == choice.id,
                onTap: () => onChoiceSelected(choice.id),
              ),
              const SizedBox(height: 10),
            ],
            if (hasSubmitted) ...[
              const SizedBox(height: 4),
              _AnswerFeedback(
                isCorrect: isCorrect,
                challenge: challenge,
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: selectedChoiceId == null || isCompleting
                  ? null
                  : () => onSubmit(challenge),
              icon: Icon(
                isCompleting
                    ? Icons.hourglass_top_rounded
                    : Icons.check_rounded,
              ),
              label: Text(isCompleting ? 'Засчитываем' : 'Проверить'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final ChallengeChoice choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primaryContainer : colorScheme.surface,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                choice.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerFeedback extends StatelessWidget {
  const _AnswerFeedback({
    required this.isCorrect,
    required this.challenge,
  });

  final bool isCorrect;
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect
            ? colorScheme.tertiaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.emoji_events_rounded : Icons.lightbulb_rounded,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Верно! ${challenge.explanation}'
                  : 'Почти. ${challenge.hint}',
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedChallengeCard extends StatelessWidget {
  const _CompletedChallengeCard({required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              challenge.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(challenge.explanation),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.task_alt_rounded),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Сегодняшнее задание выполнено',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
