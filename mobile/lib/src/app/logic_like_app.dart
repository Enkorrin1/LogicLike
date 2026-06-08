import 'package:flutter/material.dart';

import '../data/family_profile_store.dart';
import '../features/home/family_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'app_controller.dart';

class LogicLikeApp extends StatefulWidget {
  const LogicLikeApp({
    required this.familyProfileStore,
    this.locale,
    super.key,
  });

  final FamilyProfileStore familyProfileStore;
  final Locale? locale;

  @override
  State<LogicLikeApp> createState() => _LogicLikeAppState();
}

class _LogicLikeAppState extends State<LogicLikeApp> {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppController(widget.familyProfileStore)..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appTitle,
      locale: widget.locale ?? const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildAppTheme(),
      home: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const _LoadingScreen();
          }

          final familyProfile = _controller.familyProfile;
          if (familyProfile == null) {
            return OnboardingScreen(
              onComplete: _controller.completeOnboarding,
            );
          }

          return FamilyShell(controller: _controller);
        },
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
