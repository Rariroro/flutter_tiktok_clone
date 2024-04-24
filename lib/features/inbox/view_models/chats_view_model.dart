import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/chat_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/repos/chats_repo.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_tiktok_clone/features/users/repos/user_repo.dart';

class ChatsViewModel extends AsyncNotifier<List<ChatModel>> {
  late final ChatsRepository _repository;
  late final UserRepository _userRepository;
  List<ChatModel> _chatList = [];

  @override
  FutureOr<List<ChatModel>> build() async {
    _repository = ref.read(chatsRepo);
    _userRepository = ref.read(userRepo);
    _chatList = await loadChats();
    return _chatList;
  }

  Future<List<ChatModel>> loadChats() async {
    final user = ref.read(authRepo).user;
    final chatsData = await _repository.loadChats(user!.uid);
    final chats = chatsData.docs.map(
      (doc) => ChatModel.fromJson(json: doc.data()),
    );

    state = const AsyncValue.loading();
    state = AsyncValue.data(chats.toList());

    return chats.toList();
  }

  Future<void> createdChat(String hostId, String guestId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<List<ChatModel>>(
      () async {
        await _repository.createdChat(
            ChatModel(personA: hostId ?? '', personB: guestId ?? '', id: ""));
        return await loadChats();
      },
    );
  }

  Future<UserProfileModel> returnChatInfo(String chatId) async {
    final chat = _chatList.firstWhere((chat) => chat.id == chatId);
    final currentUserId = ref.read(authRepo).user!.uid;
    final otherUserId =
        (chat.personA == currentUserId) ? chat.personB : chat.personA;

    final result = await _userRepository.findProfile(otherUserId);
    if (result != null) {
      return UserProfileModel.fromJson(json: result);
    }
    return UserProfileModel.empty();
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatsViewModel, List<ChatModel>>(
  () => ChatsViewModel(),
);
