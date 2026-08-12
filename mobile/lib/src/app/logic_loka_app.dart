import 'package:flutter/material.dart';

import '../data/family_profile_store.dart';
import '../data/locale_store.dart';
import '../features/home/family_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/l10n.dart';
import '../notifications/app_notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/playful_ui.dart';
import 'app_controller.dart';

class LogicLokaApp extends StatefulWidget {
  const LogicLokaApp({
    required this.familyProfileStore,
    this.localeStore,
    this.reminderScheduler,
    this.locale,
    super.key,
  });

  final FamilyProfileStore familyProfileStore;
  final LocaleStore? localeStore;
  final ReminderScheduler? reminderScheduler;
  final Locale? locale;

  @override
  State<LogicLokaApp> createState() => _LogicLokaAppState();
}

class _LogicLokaAppState extends State<LogicLokaApp> {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppController(
      widget.familyProfileStore,
      localeStore: widget.localeStore,
      reminderScheduler: widget.reminderScheduler,
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

class _LoadingScreen extends StatefulWidget {
  const _LoadingScreen();

  @override
  State<_LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<_LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayfulBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, -4 * _controller.value),
                      child: Transform.scale(
                        scale: 0.98 + _controller.value * 0.04,
                        child: child,
                      ),
                    ),
                    child: Container(
                      width: 154,
                      height: 154,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.teal.withValues(alpha: 0.22),
                            blurRadius: 34,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar_lion.png',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    context.l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: const Color(0xFF075D5A),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.l10n.loadingMission,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppPalette.muted,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 168,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: const LinearProgressIndicator(
                        minHeight: 8,
                        backgroundColor: Colors.white,
                        color: AppPalette.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
