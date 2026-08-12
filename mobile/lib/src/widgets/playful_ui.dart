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

class AreaCharacterBadge extends StatelessWidget {
  const AreaCharacterBadge({
    required this.areaId,
    required this.color,
    this.size = 64,
    this.padding = 4,
    super.key,
  });

  final String areaId;
  final Color color;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.10),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.10),
          ),
        ],
      ),
      child: Image.asset(
        _areaCharacterAsset(areaId),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

String _areaCharacterAsset(String areaId) {
  return switch (areaId) {
    'logic' => 'assets/images/areas/area_logic_lynx.png',
    'memory' => 'assets/images/areas/area_memory_elephant.png',
    'attention' => 'assets/images/areas/area_attention_chameleon.png',
    'math' => 'assets/images/areas/area_math_robot.png',
    'space' => 'assets/images/areas/area_path_turtle.png',
    _ => 'assets/images/avatar_lion.png',
  };
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLabelWidth = constraints.hasBoundedWidth
            ? (constraints.maxWidth - 73).clamp(0, 113).toDouble()
            : 113.0;

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
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxLabelWidth),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
        );
      },
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

class BouncyTap extends StatefulWidget {
  const BouncyTap({
    required this.child,
    this.onTap,
    this.borderRadius,
    this.pressedScale = 0.965,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double pressedScale;

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap> {
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
          scale: _pressed ? widget.pressedScale : 1,
          child: widget.child,
        ),
      ),
    );
  }
}

class SoftShine extends StatefulWidget {
  const SoftShine({
    required this.child,
    required this.borderRadius,
    this.enabled = true,
    this.duration = const Duration(milliseconds: 2200),
    this.color = Colors.white,
    super.key,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final bool enabled;
  final Duration duration;
  final Color color;

  @override
  State<SoftShine> createState() => _SoftShineState();
}

class _SoftShineState extends State<SoftShine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SoftShine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: [
          widget.child,
          if (widget.enabled)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final height = constraints.maxHeight;
                        final left = width * (-0.55 + _controller.value * 1.7);

                        return Stack(
                          children: [
                            Positioned(
                              left: left,
                              top: -height * 0.25,
                              bottom: -height * 0.25,
                              width: width * 0.34,
                              child: Transform.rotate(
                                angle: 0.28,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        widget.color.withValues(alpha: 0),
                                        widget.color.withValues(alpha: 0.32),
                                        widget.color.withValues(alpha: 0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
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
