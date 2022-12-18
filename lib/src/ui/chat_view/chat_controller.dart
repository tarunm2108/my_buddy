import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/src/base/base_controller.dart';

class ChatController extends AppBaseController {
  final TextEditingController textCtrl = TextEditingController();
  final FocusNode textNode = FocusNode();
  UserModel? sender, receiver;

  @override
  void onInit() {
    final arg = Get.arguments;
    sender = arg['sender'];
    receiver = arg['receiver'];
    super.onInit();
  }

  String getLastSeen(UserModel user) {
    return "Last seen ${formatDate(user.lastSeenTime ?? '', serverDate, ddMMMyyyyhhmma)}";
  }
}
