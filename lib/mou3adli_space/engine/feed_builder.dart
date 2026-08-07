import 'package:flutter/material.dart';
import 'feed_engine.dart';
import '../models/subject_model.dart';
import '../widgets/home/royal_academic_pulse.dart';
import '../widgets/home/academic_subjects.dart';
import '../widgets/cards/announcement_card.dart';
import '../widgets/cards/teacher_card.dart';
import '../widgets/feed/royal_feed_card.dart';
import '../widgets/feed/royal_user_header.dart';
import '../widgets/feed/royal_post_body.dart';
import '../widgets/feed/royal_action_bar.dart';
import '../widgets/feed/royal_composer.dart';
import '../widgets/home/daily_quiz_card.dart';
import '../widgets/home/homework_reminder_card.dart';
import '../widgets/home/achievement_banner.dart';

class RoyalFeedBuilder extends StatelessWidget {
  final List<FeedSection> sections;

  const RoyalFeedBuilder({
    super.key,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final section = sections[index];

          switch (section.type) {
            case FeedSectionType.pulse:
              return const AcademicPulse(
                average: 15.82,
                announcements: 2,
                assignments: 1,
                replies: 3,
                documents: 5,
              );

            case FeedSectionType.composer:
              return const RoyalComposer(avatar: "https://i.pravatar.cc/150?img=1");

            case FeedSectionType.subjects:
              return AcademicSubjects(
                subjects: section.data as List<SubjectModel>? ?? [],
                onSubjectPressed: (s) {},
              );

            case FeedSectionType.announcement:
              final data = section.data;
              return AnnouncementCard(
                title: data?.title ?? "Annonce",
                description: data?.description ?? "",
                teacher: data?.teacher ?? "",
                date: data?.date ?? DateTime.now(),
              );

            case FeedSectionType.teacherPost:
              return RoyalFeedCard(
                header: RoyalUserHeader(
                  avatar: "https://i.pravatar.cc/150?img=2",
                  name: "M. Ben Salah",
                  subtitle: "Professeur de Mathématiques",
                  badge: "Professeur",
                  verified: true,
                ),
                body: RoyalPostBody(
                  text: "N'oubliez pas le contrôle de trigonométrie vendredi prochain. Révisez les formules fondamentales et les identités remarquables.",
                ),
                actions: RoyalActionBar(
                  likes: 24,
                  comments: 8,
                  shares: 3,
                  liked: false,
                  onLike: () {},
                  onComment: () {},
                  onShare: () {},
                ),
              );

            case FeedSectionType.studentPost:
              return RoyalFeedCard(
                header: RoyalUserHeader(
                  avatar: "https://i.pravatar.cc/150?img=3",
                  name: "Ahmed K.",
                  subtitle: "2ème Sciences • Il y a 2h",
                ),
                body: RoyalPostBody(
                  text: "Quelqu'un pourrait m'expliquer la dérivation des fonctions trigonométriques ? Je bloque sur l'exercice 3 du chapitre 4.",
                ),
                actions: RoyalActionBar(
                  likes: 12,
                  comments: 5,
                  shares: 1,
                  liked: false,
                  onLike: () {},
                  onComment: () {},
                  onShare: () {},
                ),
              );

            case FeedSectionType.quiz:
              return DailyQuizCard(
                title: "Quiz de Physique",
                questions: 12,
                duration: "10 min",
                reward: 50,
                onPressed: () {},
              );

            case FeedSectionType.pdf:
              return RoyalFeedCard(
                header: RoyalUserHeader(
                  avatar: "https://i.pravatar.cc/150?img=4",
                  name: "Mme. Feki",
                  subtitle: "Professeur de Physique",
                  badge: "Professeur",
                  verified: true,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.picture_as_pdf, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Cours - Mécanique du point",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 4),
                                Text("PDF • 18 pages • 3.4 MB"),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () {},
                            child: const Text("Ouvrir"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            case FeedSectionType.homework:
              return HomeworkReminderCard(
                subject: "Mathématiques",
                teacher: "M. Ben Salah",
                dueDate: DateTime.now().add(const Duration(days: 2)),
                exercises: 8,
                onPressed: () {},
              );

            case FeedSectionType.video:
              return RoyalFeedCard(
                header: RoyalUserHeader(
                  avatar: "https://i.pravatar.cc/150?img=5",
                  name: "Club Scientifique",
                  subtitle: "Il y a 5h",
                ),
                body: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: NetworkImage("https://img.youtube.com/vi/0/0.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_circle, size: 64, color: Colors.white),
                  ),
                ),
              );

            case FeedSectionType.poll:
              return RoyalFeedCard(
                header: RoyalUserHeader(
                  avatar: "https://i.pravatar.cc/150?img=6",
                  name: "Délégué de classe",
                  subtitle: "Il y a 1h",
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sondage : Quelle date préférez-vous pour la sortie scolaire ?",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    ...[
                      "Vendredi 15 mars",
                      "Samedi 16 mars",
                      "Dimanche 17 mars",
                    ].map((option) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle_outlined, size: 20, color: Colors.grey.shade600),
                            const SizedBox(width: 12),
                            Text(option),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              );

            case FeedSectionType.achievement:
              return AchievementBanner(
                title: "Nouveau badge débloqué !",
                description: "Tu as résolu 50 exercices de mathématiques. Continue comme ça !",
                icon: Icons.workspace_premium_rounded,
              );

            case FeedSectionType.leaderboard:
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff1B56EA), Color(0xff1845D0)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    const Text(
                      "🏆 Classement de la semaine",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(3, (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(
                            "#${i + 1}",
                            style: TextStyle(
                              color: i == 0 ? Colors.amber : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=${i + 10}"),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              ["Ahmed K.", "Sarra M.", "Youssef B."][i],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Text(
                            "${18.5 - (i * 0.3)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              );

            case FeedSectionType.suggestion:
              return TeacherCard(
                avatar: "https://i.pravatar.cc/150?img=20",
                name: "Mme. Trabelsi",
                subject: "Français",
                rating: 4.9,
                online: true,
                school: "Lycée Pilote",
                onMessage: () {},
              );

            default:
              return const SizedBox.shrink();
          }
        },
        childCount: sections.length,
      ),
    );
  }
}