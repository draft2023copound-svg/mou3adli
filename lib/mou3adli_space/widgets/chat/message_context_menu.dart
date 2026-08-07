import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';

class MessageContextMenu extends StatelessWidget {
  final VoidCallback onReply;
  final VoidCallback onCopy;
  final VoidCallback onForward;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const MessageContextMenu({
    super.key,
    required this.onReply,
    required this.onCopy,
    required this.onForward,
    required this.onPin,
    required this.onDelete,
  });

  Widget _tile(BuildContext context, IconData icon, String title, Color color,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: RoyalTypography.bodyMedium.copyWith(color: color),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? RoyalColors.darkSurface
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: RoyalColors.gray300,
                borderRadius: RoyalRadius.full,
              ),
            ),
            _tile(context, Icons.reply_rounded, "Répondre",
                RoyalColors.royalBlue600, onReply),
            _tile(context, Icons.copy_rounded, "Copier",
                RoyalColors.textPrimary, onCopy),
            _tile(context, Icons.forward_rounded, "Transférer",
                RoyalColors.royalBlue600, onForward),
            _tile(context, Icons.push_pin_rounded, "Épingler",
                RoyalColors.gold600, onPin),
            _tile(context, Icons.delete_outline_rounded, "Supprimer",
                RoyalColors.error, onDelete),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}