import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:my_buddy/app_route/app_router.dart';
import 'package:my_buddy/service/firebase_service.dart';
import 'package:my_buddy/src/base/base_controller.dart';
import 'package:my_buddy/utills/shared_pre.dart';

class SplashController extends AppBaseController {

  @override
  Future<void> onReady() async {
    await Firebase.initializeApp();
    await FBNotification.instance.init();
    final isLogin = SharedPre.instance.getBoolValue(SharedPre.isLogin);
    if(isLogin){
      Get.offAllNamed(chatListView);
    }else {
      Get.offAllNamed(loginView);
    }
  }
}
