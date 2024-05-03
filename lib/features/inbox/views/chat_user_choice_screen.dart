import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/available_users_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/widgets/user_tile.dart';

class ChatUserChoiceScreen extends ConsumerStatefulWidget {
  // final List<UserProfileModel> otherUserList;

  const ChatUserChoiceScreen({
    super.key,
    // required this.otherUserList,
  });

  @override
  ConsumerState<ChatUserChoiceScreen> createState() =>
      _ChatUserChoiceScreenState();
}

class _ChatUserChoiceScreenState extends ConsumerState<ChatUserChoiceScreen> {
  // final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return ref.watch(availableUsersProvider).when(
        data: (otherUsers) => Scaffold(
            appBar: AppBar(
              elevation: 0.3,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.grey,
              title: const Text(
                "Users",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView.builder(
              itemCount: otherUsers.length,
              itemBuilder: (context, index) {
                return UserTile(otherUserData: otherUsers[index]);
              },
            )

            /*AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: Key('$index'),
            opacity: animation,
            child: SizeTransition(
                sizeFactor: animation, child: const ChatTile(isChat: false)),
          );
        },
      ),*/
            ),
        error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));
  }
}
