import 'package:my_buddy/model/user_chats_model.dart';

class UserModel {
  String id;
  String name;
  String mobile;
  String phoneCode;
  String dob;
  String gender;
  String? profileUrl;
  bool? isOnline;
  String? lastSeenTime;
  List<UserChatsModel>? chatList;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.phoneCode,
    required this.dob,
    required this.gender,
    this.profileUrl,
    this.isOnline,
    this.chatList,
    this.lastSeenTime,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] == null ? null : json["id"],
        name: json['name'] == null ? null : json["name"],
        mobile: json['mobile'] == null ? null : json["mobile"],
        phoneCode: json['phoneCode'] == null ? null : json["phoneCode"],
        profileUrl: json['profileUrl'] == null ? null : json["profileUrl"],
        isOnline: json['isOnline'] == null ? false : json["isOnline"],
        dob: json['dob'] == null ? null : json["dob"],
        gender: json['gender'] == null ? null : json["gender"],
        lastSeenTime:
            json['lastSeenTime'] == null ? null : json["lastSeenTime"],
        chatList: json["chatList"] == null
            ? []
            : List<UserChatsModel>.from(
                json["chatList"].map((x) => UserChatsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "phoneCode": phoneCode,
        "profileUrl": profileUrl,
        "isOnline": isOnline,
        "chatList": chatList,
        "gender": gender,
        "dob": dob,
        "lastSeenTime": lastSeenTime,
      };
}
