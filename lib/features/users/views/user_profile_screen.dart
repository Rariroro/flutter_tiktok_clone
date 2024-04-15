import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/settings_screen.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_tiktok_clone/features/users/views/user_profile_edit_screen.dart';
import 'package:flutter_tiktok_clone/features/users/widgets/avatar.dart';
import 'package:flutter_tiktok_clone/features/users/widgets/persistent_tab_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _onProfileEditButton() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UserProfileEditScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          data: (data) => Scaffold(
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == "likes" ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        centerTitle: true,
                        title: Text(
                          data.name,
                        ),
                        actions: [
                          IconButton(
                            onPressed: _onProfileEditButton,
                            icon: const FaIcon(
                              FontAwesomeIcons.penToSquare,
                              size: Sizes.size20,
                            ),
                          ),
                          IconButton(
                            onPressed: _onGearPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.gear,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Avatar(
                                uid: data.uid,
                                name: data.name,
                                hasAvatar: data.hasAvatar),
                            Gaps.v20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "@${data.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Sizes.size18,
                                  ),
                                ),
                                Gaps.h5,
                                FaIcon(
                                  FontAwesomeIcons.solidCircleCheck,
                                  size: Sizes.size16,
                                  color: Colors.blue.shade500,
                                ),
                              ],
                            ),
                            Gaps.v24,
                            SizedBox(
                              height: Sizes.size52,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const UserAccount(
                                      count: '37', text: "Following"),
                                  VerticalDivider(
                                    thickness: Sizes.size1,
                                    width: Sizes.size32,
                                    color: Colors.grey.shade400,
                                    indent: Sizes.size10,
                                    endIndent: Sizes.size10,
                                  ),
                                  const UserAccount(
                                      count: '10.5M', text: "Followers"),
                                  VerticalDivider(
                                    thickness: Sizes.size1,
                                    width: Sizes.size32,
                                    color: Colors.grey.shade400,
                                    indent: Sizes.size10,
                                    endIndent: Sizes.size10,
                                  ),
                                  const UserAccount(
                                      count: '1499.3M', text: "Likes"),
                                ],
                              ),
                            ),
                            Gaps.v14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 180,
                                  height: 50,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: Sizes.size12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(Sizes.size1),
                                      ),
                                    ),
                                    child: const Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Gaps.h5,
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.size12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(Sizes.size1),
                                        ),
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                      child: const FaIcon(
                                          FontAwesomeIcons.youtube)),
                                ),
                                Gaps.h5,
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.size12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(Sizes.size1),
                                        ),
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                      child: const FaIcon(
                                        FontAwesomeIcons.caretDown,
                                        size: Sizes.size18,
                                      )),
                                ),
                              ],
                            ),
                            Gaps.v14,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size32,
                              ),
                              child: Text(
                                data.bio,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Gaps.v14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.link,
                                  size: Sizes.size12,
                                ),
                                Gaps.h4,
                                Text(
                                  data.link,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Gaps.v20,
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: PersistentTabBar(),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 20,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: Sizes.size2,
                          mainAxisSpacing: Sizes.size2,
                          childAspectRatio: 9 / 14,
                        ),
                        itemBuilder: (context, index) => Column(
                          children: [
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 9 / 14,
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder:
                                        "assets/images/placeholder.jpeg",
                                    image:
                                        "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                                  ),
                                ),
                                const Positioned(
                                  bottom: 5,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.play_arrow_outlined,
                                        color: Colors.white,
                                        size: Sizes.size28,
                                      ),
                                      Text(
                                        "4.1M",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Center(
                        child: Text('Page two'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}

class UserAccount extends StatelessWidget {
  const UserAccount({
    super.key,
    required this.count,
    required this.text,
  });

  final String text;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
