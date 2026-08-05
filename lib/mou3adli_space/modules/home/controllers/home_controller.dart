import 'package:get/get.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxList<UserModel> stories = <UserModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void loadMockData() {
    // Stories
    stories.value = [
      UserModel(
        uid: '1',
        name: 'M. Ben Ali',
        photoUrl: null,
        role: 'prof',
        matiere: 'Math',
      ),
      UserModel(
        uid: '2',
        name: 'Mme. Trabelsi',
        photoUrl: null,
        role: 'prof',
        matiere: 'Philosophie',
      ),
      UserModel(
        uid: '3',
        name: 'Amine K.',
        photoUrl: null,
        role: 'eleve',
      ),
      UserModel(
        uid: '4',
        name: 'Sana B.',
        photoUrl: null,
        role: 'eleve',
      ),
      UserModel(
        uid: '5',
        name: 'Youssef T.',
        photoUrl: null,
        role: 'eleve',
      ),
      UserModel(
        uid: '6',
        name: 'M. Gharbi',
        photoUrl: null,
        role: 'prof',
        matiere: 'Histoire',
      ),
      UserModel(
        uid: '7',
        name: 'Lina M.',
        photoUrl: null,
        role: 'eleve',
      ),
      UserModel(
        uid: '8',
        name: 'Omar D.',
        photoUrl: null,
        role: 'eleve',
      ),
    ];

    // Posts
    posts.value = [
      PostModel(
        postId: '1',
        userId: '1',
        username: 'mbenali',
        name: 'M. Ben Ali',
        userPhotoUrl: null,
        role: 'prof',
        matiere: 'Math',
        content: "N'oubliez pas : le contrôle de probabilités est décalé à jeudi prochain. Bon courage pour la révision !",
        type: 'text',
        likes: 24,
        comments: 2,
        shares: 3,
        isAnnouncement: true,
      ),
      PostModel(
        postId: '2',
        userId: '3',
        username: 'aminek',
        name: 'Amine K.',
        userPhotoUrl: null,
        role: 'eleve',
        matiere: 'Physique',
        content: "Quelqu'un a compris le principe de Fermat en optique ? J'ai bloqué sur l'exercice 3 du TD.",
        type: 'text',
        likes: 8,
        comments: 2,
        shares: 0,
      ),
      PostModel(
        postId: '3',
        userId: '4',
        username: 'sanab',
        name: 'Sana B.',
        userPhotoUrl: null,
        role: 'eleve',
        matiere: 'Français',
        content: 'Annonce : je partage ma fiche de révision sur La Princesse de Clèves. Lien dans les commentaires pour ceux qui veulent.',
        type: 'text',
        likes: 45,
        comments: 0,
        shares: 12,
      ),
      PostModel(
        postId: '4',
        userId: '2',
        username: 'mtrabelsi',
        name: 'Mme. Trabelsi',
        userPhotoUrl: null,
        role: 'prof',
        matiere: 'Philosophie',
        content: 'Cette semaine on aborde la notion de liberté. Je vous recommande de relire le texte de Sartre avant vendredi.',
        type: 'poll',
        likes: 31,
        comments: 1,
        shares: 5,
        pollOptions: [
          {'text': 'Oui, terminé', 'votes': 12, 'percentage': 30},
          {'text': 'En cours', 'votes': 18, 'percentage': 45},
          {'text': 'Pas encore', 'votes': 10, 'percentage': 25},
        ],
      ),
      PostModel(
        postId: '5',
        userId: '5',
        username: 'yousseft',
        name: 'Youssef T.',
        userPhotoUrl: null,
        role: 'eleve',
        matiere: 'Informatique',
        content: "Petit sondage : vous préférez Python ou Java pour le projet de fin d'année ?",
        type: 'text',
        likes: 12,
        comments: 2,
        shares: 1,
      ),
      PostModel(
        postId: '6',
        userId: '6',
        username: 'mgharbi',
        name: 'M. Gharbi',
        userPhotoUrl: null,
        role: 'prof',
        matiere: 'Histoire',
        content: 'Rappel : la sortie pédagogique au Bardo est confirmée pour le 15 mars. Retournez vos autorisations avant vendredi.',
        type: 'text',
        likes: 56,
        comments: 0,
        shares: 8,
        isAnnouncement: true,
      ),
    ];
  }

  void toggleLike(String postId) {
    final post = posts.firstWhere((p) => p.postId == postId);
    final isLiked = post.likedBy?.contains('currentUserId') ?? false;

    if (isLiked) {
      post.likedBy?.remove('currentUserId');
      post.likes = (post.likes ?? 0) - 1;
    } else {
      post.likedBy ??= [];
      post.likedBy!.add('currentUserId');
      post.likes = (post.likes ?? 0) + 1;
    }
    posts.refresh();
  }

  void toggleSave(String postId) {
    final post = posts.firstWhere((p) => p.postId == postId);
    final isSaved = post.savedBy?.contains('currentUserId') ?? false;

    if (isSaved) {
      post.savedBy?.remove('currentUserId');
    } else {
      post.savedBy ??= [];
      post.savedBy!.add('currentUserId');
    }
    posts.refresh();
  }
}
