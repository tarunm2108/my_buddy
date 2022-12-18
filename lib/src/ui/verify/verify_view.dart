import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/src/ui/verify/verify_controller.dart';
import 'package:my_buddy/src/widgets/app_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyView extends StatelessWidget {

  const VerifyView({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: GetBuilder<VerifyController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter OTP',
                  style: const TextStyle().bold,
                ),
                20.toSpace(),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: controller.otpCtrl,
                  focusNode: controller.otpNode,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  hintCharacter: '-',
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldWidth: 40,
                    fieldHeight: 40,
                    activeFillColor: Colors.black12,
                    selectedFillColor: Colors.black12,
                    inactiveFillColor: Colors.black12,
                    activeColor: Colors.black12,
                    selectedColor: Colors.black12,
                    inactiveColor: Colors.black12,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle().regular,
                  onCompleted: (v) => controller.goSetupProfile(),
                  onChanged: (value) {},
                  beforeTextPaste: (text) => true,
                ),
                AppTextButton(
                  text: 'Login',
                  onPressed: () => controller.goSetupProfile(),
                ),
              ],
            ),
          );
        },
        init: VerifyController(),
      ),
    );
  }


}
