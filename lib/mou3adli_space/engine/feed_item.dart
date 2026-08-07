enum FeedType {
  announcement,
  teacherPost,
  studentPost,
  question,
  quiz,
  exercise,
  pdf,
  video,
  live,
  poll,
  achievement,
  event,
}

class FeedItem {
  final FeedType type;
  final DateTime createdAt;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String? mediaUrl;
  final int likes;
  final int comments;
  final int shares;

  const FeedItem({
    required this.type,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.mediaUrl,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });
}