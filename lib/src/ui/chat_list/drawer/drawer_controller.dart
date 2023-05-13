import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/model/user_model.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerViewController extends AppBaseController {
  UserModel? loginUser;
  List<DrawerMenu> drawerMenuList = [];
  PackageInfo? appInfo;

  @override
  Future<void> onInit() async {
    appInfo = await getAppInfo();
    loginUser = getLoginUser();
    super.onInit();
  }

  @override
  void onReady() {
    drawerMenuList.addAll([
      DrawerMenu(
        title: 'Profile',
        onTap: () => Get.toNamed(profileView)
            ?.then((value) => loginUser = getLoginUser()),
        icon: const Icon(
          Icons.account_circle_rounded,
          color: Colors.black,
        ),
      ),
      DrawerMenu(
        title: 'Setting',
        onTap: () {},
        icon: const Icon(
          Icons.settings,
          color: Colors.black,
        ),
      ),
      DrawerMenu(
        title: 'Logout',
        onTap: () => showLogoutDialog(),
        icon: const Icon(
          Icons.logout,
          color: Colors.black,
        ),
      ),
      DrawerMenu(
        title: 'App Version',
        onTap: () {},
        trailing: appInfo?.version ?? '1.0.0',
        icon: const Icon(
          Icons.info_outline,
          color: Colors.black,
        ),
      ),
    ]);
    update();
    super.onReady();
  }
}

class DrawerMenu {
  String title;
  Widget icon;
  String? subtitle;
  String? trailing;
  VoidCallback onTap;

  DrawerMenu({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });
}
