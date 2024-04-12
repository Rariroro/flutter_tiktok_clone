import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/users/repos/user_repo.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid;
    state = await AsyncValue.guard(
      () async {
        //파일업로드
        await _repository.uploadAvatar(file, fileName);
        //model에 아바타 있다는것을 알려줌
        await ref.read(usersProvider.notifier).onAvatarUpload();
      },
    );
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);


//riverpod에서 vm은 크게 state, provider, builder의 특성이 있다.
//state값은, 즉 state.value는 buil에서 리턴한 값이다.