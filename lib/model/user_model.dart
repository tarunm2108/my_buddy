class UserModel {
  String id;
  String name;
  String mobile;
  String phoneCode;
  String dob;
  String gender;
  String? profileUrl;
  String? fcmToken;
  String? email;
  bool? isOnline;
  String? lastSeenTime;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.phoneCode,
    required this.dob,
    required this.gender,
    this.profileUrl,
    this.isOnline,
    this.lastSeenTime,
    this.email,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] == null ? null : json["id"],
        name: json['name'] == null ? null : json["name"],
        mobile: json['mobile'] == null ? null : json["mobile"],
        phoneCode: json['phoneCode'] == null ? null : json["phoneCode"],
        profileUrl: json['profileUrl'] == null ? null : json["profileUrl"],
        email: json['email'] == null ? null : json["email"],
        isOnline: json['isOnline'] == null ? false : json["isOnline"],
        dob: json['dob'] == null ? null : json["dob"],
        gender: json['gender'] == null ? null : json["gender"],
    fcmToken: json['fcmToken'] == null ? null : json["fcmToken"],
        lastSeenTime:
            json['lastSeenTime'] == null ? null : json["lastSeenTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "phoneCode": phoneCode,
        "profileUrl": profileUrl,
        "isOnline": isOnline,
        "gender": gender,
        "dob": dob,
        "email": email,
        "lastSeenTime": lastSeenTime,
        "fcmToken": fcmToken,
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? mobile,
    String? phoneCode,
    String? dob,
    String? gender,
    String? profileUrl,
    String? email,
    bool? isOnline,
    String? lastSeenTime,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      phoneCode: phoneCode ?? this.phoneCode,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      profileUrl: profileUrl ?? this.profileUrl,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
      lastSeenTime: lastSeenTime ?? this.lastSeenTime,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

}
