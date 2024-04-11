import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    //컬렉션 만들고, 도큐먼트 아이디에 uid를 넣고, vm에서 받은 파일을 json으로 바꾸어 firestore에 넣음.
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    //실제파일을 넣기전에 파일이름을 넣어 공간을 먼저 만든다.
    final fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(file); //파일업로드
  }

//내가 원하는 데이터만 firebase에 수정
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  Future<void> updateProfile() async {}
}

final userRepo = Provider((ref) => UserRepository());
