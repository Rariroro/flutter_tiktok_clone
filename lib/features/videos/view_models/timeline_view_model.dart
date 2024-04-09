import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];

  void uploadVideo() async {
    state = const AsyncValue.loading(); //이 클래스가 다시 로딩
    await Future.delayed(const Duration(seconds: 2)); //의도적으로 딜레이
    final newVideo = VideoModel(title: "${DateTime.now()}");
    _list = [..._list, newVideo]; //기존 list에 항목 추가하는 방식과 다름을 주의
    state = AsyncValue.data(_list); //AsyncNotifier안에 있기 때문에 그냥 모델을 넣을수 없고 이렇게
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 5)); //의도적으로 딜레이
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
