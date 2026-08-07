import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/shadows.dart';
import '../../foundation/typography.dart';
import '../../foundation/motion.dart';
import '../avatar/royal_avatar.dart';
import 'message_status.dart';
import '../../models/academic_message.dart';

class AcademicMessageWidget extends StatelessWidget {
  final AcademicMessage data;
  final Widget child;
  final Widget? footer;
  final VoidCallback? onReply;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;

  const AcademicMessageWidget({
    super.key,
    required this.data,
    required this.child,
    this.footer,
    this.onReply,
    this.onLongPress,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mine = data.mine;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!mine) ...[
            RoyalAvatar(
              image: data.avatar ?? '',
              size: 40,
              role: data.role == AcademicSenderRole.teacher 
                  ? RoyalUserRole.teacher 
                  : RoyalUserRole.student,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null && details.primaryVelocity! > 100) {
                  onReply?.call();
                }
              },
              onDoubleTap: onDoubleTap,
              onLongPress: onLongPress,
              child: AnimatedContainer(
                duration: RoyalMotion.normal,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: mine
                      ? RoyalColors.royalBlue600
                      : (isDark ? RoyalColors.darkElevated : Colors.white),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(22),
                    topRight: const Radius.circular(22),
                    bottomLeft: Radius.circular(mine ? 22 : 4),
                    bottomRight: Radius.circular(mine ? 4 : 22),
                  ),
                  boxShadow: mine ? null : RoyalShadows.soft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!mine)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          data.senderName,
                          style: RoyalTypography.labelMedium.copyWith(
                            color: mine ? Colors.white70 : RoyalColors.textSecondary,
                          ),
                        ),
                      ),
                    child,
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(data.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: mine ? Colors.white60 : RoyalColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (mine) MessageStatus(status: data.status),
                      ],
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: 10),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}