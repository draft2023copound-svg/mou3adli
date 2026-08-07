import 'package:flutter/material.dart';

class AcademicHeatmap extends StatelessWidget {
  final List<int> values;

  const AcademicHeatmap({
    super.key,
    required this.values,
  });

  Color _color(int v) {
    if (v == 0) return Colors.grey.shade200;
    if (v == 1) return Colors.blue.shade100;
    if (v == 2) return Colors.blue.shade300;
    if (v == 3) return Colors.blue.shade500;
    return Colors.blue.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: values.length,
        itemBuilder: (c, i) {
          return Container(
            decoration: BoxDecoration(
              color: _color(values[i]),
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}