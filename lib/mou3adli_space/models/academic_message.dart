// Academic Message model
enum AcademicMessageType {
  text,
  image,
  pdf,
  homework,
  quiz,
  announcement,
  voice,
  video,
  poll,
}

enum AcademicSenderRole {
  student,
  teacher,
  admin,
  ai,
}

enum AcademicMessageStatus {
  sending,
  sent,
  delivered,
  read,
}

class AcademicMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? avatar;
  final AcademicSenderRole role;
  final AcademicMessageType type;
  final AcademicMessageStatus status;
  final String message;
  final DateTime createdAt;
  final bool mine;
  final bool pinned;
  final bool edited;
  final String? attachment;
  final String? attachmentName;
  final String? attachmentSize;
  final Duration? voiceDuration;
  final Map<String, int> reactions;
  final int replies;
  final String? replyToId;
  final String? replyToName;
  final String? replyToText;

  const AcademicMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.role,
    required this.type,
    required this.status,
    required this.message,
    required this.createdAt,
    required this.mine,
    this.avatar,
    this.pinned = false,
    this.edited = false,
    this.attachment,
    this.attachmentName,
    this.attachmentSize,
    this.voiceDuration,
    this.reactions = const {},
    this.replies = 0,
    this.replyToId,
    this.replyToName,
    this.replyToText,
  });

  AcademicMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? avatar,
    AcademicSenderRole? role,
    AcademicMessageType? type,
    AcademicMessageStatus? status,
    String? message,
    DateTime? createdAt,
    bool? mine,
    bool? pinned,
    bool? edited,
    String? attachment,
    String? attachmentName,
    String? attachmentSize,
    Duration? voiceDuration,
    Map<String, int>? reactions,
    int? replies,
    String? replyToId,
    String? replyToName,
    String? replyToText,
  }) {
    return AcademicMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      role: role ?? this.role,
      type: type ?? this.type,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      mine: mine ?? this.mine,
      avatar: avatar ?? this.avatar,
      pinned: pinned ?? this.pinned,
      edited: edited ?? this.edited,
      attachment: attachment ?? this.attachment,
      attachmentName: attachmentName ?? this.attachmentName,
      attachmentSize: attachmentSize ?? this.attachmentSize,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      reactions: reactions ?? this.reactions,
      replies: replies ?? this.replies,
      replyToId: replyToId ?? this.replyToId,
      replyToName: replyToName ?? this.replyToName,
      replyToText: replyToText ?? this.replyToText,
    );
  }
}