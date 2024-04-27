import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/message_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message, String chatId) async {
    await _db.collection("chat_rooms").doc(chatId).collection("texts").add(
          message.toJson(),
        );
  }

  Future<void> deleteMessage(String chatId, int createdAt) async {
    var querySnapshot = await _db
        .collection("chat_rooms")
        .doc(chatId)
        .collection("texts")
        .where("createdAt", isEqualTo: createdAt)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
