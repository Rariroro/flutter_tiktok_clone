import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditController = TextEditingController();

  bool _isWriting = false;

  void _onSearchChanged(String value) {
    print("Searching from $value");
  }

  void _onSearchSubmitted(String value) {
    print("submitted $value");
  }

  @override
  void dispose() {
    _textEditController.dispose();
    super.dispose();
  }

  void _toggleKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _stopWriting() {
    _textEditController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            children: [
              const FaIcon(FontAwesomeIcons.angleLeft),
              Gaps.h20,
              Expanded(
                child: SizedBox(
                  height: Sizes.size44,
                  child: TextField(
                    onTap: _onStartWriting,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    controller: _textEditController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Sizes.size4,
                          ),
                          borderSide: BorderSide.none),
                      hintText: "Write",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: Sizes.size12,
                        horizontal: Sizes.size10,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      prefixIcon: Container(
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: Sizes.size20,
                          ),
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: Sizes.size14),
                        child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isWriting)
                              GestureDetector(
                                onTap: _stopWriting,
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: Colors.grey.shade500,
                                  size: Sizes.size20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: FaIcon(FontAwesomeIcons.sliders),
              ),
            ],
          ),
          // title: CupertinoSearchTextField(
          //   controller: _textEditingController,
          //   onChanged: _onSearchChanged,
          //   onSubmitted: _onSearchSubmitted,
          // ),
          bottom: TabBar(
            onTap: (index) => _toggleKeyboard(), //탭을 바꾸면 키보드 없애기
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(
                Sizes.size8,
              ),
              itemCount: 20,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 20,
              ),
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Sizes.size4,
                      ),
                    ),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "assets/images/placeholder.jpeg",
                        image:
                            "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                      ),
                    ),
                  ),
                  Gaps.v6,
                  const Text(
                    "This is a very long caption for my tiktok that im upload just now currently.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v6,
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          "https://avatars.githubusercontent.com/u/3612017",
                        ),
                      ),
                      Gaps.h4,
                      Expanded(
                        child: Text(
                          "My avatar is going to be very long",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      Gaps.h4,
                      FaIcon(
                        FontAwesomeIcons.heart,
                        size: Sizes.size14,
                        color: Colors.grey.shade500,
                      ),
                      Gaps.h2,
                      Text(
                        "2.5M",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
