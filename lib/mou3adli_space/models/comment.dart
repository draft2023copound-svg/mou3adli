import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? commentId;
  String? postId;
  String? userId;
  String? username;
  String? name;
  String? userPhotoUrl;
  String? text;
  int? likes;
  List<String>? likedBy;
  String? parentId; // pour les réponses imbriquées
  Timestamp? createdAt;

  CommentModel({
    this.commentId,
    this.postId,
    this.userId,
    this.username,
    this.name,
    this.userPhotoUrl,
    this.text,
    this.likes,
    this.likedBy,
    this.parentId,
    this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> data) {
    return CommentModel(
      commentId: data['commentId'],
      postId: data['postId'],
      userId: data['userId'],
      username: data['username'],
      name: data['name'],
      userPhotoUrl: data['userPhotoUrl'],
      text: data['text'],
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      parentId: data['parentId'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'username': username,
      'name': name,
      'userPhotoUrl': userPhotoUrl,
      'text': text,
      'likes': likes,
      'likedBy': likedBy,
      'parentId': parentId,
      'createdAt': createdAt,
    };
  }
}
