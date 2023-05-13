import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/model/chat_room_model.dart';
import 'package:my_buddy/model/message_model.dart';
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

  Stream<DocumentSnapshot<Object?>> getUserData({required String userId}) {
    return userCollection.doc(userId).snapshots(includeMetadataChanges: true);
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
    Map<String, dynamic> data = {};
    if (status) {
      data = {
        "isOnline": status,
      };
    } else {
      data = {
        "isOnline": status,
        "lastSeenTime": DateFormat(serverDate).format(DateTime.now()),
      };
    }
    return await userCollection
        .doc(userId)
        .update(data)
        .catchError((e) => debugPrint("____ updateUserStatus error $e"));
  }

  Future<UserModel> createUser({required UserModel user}) async {
    // String fcmToken = await SharedPre.getStringValue(Constants.FCM_TOKEN);
    final docRef = userCollection.doc();
    user.id = docRef.id;
    await docRef.set(user.toJson());
    return user;
  }

  Future<void> updateUserProfile({required UserModel user}) async {
    return await userCollection.doc(user.id).update(user.toJson());
  }

  // create chat room
  Future<void> createChatRoom({
    required String senderId,
    required String receiverId,
    required ChatRoomModel chatRoom,
  }) async {
    return await chatsCollection.doc(chatRoom.id).set(chatRoom.toJson());
  }

  // send message
  Future<String> sendMessage({
    required String chatRoomId,
    required MessageModel message,
  }) async {
    await chatsCollection
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toJson());
    updateUnreadCount(userId: message.receiverId, chatRoomId: chatRoomId);
    await chatsCollection.doc(chatRoomId).update({
      'lastMessage': message.message,
      'lastMessageType': encodeMessageType(type: message.type),
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
    });
    return chatRoomId;
  }

  Future<String> getUserFcm({required String userId}) async {
    final ref = await userCollection.doc(userId).get();
    final user = UserModel.fromJson(ref.data() as Map<String,dynamic>);
    return user.fcmToken ?? '';
  }

  Future<void> updateUnreadCount({
    required String userId,
    required String chatRoomId,
    bool? isAllRead,
  }) async {
    final docRef = await chatsCollection.doc(chatRoomId).get();
    final data = docRef.data() as Map<String, dynamic>;
    if (isAllRead ?? false) {
      await chatsCollection.doc(chatRoomId).update({
        '${userId}_unread': 0,
      });
    } else {
      int? count = data['${userId}_unread'];
      await chatsCollection.doc(chatRoomId).update({
        '${userId}_unread': count == null ? 1 : count + 1,
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages({
    required String chatRoomId,
    required int limit,
  }) {
    return chatsCollection
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<List<QueryDocumentSnapshot<Object?>>> getUserChats({
    required String userId,
  }) {
    return chatsCollection.snapshots().map((event) => event.docs.where((e) {
          return e.id.contains(userId);
        }).toList());
  }

  Stream<QuerySnapshot<Object?>> getAllUser({required String userId}) {
    return userCollection.where('id', isNotEqualTo: userId).snapshots();
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }

  Future<UserModel?> checkUserExist(
      {required String mobile, required String phoneCode}) async {
    final doc = await userCollection
        .where('mobile', isEqualTo: mobile)
        .where('phoneCode', isEqualTo: phoneCode)
        .get();
    if (doc.docs.isNotEmpty) {
      return UserModel.fromJson(doc.docs.first.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
