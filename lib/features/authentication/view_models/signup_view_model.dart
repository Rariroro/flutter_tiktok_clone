import 'dart:async'; // 비동기 프로그래밍을 위한 라이브러리

import 'package:flutter/material.dart'; // Flutter의 기본 UI 위젯을 사용하기 위한 라이브러리
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod을 사용하기 위한 라이브러리
import 'package:flutter_tiktok_clone/features/authentication/repos/authentication_repo.dart'; // 인증 리포지토리를 사용하기 위한 커스텀 라이브러리
import 'package:flutter_tiktok_clone/features/onboarding/interests_screen.dart'; // 관심사 화면을 사용하기 위한 커스텀 라이브러리
import 'package:flutter_tiktok_clone/features/users/view_models/users_view_model.dart'; // 사용자 뷰 모델을 사용하기 위한 커스텀 라이브러리
import 'package:flutter_tiktok_clone/utils.dart'; // 유틸리티 함수들을 사용하기 위한 커스텀 라이브러리
import 'package:go_router/go_router.dart'; // 라우팅을 관리하기 위한 라이브러리

// SignUpViewModel 클래스는 비동기 상태 관리 기능을 제공하는 AsyncNotifier<void>를 상속받음
class SignUpViewModel extends AsyncNotifier<void> {
  // AuthenticationRepository 타입의 _authRepo 변수를 선언
  late final AuthenticationRepository _authRepo;

  // build 메서드는 초기화 작업을 수행하며, 리포지토리를 Riverpod을 통해 읽어옴
  @override
  FutureOr<void> build() {
    // 초기화 하는 역할
    _authRepo = ref.read(authRepo); // authRepo 프로바이더를 읽어서 _authRepo 변수에 할당
  }

  // signUp 메서드는 사용자를 등록 처리, context는 UI 변경을 위해 필요
  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading(); // state를 로딩 상태로 설정
    final form = ref.read(signUpForm); // 회원가입 폼 데이터를 읽어옴

    // 1. usersProvider의 notifier를 읽어서 users에 할당
    final users = ref.read(usersProvider.notifier);

    state = await AsyncValue.guard(
      () async {
        // 2. 이메일과 비밀번호를 사용하여 FirebaseAuth에 회원가입 요청
        final userCredential = await _authRepo.emailSignUp(
          form["email"],
          form["password"],
        );

        // 3. 회원가입한 사용자 정보로 사용자 프로필을 생성하여 Firestore에 저장
        await users.createProfile(userCredential);
      },
    );

    // state에 에러가 있는지 확인
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error); // 에러가 있으면 스낵바로 에러 메시지 표시
    } else {
      context
          .goNamed(InterestsScreen.routeName); // 에러가 없으면 InterestsScreen 경로로 이동
    }
  }
}

// signUpForm은 StateProvider를 사용하여 회원가입 폼 데이터를 관리
final signUpForm = StateProvider((ref) => {});

// signUpProvider는 AsyncNotifierProvider를 사용하여 SignUpViewModel을 제공
final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
