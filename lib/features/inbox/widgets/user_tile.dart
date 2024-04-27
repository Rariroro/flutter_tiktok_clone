import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/chat_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/available_users_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/chats_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:go_router/go_router.dart';

class UserTile extends ConsumerStatefulWidget {
  final UserProfileModel otherUserData;
  const UserTile({
    super.key,
    required this.otherUserData,
  });

  @override
  ConsumerState<UserTile> createState() => _UserTileState();
}

class _UserTileState extends ConsumerState<UserTile> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  void _deleteItem() {}

  void _onChatTap() {}

  Future<void> _createdChatTap() async {
    final userAsyncValue =
        ref.read(usersProvider); // AsyncValue<UserProfileModel> 타입
    print("userAsyncValue:${userAsyncValue.value!.name}");
    // userAsyncValue가 데이터를 성공적으로 포함하고 있는지 확인
    if (userAsyncValue is AsyncData<UserProfileModel>) {
      final user = userAsyncValue.value; // 실제 UserProfileModel 인스턴스 추출
      //  print("11");
      await ref
          .watch(chatRoomProvider.notifier)
          .createdChat(user, widget.otherUserData);
      if (!mounted) return;
      //    print("22");
      // await ref
      //     .read(availableUsersProvider.notifier)
      //     .getActiveChatPartners(userAsyncValue.value.uid);
      //     print("33");
      if (!mounted) return;
      //     print("44");

      final users = ref.read(chatRoomProvider).value;

      print("55:${users![0].id}");
      print("66:${users[0].participants}");
      if (!mounted) return;
      final chat = findChat(users);
      print("tile:${chat!.id}");
      // Navigator.of(context)를 직접 사용하지 않고, 콜백으로 처리
      onChatCreated(chat);
    } else {
      // 적절한 오류 처리: 데이터 불러오기 실패
      print("Failed to load user profile.");
    }
  }

  ChatModel? findChat(List<ChatModel> chats) {
    final userId = ref.read(authRepo).user!.uid;
    // print(userId);
    //print(otherUserId);
    print("findChat:${chats[0].id}");
    // _chatList를 반복하여 각 채팅 모델을 검사
    for (ChatModel chat in chats) {
      // chat.participants 리스트에 두 사용자 ID가 모두 포함되어 있는지 확인
      if (chat.participants.contains(userId) &&
          chat.participants.contains(widget.otherUserData.uid)) {
        // 두 사용자가 모두 포함된 채팅방을 찾았다면, 해당 채팅방의 ID를 반환
        print("findChat:${chat.id}");
        return chat;
      }
    }
    // 해당하는 채팅방이 없다면 빈 문자열 반환
    return null;
  }

  void onChatCreated(ChatModel chat) {
    // Navigator.of(context).pushNamed(ChatDetailScreen.routeName, arguments: {"chatId": chatId});
    print("on:  ${chat.id}");
    context.goNamed(ChatDetailScreen.routeName, params: {"chatId": chat.id});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _createdChatTap,
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eunga0110.appspot.com/o/avatars%2F${widget.otherUserData.uid}?alt=media&haha=${DateTime.now().toString()}",
        ),
        child: Text(widget.otherUserData.name),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.otherUserData.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Text(""), //채워 넣어야
        ],
      ),
      subtitle: Text(widget.otherUserData.bio),
    );
  }
}
