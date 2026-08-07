// TeacherModel
class TeacherModel {
  final String id;
  final String name;
  final String avatar;
  final String subject;
  final String school;
  final double rating;
  final int reviewCount;
  final bool online;
  final bool verified;
  final String? bio;
  final List<String>? specialties;

  const TeacherModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.subject,
    required this.school,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.online = false,
    this.verified = true,
    this.bio,
    this.specialties,
  });
}