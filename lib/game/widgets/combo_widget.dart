import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ComboWidget extends StatelessWidget {
  final int combo;
  final double size;

  const ComboWidget({
    super.key,
    required this.combo,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    if (combo < 2) return const SizedBox.shrink();

    final intensity = (combo - 1).clamp(1, 5);
    final colors = [
      kSuccessColor,
      kWarningColor,
      Colors.orange,
      kAccentColor,
      Colors.purple,
    ];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colors[intensity - 1].withOpacity(0.3),
            colors[intensity - 1].withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colors[intensity - 1].withOpacity(0.3),
            blurRadius: 12 * intensity.toDouble(),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'x$combo',
          style: TextStyle(
            fontSize: size * 0.45,
            fontWeight: FontWeight.w900,
            color: colors[intensity - 1],
          ),
        ),
      ),
    );
  }
}