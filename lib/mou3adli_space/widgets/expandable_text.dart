import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/styles.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: widget.text,
          style: AppStyles.bodyLarge,
        );
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);
        final isOverflowing = tp.didExceedMaxLines;

        return GestureDetector(
          onTap: isOverflowing ? () => setState(() => isExpanded = !isExpanded) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: AppStyles.bodyLarge,
                maxLines: isExpanded ? null : widget.maxLines,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
              ),
              if (isOverflowing && !isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Voir plus',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.royalBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}