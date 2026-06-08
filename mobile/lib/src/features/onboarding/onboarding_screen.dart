import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';

typedef CompleteOnboarding = Future<void> Function({
  required String childName,
  required ChildAge childAge,
  required LearningGoal learningGoal,
});

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    required this.onComplete,
    super.key,
  });

  final CompleteOnboarding onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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

    await widget.onComplete(
      childName: childName,
      childAge: _selectedAge,
      learningGoal: _selectedGoal,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Text(
              'Настроим LogicLike',
              style: textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Создайте семейный профиль, чтобы ежедневные задания подходили по возрасту и цели занятий.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Имя ребенка',
                errorText: _showNameError ? 'Введите имя' : null,
                prefixIcon: const Icon(Icons.child_care_rounded),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            Text(
              'Возраст',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
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
            const SizedBox(height: 24),
            Text(
              'Цель занятий',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
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
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _isSaving ? null : _submit,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(_isSaving ? 'Сохраняем' : 'Начать'),
            ),
          ],
        ),
      ),
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
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primaryContainer : colorScheme.surface,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              _goalIcon(goal),
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(goal.description),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colorScheme.primary : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  IconData _goalIcon(LearningGoal goal) {
    switch (goal) {
      case LearningGoal.logic:
        return Icons.psychology_alt_rounded;
      case LearningGoal.math:
        return Icons.calculate_rounded;
      case LearningGoal.attention:
        return Icons.center_focus_strong_rounded;
    }
  }
}
