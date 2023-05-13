import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_consts/app_assets.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_consts/extension/space.dart';
import 'package:my_buddy/app_consts/extension/text_style_extension.dart';
import 'package:my_buddy/src/ui/profile/profile_controller.dart';
import 'package:my_buddy/src/widgets/app_button.dart';
import 'package:my_buddy/src/widgets/load_image_widget.dart';
import 'package:my_buddy/src/widgets/loader_widget.dart';
import 'package:my_buddy/src/widgets/text_field_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Profile',
              style: const TextStyle().bold.copyWith(
                    color: Colors.black,
                    fontSize: 21,
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
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          child: LoadImageWidget(
                            imagePath: controller.loginUser?.profileUrl ?? '',
                            imageType: ImageType.network,
                            errorWidget: Image.asset(AppAssets.defaultProfile),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Center(
                            child: TextButton(
                              onPressed: () => controller.updateProfile(),
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
                        Visibility(
                          visible: controller.isProfileLoading,
                          child: const LoaderWidget(),
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
                  ctrl: controller.phoneCtrl,
                  focusNode: controller.nodePhone,
                  hint: mobileNumber,
                  textInputType: TextInputType.number,
                  inputFormatter: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  action: TextInputAction.next,
                  prefix: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.phone,
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
      init: ProfileController(),
    );
  }
}
