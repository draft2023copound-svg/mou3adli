// AcademicUser model
class AcademicUser {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String section;
  final String school;
  final String classroom;
  final double average;
  final int rank;
  final int streak;
  final int badges;
  final int xp;
  final bool verified;
  final bool premium;
  final DateTime joinedAt;

  const AcademicUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.section,
    required this.school,
    required this.classroom,
    this.average = 0.0,
    this.rank = 0,
    this.streak = 0,
    this.badges = 0,
    this.xp = 0,
    this.verified = false,
    this.premium = false,
    required this.joinedAt,
  });

  AcademicUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? section,
    String? school,
    String? classroom,
    double? average,
    int? rank,
    int? streak,
    int? badges,
    int? xp,
    bool? verified,
    bool? premium,
    DateTime? joinedAt,
  }) {
    return AcademicUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      section: section ?? this.section,
      school: school ?? this.school,
      classroom: classroom ?? this.classroom,
      average: average ?? this.average,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
      xp: xp ?? this.xp,
      verified: verified ?? this.verified,
      premium: premium ?? this.premium,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}