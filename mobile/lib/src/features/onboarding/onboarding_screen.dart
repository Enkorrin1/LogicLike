import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';

typedef CompleteOnboarding = Future<void> Function({
  required String childName,
  required ChildAge childAge,
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
              'Создайте семейный профиль, чтобы ежедневные задания подходили по возрасту.',
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
            const SizedBox(height: 32),
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
