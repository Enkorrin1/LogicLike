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
    return Scaffold(
      body: PlayfulBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            children: [
              _HeroPassport(
                nameController: _nameController,
                selectedAge: _selectedAge,
                showNameError: _showNameError,
                onNameChanged: () {
                  if (_showNameError) {
                    setState(() {
                      _showNameError = false;
                    });
                  }
                },
                onSubmit: _submit,
              ),
              const SizedBox(height: 14),
              _AgeDock(
                selectedAge: _selectedAge,
                onSelected: (age) {
                  setState(() {
                    _selectedAge = age;
                  });
                },
              ),
              const SizedBox(height: 14),
              const _BrainPreview(),
              const SizedBox(height: 12),
              const _ParentPromise(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: AppPalette.surface,
          boxShadow: [
            BoxShadow(
              color: AppPalette.ink.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
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
                  : const Icon(Icons.rocket_launch_rounded),
              label: Text(_isSaving ? 'Готовим маршрут' : 'Создать героя'),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroPassport extends StatelessWidget {
  const _HeroPassport({
    required this.nameController,
    required this.selectedAge,
    required this.showNameError,
    required this.onNameChanged,
    required this.onSubmit,
  });

  final TextEditingController nameController;
  final ChildAge selectedAge;
  final bool showNameError;
  final VoidCallback onNameChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final childName = nameController.text.trim();
    final displayName = childName.isEmpty ? 'Юный герой' : childName;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF55D6F5),
            Color(0xFF7EE9C5),
            Color(0xFFFFE27A),
          ],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.sky.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -34,
            top: -28,
            child: _HeroPlanet(size: 128, color: Color(0x55FFFFFF)),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white.withValues(alpha: 0.70),
              size: 48,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 94,
                      height: 94,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.ink.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar_lion.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _MissionPill(),
                          const SizedBox(height: 10),
                          Text(
                            'Пропуск в BrainUp',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppPalette.ink,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$displayName, ${selectedAge.label}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppPalette.ink,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Сначала создаем героя, потом открываем ежедневные задания и свободные головоломки по областям мозга.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Имя ребенка',
                    errorText: showNameError ? 'Введите имя героя' : null,
                    prefixIcon: const Icon(Icons.face_rounded),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.92),
                  ),
                  onChanged: (_) => onNameChanged(),
                  onSubmitted: (_) => onSubmit(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionPill extends StatelessWidget {
  const _MissionPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, color: AppPalette.mango, size: 18),
          const SizedBox(width: 5),
          Text(
            'старт миссии',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _AgeDock extends StatelessWidget {
  const _AgeDock({
    required this.selectedAge,
    required this.onSelected,
  });

  final ChildAge selectedAge;
  final ValueChanged<ChildAge> onSelected;

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: const EdgeInsets.all(16),
      borderColor: Colors.white,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFEAF7FF)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.tune_rounded,
                color: Color(0xFFEDEAFF),
                iconColor: AppPalette.lavender,
                size: 42,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Выбери возрастной маршрут',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final age in ChildAge.values)
                _AgeToken(
                  age: age,
                  selected: selectedAge == age,
                  onTap: () => onSelected(age),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AgeToken extends StatelessWidget {
  const _AgeToken({
    required this.age,
    required this.selected,
    required this.onTap,
  });

  final ChildAge age;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 88,
        height: 64,
        decoration: BoxDecoration(
          color: selected ? AppPalette.coral : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppPalette.coral : AppPalette.border,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppPalette.coral.withValues(alpha: 0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.auto_awesome_rounded,
              color: selected ? Colors.white : AppPalette.teal,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              age.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: selected ? Colors.white : AppPalette.ink,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrainPreview extends StatelessWidget {
  const _BrainPreview();

  @override
  Widget build(BuildContext context) {
    return PlayfulCard(
      padding: const EdgeInsets.all(16),
      borderColor: Colors.white,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.psychology_alt_rounded,
                color: AppPalette.mint,
                iconColor: AppPalette.teal,
                size: 42,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Что откроется',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: _PreviewTile(
                  icon: Icons.local_fire_department_rounded,
                  color: AppPalette.coral,
                  title: 'Ежедневка',
                  subtitle: 'серия',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _PreviewTile(
                  icon: Icons.extension_rounded,
                  color: AppPalette.lavender,
                  title: 'Головоломки',
                  subtitle: 'на выбор',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: _PreviewTile(
                  icon: Icons.center_focus_strong_rounded,
                  color: AppPalette.teal,
                  title: 'Внимание',
                  subtitle: 'фокус',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _PreviewTile(
                  icon: Icons.calculate_rounded,
                  color: AppPalette.mango,
                  title: 'Счет',
                  subtitle: 'числа',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ParentPromise extends StatelessWidget {
  const _ParentPromise();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppPalette.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const IconBadge(
            icon: Icons.family_restroom_rounded,
            color: Colors.white,
            iconColor: AppPalette.ink,
            size: 42,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Для родителя: короткие занятия, без давления и с понятным прогрессом.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPlanet extends StatelessWidget {
  const _HeroPlanet({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
