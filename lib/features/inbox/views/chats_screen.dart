import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/chat_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/available_users_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/chat_otheruser_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/chats_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chat_user_choice_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];
  final Duration _duration = const Duration(milliseconds: 500);

  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  void _onChatUserChoiceButton() {
    //future은 지워야함!!!

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatUserChoiceScreen(),
      ),
    );
    // print(users[0].uid);
    //print(users[1].uid);
    //print(users.length);
  }

  void _deleteItem(List<ChatModel> chats, int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeTile(chats, index),
          ),
        ),
        duration: _duration,
      );
      chats.remove(chats[index]);
      chats = List.generate(_items.length, (index) => chats[index]);
    }
  }

  void _onChatTap(String chatId) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": chatId},
    );
  }

  Widget _makeTile(List<ChatModel> chats, int index) {
    //print("maketile");
    return ref.watch(chatOtheruserProvider(chats[index].id)).when(
        data: (otherUser) => ListTile(
              onLongPress: () => _deleteItem(chats, index),
              onTap: () => _onChatTap(
                chats[index].id,
              ),
              leading: CircleAvatar(
                radius: 30,
                foregroundImage: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eunga0110.appspot.com/o/avatars%2F${otherUser.uid}?alt=media&haha=${DateTime.now().toString()}",
                ),
                child: Text(otherUser.name),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    otherUser.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "2:16 PM",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: Sizes.size12,
                    ),
                  ),
                ],
              ),
              subtitle: const Text("Don't forget to make video"),
            ),
        error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(chatRoomProvider).when(
        data: (chats) => Scaffold(
              appBar: AppBar(
                elevation: 0.3,
                surfaceTintColor: Colors.white,
                shadowColor: Colors.grey,
                title: const Text(
                  "Direct Messages",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                actions: [
                  IconButton(
                    onPressed: _onChatUserChoiceButton,
                    icon: const FaIcon(
                      FontAwesomeIcons.plus,
                    ),
                  ),
                ],
              ),
              body: AnimatedList(
                key: _key,
                initialItemCount: chats.length,
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size10,
                ),
                itemBuilder: (context, index, animation) {
                  return FadeTransition(
                    //key: Key('$index'),
                    opacity: animation,
                    child: SizeTransition(
                        sizeFactor: animation, child: _makeTile(chats, index)),
                  );
                },
              ),
            ),
        error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }
}
