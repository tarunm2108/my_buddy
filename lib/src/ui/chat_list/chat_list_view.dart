import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/app_colors.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/model/chat_room_model.dart';
import 'package:my_buddy/model/message_model.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/ui/chat_list/chat_list_controller.dart';
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
                  fontSize: 16,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () => controller.showLogoutDialog(),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: controller.isBusy
            ? const LoaderWidget()
            : StreamBuilder(
                stream: controller.chatListStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          startChats,
                          style: const TextStyle().regular,
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _item(controller, snapshot.data?[index]);
                        });
                  } else {
                    return const LoaderWidget();
                  }
                }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.goUserList(),
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
          ),
        ),

      ),
      init: ChatListController(),
    );
  }

  Widget _item(
    ChatListController controller,
    QueryDocumentSnapshot<Object?>? doc,
  ) {
    final item = ChatRoomModel.fromJson(doc?.data() as Map<String, dynamic>);
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
                            child: Image.asset(
                              AppAssets.defaultProfile,
                              height: 50,
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
                              ),
                        ),
                        5.toSpace(),
                        Text(
                          lastMsg(
                            item.lastMessageType!,
                            item.lastMessage ?? '',
                          ),
                          style: const TextStyle().regular.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.getTime(item.lastMessageTime),
                          style: const TextStyle().regular.copyWith(
                                color: Colors.black38,
                                fontSize: 12,
                              ),
                        ),
                        _unreadCount(
                            doc?.data() as Map<String, dynamic>, controller),
                      ],
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

  String lastMsg(MessageType type, String msg) {
    switch (type) {
      case MessageType.text:
        return msg;
      case MessageType.image:
        return 'Send a image';
      case MessageType.video:
        return 'Send a video';
      case MessageType.voice:
        return 'Send a voice';
      case MessageType.doc:
        return 'Send a document';
    }
  }

  Widget _unreadCount(
    Map<String, dynamic> data,
    ChatListController controller,
  ) {
    int? count = data['${controller.loginUser!.id}_unread'];
    if ((count ?? 0) > 0) {
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
