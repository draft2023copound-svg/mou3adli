import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget dot(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        double t = controller.value;
        double scale = 0.6;
        if ((t * 3).floor() == index) scale = 1;
        return Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 60, bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [dot(0), dot(1), dot(2)],
      ),
    );
  }
}