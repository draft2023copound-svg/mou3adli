import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
// removed unused typography import

class AcademicScoreCard extends StatelessWidget {
  final double score;
  final double average;
  final int rank;
  final int streak;
  final int xp;

  const AcademicScoreCard({
    super.key,
    required this.score,
    required this.average,
    required this.rank,
    required this.streak,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            RoyalColors.royalBlue700,
            RoyalColors.royalBlue500,
          ],
        ),
        borderRadius: RoyalRadius.xl,
      ),
      child: Column(
        children: [
          const Text(
            "ACADEMIC SCORE",
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _ScorePainter(score),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      score.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "/100",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _stat(average.toStringAsFixed(2), "Moyenne"),
              _stat("#$rank", "Classement"),
              _stat("$streak", "Streak"),
              _stat("$xp", "XP"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ScorePainter extends CustomPainter {
  final double value;

  _ScorePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    const start = -math.pi / 2;
    final rect = Offset.zero & size;
    final bg = Paint()
      ..color = Colors.white24
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, bg);

    final fg = Paint()
      ..shader = const LinearGradient(
        colors: [RoyalColors.gold400, RoyalColors.gold600],
      ).createShader(rect)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start, 2 * math.pi * (value / 100), false, fg);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}