import 'package:my_buddy/model/message_model.dart';

class ChatRoomModel {
  String id;
  List<String> members;
  String? lastMessage;
  MessageType? lastMessageType;
  int? lastMessageTime;

  ChatRoomModel({
    required this.id,
    required this.members,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageType,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        id: json['id'] == null ? null : json["id"],
        members: json["members"] == null
            ? []
            : List<String>.from(json["members"].map((x) => x)),
        lastMessage: json['lastMessage'] == null ? '' : json["lastMessage"],
        lastMessageType:
            json['lastMessageType'] == null ? MessageType.text : decodeMessageType(type:json["lastMessageType"]),
        lastMessageTime:
            json['lastMessageTime'] == null ? 0 : json["lastMessageTime"],

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "members": members,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime,
        "lastMessageType":  encodeMessageType(type: lastMessageType!),
      };
}
