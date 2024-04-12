import 'dart:async';
import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/videos_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  Future<void> uploadVideo() async {}
}
