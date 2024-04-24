import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/chat_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/repos/chats_repo.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_tiktok_clone/features/users/repos/user_repo.dart';

class ChatOtheruserViewModel
    extends FamilyAsyncNotifier<UserProfileModel, String> {
  late final ChatsRepository _chatsRepository;
  late final UserRepository _userRepository;

  @override
  FutureOr<UserProfileModel> build(String chatId) async {
    _chatsRepository = ref.read(chatsRepo);
    _userRepository = ref.read(userRepo);
    final currentUserId = ref.read(authRepo).user!.uid;

    final chatsData = await _chatsRepository.loadChats(currentUserId);
    final chats =
        chatsData.docs.map((doc) => ChatModel.fromJson(json: doc.data()));
    final chat = chats.firstWhere((chat) => chat.id == chatId);

    final otherUserId =
        (chat.personA == currentUserId) ? chat.personB : chat.personA;

    final result = await _userRepository.findProfile(otherUserId);
    if (result != null) {
      return UserProfileModel.fromJson(json: result);
    }
    return UserProfileModel.empty();
  }
}

final chatOtheruserProvider = AsyncNotifierProvider.family<
    ChatOtheruserViewModel, UserProfileModel, String>(
  () => ChatOtheruserViewModel(),
);
