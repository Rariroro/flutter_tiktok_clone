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
    _chatList = await _loadChats();
    return _chatList;
  }

  Future<List<ChatModel>> _loadChats() async {
    // print("loadChat1: $_chatList");
    final user = ref.read(authRepo).user;
    final chatsData = await _repository.loadChats(user!.uid);
    if (chatsData.docs.isNotEmpty) {
      //   print("loadChat2: ${chatsData.docs}");
      final chats = chatsData.docs.map((doc) {
        //   print("loadChat3: ${doc.id}");
        return ChatModel.fromJson(json: doc.data(), chatId: doc.id);
      });

      // final testresult = chats.toList();
      //  print("loadChat4: ${testresult[0].id}");

      return chats.toList();
    }
    //  print("loadChat5: $_chatList}");
    return [];
  }

  Future<void> createdChat(
      UserProfileModel user, UserProfileModel otherUser) async {
    print("createdChat${user.uid},${otherUser.uid}");
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<List<ChatModel>>(
      () async {
        await _repository.createdChat(ChatModel(participants: [
          user.uid ?? '',
          otherUser.uid ?? '',
        ], id: ""));
        print("k");
        _chatList = await _loadChats();
        return _chatList;
      },
    );
    print("createdChat$_chatList");
    // return findChatId(user.uid, otherUser.uid);
  }

  Future<ChatModel?> findChat(String userId, String otherUserId) async {
    // print(userId);
    //print(otherUserId);
    //  print(_chatList);
    // _chatList를 반복하여 각 채팅 모델을 검사
    for (ChatModel chat in _chatList) {
      // chat.participants 리스트에 두 사용자 ID가 모두 포함되어 있는지 확인
      if (chat.participants.contains(userId) &&
          chat.participants.contains(otherUserId)) {
        // 두 사용자가 모두 포함된 채팅방을 찾았다면, 해당 채팅방의 ID를 반환
        return chat;
      }
    }
    // 해당하는 채팅방이 없다면 빈 문자열 반환
    return null;
  }

  Future<UserProfileModel> returnChatInfo(String chatId) async {
    final chat = _chatList.firstWhere((chat) =>
        chat.id == chatId); //firebase에서 받아온 채팅 리스트에서 첫번째 아이디가 일치하는 채팅 추출
    final currentUserId = ref.read(authRepo).user!.uid;
    final otherUserId = chat.participants.firstWhere(
        //채팅에서 현재유저 아닌 상대 유저 아이디 추출
        (userId) => userId != currentUserId,
        orElse: () => 'Not Found');

    final result = await _userRepository.findProfile(otherUserId); //상대 유저 정보 추출
    if (result != null) {
      return UserProfileModel.fromJson(json: result);
    }
    return UserProfileModel.empty();
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatsViewModel, List<ChatModel>>(
  () => ChatsViewModel(),
);
