class UserChatsModel {
  String id;
  int unreadCount;

  UserChatsModel({
    required this.id,
    required this.unreadCount,
  });

  factory UserChatsModel.fromJson(Map<String, dynamic> json) => UserChatsModel(
        id: json['id'] == null ? null : json["id"],
        unreadCount: json['unreadCount'] == null ? 0 : json["unreadCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unreadCount": unreadCount,
      };
}
