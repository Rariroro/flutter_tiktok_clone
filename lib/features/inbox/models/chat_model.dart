class ChatModel {
  final List<dynamic> participants;
  //final String personA;
  //final String personB;
  final String id;

  ChatModel({
    //required this.personA,
    //required this.personB,
    required this.participants,
    required this.id,
  });

  ChatModel.fromJson(
      {required Map<String, dynamic> json, required String chatId})
      : // personA = json["personA"],
        //personB = json["personB"],
        participants = json["participants"],
        id = chatId;

  Map<String, dynamic> toJson() {
    return {
      // "personA": personA,
      //"personB": personB,
      "participants": participants,
      "id": id,
    };
  }
}
