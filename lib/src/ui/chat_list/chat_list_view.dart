import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/app_colors.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/model/chat_room_model.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/ui/chat_list/chat_list_controller.dart';
import 'package:my_buddy/src/ui/chat_list/drawer/drawer_view.dart';
import 'package:my_buddy/src/widgets/load_image_widget.dart';
import 'package:my_buddy/src/widgets/loader_widget.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Chats',
            style: const TextStyle().bold.copyWith(
                  color: Colors.white,
                  fontSize: 21,
                ),
          ),
        ),
        body: controller.isBusy
            ? const LoaderWidget()
            : StreamBuilder(
                stream: controller.chatListStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return snapshot.data?.length == 0
                        ? Center(
                            child: Text(
                              startChats,
                              textAlign: TextAlign.center,
                              style: const TextStyle()
                                  .regular
                                  .copyWith(color: Colors.black),
                            ),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final doc = snapshot.data?[index];
                              return _item(controller,
                                  doc?.data() as Map<String, dynamic>);
                            },
                          );
                  } else {
                    return const LoaderWidget();
                  }
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.goUserList(),
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
          ),
        ),
        drawer: const DrawerView(),
      ),
      init: ChatListController(),
    );
  }

  Widget _item(
    ChatListController controller,
    Map<String, dynamic> data,
  ) {
    final item = ChatRoomModel.fromJson(data);
    final receiverId = item.members
        .firstWhere((element) => element != controller.loginUser?.id);
    return StreamBuilder(
      stream: ChatService.instance.getUserData(userId: receiverId),
      builder: (con, snap) {
        if (snap.hasData) {
          final user = UserModel.fromJson(
            snap.data?.data() as Map<String, dynamic>,
          );
          return InkWell(
            onTap: () => controller.onItemTap(user, item),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Stack(
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            clipBehavior: Clip.antiAlias,
                            shape: CircleBorder(
                              side: BorderSide(color: primaryColor),
                            ),
                            child: LoadImageWidget(
                              imageType: ImageType.network,
                              imagePath: user.profileUrl ?? '',
                              height: 50,
                              errorWidget: Image.asset(
                                AppAssets.defaultProfile,
                                height: 50,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.circle,
                              size: 16,
                              color: user.isOnline ?? false
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle().medium.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: controller.checkCount(data) > 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                        5.toSpace(),
                        Text(
                          controller.decodeMessageTypeToString(
                            item.lastMessageType!,
                            item.lastMessage ?? '',
                          ),
                          style: const TextStyle().regular.copyWith(
                                color: controller.checkCount(data) > 0
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: controller.checkCount(data) > 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.getTime(item.lastMessageTime),
                            style: const TextStyle().regular.copyWith(
                                  color: controller.checkCount(data) > 0
                                      ? primaryColor
                                      : Colors.black38,
                                  fontSize: 12,
                                ),
                          ),
                          _unreadCount(data, controller),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black12,
                    height: 14,
                    thickness: 1,
                  )
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _unreadCount(
    Map<String, dynamic> data,
    ChatListController controller,
  ) {
    int count = controller.checkCount(data);
    if (count > 0) {
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$count',
          style: const TextStyle().regular.copyWith(
                color: Colors.white,
                fontSize: 12,
              ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
