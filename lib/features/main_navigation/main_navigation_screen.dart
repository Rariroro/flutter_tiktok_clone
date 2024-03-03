import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/main_navigation/widgets/nav_tab.dart';
import 'package:flutter_tiktok_clone/features/main_navigation/widgets/post_video_button.dart';
import 'package:flutter_tiktok_clone/features/videos/video_timeline_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectIndex = 0;

  final screens = [
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
  ];

  void _onTap(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Record video',
            ),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
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
      body: Stack(
        children: [
          Offstage(
            offstage: _selectIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectIndex != 1,
            child: Container(),
          ),
          Offstage(
            offstage: _selectIndex != 3,
            child: Container(),
          ),
          Offstage(
            offstage: _selectIndex != 4,
            child: Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 99,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: 'Home',
                isSelected: _selectIndex == 0,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
              ),
              NavTab(
                text: 'Discover',
                isSelected: _selectIndex == 1,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTap: () => _onTap(1),
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
                      child: const PostVideoButton())),
              Gaps.h24,
              NavTab(
                text: 'Inbox',
                isSelected: _selectIndex == 3,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTap(3),
              ),
              NavTab(
                text: 'Profile',
                isSelected: _selectIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
