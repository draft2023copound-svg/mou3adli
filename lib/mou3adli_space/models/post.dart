import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? postId;
  String? userId;
  String? username;
  String? name;
  String? userPhotoUrl;
  String? role;
  String? matiere;
  String? content;
  List<String>? mediaUrls;
  String? type; // 'text', 'image', 'video', 'poll'
  List<dynamic>? pollOptions;
  int? likes;
  List<String>? likedBy;
  int? comments;
  int? shares;
  List<String>? savedBy;
  bool? isAnnouncement;
  Timestamp? createdAt;

  PostModel({
    this.postId,
    this.userId,
    this.username,
    this.name,
    this.userPhotoUrl,
    this.role,
    this.matiere,
    this.content,
    this.mediaUrls,
    this.type,
    this.pollOptions,
    this.likes,
    this.likedBy,
    this.comments,
    this.shares,
    this.savedBy,
    this.isAnnouncement,
    this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      postId: data['postId'],
      userId: data['userId'],
      username: data['username'],
      name: data['name'],
      userPhotoUrl: data['userPhotoUrl'],
      role: data['role'],
      matiere: data['matiere'],
      content: data['content'],
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      type: data['type'] ?? 'text',
      pollOptions: data['pollOptions'],
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      comments: data['comments'] ?? 0,
      shares: data['shares'] ?? 0,
      savedBy: List<String>.from(data['savedBy'] ?? []),
      isAnnouncement: data['isAnnouncement'] ?? false,
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'name': name,
      'userPhotoUrl': userPhotoUrl,
      'role': role,
      'matiere': matiere,
      'content': content,
      'mediaUrls': mediaUrls,
      'type': type,
      'pollOptions': pollOptions,
      'likes': likes,
      'likedBy': likedBy,
      'comments': comments,
      'shares': shares,
      'savedBy': savedBy,
      'isAnnouncement': isAnnouncement,
      'createdAt': createdAt,
    };
  }
}
