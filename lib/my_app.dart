import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_buddy/app_consts/app_colors.dart';
import 'package:my_buddy/app_consts/constants.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/service/chat_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:my_buddy/utills/shared_pre.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        updateUserStatus(status: true);
        break;
      case AppLifecycleState.inactive:
        updateUserStatus(status: false);
        break;
      case AppLifecycleState.paused:
        updateUserStatus(status: false);
        break;
      case AppLifecycleState.detached:
        updateUserStatus(status: false);
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPages.routes,
      initialRoute: AppPages.initial,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: Theme.of(context).copyWith(
        primaryColor: primaryColor,
        appBarTheme: Theme.of(context)
            .appBarTheme
            .copyWith(backgroundColor: primaryColor),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              secondary: primaryColor,
            ),
        radioTheme: Theme.of(context).radioTheme.copyWith(
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.purple),
            ),
      ),
    );
  }

  Future<void> updateUserStatus({required bool status}) async {
    final isLogin = SharedPre.instance.getBoolValue(SharedPre.isLogin);
    if (isLogin) {
      final user = await AppBaseController().getLoginUser();
      ChatService.instance.updateUserStatus(userId: user.id, status: status);
    }
  }
}
