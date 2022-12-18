import 'package:my_buddy/model/message_model.dart';

class ChatRoomModel {
  String id;
  List<String> members;
  String? lastMessage;
  String? lastMessageType;
  int? lastMessageTime;
  List<MessageModel>? messages;

  ChatRoomModel({
    required this.id,
    required this.members,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageType,
    this.messages,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        id: json['id'] == null ? null : json["id"],
        members: json["members"] == null
            ? []
            : List<String>.from(json["members"].map((x) => x)),
        lastMessage: json['lastMessage'] == null ? '' : json["lastMessage"],
        lastMessageType:
            json['lastMessageType'] == null ? '' : json["lastMessageType"],
        lastMessageTime:
            json['lastMessageTime'] == null ? '' : json["lastMessageTime"],
        messages: json["messages"] == null
            ? []
            : List<MessageModel>.from(
                json["messages"].map((x) => MessageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "members": members,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime,
        "messages": messages,
        "lastMessageType": lastMessageType,
      };
}
