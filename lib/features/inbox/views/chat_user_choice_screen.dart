import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/inbox/widgets/user_tile.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class ChatUserChoiceScreen extends ConsumerStatefulWidget {
  final List<UserProfileModel> userList;

  const ChatUserChoiceScreen({
    super.key,
    required this.userList,
  });

  @override
  ConsumerState<ChatUserChoiceScreen> createState() =>
      _ChatUserChoiceScreenState();
}

class _ChatUserChoiceScreenState extends ConsumerState<ChatUserChoiceScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          itemCount: widget.userList.length,
          itemBuilder: (context, index) {
            return UserTile(userData: widget.userList[index]);
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
        );
  }
}
