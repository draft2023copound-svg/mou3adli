import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/shadows.dart';

class ChatScrollButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;
  final int unreadCount;

  const ChatScrollButton({
    super.key,
    required this.visible,
    required this.onTap,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 250),
      scale: visible ? 1 : 0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: RoyalColors.royalBlue600,
            shape: BoxShape.circle,
            boxShadow: RoyalShadows.glowBlue,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: RoyalColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount > 9 ? "9+" : "$unreadCount",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}