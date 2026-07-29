class Subject {
  final String nameAr;
  final String nameFr;
  final double coeff;
  final List<String> evaluations;

  Subject({required this.nameAr, required this.nameFr, required this.coeff, required this.evaluations});
}

final List<Subject> college9Subjects = [
  Subject(nameAr: "عربية", nameFr: "Arabe", coeff: 4, evaluations: ["Contrôle continu n°1", "Contrôle continu n°2", "Oral", "Devoir de synthèse"]),
  Subject(nameAr: "فرنسية", nameFr: "Français", coeff: 4, evaluations: ["Contrôle continu n°1", "Contrôle continu n°2", "Oral", "Devoir de synthèse"]),
  Subject(nameAr: "أنكليزية", nameFr: "Anglais", coeff: 1.5, evaluations: ["Contrôle continu n°1", "Contrôle continu n°2", "Oral", "Devoir de synthèse"]),
  Subject(nameAr: "رياضيات", nameFr: "Mathématiques", coeff: 3, evaluations: ["Contrôle continu n°1", "Contrôle continu n°2", "Devoir de synthèse"]),
  Subject(nameAr: "فيزياء", nameFr: "Physique", coeff: 1, evaluations: ["Contrôle continu", "Devoir de synthèse"]),
  Subject(nameAr: "علوم طبيعية", nameFr: "SVT", coeff: 1, evaluations: ["Contrôle continu", "Devoir de synthèse", "TP / Travaux pratiques"]),
];