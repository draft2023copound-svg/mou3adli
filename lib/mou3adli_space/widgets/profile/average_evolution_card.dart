import 'package:flutter/material.dart';
import '../../foundation/colors.dart';
// removed unused radius import
import '../cards/royal_card.dart';

class AverageEvolutionCard extends StatelessWidget {
  final List<double> values;

  const AverageEvolutionCard({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final current = values.last;
    final previous = values.length > 1 ? values[values.length - 2] : current;
    final delta = current - previous;

    return RoyalCard(
      margin: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Évolution de la moyenne",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values.map((v) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          v.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: v * 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                RoyalColors.royalBlue400,
                                RoyalColors.royalBlue700,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text("Actuelle : ${current.toStringAsFixed(2)}"),
              const Spacer(),
              Text(
                delta >= 0
                    ? "+${delta.toStringAsFixed(2)}"
                    : delta.toStringAsFixed(2),
                style: TextStyle(
                  color: delta >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}