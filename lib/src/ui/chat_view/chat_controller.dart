import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/model/chat_room_model.dart';
import 'package:my_buddy/model/message_model.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:my_buddy/src/ui/chat_view/media_message/media_message_arg.dart';

class ChatController extends AppBaseController {
  final TextEditingController textCtrl = TextEditingController();
  final FocusNode textNode = FocusNode();
  UserModel? sender, receiver;
  ChatRoomModel? chatRoom;
  ScrollController scrollController = ScrollController();
  bool _scrolling = false, _searching = false, _isSearch = false;
  int limit = 20, a = 20;
  Timer? _timer;
  List<AttachmentItem> attachmentsOption = [];

  @override
  void onInit() {
    attachmentsOption.add(
      AttachmentItem(
        icon: const Icon(
          Icons.image,
          color: Colors.purple,
        ),
        title: 'Image',
        onTap: () => imagePicker(),
      ),
    );
    final arg = Get.arguments;
    sender = arg['sender'];
    receiver = arg['receiver'];
    chatRoom = arg['chatRoom'];
    _updateMessageCount();
    super.onInit();
  }

  void _updateMessageCount() {
    ChatService.instance.updateUnreadCount(
      userId: sender?.id ?? '',
      chatRoomId: chatRoom?.id ?? '',
      isAllRead: true,
    );
  }

  @override
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          //scrolling = false;
        } else {
          scrolling = true;
          limit = limit + a;
          update();
          /*if (scrolling) {
            if (_timer2?.isActive ?? false) _timer2.cancel();
            _timer2 = Timer(Duration(seconds: 5), () => scrolling = false);
          }*/
        }
      }
    });
    super.onReady();
  }

  Future<void> imagePicker() async {
    back();
    final image = await pickImage();
    if (image != null) {
      Get.toNamed(
        mediaMessageView,
        arguments: MediaMessageArg(
          from: 1,
          chatRoomId: chatRoom?.id ?? '',
          file: File(image.path),
          sender: sender,
          receiver: receiver,
        ),
      );
    }
  }

  void messageSend() async {
    if (textCtrl.text.trim().isNotEmpty) {
      final message = MessageModel(
        time: DateTime.now().millisecondsSinceEpoch,
        message: textCtrl.text.trim(),
        type: MessageType.text,
        senderId: sender?.id ?? '',
        receiverId: receiver?.id ?? '',
      );
      textCtrl.text = '';
      await ChatService.instance.sendMessage(
        chatRoomId: chatRoom?.id ?? '',
        message: message,
      );
      //scrollList();
    } else {
      showToast(msg: "Please Enter a message");
    }
  }

  void scrollList() {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      try {
        scrollController.jumpTo(0);
      } on Exception catch (_) {
        debugPrint("____ scrollList throwing new error");
        throw Exception("Error on server");
      }
    });
  }

  String getLastSeen(UserModel user) {
    return user.isOnline ?? false
        ? 'Online'
        : "Last seen ${formatDate(
            user.lastSeenTime ?? '',
            serverDate,
            ddMMMyyyyhhmma,
          )}";
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream() {
    return ChatService.instance.getChatMessages(
      chatRoomId: chatRoom?.id ?? '',
      limit: limit,
    );
  }

  Stream<DocumentSnapshot<Object?>> userStatusStream() {
    return ChatService.instance.getUserData(userId: receiver?.id ?? '');
  }

  void attachmentTap() {}

  get isSearch => _isSearch;

  set isSearch(value) {
    _isSearch = value;
    update();
  }

  get searching => _searching;

  set searching(value) {
    _searching = value;
    update();
  }

  bool get scrolling => _scrolling;

  set scrolling(bool value) {
    _scrolling = value;
    update();
  }
}

class AttachmentItem {
  Widget icon;
  String title;
  VoidCallback onTap;

  AttachmentItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
