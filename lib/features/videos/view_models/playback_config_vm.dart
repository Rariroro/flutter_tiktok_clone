import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:flutter_tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMute(value); //값을 받아 디스크에 넣고
    state =
        PlaybackConfigModel(muted: value, autoplay: state.autoplay); //상태를 바꿈
    // 위의 state가 중요. riverpod의 특별한 부분.
    //아래 빌드 부분에 초기화된 데이터의 정보가 담겨있음.언제든 접근할수있고 수정가능
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(muted: state.muted, autoplay: value);
  }

  @override
  PlaybackConfigModel build() {
    //이부분은  사용자에게 전달될 데이터 초기화.
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

//provider는 데이터를 얻고 위의 메소드를 실행하기 위해 사용.view쪽에서 쓰임
final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
//하나(PlaybackConfigViewModel)는 우리가 expose하고 싶은 것,하나(PlaybackConfigModel)는 provider가 expose할 것??
  () =>
      throw UnimplementedError(), //원래는 PlaybackConfigViewModer(repository) 로해야하지만 throw로 하는 이유는 shaerpreference가 필요한데 이게 main에서 await해야하기 때문이야.main에서 오버라이드 했어ㅏ.
);

//즉 riverpod는 크게 state, provider, builder의 특성이 있다.
