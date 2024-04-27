import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tiktok_clone/features/inbox/models/chat_model.dart';
import 'package:flutter_tiktok_clone/features/users/models/user_profile_model.dart';

class ChatsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //final List<UserProfileModel> _userList = [];

  Future<QuerySnapshot<Map<String, dynamic>>> loadChats(
      String currentUserId) async {
    return await _db
        .collection("chat_rooms")
        .where('participants', arrayContains: currentUserId)
        .get();
  }

  Future<void> createdChat(ChatModel data) async {
    await _db.collection("chat_rooms").add(data.toJson());
  }

  Future<void> deleteChat() async {}

  Future<List<dynamic>> getActiveChatPartners(String userId) async {
    //이함수는 추후에 firebase까지 안가고 _chatList에서
    var activeChatPartners = await _db
        .collection('chat_rooms')
        .where('participants',
            arrayContains: userId) // 참여자 배열에 사용자 ID가 포함되어 있는 문서 찾기
        .get()
        .then((snapshot) => snapshot.docs)
        .then((docs) => docs
            .map((doc) {
              var otherParticipants = List<dynamic>.from(doc['participants']);
              otherParticipants.remove(userId); // 현재 사용자를 제외한 다른 참여자들만 반환
              return otherParticipants;
            })
            .expand((element) => element)
            .toList()); // 모든 참여자 목록을 하나의 리스트로 펼침

    return activeChatPartners;
  }

  Future<List<UserProfileModel>> getAvailableChatCandidates(
      String currentUserId) async {
    List<dynamic> activeChatPartners =
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
