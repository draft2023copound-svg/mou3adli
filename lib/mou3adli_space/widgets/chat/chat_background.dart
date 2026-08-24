import 'dart:ui';
import 'package:flutter/material.dart';
import '../../foundation/colors.dart';

class ChatBackground extends StatelessWidget {
  final Widget child;

  const ChatBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffF9FBFF),
                Color(0xffF3F7FD),
                Color(0xffEEF4FC),
              ],
            ),
          ),
        ),
        // Decorative blobs
        Positioned(
          top: -120,
          right: -60,
          child: _blob(
            RoyalColors.royalBlue400.withValues(alpha: 0.05),
            260,
          ),
        ),
        Positioned(
          bottom: -120,
          left: -80,
          child: _blob(
            RoyalColors.gold400.withValues(alpha: 0.05),
            320,
          ),
        ),
        // Blur overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(color: Colors.transparent),
        ),
        // Content
        child,
      ],
    );
  }

  Widget _blob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}