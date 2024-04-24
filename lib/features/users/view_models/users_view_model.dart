import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:flutter_tiktok_clone/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _userRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _userRepository
          .findProfile(_authenticationRepository.user!.uid);

      if (profile != null) {
        return UserProfileModel.fromJson(json: profile);
      }
    }

    return UserProfileModel.empty();
  }

//유저프로필정보를 넣음.
  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    state = const AsyncValue.loading();
    final profile = UserProfileModel(
        hasAvatar: false,
        bio: ref.read(signUpForm)["bio"] ?? "undefined",
        link: ref.read(signUpForm)["link"] ?? "undefined",
        email: credential.user!.email ?? "anon@anon.com",
        uid: credential.user!.uid,
        name: ref.read(signUpForm)["username"] ?? "undefined",
        birthday: ref.read(signUpForm)["birthday"] ?? "undefined");

    await _userRepository.createProfile(profile);

    // 아래 state가 중요. riverpod의 특별한 부분.
    //빌드 부분에 초기화된 데이터의 정보가 담겨있음.언제든 접근할수있고 수정가능
    state = AsyncValue.data(profile);
  }

//model에 아바타 있다는 것을 알려줌
  Future<void> onAvatarUpload() async {
    //여기서 state에 로딩을 안하는 이유는 아바타 뷰모델에서 하기떄문
    if (state.value == null) return;

    //state를 바로 바꾸면 안되고,복사해서...그래서 모델에 copyWith를 만들어서 앱상의(firebase들어가기전) 기본데이터는 건드리지 않고 복제후 수정을 원하는 값만 넣어 firebase에 넣음.
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));

    //내가 원하는 값만 수정. state.value는 UserProfileModel임

    await _userRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> updateProfile(String bio, String link) async {
    if (state.value == null) return;
    state = const AsyncValue.loading();
    final updatedProfile = state.value!.copyWith(bio: bio, link: link);

    state = await AsyncValue.guard(
      () async {
        await _userRepository
            .updateUser(state.value!.uid, {"bio": bio, "link": link});
        return updatedProfile;
      },
    );
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

//riverpod에서 vm은 크게 state, provider, builder의 특성이 있다.
//state값은, 즉 state.value는 buil에서 리턴한 값이다. 