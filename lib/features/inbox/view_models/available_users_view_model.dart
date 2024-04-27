import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/inbox/repos/chats_repo.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class AvailableUsersViewModel
    extends AutoDisposeAsyncNotifier<List<UserProfileModel>> {
  // late final UserRepository _userRepository;
  late final ChatsRepository _chatsRepository;
  late final AuthenticationRepository _authenticationRepository;
  //List<UserProfileModel> _usersList = [];

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _chatsRepository = ref.read(chatsRepo);
    _authenticationRepository = ref.read(authRepo);
    final usersList =
        await getActiveChatPartners(_authenticationRepository.user!.uid);
    return usersList;
  }

  Future<List<UserProfileModel>> getActiveChatPartners(String userId) async {
    state = const AsyncValue.loading();
    final availableUsers =
        await _chatsRepository.getAvailableChatCandidates(userId);
    state = AsyncValue.data(availableUsers);
    return availableUsers;
  }

  // Future<List<UserProfileModel>> usersList() async {
  //   final result = await _chatsRepository.usersList();
  //   final users = result.docs
  //       .map((doc) => UserProfileModel.fromJson(json: doc.data()))
  //       .toList();
  //   users.removeWhere((user) => user.uid == ref.read(authRepo).user!.uid);

  //   return users;
  // }
}

final availableUsersProvider = AsyncNotifierProvider.autoDispose<
    AvailableUsersViewModel, List<UserProfileModel>>(
  () => AvailableUsersViewModel(),
);
