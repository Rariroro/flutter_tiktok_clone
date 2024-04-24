import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videosRepo);
    _list =
        await _fetchVideos(lastItemCreatedAt: null); //첫번째 페이지를 불러오기 떄문에 null
    return _list;
  }

  Future<List<VideoModel>> _fetchVideos({int? lastItemCreatedAt}) async {
    final result =
        await _repository.fetchVideo(lastItemCreatedAt: lastItemCreatedAt);
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(json: doc.data(), videoId: doc.id),
    ); //map의 방삭을 알야야. 받은 result의 값들을 하나씩 => 이후의 코드를 적용해서 값을 바꿈.}
    return videos.toList();
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(lastItemCreatedAt: null);
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
