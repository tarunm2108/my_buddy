import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:my_buddy/utills/shared_pre.dart';

class LoginController extends AppBaseController {
  final TextEditingController phoneCtrl = TextEditingController();
  final FocusNode phoneNode = FocusNode();
  String phoneCode = '91';

  Future<void> getOtpTap() async {
    setBusy(true);
    phoneNode.unfocus();
    if (phoneCtrl.text.trim().isNotEmpty) {
      final user = await ChatService.instance.checkUserExist(
        mobile: phoneCtrl.text.trim(),
        phoneCode: phoneCode,
      );
      if (user != null) {
        await SharedPre.setObj(SharedPre.loginUser, user.toJson());
        await SharedPre.setBool(SharedPre.isLogin, true);
        setBusy(false);
        Get.offAllNamed(chatListView);
      } else {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+$phoneCode${phoneCtrl.text.trim()}',
          timeout: const Duration(seconds: 120),
          verificationCompleted: (PhoneAuthCredential credential) {
            debugPrint('_____ verificationCompleted');
            setBusy(false);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              debugPrint('_____ verificationFailed');
              showToast(msg: 'Please enter valid mobile number.');
            }
            setBusy(false);
          },
          codeSent: (String verificationId, int? resendToken) {
            showToast(msg: 'OTP has send on +91${phoneCtrl.text.trim()}');
            setBusy(false);
            goOtpView();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            debugPrint('_____ Verification time out');
            setBusy(false);
          },
        );
      }
    } else {
      showToast(msg: 'Please enter a mobile number');
      setBusy(false);
    }
  }

  void goOtpView() {
    Get.toNamed(verifyView, arguments: {
      'mobile': phoneCtrl.text.trim(),
      'phoneCode': phoneCode,
    });
  }
}
