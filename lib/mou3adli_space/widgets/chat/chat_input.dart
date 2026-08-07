import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onVoice;
  final String? hint;
  final Widget? replyPreview;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttachment,
    required this.onVoice,
    this.hint,
    this.replyPreview,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? RoyalColors.darkSurface
              : Colors.white,
          border: Border(
            top: BorderSide(color: RoyalColors.border),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyPreview != null) replyPreview!,
            Row(
              children: [
                IconButton(
                  onPressed: onAttachment,
                  icon: Icon(
                    Icons.add_circle,
                    color: RoyalColors.royalBlue600,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: RoyalColors.gray50,
                      borderRadius: RoyalRadius.full,
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hint ?? "Poser une question...",
                        border: InputBorder.none,
                        hintStyle: RoyalTypography.bodyMedium.copyWith(
                          color: RoyalColors.textMuted,
                        ),
                      ),
                      style: RoyalTypography.bodyMedium,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onVoice,
                  icon: Icon(
                    Icons.mic,
                    color: RoyalColors.royalBlue600,
                  ),
                ),
                IconButton(
                  onPressed: onSend,
                  icon: Icon(
                    Icons.send,
                    color: RoyalColors.royalBlue600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}