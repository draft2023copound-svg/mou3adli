import 'academic_card_type.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Academic Card Model — Unified feed item
/// =======================================================

class AcademicCardModel {
  final AcademicCardType type;
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String avatar;
  final String author;
  final String? authorRole;
  final DateTime date;
  final String? media;
  final String? mediaType;
  final int likes;
  final int comments;
  final int shares;
  final bool liked;
  final bool bookmarked;
  final bool pinned;
  final bool verified;
  final Map<String, dynamic>? metadata;

  const AcademicCardModel({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.avatar,
    required this.author,
    required this.date,
    this.authorRole,
    this.media,
    this.mediaType,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.liked = false,
    this.bookmarked = false,
    this.pinned = false,
    this.verified = false,
    this.metadata,
  });

  AcademicCardModel copyWith({
    AcademicCardType? type,
    String? id,
    String? title,
    String? subtitle,
    String? content,
    String? avatar,
    String? author,
    String? authorRole,
    DateTime? date,
    String? media,
    String? mediaType,
    int? likes,
    int? comments,
    int? shares,
    bool? liked,
    bool? bookmarked,
    bool? pinned,
    bool? verified,
    Map<String, dynamic>? metadata,
  }) {
    return AcademicCardModel(
      type: type ?? this.type,
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      avatar: avatar ?? this.avatar,
      author: author ?? this.author,
      authorRole: authorRole ?? this.authorRole,
      date: date ?? this.date,
      media: media ?? this.media,
      mediaType: mediaType ?? this.mediaType,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      liked: liked ?? this.liked,
      bookmarked: bookmarked ?? this.bookmarked,
      pinned: pinned ?? this.pinned,
      verified: verified ?? this.verified,
      metadata: metadata ?? this.metadata,
    );
  }
}