import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/model/message_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:my_buddy/src/ui/chat_view/media_message/media_message_arg.dart';

class MediaMessageController extends AppBaseController {
  final TextEditingController textCtrl = TextEditingController();
  final FocusNode textNode = FocusNode();
  MediaMessageArg? arg;

  @override
  void onInit() {
    arg = Get.arguments;
    super.onInit();
  }

  Future<String> _uploadFile(File file) async {
    String fileName = file.path.substring(file.path.lastIndexOf('/') + 1);
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('images/$fileName')
        .putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    debugPrint('____ _uploadFile $downloadUrl');
    return downloadUrl;
  }

  Future<void> messageSend() async {
    if (arg?.file?.existsSync() ?? false) {
      setBusy(true);
      String fileUrl = await _uploadFile(arg!.file!);
      final message = MessageModel(
        time: DateTime.now().millisecondsSinceEpoch,
        message: textCtrl.text.trim(),
        type: MessageType.image,
        senderId: arg?.sender?.id ?? '',
        receiverId: arg?.receiver?.id ?? '',
        fileUrl: fileUrl,
      );
      textCtrl.text = '';
      await ChatService.instance.sendMessage(
        chatRoomId: arg?.chatRoomId ?? '',
        message: message,
      );
      setBusy(false);
      back();
    } else {
      showToast(msg: 'Please check your file');
    }
  }
}
