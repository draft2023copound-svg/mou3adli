import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onQr;

  const ProfileActionButtons({
    super.key,
    required this.onEdit,
    required this.onShare,
    required this.onQr,
  });

  Widget _button(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _button(Icons.edit, "Modifier", onEdit),
        const SizedBox(width: 12),
        _button(Icons.share, "Partager", onShare),
        const SizedBox(width: 12),
        _button(Icons.qr_code, "QR", onQr),
      ],
    );
  }
}