class ChatModel {
  final String personA;
  final String personB;
  final String id;

  ChatModel({
    required this.personA,
    required this.personB,
    required this.id,
  });

  ChatModel.fromJson({required Map<String, dynamic> json})
      : personA = json["personA"],
        personB = json["personB"],
        id = json["id"];

  Map<String, dynamic> toJson() {
    return {
      "personA": personA,
      "personB": personB,
      "id": id,
    };
  }
}
