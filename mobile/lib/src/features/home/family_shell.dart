import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';
import '../course/course_screen.dart';
import '../lesson/lesson_screen.dart';
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
  CourseDefinition? _selectedCourse;
  String? _activeLessonId;

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
            onStartMission: () {
              setState(() {
                _selectedCourse = null;
                _activeLessonId = null;
                _selectedIndex = 1;
              });
            },
            onCourseSelected: (course) {
              setState(() {
                _selectedCourse = course;
                _activeLessonId = null;
                _selectedIndex = 1;
              });
            },
          ),
          _selectedCourse != null && _activeLessonId == null
              ? CourseScreen(
                  profile: profile,
                  course: _selectedCourse!,
                  onStartLesson: (lessonId) {
                    setState(() {
                      _activeLessonId = lessonId;
                    });
                  },
                  onBackHome: () {
                    setState(() {
                      _selectedCourse = null;
                      _selectedIndex = 0;
                    });
                  },
                )
              : LessonScreen(
                  profile: profile,
                  lessonId: _activeLessonId,
                  onLessonComplete: widget.controller.completeCurrentMapLesson,
                  onBackToMap: () {
                    setState(() {
                      if (_selectedCourse != null) {
                        _activeLessonId = null;
                      } else {
                        _selectedIndex = 0;
                      }
                    });
                  },
                ),
          ParentScreen(
            profile: profile,
            onChildSelected: widget.controller.selectChildProfile,
            onChildAdded: widget.controller.addChildProfile,
            onSubscriptionPlanChanged: widget.controller.updateSubscriptionPlan,
            onResetProfile: widget.controller.resetFamilyProfile,
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: _PlayfulNavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
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

class _PlayfulNavigationBar extends StatelessWidget {
  const _PlayfulNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF62B8B4).withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: 66,
            backgroundColor: Colors.transparent,
            indicatorColor: const Color(0xFFDDF8F4),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                color: selected
                    ? const Color(0xFF0E8F88)
                    : const Color(0xFF426A70),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                color: selected
                    ? const Color(0xFF0E8F88)
                    : const Color(0xFF7E98A0),
                size: selected ? 27 : 25,
              );
            }),
          ),
          child: NavigationBar(
            elevation: 0,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: l10n.homeTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.assignment_turned_in_outlined),
                selectedIcon: const Icon(Icons.assignment_turned_in_rounded),
                label: l10n.challengeTab,
              ),
              NavigationDestination(
                icon: const Icon(Icons.supervisor_account_outlined),
                selectedIcon: const Icon(Icons.supervisor_account_rounded),
                label: l10n.parentTab,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
