import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/spacing.dart';
import '../../foundation/radius.dart';
import '../../foundation/shadows.dart';
import '../../foundation/typography.dart';
import '../../foundation/motion.dart';

enum RoyalButtonStyle {
  filled,
  outlined,
  ghost,
  glass,
  danger,
  gold,
}

class RoyalButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final RoyalButtonStyle style;
  final bool loading;
  final bool expanded;
  final double? width;
  final double height;
  final EdgeInsets? padding;

  const RoyalButton({
    super.key,
    required this.text,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.loading = false,
    this.expanded = false,
    this.width,
    this.height = RoyalSpacing.giant,
    this.padding,
    this.style = RoyalButtonStyle.filled,
  });

  @override
  State<RoyalButton> createState() => _RoyalButtonState();
}

class _RoyalButtonState extends State<RoyalButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: RoyalMotion.fast,
      curve: RoyalMotion.standard,
      child: AnimatedContainer(
        duration: RoyalMotion.normal,
        height: widget.height,
        width: widget.expanded ? double.infinity : widget.width,
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: RoyalSpacing.xl),
        decoration: BoxDecoration(
          color: _backgroundColor(isDark),
          borderRadius: RoyalRadius.full,
          border: _border(isDark),
          boxShadow: _shadow(),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: RoyalRadius.full,
            onTap: widget.loading ? null : widget.onPressed,
            onHighlightChanged: (v) => setState(() => _pressed = v),
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Center(
              child: AnimatedSwitcher(
                duration: RoyalMotion.normal,
                child: widget.loading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _foregroundColor(),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              size: 20,
                              color: _foregroundColor(),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            widget.text,
                            style: RoyalTypography.labelLarge.copyWith(
                              color: _foregroundColor(),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          if (widget.trailingIcon != null) ...[
                            const SizedBox(width: 8),
                            Icon(
                              widget.trailingIcon,
                              size: 18,
                              color: _foregroundColor(),
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _foregroundColor() {
    switch (widget.style) {
      case RoyalButtonStyle.filled:
      case RoyalButtonStyle.danger:
      case RoyalButtonStyle.gold:
        return Colors.white;
      case RoyalButtonStyle.glass:
        return Theme.of(context).brightness == Brightness.dark
            ? RoyalColors.darkTextPrimary
            : RoyalColors.textPrimary;
      case RoyalButtonStyle.outlined:
      case RoyalButtonStyle.ghost:
        return Theme.of(context).brightness == Brightness.dark
            ? RoyalColors.royalBlue300
            : RoyalColors.royalBlue600;
    }
  }

  Color _backgroundColor(bool isDark) {
    switch (widget.style) {
      case RoyalButtonStyle.filled:
        return isDark ? RoyalColors.royalBlue500 : RoyalColors.royalBlue600;
      case RoyalButtonStyle.glass:
        return isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.55);
      case RoyalButtonStyle.outlined:
      case RoyalButtonStyle.ghost:
        return Colors.transparent;
      case RoyalButtonStyle.danger:
        return RoyalColors.error;
      case RoyalButtonStyle.gold:
        return RoyalColors.gold500;
    }
  }

  Border? _border(bool isDark) {
    switch (widget.style) {
      case RoyalButtonStyle.outlined:
        return Border.all(
          color: isDark
              ? RoyalColors.royalBlue400
              : RoyalColors.royalBlue600,
          width: 1.5,
        );
      case RoyalButtonStyle.glass:
        return Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.0,
        );
      default:
        return null;
    }
  }

  List<BoxShadow>? _shadow() {
    switch (widget.style) {
      case RoyalButtonStyle.filled:
        return RoyalShadows.glowBlue;
      case RoyalButtonStyle.gold:
        return RoyalShadows.glowGold;
      case RoyalButtonStyle.glass:
        return RoyalShadows.soft;
      default:
        return null;
    }
  }
}