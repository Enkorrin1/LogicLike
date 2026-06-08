import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';

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
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _OnboardingBackdropPainter(),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
              children: [
                const _OnboardingHero(),
                const SizedBox(height: 18),
                Text(
                  l10n.onboardingTitle,
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.onboardingSubtitle,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                DecoratedBox(
                  decoration: _softPanelDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nameController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: l10n.childNameLabel,
                            errorText:
                                _showNameError ? l10n.childNameError : null,
                            prefixIcon: const Icon(Icons.child_care_rounded),
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          l10n.ageSectionTitle,
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final age in ChildAge.values)
                              ChoiceChip(
                                label: Text(l10n.labelForAge(age)),
                                selected: _selectedAge == age,
                                avatar: _selectedAge == age
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 18,
                                      )
                                    : null,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedAge = age;
                                  });
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          l10n.learningGoalSectionTitle,
                          style: textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(_isSaving ? l10n.savingButton : l10n.startButton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingHero extends StatelessWidget {
  const _OnboardingHero();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: 184,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5BD5FF),
            Color(0xFFB9F6EA),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5EBFC5).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _OnboardingHeroBackdropPainter(),
            ),
          ),
          const Positioned(
            left: 8,
            bottom: -18,
            child: SizedBox(
              width: 132,
              height: 132,
              child: Image(
                image: AssetImage('assets/images/generated/planet.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Positioned(
            right: 22,
            top: 12,
            child: SizedBox(
              width: 94,
              height: 112,
              child: Image(
                image: AssetImage('assets/images/generated/rocket.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 22,
            top: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2D9AB1).withValues(alpha: 0.20),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Image(
                    image: AssetImage('assets/images/generated/lion.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 116,
            top: 32,
            right: 118,
            child: Text(
              l10n.onboardingHeroTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    height: 1.06,
                  ),
            ),
          ),
        ],
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
    final l10n = context.l10n;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDDF8F4) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF18B7AE) : const Color(0xFFD6EDE8),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF18B7AE).withValues(alpha: 0.13),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF18B7AE)
                    : const Color(0xFFFFF3D1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _goalIcon(goal),
                color: selected ? Colors.white : const Color(0xFFFF9D2E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labelForGoal(goal),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(l10n.descriptionForGoal(goal)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color:
                  selected ? const Color(0xFF18B7AE) : const Color(0xFF9AB3B4),
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

class _OnboardingBackdropPainter extends CustomPainter {
  const _OnboardingBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFFFFBF2),
    );

    final aquaPaint = Paint()..color = const Color(0xFFE2FBF5);
    canvas.drawCircle(
        Offset(size.width * 0.88, size.height * 0.10), 90, aquaPaint);
    canvas.drawCircle(
        Offset(size.width * 0.06, size.height * 0.72), 80, aquaPaint);

    final starPaint = Paint()..color = const Color(0xFFFFE05E);
    for (final point in [
      Offset(size.width * 0.12, size.height * 0.16),
      Offset(size.width * 0.86, size.height * 0.36),
      Offset(size.width * 0.18, size.height * 0.58),
    ]) {
      _drawStar(canvas, point, 9, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var index = 0; index < 10; index += 1) {
      final angle = -math.pi / 2 + index * math.pi / 5;
      final currentRadius = index.isEven ? radius : radius * 0.45;
      final point = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _OnboardingHeroBackdropPainter extends CustomPainter {
  const _OnboardingHeroBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawCloud(canvas, Offset(size.width * 0.18, 42), 0.8);
    _drawCloud(canvas, Offset(size.width * 0.74, 52), 0.7);

    final starPaint = Paint()..color = const Color(0xFFFFE05E);
    _drawStar(
        canvas, Offset(size.width * 0.50, size.height * 0.34), 12, starPaint);
    _drawStar(
        canvas, Offset(size.width * 0.86, size.height * 0.80), 9, starPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          -20,
          size.height * 0.72,
          size.width + 40,
          size.height * 0.36,
        ),
        const Radius.circular(90),
      ),
      Paint()..color = const Color(0xFF7BE0D1),
    );
  }

  void _drawCloud(Canvas canvas, Offset center, double scale) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.78);
    canvas.drawCircle(
        center + Offset(-20 * scale, 8 * scale), 17 * scale, paint);
    canvas.drawCircle(center, 20 * scale, paint);
    canvas.drawCircle(
        center + Offset(24 * scale, 9 * scale), 14 * scale, paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + Offset(2, 14 * scale),
          width: 76 * scale,
          height: 18 * scale,
        ),
        Radius.circular(12 * scale),
      ),
      paint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var index = 0; index < 10; index += 1) {
      final angle = -math.pi / 2 + index * math.pi / 5;
      final currentRadius = index.isEven ? radius : radius * 0.45;
      final point = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

BoxDecoration _softPanelDecoration() {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.94),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Colors.white, width: 2),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF7ABDB8).withValues(alpha: 0.17),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
  );
}
