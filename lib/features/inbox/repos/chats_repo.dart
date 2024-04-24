import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/chat_model.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class ChatsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //final List<UserProfileModel> _userList = [];

  Future<QuerySnapshot<Map<String, dynamic>>> loadChats(String userId) async {
    return await _db
        .collection("users")
        .doc(userId)
        .collection("chat_rooms")
        .get();
  }

  Future<void> createdChat(ChatModel data) async {
    await _db.collection("chat_rooms").add(data.toJson());
  }

  Future<void> deleteChat() async {}

  Future<List<String>> getActiveChatPartners(String userId) async {
    var chatRooms = await _db
        .collection('chat_rooms')
        .where('personA', isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs)
        .then((docs) => docs.map((doc) => doc['personB'] as String).toList());

    var chatRooms2 = await _db
        .collection('chat_rooms')
        .where('personB', isEqualTo: userId)
        .get()
        .then((snapshot) => snapshot.docs)
        .then((docs) => docs.map((doc) => doc['personA'] as String).toList());

    return [...chatRooms, ...chatRooms2];
  }

  Future<List<UserProfileModel>> getAvailableChatCandidates(
      String currentUserId) async {
    List<String> activeChatPartners =
        await getActiveChatPartners(currentUserId);

    final allUserDocs = await _db
        .collection('users')
        .get()
        .then((snapshot) => snapshot.docs)
        .then((docs) => docs
            .map((doc) => UserProfileModel.fromJson(json: doc.data()))
            .toList());

    // 현재 채팅 중인 사용자와 현재 사용자를 제외하고, 각 사용자의 문서 전체를 반환
    return allUserDocs
        .where((userProfile) =>
            !activeChatPartners.contains(userProfile.uid) &&
            userProfile.uid != currentUserId)
        .toList();
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> usersList() async {
  //   final userList = await _db.collection("users").get();
  //   print(userList);
  //   return userList;
  // }
}

final chatsRepo = Provider((ref) => ChatsRepository());
