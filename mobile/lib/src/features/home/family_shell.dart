import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
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
          HomeScreen(profile: profile),
          ChallengeScreen(
            profile: profile,
            onChallengeComplete: widget.controller.completeDailyChallenge,
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
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Домой',
              ),
              NavigationDestination(
                icon: Icon(Icons.extension_outlined),
                selectedIcon: Icon(Icons.extension_rounded),
                label: 'Задание',
              ),
              NavigationDestination(
                icon: Icon(Icons.family_restroom_outlined),
                selectedIcon: Icon(Icons.family_restroom_rounded),
                label: 'Родителю',
              ),
            ],
          ),
        );
      },
    );
  }
}
