import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
import '../../theme/app_theme.dart';
import '../challenge/challenge_screen.dart';
import '../parent/parent_screen.dart';
import 'home_screen.dart';

class FamilyShell extends StatefulWidget {
  const FamilyShell({
    required this.controller,
    super.key,
  });

  final AppController controller;

  @override
  State<FamilyShell> createState() => _FamilyShellState();
}

class _FamilyShellState extends State<FamilyShell> {
  int _selectedIndex = 0;
  String? _pendingAreaId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final profile = widget.controller.familyProfile;
        if (profile == null) {
          return const SizedBox.shrink();
        }

        final pages = [
          HomeScreen(
            profile: profile,
            onStartChallenge: () {
              setState(() {
                _selectedIndex = 1;
                _pendingAreaId = null;
              });
            },
            onStartArea: (areaId) {
              setState(() {
                _selectedIndex = 1;
                _pendingAreaId = areaId;
              });
            },
          ),
          ChallengeScreen(
            profile: profile,
            initialAreaId: _pendingAreaId,
            onInitialAreaHandled: () {
              if (!mounted || _pendingAreaId == null) {
                return;
              }

              setState(() {
                _pendingAreaId = null;
              });
            },
            onChallengeComplete: widget.controller.completeDailyChallenge,
            onPracticeComplete: widget.controller.completePracticePuzzle,
          ),
          ParentScreen(
            profile: profile,
            onResetProfile: widget.controller.resetFamilyProfile,
          ),
        ];

        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_selectedIndex),
              child: pages[_selectedIndex],
            ),
          ),
          bottomNavigationBar: _KidBottomNav(
            selectedIndex: _selectedIndex,
            onSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}

class _KidBottomNav extends StatelessWidget {
  const _KidBottomNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ink.withValues(alpha: 0.12),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _KidNavItem(
                icon: Icons.home_rounded,
                label: 'Домой',
                selected: selectedIndex == 0,
                selectedColor: AppPalette.teal,
                onTap: () => onSelected(0),
              ),
              _KidNavItem(
                icon: Icons.assignment_turned_in_rounded,
                label: 'Задание',
                selected: selectedIndex == 1,
                selectedColor: const Color(0xFF5CA8FF),
                onTap: () => onSelected(1),
              ),
              _KidNavItem(
                icon: Icons.group_rounded,
                label: 'Родителю',
                selected: selectedIndex == 2,
                selectedColor: AppPalette.lavender,
                onTap: () => onSelected(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KidNavItem extends StatelessWidget {
  const _KidNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: selected ? 1 : 0),
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutBack,
          builder: (context, selectedT, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                Feedback.forTap(context);
                onTap();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                decoration: BoxDecoration(
                  color: selected
                      ? selectedColor.withValues(alpha: 0.16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1 + selectedT * 0.08,
                      child: Container(
                        width: 38,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            Colors.transparent,
                            selectedColor,
                            selectedT,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color:
                                        selectedColor.withValues(alpha: 0.20),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          icon,
                          color: Color.lerp(
                            AppPalette.muted,
                            Colors.white,
                            selectedT,
                          ),
                          size: 23,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: selected ? AppPalette.ink : AppPalette.muted,
                            fontSize: 11,
                            fontWeight:
                                selected ? FontWeight.w900 : FontWeight.w800,
                            height: 1,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
