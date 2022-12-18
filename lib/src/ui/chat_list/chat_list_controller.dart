import 'package:get/get.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';

class ChatListController extends AppBaseController {
  UserModel? loginUser;

  @override
  Future<void> onReady() async {
    loginUser = await getLoginUser();
    ChatService.instance
        .updateUserStatus(userId: loginUser?.id ?? '', status: true);
    ChatService.instance.getUserGroups(userId: loginUser?.id ?? '');
    super.onReady();
  }

  void goUserList() {
    Get.toNamed(userListView);
  }

  void onItemTap(UserModel receiver) {
    Get.toNamed(chatView, arguments: {
      'receiver': receiver,
      'sender': loginUser,
    });
  }
}
