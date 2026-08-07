import 'package:flutter/material.dart';
// removed unused foundation/colors import
import '../../models/academic_message.dart';

class MessageStatus extends StatelessWidget {
  final AcademicMessageStatus status;

  const MessageStatus({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AcademicMessageStatus.sending:
        return const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
        );
      case AcademicMessageStatus.sent:
        return const Icon(Icons.check, size: 16, color: Colors.white70);
      case AcademicMessageStatus.delivered:
        return const Icon(Icons.done_all, size: 16, color: Colors.white70);
      case AcademicMessageStatus.read:
        return const Icon(Icons.done_all, size: 16, color: Colors.blue);
    }
  }
}