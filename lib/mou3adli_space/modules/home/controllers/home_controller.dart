import 'package:get/get.dart';
import '../../../models/post.dart';
import '../../../models/user.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final posts = <PostModel>[].obs;
  final stories = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void toggleLike(String postId) {
    final post = posts.firstWhere((p) => p.postId == postId);
    if (post.likedBy?.contains('currentUserId') ?? false) {
      post.likedBy?.remove('currentUserId');
      post.likes = (post.likes ?? 0) - 1;
    } else {
      post.likedBy ??= [];
      post.likedBy?.add('currentUserId');
      post.likes = (post.likes ?? 0) + 1;
    }
    posts.refresh();
  }

  void toggleSave(String postId) {
    final post = posts.firstWhere((p) => p.postId == postId);
    if (post.savedBy?.contains('currentUserId') ?? false) {
      post.savedBy?.remove('currentUserId');
    } else {
      post.savedBy ??= [];
      post.savedBy?.add('currentUserId');
    }
    posts.refresh();
  }

  void _loadMockData() {
    // Stories
    stories.value = [
      UserModel(name: 'M. Ben Ali', role: 'prof', photoUrl: 'https://i.pravatar.cc/150?u=1'),
      UserModel(name: 'Amine K.', role: 'eleve', photoUrl: 'https://i.pravatar.cc/150?u=2'),
      UserModel(name: 'Sana B.', role: 'eleve', photoUrl: 'https://i.pravatar.cc/150?u=3'),
      UserModel(name: 'Dr. Trabelsi', role: 'prof', photoUrl: 'https://i.pravatar.cc/150?u=4'),
      UserModel(name: 'Youssef M.', role: 'eleve', photoUrl: 'https://i.pravatar.cc/150?u=5'),
    ];

    // Posts
    posts.value = [
      PostModel(
        postId: '1',
        name: 'M. Ben Ali',
        userPhotoUrl: 'https://i.pravatar.cc/150?u=1',
        role: 'prof',
        matiere: 'Math',
        content: "N'oubliez pas : le contrôle de probabilités est décalé à jeudi prochain. Bon courage pour la révision ! 📐",
        likes: 24,
        comments: 2,
        shares: 3,
        isAnnouncement: true,
        likedBy: [],
        savedBy: [],
      ),
      PostModel(
        postId: '2',
        name: 'Amine K.',
        userPhotoUrl: 'https://i.pravatar.cc/150?u=2',
        role: 'eleve',
        matiere: 'Physique',
        content: "Quelqu'un a compris le principe de Fermat en optique ? J'ai bloqué sur l'exercice 3 du TD. 🧐",
        likes: 8,
        comments: 2,
        shares: 0,
        likedBy: [],
        savedBy: [],
      ),
      PostModel(
        postId: '3',
        name: 'Sana B.',
        userPhotoUrl: 'https://i.pravatar.cc/150?u=3',
        role: 'eleve',
        matiere: 'Français',
        content: "Annonce : je partage ma fiche de révision sur La Princesse de Clèves. Lien dans les commentaires pour ceux qui veulent. 📚✨",
        likes: 45,
        comments: 0,
        shares: 12,
        likedBy: [],
        savedBy: [],
      ),
      PostModel(
        postId: '4',
        name: 'Dr. Trabelsi',
        userPhotoUrl: 'https://i.pravatar.cc/150?u=4',
        role: 'prof',
        matiere: 'SVT',
        content: "Cette semaine en cours : la notion de hérédité. Je vous recommande de relire le texte de Sartre avant vendredi. 🧬",
        likes: 32,
        comments: 5,
        shares: 8,
        isAnnouncement: true,
        likedBy: [],
        savedBy: [],
      ),
    ];
  }
}