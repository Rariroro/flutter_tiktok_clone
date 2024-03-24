import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/features/authentication/email_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/login_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/username_screen.dart';
import 'package:flutter_tiktok_clone/features/users/user_profile_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/video_recording_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const VideoRecordingScreen(),
    ),
  ],
);
