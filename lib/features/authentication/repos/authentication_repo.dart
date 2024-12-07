import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  // 로그인 여부를 확인하기 위한 클래스
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // 현재 사용자가 로그인되어 있는지 확인하는 getter
  bool get isLoggedIn => user != null;

  // 현재 로그인된 사용자 정보를 반환하는 getter
  User? get user => _firebaseAuth.currentUser;
  // getter는 데이터를 읽을 때 추가적인 처리가 필요한 경우에 사용.
  // 함수보다 간단한 처리의 경우 사용

  // 유저의 인증 상태 변화를 스트림으로 반환
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  // Firebase를 사용하는 역할

  // 이메일과 비밀번호로 회원가입을 처리하는 함수
  Future<UserCredential> emailSignUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 로그아웃을 처리하는 함수
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // 이메일과 비밀번호로 로그인하는 함수
  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Github 계정으로 로그인하는 함수
  Future<void> githubSignIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }
}

// AuthenticationRepository를 제공하는 Provider 생성
final authRepo = Provider((ref) => AuthenticationRepository());

// 인증 상태를 제공하는 StreamProvider 생성
final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo); // AuthenticationRepository 인스턴스를 읽음
  return repo.authStateChanges(); // 인증 상태 변화를 반환하는 스트림을 제공
});
