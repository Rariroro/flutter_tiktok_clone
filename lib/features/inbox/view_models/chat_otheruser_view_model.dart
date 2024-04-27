import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/chats_view_model.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class ChatOtheruserViewModel
    extends FamilyAsyncNotifier<UserProfileModel, String> {
  @override
  FutureOr<UserProfileModel> build(String chatId) async {
    final otherUser =
        await ref.read(chatRoomProvider.notifier).returnChatInfo(chatId);
    return otherUser;
  }
}

final chatOtheruserProvider = AsyncNotifierProvider.family<
    ChatOtheruserViewModel, UserProfileModel, String>(
  () => ChatOtheruserViewModel(),
);
