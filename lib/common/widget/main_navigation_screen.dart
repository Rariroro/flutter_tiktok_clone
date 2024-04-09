import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/discover/discover_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:flutter_tiktok_clone/features/main_navigation/widgets/nav_tab.dart';
import 'package:flutter_tiktok_clone/features/main_navigation/widgets/post_video_button.dart';
import 'package:flutter_tiktok_clone/features/users/user_profile_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_timeline_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainNavigationScreen extends StatefulWidget {
  static const routeName = "mainNavigation";

  final String tab;

  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "xxxx",
    "inbox",
    "profile",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  /* final screens = [
    const Center(
      child: Text('Home'),
    ),
    const Center(
      child: Text('Discover'),
    ),
    Container(),
    const Center(
      child: Text('Indox'),
    ),
    const Center(
      child: Text('Profile'),
    ),
  ]; */

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    context.pushNamed(VideoRecordingScreen.routeName);
  }

  double scale = 1.0;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      scale = 1.3;
    });
  }

  void _handleTapUP(TapUpDetails details) {
    setState(() {
      scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _selectedIndex == 0 ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(
              username: "니꼬",
              tab: "",
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 99,
        surfaceTintColor: _selectedIndex == 0 ? Colors.black : Colors.white,
        color: _selectedIndex == 0 ? Colors.black : Colors.white,
        elevation: 0.01,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: 'Home',
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: 'Discover',
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTap: () => _onTap(1),
                selectedIndex: _selectedIndex,
              ),
              Gaps.h24,
              GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUP,
                onTapCancel: () {
                  setState(() {
                    scale = 1.0;
                  });
                },
                onTap: _onPostVideoButtonTap,
                child: AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 300),
                  child: PostVideoButton(inverted: _selectedIndex != 0),
                ),
              ),
              Gaps.h24,
              NavTab(
                text: 'Inbox',
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTap(3),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: 'Profile',
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
