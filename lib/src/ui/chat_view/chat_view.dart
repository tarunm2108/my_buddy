import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/app_colors.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/ui/chat_view/chat_controller.dart';
import 'package:my_buddy/src/widgets/load_image_widget.dart';

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
            stream: ChatService.instance
                .getUserData(userId: controller.receiver?.id ?? ''),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                final user = UserModel.fromJson(
                    snapshot.data?.docs.first.data() as Map<String, dynamic>);
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
                            user.name ?? 'User',
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
              child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemBuilder: (context, index) =>
                    _chatItem(index, context, controller),
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
                  onPressed: () {},
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
                  onPressed: () {},
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

  Widget _chatItem(int index, BuildContext context, ChatController controller) {
    return Container(
      child: index == 3 ? _leftMessageView() : _rightMessageView(),
    );
  }

  Widget _leftMessageView() {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      alignment: Alignment.centerRight,
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(2),
          ),
        ),
        child: _textTypeChat(),
      ),
    );
  }

  Widget _rightMessageView() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: _textTypeChat(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textTypeChat() {
    return Text(
      'Testing2djb fdfnsdkfsd sdfdsjkfsdf sdfisjdfksdf sdfsdnfskdfsd dfskdfsdkfsd sdlfksdfskdfs fsdlfksdnfsdfsdlfjsdnfs',
      textWidthBasis: TextWidthBasis.longestLine,
      textAlign: TextAlign.start,
      style: const TextStyle().regular.copyWith(
            color: Colors.white,
            fontSize: 15,
          ),
    );
  }

  Widget imageTypeChat() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        child: const LoadImageWidget(
          imagePath: '',
          imageType: ImageType.network,
          height: 120,
          width: 120,
          errorWidget: Center(
            child: Icon(
              Icons.error,
              color: Colors.white,
            ),
          ),
          boxFit: BoxFit.fill,
        ),
      ),
    );
  }
}
