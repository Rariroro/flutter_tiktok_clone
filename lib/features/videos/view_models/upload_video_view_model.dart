import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';
import 'package:go_router/go_router.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;

    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () async {
          final task = await _repository.uploadVideoFile(video, user!.uid);
          if (task.metadata != null) {
            await _repository.saveVideo(
              VideoModel(
                  title: ref.read(videoForm)["title"] ?? '',
                  description: ref.read(videoForm)["description"] ?? '',
                  fileUrl: await task.ref.getDownloadURL(),
                  thumbnailUrl: '', //백엔드(cloud Function)에서 썸네일 URL을 줌.
                  creatorUid: user.uid,
                  creator: userProfile.name,
                  likes: 0,
                  comments: 0,
                  createdAt: DateTime.now().millisecondsSinceEpoch),
            );
            context.pushReplacement("/home");
          }
        },
      );
    }
  }
}

final videoForm = StateProvider((ref) => {});

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
