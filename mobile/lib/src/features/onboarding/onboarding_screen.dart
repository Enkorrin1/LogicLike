import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

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
      body: PlayfulBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 118),
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: AppMark(size: 54),
              ),
              const SizedBox(height: 18),
              Text(
                'Настроим LogicLike',
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Создадим маленькую личную миссию, чтобы задания подходили ребенку по возрасту.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 22),
              const _WelcomePanel(),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Имя ребенка',
                  errorText: _showNameError ? 'Введите имя' : null,
                  prefixIcon: const Icon(Icons.child_care_rounded),
                ),
                onChanged: (_) {
                  if (_showNameError) {
                    setState(() {
                      _showNameError = false;
                    });
                  }
                },
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 22),
              const SectionTitle(
                title: 'Возраст',
                trailing: InfoPill(
                  icon: Icons.tune_rounded,
                  label: 'подберем уровень',
                  color: AppPalette.surface,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final age in ChildAge.values)
                    ChoiceChip(
                      avatar: Icon(
                        _selectedAge == age
                            ? Icons.check_rounded
                            : Icons.auto_awesome_rounded,
                        size: 18,
                      ),
                      label: Text(age.label),
                      selected: _selectedAge == age,
                      showCheckmark: false,
                      onSelected: (_) {
                        setState(() {
                          _selectedAge = age;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 22),
              const _PromiseCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppPalette.background,
          boxShadow: [
            BoxShadow(
              color: AppPalette.ink.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 16),
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _submit,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.play_arrow_rounded),
              label: Text(_isSaving ? 'Сохраняем' : 'Начать миссию'),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel();

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: const EdgeInsets.all(18),
      borderColor: Colors.white,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE9FFF2),
          Color(0xFFE8F7FF),
        ],
      ),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.psychology_alt_rounded,
            color: AppPalette.mint,
            iconColor: AppPalette.teal,
            size: 54,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Каждый день по одной задачке',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Без гонки, оценок и перегруза.',
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

class _PromiseCard extends StatelessWidget {
  const _PromiseCard();

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: const EdgeInsets.all(18),
      color: AppPalette.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Что будет внутри',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const _PromiseRow(
            icon: Icons.timer_rounded,
            color: AppPalette.mango,
            text: 'короткие задания на 3-6 минут',
          ),
          const _PromiseRow(
            icon: Icons.favorite_rounded,
            color: AppPalette.surfaceBlue,
            text: 'мягкая мотивация без давления',
          ),
          const _PromiseRow(
            icon: Icons.family_restroom_rounded,
            color: AppPalette.mint,
            text: 'понятный прогресс для родителей',
          ),
        ],
      ),
    );
  }
}

class _PromiseRow extends StatelessWidget {
  const _PromiseRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          IconBadge(
            icon: icon,
            color: color,
            size: 34,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
