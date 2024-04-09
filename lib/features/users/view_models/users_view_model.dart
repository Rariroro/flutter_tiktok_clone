import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_tiktok_clone/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    state = const AsyncValue.loading();
    final profile = UserProfileModel(
        bio: "undefined",
        link: "undefined",
        email: credential.user!.email ?? "anon@anon.com",
        uid: credential.user!.uid,
        name: ref.read(signUpForm)["username"] ?? "undefined",
        birthday: ref.read(signUpForm)["birthday"] ?? "undefined");

    await _repository.createProfile(profile);

    // 아래 state가 중요. riverpod의 특별한 부분.
    //빌드 부분에 초기화된 데이터의 정보가 담겨있음.언제든 접근할수있고 수정가능
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);




//riverpod는 크게 state, provider, builder의 특성이 있다.