import 'dart:ui';
import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/shadows.dart';
import '../../foundation/typography.dart';

class RoyalSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilter;
  final VoidCallback? onVoice;
  final VoidCallback? onTap;
  final bool enabled;
  final bool autofocus;

  const RoyalSearchBar({
    super.key,
    this.controller,
    this.hint = "Rechercher...",
    this.onChanged,
    this.onFilter,
    this.onVoice,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  State<RoyalSearchBar> createState() => _RoyalSearchBarState();
}

class _RoyalSearchBarState extends State<RoyalSearchBar> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: RoyalRadius.full,
        border: Border.all(
          color: focused ? RoyalColors.royalBlue400 : RoyalColors.border,
          width: 1.2,
        ),
        boxShadow: focused ? RoyalShadows.glowBlue : RoyalShadows.soft,
      ),
      child: ClipRRect(
        borderRadius: RoyalRadius.full,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            children: [
              const SizedBox(width: 18),
              const Icon(
                Icons.search_rounded,
                color: RoyalColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Focus(
                  onFocusChange: (v) => setState(() => focused = v),
                  child: TextField(
                    controller: widget.controller,
                    enabled: widget.enabled,
                    autofocus: widget.autofocus,
                    onTap: widget.onTap,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      border: InputBorder.none,
                      hintStyle: RoyalTypography.bodyMedium.copyWith(
                        color: RoyalColors.textMuted,
                      ),
                    ),
                    style: RoyalTypography.bodyLarge,
                  ),
                ),
              ),
              if (widget.onVoice != null)
                _Action(icon: Icons.mic_none_rounded, onTap: widget.onVoice!),
              if (widget.onFilter != null)
                _Action(icon: Icons.tune_rounded, onTap: widget.onFilter!),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _Action({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: RoyalRadius.full,
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: RoyalColors.royalBlue50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: RoyalColors.royalBlue600, size: 20),
          ),
        ),
      ),
    );
  }
}