import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:my_buddy/utills/shared_pre.dart';

class SetupProfileController extends AppBaseController {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final FocusNode nodeName = FocusNode();
  final FocusNode nodeEmail = FocusNode();
  final FocusNode nodeDob = FocusNode();
  String _selectedGender = 'Male';
  List<String> genders = ['Male', 'Female', 'Other'];
  Map<String, dynamic> argument = {};
  UserModel? loginUser;

  @override
  void onReady() {
    argument = Get.arguments;
    update();
  }

  Future<void> onSubmitTap() async {
    nodeName.unfocus();
    nodeEmail.unfocus();
    nodeDob.unfocus();
    if (_checkValidation()) {
      setBusy(true);
        final loginUser = await ChatService.instance.createUser(
          user: UserModel(
            id: '',
            name: nameCtrl.text.trim(),
            mobile: argument['mobile'] ?? '',
            phoneCode: argument['phoneCode'] ?? '',
            dob: dobCtrl.text.trim(),
            gender: selectedGender,
            isOnline: true,
          ),
        );
        await SharedPre.instance
            .setValue(SharedPre.loginUser, loginUser.toJson());
        await SharedPre.instance.setValue(SharedPre.isLogin, true);
        setBusy(false);
        Get.offAllNamed(chatListView);
      }
  }

  bool _checkValidation() {
    if (nameCtrl.text.isEmpty) {
      showToast(msg: pleaseEnterYourName);
      return false;
    } else if (emailCtrl.text.isEmpty) {
      showToast(msg: pleaseEnterYourEmail);
      return false;
    } else if (!GetUtils.isEmail(emailCtrl.text.trim())) {
      showToast(msg: pleaseEnterValidEmail);
      return false;
    } else if (dobCtrl.text.isEmpty) {
      showToast(msg: pleaseSelectYourDob);
      return false;
    } else if (selectedGender.isEmpty) {
      showToast(msg: pleaseSelectYourGender);
      return false;
    } else {
      return true;
    }
  }

  void selectDob() {
    commonDatePicker(
      selectedDate: DateTime.now(),
      onDateSelection: (date) {
        dobCtrl.text = DateFormat('dd MMM, yyyy').format(date);
        update();
      },
      maxDate: DateTime.now(),
      minDate: DateTime(1970),
    );
  }

  String get selectedGender => _selectedGender;

  set selectedGender(String value) {
    _selectedGender = value;
    update();
  }
}
