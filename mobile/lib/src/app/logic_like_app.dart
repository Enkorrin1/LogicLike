import 'package:flutter/material.dart';

import '../data/family_profile_store.dart';
import '../data/locale_store.dart';
import '../features/home/family_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/playful_ui.dart';
import 'app_controller.dart';

class LogicLikeApp extends StatefulWidget {
  const LogicLikeApp({
    required this.familyProfileStore,
    this.localeStore,
    this.locale,
    super.key,
  });

  final FamilyProfileStore familyProfileStore;
  final LocaleStore? localeStore;
  final Locale? locale;

  @override
  State<LogicLikeApp> createState() => _LogicLikeAppState();
}

class _LogicLikeAppState extends State<LogicLikeApp> {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppController(
      widget.familyProfileStore,
      localeStore: widget.localeStore,
    )..load();
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
      locale: widget.locale ?? _controller.locale,
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
    return Scaffold(
      body: const PlayfulBackground(
        child: Center(
          child: PlayfulCard(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppMark(size: 56),
                SizedBox(height: 18),
                CircularProgressIndicator(),
                SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Text(
            context.l10n.loadingMission,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
