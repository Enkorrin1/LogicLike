import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PlayfulBackground extends StatelessWidget {
  const PlayfulBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEAF7FF),
            AppPalette.background,
            Color(0xFFFFFAEF),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _BackgroundSprinkles(),
          child,
        ],
      ),
    );
  }
}

class AppMark extends StatelessWidget {
  const AppMark({
    this.size = 46,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppPalette.mango,
            AppPalette.coral,
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.34),
        boxShadow: [
          BoxShadow(
            color: AppPalette.coral.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}

class IconBadge extends StatelessWidget {
  const IconBadge({
    required this.icon,
    required this.color,
    this.iconColor = AppPalette.ink,
    this.size = 48,
    super.key,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size * 0.52,
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  const InfoPill({
    required this.icon,
    required this.label,
    required this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.68)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppPalette.ink),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class PlayfulCard extends StatelessWidget {
  const PlayfulCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = AppPalette.surface,
    this.borderColor = AppPalette.border,
    this.gradient,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _BackgroundSprinkles extends StatelessWidget {
  const _BackgroundSprinkles();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Opacity(
        opacity: 0.36,
        child: Stack(
          children: [
            Positioned(
              top: 42,
              right: 28,
              child: Icon(
                Icons.star_rounded,
                color: AppPalette.mango,
                size: 18,
              ),
            ),
            Positioned(
              top: 112,
              left: 22,
              child: Icon(
                Icons.circle_outlined,
                color: AppPalette.sky,
                size: 18,
              ),
            ),
            Positioned(
              top: 218,
              right: 42,
              child: Icon(
                Icons.change_history_rounded,
                color: AppPalette.lavender,
                size: 20,
              ),
            ),
            Positioned(
              bottom: 136,
              left: 30,
              child: Icon(
                Icons.star_rounded,
                color: AppPalette.coral,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
