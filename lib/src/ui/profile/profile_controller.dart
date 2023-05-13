import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:my_buddy/utills/shared_pre.dart';

class ProfileController extends AppBaseController {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final FocusNode nodeName = FocusNode();
  final FocusNode nodeEmail = FocusNode();
  final FocusNode nodeDob = FocusNode();
  final FocusNode nodePhone = FocusNode();
  String _selectedGender = 'Male';
  List<String> genders = ['Male', 'Female', 'Other'];
  UserModel? loginUser;
  bool _isProfileLoading = false;

  @override
  void onReady() {
    loginUser = getLoginUser();
    nameCtrl.text = loginUser?.name ?? '';
    emailCtrl.text = loginUser?.email ?? '';
    dobCtrl.text = loginUser?.dob ?? '';
    phoneCtrl.text = loginUser?.mobile ?? '';
    selectedGender = loginUser?.gender ?? 'Male';
    update();
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

  Future<void> onSubmitTap() async {
    if (_checkValidation()) {
      setBusy(true);
      loginUser?.mobile = phoneCtrl.text.trim();
      loginUser?.name = nameCtrl.text.trim();
      loginUser?.email = emailCtrl.text.trim();
      loginUser?.dob = dobCtrl.text.trim();
      loginUser?.gender = selectedGender;
      loginUser?.isOnline = true;
      await ChatService.instance.updateUserProfile(user: loginUser!);
      await SharedPre.instance
          .setValue(SharedPre.loginUser, loginUser?.toJson());
      setBusy(false);
      back();
    }
  }

  Future<void> updateProfile() async {
    final xFile = await pickImage();
    if (xFile != null) {
      final file = File(xFile.path);
      if (file.existsSync()) {
        isProfileLoading = true;
        final fileName =
            "${loginUser?.id}_profile.${file.path.split('.').last}";
        final url = await _uploadFile(file, fileName);
        loginUser?.profileUrl = url;
        isProfileLoading = false;
      }
    }
  }

  Future<String> _uploadFile(File file, String fileName) async {
    final pathReference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');
    await pathReference.delete().catchError((error) {
      debugPrint('____ delete file $error');
    });
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('profile_images/$fileName')
        .putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    debugPrint('____ _uploadFile $downloadUrl');
    return downloadUrl;
  }

  String get selectedGender => _selectedGender;

  set selectedGender(String value) {
    _selectedGender = value;
    update();
  }

  bool get isProfileLoading => _isProfileLoading;

  set isProfileLoading(bool value) {
    _isProfileLoading = value;
    update();
  }
}
