import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
// removed unused radius import
import '../../foundation/typography.dart';
import '../../foundation/motion.dart';

class QuickActionBar extends StatelessWidget {
  final VoidCallback? onQuiz;
  final VoidCallback? onHomework;
  final VoidCallback? onPdf;
  final VoidCallback? onVideo;
  final VoidCallback? onImage;
  final VoidCallback? onPoll;

  const QuickActionBar({
    super.key,
    this.onQuiz,
    this.onHomework,
    this.onPdf,
    this.onVideo,
    this.onImage,
    this.onPoll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _ActionItem(
            icon: Icons.quiz_rounded,
            label: "Quiz",
            color: Colors.green,
            onTap: onQuiz,
          ),
          _ActionItem(
            icon: Icons.assignment_rounded,
            label: "Devoir",
            color: Colors.orange,
            onTap: onHomework,
          ),
          _ActionItem(
            icon: Icons.picture_as_pdf_rounded,
            label: "PDF",
            color: Colors.red,
            onTap: onPdf,
          ),
          _ActionItem(
            icon: Icons.videocam_rounded,
            label: "Vidéo",
            color: Colors.deepPurple,
            onTap: onVideo,
          ),
          _ActionItem(
            icon: Icons.image_rounded,
            label: "Image",
            color: Colors.blue,
            onTap: onImage,
          ),
          _ActionItem(
            icon: Icons.poll_rounded,
            label: "Sondage",
            color: Colors.teal,
            onTap: onPoll,
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  State<_ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<_ActionItem>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: RoyalMotion.fast,
          scale: _pressed ? 0.92 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: RoyalTypography.labelSmall.copyWith(
                  color: RoyalColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}