import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_buddy/src/ui/chat_list/chat_list_view.dart';
import 'package:my_buddy/src/ui/chat_view/chat_view.dart';
import 'package:my_buddy/src/ui/chat_view/media_message/media_message_view.dart';
import 'package:my_buddy/src/ui/login/login_view.dart';
import 'package:my_buddy/src/ui/setup_profile/setup_profile_view.dart';
import 'package:my_buddy/src/ui/splash/splash_view.dart';
import 'package:my_buddy/src/ui/users_list/user_list_view.dart';
import 'package:my_buddy/src/ui/verify/verify_view.dart';

///Routes Name
///Add new screen here with there path neme
const String splashView = "/splash";
const String loginView = "/login";
const String verifyView = "/verify";
const String setupProfile = "/setupProfile";
const String chatListView = "/chatList";
const String userListView = "/userList";
const String chatView = "/chat";
const String mediaMessageView = "/mediaMessage";

class AppPages {
  static const initial = splashView;

  static List<GetPage> routes = [
    GetPage(
      name: splashView,
      page: () => const SplashView(),
    ),
    GetPage(
      name: loginView,
      page: () => const LoginView(),
    ),
    GetPage(
      name: verifyView,
      page: () => const VerifyView(),
    ),
    GetPage(
      name: setupProfile,
      page: () => const SetupProfileView(),
    ),
    GetPage(
      name: chatListView,
      page: () => const ChatListView(),
    ),
    GetPage(
      name: userListView,
      page: () => const UserListView(),
    ),
    GetPage(
      name: chatView,
      page: () => const ChatView(),
    ),
    GetPage(
      name: mediaMessageView,
      page: () => const MediaMessageView(),
    ),
  ];
}
