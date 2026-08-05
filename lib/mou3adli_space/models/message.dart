import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageId;
  String? senderId;
  String? receiverId;
  String? text;
  String? imageUrl;
  bool? isRead;
  String? replyToMessageId;
  Timestamp? createdAt;

  MessageModel({
    this.messageId,
    this.senderId,
    this.receiverId,
    this.text,
    this.imageUrl,
    this.isRead,
    this.replyToMessageId,
    this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      messageId: data['messageId'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      text: data['text'],
      imageUrl: data['imageUrl'],
      isRead: data['isRead'] ?? false,
      replyToMessageId: data['replyToMessageId'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'imageUrl': imageUrl,
      'isRead': isRead,
      'replyToMessageId': replyToMessageId,
      'createdAt': createdAt,
    };
  }
}
