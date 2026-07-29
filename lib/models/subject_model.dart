import 'evaluation_model.dart';

class Subject {
  final String id;
  final String nameFr;
  final String nameAr;
  final double coefficient;
  final List<Evaluation> evaluations;
  final String iconName;

  Subject({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.coefficient,
    required this.evaluations,
    required this.iconName,
  });

  double get average {
    double totalWeighted = 0;
    double totalWeight = 0;
    for (final e in evaluations) {
      if (e.score != null) {
        totalWeighted += e.score! * e.weight;
        totalWeight += e.weight;
      }
    }
    if (totalWeight == 0) return 0;
    return totalWeighted / totalWeight;
  }

  bool get isComplete => evaluations.every((e) => e.score != null);

  int get filledCount => evaluations.where((e) => e.score != null).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameFr': nameFr,
        'nameAr': nameAr,
        'coefficient': coefficient,
        'evaluations': evaluations.map((e) => e.toJson()).toList(),
        'iconName': iconName,
      };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        nameFr: json['nameFr'],
        nameAr: json['nameAr'],
        coefficient: (json['coefficient'] as num).toDouble(),
        evaluations: (json['evaluations'] as List).map((e) => Evaluation.fromJson(e)).toList(),
        iconName: json['iconName'],
      );

  Subject copyWith({List<Evaluation>? evaluations}) => Subject(
        id: id,
        nameFr: nameFr,
        nameAr: nameAr,
        coefficient: coefficient,
        evaluations: evaluations ?? this.evaluations,
        iconName: iconName,
      );
}