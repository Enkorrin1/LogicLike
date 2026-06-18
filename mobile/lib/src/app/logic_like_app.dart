import 'package:flutter/material.dart';

import '../data/family_profile_store.dart';
import '../data/locale_store.dart';
import '../features/home/family_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../l10n/generated/app_localizations.dart';
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final familyProfile = _controller.familyProfile;
        final appLocale = widget.locale ??
            familyProfile?.language.locale ??
            _controller.locale;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: buildAppTheme(),
          locale: appLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
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
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayfulBackground(
        child: Center(
          child: PlayfulCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppMark(size: 56),
                const SizedBox(height: 18),
                const CircularProgressIndicator(),
                const SizedBox(height: 14),
                Text(context.l10n.loadingMission),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
