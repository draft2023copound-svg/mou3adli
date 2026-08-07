import '../models/feed_item.dart';
import '../models/academic_card_type.dart';

enum FeedSectionType {
  announcement,
  composer,
  pulse,
  quickActions,
  subjects,
  teacherPost,
  studentPost,
  quiz,
  poll,
  homework,
  pdf,
  video,
  achievement,
  leaderboard,
  suggestion,
}

class FeedSection {
  final FeedSectionType type;
  final dynamic data;

  const FeedSection({
    required this.type,
    this.data,
  });
}

class FeedEngine {
  const FeedEngine();

  List<FeedSection> build({
    required List<FeedItem> feed,
    required List<dynamic> announcements,
    required List<dynamic> quizzes,
    required List<dynamic> subjects,
  }) {
    final result = <FeedSection>[];

    /// Header widgets
    result.add(const FeedSection(type: FeedSectionType.pulse));
    result.add(const FeedSection(type: FeedSectionType.composer));
    result.add(FeedSection(type: FeedSectionType.subjects, data: subjects));

    /// Announcement
    if (announcements.isNotEmpty) {
      result.add(FeedSection(
        type: FeedSectionType.announcement,
        data: announcements.first,
      ));
    }

    int postCounter = 0;

    for (final item in feed) {
      result.add(FeedSection(type: _mapType(item.type), data: item));

      postCounter++;

      /// Every 4 posts → insert quiz
      if (postCounter % 4 == 0 && quizzes.isNotEmpty) {
        result.add(FeedSection(
          type: FeedSectionType.quiz,
          data: quizzes.first,
        ));
      }

      /// Every 7 posts → insert leaderboard
      if (postCounter % 7 == 0) {
        result.add(const FeedSection(type: FeedSectionType.leaderboard));
      }

      /// Every 9 posts → insert suggestion
      if (postCounter % 9 == 0) {
        result.add(const FeedSection(type: FeedSectionType.suggestion));
      }
    }

    return result;
  }
  
  FeedSectionType _mapType(AcademicCardType type) {
    switch (type) {
      case AcademicCardType.announcement:
        return FeedSectionType.announcement;
      case AcademicCardType.teacher:
        return FeedSectionType.teacherPost;
      case AcademicCardType.student:
        return FeedSectionType.studentPost;
      case AcademicCardType.quiz:
        return FeedSectionType.quiz;
      case AcademicCardType.poll:
        return FeedSectionType.poll;
      case AcademicCardType.pdf:
        return FeedSectionType.pdf;
      case AcademicCardType.video:
        return FeedSectionType.video;
      case AcademicCardType.homework:
        return FeedSectionType.homework;
      case AcademicCardType.achievement:
        return FeedSectionType.achievement;
      case AcademicCardType.leaderboard:
        return FeedSectionType.leaderboard;
      case AcademicCardType.suggestion:
        return FeedSectionType.suggestion;
      default:
        return FeedSectionType.announcement;
    }
  }
}