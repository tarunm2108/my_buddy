import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/src/ui/login/login_controller.dart';
import 'package:my_buddy/src/widgets/app_button.dart';
import 'package:my_buddy/src/widgets/text_field_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.all(21),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                20.toSpace(),
                Text(
                  'Log in',
                  style: const TextStyle().bold.copyWith(fontSize: 30),
                ),
                30.toSpace(),
                AppTextField(
                  ctrl: controller.phoneCtrl,
                  focusNode: controller.phoneNode,
                  hint: 'Enter phone number',
                ),
                30.toSpace(),
                AppTextButton(
                  text: 'Get OTP',
                  onPressed: () => controller.getOtpTap(),
                  showLoader: controller.isBusy,
                ),
              ],
            ),
          ),
        );
      },
      init: LoginController(),
    );
  }


}
