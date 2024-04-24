import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/chats_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:go_router/go_router.dart';

class UserTile extends ConsumerStatefulWidget {
  final UserProfileModel userData;
  const UserTile({
    super.key,
    required this.userData,
  });

  @override
  ConsumerState<UserTile> createState() => _UserTileState();
}

class _UserTileState extends ConsumerState<UserTile> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  void _deleteItem() {}

  void _onChatTap() {}

  Future<void> _createdChatTap() async {
    final hostId = ref.read(authRepo).user!.uid;
    await ref
        .read(chatRoomProvider.notifier)
        .createdChat(hostId, widget.userData.uid);

    context.pushNamed(ChatDetailScreen.routeName,
        params: {"chatId": widget.userData.name});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: _createdChatTap,
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eunga0110.appspot.com/o/avatars%2F${widget.userData.uid}?alt=media&haha=${DateTime.now().toString()}",
        ),
        child: Text(widget.userData.name),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.userData.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Text(""), //채워 넣어야
        ],
      ),
      subtitle: Text(widget.userData.bio),
    );
  }
}
