import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
import '../../foundation/radius.dart';
// removed unused typography import

class AcademicIdentityCard extends StatelessWidget {
  final String name;
  final String section;
  final String school;
  final double average;
  final int rank;
  final int streak;
  final int badges;
  final String avatar;

  const AcademicIdentityCard({
    super.key,
    required this.name,
    required this.section,
    required this.school,
    required this.average,
    required this.rank,
    required this.streak,
    required this.badges,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(24),
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
          CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage(avatar),
          ),
          const SizedBox(height: 18),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            section,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            school,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _metric(average.toStringAsFixed(2), "Moyenne"),
              _metric("#$rank", "Classement"),
              _metric("$streak", "Streak"),
              _metric("$badges", "Badges"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}