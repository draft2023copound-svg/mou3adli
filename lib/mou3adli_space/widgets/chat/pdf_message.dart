import 'package:flutter/material.dart';
// removed unused foundation/colors import
import '../../foundation/radius.dart';
import '../../models/academic_message.dart';
import 'academic_message.dart';

class PdfMessage extends StatelessWidget {
  final AcademicMessage data;

  const PdfMessage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return AcademicMessageWidget(
      data: data,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: RoyalRadius.md,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: RoyalRadius.md,
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "PDF • 2.4 MB",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: RoyalRadius.md,
                ),
              ),
              child: const Text("Ouvrir"),
            ),
          ],
        ),
      ),
    );
  }
}