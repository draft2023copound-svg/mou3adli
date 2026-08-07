// AnnouncementModel
class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String teacher;
  final String? subject;
  final DateTime date;
  final DateTime? expiresAt;
  final bool pinned;
  final bool urgent;
  final List<String>? attachments;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.teacher,
    this.subject,
    required this.date,
    this.expiresAt,
    this.pinned = false,
    this.urgent = false,
    this.attachments,
  });
}