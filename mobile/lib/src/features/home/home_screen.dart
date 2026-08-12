// ignore_for_file: unused_element

import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';
import '../../l10n/localized_content.dart';
import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';
import '../rewards/collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.profile,
    required this.onStartChallenge,
    required this.onStartArea,
    required this.onLanguageChanged,
    super.key,
  });

  final FamilyProfile profile;
  final VoidCallback onStartChallenge;
  final ValueChanged<String> onStartArea;
  final Future<void> Function(AppLanguage language) onLanguageChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  void _showHint(String message) {
    Feedback.forTap(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 104),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: Text(message),
          duration: const Duration(milliseconds: 1500),
        ),
      );
  }

  void _openCollection({
    required int stars,
    required int completedLevels,
    required bool completedToday,
  }) {
    Feedback.forTap(context);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CollectionScreen(
          stars: stars,
          completedLevels: completedLevels,
          highlightDailyPrize: completedToday,
        ),
      ),
    );
  }

  Future<void> _toggleLanguage() async {
    final nextLanguage = widget.profile.language.next;

    Feedback.forTap(context);
    await widget.onLanguageChanged(nextLanguage);
    if (!mounted) {
      return;
    }

    final l10n = context.l10n;
    _showHint(l10n.languageChanged(l10n.languageName(nextLanguage)));
  }

  @override
  Widget build(BuildContext context) {
    final dailyStars = widget.profile.completedChallenges;
    final mapProgress = widget.profile.completedLevels;
    final totalStars = 125 + dailyStars;
    final hearts = math.max(1, 5 - (dailyStars % 3));
    final completedToday = widget.profile.completedOn(DateTime.now());
    final streak =
        completedToday ? 5 : math.max(1, math.min(4, dailyStars + 1));
    final nodes = FoundationCatalog.starterMap.nodes;
    final level = math.min(8, math.max(1, mapProgress + 1));
    final progressValue = math.min(0.95, mapProgress / 8);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEF),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _ambientController,
            builder: (context, child) {
              return _SpaceBackdrop(progress: _ambientController.value);
            },
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              children: [
                _Reveal(
                  order: 0,
                  child: _GreetingHeader(
                    animation: _ambientController,
                    childName: widget.profile.childName,
                    stars: totalStars,
                    hearts: hearts,
                    language: widget.profile.language,
                    onStarsTap: () => _showHint(
                      context.l10n.homeStarsHint,
                    ),
                    onPlanetTap: () => _openCollection(
                      stars: totalStars,
                      completedLevels: mapProgress,
                      completedToday: completedToday,
                    ),
                    onLanguageTap: _toggleLanguage,
                  ),
                ),
                const SizedBox(height: 14),
                _Reveal(
                  order: 1,
                  child: _MissionHeroCard(
                    animation: _ambientController,
                    completedToday: completedToday,
                    level: level,
                    progressValue: progressValue,
                    onStart: widget.onStartChallenge,
                  ),
                ),
                const SizedBox(height: 16),
                _Reveal(
                  order: 2,
                  child: _FreePlayPanel(
                    animation: _ambientController,
                    onStartArea: widget.onStartArea,
                  ),
                ),
                const SizedBox(height: 16),
                _Reveal(
                  order: 3,
                  child: _AdventurePath(
                    animation: _ambientController,
                    nodes: nodes,
                    stars: mapProgress,
                    onCurrentTap: widget.onStartChallenge,
                    onLockedTap: () => _showHint(
                      context.l10n.homeLockedLevelHint,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _Reveal(
                  order: 4,
                  child: _StreakStrip(
                    animation: _ambientController,
                    streak: streak,
                    completedToday: completedToday,
                    onTap: () => _showHint(
                      completedToday
                          ? context.l10n.homeStreakSavedHint
                          : context.l10n.homeStreakNeedMissionHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpaceBackdrop extends StatelessWidget {
  const _SpaceBackdrop({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final wave = math.sin(progress * math.pi * 2);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF50D3FF),
                Color(0xFFC6F6FF),
                Color(0xFFFFFAEF),
              ],
              stops: [0, 0.36, 0.72],
            ),
          ),
        ),
        CustomPaint(painter: _TwinklePainter(progress)),
        Positioned(
          top: 118 + wave * 5,
          left: 18,
          child: const _SoftCloud(width: 92),
        ),
        Positioned(
          top: 88 - wave * 4,
          right: 22,
          child: const _SoftCloud(width: 74),
        ),
        Positioned(
          top: 206,
          left: -36,
          child: _TerrainBlob(
            width: 132,
            height: 72,
            color: const Color(0xFFF3936E).withValues(alpha: 0.64),
          ),
        ),
        Positioned(
          top: 230,
          right: -28,
          child: _TerrainBlob(
            width: 150,
            height: 84,
            color: const Color(0xFF55C9B8).withValues(alpha: 0.58),
          ),
        ),
        Positioned(
          top: 178 + wave * 6,
          right: 58,
          child: Transform.rotate(
            angle: -0.15 + wave * 0.04,
            child: Icon(
              Icons.rocket_launch_rounded,
              color: AppPalette.coral.withValues(alpha: 0.80),
              size: 58,
            ),
          ),
        ),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({
    required this.animation,
    required this.childName,
    required this.stars,
    required this.hearts,
    required this.language,
    required this.onStarsTap,
    required this.onPlanetTap,
    required this.onLanguageTap,
  });

  final Animation<double> animation;
  final String childName;
  final int stars;
  final int hearts;
  final AppLanguage language;
  final VoidCallback onStarsTap;
  final VoidCallback onPlanetTap;
  final VoidCallback onLanguageTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final scale = 1 + math.sin(animation.value * math.pi * 2) * 0.025;
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            width: 86,
            height: 86,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppPalette.teal.withValues(alpha: 0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
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
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeGreeting(childName),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF075D5A),
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        height: 1.02,
                      ),
                ),
                const SizedBox(height: 8),
                _LanguageButton(
                  language: language,
                  onTap: onLanguageTap,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TopRewardPill(
              animation: animation,
              icon: Icons.star_rounded,
              value: '$stars',
              color: const Color(0xFFFFC739),
              onTap: onStarsTap,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _RoundIconButton(
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFFF5A7D),
                  label: '$hearts',
                  onTap: onStarsTap,
                ),
                const SizedBox(width: 8),
                _PlanetButton(onTap: onPlanetTap),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.language,
    required this.onTap,
  });

  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.languageButtonSemantics(
        context.l10n.languageName(language),
      ),
      child: _TapScale(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ink.withValues(alpha: 0.09),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language_rounded,
                color: AppPalette.teal,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                language.shortLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPalette.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopRewardPill extends StatelessWidget {
  const _TopRewardPill({
    required this.animation,
    required this.icon,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final Animation<double> animation;
  final IconData icon;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppPalette.ink.withValues(alpha: 0.11),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: math.sin(animation.value * math.pi * 2) * 0.14,
                  child: child,
                );
              },
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 5),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppPalette.ink,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppPalette.ink.withValues(alpha: 0.09),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanetButton extends StatelessWidget {
  const _PlanetButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7B72FF),
              Color(0xFF42D6C6),
            ],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppPalette.lavender.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Icon(
          Icons.public_rounded,
          color: Colors.white,
          size: 23,
        ),
      ),
    );
  }
}

class _StreakStrip extends StatelessWidget {
  const _StreakStrip({
    required this.animation,
    required this.streak,
    required this.completedToday,
    required this.onTap,
  });

  final Animation<double> animation;
  final int streak;
  final bool completedToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppPalette.teal.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF25C8B5), Color(0xFF11A39C)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.teal.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFFC739),
                size: 34,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.homeStreakTitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppPalette.muted,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    completedToday
                        ? context.l10n.homeStreakDays(streak)
                        : context.l10n.homeStreakWaiting,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF075D5A),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 0,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var index = 0; index < 5; index++)
                        _StreakStar(
                          lit: index < streak,
                          phase: animation.value,
                          delay: index * 0.14,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakStar extends StatelessWidget {
  const _StreakStar({
    required this.lit,
    required this.phase,
    required this.delay,
  });

  final bool lit;
  final double phase;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final pulse =
        lit ? 1 + math.sin((phase + delay) * math.pi * 2) * 0.10 : 1.0;

    return Transform.scale(
      scale: pulse,
      child: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Icon(
          Icons.star_rounded,
          size: 26,
          color: lit ? const Color(0xFFFFC739) : const Color(0xFFD8E4E8),
        ),
      ),
    );
  }
}

class _MissionHeroCard extends StatelessWidget {
  const _MissionHeroCard({
    required this.animation,
    required this.completedToday,
    required this.level,
    required this.progressValue,
    required this.onStart,
  });

  final Animation<double> animation;
  final bool completedToday;
  final int level;
  final double progressValue;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(32),
      onTap: onStart,
      child: Container(
        height: 164,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1476FF),
              Color(0xFF0B42B6),
              Color(0xFF071B72),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B42B6).withValues(alpha: 0.28),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroStarsPainter(animation.value),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroScenePainter(),
              ),
            ),
            Positioned(
              right: -12,
              bottom: -10,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final wave = math.sin(animation.value * math.pi * 2);
                  return Transform.translate(
                    offset: Offset(0, wave * 6),
                    child: Transform.rotate(
                      angle: wave * 0.025,
                      child: child,
                    ),
                  );
                },
                child: SizedBox(
                  width: 154,
                  height: 164,
                  child: Image.asset(
                    'assets/images/home_astronaut_cutout.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF071B72).withValues(alpha: 0.95),
                      const Color(0xFF0B42B6).withValues(alpha: 0.72),
                      const Color(0xFF071B72).withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 14,
              width: 184,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _MissionTag(),
                  const SizedBox(height: 8),
                  Text(
                    completedToday
                        ? context.l10n.homeMissionFreePlay
                        : context.l10n.homeMissionDaily,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    completedToday
                        ? context.l10n.homeTrainingOpen
                        : context.l10n.homeLevel(level),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 142,
                    child: _AnimatedProgressBar(value: progressValue),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: 14,
              child: _StartMissionButton(
                animation: animation,
                width: 142,
                label: completedToday
                    ? context.l10n.homeMissionChoose
                    : context.l10n.homeMissionStart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionTag extends StatelessWidget {
  const _MissionTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC69BFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.event_available_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            context.l10n.homeMissionTag,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _MissionChip extends StatelessWidget {
  const _MissionChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _FreePlayPanel extends StatelessWidget {
  const _FreePlayPanel({
    required this.animation,
    required this.onStartArea,
  });

  final Animation<double> animation;
  final ValueChanged<String> onStartArea;

  @override
  Widget build(BuildContext context) {
    const items = [
      _FreePlayData(
        areaId: 'logic',
        color: Color(0xFFFFD28E),
      ),
      _FreePlayData(
        areaId: 'memory',
        color: Color(0xFFA9F4E8),
      ),
      _FreePlayData(
        areaId: 'attention',
        color: Color(0xFFFFC6D5),
      ),
      _FreePlayData(
        areaId: 'math',
        color: Color(0xFFDCD6FF),
      ),
      _FreePlayData(
        areaId: 'space',
        color: Color(0xFFBFF6D0),
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.teal.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF9F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppPalette.teal,
                  size: 23,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.homeFreePlayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppPalette.ink,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    Text(
                      context.l10n.homeFreePlaySubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppPalette.muted,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                Expanded(
                  child: _FreePlayItem(
                    data: items[i],
                    animation: animation,
                    delay: i * 0.12,
                    onTap: () => onStartArea(items[i].areaId),
                  ),
                ),
                if (i != items.length - 1) const SizedBox(width: 7),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _FreePlayData {
  const _FreePlayData({
    required this.areaId,
    required this.color,
  });

  final String areaId;
  final Color color;
}

class _FreePlayItem extends StatelessWidget {
  const _FreePlayItem({
    required this.data,
    required this.animation,
    required this.delay,
    required this.onTap,
  });

  final _FreePlayData data;
  final Animation<double> animation;
  final double delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final lift =
                  math.sin((animation.value + delay) * math.pi * 2) * 2;
              return Transform.translate(
                offset: Offset(0, lift),
                child: child,
              );
            },
            child: AreaCharacterBadge(
              areaId: data.areaId,
              color: data.color.withValues(alpha: 0.48),
              size: 62,
              padding: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.areaTitle(data.areaId),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _StartMissionButton extends StatelessWidget {
  const _StartMissionButton({
    required this.animation,
    required this.label,
    this.width = 116,
  });

  final Animation<double> animation;
  final String label;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7E78), Color(0xFFFF5B6C)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF5B6C).withValues(alpha: 0.34),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          const SizedBox(width: 6),
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final offset = math.sin(animation.value * math.pi * 2) * 3 + 1.5;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickGames extends StatelessWidget {
  const _QuickGames({
    required this.animation,
    required this.onStart,
  });

  final Animation<double> animation;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: context.l10n.homeMiniGamesTitle,
          subtitle: context.l10n.homeMiniGamesSubtitle,
          icon: Icons.videogame_asset_rounded,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MiniGameCard(
                animation: animation,
                delay: 0,
                icon: Icons.grid_view_rounded,
                label: context.l10n.homeQuickPairs,
                color: const Color(0xFFFFE29B),
                onTap: onStart,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniGameCard(
                animation: animation,
                delay: 0.22,
                icon: Icons.route_rounded,
                label: context.l10n.homeQuickPath,
                color: const Color(0xFFBFF6D0),
                onTap: onStart,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniGameCard(
                animation: animation,
                delay: 0.44,
                icon: Icons.calculate_rounded,
                label: context.l10n.homeQuickCount,
                color: const Color(0xFFDCD6FF),
                onTap: onStart,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniGameCard extends StatelessWidget {
  const _MiniGameCard({
    required this.animation,
    required this.delay,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final Animation<double> animation;
  final double delay;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        height: 106,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppPalette.ink.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final lift =
                    math.sin((animation.value + delay) * math.pi * 2) * 3;
                return Transform.translate(
                  offset: Offset(0, lift),
                  child: child,
                );
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.76),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppPalette.ink, size: 24),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.ink,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTiles extends StatelessWidget {
  const _DashboardTiles({
    required this.animation,
    required this.level,
    required this.progressValue,
    required this.stars,
    required this.onProgressTap,
    required this.onCollectionTap,
  });

  final Animation<double> animation;
  final int level;
  final double progressValue;
  final int stars;
  final VoidCallback onProgressTap;
  final VoidCallback onCollectionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _ProgressTile(
            animation: animation,
            level: level,
            progressValue: progressValue,
            stars: stars,
            onTap: onProgressTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CollectionTile(
            animation: animation,
            onTap: onCollectionTap,
          ),
        ),
      ],
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({
    required this.animation,
    required this.level,
    required this.progressValue,
    required this.stars,
    required this.onTap,
  });

  final Animation<double> animation;
  final int level;
  final double progressValue;
  final int stars;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currentXp = math.min(200, 120 + (stars - 125) * 8);

    return _TapScale(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        height: 178,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD8FFF4), Color(0xFFBDF4EA)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppPalette.teal.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.homeProgressTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF075D5A),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                const _SmallRoundIcon(
                  icon: Icons.bar_chart_rounded,
                  color: AppPalette.teal,
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        math.sin(animation.value * math.pi * 2) * 3,
                      ),
                      child: child,
                    );
                  },
                  child: const _TinyPlanet(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.homeLevel(level),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPalette.ink,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.l10n.homeProgressStars(currentXp, 200),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF075D5A),
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 9),
                      _AnimatedProgressBar(value: progressValue),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({
    required this.animation,
    required this.onTap,
  });

  final Animation<double> animation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        height: 178,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF1C9), Color(0xFFE7D9FF)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppPalette.lavender.withValues(alpha: 0.16),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: -4,
              child: Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/home_astronaut_cutout.png',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.25),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeCollectionTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF5943A8),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Spacer(),
                Center(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: math.sin(animation.value * math.pi * 2) * 0.035,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: 90,
                      height: 78,
                      child: Image.asset(
                        'assets/images/home_astronaut_cutout.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '15',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppPalette.lavender,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          context.l10n.homeCollectionStickers,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppPalette.lavender,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdventurePath extends StatelessWidget {
  const _AdventurePath({
    required this.animation,
    required this.nodes,
    required this.stars,
    required this.onCurrentTap,
    required this.onLockedTap,
  });

  final Animation<double> animation;
  final List<MapNode> nodes;
  final int stars;
  final VoidCallback onCurrentTap;
  final VoidCallback onLockedTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: context.l10n.homeLevelsTitle,
            subtitle: context.l10n.homeLevelsSubtitle,
            icon: Icons.explore_rounded,
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 24) / 4;

              return Wrap(
                spacing: 8,
                runSpacing: 10,
                children: [
                  for (final node in nodes)
                    _AdventureNode(
                      animation: animation,
                      width: itemWidth,
                      node: node,
                      state: node.stateForStars(stars),
                      onCurrentTap: onCurrentTap,
                      onLockedTap: onLockedTap,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdventureNode extends StatelessWidget {
  const _AdventureNode({
    required this.animation,
    required this.width,
    required this.node,
    required this.state,
    required this.onCurrentTap,
    required this.onLockedTap,
  });

  final Animation<double> animation;
  final double width;
  final MapNode node;
  final MapNodeState state;
  final VoidCallback onCurrentTap;
  final VoidCallback onLockedTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      MapNodeState.completed => AppPalette.teal,
      MapNodeState.current => AppPalette.coral,
      MapNodeState.locked => const Color(0xFFC8D7DD),
    };
    final icon = switch (state) {
      MapNodeState.completed => Icons.star_rounded,
      MapNodeState.current => Icons.play_arrow_rounded,
      MapNodeState.locked => Icons.lock_rounded,
    };
    final caption = switch (state) {
      MapNodeState.completed => context.l10n.homeNodeCompleted,
      MapNodeState.current => context.l10n.homeNodePlay,
      MapNodeState.locked => context.l10n.homeNodeSoon,
    };

    return _TapScale(
      borderRadius: BorderRadius.circular(20),
      onTap: state == MapNodeState.current ? onCurrentTap : onLockedTap,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final scale = state == MapNodeState.current
                    ? 1 + math.sin(animation.value * math.pi * 2) * 0.08
                    : 1.0;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.24),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 27),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              context.l10n.mapNodeTitle(node.order),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppPalette.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 1),
            Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppPalette.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppPalette.teal, size: 21),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.muted,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedProgressBar extends StatelessWidget {
  const _AnimatedProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0, 1).toDouble()),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutBack,
      builder: (context, progress, child) {
        return Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF15B8AA), Color(0xFF40D6C6)],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SmallRoundIcon extends StatelessWidget {
  const _SmallRoundIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _TinyPlanet extends StatelessWidget {
  const _TinyPlanet();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.22,
            child: Container(
              width: 58,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF7B72FF).withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF27D3C2), Color(0xFF0AA39A)],
              ),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 13,
            top: 15,
            child: Container(
              width: 12,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFBFF6D0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 13,
            child: Container(
              width: 14,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFBFF6D0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCloud extends StatelessWidget {
  const _SoftCloud({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.88,
      child: SizedBox(
        width: width,
        height: width * 0.42,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: width,
              height: width * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Positioned(
              left: width * 0.14,
              bottom: width * 0.08,
              child: _CloudPuff(size: width * 0.32),
            ),
            Positioned(
              left: width * 0.36,
              bottom: width * 0.10,
              child: _CloudPuff(size: width * 0.40),
            ),
            Positioned(
              right: width * 0.13,
              bottom: width * 0.07,
              child: _CloudPuff(size: width * 0.28),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudPuff extends StatelessWidget {
  const _CloudPuff({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _TerrainBlob extends StatelessWidget {
  const _TerrainBlob({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(height),
          topRight: Radius.circular(height),
          bottomLeft: const Radius.circular(18),
          bottomRight: const Radius.circular(18),
        ),
      ),
    );
  }
}

class _TapScale extends StatefulWidget {
  const _TapScale({
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;

    return Semantics(
      button: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTapUp: enabled
            ? (_) {
                _setPressed(false);
                widget.onTap?.call();
              }
            : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          scale: _pressed ? 0.965 : 1,
          child: widget.child,
        ),
      ),
    );
  }
}

class _Reveal extends StatefulWidget {
  const _Reveal({
    required this.order,
    required this.child,
  });

  final int order;
  final Widget child;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration(milliseconds: 70 * widget.order), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.06),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}

class _TwinklePainter extends CustomPainter {
  const _TwinklePainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final points = <Offset>[
      Offset(size.width * 0.14, 108),
      Offset(size.width * 0.31, 76),
      Offset(size.width * 0.54, 124),
      Offset(size.width * 0.86, 78),
      Offset(size.width * 0.78, 176),
      Offset(size.width * 0.24, 218),
      Offset(size.width * 0.92, 246),
    ];

    for (var i = 0; i < points.length; i++) {
      final pulse = (math.sin((t + i * 0.17) * math.pi * 2) + 1) / 2;
      paint.color = Colors.white.withValues(alpha: 0.35 + pulse * 0.42);
      canvas.drawCircle(points[i], 2.5 + pulse * 2.3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TwinklePainter oldDelegate) {
    return oldDelegate.t != t;
  }
}

class _HeroScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.shader = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFF9C59F6),
        Color(0xFF6C4FEF),
      ],
    ).createShader(
      Rect.fromCircle(
        center: Offset(size.width * 0.82, size.height * 0.22),
        radius: 36,
      ),
    );
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.22), 30, paint);
    paint.shader = null;
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = const Color(0xFFE7C7FF).withValues(alpha: 0.58);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.82, size.height * 0.22),
        width: 78,
        height: 22,
      ),
      paint,
    );

    paint
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF42D6C6),
          Color(0xFF087C9A),
        ],
      ).createShader(
        Rect.fromLTWH(
          size.width * 0.56,
          size.height * 0.77,
          size.width * 0.54,
          size.height * 0.34,
        ),
      );
    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.52,
        size.height * 0.78,
        size.width * 0.64,
        size.height * 0.34,
      ),
      paint,
    );
    paint.shader = null;
    paint.color = const Color(0xFF075D5A).withValues(alpha: 0.24);
    for (final crater in <Offset>[
      Offset(size.width * 0.70, size.height * 0.88),
      Offset(size.width * 0.86, size.height * 0.92),
      Offset(size.width * 0.60, size.height * 0.96),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: crater, width: 28, height: 12),
        paint,
      );
    }

    paint.color = Colors.white.withValues(alpha: 0.12);
    canvas.drawCircle(Offset(size.width * 0.18, size.height * 0.18), 42, paint);
  }

  @override
  bool shouldRepaint(covariant _HeroScenePainter oldDelegate) => false;
}

class _HeroStarsPainter extends CustomPainter {
  const _HeroStarsPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final points = <Offset>[
      Offset(size.width * 0.62, size.height * 0.17),
      Offset(size.width * 0.82, size.height * 0.26),
      Offset(size.width * 0.54, size.height * 0.44),
      Offset(size.width * 0.70, size.height * 0.76),
      Offset(size.width * 0.92, size.height * 0.66),
    ];

    for (var i = 0; i < points.length; i++) {
      final pulse = (math.sin((t + i * 0.21) * math.pi * 2) + 1) / 2;
      paint.color =
          const Color(0xFFFFE26D).withValues(alpha: 0.50 + pulse * 0.40);
      _drawStar(canvas, points[i], 6 + pulse * 4, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? radius : radius * 0.45;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final point = Offset(
        center.dx + math.cos(angle) * r,
        center.dy + math.sin(angle) * r,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeroStarsPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
