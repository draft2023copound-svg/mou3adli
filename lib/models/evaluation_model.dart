class Evaluation {
  final String id;
  final String nameFr;
  final String nameAr;
  final double weight;
  double? score;

  Evaluation({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.weight,
    this.score,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameFr': nameFr,
        'nameAr': nameAr,
        'weight': weight,
        'score': score,
      };

  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
        id: json['id'],
        nameFr: json['nameFr'],
        nameAr: json['nameAr'],
        weight: (json['weight'] as num).toDouble(),
        score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      );

  Evaluation copyWith({double? score}) => Evaluation(
        id: id,
        nameFr: nameFr,
        nameAr: nameAr,
        weight: weight,
        score: score ?? this.score,
      );
}