import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/message_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/repos/messages_repo.dart';

class MessagesViewModel extends FamilyAsyncNotifier<void, String> {
  late final MessagesRepo _repo;
  late final String _chatId;

  @override
  FutureOr<void> build(String chatId) {
    _repo = ref.read(messagesRepo);
    _chatId = chatId;

    // _chatRoomId=ref.read(chatRoomProvider).
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      _repo.sendMessage(message, _chatId);
    });
  }

  Future<void> deleteMessage(int createdAt) async {
    await _repo.deleteMessage(_chatId, createdAt);
  }
}

final messagesProvider =
    AsyncNotifierProvider.family<MessagesViewModel, void, String>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatRoomId) {
  final db = FirebaseFirestore.instance;
  return db
      .collection("chat_rooms")
      .doc(chatRoomId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
});
