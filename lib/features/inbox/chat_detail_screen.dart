import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/3612017'),
                child: Text('니꼬'),
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
          title: const Text(
            '니꼬',
            style: TextStyle(
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
      ),
      body: Stack(
        children: [
          ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size20,
                horizontal: Sizes.size14,
              ),
              itemBuilder: (context, index) {
                final isMine = index % 2 == 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                      child: const Text(
                        "this is message!",
                        style: TextStyle(
                            color: Colors.white, fontSize: Sizes.size16),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10),
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
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.solidPaperPlane,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
