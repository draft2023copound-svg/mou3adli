import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/shadows.dart';
import '../../foundation/motion.dart';

enum RoyalIconButtonStyle {
  filled,
  outlined,
  soft,
  glass,
}

class RoyalIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;
  final bool selected;
  final double size;
  final RoyalIconButtonStyle style;

  const RoyalIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.tooltip,
    this.selected = false,
    this.size = 48,
    this.style = RoyalIconButtonStyle.soft,
  });

  @override
  State<RoyalIconButton> createState() => _RoyalIconButtonState();
}

class _RoyalIconButtonState extends State<RoyalIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget child = AnimatedScale(
      duration: RoyalMotion.fast,
      curve: RoyalMotion.emphasis,
      scale: _pressed ? 0.90 : 1,
      child: AnimatedContainer(
        duration: RoyalMotion.normal,
        curve: RoyalMotion.standard,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _backgroundColor(isDark),
          shape: BoxShape.circle,
          border: _border(isDark),
          boxShadow: _shadow(),
        ),
        child: Icon(
          widget.icon,
          color: _foregroundColor(),
          size: 22,
        ),
      ),
    );

    child = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: RoyalRadius.full,
        onTap: widget.onPressed,
        onHighlightChanged: (v) => setState(() => _pressed = v),
        child: child,
      ),
    );

    if (widget.tooltip == null) return child;

    return Tooltip(
      message: widget.tooltip!,
      child: child,
    );
  }

  Color _foregroundColor() {
    if (widget.selected) return Colors.white;
    return widget.color ??
        (Theme.of(context).brightness == Brightness.dark
            ? RoyalColors.darkTextPrimary
            : RoyalColors.textPrimary);
  }

  Color _backgroundColor(bool isDark) {
    if (widget.selected) return RoyalColors.royalBlue600;
    switch (widget.style) {
      case RoyalIconButtonStyle.filled:
        return RoyalColors.royalBlue600;
      case RoyalIconButtonStyle.soft:
        return isDark
            ? RoyalColors.royalBlue800.withValues(alpha: 0.3)
            : RoyalColors.royalBlue50;
      case RoyalIconButtonStyle.glass:
        return Colors.white.withValues(alpha: 0.65);
      case RoyalIconButtonStyle.outlined:
        return Colors.transparent;
    }
  }

  Border? _border(bool isDark) {
    if (widget.style == RoyalIconButtonStyle.outlined) {
      return Border.all(
        color: isDark ? RoyalColors.darkBorder : RoyalColors.border,
      );
    }
    if (widget.style == RoyalIconButtonStyle.glass) {
      return Border.all(
        color: Colors.white.withValues(alpha: 0.30),
      );
    }
    return null;
  }

  List<BoxShadow>? _shadow() {
    if (widget.selected) return RoyalShadows.glowBlue;
    switch (widget.style) {
      case RoyalIconButtonStyle.glass:
        return RoyalShadows.soft;
      case RoyalIconButtonStyle.outlined:
        return RoyalShadows.soft;
      default:
        return null;
    }
  }
}