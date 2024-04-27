import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_tiktok_clone/utils.dart';
import 'package:go_router/go_router.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    //초기화 하는 역할
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);

    //1.uservm 리스너를 받아놓기
    final users = ref.read(usersProvider.notifier);
    //print(form["username"]);
    state = await AsyncValue.guard(
      () async {
        //2.회원가입 하면 firebaseauth에서 유저정보 받아놓기
        final userCredential = await _authRepo.emailSignUp(
          form["email"],
          form["password"],
        );

        //  await userCredential.user!.updateDisplayName("dsfdfd");

        //3.firebaseauth에서 받은 유저정보를 유저프로필(firestore)에 저장
        await users.createProfile(userCredential);

        // print(userCredential.user);
      },
    );

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(InterestsScreen.routeName);
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
