import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:go_router/go_router.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    await _db.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListeners(BuildContext context) async {
    //eventlistener이다. firebase에서 메세지 이벤트가 오면 받는것
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    //Foreground 일때 실행
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage event) {
        print("I just got a message and I'm in the foreground");
        print(event.notification?.title);
      },
    );

    //Background 일때 실행
    FirebaseMessaging.onMessageOpenedApp.listen(
      (notification) {
        context.pushNamed(ChatsScreen.routeName);
      },
    );

    //Terminated 일때 실행, 앱이 죽어있다가 유저가 알림을 탭 해서 깨어났을때 메세지를 받음.
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {
      context.go(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    await initListeners(context);
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
