import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/src/ui/setup_profile/setup_profile_controller.dart';
import 'package:my_buddy/src/widgets/app_button.dart';
import 'package:my_buddy/src/widgets/load_image_widget.dart';
import 'package:my_buddy/src/widgets/text_field_widget.dart';

class SetupProfileView extends StatelessWidget {
  const SetupProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Setup Profile',
              style: const TextStyle().bold.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                  ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.purple,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      children: [
                        Card(
                          shape: const CircleBorder(
                              side: BorderSide(
                            color: Colors.purple,
                          ),),
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: LoadImageWidget(
                            imagePath: AppAssets.defaultProfile,
                            imageType: ImageType.assets,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                30.toSpace(),
                AppTextField(
                  ctrl: controller.nameCtrl,
                  focusNode: controller.nodeName,
                  hint: name,
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  action: TextInputAction.next,
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.purple,
                    ),
                  ),
                ),
                20.toSpace(),
                AppTextField(
                  ctrl: controller.emailCtrl,
                  focusNode: controller.nodeEmail,
                  hint: email,
                  textInputType: TextInputType.emailAddress,
                  action: TextInputAction.next,
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.mail,
                      color: Colors.purple,
                    ),
                  ),
                ),
                20.toSpace(),
                AppTextField(
                  ctrl: controller.dobCtrl,
                  readOnly: true,
                  onTap: controller.selectDob,
                  focusNode: controller.nodeDob,
                  hint: dateOfBirth,
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.purple,
                    ),
                  ),
                ),
                20.toSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    controller.genders.length,
                    (index) => Expanded(
                      child: RadioListTile(
                        title: Text(
                          controller.genders[index],
                          style: const TextStyle().regular,
                        ),
                        contentPadding: EdgeInsets.zero,
                        value: controller.genders[index],
                        groupValue: controller.selectedGender,
                        onChanged: (value) =>
                            controller.selectedGender = value!,
                      ),
                    ),
                  ),
                ),
                20.toSpace(),
                AppTextButton(
                  text: submit.toUpperCase(),
                  onPressed: () => controller.onSubmitTap(),
                  showLoader: controller.isBusy,
                ),
              ],
            ),
          ),
        );
      },
      init: SetupProfileController(),
    );
  }
}
