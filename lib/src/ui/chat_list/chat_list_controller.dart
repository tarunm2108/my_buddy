import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/model/chat_room_model.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';

class ChatListController extends AppBaseController {
  UserModel? loginUser;

  @override
  Future<void> onReady() async {
    setBusy(true);
    loginUser = await getLoginUser();
    await ChatService.instance
        .updateUserStatus(userId: loginUser?.id ?? '', status: true);
    setBusy(false);
    super.onReady();
  }

  void goUserList() {
    Get.toNamed(userListView);
  }

  void onItemTap(UserModel receiver, ChatRoomModel item) {
    Get.toNamed(chatView, arguments: {
      'receiver': receiver,
      'sender': loginUser,
      'chatRoom': item,
    });
  }

  String getTime(int? lastMessageTime) {
    if (lastMessageTime != null) {
      final date = DateTime.fromMillisecondsSinceEpoch(lastMessageTime);
      return DateFormat(timeFormat).format(date);
    }
    return '';
  }

  Stream chatListStream() {
    return ChatService.instance.getUserChats(userId: loginUser?.id ?? '');
  }

}
