import 'package:get/get.dart';
import '../../../models/message.dart';
import '../../../models/user.dart';

class ChatController extends GetxController {
  final RxList<UserModel> conversations = <UserModel>[].obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockConversations();
  }

  void loadMockConversations() {
    conversations.value = [
      UserModel(
        uid: '1',
        name: 'M. Ben Ali',
        photoUrl: null,
        role: 'prof',
        matiere: 'Math',
      ),
      UserModel(
        uid: '4',
        name: 'Sana B.',
        photoUrl: null,
        role: 'eleve',
      ),
      UserModel(
        uid: 'group1',
        name: 'Groupe 4ème Sc.',
        photoUrl: null,
        role: 'eleve',
      ),
      UserModel(
        uid: '5',
        name: 'Youssef T.',
        photoUrl: null,
        role: 'eleve',
      ),
    ];
  }

  void loadMockMessages(String userId) {
    messages.value = [
      MessageModel(
        messageId: '1',
        senderId: userId,
        receiverId: 'currentUser',
        text: 'Salut ! Tu as compris le dernier cours ?',
        isRead: true,
      ),
      MessageModel(
        messageId: '2',
        senderId: 'currentUser',
        receiverId: userId,
        text: "Oui, mais j'ai encore quelques questions sur l'exercice 3.",
        isRead: true,
      ),
      MessageModel(
        messageId: '3',
        senderId: userId,
        receiverId: 'currentUser',
        text: 'Pas de souci, on peut se voir demain après les cours pour réviser ensemble.',
        isRead: false,
      ),
    ];
  }

  Future<void> sendMessage(String text, String receiverId) async {
    if (text.trim().isEmpty) return;

    final message = MessageModel(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'currentUser',
      receiverId: receiverId,
      text: text,
      isRead: false,
      createdAt: null,
    );

    messages.add(message);
    // TODO: Implémenter l'envoi Firebase
  }
}
