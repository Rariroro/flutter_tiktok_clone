import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  //로그인 됐는지 확인하기 위한 클래스
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth
      .currentUser; //getter는 데이터를 읽을 때 추가적인 처리가 필요한 경우에 사용. 함수보다 간단한 처리의 경우 사용

  Stream<User?> authStateChanges() =>
      _firebaseAuth.authStateChanges(); //유저의 인증상태를 계속 체크

//firebase를 사용하는 역할
  Future<UserCredential> emailSignUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> githubSignIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }
}

final authRepo = Provider((ref) => AuthenticationRepository()); //프로바이더 만듬

final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
