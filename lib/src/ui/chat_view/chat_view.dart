import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/app_colors.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/model/message_model.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/src/ui/chat_view/chat_controller.dart';
import 'package:my_buddy/src/widgets/load_image_widget.dart';
import 'package:my_buddy/src/widgets/loader_widget.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leadingWidth: 30,
          title: StreamBuilder(
            stream: controller.userStatusStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = UserModel.fromJson(
                    snapshot.data?.data() as Map<String, dynamic>);
                return Row(
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      shape: const CircleBorder(),
                      child: Image.asset(
                        AppAssets.defaultProfile,
                        height: 40,
                      ),
                    ),
                    10.toSpace(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle().bold.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                          ),
                          3.toSpace(),
                          Text(
                            controller.getLastSeen(user),
                            style: const TextStyle().regular.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.chatStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoaderWidget();
                  } else if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      //controller: controller.scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: snapshot.data?.docs.length ?? 0,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final item = MessageModel.fromJson(
                            snapshot.data?.docs[index].data()
                                as Map<String, dynamic>);
                        return _chatItem(index, controller, item);
                      },
                      separatorBuilder: (context, index) => 10.toSpace(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            6.toSpace(),
            Row(
              children: [
                10.toSpace(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      autocorrect: false,
                      controller: controller.textCtrl,
                      focusNode: controller.textNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        hintText: typeAMessage,
                        hintStyle: const TextStyle().regular.copyWith(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showAttachmentDialog(context, controller),
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40)),
                  child: Icon(
                    Icons.file_copy_outlined,
                    color: primaryColor,
                  ),
                ),
                TextButton(
                  onPressed: () => controller.messageSend(),
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(40, 40)),
                  child: Icon(
                    Icons.send,
                    color: primaryColor,
                  ),
                ),
                10.toSpace(),
              ],
            ),
            10.toSpace(),
          ],
        ),
      ),
      init: ChatController(),
    );
  }

  Widget _chatItem(
      int index, ChatController controller, MessageModel? msgItem) {
    return Container(
      child: msgItem?.senderId == controller.sender?.id
          ? _leftMessageView(msgItem)
          : _rightMessageView(msgItem),
    );
  }

  Widget _leftMessageView(MessageModel? msgItem) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(2),
          ),
        ),
        child: msgItem?.type == MessageType.image
            ? _imageTypeChat(msgItem)
            : _textTypeChat(msg: msgItem?.message ?? ''),
      ),
    );
  }

  Widget _rightMessageView(MessageModel? msgItem) {
    return Container(
      width: Get.width,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: _textTypeChat(msg: msgItem?.message ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textTypeChat({required String msg}) {
    return Text(
      msg,
      textWidthBasis: TextWidthBasis.longestLine,
      textAlign: TextAlign.start,
      style: const TextStyle().regular.copyWith(
            color: Colors.white,
            fontSize: 15,
          ),
    );
  }

  Widget _imageTypeChat(MessageModel? msgItem) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: LoadImageWidget(
              imagePath: msgItem?.fileUrl ?? '',
              imageType: ImageType.network,
              height: 120,
              width: 120,
              errorWidget: const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
              boxFit: BoxFit.fill,
            ),
          ),
          8.toSpace(),
          if (msgItem?.message.isNotEmpty ?? false)
            _textTypeChat(msg: msgItem!.message)
        ],
      ),
    );
  }

  void _showAttachmentDialog(
    BuildContext context,
    ChatController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: List.generate(
              controller.attachmentsOption.length,
              (index) {
                final item = controller.attachmentsOption[index];
                return InkWell(
                  onTap: item.onTap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      item.icon,
                      Text(
                        item.title,
                        style: const TextStyle().regular.copyWith(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
