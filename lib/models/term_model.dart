import 'subject_model.dart';

class Term {
  final String id;
  final String nameFr;
  final String nameAr;
  final List<Subject> subjects;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;

  Term({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.subjects,
    this.startDate,
    this.endDate,
    this.isActive = true,
  });

  double get generalAverage {
    double totalWeighted = 0;
    double totalCoef = 0;
    for (final s in subjects) {
      final avg = s.average;
      if (avg > 0) {
        totalWeighted += avg * s.coefficient;
        totalCoef += s.coefficient;
      }
    }
    if (totalCoef == 0) return 0;
    return totalWeighted / totalCoef;
  }

  int get completedSubjects => subjects.where((s) => s.average > 0).length;
  int get totalSubjects => subjects.length;

  double get progress {
    if (subjects.isEmpty) return 0;
    int totalEvals = 0;
    int filledEvals = 0;
    for (final s in subjects) {
      totalEvals += s.evaluations.length;
      filledEvals += s.filledCount;
    }
    if (totalEvals == 0) return 0;
    return filledEvals / totalEvals;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nameFr': nameFr,
    'nameAr': nameAr,
    'subjects': subjects.map((s) => s.toJson()).toList(),
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'isActive': isActive,
  };

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    id: json['id'],
    nameFr: json['nameFr'],
    nameAr: json['nameAr'],
    subjects: (json['subjects'] as List).map((s) => Subject.fromJson(s)).toList(),
    startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    isActive: json['isActive'] ?? true,
  );

  Term copyWith({
    List<Subject>? subjects,
    bool? isActive,
  }) => Term(
    id: id,
    nameFr: nameFr,
    nameAr: nameAr,
    subjects: subjects ?? this.subjects,
    startDate: startDate,
    endDate: endDate,
    isActive: isActive ?? this.isActive,
  );
}