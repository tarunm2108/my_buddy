enum MessageType { text, image, video, voice, doc }

MessageType decodeMessageType({required String type}) {
  switch (type) {
    case '0':
      return MessageType.text;
    case '1':
      return MessageType.image;
    case '2':
      return MessageType.video;
    case '3':
      return MessageType.voice;
    case '4':
      return MessageType.doc;
    default:
      return MessageType.text;
  }
}

String encodeMessageType({required MessageType type}) {
  switch (type) {
    case MessageType.text:
      return '0';
    case MessageType.image:
      return '1';
    case MessageType.video:
      return '2';
    case MessageType.voice:
      return '3';
    case MessageType.doc:
      return '4';
  }
}

class MessageModel {
  int time;
  String message;
  MessageType type;
  String senderId;
  String receiverId;

  MessageModel({
    required this.time,
    required this.message,
    required this.type,
    required this.senderId,
    required this.receiverId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        time: json['time'] == null ? null : json["time"],
        message: json['message'] == null ? null : json["message"],
        type: json['type'] == null
            ? MessageType.text
            : decodeMessageType(type: json["type"].toString()),
        senderId: json['senderId'] == null ? null : json["senderId"],
        receiverId: json['receiverId'] == null ? null : json["receiverId"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "message": message,
        "type": encodeMessageType(type: type),
        "senderId": senderId,
        "receiverId": receiverId,
      };
}
