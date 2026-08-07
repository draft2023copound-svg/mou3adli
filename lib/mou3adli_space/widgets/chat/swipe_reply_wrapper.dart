import 'package:flutter/material.dart';
import '../../foundation/colors.dart';

class SwipeReplyWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;

  const SwipeReplyWrapper({
    super.key,
    required this.child,
    required this.onReply,
  });

  @override
  State<SwipeReplyWrapper> createState() => _SwipeReplyWrapperState();
}

class _SwipeReplyWrapperState extends State<SwipeReplyWrapper> {
  double _dx = 0;
  static const double _threshold = 60;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          setState(() {
            _dx = (_dx + details.delta.dx).clamp(0, 90);
          });
        }
      },
      onHorizontalDragEnd: (_) {
        if (_dx > _threshold) {
          widget.onReply();
        }
        setState(() => _dx = 0);
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            left: 16,
            child: Opacity(
              opacity: (_dx / _threshold).clamp(0, 1),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: RoyalColors.royalBlue600,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.reply,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(_dx, 0, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}