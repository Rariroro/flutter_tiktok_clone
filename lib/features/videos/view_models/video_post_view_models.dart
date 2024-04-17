import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  //FamilyAsyncNotifier는 프로바이더 read할때 프로퍼티를 받아 build에서 초기화때 적용
  late final VideosRepository _repository;
  late final String _videoId;
  late bool isliked = false;

  @override
  FutureOr<void> build(String videoId) async {
    _videoId = videoId;
    _repository = ref.read(videosRepo);
    isliked = await initLike();
  }

  Future<bool> likeVideo() async {
    final user = ref.read(authRepo).user;
    isliked = await _repository.likeVideo(_videoId, user!.uid);
    return isliked;
  }

  Future<bool> initLike() async {
    final user = ref.read(authRepo).user;
    return _repository.initLike(_videoId, user!.uid);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);
