import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<LikeState, VideoModel> {
  //FamilyAsyncNotifier는 프로바이더 read할때 프로퍼티를 받아 build에서 초기화때 적용
  late final VideosRepository _repository;
  late final String _videoId;
  late bool isLiked = false;
  late int likeCount;

  @override
  FutureOr<LikeState> build(VideoModel video) async {
    _videoId = video.id;
    _repository = ref.read(videosRepo);
    likeCount = video.likes;
    await isLike();
    return LikeState(isLiked, likeCount);
  }

  Future<void> likeVideo() async {
    final user = ref.read(authRepo).user;

    isLiked = await _repository.likeVideo(_videoId, user!.uid);
    if (isLiked) {
      likeCount += 1;
    } else {
      likeCount -= 1;
    }
    state = AsyncValue.data(LikeState(isLiked, likeCount));
  }

  Future<void> isLike() async {
    final user = ref.read(authRepo).user;
    isLiked = await _repository.isLike(_videoId, user!.uid);
  }
}

class LikeState {
  final bool isLiked;
  final int likeCount;

  LikeState(this.isLiked, this.likeCount);
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, LikeState, VideoModel>(
  () => VideoPostViewModel(),
);
