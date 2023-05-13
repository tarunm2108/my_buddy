import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/model/chat_room_model.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';

class UserListController extends AppBaseController {
  UserModel? loginUser;

  @override
  Future<void> onReady() async {
    loginUser = getLoginUser();
    update();
    super.onReady();
  }

  Future<void> onItemTap(QueryDocumentSnapshot<Object?> doc) async {
    final loginUser = getLoginUser();
    final user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    final item = ChatRoomModel(
      id: "${loginUser.id}_chat_room_${user.id}",
      members: [loginUser.id, user.id],
    );
    await ChatService.instance.createChatRoom(
      senderId: loginUser.id,
      receiverId: user.id,
      chatRoom: item,
    );
    Get.offAndToNamed(chatView, arguments: {
      'receiver': user,
      'sender': loginUser,
      'chatRoom': item,
    });
  }
}
