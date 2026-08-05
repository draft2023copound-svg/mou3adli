import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? username;
  String? name;
  String? email;
  String? photoUrl;
  String? bio;
  String? role; // 'prof' ou 'eleve'
  String? matiere; // pour les profs
  List<String>? followers;
  List<String>? following;
  List<String>? savedPosts;
  bool? isVerified;
  Timestamp? createdAt;

  UserModel({
    this.uid,
    this.username,
    this.name,
    this.email,
    this.photoUrl,
    this.bio,
    this.role,
    this.matiere,
    this.followers,
    this.following,
    this.savedPosts,
    this.isVerified,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      username: data['username'],
      name: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      role: data['role'],
      matiere: data['matiere'],
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      savedPosts: List<String>.from(data['savedPosts'] ?? []),
      isVerified: data['isVerified'] ?? false,
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'role': role,
      'matiere': matiere,
      'followers': followers,
      'following': following,
      'savedPosts': savedPosts,
      'isVerified': isVerified,
      'createdAt': createdAt,
    };
  }
}
