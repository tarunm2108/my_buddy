import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:my_buddy/model/chat_room_model.dart';
import 'package:my_buddy/model/message_model.dart';
import 'package:my_buddy/model/user_chats_model.dart';
import 'package:my_buddy/model/user_model.dart';

class ChatService {
  static const String users = 'users';
  static const String chatRooms = 'chat_rooms';
  static const String conversations = 'conversations';

  static final ChatService instance = ChatService._internal();

  factory ChatService() => instance;

  ChatService._internal();

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(users);
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection(chatRooms);

  // update userdata
  void updateUserData(UserModel user) async {
    await userCollection.doc(user.id).update({
      "id": user.id,
      "name": user.name,
      "mobile": user.mobile,
      "phoneCode": user.phoneCode,
      "profileUrl": user.profileUrl,
      "isOnline": user.isOnline,
    });
  }

  Stream<QuerySnapshot<Object?>> getUserData({required String userId}){
    return userCollection.where('id',isEqualTo: userId).get().asStream();
  }

  Future<UserModel?> getUserById({required String userId}) async {
    final doc = await userCollection.doc(userId).get();
    if (doc.data().toString().isNotEmpty) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // update userdata
  Future<void> updateUserStatus({
    required String userId,
    required bool status,
  }) async {
    return await userCollection.doc(userId).update({
      "isOnline": status,
    }).catchError((e) => debugPrint("____ updateUserStatus error $e"));
  }

  Future<UserModel> createUser({required UserModel user}) async {
    // String fcmToken = await SharedPre.getStringValue(Constants.FCM_TOKEN);
    final docRef = userCollection.doc();
    user.id = docRef.id;
    await docRef.set(user.toJson());
    return user;
  }

  // create chat room
  Future createGroup({
    required String loginUserId,
    required ChatRoomModel chatRoom,
  }) async {
    await chatsCollection.doc(chatRoom.id).set(chatRoom.toJson());
    //DateTime.now().millisecondsSinceEpoch
    await userCollection.doc(loginUserId).update({
      'chatList': FieldValue.arrayUnion([
        UserChatsModel(id: chatRoom.id, unreadCount: 0).toJson(),
      ])
    });
  }

  // get user groups
  Stream<DocumentSnapshot<Object?>> getUserGroups({required String userId}) {
    return chatsCollection.doc().snapshots().where((event) {
      log("___- event ${event.id}");
      return true;
    });
  }

  // send message
  Future<String> sendMessage(
      {required String groupId, required MessageModel message}) async {
    await chatsCollection.doc(groupId).update({
      'messages': FieldValue.arrayUnion([message.toJson()]),
    });
    await chatsCollection.doc(groupId).update({
      'lastMessage': message.message,
      'lastMessageType': encodeMessageType(type: message.type),
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
    });
    return groupId;
  }

  Stream<QuerySnapshot<Object?>> getUserChats({required String userId}) {
    return chatsCollection.snapshots();
  }

  Stream<QuerySnapshot<Object?>> getAllUser({required String userId}) {
    return userCollection.where('id', isNotEqualTo: userId).snapshots();
  }

  // get chats of a particular group
  Stream<QuerySnapshot> getChats(String groupId) {
    return chatsCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time', descending: true)
        .get()
        .asStream();
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }

  Stream<QuerySnapshot> getRecentMsg(String groupId) {
    return chatsCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .limitToLast(2)
        .snapshots();
  }
}
