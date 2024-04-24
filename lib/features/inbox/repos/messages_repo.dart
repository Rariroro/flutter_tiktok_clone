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
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
