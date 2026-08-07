import 'package:flutter/material.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Subject Model — For Academic Hub & trending
/// =======================================================

class SubjectModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int unread;
  final int totalPosts;
  final int totalDocuments;
  final int totalQuizzes;
  final double progress;
  final double average;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.unread = 0,
    this.totalPosts = 0,
    this.totalDocuments = 0,
    this.totalQuizzes = 0,
    this.progress = 0.0,
    this.average = 0.0,
  });
}