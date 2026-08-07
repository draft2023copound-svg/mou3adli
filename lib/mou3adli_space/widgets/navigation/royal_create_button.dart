import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/shadows.dart';
import '../../foundation/motion.dart';

class RoyalCreateButton extends StatefulWidget {
  final VoidCallback onTap;

  const RoyalCreateButton({
    super.key,
    required this.onTap,
  });

  @override
  State<RoyalCreateButton> createState() => _RoyalCreateButtonState();
}

class _RoyalCreateButtonState extends State<RoyalCreateButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: RoyalMotion.fast,
      scale: _pressed ? 0.94 : 1.0,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                RoyalColors.gold400,
                RoyalColors.gold600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              ...RoyalShadows.glowGold,
              const BoxShadow(
                color: Color(0x40FFC929),
                blurRadius: 30,
                spreadRadius: 2,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}