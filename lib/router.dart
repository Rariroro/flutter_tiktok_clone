import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/common/widget/main_navigation_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/login_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:flutter_tiktok_clone/features/notification/notifications_provider.dart';
import 'package:flutter_tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:flutter_tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  //ref.watch(authState); //이 코드를 라우터에 바로 넣으면,변화있을때 아래가 리빌드
  return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            ref.read(notificationsProvider(context));
            return child;
          },
          routes: [
            GoRoute(
              name: SignUpScreen.routeName,
              path: SignUpScreen.routeURL,
              builder: (context, state) => const SignUpScreen(),
            ),
            GoRoute(
              name: LoginScreen.routeName,
              path: LoginScreen.routeURL,
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              name: InterestsScreen.routeName,
              path: InterestsScreen.routeURL,
              builder: (context, state) => const InterestsScreen(),
            ),
            GoRoute(
              name: MainNavigationScreen.routeName,
              path: "/:tab(home|discover|inbox|profile)",
              builder: (context, state) {
                final tab = state.params["tab"]!;
                return MainNavigationScreen(
                  tab: tab,
                );
              },
            ),
            GoRoute(
              name: ActivityScreen.routeName,
              path: ActivityScreen.routeURL,
              builder: (context, state) => const ActivityScreen(),
            ),
            GoRoute(
              name: ChatsScreen.routeName,
              path: ChatsScreen.routeURL,
              builder: (context, state) => const ChatsScreen(),
              routes: [
                GoRoute(
                  path: ChatDetailScreen.routeURL,
                  name: ChatDetailScreen.routeName,
                  builder: (context, state) {
                    final chatId = state.params["chatId"]!;

                    return ChatDetailScreen(chatId: chatId);
                  },
                ),
              ],
            ),
            GoRoute(
                path: VideoRecordingScreen.routeURL,
                name: VideoRecordingScreen.routeName,
                pageBuilder: (context, state) => CustomTransitionPage(
                      transitionDuration: const Duration(milliseconds: 200),
                      child: const VideoRecordingScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final position =
                            Tween(begin: const Offset(0, 1), end: Offset.zero)
                                .animate(animation);
                        return SlideTransition(
                          position: position,
                          child: child,
                        );
                      },
                    )),
          ],
        )
      ]);
});
