import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/src/base/base_controller.dart';

class VerifyController extends AppBaseController {
  final TextEditingController otpCtrl = TextEditingController();
  final FocusNode otpNode = FocusNode();

  void goSetupProfile() {
    final arg = Get.arguments;
    Get.offAndToNamed(setupProfile, arguments: arg);
  }
}
