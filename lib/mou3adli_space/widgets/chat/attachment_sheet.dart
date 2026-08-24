import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
import '../../foundation/typography.dart';

class AttachmentSheet extends StatelessWidget {
  final Function(int) onSelected;

  const AttachmentSheet({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.picture_as_pdf_rounded, "PDF", Colors.red),
      (Icons.quiz_rounded, "Quiz", Colors.green),
      (Icons.assignment_rounded, "Devoir", Colors.orange),
      (Icons.poll_rounded, "Sondage", Colors.blue),
      (Icons.image_rounded, "Image", Colors.purple),
      (Icons.camera_alt_rounded, "Caméra", Colors.teal),
      (Icons.videocam_rounded, "Vidéo", Colors.pink),
      (Icons.mic_rounded, "Audio", Colors.indigo),
      (Icons.calendar_month_rounded, "Planning", Colors.cyan),
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(24),
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: RoyalColors.gray300,
                borderRadius: RoyalRadius.full,
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: RoyalRadius.lg,
                  onTap: () {
                    onSelected(index);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: items[index].$3.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          items[index].$1,
                          color: items[index].$3,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        items[index].$2,
                        style: RoyalTypography.labelMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}