class User {
  final String id;
  String fullName;
  String email;
  String? photoUrl;
  String schoolName;
  String cycle; // "college" | "lycee"
  String classLevel; // "7eme", "8eme", "9eme", "1ere", "2eme", "3eme", "4eme"
  String? stream; // "commun", "pilote", "sciences", "lettres", etc.
  String? optionId; // "allemand", "espagnol", "italien", "musique", "arts_plastiques"
  DateTime createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoUrl,
    required this.schoolName,
    required this.cycle,
    required this.classLevel,
    this.stream,
    this.optionId,
    required this.createdAt,
  });

  String get displayClass {
    if (cycle == 'college') {
      final map = {'7eme': '7ème Année', '8eme': '8ème Année', '9eme': '9ème Année'};
      return map[classLevel] ?? classLevel;
    } else {
      final map = {'1ere': '1ère Année', '2eme': '2ème Année', '3eme': '3ème Année', '4eme': '4ème Année'};
      return map[classLevel] ?? classLevel;
    }
  }

  String get displayStream {
    if (stream == null) return '';
    final map = {
      'commun': 'Commun',
      'pilote': 'Pilote',
      'general': 'Tronc commun',
      'sciences': 'Sciences',
      'lettres': 'Lettres',
      'economie': 'Économie & Gestion',
      'tech_info': 'Technologie Info',
      'math': 'Mathématiques',
      'sciences_exp': 'Sciences Exp.',
      'sciences_tech': 'Sciences Techniques',
      'sciences_info': 'Sciences Info',
      'sport': 'Sport',
    };
    return map[stream] ?? stream!;
  }

  String? get displayOption {
    if (optionId == null) return null;
    final map = {
      'allemand': 'Allemand',
      'espagnol': 'Espagnol',
      'italien': 'Italien',
      'musique': 'Musique',
      'arts_plastiques': 'Arts Plastiques',
    };
    return map[optionId] ?? optionId;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'photoUrl': photoUrl,
    'schoolName': schoolName,
    'cycle': cycle,
    'classLevel': classLevel,
    'stream': stream,
    'optionId': optionId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    photoUrl: json['photoUrl'],
    schoolName: json['schoolName'],
    cycle: json['cycle'],
    classLevel: json['classLevel'],
    stream: json['stream'],
    optionId: json['optionId'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}