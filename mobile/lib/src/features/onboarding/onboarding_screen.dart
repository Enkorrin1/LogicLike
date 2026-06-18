import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';
import '../../l10n/localized_content.dart';
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
                  setState(() {
                    _showNameError = false;
                  });
                },
                onAgeSelected: (age) {
                  setState(() {
                    _selectedAge = age;
                  });
                },
                onSubmit: _submit,
              ),
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
              label: Text(
                _isSaving
                    ? context.l10n.onboardingSubmitSaving
                    : context.l10n.onboardingSubmitCreateHero,
              ),
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
    required this.onAgeSelected,
    required this.onSubmit,
  });

  final TextEditingController nameController;
  final ChildAge selectedAge;
  final bool showNameError;
  final VoidCallback onNameChanged;
  final ValueChanged<ChildAge> onAgeSelected;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final childName = nameController.text.trim();
    final l10n = context.l10n;
    final displayName =
        childName.isEmpty ? l10n.onboardingDefaultHero : childName;

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
                            l10n.onboardingTitle,
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
                            l10n.onboardingHeroSummary(
                              displayName,
                              l10n.childAgeLabel(selectedAge),
                            ),
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
                  l10n.onboardingSubtitle,
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
                    labelText: l10n.childNameLabel,
                    errorText: showNameError ? l10n.childNameError : null,
                    prefixIcon: const Icon(Icons.face_rounded),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.92),
                  ),
                  onChanged: (_) => onNameChanged(),
                  onSubmitted: (_) => onSubmit(),
                ),
                const SizedBox(height: 14),
                _InlineAgeSelector(
                  selectedAge: selectedAge,
                  onSelected: onAgeSelected,
                ),
                const SizedBox(height: 14),
                const _HeroUnlockRow(),
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
            context.l10n.onboardingMissionPill,
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

class _InlineAgeSelector extends StatelessWidget {
  const _InlineAgeSelector({
    required this.selectedAge,
    required this.onSelected,
  });

  final ChildAge selectedAge;
  final ValueChanged<ChildAge> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.74)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cake_rounded,
                color: AppPalette.coral,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.onboardingAgeTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < ChildAge.values.length; i++) ...[
                Expanded(
                  child: _CompactAgeChip(
                    age: ChildAge.values[i],
                    selected: selectedAge == ChildAge.values[i],
                    onTap: () => onSelected(ChildAge.values[i]),
                  ),
                ),
                if (i != ChildAge.values.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactAgeChip extends StatelessWidget {
  const _CompactAgeChip({
    required this.age,
    required this.selected,
    required this.onTap,
  });

  final ChildAge age;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppPalette.coral : Colors.white;

    return BouncyTap(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.white : AppPalette.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppPalette.coral.withValues(alpha: 0.24),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
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
              size: 18,
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                context.l10n.childAgeLabel(age),
                maxLines: 1,
                softWrap: false,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: selected ? Colors.white : AppPalette.ink,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroUnlockRow extends StatelessWidget {
  const _HeroUnlockRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _UnlockBadge(
            icon: Icons.local_fire_department_rounded,
            color: AppPalette.coral,
            label: l10n.unlockMission,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _UnlockBadge(
            icon: Icons.extension_rounded,
            color: AppPalette.lavender,
            label: l10n.unlockGames,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _UnlockBadge(
            icon: Icons.star_rounded,
            color: AppPalette.mango,
            label: l10n.unlockPrizes,
          ),
        ),
      ],
    );
  }
}

class _UnlockBadge extends StatelessWidget {
  const _UnlockBadge({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                  height: 1,
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
