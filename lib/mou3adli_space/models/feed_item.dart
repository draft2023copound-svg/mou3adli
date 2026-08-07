import 'package:flutter/widgets.dart';
import 'academic_card_type.dart';
import 'academic_card_model.dart';

/// =======================================================
/// MOU3ADLI ROYAL DESIGN SYSTEM
/// Feed Item — Base class for feed composition engine
/// =======================================================

abstract class FeedItem {
  final String id;
  final AcademicCardType type;
  final DateTime createdAt;
  final int priority;

  const FeedItem({
    required this.id,
    required this.type,
    required this.createdAt,
    this.priority = 0,
  });
}

/// Content feed item with full card data
class ContentFeedItem extends FeedItem {
  final AcademicCardModel card;

  const ContentFeedItem({
    required super.id,
    required super.type,
    required super.createdAt,
    required this.card,
    super.priority,
  });
}

/// Section divider in feed (e.g., "Today", "Yesterday")
class SectionFeedItem extends FeedItem {
  final String label;

  const SectionFeedItem({
    required super.id,
    required this.label,
    required super.createdAt,
  }) : super(type: AcademicCardType.announcement, priority: 100);
}

/// Loading placeholder in feed
class LoadingFeedItem extends FeedItem {
  const LoadingFeedItem({
    required super.id,
    required super.createdAt,
  }) : super(type: AcademicCardType.announcement, priority: 99);
}

/// Empty state in feed
class EmptyFeedItem extends FeedItem {
  final String message;
  final IconData? icon;

  const EmptyFeedItem({
    required super.id,
    required this.message,
    this.icon,
    required super.createdAt,
  }) : super(type: AcademicCardType.announcement, priority: 99);
}