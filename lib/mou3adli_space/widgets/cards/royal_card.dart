import 'dart:ui';
import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/spacing.dart';
import '../../foundation/radius.dart';
import '../../foundation/shadows.dart';
import '../../foundation/motion.dart';

enum RoyalCardStyle {
  surface,
  elevated,
  glass,
  outlined,
  flat,
}

class RoyalCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final RoyalCardStyle style;
  final bool animate;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? elevation;

  const RoyalCard({
    super.key,
    required this.child,
    this.onTap,
    this.animate = true,
    this.style = RoyalCardStyle.elevated,
    this.color,
    this.borderRadius,
    this.elevation,
    this.padding = const EdgeInsets.all(RoyalSpacing.lg),
    this.margin = EdgeInsets.zero,
  });

  @override
  State<RoyalCard> createState() => _RoyalCardState();
}

class _RoyalCardState extends State<RoyalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: RoyalMotion.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.985).animate(
      CurvedAnimation(parent: _controller, curve: RoyalMotion.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.animate && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.animate) {
      _controller.reverse();
    }
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (widget.animate) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? RoyalRadius.lg;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: AnimatedContainer(
          duration: RoyalMotion.normal,
          curve: RoyalMotion.standard,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color ?? _backgroundColor(isDark),
            borderRadius: radius,
            border: _border(isDark),
            boxShadow: _shadow(),
          ),
          child: child,
        ),
      ),
      child: widget.child,
    );

    if (widget.style == RoyalCardStyle.glass) {
      card = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: card,
        ),
      );
    }

    if (widget.onTap == null) return card;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: card,
    );
  }

  Color _backgroundColor(bool isDark) {
    switch (widget.style) {
      case RoyalCardStyle.surface:
        return isDark ? RoyalColors.darkSurface : RoyalColors.surface;
      case RoyalCardStyle.elevated:
        return isDark ? RoyalColors.darkCard : RoyalColors.card;
      case RoyalCardStyle.glass:
        return isDark
            ? RoyalColors.darkGlass
            : Colors.white.withOpacity(0.72);
      case RoyalCardStyle.outlined:
        return isDark ? RoyalColors.darkSurface : RoyalColors.surface;
      case RoyalCardStyle.flat:
        return isDark ? RoyalColors.darkElevated : RoyalColors.gray50;
    }
  }

  Border? _border(bool isDark) {
    switch (widget.style) {
      case RoyalCardStyle.outlined:
        return Border.all(
          color: isDark ? RoyalColors.darkBorder : RoyalColors.border,
          width: 1.2,
        );
      case RoyalCardStyle.glass:
        return Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.35),
          width: 1.0,
        );
      default:
        return null;
    }
  }

  List<BoxShadow>? _shadow() {
    switch (widget.style) {
      case RoyalCardStyle.surface:
        return RoyalShadows.soft;
      case RoyalCardStyle.elevated:
        return RoyalShadows.medium;
      case RoyalCardStyle.glass:
        return RoyalShadows.floating;
      case RoyalCardStyle.outlined:
      case RoyalCardStyle.flat:
        return null;
    }
  }
}