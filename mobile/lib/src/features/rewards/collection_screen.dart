import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/playful_ui.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({
    required this.stars,
    required this.completedLevels,
    this.highlightDailyPrize = false,
    super.key,
  });

  final int stars;
  final int completedLevels;
  final bool highlightDailyPrize;

  static const _items = [
    _CollectionItemData(
      title: 'Лев',
      subtitle: 'первый герой',
      assetPath: 'assets/images/avatar_lion.png',
      unlockAfterLevels: 0,
      color: AppPalette.mango,
    ),
    _CollectionItemData(
      title: 'Космонавт',
      subtitle: 'миссия дня',
      assetPath: 'assets/images/home_astronaut_cutout.png',
      unlockAfterLevels: 1,
      color: AppPalette.sky,
    ),
    _CollectionItemData(
      title: 'Рысь',
      subtitle: 'логика',
      assetPath: 'assets/images/areas/area_logic_lynx.png',
      unlockAfterLevels: 2,
      color: AppPalette.coral,
    ),
    _CollectionItemData(
      title: 'Слон',
      subtitle: 'память',
      assetPath: 'assets/images/areas/area_memory_elephant.png',
      unlockAfterLevels: 3,
      color: AppPalette.lavender,
    ),
    _CollectionItemData(
      title: 'Хамелеон',
      subtitle: 'внимание',
      assetPath: 'assets/images/areas/area_attention_chameleon.png',
      unlockAfterLevels: 4,
      color: AppPalette.teal,
    ),
    _CollectionItemData(
      title: 'Робот',
      subtitle: 'счет',
      assetPath: 'assets/images/areas/area_math_robot.png',
      unlockAfterLevels: 5,
      color: AppPalette.mango,
    ),
    _CollectionItemData(
      title: 'Черепаха',
      subtitle: 'путь',
      assetPath: 'assets/images/areas/area_path_turtle.png',
      unlockAfterLevels: 6,
      color: AppPalette.sky,
    ),
    _CollectionItemData(
      title: 'Ракета',
      subtitle: 'большой приз',
      assetPath: 'assets/images/home_hero_astronaut.png',
      unlockAfterLevels: 8,
      color: AppPalette.coral,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = math.max(completedLevels, highlightDailyPrize ? 1 : 0);
    final unlockedCount =
        _items.where((item) => progress >= item.unlockAfterLevels).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Моя коллекция')),
      body: PlayfulBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            _CollectionHero(
              stars: stars,
              unlockedCount: unlockedCount,
              totalCount: _items.length,
              highlightDailyPrize: highlightDailyPrize,
            ),
            const SizedBox(height: 16),
            if (highlightDailyPrize) ...[
              const _NewPrizeBanner(),
              const SizedBox(height: 16),
            ],
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                final unlocked = progress >= item.unlockAfterLevels;
                final justOpened = highlightDailyPrize &&
                    item.unlockAfterLevels == 1 &&
                    unlocked;

                return _CollectionPrizeCard(
                  item: item,
                  unlocked: unlocked,
                  justOpened: justOpened,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionHero extends StatelessWidget {
  const _CollectionHero({
    required this.stars,
    required this.unlockedCount,
    required this.totalCount,
    required this.highlightDailyPrize,
  });

  final int stars;
  final int unlockedCount;
  final int totalCount;
  final bool highlightDailyPrize;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : unlockedCount / totalCount;

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE4FBFF),
            Color(0xFFFFF1C9),
            Color(0xFFE7D9FF),
          ],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.lavender.withValues(alpha: 0.16),
            blurRadius: 26,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -28,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white.withValues(alpha: 0.38),
              size: 128,
            ),
          ),
          Row(
            children: [
              Container(
                width: 92,
                height: 92,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.teal.withValues(alpha: 0.18),
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      highlightDailyPrize ? 'Приз дня' : 'Космо-призы',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: const Color(0xFF075D5A),
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$unlockedCount из $totalCount открыто',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppPalette.ink,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 9),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        value: progress.clamp(0, 1).toDouble(),
                        backgroundColor: Colors.white.withValues(alpha: 0.62),
                        valueColor: const AlwaysStoppedAnimation(
                          AppPalette.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _StarCounter(stars: stars),
            ],
          ),
        ],
      ),
    );
  }
}

class _StarCounter extends StatelessWidget {
  const _StarCounter({required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 68),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFC739), size: 27),
          const SizedBox(height: 2),
          Text(
            '$stars',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

class _NewPrizeBanner extends StatelessWidget {
  const _NewPrizeBanner();

  @override
  Widget build(BuildContext context) {
    return SoftShine(
      borderRadius: BorderRadius.circular(28),
      duration: const Duration(milliseconds: 2100),
      child: PlayfulCard(
        padding: const EdgeInsets.all(14),
        borderColor: AppPalette.mango.withValues(alpha: 0.56),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF5CF),
            Color(0xFFEAF7FF),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppPalette.coral,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Новый приз дня',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppPalette.ink,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Космонавт добавлен в коллекцию.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionPrizeCard extends StatelessWidget {
  const _CollectionPrizeCard({
    required this.item,
    required this.unlocked,
    required this.justOpened,
  });

  final _CollectionItemData item;
  final bool unlocked;
  final bool justOpened;

  void _showTapFeedback(BuildContext context) {
    Feedback.forTap(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 92),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: Text(
            unlocked
                ? '${item.title} уже в коллекции.'
                : 'Откроется после новых уровней.',
          ),
          duration: const Duration(milliseconds: 1200),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = unlocked ? item.color : const Color(0xFFC8D7DD);

    return BouncyTap(
      borderRadius: BorderRadius.circular(28),
      onTap: () => _showTapFeedback(context),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: unlocked ? 1 : 0.70,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cardColor.withValues(alpha: unlocked ? 0.92 : 0.42),
                cardColor.withValues(alpha: unlocked ? 0.62 : 0.28),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: unlocked ? 0.18 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (justOpened)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'новый',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppPalette.coral,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.72),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              item.assetPath,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          if (!unlocked)
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppPalette.ink.withValues(alpha: 0.64),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unlocked ? item.subtitle : '${item.unlockAfterLevels} ур.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionItemData {
  const _CollectionItemData({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.unlockAfterLevels,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String assetPath;
  final int unlockAfterLevels;
  final Color color;
}
