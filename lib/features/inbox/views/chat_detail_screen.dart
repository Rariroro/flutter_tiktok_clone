import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/chat_otheruser_view_model.dart';
import 'package:flutter_tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;
  // final String otherPersonId;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    //  required this.otherPersonId,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _editingController = TextEditingController();
  bool isDeleteMessage = false;
  //late final UserProfileModel otherUser;

  void _onSendPress() {
    final text = _editingController.text;
    if (text == "") {
      return;
    }
    ref.read(messagesProvider(widget.chatId).notifier).sendMessage(text);
    _editingController.text = ""; //메세지가 데이터베이스로 전송되면 텍스트필드에서 삭제
  }

  Future<void> _showMessageMenu(BuildContext context, int createdAt) async {
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    final int timeDifference = currentTime - createdAt;
    const int timeLimit = 120000;

    final result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            if (timeDifference < timeLimit)
              ListTile(
                leading: const Icon(FontAwesomeIcons.deleteLeft),
                title: const Text("Delete Message"),
                onTap: () => Navigator.pop(context, 'delete'),
              )
            else
              const ListTile(
                leading: Icon(FontAwesomeIcons.info),
                title: Text("2분이 지나 삭제할 수 없습니다"),
              )
          ],
        );
      },
    );
    if (result == 'delete') {
      _deleteMessage(createdAt);
    }
  }

  Future<void> _deleteMessage(int createdAt) async {
    setState(() {
      isDeleteMessage = true;
      print("Deleting message with ID: $createdAt");
      //메세지 삭제로직 추가
      ref
          .read(messagesProvider(widget.chatId).notifier)
          .deleteMessage(createdAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(messagesProvider(widget.chatId))
        .isLoading; //메세지가 아직 넘어가지 않았는데 전송버튼을 마구 눌러도 적용되지 않게 하기 위해.

    return Scaffold(
      appBar: AppBar(
        title: ref.watch(chatOtheruserProvider(widget.chatId)).when(
              data: (otherUser) => ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: Sizes.size8,
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: Sizes.size24,
                      foregroundImage: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-eunga0110.appspot.com/o/avatars%2F${otherUser.uid}?alt=media&haha=${DateTime.now().toString()}"),
                      child: Text(otherUser.name),
                    ),
                    Positioned(
                      // width: 25,
                      //left: 28,
                      // top: 28,
                      // height: 25,
                      bottom: -4,
                      right: -4,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(color: Colors.white, width: 5),
                        ),
                      ),
                    )
                  ],
                ),
                title: Text(
                  otherUser.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('Active now'),
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.flag,
                      color: Colors.black,
                      size: Sizes.size20,
                    ),
                    Gaps.h32,
                    FaIcon(
                      FontAwesomeIcons.ellipsis,
                      color: Colors.black,
                      size: Sizes.size20,
                    )
                  ],
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
      ),
      body: Stack(
        children: [
          ref.watch(chatProvider(widget.chatId)).when(
                data: (data) {
                  return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size20,
                        horizontal: Sizes.size14,
                      ),
                      itemBuilder: (context, index) {
                        final message = data[index];
                        final isMine =
                            message.userId == ref.watch(authRepo).user!.uid;
                        return GestureDetector(
                          onLongPress: () =>
                              _showMessageMenu(context, message.createdAt),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(Sizes.size14),
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Colors.blue
                                      : Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(
                                      Sizes.size20,
                                    ),
                                    topRight: const Radius.circular(
                                      Sizes.size20,
                                    ),
                                    bottomLeft: isMine
                                        ? const Radius.circular(Sizes.size20)
                                        : const Radius.circular(Sizes.size5),
                                    bottomRight: Radius.circular(
                                        isMine ? Sizes.size5 : Sizes.size20),
                                  ),
                                ),
                                child: Text(
                                  message.text,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: Sizes.size16),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Gaps.v10,
                      itemCount: data.length);
                },
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
          Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                color: Colors.grey.shade50,
                surfaceTintColor: Colors.grey.shade50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _editingController,
                        onTap: () => (),
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: Sizes.size12,
                              horizontal: Sizes.size10,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.size24),
                                borderSide: BorderSide.none),
                            hintText: "Send a message...",
                            hintStyle: const TextStyle(
                                fontSize: Sizes.size20,
                                fontWeight: FontWeight.w400),
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: const FaIcon(
                                    FontAwesomeIcons.faceSmile,
                                    size: Sizes.size28,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Gaps.h20,
                    IconButton(
                      onPressed: isLoading ? () {} : _onSendPress,
                      icon: FaIcon(
                        isLoading
                            ? FontAwesomeIcons.hourglass
                            : FontAwesomeIcons.paperPlane,
                        color: Colors.black,
                      ),
                    )
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Container(
                    //     width: 50,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.grey.shade300),
                    //     child: const Center(
                    //       child: FaIcon(
                    //         FontAwesomeIcons.solidPaperPlane,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
