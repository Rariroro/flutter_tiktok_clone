import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late bool _isLiked;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");
    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideo(
      {int? lastItemCreatedAt}) {
    //아래 코드는 영상을 가져올때 좋아요가 10개 위의 영상을 가져오는 코드. 이렇게도 할수있다.
    //return _db.collection("videos").where("likes",isGreaterThan: 10).get();

    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);

    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<bool> likeVideo(String videoId, String userId) async {
    final query = _db
        .collection("likes")
        .doc("${videoId}000$userId"); //자동아이디 아닌 userId와videoId결합해서 like아이디 만듬.
    final like = await query.get();

    if (!like.exists) {
      //동일한 아이디의 like가 있으면 만들지 않음.좋아요를 동일한 사람이 두번이상 못하게 하기 위한 방법
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
      _isLiked = true;
      return _isLiked;
    } else {
      await query.delete();
      _isLiked = false;
      return _isLiked;
    }
  }

  Future<bool> isLike(String videoId, String userId) async {
    final query = _db
        .collection("likes")
        .doc("${videoId}000$userId"); //자동아이디 아닌 userId와videoId결합해서 like아이디 만듬.
    final like = await query.get();

    return like.exists;
  }
}

final videosRepo = Provider((ref) => VideosRepository());
