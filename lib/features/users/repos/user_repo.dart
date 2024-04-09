import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    //컬렉션 만들고, 도큐먼트 아이디에 uid를 넣고, vm에서 받은 파일을 json으로 바꾸어 firestore에 넣음.
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  Future<void> updateProfile() async {}
}

final userRepo = Provider((ref) => UserRepository());
