import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_colors.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/src/ui/chat_view/media_message/media_message_controller.dart';
import 'package:my_buddy/src/widgets/load_image_widget.dart';
import 'package:my_buddy/src/widgets/loader_widget.dart';

class MediaMessageView extends StatelessWidget {
  const MediaMessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MediaMessageController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: controller.arg?.from == 1
                ? Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            automaticallyImplyLeading: true,
                          ),
                          Expanded(
                            child: Image.file(
                              controller.arg!.file!,
                              height: context.height,
                              width: context.width,
                              fit: BoxFit.contain,
                              errorBuilder: (context, exception, s) =>
                                  const Text('Failed to load image'),
                            ),
                          ),
                          Container(
                            color: Colors.black38,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    autocorrect: false,
                                    controller: controller.textCtrl,
                                    focusNode: controller.textNode,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    minLines: 1,
                                    style:
                                    const TextStyle().regular.copyWith(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      hintText: typeAMessage,
                                      hintStyle:
                                          const TextStyle().regular.copyWith(
                                                color: Colors.white38,
                                                fontSize: 15,
                                              ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => controller.messageSend(),
                                  style: TextButton.styleFrom(
                                      shape: const CircleBorder(),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(40, 40)),
                                  child: Icon(
                                    Icons.send,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: controller.isBusy,
                        child: const LoaderWidget(),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      LoadImageWidget(
                        imagePath: controller.arg?.fileUrl ?? '',
                        imageType: ImageType.network,
                        height: context.height,
                        width: context.width,
                        boxFit: BoxFit.contain,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: true,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
      init: MediaMessageController(),
    );
  }
}
