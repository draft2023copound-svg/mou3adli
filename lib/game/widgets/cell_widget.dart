import 'package:flutter/material.dart';
import '../models/block.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class CellWidget extends StatelessWidget {
  final Block? block;
  final double size;
  final bool isGhost, isHighlighted;
  final VoidCallback? onTap;

  const CellWidget({
    super.key,
    this.block,
    required this.size,
    this.isGhost = false,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = block?.color ?? kEmptyCellColor;
    final Color displayColor = isGhost
        ? kGhostColor
        : isHighlighted
            ? baseColor.lighten(0.3)
            : baseColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: displayColor,
          borderRadius: BorderRadius.circular(kCellBorderRadius),
          border: block == null && !isGhost
              ? Border.all(color: kCellBorderColor.withOpacity(0.3), width: 0.5)
              : null,
          boxShadow: block != null && !isGhost
              ? [
                  BoxShadow(
                    color: displayColor.darken(0.4).withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ]
              : null,
        ),
        child: block != null && !isGhost
            ? Center(
                child: Container(
                  width: size * 0.35,
                  height: size * 0.35,
                  decoration: BoxDecoration(
                    color: displayColor.lighten(0.25).withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}